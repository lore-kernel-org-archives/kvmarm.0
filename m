Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DCAD504
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 17:03:49 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id k7-20020a256f07000000b006cbcc030bc8so16620687ybc.18
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 09:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/bRkqjyelCT2BwKXDL2kk3eM+ea/9WF6lbhTPLqyzQs=;
        b=OdTGpYZuNgCXakLh2Jk72rtpCkaN4uXEYVgleL325j12+NmpV15XjX8JS6kVtFnDwK
         PNhAWspY5fLWyh0Xj8g3+lafmWa+eNTSAWQNZ6ONYvy50LpLKB4FdqVaYvmgtJW2AQwQ
         3xyBTOFq4CD0fbhlimpa8mukamYs6e4YSrieqiuW60AY/G/B7EQ2yfIjZd0LkShAI6L6
         AdgQri5c8YZwdv8W2uBFogmXjDGJjZ5thbMVabQnwE3E5hk6ShehMMeEGgcGHCmDZLeW
         itubJ4CVgFw6aN3xSYppKJyDs5NU7h2q0H+C5Jh9Gqse5HdJu4x5tknbHrNbOaZ/CoAS
         +7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/bRkqjyelCT2BwKXDL2kk3eM+ea/9WF6lbhTPLqyzQs=;
        b=yz2OReL0e6D2zMsSpqhiFJpAcrMxoYPiMpCVmgh9eIBVrSBCyqtK3yC2LwJxx8C0u3
         qE8U3K3wiHt1nsy89Z4RxomI0GbRbo7FkNmM5NUCnOV+c2ztZMns9NAIO967RkB4+G5n
         6lxdufdeew/WOS4muGsI8O9vdrWo/3+b47s/YXY/6hb2IZFkn3lbBU8iE0mybWtsd//D
         8hDq8YGbCvDV09XFvh7YV4vmHjE1IcRKvp0mYyY2NuGI1gbRFYf7EHcQ77xf9HlqwD8M
         CfO6NYpuUNuLKAjr95g/mjSbpwi4f6QJjr6WmimzOOsOR6Ose5a/PNjPlS0rntRQAm38
         LDtQ==
X-Gm-Message-State: ACrzQf0rMAzeVqXCfqan5ak06si8TSVZxx2Z1rAplM+2PbXHAiCpUxwO
	gag1ezA4ETd1AsMO+Cvjt3p9QTY3ovoZ
X-Google-Smtp-Source: AMsMyM6kz2VVfMezIhOWhcHrz/hGAETOYwjma0z07Lmtkc6uNWWu17KZrnMVkVuR1GhaX/Tp0luYpM2CFjFt
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a05:6902:1206:b0:6c0:2863:c15c with SMTP
 id s6-20020a056902120600b006c02863c15cmr68406659ybu.117.1668618227919; Wed,
 16 Nov 2022 09:03:47 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:27 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-5-qperret@google.com>
Subject: [PATCH 04/12] KVM: arm64: Probe FF-A version and host/hyp partition
 ID during init
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Andrew Walbran <qwandor@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221116170327.mMIV-E8zFN0SsjpD-CMhBJ8cc67qP5PuR0n85Bjo5oA@z>

From: Will Deacon <will@kernel.org>

Probe FF-A during pKVM initialisation so that we can detect any
inconsistencies in the version or partition ID early on.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h     |  1 +
 arch/arm64/kvm/arm.c                  |  1 +
 arch/arm64/kvm/hyp/include/nvhe/ffa.h |  1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 30 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c       |  5 +++++
 5 files changed, 38 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 63307e7dc9c5..ab5ccf47c05f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -347,6 +347,7 @@ struct kvm_host_data {
 struct kvm_host_psci_config {
 	/* PSCI version used by host. */
 	u32 version;
+	u32 smccc_version;
 
 	/* Function IDs used by host if version is v0.1. */
 	struct psci_0_1_function_ids function_ids_0_1;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1d1a3b93a3de..8b93af23f327 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1780,6 +1780,7 @@ static bool init_psci_relay(void)
 	}
 
 	kvm_host_psci_config.version = psci_ops.get_version();
+	kvm_host_psci_config.smccc_version = arm_smccc_get_version();
 
 	if (kvm_host_psci_config.version == PSCI_VERSION(0, 1)) {
 		kvm_host_psci_config.function_ids_0_1 = get_psci_0_1_function_ids();
diff --git a/arch/arm64/kvm/hyp/include/nvhe/ffa.h b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
index fc09ec671e24..5c9b92430ff3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/ffa.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
@@ -11,6 +11,7 @@
 #define FFA_MIN_FUNC_NUM 0x60
 #define FFA_MAX_FUNC_NUM 0x7F
 
+int hyp_ffa_init(void);
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt);
 
 #endif /* __KVM_HYP_FFA_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 6ccf935d3b41..969d72390844 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -31,6 +31,12 @@
 #include <nvhe/ffa.h>
 #include <nvhe/trap_handler.h>
 
+/*
+ * "ID value 0 must be returned at the Non-secure physical FF-A instance"
+ * We share this ID with the host.
+ */
+#define HOST_FFA_ID	0
+
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
 	*res = (struct arm_smccc_res) {
@@ -111,3 +117,27 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 	ffa_set_retval(host_ctxt, &res);
 	return true;
 }
+
+int hyp_ffa_init(void)
+{
+	struct arm_smccc_res res;
+
+	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
+		return 0;
+
+	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_0, 0, 0, 0, 0, 0, 0, &res);
+	if (res.a0 == FFA_RET_NOT_SUPPORTED)
+		return 0;
+
+	if (res.a0 != FFA_VERSION_1_0)
+		return -EOPNOTSUPP;
+
+	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
+	if (res.a0 != FFA_SUCCESS)
+		return -EOPNOTSUPP;
+
+	if (res.a2 != HOST_FFA_ID)
+		return -EINVAL;
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 110f04627785..c4ca174a0592 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -11,6 +11,7 @@
 #include <asm/kvm_pkvm.h>
 
 #include <nvhe/early_alloc.h>
+#include <nvhe/ffa.h>
 #include <nvhe/fixed_config.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
@@ -314,6 +315,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = hyp_ffa_init();
+	if (ret)
+		goto out;
+
 	pkvm_hyp_vm_table_init(vm_table_base);
 out:
 	/*
-- 
2.38.1.431.g37b22c650d-goog

