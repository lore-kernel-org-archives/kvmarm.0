Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2052810E6
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 04:22:54 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-509ab88f98fso40413697b3.10
        for <kvmarm@lists.linux.dev>; Thu, 02 Feb 2023 20:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zh23L8RDzGrOG493Hoc2xtIcNQwj7Zx258tJ/hDjdbg=;
        b=LOiR52h0CwRLGp36DX1ZjonnDEoN3p1DFxAGEXkvjBWiSm8AicN+69FW2OnZ0m9CRg
         s+bcXNjMeUmi+MafAmpA497N8B5QLl0aDZdqJTlHld03CGnWHsijZws8+3u9wmrQEO94
         +/TdBSKKXDmpiPWhDFkuSHyKGGFyjZVLHRREc9IHRGdL2rKyIkB8P7V8pL7k7ufs7Rw0
         43M/iuzsoMtwiRuuUZ/5/nkWtW8FutvL2UesM/pDBmyYpnVM9aeYmhUMUHfV4qZGx27Z
         0sGEdotLODUDSqJklEul4+74q9QgSHBbsgJER3Lul8ZiyFVYRVmgAEEhbUX2E9mXvDcL
         g5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zh23L8RDzGrOG493Hoc2xtIcNQwj7Zx258tJ/hDjdbg=;
        b=s8PZwSRhXkhw1gZ7qkp7R0mijIt7J9Pp2auPG251kSfFXPBXHE0mZUhXcb1gmnjpYW
         eTO5Z9/drkCLs/k0GNUrrIXx6FmlwMaaaEkwfxXufraE1nhcje0qQreEvnlivxloHRmM
         K6iQ4mNYxzWVMtTnP9LX1oKwgJsazwsJMWTCRpmmdySXGUmeSVT+xlMFoEAdu4JgK+qc
         csGwiMXsXk2cIBHM6bimMPpPZ19SrHkxPE5K8ODjtGIbKrhA0mIB9RNSGCnUltdUUEuZ
         hhHlUNNd8r5svLNM3bMUOjl4l00IDk5AAq2Eog39qZePF0l3gvYxlzj+I/p5njRUsxHF
         lWMw==
X-Gm-Message-State: AO0yUKVRio2yPbV+ipwUF91dtxhbEKvhDhmobpgoBYpSDyuCgeK7DRvq
	7uTjOqXb0VCOaFSicQH0Q4FKZ77oNZw=
X-Google-Smtp-Source: AK7set/f7tCnxbVAOphOa+pn50t+vK+KBWmf/f9IPGWE6ooHqpdSfbk9C+oLKEZYPGto6MBz/P2BmnRQrVQ=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:7795:0:b0:855:fa17:4f62 with SMTP id
 s143-20020a257795000000b00855fa174f62mr4ybc.4.1675398173757; Thu, 02 Feb 2023
 20:22:53 -0800 (PST)
Date: Thu,  2 Feb 2023 20:20:45 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-2-reijiw@google.com>
Subject: [PATCH v3 03/14] KVM: arm64: PMU: Don't use the sanitized value for PMUVer
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Now, the guest has the default PMU on the first vCPU reset
when a PMU is configured for any of vCPUs on the guest.

For a vCPU with PMU configured, use the PMUver of the guest's
PMU as the default value of ID_AA64DFR0_EL1.PMUVer and
as the limit value of the field, instead of its sanitized
value (The sanitized value could be inappropriate for these
on some heterogeneous PMU systems, as only one of PMUs on
the system can be associated with the guest. See the previous
patch for more details).

