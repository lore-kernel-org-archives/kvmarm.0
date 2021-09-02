Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34292C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 21:01:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D19A261074
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 21:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D19A261074
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 730474B10B;
	Thu,  2 Sep 2021 17:01:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IJLRwAvCcDmK; Thu,  2 Sep 2021 17:01:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1138A4B121;
	Thu,  2 Sep 2021 17:01:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BAE54B10A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 15:22:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cnZkpUFxE2uX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 15:22:44 -0400 (EDT)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4B214A524
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 15:22:44 -0400 (EDT)
Received: by mail-pl1-f178.google.com with SMTP id q21so1841205plq.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 12:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uNPtW+6uA+IorMmx89tZvAje5LA6sRmLTggdZeiUpKQ=;
 b=DUPBVsET97fo8gZE+12RRIe3oBglmGvYRDpWjPC2p+hbEXLBsAYdQvDjInkq6gYd9W
 aD0keO3ba193KwUAVcMMcw+goFfB2DAN7bF6mvu7quwJ39X0u0GDdq6d0OOhIGbnCvNx
 jE0qJTjzRRm6E8cO1WHrwHdmnAAbN2EB+EIKY49b88wbvHWGVELVHCLjaPF8+CX3gjAG
 a4OToBU85qyLrfFq90ge6iKk8oVInT2Lj4C0lF3v/U7veqJLjRlG/5Jd9L1Rhtw1lTsU
 qi+PWSS7OrPNvrRmJQp/0Rnc2emt5+f/oh+VuZc/SgzPRcMJG/Qe1jrYCg1dxv07hOOU
 Ae6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uNPtW+6uA+IorMmx89tZvAje5LA6sRmLTggdZeiUpKQ=;
 b=mvvF1TBIg63VekM9ONNp1talZ1g2Jzg26va9QpP9PapIf5G09p4nBopCe/2TTARBVW
 PnZheS3qhCjd2f/zy2gCBipseKfgfOo/D4sQkqjmZ7/AsCqPe5e2bRmTvxhsEVs4sj0R
 zO87Hs2h4k8+4coNmYM5bmKZqfG8b1Q2ezOBnIS+8DGvfRuakWTS2CZ2HYk96zLW9i8m
 12qKybXx+JwmbOPgVzrokLivxm+xUwxyPnx9yblwLmYGgM7C/esq0B+CsMmLz45AgKwX
 jd2op2J4Sauzoo3Xbldi0ZPWVRksoIybqDBLTWI6ZAzY70+1w+1XFPOBFzICL8HyVA4E
 7h4A==
X-Gm-Message-State: AOAM530IdhFcdvEi/XWVFAJCh5c9gD17YV77vC4kVHQpAKe1EXq2jAKR
 RQlP4cb2AVFvfHkEtZQJW8JdGQ==
X-Google-Smtp-Source: ABdhPJyA+Ul43RLuBvaJkLgS2mR6ljKmyKfNqIQzvT0/kC56lZBa3GlaBfo3GRItE1F4k7nstvQBhg==
X-Received: by 2002:a17:90a:ad02:: with SMTP id
 r2mr5529728pjq.182.1630610563431; 
 Thu, 02 Sep 2021 12:22:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id x75sm3674726pgx.43.2021.09.02.12.22.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 12:22:42 -0700 (PDT)
Date: Thu, 2 Sep 2021 19:22:39 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v7 4/6] KVM: x86: Take the pvclock sync lock behind the
 tsc_write_lock
Message-ID: <YTEkf3wn/PbVpYni@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-5-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210816001130.3059564-5-oupton@google.com>
X-Mailman-Approved-At: Thu, 02 Sep 2021 17:01:18 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Mon, Aug 16, 2021, Oliver Upton wrote:
> A later change requires that the pvclock sync lock be taken while
> holding the tsc_write_lock. Change the locking in kvm_synchronize_tsc()
> to align with the requirement to isolate the locking change to its own
> commit.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/locking.rst | 11 +++++++++++
>  arch/x86/kvm/x86.c                 |  2 +-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> index 8138201efb09..0bf346adac2a 100644
> --- a/Documentation/virt/kvm/locking.rst
> +++ b/Documentation/virt/kvm/locking.rst
> @@ -36,6 +36,9 @@ On x86:
>    holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
>    there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
>  
> +- kvm->arch.tsc_write_lock is taken outside
> +  kvm->arch.pvclock_gtod_sync_lock
> +
>  Everything else is a leaf: no other lock is taken inside the critical
>  sections.
>  
> @@ -222,6 +225,14 @@ time it will be set using the Dirty tracking mechanism described above.
>  :Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
>  		migration.
>  
> +:Name:		kvm_arch::pvclock_gtod_sync_lock
> +:Type:		raw_spinlock_t
> +:Arch:		x86
> +:Protects:	kvm_arch::{cur_tsc_generation,cur_tsc_nsec,cur_tsc_write,
> +			cur_tsc_offset,nr_vcpus_matched_tsc}
> +:Comment:	'raw' because updating the kvm master clock must not be
> +		preempted.
> +
>  :Name:		kvm_arch::tsc_write_lock
>  :Type:		raw_spinlock
>  :Arch:		x86
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b1e9a4885be6..f1434cd388b9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2533,7 +2533,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
>  
>  	kvm_vcpu_write_tsc_offset(vcpu, offset);
> -	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  
>  	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
>  	if (!matched) {
> @@ -2544,6 +2543,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  
>  	kvm_track_tsc_matching(vcpu);
>  	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);

Drop the irqsave/irqrestore in this patch instead of doing so while refactoring
the code in the next patch.

> +	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  }
>  
>  static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
> -- 
> 2.33.0.rc1.237.g0d66db33f3-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
