Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA20F1A725
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wHkH55xA"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33331e69698so516200f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857110; x=1702461910; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fllstZe0TUWUwjolPsk8Qr4Z05k2c/KSz4LIDdDQWR0=;
        b=wHkH55xAv+e5KyyfYmanph0FC9ll/av1ivjTLeL/GaPQb6GOzPeRurHmkoLxYcYQx5
         XW0LJHjx065oxUKU35xSuuvXo1pKYspX2Ckd9eDLaJm1Koi2zHOrm1FrQLuqQUGdHLq0
         hNWXp9oyxBx2iiUYtcGbKD5uSBUVzi6wj7iHvjtmkCJo1pCAL2ccQqHtXyvdbb6kWkT9
         +4KIK+SPEQn3dv1EPRoELLUjHw1DSbGKoMIROjcCKQzzFoWRl3lpLMD3evHUHH1ygw2W
         kIpNei6KoKM1GuzuUyPkNowfjK9aPTuJnub9LHT/DKGYzuJZa8ttTJtDfGCn+pS+iywH
         S7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857110; x=1702461910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fllstZe0TUWUwjolPsk8Qr4Z05k2c/KSz4LIDdDQWR0=;
        b=vNgseWsjK5Eo6P97ZK9I7SsocL/xEIEKNTLBmKETm9X72ljTAqxMKtSt7C58Q+51fS
         MzbM8VfDAoZLfCHpvoQnrYlhNPICIPZ+R8pE9UbPyKd1qjd1TGeR8/KqNr13/L25TvKX
         EH45K45cKTSQ1IAsTWQiPS8nI7a3i44ipE86Kt2IZH+F71DTUgwmVDQLwqY1GABMukKA
         gUouSdSuqrh9TOmyYLW2zSgqhag96pGXvmGIjB0Ac2YTB6KQuJO2tvl83v2bFbTRybZF
         gMk9JvSJscuoiMUl0KFM/+6AgxwkwZaJjiw9dnCk+Llj4VpOkBb0mQKtMxXOyZk1a++N
         JCkw==
X-Gm-Message-State: AOJu0YxEJYw92Y7b/VZbZD4TAOFztAcCN6b32T7QukpipEaQkvcOoYrH
	fkH4bWAGJG06UE892fkDfKupN7C/qzDV8TEKrI4bRxq3B/FkNeQIiEzmi5P6fWWGxiog7Teyxgz
	gRas1IkCcxT889DWj/1v25NT+9pB9LNL4a3gQFOyO+2s3Uot6LWmKJsGjY9o=
X-Google-Smtp-Source: AGHT+IG8bFxlibva7s7MJBG/XyNjr1Q5Cs+KItTvcqc4K1NmdWg8tSPNsolg5Kegs6PDsLRL7MvOG4cOwQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:111:b0:333:3f96:6eb8 with SMTP id
 o17-20020a056000011100b003333f966eb8mr2882wrx.14.1701857109880; Wed, 06 Dec
 2023 02:05:09 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:52 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-3-tabba@google.com>
Subject: [PATCH v2 02/12] KVM: arm64: Add latest HFGxTR_EL2 FGT entries to
 nested virt
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the missing nested virt FGT table entries HFGxTR_EL2. Based
on the 2023-09 Arm Architecture System Registers xml
specification [*].

Also adds definitions of some of the missing system registers,
which can be trapped by the FGT bits.

[*] https://developer.arm.com/downloads/-/exploration-tools

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h | 13 +++++++++++++
 arch/arm64/kvm/emulate-nested.c | 10 ++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 5e65f51c10d2..7b469b3ac1f9 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -297,6 +297,10 @@
 #define SYS_APGAKEYLO_EL1		sys_reg(3, 0, 2, 3, 0)
 #define SYS_APGAKEYHI_EL1		sys_reg(3, 0, 2, 3, 1)
 
+#define SYS_GCSCR_EL1			sys_reg(3, 0, 2, 5, 0)
+#define SYS_GCSPR_EL1			sys_reg(3, 0, 2, 5, 1)
+#define SYS_GCSCRE0_EL1			sys_reg(3, 0, 2, 5, 2)
+
 #define SYS_SPSR_EL1			sys_reg(3, 0, 4, 0, 0)
 #define SYS_ELR_EL1			sys_reg(3, 0, 4, 0, 1)
 
@@ -356,7 +360,11 @@
 #define SYS_PMMIR_EL1			sys_reg(3, 0, 9, 14, 6)
 
 #define SYS_MAIR_EL1			sys_reg(3, 0, 10, 2, 0)
