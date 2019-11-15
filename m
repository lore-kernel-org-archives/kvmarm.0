Return-Path: <SRS0=MyuK=ZH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FORGED_YAHOO_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FF9C432C3
	for <kvmarm@archiver.kernel.org>; Fri, 15 Nov 2019 02:15:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F41A9206D5
	for <kvmarm@archiver.kernel.org>; Fri, 15 Nov 2019 02:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="UyS9Ofi5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F41A9206D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=yahoo.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4A74AEF3;
	Thu, 14 Nov 2019 21:15:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@yahoo.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dQ10WmCd6TVu; Thu, 14 Nov 2019 21:15:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 472D94AEF5;
	Thu, 14 Nov 2019 21:15:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A98AF4AEF3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 21:15:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yXVs-qvsJUqp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Nov 2019 21:15:38 -0500 (EST)
Received: from sonic309-44.consmr.mail.bf2.yahoo.com
 (sonic309-44.consmr.mail.bf2.yahoo.com [74.6.129.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 824AC4AEBD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 21:15:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
 t=1573784138; bh=C+s/pcKUAh6zBlVje3f241DL958jTrffFEhgECkKcwg=;
 h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject;
 b=UyS9Ofi5Lm/JfSGTVOl35xrlb6iMGui6m+iLicONDM3394sU3etB10GBWO/Ncx6rsH6hJna23dgF+TQU2Mvzl/er1aV/MpJwkyAXL1BQlzhFrOc4LcTQHhhNizvO1oaVAj5dbPvEHeKr8MbdBEtcRDOiWMFjYRT5hhuyERuXTiKBRcfZSr7FaktV7fIbMbLGKNXoHvGp2QcIdNY6GgaOjN9dkBqA76jjNa4b50Tfs8EBdY6u2vtRkPOZ7NecH+aaMyvk6qToV+dxGutChManRArB75tyKDo/5E6pEUEpxTitzR0Mw23XHJ/k2UgSR7DbIPIgeyDxuSUniHYQmZj+Dw==
X-YMail-OSG: N_6BpMEVRDvd.miR6A7lED5GPdAEx7ojsA--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic309.consmr.mail.bf2.yahoo.com with HTTP; Fri, 15 Nov 2019 02:15:38 +0000
Date: Fri, 15 Nov 2019 02:13:37 +0000 (UTC)
From: Matjaz Matjaz <matyaz@yahoo.com>
To: Marco Felsch <m.felsch@pengutronix.de>, 
 Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <231794607.364474.1573784017752@mail.yahoo.com>
In-Reply-To: <7322163f-e08e-a6b7-b143-e9d59917ee5b@gmail.com>
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <20191114181243.q37rxoo3seds6oxy@pengutronix.de>
 <7322163f-e08e-a6b7-b143-e9d59917ee5b@gmail.com>
Subject: ***SPAM*** Re: [PATCH v6 0/6] KASan for arm
MIME-Version: 1.0
X-Mailer: WebService/1.1.14728 YMailNorrin Mozilla/5.0 (Windows NT 6.1)
 AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36
Cc: alexandre.belloni@bootlin.com, mhocko@suse.com, linux-doc@vger.kernel.org,
 catalin.marinas@arm.com, dhowells@redhat.com, yamada.masahiro@socionext.com,
 ryabinin.a.a@gmail.com, glider@google.com, kvmarm@lists.cs.columbia.edu,
 rob@landley.net, corbet@lwn.net, liuwenliang@huawei.com,
 daniel.lezcano@linaro.org, linux@armlinux.org.uk, kasan-dev@googlegroups.com,
 bcm-kernel-feedback-list@broadcom.com, linux-arm-kernel@lists.infradead.org,
 geert@linux-m68k.org, keescook@chromium.org, arnd@arndb.de,
 marc.zyngier@arm.com, andre.przywara@arm.com, philip@cog.systems,
 jinb.park7@gmail.com, tglx@linutronix.de, dvyukov@google.com, nico@fluxnic.net,
 gregkh@linuxfoundation.org, ard.biesheuvel@linaro.org,
 linux-kernel@vger.kernel.org, kernel@pengutronix.de, pombredanne@nexb.com,
 akpm@linux-foundation.org, thgarnie@google.com,
 kirill.shutemov@linux.intel.com
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
Content-Type: multipart/mixed; boundary="===============0934484133862964638=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============0934484133862964638==
Content-Type: multipart/alternative; 
	boundary="----=_Part_364473_1006591184.1573784017750"

------=_Part_364473_1006591184.1573784017750
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

 [::1]:2869=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0hp-PC:53166=C2=
=A0 =C2=A0=C2=A0ios 2.1.2 I sign on it
    Dne petek, 15. november 2019 00:01:38 GMT+1 je uporabnik Florian Fainel=
li <f.fainelli@gmail.com> napisal: =20
=20
 Hello Marco,

On 11/14/19 10:12 AM, Marco Felsch wrote:
> Hi Florian,
>=20
> first of all, many thanks for your work on this series =3D) I picked your
> and Arnd patches to make it compilable. Now it's compiling but my imx6q
> board didn't boot anymore. I debugged the code and found that the branch
> to 'start_kernel' won't be reached
>=20
> 8<------- arch/arm/kernel/head-common.S -------
> ....
>=20
> #ifdef CONFIG_KASAN
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 bl=C2=A0 =C2=A0 =C2=A0 kasan_early_init
> #endif
> =C2=A0=C2=A0=C2=A0 mov=C2=A0 =C2=A0 lr, #0
> =C2=A0=C2=A0=C2=A0 b=C2=A0 =C2=A0 =C2=A0 start_kernel
> ENDPROC(__mmap_switched)
>=20
> ....
> 8<----------------------------------------------
>=20
> Now, I found also that 'KASAN_SHADOW_OFFSET' isn't set due to missing
> 'CONFIG_KASAN_SHADOW_OFFSET' and so no '-fasan-shadow-offset=3Dxxxxx' is
> added. Can that be the reason why my board isn't booted anymore?

The latest that I have is here, though not yet submitted since I needed
to solve one issue on a specific platform with a lot of memory:

https://github.com/ffainelli/linux/pull/new/kasan-v7

Can you share your branch as well? I did not pick all of Arnd's patches
since some appeared to be seemingly independent from KASan on ARM. This
is the KASAN related options that are set in my configuration:

grep KASAN build/linux-custom/.config
CONFIG_HAVE_ARCH_KASAN=3Dy
CONFIG_CC_HAS_KASAN_GENERIC=3Dy
CONFIG_KASAN=3Dy
CONFIG_KASAN_GENERIC=3Dy
CONFIG_KASAN_OUTLINE=3Dy
# CONFIG_KASAN_INLINE is not set
CONFIG_KASAN_STACK=3D1
CONFIG_TEST_KASAN=3Dm

are you using something different by any chance?
--=20
Florian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
 =20
------=_Part_364473_1006591184.1573784017750
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div class=3D"ydp4bb2ab2ayahoo-style-wrap" style=
=3D"font-family:Helvetica Neue, Helvetica, Arial, sans-serif;font-size:16px=
;"><div></div>
        <div dir=3D"ltr" data-setdir=3D"false"><div><div>[::1]:2869&nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;hp-PC:53166&nbsp; &nbsp;&nbsp;</div=
></div>ios 2.1.2 I sign on it</div><div><br></div>
       =20
        </div><div id=3D"yahoo_quoted_3822534166" class=3D"yahoo_quoted">
            <div style=3D"font-family:'Helvetica Neue', Helvetica, Arial, s=
ans-serif;font-size:13px;color:#26282a;">
               =20
                <div>
                    Dne petek, 15. november 2019 00:01:38 GMT+1 je uporabni=
k Florian Fainelli &lt;f.fainelli@gmail.com&gt; napisal:
                </div>
                <div><br></div>
                <div><br></div>
                <div><div dir=3D"ltr">Hello Marco,<br></div><div dir=3D"ltr=
"><br></div><div dir=3D"ltr">On 11/14/19 10:12 AM, Marco Felsch wrote:<br><=
/div><div dir=3D"ltr">&gt; Hi Florian,<br></div><div dir=3D"ltr">&gt; <br><=
/div><div dir=3D"ltr">&gt; first of all, many thanks for your work on this =
series =3D) I picked your<br></div><div dir=3D"ltr">&gt; and Arnd patches t=
o make it compilable. Now it's compiling but my imx6q<br></div><div dir=3D"=
ltr">&gt; board didn't boot anymore. I debugged the code and found that the=
 branch<br></div><div dir=3D"ltr">&gt; to 'start_kernel' won't be reached<b=
