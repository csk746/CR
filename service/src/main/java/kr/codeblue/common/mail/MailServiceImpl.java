package kr.codeblue.common.mail;

import kr.codeblue.common.util.HttpClientUtil;
import org.apache.commons.httpclient.NameValuePair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Service
public class MailServiceImpl implements MailService {

	@Autowired
	private JavaMailSender javaMailSender;
	
	public void setJavaMailSender(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }
	
	@Autowired
	private MessageSource messageSource;
	
	@Override
	public void sendMail(Mail mail) {
		MimeMessage message = javaMailSender.createMimeMessage();

        try {
            MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
            messageHelper.setSubject(mail.getSubject());
            messageHelper.setTo(mail.getTo());
            messageHelper.setFrom(mail.getFrom());
            
            if( StringUtils.isEmpty(mail.getHtmlUrl()) ){
            	messageHelper.setText(mail.getMessage(), true);
            } else {
            	
            	List<NameValuePair> params = new ArrayList<NameValuePair>();
        		Iterator<String> itr = mail.getReplaceContents().keySet().iterator();
        		while(itr.hasNext()){
        			String key = itr.next();
        			String value = mail.getReplaceContents().get(key);
        			if( value == null ){
        				value = "";
        			}
        			params.add(new NameValuePair(key, value));
        			System.out.println("--------[ Mail Param ] " + key + " : " + value);
        		}
        		
        		String contents = HttpClientUtil.urlToString(mail.getHtmlUrl(), params);
            	messageHelper.setText(contents, true);
            }
            
            javaMailSender.send(message);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
		
	}

}
