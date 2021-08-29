Return-Path: <SRS0=y5YY=NU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC895C432BE
	for <kvmarm@archiver.kernel.org>; Sun, 29 Aug 2021 08:26:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41F68608FE
	for <kvmarm@archiver.kernel.org>; Sun, 29 Aug 2021 08:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 41F68608FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF16A4B0A5;
	Sun, 29 Aug 2021 04:26:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x8CAVINQAa09; Sun, 29 Aug 2021 04:26:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C65384B12B;
	Sun, 29 Aug 2021 04:26:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 961A64B11F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Aug 2021 04:26:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rtW4kklXnP6A for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Aug 2021 04:26:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2318F4B0A5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Aug 2021 04:26:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630225569;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=JjTKSJDOFG8EmUAAgQVMI2Jt5VU/rzyE9X8Go3zFFC8=;
 b=IexQHMDJy+84Pn06tSki01Qr+8i2IRSQLuqzYRSII3FLiFza6O0zO83wTiyyNNbYuLW9gL
 wbchKyJedobStUH6cW8txmJ449C0VVBA1WOgHW8QDYXl1SEJhFqIC/bImMbj2DfHr5LiwL
 DflcI/Tbj2cD64X76CSB6UiZYpwbTdU=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-r2dGxmadPx6dgQIOBnrrkw-1; Sun, 29 Aug 2021 04:26:05 -0400
X-MC-Unique: r2dGxmadPx6dgQIOBnrrkw-1
Received: by mail-pf1-f197.google.com with SMTP id
 h10-20020a056a00170a00b003e31c4d9992so1713520pfc.23
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Aug 2021 01:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JjTKSJDOFG8EmUAAgQVMI2Jt5VU/rzyE9X8Go3zFFC8=;
 b=CCL7LBIidgHDYTJ5nT5KWDpCYkpnsER2AD43Zp1kjSz/2PhjaAMikPgAsdlxKP1nEQ
 3Ggnu9ZGBUqRcWk9rg31KBkp4aZpHgzkHyPwaC+MM3J7z2/GkLak6R4dwIaWC4fBKGAZ
 SNlmT22p4aL4DGNV8qWOTWjyDoVH5hzLAb2q+T61rOwIuHFhSwouiS3QRON0+R7ri1ob
 nd8yTEzxM26dhjCiGzAMitfawHf+M4QGm75UPFHMhZGp7HCi0YnfFUmLokLyK/ij9q3U
 QWz3xyLdhGETbOY4pb+WhNMAZKoLvDoZX62nZOGxqOQMWpANwOop11LgnXd909v/ATM6
 o5ng==
X-Gm-Message-State: AOAM530ymoYUwmiFk+C+4nv1GlPs0WzG4kADNJ3kQKmpUIKHt3YUCvnd
 X7JZCKAPWTjV0BFicQA8vLvSkrhDe4YT+vjKcCdki/JrloXSqTlZIDiAE//63XoiidqKVP6wXdO
 w0Zncq7ufcoXC1/bdu9QFGhndbdz8gz1biXi2Di1o
X-Received: by 2002:a65:5603:: with SMTP id l3mr15961606pgs.281.1630225564781; 
 Sun, 29 Aug 2021 01:26:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySWEMA4H1jF0Mcnvk8eUpODxWTAu6fA3LgRcMWeaEJLcSONqbAzIpnq1+p8Z5iypLdJCetbYIsHsD7cI638CE=
X-Received: by 2002:a65:5603:: with SMTP id l3mr15961581pgs.281.1630225564456; 
 Sun, 29 Aug 2021 01:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-7-oupton@google.com>
 <CAOQ_Qsj_MfRNRRSK1UswsfBw4c9ugSW6tKXNua=3O78sHEonvA@mail.gmail.com>
 <20210826124836.GA155749@fuller.cnet> <YSf5SV0AZMvfIEib@google.com>
In-Reply-To: <YSf5SV0AZMvfIEib@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 29 Aug 2021 10:25:51 +0200
Message-ID: <CABgObfbqHG59n8jitJGzL0=J-tvKYvpg4+2xV7z2dFf2rNHhqg@mail.gmail.com>
Subject: Re: [PATCH v7 6/6] KVM: x86: Expose TSC offset controls to userspace
To: Oliver Upton <oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm <kvm@vger.kernel.org>,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Peter Shier <pshier@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, KVM ARM <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>
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
Content-Type: multipart/mixed; boundary="===============8651692121575601562=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8651692121575601562==
Content-Type: multipart/alternative; boundary="000000000000ac6c9e05caae7788"

--000000000000ac6c9e05caae7788
Content-Type: text/plain; charset="UTF-8"

This will bounce to the mailing lists because I am on a text/plain-impaired
phone, but anyway.

One reason to have selftests is to allow having APIs that are not used by
QEMU. Still, I think Maxim had an implementation of his own TSC migration
API and it shouldn't be too hard to use the algorithm that is documented in
this series.

Paolo

Il gio 26 ago 2021, 22:28 Oliver Upton <oupton@google.com> ha scritto:

