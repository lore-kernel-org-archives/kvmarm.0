Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD5C23761
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PFHO9Xg/"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5d3bdbf1fb5so83077137b3.2
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857128; x=1702461928; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qLijKD8q5uEfTH/4BglE/UZ689qP1bE0/PcejI4q2w=;
        b=PFHO9Xg/GpJq2IYiEQWwEpFKCUZQ3QDrRUVxx1Dc1F7hNQhDIp1qVGkBbA2k8Cooqj
         oa4kiqLRsve93krFRe10dH+bfROo6nath49qHNozFa3iR38vMreog3FL5o8Qk4vvHUXC
         Gx4iV3TCmiqLXuwPNZ2eW2cRcQ0UuVkRgJlIEuqwv8OaITOcIqhHU+pVl0RIWCSoYzUt
         6Pg1uOxm55W/WQuLIRIY7GeWiWVUwVCWJUNyyc2cXNXiv2aKaVrD8v81teCMY3wBQd41
         vAwawDagUCsyl8khKdHDzW9wdDButHkhoiI3Hkosr0NSU/felVyAlDR3QKKCBsQtN+NJ
         RZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857128; x=1702461928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qLijKD8q5uEfTH/4BglE/UZ689qP1bE0/PcejI4q2w=;
        b=qFEp0MbP/yJ9fs56PXtUy/Bdq0qZuY8dUlirCgxRv0O9DmUgGSRd7z656CI1RxEpZE
         G4ugc1POt+wUi4fjflyC9eDZ/5Uck1S9AVWg93UX+5YjOjZEL4ycAnmfu3SB+d7/awYN
         G1ff4PdUcP7WoUTGuCBG3uchJTamYugTAP5NFAuR3CdFxFeSpHo3Un8nQ9IzZV4Kd6KK
         Pbz8xUwQCH3anIA1/c7rq+1a/HVPL4e99ZzDtjThPjmDYZhimJ8rcrbdZVI+QkiMZu0g
         y6y6y8ZiTVtxcqDVXmNMgBVSqBZyB1CstmtxGebGeFi0K3VUlKvdAyM29whE2MRS76pc
         KL9Q==
X-Gm-Message-State: AOJu0YxdtZpM6vr9TMD8kSTgsvHdQpLp4JTygL3lI37oEVma+R7jeTxd
	lfSmQVIo1sQcx0G+0Zi6LnXQsHyFouS3ylYzVBbl/A91dRrTDj8qTIpfSEmBjZb9XQlC/pY3d1E
	/FhlxTn/8xWyEerrABnsYK95239IgtRpGbJ0exkfbrPRRDUd1h8l5IYytxOo=
X-Google-Smtp-Source: AGHT+IHKjvyKeYLrkS5ZZWyHnurnfbOJDHjyqa85gizom7o/uhstJUGb/tajT9c++1MeaHJGxuTLhm2I1A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:be14:0:b0:5d0:a744:719b with SMTP id
 i20-20020a81be14000000b005d0a744719bmr7672ywn.0.1701857127610; Wed, 06 Dec
 2023 02:05:27 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:59 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-10-tabba@google.com>
Subject: [PATCH v2 09/12] KVM: arm64: Generate the HFGWTR-only RES0 bits
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Generate the HFGWTR-only RES0 bits in sysreg. This is done to
consolidate all the bit definitions in one place.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 13 +++----------
 arch/arm64/tools/sysreg          | 26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5b634e909d1c..02442bc90717 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -348,16 +348,9 @@
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
 #define __HFGRTR_EL2_nMASK	(GENMASK(63, 52) | BIT(50))
 
-/*
- * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
- * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
- */
-#define __HFGxTR_READ_ONLY_MASK	(BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
-				 GENMASK(26, 25) | BIT(21) | BIT(18) | \
-				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
-#define __HFGWTR_EL2_RES0	(__HFGRTR_EL2_RES0 | __HFGxTR_READ_ONLY_MASK)
-#define __HFGWTR_EL2_MASK	(__HFGRTR_EL2_MASK & ~__HFGxTR_READ_ONLY_MASK)
-#define __HFGWTR_EL2_nMASK	(__HFGRTR_EL2_nMASK & ~__HFGxTR_READ_ONLY_MASK)
+#define __HFGWTR_EL2_RES0	(__HFGRTR_EL2_RES0 | HFGWTR_ONLY_EL2_RES0)
+#define __HFGWTR_EL2_MASK	(__HFGRTR_EL2_MASK & ~HFGWTR_ONLY_EL2_RES0)
+#define __HFGWTR_EL2_nMASK	(__HFGRTR_EL2_nMASK & ~HFGWTR_ONLY_EL2_RES0)
 
 #define __HFGITR_EL2_RES0	HFGITR_EL2_RES0
 #define __HFGITR_EL2_MASK	(BIT(62) | BIT(60) | GENMASK(54, 0))
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index e5631f4e62f4..85f8b385fed2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2093,6 +2093,32 @@ Field	1	AFSR1_EL1
 Field	0	AFSR0_EL1
 EndSysregFields
 
+# HFGWTR_EL2 bits are a subset of those for HFGRTR_EL2.
+# Define RES0 only present in HFGWTR_EL2.
+SysregFields	HFGWTR_ONLY_EL2
+Unkn	63:47
+Res0	46
+Unkn	45:43
+Res0	42
+Unkn	41
+Res0	40
+Unkn	39:29
+Res0	28
+Unkn	27
+Res0	26:25
+Unkn	24:22
+Res0	21
+Unkn	20:19
+Res0	18
+Unkn	17:16
+Res0	15:14
+Unkn	13:11
+Res0	10:9
+Unkn	8:3
+Res0	2
+Unkn	1:0
+EndSysregFields
+
 Sysreg HFGRTR_EL2	3	4	1	1	4
 Fields	HFGxTR_EL2
 EndSysreg
-- 
2.43.0.rc2.451.g8631bc7472-goog

