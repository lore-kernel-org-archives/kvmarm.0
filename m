From: Yasutaka Tanaka <yt2558@columbia.edu>
Subject: KVM on ARM Cortex A53 in 32-bit Mode
Date: Thu, 2 Mar 2017 09:57:50 -0500
Message-ID: <CAPn9co60wgUms-V_6PBB4CDKeWV_mJzHqg-5wjTchKFi4G9xkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4598941946209126767=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE03740992
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 09:56:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WNZauUnv1WeF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Mar 2017 09:56:39 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1007740430
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 09:56:38 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v22Eu9HO023279
 for <kvmarm@lists.cs.columbia.edu>; Thu, 2 Mar 2017 09:57:51 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id C15826D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 09:57:51 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id AC68F7E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 09:57:51 -0500 (EST)
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com
 [209.85.220.198])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v22EvpMC011393
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 2 Mar 2017 09:57:51 -0500
Received: by mail-qk0-f198.google.com with SMTP id n127so102682908qkf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Mar 2017 06:57:51 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============4598941946209126767==
Content-Type: multipart/alternative; boundary=94eb2c12543a2ab1720549c0a7ac

--94eb2c12543a2ab1720549c0a7ac
Content-Type: text/plain; charset=UTF-8

Hello KVM/ARM community,

I am now trying to execute KVM on Raspberry Pi 3 Model B (RPI3).
Does anyone know whether KVM/ARM can run with 32-bit mode on ARM Cortex A53?

The CPU of RPI3 is ARM Cortex A53 which can be executed in both 32-bit and
64-bit mode. I've managed to display /dev/kvm on 64-bit mode execution
(i.e. with a 64-bit linux kernel) on RPI3, but I failed to do so in 32-bit
mode.

In 32-bit mode, an KVM error messages says CPU not supported. I guess the
reason for the error message is KVM_ARM_TARGET_CORTEX_A53 is only returned
in /arch/arm64/kvm/guest.c not under/arch/arm/kvm/guest.c.

So I'm wondering whether it's possible or not. What I'd like to do is to
compare the execution speed of KVM between 32-bit and 64-bit mode. The
second plan is to compare between KVMs of 32-bit RPI2 and 64-bit RPI3 (I
have both), but since RPI2 spec is a little low and I'm worried that some
numeric comparisons become unfair.

(I was also notified by an KVM/ARM expert that since RPI doesn't have a GIC
and I need to apply some patches)

The 64-bit kernel I used is the official RPI3 one here:
https://github.com/raspberrypi/linux
I compiled after make bcmrpi3_defconfig config:
https://github.com/raspberrypi/linux/blob/rpi-4.9.y/arch/arm64/configs/bcmrpi3_defconfig

Best regards,
Yasutaka Tanaka

--94eb2c12543a2ab1720549c0a7ac
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><span style=3D"color:rgb(51,51,51);font-family:ubuntu=
,tahoma,&quot;helvetica neue&quot;,helvetica,arial,sans-serif;font-size:14p=
x">Hello KVM/ARM community,</span><br></div><div><span style=3D"color:rgb(5=
1,51,51);font-family:ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,ari=
al,sans-serif;font-size:14px"><br></span></div><div><span style=3D"color:rg=
b(51,51,51);font-family:ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,=
arial,sans-serif;font-size:14px">I am now trying to execute KVM on Raspberr=
y Pi 3 Model B (RPI3).</span></div><div><font color=3D"#333333" face=3D"ubu=
ntu, tahoma, helvetica neue, helvetica, arial, sans-serif"><span style=3D"f=
ont-size:14px">Does anyone know whether KVM/ARM can run with 32-bit mode on=
 ARM Cortex A53?</span></font></div><div><span style=3D"color:rgb(51,51,51)=
