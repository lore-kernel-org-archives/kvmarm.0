Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CCD11718
	for <kvmarm@lists.linux.dev>; Mon, 11 Sep 2023 15:01:32 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40037db2fe7so49023095e9.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Sep 2023 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694444490; x=1695049290; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XCEOb7WccW67YUIOw67R+Cvx7t9mQ8+KuAnKAOSBIbA=;
        b=bZigh8TPbrkePF9vRRRapIHS9FsNfFkpQJNn7H65tXiNY+hT804B5rziPl42tkJ5ks
         b2ypMS69L3rAHyn1R2w8Ls8gTKZlzMH6fci0bLltVZ2b1vUQRMOw8cjniBc1RRO6YG68
         oSK02GNI78mZq++TdvypCUS8zlPvZma+X48YFfjUBfYsaZI3TiQxNCcJ7VSF1kl+NrAC
         bfiaQkirUjxZomC+IjZTz4iL//fi4sCJ3mHU9zJeb5qFn2x/F0GPlaLkxVZS31Tl4s0A
         qs1M2jCV6cu5ftmkwNRPj51ig7KOSbmyPYADJCX+1NWuYEnNFQjgBAxEx5SVX8Zvf8zc
         lBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694444490; x=1695049290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XCEOb7WccW67YUIOw67R+Cvx7t9mQ8+KuAnKAOSBIbA=;
        b=HgfLiKukhaJfkQweNNhISgaZg8q7IS5Z/3cH2V3JM4F6dHEdC7BB29Ez9VDD8vH/a6
         LUa7GknkZKxl1maDaCehnwVHJOarZfgqnT6e9HnAg9c4obZ+HIQ0PqkmVv1WOF1Cv+Bq
         JekPO2tkQHgWa0tklZ5VpGQBokdnjAHWQl7MOl+unB9Q208bFmKn+coh3nvsKoN4Wrxc
         TjrG8MirRX5Jg3aCaveyqac3AOzKTUSIlw1UDMTOBJXxf8UhsH/L2tAyt1RZQ7yHC177
         yPVABh5N7ypBTp6W4ExfkxAFVKJ8D7i1wKsZgb6pqmPSMDzZC4elaVMuFWZTf6Y6q3nQ
         TPgQ==
X-Gm-Message-State: AOJu0Yw8FmtWOEENluhowNXayuH5LXqi0+ajBBpASrn1NAveOa0LAhqg
	1xKNxuNwPRul4QUrZm/+P/uIcA==
X-Google-Smtp-Source: AGHT+IGs3SxYXExocX5sgTM4bYzdxVRvEQBoBJnv2MRZBQ3lXA0UXgiTZhsa4PxpOBt7Y18kkfVekw==
X-Received: by 2002:adf:e484:0:b0:314:36c5:e4c0 with SMTP id i4-20020adfe484000000b0031436c5e4c0mr7955040wrm.11.1694444490259;
        Mon, 11 Sep 2023 08:01:30 -0700 (PDT)
Received: from localhost.localdomain ([2a02:c7c:7290:b00:fd32:2b31:6755:400c])
        by smtp.gmail.com with ESMTPSA id x14-20020aa7dace000000b005257da6be23sm4765010eds.75.2023.09.11.08.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 08:01:29 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	oliver.upton@linux.dev
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH] KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID
Date: Mon, 11 Sep 2023 15:52:57 +0100
Message-ID: <20230911145254.934414-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When SVE is enabled, the host may set bit 16 in SMCCC function IDs, a
hint that indicates an unused SVE state. At the moment NVHE doesn't
account for this bit when inspecting the function ID, and rejects most
calls. Clear the hint bit before comparing function IDs.

About version compatibility: the host's PSCI driver initially probes the
firmware for a SMCCC version number. If the firmware implements a
protocol recent enough (1.3), subsequent SMCCC calls have the hint bit
set. Since the hint bit was reserved in earlier versions of the
protocol, clearing it is fine regardless of the version in use.

When a new hint is added to the protocol in the future, it will be added
to ARM_SMCCC_CALL_HINTS and NVHE will handle it straight away. This
patch only clears known hints and leaves reserved bits as is, because
future SMCCC versions could use reserved bits as modifiers for the
function ID, rather than hints.

Fixes: cfa7ff959a78 ("arm64: smccc: Support SMCCC v1.3 SVE register saving hint")
Reported-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h      | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/ffa.h | 2 +-
 include/linux/arm-smccc.h             | 2 ++
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 3 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    | 8 ++++++--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c  | 3 +--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S    | 1 +
 7 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b7238c72a04cf..66efd67ea7e8d 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -118,7 +118,7 @@ void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
-bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
+bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt, u32 func_id);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/ffa.h b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
index 1becb10ecd805..d9fd5e6c7d3cc 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/ffa.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
@@ -12,6 +12,6 @@
 #define FFA_MAX_FUNC_NUM 0x7F
 
 int hyp_ffa_init(void *pages);
-bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt);
+bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id);
 
 #endif /* __KVM_HYP_FFA_H */
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 7c67c17321d4c..083f856537161 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -67,6 +67,8 @@
 #define ARM_SMCCC_VERSION_1_3		0x10003
 
 #define ARM_SMCCC_1_3_SVE_HINT		0x10000
+#define ARM_SMCCC_CALL_HINTS		ARM_SMCCC_1_3_SVE_HINT
+
 
 #define ARM_SMCCC_VERSION_FUNC_ID					\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index ab4f5d160c58f..6e4dba9eadef5 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -634,9 +634,8 @@ static bool do_ffa_features(struct arm_smccc_res *res,
 	return true;
 }
 
-bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
+bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
-	DECLARE_REG(u64, func_id, host_ctxt, 0);
 	struct arm_smccc_res res;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 857d9bc04fd48..2385fd03ed87c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -368,6 +368,7 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	if (static_branch_unlikely(&kvm_protected_mode_initialized))
 		hcall_min = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize;
 
+	id &= ~ARM_SMCCC_CALL_HINTS;
 	id -= KVM_HOST_SMCCC_ID(0);
 
 	if (unlikely(id < hcall_min || id >= ARRAY_SIZE(host_hcall)))
@@ -392,11 +393,14 @@ static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
 
 static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 {
+	DECLARE_REG(u64, func_id, host_ctxt, 0);
 	bool handled;
 
-	handled = kvm_host_psci_handler(host_ctxt);
+	func_id &= ~ARM_SMCCC_CALL_HINTS;
+
+	handled = kvm_host_psci_handler(host_ctxt, func_id);
 	if (!handled)
-		handled = kvm_host_ffa_handler(host_ctxt);
+		handled = kvm_host_ffa_handler(host_ctxt, func_id);
 	if (!handled)
 		default_host_smc_handler(host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 24543d2a34905..d57bcb6ab94d2 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -273,9 +273,8 @@ static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_
 	}
 }
 
-bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt)
+bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
-	DECLARE_REG(u64, func_id, host_ctxt, 0);
 	unsigned long ret;
 
 	switch (kvm_host_psci_config.version) {
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 90fade1b032e4..1cc06e6797bda 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -57,6 +57,7 @@ __do_hyp_init:
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.lo	__kvm_handle_stub_hvc
 
+	bic	x0, x0, #ARM_SMCCC_CALL_HINTS
 	mov	x3, #KVM_HOST_SMCCC_FUNC(__kvm_hyp_init)
 	cmp	x0, x3
 	b.eq	1f
-- 
2.42.0

