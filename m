Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95157B
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 00:21:55 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-536a5a0b6e3so139595837b3.10
        for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 17:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680049315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iXBtTxJA82bcXFQXnQ4d5hea80kX0towjerItzNuSjc=;
        b=f3LE3sXwy/Ypo0P2WoNo8NflUs56Y6hwFUXr6NyFwI05caseJKeOArDA3LgE6Zvesh
         n8XB+vhcrio7HWaQOwAgaN3DIiP9fCowNOXVr4nI+hNQtTbatppnEfPFQKmmykKrDCdm
         BYn5i/V1hkx3deB/XcrBXFj3kTR5h1S7Xcr1lR4QtEztD3l97yuAqQGTW/v5IqFDFIB3
         /BX/s9XQQjmYW6t6MQl5kqVyqT1vco7mSDQcsmO2kRkM429zib6uYwf6k+CXWGQpYA9r
         q9xWmPJLZW8gDNFLVzvXNcN/lF/2sLxlfxPgRdF37A1YYkqf+/7neUK/EMVqdLyEtdw7
         QJUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680049315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iXBtTxJA82bcXFQXnQ4d5hea80kX0towjerItzNuSjc=;
        b=GFhQAsmPEIBTgp2rFQ2KREKVIhCMYfz+Fv2sEQzEc5Lbbs4roAqD6q3TYsdgJrA8FU
         pRFfSln/VImL6+hZjGdhIgn1XHeGBturx0PJ2g01DWcIoJiPI05ZlE7ujq+vOE5Kd3MM
         KZDIDO7OOE7kRSsJudLBrmQYCbAAN/X8K59qoFjuuIaOKckNmTPtLlKofd4d5aIac81u
         PXQfEVNkT8RZbvyZUWM8QC+CeF+95N1R1WE8dhiiNz34ohxkyOwLyL15t1HsWLBjvFQP
         xgNfDK0aDl/Cm2i3FE5Hpy4FqL/wI60y043e2XgpycL0TCI3LfFjReLwNEhmAmaDG+HR
         QQDw==
X-Gm-Message-State: AAQBX9cJgiFTveJ2iavQHnCrgcncYsHIZrMfKATcdehm+0+C8XK6Ju3D
	+r4gulqG4CoN5Ft1sWkqjjUE3ptmoB0=
X-Google-Smtp-Source: AKy350a64aWirwKtZfp2hNwUr2/sbk2BHCGDPtQLxA7yvFuGhqlS4CfVlAm0dtCZEFXYfpoboZnvH7OctM8=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:a8c:b0:b7b:fb15:8685 with SMTP id
 cd12-20020a0569020a8c00b00b7bfb158685mr5290936ybb.9.1680049315012; Tue, 28
 Mar 2023 17:21:55 -0700 (PDT)
Date: Tue, 28 Mar 2023 17:21:36 -0700
In-Reply-To: <20230329002136.2463442-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230329002136.2463442-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329002136.2463442-3-reijiw@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: PMU: Ensure to trap PMU access from EL0 to EL2
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, with VHE, KVM sets ER, CR, SW and EN bits of
PMUSERENR_EL0 to 1 on vcpu_load().  So, if the value of those bits
are cleared after vcpu_load() (the perf subsystem would do when PMU
counters are programmed for the guest), PMU access from the guest EL0
might be trapped to the guest EL1 directly regardless of the current
PMUSERENR_EL0 value of the vCPU.

With VHE, fix this by setting those bits of the register on every
guest entry (as with nVHE).  Also, opportunistically make the similar
change for PMSELR_EL0, which is cleared by vcpu_load(), to ensure it
is always set to zero on guest entry (PMXEVCNTR_EL0 access might cause
UNDEF at EL1 instead of being trapped to EL2, depending on the value
of PMSELR_EL0).  I think that would be more robust, although I don't
find any kernel code that writes PMSELR_EL0.

Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 29 +++++++++++++------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 44b84fbdde0d..7d39882d8a73 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -74,18 +74,6 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 
-	/*
-	 * Make sure we trap PMU access from EL0 to EL2. Also sanitize
-	 * PMSELR_EL0 to make sure it never contains the cycle
-	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
-	 * EL1 instead of being trapped to EL2.
-	 */
-	if (kvm_arm_support_pmu_v3()) {
-		write_sysreg(0, pmselr_el0);
-		vcpu->arch.host_pmuserenr_el0 = read_sysreg(pmuserenr_el0);
-		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
-	}
-
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
@@ -106,8 +94,6 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
 
 	write_sysreg(0, hstr_el2);
-	if (kvm_arm_support_pmu_v3())
-		write_sysreg(vcpu->arch.host_pmuserenr_el0, pmuserenr_el0);
 
 	if (cpus_have_final_cap(ARM64_SME)) {
 		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
@@ -130,6 +116,18 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
+
+	/*
+	 * Make sure we trap PMU access from EL0 to EL2. Also sanitize
+	 * PMSELR_EL0 to make sure it never contains the cycle
+	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
+	 * EL1 instead of being trapped to EL2.
+	 */
+	if (kvm_arm_support_pmu_v3()) {
+		write_sysreg(0, pmselr_el0);
+		vcpu->arch.host_pmuserenr_el0 = read_sysreg(pmuserenr_el0);
+		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
+	}
 }
 
 static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
@@ -144,6 +142,9 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 &= ~HCR_VSE;
 		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
 	}
+
+	if (kvm_arm_support_pmu_v3())
+		write_sysreg(vcpu->arch.host_pmuserenr_el0, pmuserenr_el0);
 }
 
 static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
-- 
2.40.0.348.gf938b09366-goog

