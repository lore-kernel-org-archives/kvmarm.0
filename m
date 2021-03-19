Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D97C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:39:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2476D64EEE
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:39:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2476D64EEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D48A4B6A1;
	Fri, 19 Mar 2021 06:39:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bZcSvZVDMlhv; Fri, 19 Mar 2021 06:39:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87A904B453;
	Fri, 19 Mar 2021 06:39:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1214B453
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:39:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lZn7u7NquSyZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:39:09 -0400 (EDT)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com
 [209.85.160.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C1FB4B422
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:39:09 -0400 (EDT)
Received: by mail-qt1-f173.google.com with SMTP id 94so6340765qtc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=SlzWXR71tvycP9uY2SQNcDnn0YNLniJ5Tlk+w3iHuhs=;
 b=IJ+C9hLxu0RA1xSAzafDUMHcT/zdjvFrcdlqN6BIzDXKuVmgDXRBVJ60vL90h9QG3X
 EyptujwQ3Gko5t0kS6obh/SsLJXW4QKV+wLOOdwIQdl3DXaJBNQpm1JhwWM9ZB1GEMFy
 6ySfIZJbb1/HVMZSBHW460yJK5saWIzHLEq+V5h1EAUqlWxAvGqV1WjXStjE+/oqIHy1
 BPTYgUE3fhqyeHEpAKyN7/bB6BcklHW7Nb7m8OR4XRroFioFS0k/btCZQzwbNobK0MSr
 lUKMphXo6uV8FjWl50kSVpr5+aOftdVPIEhdhdvMdGWvlMu7EtIdLrATdQNXCHz/R/5K
 wlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=SlzWXR71tvycP9uY2SQNcDnn0YNLniJ5Tlk+w3iHuhs=;
 b=W10XOPEveREvw6lU3i7FQE0kRKrlafHzz9Wzqsih8685DTuxQt7yWxa8L5cQdcZhZv
 h8vLMg/7Yncr5SsUnXLu7Q7cepZE50VtZ3EVJTCHExAwkAxIYBg3O4fKBDUjRo5mzWOx
 6zArftzDEyDI4Lz8kwYDMO+I3LWgoOD6HoQYV/kZIOAXzXrKq8slcxNPuCoailOONfXu
 1SuN4K4xSTkBbLui7SjXvlPZyEhzISPDzjPSvcBg4RaZ60XQtVyLafFv8efxmDN6OK3z
 Sbss5jaNfA/Nga0WPIfE16CLcr8fn9BHYFh3tYQ/y2LTI34zwtAVLhAieno8vLzIrgGy
 47cA==
X-Gm-Message-State: AOAM530Gnv5haouavUMaF/5xoeBdV91rY2JUCmqAaLRCCIw5qASl3cGK
 /NCJsdQbLHXFvfij0ZR0VNovaFlxzlKrKRuivfpg3A==
X-Google-Smtp-Source: ABdhPJxqO2L9w6/6sUvL7FZA17pv3PVdOKJl2hVBelz3F9QsNFymb0DmMBDL86qg95EzNDxCq1nwDqKRhog9bHV8Fgs=
X-Received: by 2002:a05:622a:9:: with SMTP id x9mr7610201qtw.189.1616150348993; 
 Fri, 19 Mar 2021 03:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210318143311.839894-1-ascull@google.com>
 <20210318143311.839894-6-ascull@google.com>
 <20210318165946.GA7656@willie-the-truck>
 <CADcWuH28yNVXwE5HyVSDcLLQKGesgZuXOKV1R0b7U2WVRV4PdA@mail.gmail.com>
In-Reply-To: <CADcWuH28yNVXwE5HyVSDcLLQKGesgZuXOKV1R0b7U2WVRV4PdA@mail.gmail.com>
From: Andrew Scull <ascull@google.com>
Date: Fri, 19 Mar 2021 10:38:57 +0000
Message-ID: <CADcWuH3aP8yWbh5mYbgEqjpqvRT8R6HFp814BiZevQAc_o-1+Q@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: Log source when panicking from nVHE hyp
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

> > > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > > index 90873851f677..7c17a67d2291 100644
> > > --- a/arch/arm64/include/asm/kvm_mmu.h
> > > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > > @@ -121,6 +121,8 @@ void kvm_update_va_mask(struct alt_instr *alt,
> > >  void kvm_compute_layout(void);
> > >  void kvm_apply_hyp_relocations(void);
> > >
> > > +#define __hyp_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
> >
> > Just a heads up: but Quentin's series moves this same macro, but to a
> > different header (arch/arm64/kvm/hyp/include/nvhe/memory.h)
>
> I can make sure we're putting it in the same header to ease the merge.

Seems I was too optimistic since nvhe/memory.h can only be used from
nVHE hyp. I could rebase no top of Quentin to move the macro somewhere
that can be used from here, but that would add a series dependency
that you usually seem to try and avoid so I'm not going to change
this, unless you'd prefer that I do.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