> Marcelo,
>
> On Thu, Aug 26, 2021 at 09:48:36AM -0300, Marcelo Tosatti wrote:
> > On Mon, Aug 23, 2021 at 01:56:30PM -0700, Oliver Upton wrote:
> > > Paolo,
> > >
> > > On Sun, Aug 15, 2021 at 5:11 PM Oliver Upton <oupton@google.com>
> wrote:
> > > >
> > > > To date, VMM-directed TSC synchronization and migration has been a
> bit
> > > > messy. KVM has some baked-in heuristics around TSC writes to infer if
> > > > the VMM is attempting to synchronize. This is problematic, as it
> depends
> > > > on host userspace writing to the guest's TSC within 1 second of the
> last
> > > > write.
> > > >
> > > > A much cleaner approach to configuring the guest's views of the TSC
> is to
> > > > simply migrate the TSC offset for every vCPU. Offsets are idempotent,
> > > > and thus not subject to change depending on when the VMM actually
> > > > reads/writes values from/to KVM. The VMM can then read the TSC once
> with
> > > > KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant
> when
> > > > the guest is paused.
> > > >
> > > > Cc: David Matlack <dmatlack@google.com>
> > > > Cc: Sean Christopherson <seanjc@google.com>
> > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > >
> > > Could you please squash the following into this patch? We need to
> > > advertise KVM_CAP_VCPU_ATTRIBUTES to userspace. Otherwise, happy to
> > > resend.
> > >
> > > Thanks,
> > > Oliver
> >
> > Oliver,
> >
> > Is there QEMU support for this, or are you using your own
> > userspace with this?
>
> Apologies for not getting back to you on your first mail. Sadly, I am
> using our own userspace for this. That being said, adding support to
> QEMU shouldn't be too challenging. I can take a stab at it if it makes
> the series more amenable to upstream, with the giant disclaimer that I
> haven't done work in QEMU before. Otherwise, happy to review someone
> else's implementation.
>
> --
> Thanks,
> Oliver
>
>

--000000000000ac6c9e05caae7788
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">This will bounce to the mailing lists because I am on a t=
ext/plain-impaired phone, but anyway.<div dir=3D"auto"><br></div><div dir=
=3D"auto">One reason to have selftests is to allow having APIs that are not=
 used by QEMU. Still, I think Maxim had an implementation of his own TSC mi=
gration API and it shouldn&#39;t be too hard to use the algorithm that is d=
ocumented in this series.<div dir=3D"auto"><br></div><div dir=3D"auto">Paol=
o</div></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D=
"gmail_attr">Il gio 26 ago 2021, 22:28 Oliver Upton &lt;<a href=3D"mailto:o=
upton@google.com">oupton@google.com</a>&gt; ha scritto:<br></div><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex">Marcelo,<br>
<br>
On Thu, Aug 26, 2021 at 09:48:36AM -0300, Marcelo Tosatti wrote:<br>
&gt; On Mon, Aug 23, 2021 at 01:56:30PM -0700, Oliver Upton wrote:<br>
&gt; &gt; Paolo,<br>
&gt; &gt; <br>
&gt; &gt; On Sun, Aug 15, 2021 at 5:11 PM Oliver Upton &lt;<a href=3D"mailt=
o:oupton@google.com" target=3D"_blank" rel=3D"noreferrer">oupton@google.com=
</a>&gt; wrote:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; To date, VMM-directed TSC synchronization and migration has =
been a bit<br>
&gt; &gt; &gt; messy. KVM has some baked-in heuristics around TSC writes to=
 infer if<br>
&gt; &gt; &gt; the VMM is attempting to synchronize. This is problematic, a=
s it depends<br>
&gt; &gt; &gt; on host userspace writing to the guest&#39;s TSC within 1 se=
cond of the last<br>
&gt; &gt; &gt; write.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; A much cleaner approach to configuring the guest&#39;s views=
 of the TSC is to<br>
&gt; &gt; &gt; simply migrate the TSC offset for every vCPU. Offsets are id=
empotent,<br>
&gt; &gt; &gt; and thus not subject to change depending on when the VMM act=
ually<br>
&gt; &gt; &gt; reads/writes values from/to KVM. The VMM can then read the T=
SC once with<br>
&gt; &gt; &gt; KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the =
instant when<br>
&gt; &gt; &gt; the guest is paused.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Cc: David Matlack &lt;<a href=3D"mailto:dmatlack@google.com"=
 target=3D"_blank" rel=3D"noreferrer">dmatlack@google.com</a>&gt;<br>
&gt; &gt; &gt; Cc: Sean Christopherson &lt;<a href=3D"mailto:seanjc@google.=
com" target=3D"_blank" rel=3D"noreferrer">seanjc@google.com</a>&gt;<br>
&gt; &gt; &gt; Signed-off-by: Oliver Upton &lt;<a href=3D"mailto:oupton@goo=
gle.com" target=3D"_blank" rel=3D"noreferrer">oupton@google.com</a>&gt;<br>
&gt; &gt; <br>
&gt; &gt; Could you please squash the following into this patch? We need to=
<br>
&gt; &gt; advertise KVM_CAP_VCPU_ATTRIBUTES to userspace. Otherwise, happy =
to<br>
&gt; &gt; resend.<br>
&gt; &gt; <br>
&gt; &gt; Thanks,<br>
&gt; &gt; Oliver<br>
&gt; <br>
&gt; Oliver,<br>
&gt; <br>
&gt; Is there QEMU support for this, or are you using your own<br>
&gt; userspace with this?<br>
<br>
Apologies for not getting back to you on your first mail. Sadly, I am<br>
using our own userspace for this. That being said, adding support to<br>
QEMU shouldn&#39;t be too challenging. I can take a stab at it if it makes<=
br>
the series more amenable to upstream, with the giant disclaimer that I<br>
haven&#39;t done work in QEMU before. Otherwise, happy to review someone<br=
>
else&#39;s implementation.<br>
<br>
--<br>
Thanks,<br>
Oliver<br>
<br>
</blockquote></div>

--000000000000ac6c9e05caae7788--


--===============8651692121575601562==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8651692121575601562==--

