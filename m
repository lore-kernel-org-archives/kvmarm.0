Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640488;
	b=nikaOo2NKdyfiSYscbY6Kpx0h91cOeca353VJZ4HuKz+tGLTg5gAHwYB+EMh6VGQebZ1
	 fUJYO1pliBNCvu41GITnColndL3mw1t7r3/8zMBUUPYFR/VLrRAWSXIDnK5EFkKZYUOp6
	 V2bBP/KUuOaaJFaBxV8t+OAEgJARxovOdE3E/BMEIelUhOkTdzW67or7LpAYBMVO7/8wS
	 pcibzFzCRl1r5X/RLZrMM4wL4NUr2gwD1m9ivJbGX2QZyz/B53fVAMt9zVXXJf6O2Es6i
	 AWrQANcCFepu5D9OHR7CZuEGET3muU8pKTseIEUKU5/GDixofG9kXSK4I3Aymr9Fl3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640488;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=nPRUQ+xTLvtD/Pj4JiL4QlUUNFgbAg2ee1MpctCwnho=;
	b=LmoPvbD7mswenCMuRJKeXpOOC2iXhMk1sYwEvr5Cz/20n74GfJebdQtRYPpYMkjmDOLk
	 BQsfTIw4nEXSDolxeDXnmwpM0sOFL1bBheJBJZbyAYrS8jqUUfjh2lQEL4O3HT4x6Guhr
	 1nR/A92F+v0VtGrXO1EDvU9IJ/NLSNitM1x5dwq2wQnyRciLxg6AsGsZBKiXpMyka8OBR
	 CDYAtuBi7Al1Esw6V9fVPKkZOfSCq7OPe1bYZGsA3gmCucFocmdywuhoF1zwIVwOC2l7/
	 lMNe5SHd4XBYVlE0GFm0/ZRZ2vg/TB/mn6Xk6XmJt3Yj/6+upHq2KAJIIkPCsNc9GAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CSMdTmYm;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11ACD606E021
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 17:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11ACD606E021
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CSMdTmYm
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3588716F3;
	Mon,  2 Nov 2026 09:28:04 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C51043F59E;
	Mon,  2 Nov 2026 09:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793640487; bh=SOd+aVHF6WihHK1ddzjUEya6Le5syiM79M8tVeFOlgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSMdTmYmPGvh971jyseGXnawVbybj9i/u1NiVaCp4iKaTzoX441AtvLnZF4mvfqdj
	 /e3Bj+WjEttuIjd08394XX8OStanC/TnC0WiZpA/QjC3f93dPBQhrJHCHJ4bQPKAuk
	 R8cPiAL6VvyIVlIAHkzbnYdMS4J4Xt0gYu05N3yM=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 04/28] KVM: arm64: nv: Only shadow writable-dirty guest descs as writable
Date: Mon,  2 Nov 2026 17:27:57 +0000
Message-ID: <aujIHS0eD6P-Grz-@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-5-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-5-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 23, 2026 at 01:55:46PM -0700, Oliver Upton wrote:
> KVM will soon add support for hardware dirty state management for nested
> guests. In order to emulate dirty state transitions on the guest
> desciptor, KVM will need to use read-only hardware mappings and re-walk
> the guest page tables upon taking a permission fault.
> 
> Prepare by limiting shadow stage-2 and shadow VNCR translations to
> read-only for writable-clean guest translations.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h |  2 ++
>  arch/arm64/kvm/at.c                 |  2 ++
>  arch/arm64/kvm/mmu.c                |  2 +-
>  arch/arm64/kvm/nested.c             | 15 +++++++++++----
>  4 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 01645a5b224f..e8d5ae7afb9a 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -100,6 +100,7 @@ struct kvm_s2_trans {
>  	u32		esr;
>  	bool		writable;
>  	bool		readable;
> +	bool		dirty;
>  	bool		px;
>  	bool		ux;
>  };
> @@ -344,6 +345,7 @@ struct s1_walk_result {
>  			bool	pr;
>  			bool	pw;
>  			bool	px;
> +			bool	dirty;
>  		};
>  		struct {
>  			u8	fst;
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 12ffd54be2b8..4e505433299b 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1315,6 +1315,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
>  			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
>  	wr->pw &= !pan;
>  	wr->pr &= !pan;
> +	wr->dirty = !(wr->desc & BIT(7));
>  }
>  
>  static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
> @@ -1673,6 +1674,7 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	if (wr->level == S1_MMU_DISABLED) {
>  		wr->ur = wr->uw = wr->ux = true;
>  		wr->pr = wr->pw = wr->px = true;
> +		wr->dirty = true;
>  	} else {
>  		ret = walk_s1(vcpu, wi, wr, va);
>  		if (ret)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cbf3cfb426ba..84aa1bb31095 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1703,7 +1703,7 @@ static int topup_mmu_memcache(struct kvm_s2_mmu *mmu, void *memcache)
>  static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
>  						       enum kvm_pgtable_prot prot)
>  {
> -	if (!nested->writable)
> +	if (!(nested->writable && nested->dirty))
>  		prot &= ~KVM_PGTABLE_PROT_W;
>  	if (!nested->readable)
>  		prot &= ~KVM_PGTABLE_PROT_R;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 15c22a218609..9b2ea83aeccd 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -288,6 +288,8 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
>  
>  	trans->readable = s2ap & BIT(0);
>  	trans->writable = s2ap & BIT(1);
> +
> +	trans->dirty = ws->desc & BIT(7);
>  }
>  
>  /*
> @@ -1587,6 +1589,11 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
>  	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
>  }
>  
> +static bool vncr_can_map_writable(struct vncr_tlb *vt)
> +{
> +	return vt->wr.pw && vt->wr.dirty && vt->hpa_writable;
> +}

Why do we require the page to be dirty to be considered writable?

Thanks!
Leo

> +
>  static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  {
>  	struct kvm_memory_slot *memslot;
> @@ -1683,10 +1690,10 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  		atomic_set(&vt->cpu, -1);
>  
>  		kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu);
> -		kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw && vt->hpa_writable);
> +		kvm_release_faultin_page(vcpu->kvm, page, false, vncr_can_map_writable(vt));
>  	}
>  
> -	if (vt->wr.pw && vt->hpa_writable)
> +	if (vncr_can_map_writable(vt))
>  		mark_page_dirty(vcpu->kvm, gfn);
>  
>  	return 0;
> @@ -1781,7 +1788,7 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
>  		kvm_inject_nested_sync(vcpu, esr);
>  		break;
>  	case 0:
> -		perm = kvm_is_write_fault(vcpu) ? vt->wr.pw && vt->hpa_writable : vt->wr.pr;
> +		perm = kvm_is_write_fault(vcpu) ? vncr_can_map_writable(vt) : vt->wr.pr;
>  		if (!perm)
>  			handle_vncr_perm(vcpu);
>  		break;
> @@ -1824,7 +1831,7 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
>  	if (vt->wr.nG && get_asid_by_regime(vcpu, TR_EL20) != vt->wr.asid)
>  		return;
>  
> -	if (vt->hpa_writable && vt->wr.pw && vt->wr.pr)
> +	if (vncr_can_map_writable(vt) && vt->wr.pr)
>  		prot = PAGE_KERNEL;
>  	else if (vt->wr.pr)
>  		prot = PAGE_KERNEL_RO;
> -- 
> 2.47.3
> 
