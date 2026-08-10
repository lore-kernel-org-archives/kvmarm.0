Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A383FBEB8;
	Mon, 10 Aug 2026 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373293; cv=none; b=awt3Z5hUWvVYB4eM0L9yxfSeONHd0gXi+sB5N4hY92SmdozqSYdRWokmMyHfAMB7gr5Sb0QQhMzXeyVF2QZlrlgjoyXKU2Uy5wFRR0qEWx5UCtvbqNCIr2R8HCDtUl6UK96Bj5/Hpe59MB/l2+XfulnB5Cz8xcLnv1h3m/bWQi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373293; c=relaxed/simple;
	bh=99XkH2IMF7D6nyHbHISy+8bb2LKxW8tAVwIQzhTqFok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bf1FW2VRQuVv5usqraMyC8ZlZsIJIAixgdnwEMrWbjQzEKQbnXdIzJC4izpkfbjapl4pVAGiUi9EcWlqswCpsjftzeInRMq0Kt3G5gdoIxajnrzz3QsZ7wiwOE6FikBxDqzEduykF2dVRk1oYYex3FKpwZ4lAKZZd6eVRmFFAME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=bLxON1m2; arc=none smtp.client-ip=139.138.36.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="bLxON1m2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1786373291; x=1817909291;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=99XkH2IMF7D6nyHbHISy+8bb2LKxW8tAVwIQzhTqFok=;
  b=bLxON1m25lhmqq5s+fq8ZyWgOE28SoKe/4uudolfQ/HOZ0QV4BWKeyqy
   cz/Lr+SrMW/cUAyQCG2K0MxFssJZ6ENlJzSOnnjVQsgRNFNQPQfJl5W7k
   /lZwbqnJB8DYsWvRMIvgDvVcTQmkStd9KgX/XsZrCmjAq2MG1lVqPqvU+
   HZNt1OgXgd1EICFPmcUF+PqJgviVQxy6SPB6A2TtvzfMDpYt/OaW/4lkT
   BamBKg+TChJcLo2CV+uoTMFjZzWUaoWoNkM2Qp2zSLlyvf02n19fY0X1e
   2CdX2ra9Po1Qz2bvtI43Q6R0dWe40yJgTSJRVFtkDvE7b1u2UtKJxk3mk
   A==;
X-CSE-ConnectionGUID: bf/0rBchSAus2RW8RYT+ZA==
X-CSE-MsgGUID: lKLUCAGuQAKmzMksAH8CQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="237901631"
X-IronPort-AV: E=Sophos;i="6.25,215,1779116400"; 
   d="scan'208";a="237901631"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 23:47:00 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 3E6691000340;
	Mon, 10 Aug 2026 14:47:00 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (unknown [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id E906CC09656;
	Mon, 10 Aug 2026 14:46:59 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.24.243])
	by az2uksmom2.o.css.fujitsu.com (Postfix) with SMTP id 503D314000B0;
	Mon, 10 Aug 2026 14:46:52 +0000 (UTC)
Date: Mon, 10 Aug 2026 23:46:50 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 30/45] KVM: arm64: CCA: Handle realm vCPU load
Message-ID: <annfY97FFA8ZuoHE@FCCLS0092175.localdomain>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-31-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260803134403.80630-31-steven.price@arm.com>

On 08/03 14:43, Steven Price wrote:
> When loading a realm VCPU much of the work is handled by the RMM so only
> some of the actions are required. Rearrange kvm_arch_vcpu_load()
> slightly so we can bail out early for a realm guest.

Hi Steven,

I found that Realm guests can execute WFI/WFE instructions without
causing a REC exit, ignoring KVM's WFx trap policy.

I'd suggest translating HCR_EL2.TWE/TWI into the corresponding
run->enter.flags to honor the policy. Below is the patch I tested.

----
From 8637cd6f818a3c56d8b898a72874e9485eb94e59 Mon Sep 17 00:00:00 2001
From: Kohei Enju <enju.kohei@fujitsu.com>
Date: Mon, 10 Aug 2026 22:54:27 +0900
Subject: [PATCH] KVM: arm64: CCA: Honor WFx trap policy for Realm vCPUs

