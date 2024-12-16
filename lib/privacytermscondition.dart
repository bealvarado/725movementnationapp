import 'package:flutter/material.dart';

class PrivacyTermsAndConditions extends StatelessWidget {
  final double fontSize;
  final double paragraphSpacing;

  PrivacyTermsAndConditions({this.fontSize = 16.0, this.paragraphSpacing = 8.0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(
          'Terms and Conditions',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Terms and Condition'),
              buildSectionContent(
                "Welcome to Inspire movement.\n\n"
                "By accessing or using our Sites and/or Services, you agree to be legally bound by the following terms and conditions operated by Inspire movement (\"us\", \"we\", or \"our\").\n\n"
                "Please read these Terms of Use carefully. If you do not agree with any part of these Terms of Use you should refrain from using the Sites and/or Services. We may change, modify, add or delete portions of the Terms of Use from time to time at our sole discretion and your continued use of the Sites and/or Services constitutes your acceptance of those changes.\n"
                "It is your responsibility to regularly check and/or review these Terms of Use and to decide whether you agree to abide by them and be bound by them. If you do not agree to be bound by or abide by these or any future Terms of Use, please do not use or access (or continue to use or access) the Sites and/or Services.\n\n"
                "Inspire movement reserves the right to elect not to provide the Services to you, process any order you place or allow you access to the Sites.\n\n"
                "Nothing contained in this Website should be construed as any form of such medical advice or diagnosis. By using the Website you represent that you understand that physical exercise involves strenuous physical movement and that such activity carries the risk of injury whether physical or mental. You understand that it is your responsibility to judge your physical and mental capabilities for such activities. It is your responsibility to ensure that by participating in classes and activities from Inspire movement, you will not exceed your limits while performing such activity, and you will select the appropriate level of classes for your skills and abilities, as well as for any mental or physical conditions and/or limitations you have. You expressly waive and release any claim that you may have at any time for injury of any kind against Inspire movement, including without limitation its directors.\n\n"
                "By participating in a zoom live class, you agree and acknowledge the following terms and conditions:\n"
                "1. Online dance classes can involve the risk of personal injury, and that risk is accentuated by participation outside the controlled environment of our own studios. While Inspire movement takes all reasonable care in the conduct of its classes, it accepts no responsibility for injury or loss caused during the classes or whilst participants are participating in an online class session;\n"
                "2. You or your legal guardian are responsible for ensuring that you are physically and medically fit for the class;\n\n"
                "Proprietary Rights\n\n"
                "All materials on the Website, including, without limitation, names, logos, trademarks, images, text, columns, graphics, videos, photographs, illustrations, artwork, software, and other elements (collectively, “Material”) are protected by copyrights, trademarks and/or other intellectual property rights owned and controlled by Inspire movement or by third parties that have licensed or otherwise provided their material to Inspire movement. You acknowledge and agree that all Materials on the Website are made available for limited, non-commercial, personal use only. Except as specifically provided herein or elsewhere on this Website, no Material may be copied, reproduced, republished, sold, downloaded, posted, transmitted, or distributed in any way, or otherwise used for any purpose, by any person or entity, without Inspire movements prior express written permission. You may not add, delete, distort, or otherwise modify the Material. Any unauthorized attempt to modify any Material, to defeat or circumvent any security features, or to utilize the Website or any part of the Material for any purpose other than its intended purposes is strictly prohibited.\n\n"
                "Nothing displayed on the Sites and/or Services should be construed as granting any right of use in relation to any intellectual property displayed on the Sites and/or Services without the express written consent of SDC\n\n"
                "License to Your Content\n\n"
                "By posting, displaying, publishing, transmitting, or otherwise making available (individually and collectively, “Posting”) any Content on or through the Website or the Service, you hereby grant to Inspire movement a non-exclusive, fully-paid, royalty-free, perpetual, irrevocable, worldwide license (with the right to sublicense through unlimited levels of sublicensees) to use, copy, modify, adapt, translate, create derivative works, publish, publicly perform, publicly display, store, reproduce, transmit, distribute, and otherwise make available such Content on and through the Website, in print, or in any other format or media now known or hereafter invented, without prior notification, compensation, or attribution to you, and without your consent. If you wish to remove any Content from the Service, your ability to do so may depend on the type of Content, the location and manner of Posting, and other factors. You may contact us to request the removal of certain Content you have Posted, but Inspire movement has no obligation to remove any such Content, may choose whether or not to do so in its sole discretion, and makes no guarantee as to the complete deletion of any such Content and copies thereof. Notwithstanding the foregoing, a backup or residual copy of any Content posted by you may remain on Inspire movement’s servers after the Content appears to have been removed from the Website, and Inspire movement retains the rights to all such remaining copies. You represent and warrant that: (a) you own all right, title and interest in all Content posted by you on or through the Website or the Service, or otherwise have the right to grant the license set forth in this section, and (b) the Posting of your Content on or through the Website or Service does not violate the privacy rights, publicity rights, copyrights, publishing, trademarks, patents, trade secrets, contract rights, confidentiality, or any other rights of any third party.\n\n"
                "Limitation on Liability"
                "We do not guarantee, represent or warrant that your use of our service will be uninterrupted, timely, secure or error-free. \nWe do not warrant that the results that may be obtained from the use of the service will be accurate or reliable.\nYou agree that from time to time we may remove the service for indefinite periods of time or cancel the service at any time, without notice to you.\nYou expressly agree that your use of, or inability to use, the service is at your sole risk. The service and all products and services delivered to you through the service are (except as expressly stated by us) provided 'as is' and 'as available for your use, without any representation, warranties or conditions of any kind, either express or implied, including all implied warranties or conditions of merchantability, merchantable quality, fitness for a particular purpose, durability, title, and non-infringement.\n\n"
                "IN NO EVENT SHALL INSPIRE MOVEMENT, ITS OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS, BE LIABLE TO YOU FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES WHATSOEVER RESULTING FROM ANY (I) ERRORS, MISTAKES, OR INACCURACIES OF CONTENT, (II) PERSONAL INJURY OR PROPERTY DAMAGE, OF ANY NATURE WHATSOEVER, RESULTING FROM YOUR ACCESS TO AND USE OF THE WEBSITE, (III) ANY UNAUTHORIZED ACCESS TO OR USE OF Movement online SECURE SERVERS AND/OR ANY AND ALL PERSONAL INFORMATION AND/OR FINANCIAL INFORMATION STORED THEREIN, (IV) ANY INTERRUPTION OR CESSATION OF TRANSMISSION TO OR FROM THE WEBSITE, (V) ANY BUGS, VIRUSES, TROJAN HORSES, OR THE LIKE, WHICH MAY BE TRANSMITTED TO OR THROUGH THE WEBSITE BY ANY THIRD PARTY, AND/OR (VI) ANY ERRORS OR OMISSIONS IN ANY CONTENT OR FOR ANY LOSS OR DAMAGE OF ANY KIND INCURRED AS A RESULT OF YOUR USE OF ANY CONTENT POSTED, EMAILED, TRANSMITTED, OR OTHERWISE MADE AVAILABLE VIA THE WEBSITE, WHETHER BASED ON WARRANTY, CONTRACT, TORT, OR ANY OTHER LEGAL THEORY, AND WHETHER OR NOT THE Movement online IS ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. THE FOREGOING LIMITATION OF LIABILITY SHALL APPLY TO THE FULLEST EXTENT PERMITTED BY LAW IN THE APPLICABLE JURISDICTION.  YOU SPECIFICALLY ACKNOWLEDGE THAT INSPIRE MOVEMENT SHALL NOT BE LIABLE FOR CONTENT POSTED BY USERS OR THE DEFAMATORY, OFFENSIVE, OR ILLEGAL CONDUCT OF ANY THIRD PARTY AND THAT THE RISK OF HARM OR DAMAGE FROM THE FOREGOING RESTS ENTIRELY WITH YOU.  ANY REFERENCE TO A PERSON, ENTITY, PRODUCT, OR SERVICE ON THIS WEBSITE DOES NOT CONSTITUTE AN ENDORSEMENT OR RECOMMENDATION BY INSPIRE MOVEMENT OR ANY OF ITS EMPLOYEES. Movement Online IS NOT RESPONSIBLE FOR ANY THIRD-PARTY CONTENT ON THE WEBSITE OR THIRD PARTY WEB PAGE ACCESSED FROM THIS WEBSITE, NOR DOES Movement Online WARRANT THE ACCURACY OF ANY INFORMATION CONTAINED IN A THIRD PARTY WEBSITE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.  NO COMMUNICATION OF ANY KIND BETWEEN YOU AND INSPIRE MOVEMENT OR A REPRESENTATIVE OF Movement online SHALL CONSTITUTE A WAIVER OF ANY LIMITATIONS OF LIABILITY HEREUNDER OR CREATE ANY ADDITIONAL WARRANTY NOT EXPRESSLY STATED IN THE TERMS OF USE.  INSPIRE MOVEMENT RESERVES THE RIGHT TO REMOVE ANY MATERIAL POSTED ON THE WEBSITE THAT IT DETERMINES IN ITS SOLE DISCRETION IS VIOLATIVE OF ANY LAW OR RIGHT OF ANY PERSON, INFRINGES THE RIGHTS OF ANY PERSON, OR IS OTHERWISE INAPPROPRIATE FOR POSTING ON THE WEBSITE.\nYou agree to defend, indemnify and hold harmless Inspire movement its subsidiaries, affiliates, subcontractors, officers, directors, employees, consultants, representatives, and agents, from and against any and all claims, damages, obligations, losses, liabilities, costs or debt, and expenses (including but not limited to attorneys’ fees and costs) arising from (i) your use of and access to the Website; (ii) your violation of any term of this Agreement; (iii) your violation of any third party right, including without limitation any copyright, property, or privacy right; or (iv) any claim that one of your submissions of Content caused damage to a third party. This defense and indemnification obligation will survive this Agreement and your use of the Website.\nYou affirm that you are at least eighteen (18) years of age, and are fully able and competent to enter into this Agreement, conditions, obligations, affirmations, representations, and warranties set forth in this Agreement, and to abide by and comply with this Agreement.\nInspire movement reserves the right to amend this Agreement at any time and without notice, and it is your responsibility to review this Agreement for any changes. Your use of the Website following any amendment of this Agreement will signify your assent to and acceptance of its revised terms.\n\n"
                "THIRD-PARTY LINKS\n\n"
                "Certain content, products, and services available via our Service may include materials from third-parties.\nThird-party links on this site may direct you to third-party websites that are not affiliated with us. We are not responsible for examining or evaluating the content or accuracy and we do not warrant and will not have any liability or responsibility for any third-party materials or websites, or for any other materials, products, or services of third-parties.\nWe are not liable for any harm or damages related to the purchase or use of goods, services, resources, content, or any other transactions made in connection with any third-party websites. Please review carefully the third-party's policies and practices and make sure you understand them before you engage in any transaction. Complaints, claims, concerns, or questions regarding third-party products should be directed to the third-party.\n\n"
              ),
              buildSectionTitle('Privacy'),
              buildSectionContent(
                "This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.\n"
                "We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. \n"
                "Interpretation and Definitions"
                "Interpretation"
                "The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.\n"
                "Definitions"
                "For the purposes of this Privacy Policy:"
                "- Account means a unique account created for You to access our Service or parts of our Service.\n"
                "- Company (referred to as either 'the Company', 'We', 'Us' or 'Our' in this Agreement) refers to Inspire movement.\n"
                "- Cookies are small files that are placed on Your computer, mobile device or any other device by a website, containing the details of Your browsing history on that website among its many uses.\n"
                "- Country refers to: New South Wales, Australia\n"
                "- Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.\n"
                "- Personal Data is any information that relates to an identified or identifiable individual.\n"
                "- Service refers to the Website.\n"
                "- Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.\n"
                "- Third-party Social Media Service refers to any website or any social network website through which a User can log in or create an account to use the Service.\n"
                "- Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).\n"
                "- Website refers to Inspire movement, accessible from https://www.movementnation.com.au/\n"
                "- You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.\n\n"
                "Collecting and Using Your Personal Data\n"
                "Types of Data Collected\n"
                "Personal Data\n"
                "While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:\n"
                "- Email address\n"
                "- First name and last name\n"
                "- Phone number\n"
                "- Address, State, Province, ZIP/Postal code, City\n"
                "- Usage Data\n\n"
                "Usage Data\n"
                "Usage Data is collected automatically when using the Service.\n"
                "Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.\n"
                "When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.\n"
                "We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.\n\n"
                "Information from Third-Party Social Media \n"
                "Services\n"
                "The Company allows You to create an account and log in to use the Service through the following Third-party Social Media Services:\n"
                "- Google\n"
                "- Facebook\n"
                "- Apple\n"
                "If You decide to register through or otherwise grant us access to a Third-Party Social Media Service, We may collect Personal data that is already associated with Your Third-Party Social Media Service's account, such as Your name, Your email address, Your activities or Your contact list associated with that account.\n"
                "You may also have the option of sharing additional information with the Company through Your Third-Party Social Media Service's account. If You choose to provide such information and Personal Data, during registration or otherwise, You are giving the Company permission to use, share, and store it in a manner consistent with this Privacy Policy.\n"
                "Tracking Technologies and Cookies\n"
                "We use Cookies and similar tracking technologies to track the activity on Our Service and store certain information. Tracking technologies used are beacons, tags, and scripts to collect and track information and to improve and analyze Our Service. The technologies We use may include:\n"
                "- Cookies or Browser Cookies. A cookie is a small file placed on Your Device. You can instruct Your browser to refuse all Cookies or to indicate when a Cookie is being sent. However, if You do not accept Cookies, You may not be able to use some parts of our Service. Unless you have adjusted Your browser setting so that it will refuse Cookies, our Service may use Cookies.\n"
                "- Flash Cookies. Certain features of our Service may use local stored objects (or Flash Cookies) to collect and store information about Your preferences or Your activity on our Service. Flash Cookies are not managed by the same browser settings as those used for Browser Cookies. For more information on how You can delete Flash Cookies, please read 'Where can I change the settings for disabling, or deleting local shared objects?' available at https://helpx.adobe.com/flash-player/kb/disable-local-shared-objects-flash.html#main_Where_can_I_change_the_settings_for_disabling__or_deleting_local_shared_objects_\n"
                "- Web Beacons. Certain sections of our Service and our emails may contain small electronic files known as web beacons (also referred to as clear gifs, pixel tags, and single-pixel gifs) that permit the Company, for example, to count users who have visited those pages or opened an email and for other related website statistics (for example, recording the popularity of a certain section and verifying system and server integrity).\n"
                "Cookies can be 'Persistent' or 'Session' Cookies. Persistent Cookies remain on Your personal computer or mobile device when You go offline, while Session Cookies are deleted as soon as You close Your web browser. You can learn more about cookies here: All About Cookies by TermsFeed. We use both Session and Persistent Cookies for the purposes set out below:\n"
                "-Necessary / Essential Cookies\n"
                "- Type: Session Cookies\n"
                "- Administered by: Us\n"
                "- Purpose: These Cookies are essential to provide You with services available through the Website and to enable You to use some of its features. They help to authenticate users and prevent fraudulent use of user accounts. Without these Cookies, the services that You have asked for cannot be provided, and We only use these Cookies to provide You with those services.\n"
                "- Cookies Policy / Notice Acceptance Cookies\n"
                "- Type: Persistent Cookies\n"
                "- Administered by: Us\n"
                "- Purpose: These Cookies identify if users have accepted the use of cookies on the Website.\n"
                "- Functionality Cookies\n"
                "- Type: Persistent Cookies\n"
                "- Administered by: Us\n"
                "- Purpose: These Cookies allow us to remember choices You make when You use the Website, such as remembering your login details or language preference. The purpose of these Cookies is to provide You with a more personal experience and to avoid You having to re-enter your preferences every time You use the Website.\n"
                "For more information about the cookies we use and your choices regarding cookies, please visit our Cookies Policy or the Cookies section of our Privacy Policy.\n"
                "Use of Your Personal Data\n"
                "The Company may use Personal Data for the following purposes:\n"
                "To provide and maintain our Service, including to monitor the usage of our Service.\n"
                "To manage Your Account: to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user. For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service. To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation. To provide You with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information. To manage Your requests: To attend and manage Your requests to Us. For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred. For other purposes: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience. We may share Your personal information in the following situations: With Service Providers: We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You. For business transfers: We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company. With Affiliates: We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us. With business partners: We may share Your information with Our business partners to offer You certain products, services or promotions. With other users: when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside. If You interact with other users or register through a Third-Party Social Media Service, Your contacts on the Third-Party Social Media Service may see Your name, profile, pictures and description of Your activity. Similarly, other users will be able to view descriptions of Your activity, communicate with You and view Your profile. With Your consent: We may disclose Your personal information for any other purpose with Your consent. Retention of Your Personal Data The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies. The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods. Transfer of Your Personal Data Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction. Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer. The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information. Disclosure of Your Personal Data Business Transactions If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy. Law enforcement Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency). Other legal requirements The Company may disclose Your Personal Data in the good faith belief that such action is necessary to: Comply with a legal obligation Protect and defend the rights or property of the Company Prevent or investigate possible wrongdoing in connection with the Service Protect the personal safety of Users of the Service or the public Protect against legal liability Security of Your Personal Data The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security. Children's Privacy Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers. If We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent's consent before We collect and use that information. Links to Other Websites Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit. We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services. Changes to this Privacy Policy We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page. We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the Last updated date at the top of this Privacy Policy. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.\n"
                "Contact Us\n"
                "If you have any questions about this Privacy Policy, You can contact us\n"
                "By email: 2020movementnation@gmail.com\n"
                "2024"
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: paragraphSpacing, bottom: paragraphSpacing / 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize - 2, // Adjusted font size for title
          fontWeight: FontWeight.bold,
          color: Color(0xFF9CA3AF),
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

  Widget buildSectionContent(String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: paragraphSpacing),
      child: Text(
        content,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PrivacyTermsAndConditions(),
  ));
}
