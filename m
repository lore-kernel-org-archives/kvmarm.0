Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B12C1A725
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kUD40ZEe"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-333503fd5bdso488102f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857113; x=1702461913; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4emEZgCht3g7YAgleMBhSuxLFdgddUkyW+dgth2uuoc=;
        b=kUD40ZEebZ2szbCJdKBwMwwOu8ylKz7JmsNkGtGTXXa+Xbiv7IhzTqrzhihZ4pG2d0
         acZyBG096pSmqWbKs1kKsBIQlD2TUiF+CQ8ZtFLwL1fCijcGozE2Gnh2SuBsCiB46eF2
         RCrEgBEHFB9M0wfw0rnO5VoOwVvqxum/dAhI5JC1Uo/TKN0k8ivHuU869bOSOhgOl9od
         fFip/OpErcu6sXHoG3s063BmIKOEA8IAzVL01eWSKcyHTKr50W2VLyYY4c2LXCHjLvJw
         A4GmGC9lCbnHDXT2ITh4ttIMkMFcoKZHuc/5+PuAMOrYQJR8bB7xhDYsETxzbc0akCPS
         k/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857113; x=1702461913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4emEZgCht3g7YAgleMBhSuxLFdgddUkyW+dgth2uuoc=;
        b=EF+HZPS+0qpczGCwPEe8g6q5JmxwxsDQUa1oLG0gd9Ob7zkxgVmZTJXDElrwOO1SfU
         OBaStqgFmZtfSKlbei2RAcpBSCm4nlpOQ+snpmFbWbH486eIw6qrEPf48qzcDpyJaIe8
         em8jGNQfxJ9GvvmDbSTwX5tkfleZJiCtESL/TTbBtx63jlqBx+coYx+/HiafyPJWZ6XN
         igiGhuZPZ0Qur+XjKKw1kFM2rHcWAdkaGnTdNTMZUBhY91b44NL6Q+LX4p73P0Izp66Y
         j33oKC6r1jKmR+c6gVG9RxojYtazPqQt8vHqi6Wc08T6l/aCEidpvKFmyrb6RYShLQLl
         Q0ZQ==
X-Gm-Message-State: AOJu0YyCvOLyPq/MX8oswsOmj3RNJIXrXoJPWmGaX7oYaJ8+cQGFPQr7
	DBNaaErqlUQIRWGt3qftBNPdQ9PhJJCbYKobmxEbZf464jrC8aYQyO5/wGgduMAJ7e6as5iXb2d
	/TBfnhzEQvHSQqG9leZKkSrhubw++RxKSKPS+x+rH1A5M8TJx4B8WaeTllhg=
X-Google-Smtp-Source: AGHT+IEv+1m5kkwwlrBEnwaIOLyd7g2RxSvIRGBWo9YXHGk+nCbTeViePGtmzBdh+c5B8e2yspcPiPQNVQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:b613:0:b0:333:6374:9da7 with SMTP id
 f19-20020adfb613000000b0033363749da7mr2962wre.13.1701857112375; Wed, 06 Dec
 2023 02:05:12 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:53 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-4-tabba@google.com>
Subject: [PATCH v2 03/12] KVM: arm64: Add latest HFGITR_EL2 FGT entries to
 nested virt
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the missing nested virt FGT table entries HFGITR_EL2. Based
on the 2023-09 Arm Architecture System Registers xml
specification [*]. Add the missing field definitions as well,
both to generate the correct RES0 mask and to be able to toggle
their FGT bits.

Also adds definitions of some of the missing system registers and
instructions, which can be trapped by the FGT bits.

[*] https://developer.arm.com/downloads/-/exploration-tools

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 arch/arm64/kvm/emulate-nested.c | 5 +++++
 arch/arm64/tools/sysreg         | 4 +++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7b469b3ac1f9..5892f9f1b541 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -658,6 +658,7 @@
 #define OP_AT_S1E0W	sys_insn(AT_Op0, 0, AT_CRn, 8, 3)
 #define OP_AT_S1E1RP	sys_insn(AT_Op0, 0, AT_CRn, 9, 0)
 #define OP_AT_S1E1WP	sys_insn(AT_Op0, 0, AT_CRn, 9, 1)
+#define OP_AT_S1E1A	sys_insn(AT_Op0, 0, AT_CRn, 9, 2)
 #define OP_AT_S1E2R	sys_insn(AT_Op0, 4, AT_CRn, 8, 0)
 #define OP_AT_S1E2W	sys_insn(AT_Op0, 4, AT_CRn, 8, 1)
 #define OP_AT_S12E1R	sys_insn(AT_Op0, 4, AT_CRn, 8, 4)
@@ -794,10 +795,16 @@
 #define OP_TLBI_VMALLS12E1NXS		sys_insn(1, 4, 9, 7, 6)
 
 /* Misc instructions */
+#define OP_GCSPUSHX			sys_insn(1, 0, 7, 7, 4)
+#define OP_GCSPOPCX			sys_insn(1, 0, 7, 7, 5)
+#define OP_GCSPOPX			sys_insn(1, 0, 7, 7, 6)
+#define OP_GCSPUSHM			sys_insn(1, 3, 7, 7, 0)
+
 #define OP_BRB_IALL			sys_insn(1, 1, 7, 2, 4)
 #define OP_BRB_INJ			sys_insn(1, 1, 7, 2, 5)
 #define OP_CFP_RCTX			sys_insn(1, 3, 7, 3, 4)
 #define OP_DVP_RCTX			sys_insn(1, 3, 7, 3, 5)
+#define OP_COSP_RCTX			sys_insn(1, 3, 7, 3, 6)
 #define OP_CPP_RCTX			sys_insn(1, 3, 7, 3, 7)
 
 /* Common SCTLR_ELx flags. */
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 8b473a1bbc11..89901550db34 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1117,6 +1117,11 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_AFSR1_EL1, 		HFGxTR, AFSR1_EL1, 1),
 	SR_FGT(SYS_AFSR0_EL1, 		HFGxTR, AFSR0_EL1, 1),
 	/* HFGITR_EL2 */
+	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
+	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
+	SR_FGT(OP_GCSPUSHX, 		HFGITR, nGCSEPP, 0),
+	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
+	SR_FGT(OP_GCSPUSHM, 		HFGITR, nGCSPUSHM_EL1, 0),
 	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
 	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),
 	SR_FGT(SYS_DC_CVAC, 		HFGITR, DCCVAC, 1),
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index c6cc8f2396e6..61cc3bcfc3fa 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2102,7 +2102,9 @@ Fields	HFGxTR_EL2
 EndSysreg
 
 Sysreg HFGITR_EL2	3	4	1	1	6
-Res0	63:61
+Res0	63
+Field	62	ATS1E1A
+Res0	61
 Field	60	COSPRCTX
 Field	59	nGCSEPP
 Field	58	nGCSSTR_EL1
-- 
2.43.0.rc2.451.g8631bc7472-goog

