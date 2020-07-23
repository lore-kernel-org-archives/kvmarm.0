Return-Path: <SRS0=bqG1=BC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC83C4345B
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 00:59:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDD0020825
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 00:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=Assurantconnects.onmicrosoft.com header.i=@Assurantconnects.onmicrosoft.com header.b="IfyDtywn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDD0020825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=assurant.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C1B4B2F8;
	Wed, 22 Jul 2020 20:59:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@assurantconnects.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2o3UrbU5g+7w; Wed, 22 Jul 2020 20:59:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C48974B2D6;
	Wed, 22 Jul 2020 20:59:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83DA64B2A8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 20:59:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G87uJFOKZQ4j for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 20:59:17 -0400 (EDT)
Received: from atl0lppp003.etdbw.com (atl0lppp003.etdbw.com [167.79.177.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F15494B29B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 20:59:16 -0400 (EDT)
Received: from pps.filterd (atl0lppp003.etdbw.com [127.0.0.1])
 by atl0lppp003.etdbw.com (8.16.0.42/8.16.0.42) with SMTP id 06N0pE0m073103;
 Wed, 22 Jul 2020 20:59:26 -0400
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
 by atl0lppp003.etdbw.com with ESMTP id 32e9cq74k7-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 22 Jul 2020 20:59:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ho6W4QJbNoO4ry9E3nq8RkSzebmzPTbk+Du+sFM9jxeS19XHWD0AXA7Muj4FjWz722ycTPW8hztVVA++FAhTwpWKNxMfWEwbCpMMV1VPrHdhncJx2imvFjwzMJ+vxeOGiCrR51eRRTZSb04RhR/XRRYI0KIXenJJJxPmanSQj+2C3ezL7bf+EFJZceHvSZKEDRK39kykKKpn1i0hHIQ0poRWOfACUpbnm0Zgz3ruQ7k0oI0567/GXxAT6G3jsX3Q1BtxjZibLWHAT4UXq0gx6vF+S335hbGl7pwAENE/O8GnH+D9IHZp8S/QOl7uAGa/h96w2qmtL3IF2VOEIUcNWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqHtttJgH/uYB2EykF1CbcxEPaens5PpZdUTYO9rLcI=;
 b=euv1eRpu39xiZBxKvtpOftveJZEDf9y2iHsvQuwbdfZBcSPDnAJjulO7bD9S8g4n2c3WRKHjT1QMxBpKqOLpNjOSPJD8arqz50vHuiO+Eaqm6SXHQkBQOYItkvY+e58ZD8tYDyhPhhcRKcugez9XyPDC/A8JzZgTXWBnDKJlqD0OGa4b4vc7fm8IxBc21l6ydsBglo63TR3ZRzM+lCHfj6bp6t/QsVD+Cn4r5u3/2tOzqS1nK4V0fifVhSuq9hNGsVE+4DV6zaz/OD8FMwUazocK4EU0WHyxpJjg5ZEiMynLZNOviB5wVpW6EmrNb1D3/y1gjZkoDmWEhgG9ZOcw1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=assurant.com; dmarc=pass action=none header.from=assurant.com;
 dkim=pass header.d=assurant.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Assurantconnects.onmicrosoft.com;
 s=selector2-Assurantconnects-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqHtttJgH/uYB2EykF1CbcxEPaens5PpZdUTYO9rLcI=;
 b=IfyDtywnaQ7p1C6+YMLeL2nwooOqjZ6rLDyYt7h26Rsi7ReaDiXGWydhmKqVp2znunrOajro6nCRZwsd2sqR6p4x9th2zScqNeKq8YoT+hd0/zvyNwxLpXfvBo7tCBrSRJrYwopIcvNu9AG/GzDD0RwpBYCkv7ttr7aFkqaGqBk=
Received: from BN8PR03MB5028.namprd03.prod.outlook.com (2603:10b6:408:de::22)
 by BN3PR03MB2289.namprd03.prod.outlook.com (2a01:111:e400:7bba::26)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Thu, 23 Jul
 2020 00:59:11 +0000
Received: from BN8PR03MB5028.namprd03.prod.outlook.com
 ([fe80::ed67:c8b9:f2b3:c857]) by BN8PR03MB5028.namprd03.prod.outlook.com
 ([fe80::ed67:c8b9:f2b3:c857%4]) with mapi id 15.20.3216.020; Thu, 23 Jul 2020
 00:59:11 +0000
From: Renters Cancellation Requests <renterscancel@assurant.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Scull <ascull@google.com>
Subject: FW: Re: [PATCH 07/37] KVM: arm64: Separate SError detection from
 VAXorcism
Thread-Topic: Re: [PATCH 07/37] KVM: arm64: Separate SError detection from
 VAXorcism
Thread-Index: AQHWWtgWYxTser9P5Uyg1GzC81T3pakNDhUAgAN8NICAAAwGgNZgjHjR
Date: Thu, 23 Jul 2020 00:59:11 +0000
Message-ID: <0EB64B4CBD1D4CC88F746A99A8935F701D6608C78D1C@RENTERSCANCEL.ASSURANT.COM>
In-Reply-To: <500058465906ab72122127cf745568c6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: assurant.com; dkim=none (message not signed)
 header.d=none;assurant.com; dmarc=none action=none header.from=assurant.com;
x-originating-ip: [40.90.252.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a4c7df1-0ce6-486e-cf36-08d82ea39cd3
x-ms-traffictypediagnostic: BN3PR03MB2289:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN3PR03MB2289D4D22A593DEA01C19B3AC7760@BN3PR03MB2289.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T5tntaCuvzOKVpgVP3+CfzaVzUvOQVE4prkVZOiXhTd1hKQpQUvfvy/bTNS4fiNtykPvDN0+bxIXTw76c7Pd9dupuj6KqW2FwJRRU5Q0eC7JXZJpRpZwvAcaS7uzLKr1IAIL8OTBOXGHnbSQfZX/rkzTMCoqVpeyqtqtfa0voR+udbibdpVKS/v6K+AusIosJQFb3TRNKgcVgyXqkgn+oldcv8XW6eM7c8jFscNj7knkOKpqaRSkZNZJ3SK7PCI7LgmzreG4lrRuJpQse5WrLApEmNuKvlvCFMuvScwcHgIhKO2a9eUUDH7cAEGcbUCirhSR7W4NHb2QD0vgcne0oTqhRdu8v9wBVHDOmjzposVJWAAgll6eFTolHyc9NvJ1YJSzsK9noTMAxahb76vNOw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BN8PR03MB5028.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFTY:;
 SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(4326008)(478600001)(6512007)(166002)(33656002)(83380400001)(5660300002)(966005)(37786003)(4000750100001)(71200400001)(76116006)(8936002)(66946007)(66446008)(66556008)(66476007)(55846006)(64756008)(26005)(186003)(54906003)(86362001)(91956017)(316002)(6506007)(53546011)(8676002)(2906002)(110136005)(6486002);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata: fRjxTI/ZCzmBBXxenj67xlaHE3dJewkM/YmsqystTx5bmm8lji5GAgGsQ50ISHhq5Cb1itCo/cDSuMy6CWkF8T+PR8bOZwVgHPomj8/8ecgqzNtUvkJB3O6DYbJdKHgaUxJ0Eo60AzQ6+ajZFgatWsnG30atQ1T79EECUhFmom2qDs6TjpVd14hpEz/n5p8SAD5kTz7/qDfB9rtVH5iU7Cr96soYxxCEAYjTQUoYsg1xsKdbygTxN1YStrWt1CXbhKhFNz+PJ4DWUErb8pwUPCJIJJGcwB9KkIHUFwGCsMyY8iesJH3IIcyL3V5A/9qDKVC2lFa2Di4qPY52WSEI5ePBdQuq/EY3CV7QfueOF3D38IWc3Sj/v/VpORUMkIJS6xUchYTtZZ8ql/bNIDwGDXNPGtOI8HBlaQZJ/DRM2ahY5Zg161D4c+n0jv3lzzHyk8+gld2AZBGYJMrVSXjftyUbwTqy2PZBQ46h82ObwEBdUeqPDBAsseME1suuPcEW
MIME-Version: 1.0
X-OriginatorOrg: assurant.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR03MB5028.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4c7df1-0ce6-486e-cf36-08d82ea39cd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 00:59:11.6767 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 354f10a5-0782-4663-8897-8b60747eb8bc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PKhLwSVRb8G72sv+uojgIlpDAhjwO4w0DfovbM3LLUQiYLQU6E51m+CaXQI/27t7KbVLa3xn3HqhCOCBXUEesYSQDP87O7SLqBJskGQlunk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2289
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007230002
Cc: "kernel-team@android.com" <kernel-team@android.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4156546786731818317=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4156546786731818317==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_0EB64B4CBD1D4CC88F746A99A8935F701D6608C78D1CRENTERSCANC_"

--_000_0EB64B4CBD1D4CC88F746A99A8935F701D6608C78D1CRENTERSCANC_
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="Windows-1252"

Dear Valued Customer,


Thank you for your inquiry. Please let us know how we may assist you.


If you have a Renter=92s policy, you can manage your policy online 24/7 at:=
 https://www.myassurantpolicy.com/

You have access to a range of service options including:

  *
View/update policy information
  *
Manage your payments
  *
Obtain proof of insurance
  *
And much more



Thank you for allowing us the opportunity to serve you.


Sincerely,

Insurance Services

Assurant - Global Specialty Operations




------------------- Original Message -------------------
From: Marc Zyngier
Received: Mon Jul 20 2020 10:57:01 GMT-0400 (Eastern Daylight Time)
To: Andrew Scull
Cc: kernel-team@android.com; kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 07/37] KVM: arm64: Separate SError detection from VAXor=
cism

On 2020-07-20 15:13, Andrew Scull wrote:
> On Sat, Jul 18, 2020 at 10:00:30AM +0100, Marc Zyngier wrote:
>> Hi Andrew,
>>
>> On Wed, 15 Jul 2020 19:44:08 +0100,
>> Andrew Scull <ascull@google.com> wrote:
>> >
>> > When exiting a guest, just check whether there is an SError pending and
>> > set the bit in the exit code. The fixup then initiates the ceremony
>> > should it be required.
>> >
>> > The separation allows for easier choices to be made as to whether the
>> > demonic consultation should proceed.
>>
>> Such as?
>
> It's used in the next patch to keep host SErrors pending and left for
> the host to handle when reentering the host vcpu. IIUC, this matches
> the
> previous behaviour since hyp would mask SErrors.
>
> We wanted to avoid the need to convert host SErrors into virtual ones
> and I opted for this approach to keep as much of the logic/policy as
> possible in C.

Right. That's the kind of information you should put in your commit
message, as it makes your intent much clearer.

Thanks,

         M.
--
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

**********************************************************************
This e-mail message and all attachments transmitted with it may contain leg=
ally privileged and/or confidential information intended solely for the use=
 of the addressee(s). If the reader of this message is not the intended rec=
ipient, you are hereby notified that any reading, dissemination, distributi=
on, copying, forwarding or other use of this message or its attachments is =
strictly prohibited. If you have received this message in error, please not=
ify the sender immediately and delete this message and all copies and backu=
ps thereof. Thank you.

--_000_0EB64B4CBD1D4CC88F746A99A8935F701D6608C78D1CRENTERSCANC_
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="Windows-1252"

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DWindows-1=
252">
</head>
<body>
<span style=3D"font-size: 12px; font-family: Tahoma, Verdana, Arial;">
<table cellspacing=3D"2" cellpadding=3D"4" width=3D"100%" height=3D"100%">
<tbody>
<tr>
<td style=3D"background-color:#ffffff;font-family:verdana;font-size:10pt;">
<p>Dear Valued Customer,</p>
<p><br>
</p>
<p>Thank you for your inquiry. Please let us know how we may assist you. </=
p>
<p style=3D"margin:0in 0in 8pt;line-height:normal;"><font face=3D"Calibri">=
<b><span style=3D"color:black;font-size:12pt;"><br>
</span></b></font></p>
<p style=3D"margin:0in 0in 8pt;line-height:normal;"><font face=3D"Calibri">=
<b><span style=3D"color:black;font-size:12pt;">If you have a
</span></b><b><span style=3D"color:rgb(197, 90, 17);font-size:12pt;">Renter=
=92s</span></b><b><span style=3D"color:black;font-size:12pt;"> policy, you =
can manage your policy online 24/7 at:
</span></b></font><a href=3D"https://www.myassurantpolicy.com/"><span style=
=3D"font-size:12pt;"><u><font color=3D"#0563c1" face=3D"Calibri">https://ww=
w.myassurantpolicy.com/</font></u></span></a></p>
<font face=3D"Times New Roman" size=3D"3"></font>
<p style=3D"margin:0in 0in 8pt;line-height:normal;"><span style=3D"color:bl=
ack;font-size:12pt;"><font face=3D"Calibri">You have access to a range of s=
ervice options including:</font></span></p>
<font face=3D"Times New Roman"></font>
<ul class=3D"Articlesedit_article_div_secEdit RTE_list_style_position">
<li>
<div style=3D"color:rgb(0, 0, 0);line-height:normal;font-style:normal;font-=
weight:normal;margin-top:0in;margin-bottom:0pt;">
<span style=3D"color:black;">View/update policy information</span></div>
</li><li>
<div style=3D"color:rgb(0, 0, 0);line-height:normal;font-family:&quot;Calib=
ri&quot;,sans-serif;font-size:11pt;font-style:normal;font-weight:normal;mar=
gin-top:0in;margin-bottom:0pt;">
<span style=3D"color:black;font-size:12pt;">Manage your payments</span></di=
v>
</li><li>
<div style=3D"color:rgb(0, 0, 0);line-height:normal;font-family:&quot;Calib=
ri&quot;,sans-serif;font-size:11pt;font-style:normal;font-weight:normal;mar=
gin-top:0in;margin-bottom:0pt;">
<span style=3D"color:black;font-size:12pt;">Obtain proof of insurance</span=
></div>
</li><li>
<div style=3D"color:rgb(0, 0, 0);line-height:normal;font-family:&quot;Calib=
ri&quot;,sans-serif;font-size:11pt;font-style:normal;font-weight:normal;mar=
gin-top:0in;margin-bottom:8pt;">
<span style=3D"color:black;font-size:12pt;">And much more</span></div>
<br>
</li></ul>
<p><br>
</p>
<p>Thank you for allowing us the opportunity to serve you.</p>
<p><br>
</p>
<p>Sincerely,</p>
<p>Insurance Services</p>
<p>Assurant - Global Specialty Operations&nbsp; </p>
</td>
</tr>
<tr height=3D"100%">
<td><br>
</td>
</tr>
</tbody>
</table>
</span><br>
<div id=3D"signature" style=3D"font-size: 12px; font-family: Tahoma, Verdan=
a, Arial;">
</div>
<br>
<font face=3D"Tahoma, Verdana, Arial" size=3D"2"><br>
------------------- Original Message -------------------<br>
<b>From:</b> Marc Zyngier<br>
<b>Received:</b> Mon Jul 20 2020 10:57:01 GMT-0400 (Eastern Daylight Time)<=
br>
<b>To:</b> Andrew Scull<br>
<b>Cc:</b> kernel-team@android.com; kvmarm@lists.cs.columbia.edu<br>
<b>Subject:</b> Re: [PATCH 07/37] KVM: arm64: Separate SError detection fro=
m VAXorcism</font><br>
<br>
<style>
.EmailQuote {
margin-left:1pt;
padding-left:4pt;
border-left:#800000 2px solid;
}
</style><font size=3D"2"><span style=3D"font-size:11pt;">
<div class=3D"PlainText">On 2020-07-20 15:13, Andrew Scull wrote:<br>
&gt; On Sat, Jul 18, 2020 at 10:00:30AM +0100, Marc Zyngier wrote:<br>
&gt;&gt; Hi Andrew,<br>
&gt;&gt; <br>
&gt;&gt; On Wed, 15 Jul 2020 19:44:08 +0100,<br>
&gt;&gt; Andrew Scull &lt;ascull@google.com&gt; wrote:<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; When exiting a guest, just check whether there is an SError p=
ending and<br>
&gt;&gt; &gt; set the bit in the exit code. The fixup then initiates the ce=
remony<br>
&gt;&gt; &gt; should it be required.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; The separation allows for easier choices to be made as to whe=
ther the<br>
&gt;&gt; &gt; demonic consultation should proceed.<br>
&gt;&gt; <br>
&gt;&gt; Such as?<br>
&gt; <br>
&gt; It's used in the next patch to keep host SErrors pending and left for<=
br>
&gt; the host to handle when reentering the host vcpu. IIUC, this matches <=
br>
&gt; the<br>
&gt; previous behaviour since hyp would mask SErrors.<br>
&gt; <br>
&gt; We wanted to avoid the need to convert host SErrors into virtual ones<=
br>
&gt; and I opted for this approach to keep as much of the logic/policy as<b=
r>
&gt; possible in C.<br>
<br>
Right. That's the kind of information you should put in your commit<br>
message, as it makes your intent much clearer.<br>
<br>
Thanks,<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; M.<br>
-- <br>
Jazz is not dead. It just smells funny...<br>
_______________________________________________<br>
kvmarm mailing list<br>
kvmarm@lists.cs.columbia.edu<br>
<a href=3D"https://lists.cs.columbia.edu/mailman/listinfo/kvmarm">https://l=
ists.cs.columbia.edu/mailman/listinfo/kvmarm</a><br>
</div>
</span></font>

<HR>This e-mail message and all attachments transmitted with it may contain=
 legally privileged and/or confidential information intended solely for the=
 use of the addressee(s). If the reader of this message is not the intended=
 recipient, you are hereby notified that any reading, dissemination, distri=
bution, copying, forwarding or other use of this message or its attachments=
 is strictly prohibited. If you have received this message in error, please=
 notify the sender immediately and delete this message and all copies and b=
ackups thereof. Thank you.<BR>
</body>
</html>

--_000_0EB64B4CBD1D4CC88F746A99A8935F701D6608C78D1CRENTERSCANC_--

--===============4156546786731818317==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4156546786731818317==--
