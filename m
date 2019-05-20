Return-Path: <SRS0=onLC=TU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.8 required=3.0 tests=FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_IMAGE_ONLY_32,HTML_MESSAGE,INVALID_MSGID,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1ECC072B1
	for <kvmarm@archiver.kernel.org>; Mon, 20 May 2019 08:23:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FB3D2081C
	for <kvmarm@archiver.kernel.org>; Mon, 20 May 2019 08:23:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FB3D2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cloudminds.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C20004A50F;
	Mon, 20 May 2019 04:23:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id do8FhNfknI3F; Mon, 20 May 2019 04:22:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D6914A51D;
	Mon, 20 May 2019 04:22:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 904A44A49C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 May 2019 03:31:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id STVXTGUkVR6M for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 May 2019 03:31:43 -0400 (EDT)
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3D194A477
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 May 2019 03:31:42 -0400 (EDT)
X-QQ-mid: bizesmtp12t1558337493tgxz4cig
Received: from [10.11.32.138] (unknown [39.155.168.46])
 by esmtp6.qq.com (ESMTP) with 
 id ; Mon, 20 May 2019 15:31:32 +0800 (CST)
X-QQ-SSF: 00400000002000B0C414B00A0000000
X-QQ-FEAT: xeo957adDlYf7iMhHS9V/ysP9pI9/RMXs/q8XrXpbO5OgMKDnhpST3espKqzN
 rHUCljYgQZ/JtFmxppROG98X4DCtXMs1hWW9Ygnn/dRIPuxruyFbIQo5RQtiZ6QCaquCv64
 chaAJQzNGD+Lh8U9h1M3LGs6UzqireZ/VIKf+itZVjsR0tpcaoxFK+AR1od3uJnl/6ibnT9
 y1je8Bt1N5R7JPst5kAFAM4uv4fymxBhTDxp3mQrC7VbmCdcR1qe3X1QTsJ7Diddfw1JGvC
 Z+TP0H/xStCDYRGf/BG4ifiuF02iOGxYVdY1sBAEq1zOQ1FHQPWCje1m+NHv7wxiFJtNVrR
 1cbaD+QiHYkL+cJ/dLd+JHf2fkKjpbfIOsOORcUfp+QkxeDsQg=
X-QQ-GoodBg: 2
Subject: Re: ARM64 kvm cache coherency problem
To: Marc Zyngier <marc.zyngier@arm.com>
References: <7c31d3ab-ac30-626e-05be-b2547b558f4a@cloudminds.com>
 <86v9y57g3k.wl-marc.zyngier@arm.com>
From: kevin zhao <xiaoqiang.zhao@cloudminds.com>
Message-ID: <b3171769-2648-bead-c07a-b137a1f4c415@cloudminds.com>+A8E7809C801C9670
Date: Mon, 20 May 2019 15:31:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <86v9y57g3k.wl-marc.zyngier@arm.com>
Content-Type: multipart/mixed; boundary="------------2E9DF8F2858015918D824799"
Content-Language: en-US
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cloudminds.com:qybgforeign:qybgforeign2
X-QQ-Bgrelay: 1
X-Mailman-Approved-At: Mon, 20 May 2019 04:22:52 -0400
Cc: kvmarm@lists.cs.columbia.edu
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
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This is a multi-part message in MIME format.
--------------2E9DF8F2858015918D824799
Content-Type: multipart/alternative;
 boundary="------------237D5C8B51BA9A41CFA368BA"


--------------237D5C8B51BA9A41CFA368BA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

It's much more clear to me now.

Thanks Marc !

在 2019/5/20 下午3:14, Marc Zyngier 写道:
> Hi Kevin,
>
> On Mon, 20 May 2019 04:19:50 +0100,
> kevin zhao <xiaoqiang.zhao@cloudminds.com> wrote:
>> [1  <multipart/alternative (7bit)>]
>> [1.1  <text/plain; UTF-8 (8bit)>]
>>   Hi, there:
>>
>>      I have seen some RFC about solving ARM64 kvm cache incoherency
>> issue ([1], [2]) in May 2015. I followed a few threads and did not
>> know how this arguments ends.
> First, let me put things straight: there is no KVM/arm64 cache
> coherency problem. The issue is that people expect behaviours that are
> specific to x86 (such as coherency between cacheable and non-cacheable
> aliases) to work on non-x86 architectures. This isn't a reasonable
> expectation, unfortunately.
>
> The patches you refer to try to workaround the issue by changing
> either QEMU's or the kernel's behaviour. I contend that none of these
> need to be changed, but instead the guest has to be fixed to properly
> behave on the arm64 architecture, which includes things such as not
> lying about what is a real device and what is an emulated one.
>
> I've ranted publicly on this very subject a long while ago[1], with
> all the gory details of what fails, why, and what the solutions
> are. In the end, KVM/arm64 works remarkably well for what actually
> matters, such as PV devices (virtio) and directly assigned devices,
> without any cache coherency issue.
>
>>     Does anybody know how this problem  is solved finally ?
> The architecture has gained the ARMv8.4 FWB extension, which solves
> some of these problems by allowing Stage-2 to override the guest's
> attributes (and a couple of other things that make I$/D$ coherency
> much easier). Yes, it would have been nice to have this since day one
> (circa 2008), but it involves getting hold of a crystal ball and a
> time machine, both of which are out of stock at my local dealer.
>
> I don't know of any publicly available CPU implementing FWB at this
> stage, so this is a moot point...
>
> Thanks,
>
> 	M.
>
> [1] https://events.static.linuxfound.org/sites/events/files/slides/slides_10.pdf
>
-- 