When a PMU for the guest is changed, the PMUVer for the guest
will be reset based on the new PMU.  On heterogeneous systems,
this might end up changing the PMUVer that is set by userspace
for the guest if userspace changes the PMUVer before using
KVM_ARM_VCPU_PMU_V3_SET_PMU.
This change isn't nice though.  Other options considered are not
updating the PMUVer even when the PMU for the guest is changed,
or setting PMUVer to the new limit value only when it is larger
than the limit.  The former might end up exposing PMUVer that
KVM can't support. The latter is inconvenient as the default
PMUVer for the PMU set by KVM_ARM_VCPU_PMU_V3_SET_PMU will be
an unknown (but supported) value, and userspace explicitly need
to set the PMUVer for the guest to use the host PMUVer value.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  6 -----
 arch/arm64/kvm/pmu-emul.c         |  2 ++
 arch/arm64/kvm/sys_regs.c         | 38 +++++++++++++++++++++----------
 include/kvm/arm_pmu.h             |  1 -
 5 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..33839077a95c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -230,6 +230,7 @@ struct kvm_arch {
 	struct {
 		u8 imp:4;
 		u8 unimp:4;
+		u8 imp_limit;
 	} dfr0_pmuver;
 
 	/* Hypercall features firmware registers' descriptor */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..41f478344a4d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -164,12 +164,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
-
 	return 0;
 
 err_free_cpumask:
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index c98020ca427e..49580787ee09 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -878,6 +878,8 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 	}
 
 	kvm->arch.arm_pmu = arm_pmu;
+	kvm->arch.dfr0_pmuver.imp_limit = min_t(u8, arm_pmu->pmuver, ID_AA64DFR0_EL1_PMUVer_V3P5);
+	kvm->arch.dfr0_pmuver.imp = kvm->arch.dfr0_pmuver.imp_limit;
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c6cbfe6b854b..c1ec4a68b914 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1259,8 +1259,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
+	u64 current_val = read_id_reg(vcpu, rd);
+	int ret = -EINVAL;
 
-	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
+	mutex_lock(&vcpu->kvm->lock);
+	host_pmuver = vcpu->kvm->arch.dfr0_pmuver.imp_limit;
 
 	/*
 	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
@@ -1270,26 +1273,30 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	 */
 	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
 	if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver))
-		return -EINVAL;
+		goto out;
 
 	valid_pmu = (pmuver != 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
 
 	/* Make sure view register and PMU support do match */
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
-		return -EINVAL;
+		goto out;
 
 	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
+	val ^= current_val;
 	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
 	if (val)
-		return -EINVAL;
+		goto out;
 
 	if (valid_pmu)
 		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
 	else
 		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
 
-	return 0;
+	ret = 0;
+out:
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return ret;
 }
 
 static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
@@ -1298,8 +1305,11 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 perfmon, host_perfmon;
 	bool valid_pmu;
+	u64 current_val = read_id_reg(vcpu, rd);
+	int ret = -EINVAL;
 
-	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
+	mutex_lock(&vcpu->kvm->lock);
+	host_perfmon = pmuver_to_perfmon(vcpu->kvm->arch.dfr0_pmuver.imp_limit);
 
 	/*
 	 * Allow DFR0_EL1.PerfMon to be set from userspace as long as
@@ -1310,26 +1320,30 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), val);
 	if ((perfmon != ID_DFR0_EL1_PerfMon_IMPDEF && perfmon > host_perfmon) ||
 	    (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3))
-		return -EINVAL;
+		goto out;
 
 	valid_pmu = (perfmon != 0 && perfmon != ID_DFR0_EL1_PerfMon_IMPDEF);
 
 	/* Make sure view register and PMU support do match */
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
-		return -EINVAL;
+		goto out;
 
 	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
+	val ^= current_val;
 	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
 	if (val)
-		return -EINVAL;
+		goto out;
 
 	if (valid_pmu)
 		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
 	else
 		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
 
-	return 0;
+	ret = 0;
+out:
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return ret;
 }
 
 /*
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 7b5c5c8c634b..c7da46c7377e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -95,7 +95,6 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 #define kvm_pmu_is_3p5(vcpu)						\
 	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
-u8 kvm_arm_pmu_get_pmuver_limit(void);
 int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu);
 
 #else
-- 
2.39.1.519.gcb327c4b5f-goog

