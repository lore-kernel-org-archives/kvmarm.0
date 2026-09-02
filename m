Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19733AE190
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 10:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788343961; cv=none; b=Q3wyKUGq4KJ7ea40imd/dR/7XFBvyf7xCwt4QzPL7nNKheEXBDQCpB0Y4dUx9Ptjm97gYI2EC6rESXxYdIKHUHlvCjrrpeRKIA27IEYpuTKmrO0KuhxBucUvBgLGG+dzZlXuRLOpSqbmf/q1W1tHPEGbUSoI4yXu4ezahlxjzTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788343961; c=relaxed/simple;
	bh=WAV5GySQgV5zJK3fV42hf/X4XKvZR2TNrIIR65/Ii/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q67S7IlrvOY5lHUT4Nq9qCSppv42233fHkspA1Z1w9KuDjxeGLI9HOEG/MFCzxcvuF98Oz5Mn2ToT6npjdRd5vxI2INADWGzgwPMCXHH8tgEuKGC0f5Nhdn9JAXswptq634gs3AMG2DGx+3RVqNvJSCKCn3u0TuIeooOMvc85jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QvGJZjuX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QvGJZjuX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 978F1165C;
	Wed,  2 Sep 2026 03:12:34 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4343F3F882;
	Wed,  2 Sep 2026 03:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788343958; bh=WAV5GySQgV5zJK3fV42hf/X4XKvZR2TNrIIR65/Ii/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QvGJZjuXcefswVZMeXVpzZFWYLDCPY4NfBo2oEJ6eLUHq+gAqWIKw/uOcGoO9GPae
	 3z9256KeR1MmyNSGzfZ0fhgy6CpRK5EkhAU1silcMJeCLHZd4qOUtM0ZvI+xZhq++8
	 NnmmjoohY2pjIoVgViPORTaAN8Klu8+QnHO/0n5E=
Date: Wed, 2 Sep 2026 11:12:30 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 04/17] KVM: arm64: Introduce per-EC entry handlers for
 pKVM
Message-ID: <apf2jvCicXlw7JYP@e143914.arm.com>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-5-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163421.272420-5-fuad.tabba@linux.dev>

On Mon, Aug 31, 2026 at 05:34:08PM +0100, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Add an ESR_EL2.EC-indexed handler table, entry_hyp_vm_handlers[],
> consulted from flush_hyp_vcpu() on re-entry when the previous exit was
> a trap: sync_hyp_vcpu() records the exit reason in the hyp vCPU as
> exit_code, and the trap's exception class comes from its ESR_EL2.
> 
> Entry carries the host's requested PC updates to the hyp vCPU: add
> vcpu_copy_flag() to copy a masked set of flags between the two vCPU
> structures, with PC_UPDATE_REQ covering INCREMENT_PC and the
> pending-exception flags. The wholesale iflags copy moves into the
> non-protected branch; a protected vCPU takes only PC_UPDATE_REQ.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Not really looked at nVHE much (or pkvm ever), but:

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_host.h      | 19 +++++++++++++
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 ++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 39 +++++++++++++++++++++++---
>  3 files changed, 57 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7a..78a4d387f9fd4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1033,11 +1033,28 @@ struct kvm_vcpu_arch {
>  		set;						\
>  	})
>  
> +#define __vcpu_copy_flag(vt, vs, flagset, f, m)			\
> +	do {							\
> +		typeof(vs->arch.flagset) tmp, val;		\
> +								\
> +		__build_check_flag(vs, flagset, f, m);		\
> +								\
> +		val = READ_ONCE(vs->arch.flagset);		\
> +		val &= (m);					\
> +		__vcpu_flags_preempt_disable();			\
> +		tmp = READ_ONCE(vt->arch.flagset);		\
> +		tmp &= ~(m);					\
> +		tmp |= val;					\
> +		WRITE_ONCE(vt->arch.flagset, tmp);		\
> +		__vcpu_flags_preempt_enable();			\
> +	} while (0)
> +
>  #define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)
>  #define vcpu_set_flag(v, ...)	__vcpu_set_flag((v), __VA_ARGS__)
>  #define vcpu_clear_flag(v, ...)	__vcpu_clear_flag((v), __VA_ARGS__)
>  #define vcpu_test_and_clear_flag(v, ...)			\
>  	__vcpu_test_and_clear_flag((v), __VA_ARGS__)
> +#define vcpu_copy_flag(vt, vs, ...) __vcpu_copy_flag((vt), (vs), __VA_ARGS__)
>  
>  /* KVM_ARM_VCPU_INIT completed */
>  #define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(0))
> @@ -1055,6 +1072,8 @@ struct kvm_vcpu_arch {
>  #define INCREMENT_PC		__vcpu_single_flag(iflags, BIT(1))
>  /* Target EL/MODE (not a single flag, but let's abuse the macro) */
>  #define EXCEPT_MASK		__vcpu_single_flag(iflags, GENMASK(3, 1))
> +/* Cover both PENDING_EXCEPTION and EXCEPT_MASK for global operations */
> +#define PC_UPDATE_REQ		__vcpu_single_flag(iflags, GENMASK(3, 0))
>  /* Host-set: the hyp flushes the non-protected vCPU state in on entry */
>  #define PKVM_HOST_STATE_DIRTY	__vcpu_single_flag(iflags, BIT(4))
>  
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index c904647d2f760..49a0a992047ba 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -26,6 +26,9 @@ struct pkvm_hyp_vcpu {
>  	 * per-cpu pointer tracking us. Otherwise, NULL if not loaded.
>  	 */
>  	struct pkvm_hyp_vcpu **loaded_hyp_vcpu;
> +
> +	/* The previous exit's ARM_EXCEPTION_* code. */
> +	u32 exit_code;
>  };
>  
>  /*
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index b6bfe502bcd04..ca7122b0bccdd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -31,6 +31,17 @@ unsigned int hyp_gicv3_nr_lr;
>  
>  void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
>  
> +typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
> +
> +static void handle_vm_entry_generic(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	vcpu_copy_flag(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu, PC_UPDATE_REQ);
> +}

This is added here because the full copy of iflags was moved into the
!pkvm_hyp_vcpu_is_protected() section, so is needed temporarily until
each EC has its own handler.

Thanks,
Joey
