Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090B212BF02
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 17:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732123889; cv=none; b=WDn0uPpsG8SnThyJYrHgvjqletFyczaiaNjvBWqSfyCGaw6fcjDpuy8+LnPmTdZKjEt/0Dhl/bJzyFMQDYiMOxGJi1JtEnDceVc3h+ZHLG/PD9w+GYLa7Vs36ne/bRZ5KUgX/DHl7lyUrhlNk1zSpV0MQegkUVL47Tzd0+zm3jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732123889; c=relaxed/simple;
	bh=52UlUca83BCJ4bTbpXzo0dcf4hoWvy6v64cKcaFXNeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFtQ+xNxiAdaf7mio0b897RKuGboieh9YYE+T13gUyKKsO808FCFEOPzmatC/pxrMG1eA5Qn0/8PYkyGbDs3mG0D0oL/elfA+Izb2hoL+BjnRwuuA0yEQskai3NAcEqMsV14QTDwAh7mazkdqxUDJjEa3cfGT0BJ8l71AlNGqdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O/wq2KL5; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O/wq2KL5"
Date: Wed, 20 Nov 2024 17:31:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732123885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tnHduo24AdOoAdI77IZf7s1iLW4IzFa8VA+z+Tg/Y28=;
	b=O/wq2KL5Z4g46tyl35oMSphCNZCGWzeMbieD+t20CV6A6f2SqjodzFgD/GhtOEJIk3dJk/
	UKVmbib2LnSuMj/Z2ga8+AMytY/UiXA7lZOwSE88ZuYHRBhzkesDozYmEeBzGudItwH5ST
	lKzeWILaG+QtwK18R45dAx/ba18969Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@linaro.org>
Cc: suzuki.poulose@arm.com, coresight@lists.linaro.org,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>, Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>, Mark Brown <broonie@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 11/12] KVM: arm64: Swap TRFCR on guest switch
Message-ID: <Zz4c5LmQnK2SD5HO@linux.dev>
References: <20241112103717.589952-1-james.clark@linaro.org>
 <20241112103717.589952-12-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112103717.589952-12-james.clark@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 12, 2024 at 10:37:10AM +0000, James Clark wrote:
> +void kvm_set_trfcr(u64 host_trfcr, u64 guest_trfcr)
> +{
> +	if (kvm_arm_skip_trace_state())
> +		return;
> +
> +	if (has_vhe())
> +		write_sysreg_s(guest_trfcr, SYS_TRFCR_EL12);
> +	else
> +		if (host_trfcr != guest_trfcr) {
> +			*host_data_ptr(host_debug_state.trfcr_el1) = guest_trfcr;

Huh? That's going into host_debug_state, which is the dumping grounds
for *host* context when entering a guest.

Not sure why we'd stick a *guest* value in there...

> +			host_data_set_flag(HOST_STATE_SWAP_TRFCR);
> +		} else
> +			host_data_clear_flag(HOST_STATE_SWAP_TRFCR);
> +}
> +EXPORT_SYMBOL_GPL(kvm_set_trfcr);

I have a rather strong distaste for this interface, both with the
coresight driver and internally with the hypervisor. It'd be better if
the driver actually told KVM what the *intent* is rather than throwing a
pile of bits over the fence and forcing KVM to interpret what that
configuration means.

> +static void __debug_swap_trace(void)
> +{
> +	u64 trfcr = read_sysreg_el1(SYS_TRFCR);
> +
> +	write_sysreg_el1(*host_data_ptr(host_debug_state.trfcr_el1), SYS_TRFCR);
> +	*host_data_ptr(host_debug_state.trfcr_el1) = trfcr;
> +	host_data_set_flag(HOST_STATE_RESTORE_TRFCR);
> +}
> +

What if trace is disabled in the guest or in the host? Do we need to
synchronize when transitioning from an enabled -> disabled state like we
do today?

I took a stab at this, completely untested of course && punts on
protected mode. But this is _generally_ how I'd like to see everything
fit together.

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8bc0ec151684..b4714cece5f0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -611,7 +611,7 @@ struct cpu_sve_state {
  */
 struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_HAS_SPE			0
-#define KVM_HOST_DATA_FLAG_HAS_TRBE			1
+#define KVM_HOST_DATA_FLAG_HOST_TRBE_ENABLED		1
 #define KVM_HOST_DATA_FLAG_HOST_SVE_ENABLED		2
 #define KVM_HOST_DATA_FLAG_HOST_SME_ENABLED		3
 	unsigned long flags;
@@ -659,6 +659,9 @@ struct kvm_host_data {
 		u64 mdcr_el2;
 	} host_debug_state;
 
+	/* Guest trace filter value */
+	u64 guest_trfcr_el1;
+
 	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
 	unsigned int nr_event_counters;
 
@@ -1381,6 +1384,8 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
+void kvm_enable_trbe(u64 guest_trfcr);
+void kvm_disable_trbe(void);
 #else
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u64 clr) {}
@@ -1388,6 +1393,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
 {
 	return false;
 }
