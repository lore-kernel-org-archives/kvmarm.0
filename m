Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BFF1C3F13
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648131; cv=none; b=gQek9PJE/h2X9LmbJizz4Z2JGgNcP3Yc1K6rwSUWZGcfPypFswviIpFzUkq6qLMOdyWLAqzsiytxBnJfICpbkYdELGbOLSlPhH9mJVGelGB3W0jtdSesVKOVTO952MsMeZcV9EFZUHy7XeiIO2hjketPmOqxlJ4Rr1SEdiut+Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648131; c=relaxed/simple;
	bh=dzmLxP6EjQCrJ5Ta1F8r1yTrILJ7V821ihbo3S1jsdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VP7X7SRmW+p7vTUh8PHWWvlkWBSpUR81zdbNimFVnIEASUOczeSEFDCpshRTqbYC1rxv0e9S4fvZLl39q5MDflAf2Y/oygvf9Cca+rXxoGKW4wtKDoMldFnTihCxXesIZZidsJzLnIXiu1AFbSwELp4IV9MUaK8mE8iqAqeWOgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vxFZgXAd; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vxFZgXAd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Je/BQghng+w2bt+hnJU75nV+yahVV5nH1ArdWHQGqbA=;
	b=vxFZgXAdD44E7+aSHt/M1s4xj+kN03Wu3fXiwRcpXhAz+ZwPwN5etj8mrM864tnKAOAHTK
	/CTwIkW7Qv1snG7QmsgjYCgjmPo63lMWQUUtUe/eAaZLTw+ejmtGU3uMI8TqCs3nI9uDSb
	mBG9eja2WnDNW9pJW+Yfsx/CmoZzoc0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 17/19] KVM: arm64: Avoid reading ID_AA64DFR0_EL1 for debug save/restore
Date: Thu, 19 Dec 2024 14:41:14 -0800
Message-Id: <20241219224116.3941496-18-oliver.upton@linux.dev>
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Similar to other per-CPU profiling/debug features we handle, store the
number of breakpoints/watchpoints in kvm_host_data to avoid reading the
ID register 4 times on every guest entry/exit. And if you're in the
nested virt business that's quite a few avoidable exits to the L0
hypervisor.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h         |  4 ++++
 arch/arm64/kvm/debug.c                    |  3 +++
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 17 ++++-------------
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d48516de778d..e7c740c99ee3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -661,6 +661,10 @@ struct kvm_host_data {
 
 	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
 	unsigned int nr_event_counters;
+
+	/* Number of debug breakpoints/watchpoints for this CPU (minus 1) */
+	unsigned int debug_brps;
+	unsigned int debug_wrps;
 };
 
 struct kvm_host_psci_config {
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 7d3c71d65518..d921e7f7bd59 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -71,6 +71,9 @@ void kvm_init_host_debug_data(void)
 		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
 							      read_sysreg(pmcr_el0));
 
+	*host_data_ptr(debug_brps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
+	*host_data_ptr(debug_wrps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
+
 	if (has_vhe())
 		return;
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index c14586d87361..502a5b73ee70 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -106,12 +106,8 @@ static struct kvm_guest_debug_arch *__vcpu_debug_regs(struct kvm_vcpu *vcpu)
 static void __debug_save_state(struct kvm_guest_debug_arch *dbg,
 			       struct kvm_cpu_context *ctxt)
 {
-	u64 aa64dfr0;
-	int brps, wrps;
-
-	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
-	brps = (aa64dfr0 >> 12) & 0xf;
-	wrps = (aa64dfr0 >> 20) & 0xf;
+	int brps = *host_data_ptr(debug_brps);
+	int wrps = *host_data_ptr(debug_wrps);
 
 	save_debug(dbg->dbg_bcr, dbgbcr, brps);
 	save_debug(dbg->dbg_bvr, dbgbvr, brps);
@@ -124,13 +120,8 @@ static void __debug_save_state(struct kvm_guest_debug_arch *dbg,
 static void __debug_restore_state(struct kvm_guest_debug_arch *dbg,
 				  struct kvm_cpu_context *ctxt)
 {
-	u64 aa64dfr0;
-	int brps, wrps;
-
-	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
-
-	brps = (aa64dfr0 >> 12) & 0xf;
-	wrps = (aa64dfr0 >> 20) & 0xf;
+	int brps = *host_data_ptr(debug_brps);
+	int wrps = *host_data_ptr(debug_wrps);
 
 	restore_debug(dbg->dbg_bcr, dbgbcr, brps);
 	restore_debug(dbg->dbg_bvr, dbgbvr, brps);
-- 
2.39.5

