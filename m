Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF1EC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 16:03:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4F44B3A9;
	Fri, 20 May 2022 12:03:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sib0W5gBLa4n; Fri, 20 May 2022 12:03:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14FD94B37B;
	Fri, 20 May 2022 12:03:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B3B74B374
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 12:03:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q08GL0ptRnuD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 12:03:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2A1E4B33C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 12:03:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CD621477;
 Fri, 20 May 2022 09:03:19 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E3013F73D;
 Fri, 20 May 2022 09:03:16 -0700 (PDT)
Date: Fri, 20 May 2022 17:03:29 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 33/89] KVM: arm64: Handle guest stage-2 page-tables
 entirely at EL2
Message-ID: <Yoe70WC0wJg0Vcon@monolith.localdoman>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-34-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220519134204.5379-34-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kernel-team@android.com,
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

Hi,

On Thu, May 19, 2022 at 02:41:08PM +0100, Will Deacon wrote:
> Now that EL2 is able to manage guest stage-2 page-tables, avoid
> allocating a separate MMU structure in the host and instead introduce a
> new fault handler which responds to guest stage-2 faults by sharing
> GUP-pinned pages with the guest via a hypercall. These pages are
> recovered (and unpinned) on guest teardown via the page reclaim
> hypercall.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
[..]
> +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +			  unsigned long hva)
> +{
> +	struct kvm_hyp_memcache *hyp_memcache = &vcpu->arch.pkvm_memcache;
> +	struct mm_struct *mm = current->mm;
> +	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> +	struct kvm_pinned_page *ppage;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct page *page;
> +	u64 pfn;
> +	int ret;
> +
> +	ret = topup_hyp_memcache(hyp_memcache, kvm_mmu_cache_min_pages(kvm));
> +	if (ret)
> +		return -ENOMEM;
> +
> +	ppage = kmalloc(sizeof(*ppage), GFP_KERNEL_ACCOUNT);
> +	if (!ppage)
> +		return -ENOMEM;
> +
> +	ret = account_locked_vm(mm, 1, true);
> +	if (ret)
> +		goto free_ppage;
> +
> +	mmap_read_lock(mm);
> +	ret = pin_user_pages(hva, 1, flags, &page, NULL);

When I implemented memory pinning via GUP for the KVM SPE series, I
discovered that the pages were regularly unmapped at stage 2 because of
automatic numa balancing, as change_prot_numa() ends up calling
mmu_notifier_invalidate_range_start().

I was curious how you managed to avoid that, I don't know my way around
pKVM and can't seem to find where that's implemented.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