+void kvm_enable_trbe(u64 guest_trfcr) {}
+void kvm_disable_trbe(void) {}
 #endif
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 46dbeabd6833..6ef8d8f4b452 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -72,10 +72,6 @@ void kvm_init_host_debug_data(void)
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
 	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
 		host_data_set_flag(HAS_SPE);
-
-	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
-	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
-		host_data_set_flag(HAS_TRBE);
 }
 
 /*
@@ -215,3 +211,27 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
 }
+
+void kvm_enable_trbe(u64 guest_trfcr)
+{
+	if (WARN_ON_ONCE(preemptible()))
+		return;
+
+	if (has_vhe()) {
+		write_sysreg_s(guest_trfcr, SYS_TRFCR_EL12);
+		return;
+	}
+
+	*host_data_ptr(guest_trfcr_el1) = guest_trfcr;
+	host_data_set_flag(HOST_TRBE_ENABLED);
+}
+EXPORT_SYMBOL_GPL(kvm_enable_trbe);
+
+void kvm_disable_trbe(void)
+{
+	if (has_vhe() || WARN_ON_ONCE(preemptible()))
+		return;
+
+	host_data_clear_flag(HOST_TRBE_ENABLED);
+}
+EXPORT_SYMBOL_GPL(kvm_disable_trbe);
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 858bb38e273f..d36cbce75bee 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -51,32 +51,33 @@ static void __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
 }
 
-static void __debug_save_trace(u64 *trfcr_el1)
+static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
 {
-	*trfcr_el1 = 0;
+	*saved_trfcr = read_sysreg_el1(SYS_TRFCR);
+	write_sysreg_el1(new_trfcr, SYS_TRFCR);
 
-	/* Check if the TRBE is enabled */
-	if (!(read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E))
+	/* Nothing left to do if going to an enabled state */
+	if (new_trfcr)
 		return;
+
 	/*
-	 * Prohibit trace generation while we are in guest.
-	 * Since access to TRFCR_EL1 is trapped, the guest can't
-	 * modify the filtering set by the host.
+	 * Switching to a context with trace generation disabled. Drain the
+	 * trace buffer to memory.
 	 */
-	*trfcr_el1 = read_sysreg_el1(SYS_TRFCR);
-	write_sysreg_el1(0, SYS_TRFCR);
 	isb();
-	/* Drain the trace buffer to memory */
 	tsb_csync();
 }
 
-static void __debug_restore_trace(u64 trfcr_el1)
+static void __trace_switch_to_guest(void)
 {
-	if (!trfcr_el1)
-		return;
+	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
+			  *host_data_ptr(guest_trfcr_el1));
+}
 
-	/* Restore trace filter controls */
-	write_sysreg_el1(trfcr_el1, SYS_TRFCR);
+static void __trace_switch_to_host(void)
+{
+	__trace_do_switch(host_data_ptr(guest_trfcr_el1),
+			  *host_data_ptr(host_debug_state.trfcr_el1));
 }
 
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
@@ -84,9 +85,13 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 	/* Disable and flush SPE data generation */
 	if (host_data_test_flag(HAS_SPE))
 		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
-	/* Disable and flush Self-Hosted Trace generation */
-	if (host_data_test_flag(HAS_TRBE))
-		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
+
+	/*
+	 * Switch the trace filter, potentially disabling and flushing trace
+	 * data generation
+	 */
+	if (host_data_test_flag(HOST_TRBE_ENABLED))
+		__trace_switch_to_guest();
 }
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -98,8 +103,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	if (host_data_test_flag(HAS_SPE))
 		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
-	if (host_data_test_flag(HAS_TRBE))
-		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
+	if (host_data_test_flag(HOST_TRBE_ENABLED))
+		__trace_switch_to_host();
 }
 
 void __debug_switch_to_host(struct kvm_vcpu *vcpu)

-- 
Thanks,
Oliver
