Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2437FB
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 02:47:14 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2566ed9328eso1735033a91.2
        for <kvmarm@lists.linux.dev>; Mon, 29 May 2023 19:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1685414834; x=1688006834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=alV8inSLdkpveU+gErF0Hqmj8NeaEg9f/ZBWhD5ez2U=;
        b=VXyb2L0Lk9rF7WpImdHVoDcV+wHY1TpjAjC6TnDsrpgVCNTBuP+09WDoovYSiQjFKp
         EyxL1UVZBQ8nW28vfQL72iihabRnhi/EkD8gk5OONuEfLhM+7gyFIuZ7gyhMgwCU+N4W
         pezZ+Dmt9GIkAGHjmh34aCGDBos3FhMi9ipGNE/4+KA2Jldfys+/6gNvVkHEqP2srBq3
         T0H6/N5WI5tiwwj9Vk+x1MlRC9IL1vjeh4j22arGcxuzaoP267EdprZlv6D2nwJHQrn6
         LLBLFXd1d0JlKwxP+YzIDQSbUuT51wptUFFfemshptbvqcUslGnBI1URWLf7UVKDT83K
         35QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685414834; x=1688006834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=alV8inSLdkpveU+gErF0Hqmj8NeaEg9f/ZBWhD5ez2U=;
        b=lj9I8/cHGHFWcG25tWhAPcdiS++krL7hEGj6uh7hwZLN/ziymuzDMBgcktYpCXHB8J
         gRXCBIcyhnhoZSSHmcjvP2cOQ1Lhx/GO1jlfEl2fM86dHg1GpQ33327f4NQN188zxluT
         ytAJYOeJNacSX3uyxRGWgicFsEEg6FYlT4792SPDDTuQhfrIcxspkjga+E5IhDPqCD2z
         9hbRopNcjmdSeuG4SqQ5KqSXiqdhWOArVZgK+cNsXnMDUE5AdxmKlkDJGh2iST7U87E3
         QLb32TiH4/HiDbITrq+PXAQMnauc73XPvSbXDSiVxGRrqJNsvnkTSF9ZwlNPRBgu/J7X
         NZIQ==
X-Gm-Message-State: AC+VfDxpbf7amBJj1+FiBKOF243UX0T6Ugrh0kSXh56kDYz9KIEBhz8x
	cJSuSDgLY099+otJeEAPlHSw+A==
X-Google-Smtp-Source: ACHHUZ5esirN+GjiMvMiqRhafSMP/4L6Nwl3/8gg9VPgzza/IsiTQ+IctgDBLZQizuhsmpqFTzEGGg==
X-Received: by 2002:a17:902:da82:b0:1b0:5ce9:adbb with SMTP id j2-20020a170902da8200b001b05ce9adbbmr967084plx.45.1685414834012;
        Mon, 29 May 2023 19:47:14 -0700 (PDT)
Received: from fedora.. ([157.82.203.71])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b001aaf370b1c7sm8926329pli.278.2023.05.29.19.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 19:47:13 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v2] KVM: arm64: Populate fault info for watchpoint
Date: Tue, 30 May 2023 11:46:51 +0900
Message-Id: <20230530024651.10014-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When handling ESR_ELx_EC_WATCHPT_LOW, far_el2 member of struct
kvm_vcpu_fault_info will be copied to far member of struct
kvm_debug_exit_arch and exposed to the userspace. The userspace will
see stale values from older faults if the fault info does not get
populated.

Fixes: 8fb2046180a0 ("KVM: arm64: Move early handlers to per-EC handlers")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 8 ++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 ++
 arch/arm64/kvm/hyp/vhe/switch.c         | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..33f4d4200329 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -351,17 +351,21 @@ static bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+static bool kvm_hyp_handle_memory_fault(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (!__populate_fault_info(vcpu))
 		return true;
 
 	return false;
 }
+static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+	__alias(kvm_hyp_handle_memory_fault);
+static bool kvm_hyp_handle_watchpt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+	__alias(kvm_hyp_handle_memory_fault);
 
 static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	if (!__populate_fault_info(vcpu))
+	if (kvm_hyp_handle_memory_fault(vcpu, exit_code))
 		return true;
 
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c2cb46ca4fb6..895fb3200076 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -186,6 +186,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
@@ -196,6 +197,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1a97391fedd2..45ac4a59cc2c 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -110,6 +110,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-- 
2.40.1