;font-family:ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,arial,sans-=
serif;font-size:14px"><br></span></div><div><span style=3D"color:rgb(51,51,=
51);font-family:ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,arial,sa=
ns-serif;font-size:14px">The CPU of RPI3 is ARM Cortex A53 which can be exe=
cuted in both 32-bit and 64-bit mode.=C2=A0</span><span style=3D"color:rgb(=
51,51,51);font-family:ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,ar=
ial,sans-serif;font-size:14px">I&#39;ve managed to display /dev/kvm on 64-b=
it mode execution (i.e. with a 64-bit linux kernel) on RPI3, but I failed t=
o do so in 32-bit mode.=C2=A0</span></div><div><span style=3D"color:rgb(51,=
51,51);font-family:ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,arial=
,sans-serif;font-size:14px"><br></span></div><div><span style=3D"color:rgb(=
51,51,51);font-family:ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,ar=
ial,sans-serif;font-size:14px">In 32-bit mode, an KVM error messages says C=
PU not supported. I guess the reason for the error message is=C2=A0</span><=
font color=3D"#333333" face=3D"ubuntu, tahoma, helvetica neue, helvetica, a=
rial, sans-serif"><span style=3D"font-size:14px">KVM_ARM_TARGET_CORTEX_A53 =
is only returned in /arch/arm64/kvm/guest.c not under/arch/arm/kvm/guest.c.=
</span></font></div><div><span style=3D"color:rgb(51,51,51);font-family:ubu=
ntu,tahoma,&quot;helvetica neue&quot;,helvetica,arial,sans-serif;font-size:=
14px"><br></span></div><div><span style=3D"color:rgb(51,51,51);font-family:=
ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,arial,sans-serif;font-si=
ze:14px">So I&#39;m wondering whether it&#39;s possible or not. What I&#39;=
d like to do is to compare the execution speed of KVM between 32-bit and 64=
-bit mode. The second plan is to compare between KVMs of 32-bit RPI2 and 64=
-bit RPI3 (I have both), but since RPI2 spec is a little low and I&#39;m wo=
rried that some numeric comparisons become unfair.</span></div><div><span s=
tyle=3D"color:rgb(51,51,51);font-family:ubuntu,tahoma,&quot;helvetica neue&=
quot;,helvetica,arial,sans-serif;font-size:14px"><br></span></div><div><spa=
n style=3D"color:rgb(51,51,51);font-family:ubuntu,tahoma,&quot;helvetica ne=
ue&quot;,helvetica,arial,sans-serif;font-size:14px">(I was also notified by=
 an KVM/ARM expert that since RPI doesn&#39;t have a GIC and I need to appl=
y some patches)</span></div><div><span style=3D"color:rgb(51,51,51);font-fa=
mily:ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,arial,sans-serif;fo=
nt-size:14px"><br></span></div><div><span style=3D"color:rgb(51,51,51);font=
-family:ubuntu,tahoma,&quot;helvetica neue&quot;,helvetica,arial,sans-serif=
;font-size:14px">The 64-bit kernel I used is the official RPI3 one here:=C2=
=A0</span><font color=3D"#333333" face=3D"ubuntu, tahoma, helvetica neue, h=
elvetica, arial, sans-serif"><span style=3D"font-size:14px"><a href=3D"http=
s://github.com/raspberrypi/linux">https://github.com/raspberrypi/linux</a><=
/span></font></div><div><font color=3D"#333333" face=3D"ubuntu, tahoma, hel=
vetica neue, helvetica, arial, sans-serif"><span style=3D"font-size:14px">I=
 compiled after make bcmrpi3_defconfig config:=C2=A0<a href=3D"https://gith=
ub.com/raspberrypi/linux/blob/rpi-4.9.y/arch/arm64/configs/bcmrpi3_defconfi=
g">https://github.com/raspberrypi/linux/blob/rpi-4.9.y/arch/arm64/configs/b=
cmrpi3_defconfig</a></span></font></div><div><br></div><div>Best regards,</=
div><div><span style=3D"color:rgb(51,51,51);font-family:ubuntu,tahoma,&quot=
;helvetica neue&quot;,helvetica,arial,sans-serif;font-size:14px">Yasutaka T=
anaka</span></div></div>

--94eb2c12543a2ab1720549c0a7ac--


--===============4598941946209126767==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4598941946209126767==--
