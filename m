Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A5F62D
	for <kvmarm@lists.linux.dev>; Mon, 29 May 2023 02:48:55 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-64d1e96c082so2075683b3a.1
        for <kvmarm@lists.linux.dev>; Sun, 28 May 2023 19:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1685328535; x=1687920535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G4Nb/gFMm8Ye9wyALRV/xgn92872VRuD4vbstmC2QEw=;
        b=NOjWamSYnCLQvYfKu8DJq+B0/i3lMIg0lSMnghs2kA7eYtwehwitTw8cfLbYhKd0ju
         foqc4dLoVmDgrUN4Ezs5H6a7UBsIJyFrXiEacDO5HjrImstFrJvGqwuZrTatKkTAarSE
         O+Y2NpFKFMia/vtb7J1ZW03ErSdff5CWJI7/jkRzHLzbcdT4JCqNigWlprjEou16haR6
         Pl0P+rk2jW8g8oJx7qBpc4A1n3D6xsfQX5BwzPvKJO3WcrhXerEgnyX6/Pa/4w0Vm83i
         6CFPiuIuLuF8HOg6QCCOk/haz6HHhzZn4V+eoWVH1z27pqmnnEBa/0ximUKIKtaAC/IJ
         jFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685328535; x=1687920535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G4Nb/gFMm8Ye9wyALRV/xgn92872VRuD4vbstmC2QEw=;
        b=K8nl6eD2xiW803UdjXH4Xis1neBLunH3UmkzSr9wnhPEK4ANxDAqGwD7aAJiqG5OAn
         Hj+U7UwnVkApdgmezOFyod2QcA1WXEmXH83Vt6WZ9q8L4TqfgoJ9l4eW5HSTz3cyk2zd
         OtHAM6k0LH1kDUjb4wdb6737L4fOXsKcKXagtNf/nJejRDOdUqdnjSwZq7X7GaO/RP4/
         wFvn6N7CAdeawZbsZTaWhe1LeLJ/7UazsGOcRpmYvZWLmCUBYJQtXcmk3LRUbVUX1PIH
         vjyfIEgU9Afuk7LkA1XgubdWLh+F8PcURnjXQ0MOVBWR0aU3FT6OlCpf7dgZ6uxR4xgV
         l4MA==
X-Gm-Message-State: AC+VfDy5amvbix7HnJcYVWMpuk7O1ObONEcEAKCApMIlSs/2FTrdcGuN
	owZP4JoQ4oh1m0cmPUYL3fPe2g==
X-Google-Smtp-Source: ACHHUZ4mx6kzGcSLWLye7VJKM8QzXipRR+WZ0JOezVy9o+7MbOB0M4Cmb/lafTqjjm77gYCEBD9Uxw==
X-Received: by 2002:a05:6a00:1486:b0:647:b6c9:179d with SMTP id v6-20020a056a00148600b00647b6c9179dmr15084106pfu.21.1685328535460;
        Sun, 28 May 2023 19:48:55 -0700 (PDT)
Received: from fedora.. ([157.82.203.71])
        by smtp.gmail.com with ESMTPSA id c8-20020aa78c08000000b0063d2d9990ecsm5791039pfd.87.2023.05.28.19.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 19:48:55 -0700 (PDT)
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
Subject: [PATCH] KVM: arm64: Populate fault info for watchpoint
Date: Mon, 29 May 2023 11:48:47 +0900
Message-Id: <20230529024847.8671-1-akihiko.odaki@daynix.com>
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
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 6 ++++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..2eb0a1481ead 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -351,7 +351,7 @@ static bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+static bool kvm_hyp_handle_generic_fault(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (!__populate_fault_info(vcpu))
 		return true;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c2cb46ca4fb6..1b77866079dc 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -184,8 +184,9 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
-	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
+	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_generic_fault,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_generic_fault,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
@@ -194,8 +195,9 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
 	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
-	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
+	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_generic_fault,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_generic_fault,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1a97391fedd2..08ae0ee4697b 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -108,8 +108,9 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
-	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
+	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_generic_fault,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_generic_fault,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-- 
2.40.1