Propagate KVM's WFx trap policy to the RMM by translating
HCR_EL2.TWE/TWI into REC_ENTER TRAP_WFE/WFI flags before entering a REC.

Without this, guests can execute WFE/WFI instructions without causing a
REC exit, ignoring KVM's common trap policy. Configure the REC_ENTER
flags to honor the policy.

Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
---
 arch/arm64/include/asm/kvm_rmi.h |  2 ++
 arch/arm64/kvm/arm.c             |  3 +++
 arch/arm64/kvm/rmi.c             | 14 ++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 2789879b6701..b858c6b4db6a 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -109,6 +109,8 @@ void kvm_destroy_realm(struct kvm *kvm);
 int kvm_realm_teardown_stage2(struct kvm *kvm);
 void kvm_destroy_rec(struct kvm_vcpu *vcpu);
 
+void kvm_rec_set_wfx_traps(struct kvm_vcpu *vcpu);
+
 int kvm_rec_enter(struct kvm_vcpu *vcpu);
 int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
 int kvm_rec_handle_request(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7edc572dd8ab..0cba333b4fd2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -770,6 +770,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	else
 		vcpu->arch.hcr_el2 |= HCR_TWI;
 
+	if (vcpu_is_rec(vcpu))
+		kvm_rec_set_wfx_traps(vcpu);
+
 	vcpu_set_pauth_traps(vcpu);
 
 	if (is_protected_kvm_enabled()) {
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index c242dfc2c7a6..c472f3d03234 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1302,6 +1302,20 @@ static void noinstr load_realm_timer_state(struct kvm_vcpu *vcpu)
 	write_sysreg_el0(rec_exit->cntp_ctl, SYS_CNTP_CTL);
 }
 
+void kvm_rec_set_wfx_traps(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	rec->run->enter.flags &=
+		~(REC_ENTER_FLAG_TRAP_WFE | REC_ENTER_FLAG_TRAP_WFI);
+
+	if (vcpu->arch.hcr_el2 & HCR_TWE)
+		rec->run->enter.flags |= REC_ENTER_FLAG_TRAP_WFE;
+
+	if (vcpu->arch.hcr_el2 & HCR_TWI)
+		rec->run->enter.flags |= REC_ENTER_FLAG_TRAP_WFI;
+}
+
 int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
-- 
2.43.0

> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/arm.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f1b26b263bf0..96e536d2dda8 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -707,7 +707,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	struct kvm_s2_mmu *mmu;
>  	int *last_ran;
>  
> -	if (is_protected_kvm_enabled())
> +	if (is_protected_kvm_enabled() || kvm_is_realm(vcpu->kvm))
>  		goto nommu;
>  
>  	if (vcpu_has_nv(vcpu))
> @@ -751,12 +751,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	kvm_vgic_load(vcpu);
>  	kvm_vcpu_load_debug(vcpu);
>  	kvm_vcpu_load_fgt(vcpu);
> -	if (has_vhe())
> -		kvm_vcpu_load_vhe(vcpu);
> -	kvm_arch_vcpu_load_fp(vcpu);
> -	kvm_vcpu_pmu_restore_guest(vcpu);
> -	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
> -		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>  
>  	if (kvm_vcpu_should_clear_twe(vcpu))
>  		vcpu->arch.hcr_el2 &= ~HCR_TWE;
> @@ -778,6 +772,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  			     &vcpu->arch.vgic_cpu.vgic_v3);
>  	}
>  
> +	/* No additional state needs to be loaded on Realmed VMs */
> +	if (vcpu_is_rec(vcpu))
> +		return;
> +
> +	if (has_vhe())
> +		kvm_vcpu_load_vhe(vcpu);
> +	kvm_arch_vcpu_load_fp(vcpu);
> +	kvm_vcpu_pmu_restore_guest(vcpu);
> +	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
> +		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> +
>  	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
>  		vcpu_set_on_unsupported_cpu(vcpu);
>  
> -- 
> 2.43.0
> 