+#define SYS_MAIR2_EL1			sys_reg(3, 0, 10, 2, 1)
+#define SYS_POR_EL1			sys_reg(3, 0, 10, 2, 4)
+#define SYS_S2POR_EL1			sys_reg(3, 0, 10, 2, 5)
 #define SYS_AMAIR_EL1			sys_reg(3, 0, 10, 3, 0)
+#define SYS_AMAIR2_EL1			sys_reg(3, 0, 10, 3, 1)
 
 #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
 #define SYS_DISR_EL1			sys_reg(3, 0, 12, 1, 1)
@@ -390,6 +398,7 @@
 #define SYS_ICC_IGRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
 
 #define SYS_ACCDATA_EL1			sys_reg(3, 0, 13, 0, 5)
+#define SYS_RCWMASK_EL1			sys_reg(3, 0, 13, 0, 6)
 
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
@@ -398,6 +407,8 @@
 #define SYS_RNDR_EL0			sys_reg(3, 3, 2, 4, 0)
 #define SYS_RNDRRS_EL0			sys_reg(3, 3, 2, 4, 1)
 
+#define SYS_GCSPR_EL0			sys_reg(3, 3, 2, 5, 1)
+
 #define SYS_PMCR_EL0			sys_reg(3, 3, 9, 12, 0)
 #define SYS_PMCNTENSET_EL0		sys_reg(3, 3, 9, 12, 1)
 #define SYS_PMCNTENCLR_EL0		sys_reg(3, 3, 9, 12, 2)
@@ -412,6 +423,8 @@
 #define SYS_PMUSERENR_EL0		sys_reg(3, 3, 9, 14, 0)
 #define SYS_PMOVSSET_EL0		sys_reg(3, 3, 9, 14, 3)
 
+#define SYS_POR_EL0			sys_reg(3, 3, 10, 2, 4)
+
 #define SYS_TPIDR_EL0			sys_reg(3, 3, 13, 0, 2)
 #define SYS_TPIDRRO_EL0			sys_reg(3, 3, 13, 0, 3)
 #define SYS_TPIDR2_EL0			sys_reg(3, 3, 13, 0, 5)
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 06185216a297..8b473a1bbc11 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1042,10 +1042,20 @@ enum fg_filter_id {
 
 static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	/* HFGRTR_EL2, HFGWTR_EL2 */
+	SR_FGT(SYS_AMAIR2_EL1,		HFGxTR, nAMAIR2_EL1, 0),
+	SR_FGT(SYS_MAIR2_EL1,		HFGxTR, nMAIR2_EL1, 0),
+	SR_FGT(SYS_S2POR_EL1,		HFGxTR, nS2POR_EL1, 0),
+	SR_FGT(SYS_POR_EL1,		HFGxTR, nPOR_EL1, 0),
+	SR_FGT(SYS_POR_EL0,		HFGxTR, nPOR_EL0, 0),
 	SR_FGT(SYS_PIR_EL1,		HFGxTR, nPIR_EL1, 0),
 	SR_FGT(SYS_PIRE0_EL1,		HFGxTR, nPIRE0_EL1, 0),
+	SR_FGT(SYS_RCWMASK_EL1,		HFGxTR, nRCWMASK_EL1, 0),
 	SR_FGT(SYS_TPIDR2_EL0,		HFGxTR, nTPIDR2_EL0, 0),
 	SR_FGT(SYS_SMPRI_EL1,		HFGxTR, nSMPRI_EL1, 0),
+	SR_FGT(SYS_GCSCR_EL1,		HFGxTR, nGCS_EL1, 0),
+	SR_FGT(SYS_GCSPR_EL1,		HFGxTR, nGCS_EL1, 0),
+	SR_FGT(SYS_GCSCRE0_EL1,		HFGxTR, nGCS_EL0, 0),
+	SR_FGT(SYS_GCSPR_EL0,		HFGxTR, nGCS_EL0, 0),
 	SR_FGT(SYS_ACCDATA_EL1,		HFGxTR, nACCDATA_EL1, 0),
 	SR_FGT(SYS_ERXADDR_EL1,		HFGxTR, ERXADDR_EL1, 1),
 	SR_FGT(SYS_ERXPFGCDN_EL1,	HFGxTR, ERXPFGCDN_EL1, 1),
-- 
2.43.0.rc2.451.g8631bc7472-goog

