Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43534486B8C
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174322; cv=none; b=LBPXEaOhEa8QxR6q0GFxqqoYsu4FRUyrfOK4lmKjEgq5IF1fYI8AuxD7iVb37ilbgev9Wg7VGROU3Ic40gQCNbqM9OZXj6lfppLFwRpIIuQ/NzW9E8GYhiv1m3OclNpBn4NaehG6WyjMG8+RxflIZW3LVKSpxYLRe131FsgwvBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174322; c=relaxed/simple;
	bh=7bFq1iAGeG7O4B0c+8iqpiwWQIPSD1yumWXoRxCSySk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=UK9Cf6nFHhyFrnVPs9Bus4E0OrmjXnLdPq6cwqO5BvM7gooilLOmrBoXlJH7m5QZk2+vocMmd69WaZsmfL4IQl5HCBKtJYLxCOzl1EHEQe3xboELHp5UdIk4xBpuEHr2qhXvPmrnPf7HKx9L4znco4YOU43NpumHt31BrK0AxeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xlwcr1a/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xlwcr1a/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02E52152B;
	Wed, 23 Sep 2026 07:38:36 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50A313F86C;
	Wed, 23 Sep 2026 07:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790174319; bh=7bFq1iAGeG7O4B0c+8iqpiwWQIPSD1yumWXoRxCSySk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xlwcr1a/AsJkK1o9q5jdf6mdFMPKN7Xsz5O30PDj69exHZXHpvVjEk7tw4IxdMTdu
	 F7k8142VElEuz0QAUBwX1EneDz4yMTU4Fc86Y7cn/w1wSHSYHVAL7MgNruf6/CP+Eg
	 JrjxV7+fybOXDKvWgA0YNB1brL32aIsScCzW8sOo=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 08/22] KVM: arm64: nv: Treat DBM as writable at stage-2
Date: Wed, 23 Sep 2026 15:38:36 +0100
Message-ID: <arPka0PldKvd0jzc@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-9-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-9-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:47AM -0700, Oliver Upton wrote:
> When using direct permissions, the DBM bit has the effect of granting
> the write permission. And, depending on the access, it could grant write
> permission without a dirty state update.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  1 +
>  arch/arm64/kvm/nested.c              | 11 +++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 22aeb2ed18d1..6ae36973686c 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -94,6 +94,7 @@ typedef u64 kvm_pte_t;
>  #define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
>  
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
> +#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
>  
>  #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
>  
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index e5a407fc0880..4f13f37e560b 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -305,6 +305,17 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
>  		break;
>  	}
>  
> +	/*
> +	 * Descriptors with the DBM bit set while hardware dirty state are
> +	 * considered writable, even though certain accesses (like AT instructions)
> +	 * don't actually update the dirty state.
> +	 *
> +	 * Assume that walk_nestd_s2_pgd() made the necessary descriptor updates
> +	 * for the access and just treat DBM as writable here.
> +	 */
> +	if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> +		s2ap |= BIT(1);
> +
>  	trans->readable = s2ap & BIT(0);
>  	trans->writable = s2ap & BIT(1);
>  
> -- 
> 2.47.3
> 


Okay, now I see why were you doing that on the previous patch.

Here you test DBM and set writable to 1, and change nothing else, as s2ap 
is a local variable that is only used to set writable if DBM is set.

This feels weird, though. That way it looks like DBM is changing s2ap, 
which is not.

I suggest doing something like:

+     if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
+             trans->writable = true;
+
       trans->readable =  s2ap & BIT(0);
-      trans->writable = s2ap & BIT(1);
+      trans->writable |= s2ap & BIT(1);

Although, this is odd, as S2AP[1] is supposed to be the dirty-bit.
Maybe it's fine, as in our case, dirty implies writable.

IHMO, the best approach to this would be to make the movement to 
DBM = writable, then have something like:

+	trans->readable =  s2ap & BIT(0);
+	trans->dirty    =  s2ap & BIT(1);
+	trans->writable =  ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM;

+	/* Dirty implies on writable, was used alone on older systems */
+	trans->writable |= trans->dirty;

(And we assume DBM always means writable, and not only when VTCR_EL2.HD=1.

What do you think?

Thanks!
Leo

