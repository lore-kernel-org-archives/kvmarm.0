Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD32525A88
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788806535; cv=none; b=fZ5mxJey00oEk+tvsiAWnRReeb3LwnqsFBt0d/Ktqr6o/+a4TO+DRAYuH3aswnQ0o9MiuTr7kuWHjvQJkKZvg4PIJrAkHNYR6kfvPjo+10Jzu8ZYL6HKxttj94DKIJgF5Fu07i/gebEoDpIzfbjhl/yIgwHIbct3cOo2qYp03H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788806535; c=relaxed/simple;
	bh=oOAJaNc8fwgBRGZou+YwG8GwcsoIvMJQ0k0a4TIZy/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBEoj7nSkAQFbSXFtC10p7qITA7jrazLitFaeUeIVE/FkKUFCCky//ZNECpzHi4rMRYXXzV90toZBNAIiEYIPcZNQmPM3RV5wFmg7r3iiHz3IefFVF+rg1A/MqiASawq9uNFvFveIxUSoDC6w3wTt+JLRS9EcS6awHhHD9FOpVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M5eaoEi/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M5eaoEi/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 986621476;
	Mon,  7 Sep 2026 11:41:45 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D57603F528;
	Mon,  7 Sep 2026 11:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788806509; bh=oOAJaNc8fwgBRGZou+YwG8GwcsoIvMJQ0k0a4TIZy/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M5eaoEi/0DWd2TdnMuk/JswwJZj75WRus7Ql1q+5a2MSL7qzb/IUiyPVu96k0DJxc
	 /UZNp1gsDy7VWFjgwh4krvW93L0Kit1sFpSeJbc3tYtwkog3asHDgLkWUJzqbcLQcs
	 r6ju8NUwqY2QKPfOpCHSesZ/5AD1JYKFD4kynPx4=
Date: Mon, 7 Sep 2026 19:41:30 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 00/20] Huge mapping support for protected VMs
Message-ID: <g46hgnsj7rltrqzfmm7lgkdxteaxositebvrpasyjwesygwmq7@mcustodfb26v>
References: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>

Hi Vincent,

On Mon, Aug 03, 2026 at 11:08:44AM +0100, Vincent Donnefort wrote:
> Currently, pKVM handles stage-2 mappings and ownership tracking strictly
> at the PAGE_SIZE level. This series extends pKVM to support PMD_SIZE
> block mappings, thereby enabling Transparent Huge Pages (THP) for
> protected guests. hugetlbfs is currently unsupported as it does not
> appear as swapbacked.
> 
> Summary of changes:
> 
> 1. Enable host stage-2 block-level annotations:
> 
> The host stage-2 being annotated with the GFN of the guest on the
> host->guest donation transitions, we allow block-level annotations to
> ensure the host stage-2 mapping size matches the guest stage-2.
> 
> 2. Expand ownership transition HVCs:
> 
> Enable the ownership test to work with PMD_SIZE so we can test
> transitions supporting more than PAGE_SIZE.
> 
> 3. Implements the `PKVM_HYP_REQ_SPLIT` hypervisor request:
> 
> Allows the hypervisor to ask the host to split a mapping. This ensures
> the guest s2, pkvm_mapping tree and host s2 are always using the same
> mapping size.
> 
> 4. Wires up THP support for pKVM guests.
> 
> Keir Fraser (1):
>   KVM: arm64: Prefault host stage-2 entries on block split
> 
> Vincent Donnefort (19):
>   KVM: arm64: Propagate host stage-2 annotated entries on block split
>   KVM: arm64: Allow block-level stage-2 annotation
>   KVM: arm64: Use block-level annotations when setting up the host
>     stage-2
>   KVM: arm64: Make pKVM ownership selftest an HVC
>   KVM: arm64: Add a range to __pkvm_host_share/unshare_hyp()
>   KVM: arm64: Add a range to __pkvm_host_donate_guest()
>   KVM: arm64: Add a range to __pkvm_host_reclaim_page_guest()
>   KVM: arm64: Add a range to __pkvm_guest_share_host()
>   KVM: arm64: Add a range to __pkvm_guest_unshare_host()
>   KVM: arm64: Add a range to pKVM ownership selftest
>   KVM: arm64: Handle huge mappings in
>     __pkvm_host_force_reclaim_page_guest()
>   KVM: arm64: Handle huge mappings in __pkvm_vcpu_in_poison_fault()
>   KVM: arm64: pkvm: Warn on guest stage-2 block collapse
>   KVM: arm64: Add pkvm_hyp_req infrastructure
>   KVM: arm64: Add __pkvm_host_split_guest HVC
>   KVM: arm64: Extend pKVM page ownership selftests to cover guest block
>     split
>   KVM: arm64: Add PKVM_HYP_REQ_SPLIT
>   KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing
>   KVM: arm64: Stage-2 huge mappings for protected VMs
> 
>  arch/arm64/include/asm/kvm_asm.h              |  12 +-
>  arch/arm64/include/asm/kvm_host.h             |  19 +
>  arch/arm64/include/asm/kvm_pgtable.h          |   3 +-
>  arch/arm64/include/asm/kvm_pkvm.h             |  21 +-
>  arch/arm64/kvm/arm.c                          |   2 +
>  arch/arm64/kvm/handle_exit.c                  |   3 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  25 +-
>  arch/arm64/kvm/hyp/include/nvhe/memory.h      |   5 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   6 +-
>  arch/arm64/kvm/hyp/nvhe/ffa.c                 |  12 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  47 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 545 ++++++++++++------
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  59 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c               | 152 +++--
>  arch/arm64/kvm/hyp/pgtable.c                  | 113 +++-
>  arch/arm64/kvm/mmu.c                          |  72 ++-
>  arch/arm64/kvm/pkvm.c                         | 247 +++++++-
>  arch/arm64/kvm/trace_pkvm.h                   |  44 ++
>  18 files changed, 1036 insertions(+), 351 deletions(-)
>  create mode 100644 arch/arm64/kvm/trace_pkvm.h

The patches in this series are missing per patch stats like this here.
I would recommend including that to help reviewing.

Thanks,
Wei-Lin Chang

> 
> 
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
> -- 
> 2.55.0.508.g3f0d502094-goog
> 
