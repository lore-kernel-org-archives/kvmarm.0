Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9FFC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 09:43:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7364061378
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 09:43:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7364061378
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D601E4B231;
	Mon, 23 Aug 2021 05:43:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GBPHRif+nJ3K; Mon, 23 Aug 2021 05:43:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B76834B20D;
	Mon, 23 Aug 2021 05:43:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 319E14B19C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 05:43:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VVD4ScoF49mm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 05:43:38 -0400 (EDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com
 [209.85.208.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F1A64B196
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 05:43:38 -0400 (EDT)
Received: by mail-lj1-f182.google.com with SMTP id d16so30382110ljq.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 02:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gWmYyzLZYwCmRIE4ALv83ZXrjhhuisDMi1lGu05K+NU=;
 b=WYGv2vBBQ/I9AKF4YOn4TG30i6RXbgOhgeQZknBvvTzLBHXURvVH/G4GOhkAMrGLAg
 OZSYB2aNwWcK4s9j4OUt/wtdwKSv+8G38vU99pJCmcKV82MbTVdx+DE6ffvTtaPKZXRK
 YOOQolR4kBNzVhJcO9vW+yMXirz2fq7z0N7tkKaEhspQMB4/4VHq4UakDMAy+xpL8F/A
 J13XwP9sU+Ypcm6LfeU1siZFJ2RNXoFY4WDU2uX1FyHFXPn94orze6RWczhm6ASDSK+B
 ikQJyD9J85tb0gKLsqi9NHV7dkZWf0/ZQQsVU4rzIKcjIBmyGvXvB7i0rSrjriw3w3ZI
 9LLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gWmYyzLZYwCmRIE4ALv83ZXrjhhuisDMi1lGu05K+NU=;
 b=IMjYJgb2OMp4RWgMfvKSPEVMU4BrW8cqtG8CxLySw+MEouESU5oZjM/tgCl9briJsq
 IsioCIaS63hXNlgkPMHLSA9tJma9RqrPJ36+j2SZlRg36fuDNORLG+1fE1Wv/yghHAOa
 VIVDPTHk94/3OkBgCXDgxvsn51xS6rFXNWNgVMU/p1d4wGb2GQvJz22cI+xQEZy8lk6B
 CdMlcGf9r1lhBzDA8II+AViyJWReglu61Scjg/p2F5EnWGVANvJ/cPByvhd1aQg3yDWx
 budqAg5Thog5GmJEl2489bMyk0KNWHqIZCHzKfeGmHnAlsOAovsPkRlzhdOd2zNF4ZPS
 Tuow==
X-Gm-Message-State: AOAM531WjC3XQOp5CDvMYhOpmQ5zbuR0iRgmGuUp+hEmo0zsEwYn3TO5
 TvSO8ePui+I47iBlXPiBUH9X5kEgjmFSIN0DvRJ+PA==
X-Google-Smtp-Source: ABdhPJyNc0kgDTieAItyEgp7N3V5QMCOVCtOGvAAn3s1Zb6UI0O0FJLDphqK8FJgv5rmU7tTumNQJslDEHYCYNe+FWA=
X-Received: by 2002:a2e:a5c1:: with SMTP id n1mr26530717ljp.65.1629711816548; 
 Mon, 23 Aug 2021 02:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210822152526.1291918-1-maz@kernel.org>
 <20210822152526.1291918-4-maz@kernel.org>
 <CAOQ_QsgpgTfhDAg9Td4rgQmEy6m1j5RDDZZG9Q6UDNR3S58YLw@mail.gmail.com>
 <87bl5oqz8k.wl-maz@kernel.org>
In-Reply-To: <87bl5oqz8k.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Mon, 23 Aug 2021 02:43:25 -0700
Message-ID: <CAOQ_QsjKyP+c+m8Hei6ChMDQGi17FJt877-fgAFY1-rS_XOfGw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] kvmtool: arm64: Configure VM with the minimal
 required IPA space
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>
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

On Mon, Aug 23, 2021 at 2:36 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sun, 22 Aug 2021 21:05:16 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Marc,
> >
> > On Sun, Aug 22, 2021 at 8:25 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > There is some value in keeping the IPA space small, as it reduces
> > > the size of the stage-2 page tables.
> > >
> > > Let's compute the required space at VM creation time, and inform
> > > the kernel of our requirements.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arm/aarch64/kvm.c | 20 +++++++++++++++++++-
> > >  1 file changed, 19 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> > > index d03a27f2..4e66a22e 100644
> > > --- a/arm/aarch64/kvm.c
> > > +++ b/arm/aarch64/kvm.c
> > > @@ -3,6 +3,7 @@
> > >  #include <asm/image.h>
> > >
> > >  #include <linux/byteorder.h>
> > > +#include <kvm/util.h>
> > >
> > >  /*
> > >   * Return the TEXT_OFFSET value that the guest kernel expects. Note
> > > @@ -59,5 +60,22 @@ int kvm__arch_get_ipa_limit(struct kvm *kvm)
> > >
> > >  int kvm__get_vm_type(struct kvm *kvm)
> > >  {
> > > -       return KVM_VM_TYPE_ARM_IPA_SIZE(kvm__arch_get_ipa_limit(kvm));
> > > +       unsigned int ipa_bits, max_ipa_bits;
> > > +       unsigned long max_ipa;
> > > +
> > > +       /* If we're running on an old kernel, use 0 as the VM type */
> > > +       max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
> > > +       if (!max_ipa_bits)
> > > +               return 0;
> > > +
> > > +       /* Otherwise, compute the minimal required IPA size */
> > > +       max_ipa = ARM_MEMORY_AREA + kvm->cfg.ram_size - 1;
> > > +       ipa_bits = max(32, fls_long(max_ipa));
> > > +       pr_debug("max_ipa %lx ipa_bits %d max_ipa_bits %d",
> > > +                max_ipa, ipa_bits, max_ipa_bits);
> > > +
> > > +       if (ipa_bits > max_ipa_bits)
> > > +               die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
> >
> > I imagine it may not be immediately obvious to a kvmtool user what
> > this log line means, like what 'bits' are being referred to here.
> > Would it be more helpful to report the maximum allowed memory size for
> > the system, as derived from the max IPA?
>
> That's consistent with what "the other VMM" does as well.

Lol
> But sure,
> happy to amend the message if people feel strongly about it.

Eh, maybe not worth the extra math in the end. My nit would be to say
"needs %d IPA bits" in the message. But regardless:

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
