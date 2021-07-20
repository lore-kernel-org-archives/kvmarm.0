Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFDEC636C9
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C858061221
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C858061221
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 556354B159;
	Wed, 21 Jul 2021 08:20:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YtQSler+ItXF; Wed, 21 Jul 2021 08:20:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C34614B12C;
	Wed, 21 Jul 2021 08:20:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1D864B0BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 16:33:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DqpSVc32JNBb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 16:33:51 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AF054B0AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 16:33:51 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id
 h6-20020a17090a6486b029017613554465so315795pjj.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 13:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=mbKlAsXvTpB6CPeZ6j5yKIg+s519W2REhFMvJ3Fp/jY=;
 b=slX3auxMexaeHwyk0mKz1uilKpLlpoTuqzpNJc+VHWt3WlVTnT5roMCPMjNeSSmmmf
 vlN7qiE3u4ff9Y6BgWkCw7esNzcCYRsCYgq0VT71Zp1fY5rNt73mudCBUvu8hxnKfWsY
 zka5XhAXoTkCgF6EeTBRX6iVwn0bvtTLgrF2O2+CgzSDU8sJPnPhARaOZaeHAG8ptlo9
 DB+Kh3DeI4ElDDe8tk5Z8odZMnq+RVcv7rgKDQYclntIahLRa3cEixO0oGKe3WY8Zs7z
 xjr7nW7J6RSohxArSDj5CT/R0u35dcICTUlTE9edvsCN+XLFxo6F4gb5DgtZKkRKfMt4
 MnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mbKlAsXvTpB6CPeZ6j5yKIg+s519W2REhFMvJ3Fp/jY=;
 b=NVQ8MtIW5uIcGX6vt4Vh42s3P2YzDcjXsiLad9fo9jrSMlqf2ut1Wkk4tyVCwUAQ02
 bOJ0u/zRJS4ko1QK05upeUQRrCFAI4J/qWK0hI2LQ5EdhSZOiopjspw8F1KHPTMSqi6Q
 3drHIJhPKLceQABz3eajT/j0Smv9Rq3Vp0BJwJEqE6i2D8Gd54wMIsfrNdDCb5Y3dgg6
 xtIZ164U1sSrRyTOTgxH1iA6M5fEdGvgthrjsmo0J6mRBsdUFg0S65JEZMXCK620mbiX
 IaS//cD5OAny0SHXgUT+A31R1tpaHg8ibqnAvbhFVrBcyf1EJKOLjKezHU0J2npQRz4X
 H02g==
X-Gm-Message-State: AOAM5330Xp25HfzK+QGlLSfYGaT0d7S3OgXvl3Bd5fpHSuGsIG3PLh2d
 1C57me3BudTU5ChUKJOWxCZM0g==
X-Google-Smtp-Source: ABdhPJyMSwrO+FqXn2FlrNeBVin0MKCIdNEvJBnjFa2GWqgaDqwIZzphqJi1e3/3dpJWoJv94pwvDg==
X-Received: by 2002:a17:902:82c1:b029:12a:fb53:2038 with SMTP id
 u1-20020a17090282c1b029012afb532038mr24863288plz.6.1626813230190; 
 Tue, 20 Jul 2021 13:33:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id y4sm3648831pjg.9.2021.07.20.13.33.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 13:33:49 -0700 (PDT)
Date: Tue, 20 Jul 2021 20:33:46 +0000
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute
 the THP mapping size
Message-ID: <YPczKoLqlKElLxzb@google.com>
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
 <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com>
X-Mailman-Approved-At: Wed, 21 Jul 2021 08:20:04 -0400
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Jul 20, 2021, Alexandru Elisei wrote:
> Hi Marc,
> 
> I just can't figure out why having the mmap lock is not needed to walk the
> userspace page tables. Any hints? Or am I not seeing where it's taken?

Disclaimer: I'm not super familiar with arm64's page tables, but the relevant KVM
functionality is common across x86 and arm64.

KVM arm64 (and x86) unconditionally registers a mmu_notifier for the mm_struct
associated with the VM, and disallows calling ioctls from a different process,
i.e. walking the page tables during KVM_RUN is guaranteed to use the mm for which
KVM registered the mmu_notifier.  As part of registration, the mmu_notifier
does mmgrab() and doesn't do mmdrop() until it's unregistered.  That ensures the
mm_struct itself is live.

For the page tables liveliness, KVM implements mmu_notifier_ops.release, which is
invoked at the beginning of exit_mmap(), before the page tables are freed.  In
its implementation, KVM takes mmu_lock and zaps all its shadow page tables, a.k.a.
the stage2 tables in KVM arm64.  The flow in question, get_user_mapping_size(),
also runs under mmu_lock, and so effectively blocks exit_mmap() and thus is
guaranteed to run with live userspace tables.

Lastly, KVM also implements mmu_notifier_ops.invalidate_range_{start,end}.  KVM's
invalidate_range implementations also take mmu_lock, and also update a sequence
counter and a flag stating that there's an invalidation in progress.  When
installing a stage2 entry, KVM snapshots the sequence counter before taking
mmu_lock, and then checks it again after acquiring mmu_lock.  If the counter
mismatches, or an invalidation is in-progress, then KVM bails and resumes the
guest without fixing the fault.

E.g. if the host zaps userspace page tables and KVM "wins" the race, the subsequent
kvm_mmu_notifier_invalidate_range_start() will zap the recently installed stage2
entries.  And if the host zap "wins" the race, KVM will resume the guest, which
in normal operation will hit the exception again and go back through the entire
process of installing stage2 entries.

Looking at the arm64 code, one thing I'm not clear on is whether arm64 correctly
handles the case where exit_mmap() wins the race.  The invalidate_range hooks will
still be called, so userspace page tables aren't a problem, but
kvm_arch_flush_shadow_all() -> kvm_free_stage2_pgd() nullifies mmu->pgt without
any additional notifications that I see.  x86 deals with this by ensuring its
top-level TDP entry (stage2 equivalent) is valid while the page fault handler is
running.

  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
  {
	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
	struct kvm_pgtable *pgt = NULL;

	spin_lock(&kvm->mmu_lock);
	pgt = mmu->pgt;
	if (pgt) {
		mmu->pgd_phys = 0;
		mmu->pgt = NULL;
		free_percpu(mmu->last_vcpu_ran);
	}
	spin_unlock(&kvm->mmu_lock);

	...
  }

AFAICT, nothing in user_mem_abort() would prevent consuming that null mmu->pgt
if exit_mmap() collidied with user_mem_abort().

  static int user_mem_abort(...)
  {

	...

	spin_lock(&kvm->mmu_lock);
	pgt = vcpu->arch.hw_mmu->pgt;         <-- hw_mmu->pgt may be NULL (hw_mmu points at vcpu->kvm->arch.mmu)
	if (mmu_notifier_retry(kvm, mmu_seq)) <-- mmu_seq not guaranteed to change
		goto out_unlock;

	...

	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
	} else {
		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
					     __pfn_to_phys(pfn), prot,
					     memcache);
	}
  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
