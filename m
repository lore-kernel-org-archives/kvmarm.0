Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213133;
	b=1Fik040BKeS3HB4MWmqrPr9A5aJuwDZzVtE43ehyATef0FMRzFumxS6OfD+5LqnlZI25
	 igRIIzt5YQQUydivnRFFY3/L45ZH+8TC2za0j31GZr1g+BSY78HvAQikComF/mcKYkh25
	 Lo6Ur0vI0X5yWbHxSC+zdE4WeBSbXdhDpLyAmNPZWK8GewRYLsTd606SPHOF5jRbDlt2q
	 B9kz9hMJCFTocPrTmOyExJt61M7AtxFOM3SnzU2Oe92y1l1vEuMRZXhr4qaljWHjzbLdg
	 Y8+FgOdjLmA0tOHz19k1t7/shfMBxEjvmlj4VZKZy8KT0WIcin+Tq5EIPJdhMQZ0BJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213133;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dC8Nvk9HltS2WjAbMa049oqSzt2wkzwJPoICcDtsLEQ=;
	b=VKtlmEBOqtjZZRp9ESLXiMHwzmHxueReJHVI1Uq8bDoWDkb7Ui01oQi7WIUIbRv7197U
	 S1Ecfh+EKeaL7KP8hjCjdcCr4w9U27IVR27mXD6Xm9KfMuUlccKXgKYwEpC5uhdz6/gG3
	 8yVy1YCxUnQHh9ps1hygVTOhQaivRT3wWg0Ovn6IuSlWSdyu/et2bAZrG1kN03TCGXVNy
	 JI8CXFYQSQkfmDD15WwGX82fuZirttPbEyfpxdMUzJINIQuM6UK3dvGnXzQyBXL55bHnd
	 stY3SZBF25ywHygrpz0PEtnsGF7EeAYafH7i9dpspHCrxBZ3rzklaV25QlWDWBy9uVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eDjHT7gS;
	arc=none smtp.remote-ip=91.218.175.173
Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7555606A332
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7555606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eDjHT7gS
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=AKowbsDDlbP2ukyZY0i+b+DKnxhMeynrWxp0nn++TZ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213129; v=1; x=1794817929;
 b=eDjHT7gSMZPH+tYcIA7/5vAbPqHMfcMR5lYgcrNEPv1QCgt9m5PQXmVSyGgmcJ3QRq1t3rBj
 TLqPW589bmL0u7oPQ4aV7Ps9tA/WC/jXNj6dnFAeWiZm7mL+5ssB3ke2L7k7DumvcXH7xL+91mn
 tX4y4W1PXKjREa+k+2TnNEJY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b71c7a4035c1e0dd;
	Mon, 09 Nov 2026 08:32:09 +0000
X-Mizu-Trace-ID: b71c7a4035c1e0dd
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] KVM: arm64: Allocate a protected vCPU's SVE state at EL2
Date: Mon,  9 Nov 2026 08:31:52 +0000
Message-ID: <20261109083205.806619-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109083205.806619-1-fuad.tabba@linux.dev>
References: <20261109083205.806619-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a vCPU with SVE, EL2 pins the buffer the host allocated at
KVM_ARM_VCPU_FINALIZE and saves the guest's SVE registers there. The
host can still read and write that buffer, so it can't hold a protected
vCPU's state.

Allocate a protected vCPU's SVE state from the hyp heap instead, and
free it with the vCPU. When EL2 resets a protected vCPU, zero its SVE
state and ZCR_EL1, as KVM does for a non-protected one. The host still
allocates its own buffer, which KVM_{GET,SET}_ONE_REG access before the
first run, but EL2 doesn't use it.

For a protected vCPU, the host's sve_max_vl now sizes an EL2 allocation
and is the guest's maximum vector length on every CPU. Give EL2 a copy
of kvm_sve_max_vl, the largest length all CPUs can give a guest, and
check every vCPU's sve_max_vl against it rather than clamping it to the
host's own maximum. set_sve_vls() already keeps the host's value within
that bound.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 41 ++++++++++++++++++++----------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  1 +
 arch/arm64/kvm/reset.c             |  2 ++
 4 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 9a785a341090e..22601a4e36f4e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -158,6 +158,7 @@ extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
 extern enum mitigation_state kvm_nvhe_sym(spectre_v2_state);
 extern enum mitigation_state kvm_nvhe_sym(spectre_v4_state);
 extern enum mitigation_state kvm_nvhe_sym(spectre_bhb_state);