r></div><div dir=3D"ltr">&gt; <br></div><div dir=3D"ltr">&gt; 8&lt;------- =
arch/arm/kernel/head-common.S -------<br></div><div dir=3D"ltr">&gt; ....<b=
r></div><div dir=3D"ltr">&gt; <br></div><div dir=3D"ltr">&gt; #ifdef CONFIG=
_KASAN<br></div><div dir=3D"ltr">&gt;&nbsp; &nbsp; &nbsp; &nbsp;  bl&nbsp; =
&nbsp; &nbsp; kasan_early_init<br></div><div dir=3D"ltr">&gt; #endif<br></d=
iv><div dir=3D"ltr">&gt; &nbsp;&nbsp;&nbsp; mov&nbsp; &nbsp;  lr, #0<br></d=
iv><div dir=3D"ltr">&gt; &nbsp;&nbsp;&nbsp; b&nbsp; &nbsp; &nbsp;  start_ke=
rnel<br></div><div dir=3D"ltr">&gt; ENDPROC(__mmap_switched)<br></div><div =
dir=3D"ltr">&gt; <br></div><div dir=3D"ltr">&gt; ....<br></div><div dir=3D"=
ltr">&gt; 8&lt;----------------------------------------------<br></div><div=
 dir=3D"ltr">&gt; <br></div><div dir=3D"ltr">&gt; Now, I found also that 'K=
