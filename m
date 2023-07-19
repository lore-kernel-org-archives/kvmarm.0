Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5458A1FC1
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 15:06:45 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57a43b50c2fso48863237b3.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 08:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689779204; x=1690384004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7LR1yZCe6VNGLtdEg+gtFFnsUjwyDUwihFVFC00Q/lI=;
        b=moxbz2P9Mesy64+3mcpQFY9sVLeUnrMDYzr94rnrSeCeNDbJcv3Lb/5leIe76xicam
         yOVOX4fdil/NBeqyEGbD8uSdGzWlLkdpZO9t9IdH8On/1igVmC5K/SpV0+DAzDLg1oZV
         3WCNTXWb5qLmr/9XqIAzDpdLxm3ymbv2hKaca/SE8lZY1L35oaxEzowZHQSzwaFi3fae
         DtgL/EGtM1PUVI/mhBuYTE/rhS1E7Iq/sK/e8Le9TB4r/Fr2uEC4zxPaMhtXQBJrArcw
         Xs6b+ktLCCSQUlFzEuxifJBTo9/szEx8WUg9HiO+8Pz64sGsyXvAUc6A2BEQK+V+piCd
         paCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689779204; x=1690384004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7LR1yZCe6VNGLtdEg+gtFFnsUjwyDUwihFVFC00Q/lI=;
        b=Z+1wmJgK+sH7aaXmPjfwT4nrn5buDUvtH+kU13dcAY/TCdECw32cUXbQziCFGJoRrR
         PQ9ZZJEgOsTz50r8E9y8zUkpQBLc6ujyTGU2bwyAWX0EZZI2bkyH5e4ZnyxEGDNpulbm
         2Imi6nkwThnDEg7pKCO1e43VRE4ct3R3i4uAhInkOsRXeudK305pItAMpskh0m0B0GQ9
         tiT49aZFo+zbggvGvG2qZO8kggHwEPpPqk16dNlXTgnNcl+9tfSyePrRkmK9YeQPCWpT
         l/VTpgFw0KQWsZlvz7SiJ/kuLSBCzREZ8iy5Vs50dAneD03AUoFvGK8xnGDos9V2ZFwV
         nc0g==
X-Gm-Message-State: ABy/qLYbdQsztatIPo5UZzNXqDmcSpB0wSraa5QcTEWqgQPYwrm8a9Gu
	fyJr/7ycA5ZR2BkNU/hY4jSbWlRbIItrVsF0eVfz49Y4KJLeO7NSRJp0ucS7srZspv5kEwaPAF4
	z1px3G7tsL5ybQNSjAUrSf8CfD3b8GecWF7TckqTbgZK39GboHlzms0ME8pM=
X-Google-Smtp-Source: APBJJlH11DgHhMclm1qRir5tEb+iNxZ4AdEE4Wu+o2E2tvfRJtU8Iltwvyoi6nh2SZ0mNIbh9nw4kiIGmg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1005:b0:cb3:c343:19e5 with SMTP id
 w5-20020a056902100500b00cb3c34319e5mr30517ybt.2.1689779203898; Wed, 19 Jul
 2023 08:06:43 -0700 (PDT)
Date: Wed, 19 Jul 2023 16:06:35 +0100
In-Reply-To: <20230719150639.1968034-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230719150639.1968034-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230719150639.1968034-2-tabba@google.com>
Subject: [PATCH v1 1/5] KVM: arm64: Use the appropriate feature trap register
 for SVE at EL2 setup
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Use the architectural feature trap/control register that
corresponds to the current KVM mode, i.e., CPTR_EL2 or CPACR_EL1,
when setting up SVE feature traps.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/el2_setup.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 8e5ffb58f83e..c106b31d776c 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -143,11 +143,12 @@
 	and	x1, x1, #HCR_E2H
 	cbz	x1, .LnVHE_\@
 	mov	x0, #(CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN)
-	b	.Lset_cptr_\@
+	msr	cpacr_el1, x0
+	b	.Lskip_set_cptr_\@
 .LnVHE_\@:
 	mov	x0, #0x33ff
-.Lset_cptr_\@:
 	msr	cptr_el2, x0			// Disable copro. traps to EL2
+.Lskip_set_cptr_\@:
 .endm
 
 /* Disable any fine grained traps */
@@ -268,19 +269,21 @@
 	check_override id_aa64pfr0, ID_AA64PFR0_EL1_SVE_SHIFT, .Linit_sve_\@, .Lskip_sve_\@, x1, x2
 
 .Linit_sve_\@:	/* SVE register access */
-	mrs	x0, cptr_el2			// Disable SVE traps
 	mrs	x1, hcr_el2
 	and	x1, x1, #HCR_E2H
 	cbz	x1, .Lcptr_nvhe_\@
 
-	// VHE case
+	// (h)VHE case
+	mrs	x0, cpacr_el1			// Disable SVE traps
 	orr	x0, x0, #(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
-	b	.Lset_cptr_\@
+	msr	cpacr_el1, x0
+	b	.Lskip_set_cptr_\@
 
 .Lcptr_nvhe_\@: // nVHE case
+	mrs	x0, cptr_el2			// Disable SVE traps
 	bic	x0, x0, #CPTR_EL2_TZ
-.Lset_cptr_\@:
 	msr	cptr_el2, x0
+.Lskip_set_cptr_\@:
 	isb
 	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
 	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
-- 
2.41.0.255.g8b1d071c50-goog