+extern unsigned int kvm_nvhe_sym(kvm_sve_max_vl);
 extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
 extern unsigned long kvm_nvhe_sym(hyp_nr_cpus);
 extern unsigned int kvm_nvhe_sym(hyp_gicv3_nr_lr);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 1d484da274c0e..fba8dfe6389d6 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -30,6 +30,7 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
+unsigned int kvm_sve_max_vl;
 unsigned int kvm_host_sve_max_vl;
 
 /*
@@ -479,7 +480,7 @@ static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
 		hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
 }
 
-static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+static void teardown_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	void *sve_state;
 
@@ -487,8 +488,10 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (!sve_state)
 		return;
 
-	hyp_unpin_shared_mem(sve_state,
-			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		hyp_free(sve_state);
+	else
+		hyp_unpin_shared_mem(sve_state, sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
 }
 
 static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
@@ -503,7 +506,7 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 			continue;
 
 		unpin_host_vcpu(hyp_vcpu->host_vcpu);
-		unpin_host_sve_state(hyp_vcpu);
+		teardown_sve_state(hyp_vcpu);
 	}
 }
 
@@ -546,18 +549,25 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 		return 0;
 	}
 
-	/* Limit guest vector length to the maximum supported by the host. */
-	sve_max_vl = min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_host_sve_max_vl);
-	sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
-
-	if (!sve_vl_valid(sve_max_vl) || !sve_state)
+	sve_max_vl = READ_ONCE(host_vcpu->arch.sve_max_vl);
+	if (!sve_vl_valid(sve_max_vl) || sve_max_vl > kvm_sve_max_vl)
 		return -EINVAL;
 
 	sve_state_size = sve_state_size_from_vl(sve_max_vl);
 
-	ret = hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);
-	if (ret)
-		return ret;
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+		sve_state = hyp_alloc(sve_state_size);
+		if (!sve_state)
+			return hyp_alloc_errno();
+	} else {
+		sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
+		if (!sve_state)
+			return -EINVAL;
+
+		ret = hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);
+		if (ret)
+			return ret;
+	}
 
 	vcpu->arch.sve_state = sve_state;
 	vcpu->arch.sve_max_vl = sve_max_vl;
@@ -646,7 +656,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 done:
 	if (ret) {
 		unpin_host_vcpu(host_vcpu);
-		unpin_host_sve_state(hyp_vcpu);
+		teardown_sve_state(hyp_vcpu);
 	}
 	return ret;
 }
@@ -1018,7 +1028,7 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu)
 	ret = register_hyp_vcpu(hyp_vm, hyp_vcpu);
 	if (ret) {
 		unpin_host_vcpu(host_vcpu);
-		unpin_host_sve_state(hyp_vcpu);
+		teardown_sve_state(hyp_vcpu);
 		goto unclaim;
 	}
 	goto unlock;
@@ -1246,6 +1256,9 @@ int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 			    PSCI_0_2_AFFINITY_LEVEL_ON) != PSCI_0_2_AFFINITY_LEVEL_ON_PENDING)
 		return -ECANCELED;
 
+	if (vcpu_has_sve(&hyp_vcpu->vcpu))
+		memset(hyp_vcpu->vcpu.arch.sve_state, 0, vcpu_sve_state_size(&hyp_vcpu->vcpu));
+
 	kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
 	kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
 	kvm_load_pvm_debug(&hyp_vcpu->vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index e7148254ec5b8..7a0aed1d8b0b3 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -783,6 +783,7 @@ static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
 	RESET_UNKNOWN(MAIR_EL1),
 	RESET_ZERO(AMAIR_EL1),
 	RESET_ZERO(MDSCR_EL1),
+	RESET_ZERO(ZCR_EL1),
 	RESET_ZERO(CNTV_CTL_EL0),
 	RESET_UNKNOWN(TTBR0_EL1),
 	RESET_UNKNOWN(TTBR1_EL1),
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 10eb7249aa9e8..aaaa1b8634ba4 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -52,6 +52,8 @@ int __init kvm_arm_init_sve(void)
 		if (WARN_ON(kvm_sve_max_vl > VL_ARCH_MAX))
 			kvm_sve_max_vl = VL_ARCH_MAX;
 
+		kvm_nvhe_sym(kvm_sve_max_vl) = kvm_sve_max_vl;
+
 		/*
 		 * Don't even try to make use of vector lengths that
 		 * aren't available on all CPUs, for now:
-- 
2.47.3