ASAN_SHADOW_OFFSET' isn't set due to missing<br></div><div dir=3D"ltr">&gt;=
 'CONFIG_KASAN_SHADOW_OFFSET' and so no '-fasan-shadow-offset=3Dxxxxx' is<b=
r></div><div dir=3D"ltr">&gt; added. Can that be the reason why my board is=
n't booted anymore?<br></div><div dir=3D"ltr"><br></div><div dir=3D"ltr">Th=
e latest that I have is here, though not yet submitted since I needed<br></=
div><div dir=3D"ltr">to solve one issue on a specific platform with a lot o=
f memory:<br></div><div dir=3D"ltr"><br></div><div dir=3D"ltr"><a href=3D"h=
ttps://github.com/ffainelli/linux/pull/new/kasan-v7" target=3D"_blank">http=
s://github.com/ffainelli/linux/pull/new/kasan-v7</a><br></div><div dir=3D"l=
tr"><br></div><div dir=3D"ltr">Can you share your branch as well? I did not=
 pick all of Arnd's patches<br></div><div dir=3D"ltr">since some appeared t=
o be seemingly independent from KASan on ARM. This<br></div><div dir=3D"ltr=
">is the KASAN related options that are set in my configuration:<br></div><=
div dir=3D"ltr"><br></div><div dir=3D"ltr">grep KASAN build/linux-custom/.c=
onfig<br></div><div dir=3D"ltr">CONFIG_HAVE_ARCH_KASAN=3Dy<br></div><div di=
r=3D"ltr">CONFIG_CC_HAS_KASAN_GENERIC=3Dy<br></div><div dir=3D"ltr">CONFIG_=
KASAN=3Dy<br></div><div dir=3D"ltr">CONFIG_KASAN_GENERIC=3Dy<br></div><div =
dir=3D"ltr">CONFIG_KASAN_OUTLINE=3Dy<br></div><div dir=3D"ltr"># CONFIG_KAS=
AN_INLINE is not set<br></div><div dir=3D"ltr">CONFIG_KASAN_STACK=3D1<br></=
div><div dir=3D"ltr">CONFIG_TEST_KASAN=3Dm<br></div><div dir=3D"ltr"><br></=
div><div dir=3D"ltr">are you using something different by any chance?<br></=
div><div dir=3D"ltr">-- <br></div><div dir=3D"ltr">Florian<br></div><div di=
r=3D"ltr">_______________________________________________<br></div><div dir=
=3D"ltr">kvmarm mailing list<br></div><div dir=3D"ltr"><a ymailto=3D"mailto=
:kvmarm@lists.cs.columbia.edu" href=3D"mailto:kvmarm@lists.cs.columbia.edu"=
>kvmarm@lists.cs.columbia.edu</a><br></div><div dir=3D"ltr"><a href=3D"http=
s://lists.cs.columbia.edu/mailman/listinfo/kvmarm" target=3D"_blank">https:=
//lists.cs.columbia.edu/mailman/listinfo/kvmarm</a><br></div></div>
            </div>
        </div></body></html>
------=_Part_364473_1006591184.1573784017750--

--===============0934484133862964638==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0934484133862964638==--
