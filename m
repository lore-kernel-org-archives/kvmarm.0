Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CD8A23
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 03:16:22 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-4fa63c84621so68694317b3.20
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 19:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5M0wOE83qtTaURF82G8aZFS/91Kl/LIeHE7nz/7UDxU=;
        b=Iqc53gBNzfM0ZQBk4+xbHFmih0iyiuyuQ5/tcEObQjx105oWDDzm/qXUERW3fpzmJD
         cL5SI93qyIHP4R5ZzGjPRCkkgTQs5g155SR9fNANxpFJ2Ip9pfQLqMn3NkggSbCbLOUG
         eVzyqy4KufW91RvdGwtwmuJkCZ1Gh89q6XnCJHwz+NIaoyf3r/ocOmPNZyewK6N7QI/e
         KiGhGAtOXFPUg9dKK7qN1Z0QAtJT3TvQ5o1+SOwgIY9enaLlz0wMjYniP6hY8zgIwh3X
         +PBrlz07VEBOXL5pUoaXNvr7ztDJvIE72GaObrGut5iXTgoguT1F40bdVDOCmPTBUWQo
         Bb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5M0wOE83qtTaURF82G8aZFS/91Kl/LIeHE7nz/7UDxU=;
        b=RFSeRnzsKFd6uTlO53OTgFoY/NE8a7Iddv011XZuk3n2L73I8LLSi/GkFgbX51Hi+s
         JclS+s5Qy1xaKhKFdOOKhjrRVwV4SZow8wbjEgwUDm3aZsFaG2N3/bnd9BMCLtCi3T08
         la6sG47hs70ot/UGhymziGsMRW3iX+nnmAIwowgtZI0QCTqAge0BwQzM/JupqBaau6cF
         aqRrXpwJ9IgVQYEGtRPbuL9/zheqqnnMcbWyEDL7lEDAuTQPh0IIVzlFCbqu61P5WwJI
         enABNxVl+jXEPn2cvsW0ZdHKnx45aF/eC4BVz/YA7jTEDhwGmxz2bLvlN3JRRA/srG7S
         M2Hw==
X-Gm-Message-State: AO0yUKVafX/UQ16Hi1T138rEOgbcgMO+LnuJWbTDHLxdEDYbfWgZZ7Wf
	L7sCeL+25RDq1uio9+IA5j69gm+wGg4=
X-Google-Smtp-Source: AK7set+FFAMDtkCc/A+nLWNZ/DMaXcRy2xyI3GQgwZav1va16NpsqWMcS5QMEEK1oQIgOipyziXQEYJALgo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:3293:0:b0:8e6:f40a:adc7 with SMTP id
 y141-20020a253293000000b008e6f40aadc7mr6yby.6.1676085380948; Fri, 10 Feb 2023
 19:16:20 -0800 (PST)
Date: Fri, 10 Feb 2023 19:14:54 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-3-reijiw@google.com>
Subject: [PATCH v4 02/14] KVM: arm64: PMU: Set the default PMU for the guest
 on vCPU reset
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

For vCPUs with PMU configured, KVM uses the sanitized value
(returned from read_sanitised_ftr_reg()) of ID_AA64DFR0_EL1.PMUVer
as the default value and the limit value of that field.
The sanitized value could be inappropriate for these on some
heterogeneous PMU systems, as only one of PMUs on the system
can be associated with the guest.  Also, since the PMUVer
is defined as FTR_EXACT with safe_val == 0 (in cpufeature.c),
it will be zero when any PEs on the system have a different
PMUVer value than the other PEs (i.e. the guest with PMU
configured might see PMUVer == 0).

As a guest with PMU configured is associated with one of
PMUs on the system, the default and the limit PMUVer value for
the guest should be set based on that PMU.  Since the PMU
won't be associated with the guest until some vcpu device
attribute for PMU is set, KVM doesn't have that information
until then though.

Set the default PMU for the guest on the first vCPU reset.
The following patches will use the PMUVer of the PMU as the
default value of the ID_AA64DFR0_EL1.PMUVer for vCPUs with
PMU configured.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 14 +-------------
 arch/arm64/kvm/reset.c    | 21 ++++++++++++++-------
 include/kvm/arm_pmu.h     |  6 ++++++
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f2a89f414297..c98020ca427e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -867,7 +867,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
-static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->lock);
 
@@ -923,18 +923,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	mutex_lock(&kvm->lock);
-	if (!kvm->arch.arm_pmu) {
-		/* No PMU set, get the default one */
-		int ret = kvm_arm_set_vm_pmu(kvm, NULL);
-
-		if (ret) {
-			mutex_unlock(&kvm->lock);
-			return ret;
-		}
-	}
-	mutex_unlock(&kvm->lock);
-
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e0267f672b8a..5d1e1acfe6ce 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -248,18 +248,30 @@ static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct vcpu_reset_state reset_state;
 	int ret;
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&kvm->lock);
 	ret = kvm_set_vm_width(vcpu);
 	if (!ret) {
 		reset_state = vcpu->arch.reset_state;
 		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+
+		/*
+		 * When the vCPU has a PMU, but no PMU is set for the guest
+		 * yet, set the default one.
+		 */
+		if (kvm_vcpu_has_pmu(vcpu) && unlikely(!kvm->arch.arm_pmu)) {
+			if (kvm_arm_support_pmu_v3())
+				ret = kvm_arm_set_vm_pmu(kvm, NULL);
+			else
+				ret = -EINVAL;
+		}
 	}
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	if (ret)
 		return ret;
@@ -297,11 +309,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
 		}
-
-		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
-			ret = -EINVAL;
-			goto out;
-		}
 		break;
 	}
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..7b5c5c8c634b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -96,6 +96,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
+int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu);
 
 #else
 struct kvm_pmu {
@@ -168,6 +169,11 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 	return 0;
 }
 
+static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	return 0;
+}
+
 #endif
 
 #endif
-- 
2.39.1.581.gbfd45094c4-goog

