Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2A0315B4
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 21:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2K3fvWK2"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5a7bbe0a453so18181117b3.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 14:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838069; x=1698442869; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OrkUb5e6f7M9UeNAstnZgH452akYrJ8pbLmUt7I8ZGI=;
        b=2K3fvWK2dUGAbM0NmIAY1ALLm1RaadE+nBuHGcEbQ28AhY4WfoZTo/L7nQXdpNnw7k
         UaS861j4KehDjcVbiuuh0kBxZacL6T8kp9YsX9w94ohtLUqkE4RlRpPuQM+u4KApWdos
         DadZtWaxJqJpBEvOLXB00JAIRuOiuRBLAGh3mzQLqi1l6BC7qbMfqydezaUExgeUKO1a
         KlZvOd3csdZmQWqRJXsDODL6ZJU5HADd8rTKaF4k0OL+3LVc11ECIp693+N2C1fCGHut
         f6IMjVh9L2739j3fwkL3VeDfHp0sUN3FFGwmmqkm2/v/YyrNqoEN/wRsSC9rfxis7sTp
         j2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838069; x=1698442869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OrkUb5e6f7M9UeNAstnZgH452akYrJ8pbLmUt7I8ZGI=;
        b=jKxW3xaZ3MBdGBq7wWalh5dia2J/ZNI6JxJmbl7ON1lLIGOvPFtXkuqS4a7/BfJCXJ
         XUmRVncEEQxu2dYrPrZPENbLChurc3us1MH6Gs8YrYg8s51UH2KVBiiZXMyvEshUTUey
         PvIpPQdCKdMxB9Vb+MvB0lfAuU4jOAh4KomCTlSgZna7AoFnlxFGyfKdOISVOgZuQPDJ
         J4HUbbg2Y698MGf231Wdg8KV7uSilJ1Q9+kFe6V75W384uMtKpUHZXoBGHxtTaN+Fp80
         8za8r7GwLHyoN90PAluWFXw68nIndufU20uC7rHlYWiHOhnqT7RIEUVMtgMsxAbQL6ZS
         btgw==
X-Gm-Message-State: AOJu0YzcRZrkWJ1qhJBtyoHZJJCDOXGzGeMyIDMWYtmTUmUBLYZegBjX
	4nfMxNHjvJfE4bueasZVsO1KNzw2TnF1
X-Google-Smtp-Source: AGHT+IF8vIJpYXDnhqI5NKgDVDHoabvTZ450+oSs7hhl9zUr4cDiZmkB1WBSoXWjbK4iwRe+sAFoloM6sPH/
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a81:6cc3:0:b0:5a7:b8d1:ef65 with SMTP id
 h186-20020a816cc3000000b005a7b8d1ef65mr73650ywc.3.1697838069760; Fri, 20 Oct
 2023 14:41:09 -0700 (PDT)
Date: Fri, 20 Oct 2023 21:40:53 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-14-rananta@google.com>
Subject: [PATCH v8 13/13] KVM: selftests: aarch64: vPMU test for immutability
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

KVM marks some of the vPMU registers as immutable to
userspace once the vCPU has started running. Add a test
scenario to check this behavior.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/aarch64/vpmu_counter_access.c         | 47 ++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 2b697b144e677..f87d76c614e8b 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -9,7 +9,8 @@
  * those counters, and if the guest is prevented from accessing any
  * other counters.
  * It also checks if the userspace accesses to the PMU regsisters honor the
- * PMCR.N value that's set for the guest.
+ * PMCR.N value that's set for the guest and if these accesses are immutable
+ * after KVM has run once.
  * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
  */
 #include <kvm_util.h>
@@ -648,6 +649,48 @@ static void run_error_test(uint64_t pmcr_n)
 	destroy_vpmu_vm();
 }
 
+static uint64_t immutable_regs[] = {
+	SYS_PMCR_EL0,
+	SYS_PMCNTENSET_EL0,
+	SYS_PMCNTENCLR_EL0,
+	SYS_PMINTENSET_EL1,
+	SYS_PMINTENCLR_EL1,
+	SYS_PMOVSSET_EL0,
+	SYS_PMOVSCLR_EL0,
+};
+
+/*
+ * Create a guest with one vCPU, run it, and then make an attempt to update
+ * the registers in @immutable_regs[] (with their complements). KVM shouldn't
+ * allow updating these registers once vCPU starts running. Hence, the test
+ * fails if that's not the case.
+ */
+static void run_immutable_test(uint64_t pmcr_n)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	uint64_t reg_id, reg_val, reg_val_orig;
+
+	create_vpmu_vm(guest_code);
+	vcpu = vpmu_vm.vcpu;
+
+	run_vcpu(vcpu, pmcr_n);
+
+	for (i = 0; i < ARRAY_SIZE(immutable_regs); i++) {
+		reg_id = immutable_regs[i];
+
+		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(reg_id), &reg_val_orig);
+		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(reg_id), ~reg_val_orig);
+		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(reg_id), &reg_val);
+
+		TEST_ASSERT(reg_val == reg_val_orig,
+			    "Register 0x%llx value updated after vCPU run: 0x%lx; expected: 0x%lx\n",
+			    KVM_ARM64_SYS_REG(reg_id), reg_val, reg_val_orig);
+	}
+
+	destroy_vpmu_vm();
+}
+
 /*
  * Return the default number of implemented PMU event counters excluding
  * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
@@ -677,5 +720,7 @@ int main(void)
 	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
 		run_error_test(i);
 
+	run_immutable_test(pmcr_n);
+
 	return 0;
 }
-- 
2.42.0.655.g421f12c284-goog

