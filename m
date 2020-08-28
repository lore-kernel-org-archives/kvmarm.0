Return-Path: <SRS0=xBPq=CG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2418C433E2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 11:23:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5920E207DF
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 11:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3nMQOdr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5920E207DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 030DC4B8AF;
	Fri, 28 Aug 2020 07:23:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xPA-4oOGF58z; Fri, 28 Aug 2020 07:23:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C01764C22E;
	Fri, 28 Aug 2020 07:23:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C73654BD21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 04:41:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jnk4Ij4vYIjN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Aug 2020 04:41:14 -0400 (EDT)
Received: from mail-io1-f68.google.com (mail-io1-f68.google.com
 [209.85.166.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 781024B972
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 04:41:14 -0400 (EDT)
Received: by mail-io1-f68.google.com with SMTP id b16so449044ioj.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 01:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Rv9t9DBMT4Y9Uv16M/8E2uBNqN9bviSqC1cfMDj55qk=;
 b=O3nMQOdrhgjp6pS91SYY1V/rXLQgfKSIVRfsltF1r3lM5xYWjM/3hPwTifUchnhBE+
 cmbau7uFPuSgsqd/68IVYDK4FHCm/lfYzfVg7K3e29J6HZ6Ef1Or2+6wluD1hkRq+2G0
 1ETSdruDkdU8FyzBQy4yjKSi/XyjlcyJgmQwyMU+SRCQ37xSkwnHvj1VSa7xU7QgARj9
 3A8yLY3Uu7pCN85wgCo5cUUCkbvCXdpjcDjyqKk9y9MFvw7HBi6+VnGTKC1fSUswjwCB
 K05hk9A2PKgFCMDBkCbnIDXWedvJ9QXfAZMkzqsR+m4YX7no1t8v3O4O0dwtCM5cSRGQ
 l2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Rv9t9DBMT4Y9Uv16M/8E2uBNqN9bviSqC1cfMDj55qk=;
 b=XYN0BOjxW5wNXMMKwjvheapt6S23I45UzAq/oF+7EafYM/yDG/AJlnsx6Wo4q3dctE
 q+Ck3zsTcKss/yKjkOW33yIJENzS32OsFfvTygt6DoCAEBrpKf3XuhG3OVsJPYNjjlKq
 D7MXRAZIMpzHD/R1csE7F56U4EKhIOfVAV1WWcMODDggd1jK0mNYK8/IMXwPJ0t9KiCW
 8ATx0xOGV7dnjpF/4iO7IKqrOgef82Hfg/tjalfB2QDpXU4xPSR68XhYfJBdjw5S6So4
 9sANud3z4Z7GUAj3xOSWWW4Wb9COZGmIrek3eEnW3C6cRw5SKCPXP6PQapZMbwvKnKoi
 sLcA==
X-Gm-Message-State: AOAM531xH79cEgY7ipny0hPuhxGEMEro5LiICMoMpE7/JvYIvr1QXS+L
 hQyO8B/xrilGy+4N8BL8vDS0mo6Lah+YdLWstw==
X-Google-Smtp-Source: ABdhPJxIX0fJi9w6dYvAGIo8yULiAYghXMHvu5eHGaixZLaaGSv3j99yakmktgVk8wFUKdTWYhT3m0gbG/uomOq1HDA=
X-Received: by 2002:a5e:9e0a:: with SMTP id i10mr455714ioq.41.1598604073846;
 Fri, 28 Aug 2020 01:41:13 -0700 (PDT)
MIME-Version: 1.0
References: <1597241133-3630-1-git-send-email-kernelfans@gmail.com>
 <50ccd1aa-797f-bc97-d675-8d6732d9ae06@arm.com>
In-Reply-To: <50ccd1aa-797f-bc97-d675-8d6732d9ae06@arm.com>
From: Pingfan Liu <kernelfans@gmail.com>
Date: Fri, 28 Aug 2020 16:41:02 +0800
Message-ID: <CAFgQCTvy0UGq73AxBmGKPNZATRRggGLkSqksXJaz_-ZOj2YCrg@mail.gmail.com>
Subject: Re: [PATCH] arm(64)/kvm: improve the documentation about HVC calls
To: James Morse <james.morse@arm.com>
X-Mailman-Approved-At: Fri, 28 Aug 2020 07:23:40 -0400
Cc: Marc Zyngier <maz@kernel.org>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Aug 27, 2020 at 2:10 AM James Morse <james.morse@arm.com> wrote:
>
> Hi Pingfan,
>
> On 12/08/2020 15:05, Pingfan Liu wrote:
> > Both arm and arm64 kernel entry point have the following prerequisite:
> >   MMU = off, D-cache = off, I-cache = dont care.
> >
> > HVC_SOFT_RESTART call should meet this prerequisite before jumping to the
> > new kernel.
>
> I think you have this the wrong way up. This should describe what HVC_SOFT_RESTART does.
Yes, it is a wrong way.

>
> We want to remove some extra work kexec does on arm64, and both implementations of
> HVC_SOFT_RESTART on arm64 already do what we need. The change here should be to document
> that the D/I bits are cleared after a HVC_SOFT_RESTART on arm64.
>
>
> > Furthermore, on arm64, el2_setup doesn't set I+C bits and keeps EL2 MMU
> > off, and KVM resets them when its unload. These are achieved by
> > HVC_RESET_VECTORS call.
> >
> > Improve the document.
>
>
> > diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm/hyp-abi.rst
> > index d9eba93..a95bc30 100644
> > --- a/Documentation/virt/kvm/arm/hyp-abi.rst
> > +++ b/Documentation/virt/kvm/arm/hyp-abi.rst
> > @@ -40,9 +40,9 @@ these functions (see arch/arm{,64}/include/asm/virt.h):
> >
> >  * ::
> >
> > -    r0/x0 = HVC_RESET_VECTORS
> > +    x0 = HVC_RESET_VECTORS (arm64 only)
> >
> > -  Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the initials
> > +  Disable HYP/EL2 MMU and D-cache, and reset HVBAR/VBAR_EL2 to the initials
> >    stubs' exception vector value. This effectively disables an existing
> >    hypervisor.
>
> I don't think we should remove this. KVM on 32bit was the only implementer, but if there
> ever is another, this is how it should work.
>
>
> > @@ -54,7 +54,7 @@ these functions (see arch/arm{,64}/include/asm/virt.h):
> >      x3 = x1's value when entering the next payload (arm64)
> >      x4 = x2's value when entering the next payload (arm64)
> >
> > -  Mask all exceptions, disable the MMU, move the arguments into place
> > +  Mask all exceptions, disable the MMU and D-cache, move the arguments into place
> >    (arm64 only), and jump to the restart address while at HYP/EL2. This
> >    hypercall is not expected to return to its caller.
>
> (I don't think disable the D-cache is what the bit does, it forces the attributes that are
> used for a data access).
>
> Please just describe this as the on arm64 the D and I bits are cleared.
OK, I will do it.

> (it might be true on 32bit, I can't work the assembly out).
I will leave 32bit as it is.

Thanks,
Pingfan
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