--------------237D5C8B51BA9A41CFA368BA
Content-Type: multipart/related;
 boundary="------------34406AE4D530A0FD99574304"


--------------34406AE4D530A0FD99574304
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p>It's much more clear to me now.</p>
    <p>Thanks Marc !<br>
    </p>
    <div class="moz-cite-prefix">在 2019/5/20 下午3:14, Marc Zyngier 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:86v9y57g3k.wl-marc.zyngier@arm.com">
      <pre class="moz-quote-pre" wrap="">Hi Kevin,

On Mon, 20 May 2019 04:19:50 +0100,
kevin zhao <a class="moz-txt-link-rfc2396E" href="mailto:xiaoqiang.zhao@cloudminds.com">&lt;xiaoqiang.zhao@cloudminds.com&gt;</a> wrote:
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">
[1  &lt;multipart/alternative (7bit)&gt;]
[1.1  &lt;text/plain; UTF-8 (8bit)&gt;]
 Hi, there:

    I have seen some RFC about solving ARM64 kvm cache incoherency
issue ([1], [2]) in May 2015. I followed a few threads and did not
know how this arguments ends.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
First, let me put things straight: there is no KVM/arm64 cache
coherency problem. The issue is that people expect behaviours that are
specific to x86 (such as coherency between cacheable and non-cacheable
aliases) to work on non-x86 architectures. This isn't a reasonable
expectation, unfortunately.

The patches you refer to try to workaround the issue by changing
either QEMU's or the kernel's behaviour. I contend that none of these
need to be changed, but instead the guest has to be fixed to properly
behave on the arm64 architecture, which includes things such as not
lying about what is a real device and what is an emulated one.

I've ranted publicly on this very subject a long while ago[1], with
all the gory details of what fails, why, and what the solutions
are. In the end, KVM/arm64 works remarkably well for what actually
matters, such as PV devices (virtio) and directly assigned devices,
without any cache coherency issue.

</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">   Does anybody know how this problem  is solved finally ?
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
The architecture has gained the ARMv8.4 FWB extension, which solves
some of these problems by allowing Stage-2 to override the guest's
attributes (and a couple of other things that make I$/D$ coherency
much easier). Yes, it would have been nice to have this since day one
(circa 2008), but it involves getting hold of a crystal ball and a
time machine, both of which are out of stock at my local dealer.

I don't know of any publicly available CPU implementing FWB at this
stage, so this is a moot point...

Thanks,

	M.

[1] <a class="moz-txt-link-freetext" href="https://events.static.linuxfound.org/sites/events/files/slides/slides_10.pdf">https://events.static.linuxfound.org/sites/events/files/slides/slides_10.pdf</a>

</pre>
    </blockquote>
    <div class="moz-signature">-- <br>
      <img src="cid:part1.3B40FEC0.A4038BF2@cloudminds.com" border="0"></div>
  </body>
</html>

--------------34406AE4D530A0FD99574304
Content-Type: image/png;
 name="CloudMinds Logo_English_Color_Landscape_forEmail116.png"
Content-Transfer-Encoding: base64
Content-ID: <part1.3B40FEC0.A4038BF2@cloudminds.com>
Content-Disposition: inline;
 filename="CloudMinds Logo_English_Color_Landscape_forEmail116.png"

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
RU5ErkJggg==
--------------34406AE4D530A0FD99574304--

--------------237D5C8B51BA9A41CFA368BA--

--------------2E9DF8F2858015918D824799
Content-Type: text/x-vcard; charset=utf-8;
 name="xiaoqiang_zhao.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xiaoqiang_zhao.vcf"

begin:vcard
fn;quoted-printable:=E8=B5=B5 =E5=B0=8F=E5=BC=BA
n;quoted-printable;quoted-printable:=E5=B0=8F=E5=BC=BA;=E8=B5=B5
version:2.1
end:vcard


--------------2E9DF8F2858015918D824799
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--------------2E9DF8F2858015918D824799--


