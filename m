Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4031991B9
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718392171; cv=none; b=ejYaBEp8Q0iCiDPDCRUyYEmSQq2KmFQFxOmdKDHXrR2OJkCAmqZfqPWXMX1tRUCzLZR6BWKJzGS9eH6GJce11VhewmkeeUJb5Nca3vqOOb0noDwO/hFpCq3Sctm4aIkfc14Fc8qLiui3N0DPM5QSufr41Y6z9AKr5DNpoXPjtag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718392171; c=relaxed/simple;
	bh=Wizhiytn4Lj3Shj2nqRLymOMjV8PCb5TMVol1RzlXWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvYLW+BTyPrHvDeP2n3SRWtkaGa3FV2XThvrlM7r14k2I2lWZ+AXPW8YgyNFhiVnHKupcM70mMv2yPxEEDC2CyYdXIe6blprPyEtQk2VJOsUKX0cOkWmA3HubvXSmg8XFNu73qOY79SanZtpUPSkUESeufTLpfFBYFnRFBkdJGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Uk/GR843; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uk/GR843"
X-Envelope-To: coltonlewis@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718392167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gkzyBBXAwCY3OzPK+SBz7H8Gt8fdJVI1ukS9jG1P/vI=;
	b=Uk/GR843p9Box6vvqsaHG5/Rl57kIPIH+lAwURbqN6EOIWpimaV5f9KvkM310qiACy/fNc
	PF75FHaijo3O9EY3HAqFx+oCi4Runo9dXFhJd2kbkY4muHk/tGFsh2SMz1XfHfJtfRDOzQ
	h/aEl6tewTosCcf3fTQYa/N0oN1Zs5k=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: corbet@lwn.net
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: linux-doc@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
Date: Fri, 14 Jun 2024 19:09:21 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v6] KVM: arm64: Add early_param to control WFx trapping
Message-ID: <ZmyVYQG_wC9rRonF@linux.dev>
References: <20240523174056.1565133-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523174056.1565133-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 23, 2024 at 05:40:55PM +0000, Colton Lewis wrote:
> Add an early_params to control WFI and WFE trapping. This is to
> control the degree guests can wait for interrupts on their own without
> being trapped by KVM. Options for each param are trap and notrap. trap
> enables the trap. notrap disables the trap. Note that when enabled,
> traps are allowed but not guaranteed by the CPU architecture. Absent
> an explicitly set policy, default to current behavior: disabling the
> trap if only a single task is running and enabling otherwise.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
> v6:
>  * Rebase to v6.9.1

As in from the stable tree? Please base your patches on an -rc tag, and
especially one from this release cycle.

> +static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
> +{
> +	if (likely(kvm_wfi_trap_policy == KVM_WFX_NOTRAP_SINGLE_TASK))
> +		return single_task_running() &&
> +			(atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
> +			 vcpu->kvm->arch.vgic.nassgireq);
> +
> +	return kvm_wfi_trap_policy == KVM_WFX_NOTRAP;
> +}

Generally, it is more readable to organize your code in such a way that
multiline statements are unnested as much as possible. So if you were to
invert the if condition it'd become a bit cleaner.

Here is what I plan on squashing into this patch,
kvm_vcpu_should_clear_twe() got the same treatment for the sake of
consistency.

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9cddd1096b0a..53e23528d2cf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -557,20 +557,20 @@ static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
 
 static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
 {
-	if (likely(kvm_wfi_trap_policy == KVM_WFX_NOTRAP_SINGLE_TASK))
-		return single_task_running() &&
-			(atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
-			 vcpu->kvm->arch.vgic.nassgireq);
+	if (unlikely(kvm_wfi_trap_policy != KVM_WFX_NOTRAP_SINGLE_TASK))
+		return kvm_wfi_trap_policy == KVM_WFX_NOTRAP;
 
-	return kvm_wfi_trap_policy == KVM_WFX_NOTRAP;
+	return single_task_running() &&
+	       (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
+		vcpu->kvm->arch.vgic.nassgireq);
 }
 
 static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
 {
-	if (likely(kvm_wfe_trap_policy == KVM_WFX_NOTRAP_SINGLE_TASK))
-		return single_task_running();
+	if (unlikely(kvm_wfe_trap_policy != KVM_WFX_NOTRAP_SINGLE_TASK))
+		return kvm_wfe_trap_policy == KVM_WFX_NOTRAP;
 
-	return kvm_wfe_trap_policy == KVM_WFX_NOTRAP;
+	return single_task_running();
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)

-- 
Thanks,
Oliver
