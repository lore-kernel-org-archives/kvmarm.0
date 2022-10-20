Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C8CC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 05:42:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1D94B91F;
	Thu, 20 Oct 2022 01:42:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hdy6w8FHbhrD; Thu, 20 Oct 2022 01:42:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5092B4B8E6;
	Thu, 20 Oct 2022 01:42:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E30A49673
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:42:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OE32ShzyRaCL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 01:42:45 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DB524005D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:42:45 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 n6-20020a5b0486000000b006aff8dc9865so18277939ybp.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 22:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=ELzAVn+3sNc+4loFg06+kDTn2r7oBUPNaJZquHZJGM8=;
 b=JHe9BhP8WxnUbibz6mt6YrXKaJ8YGE5HpO4NBAJasDjfzX6DH+FcWz/XA8i3DPgO+p
 IdhKCFDnzk5HbJ3oNT6RDfyg0Z9C0EeQ/XxJ9EKICgTXNawqyOk+vgb5hFo6UQCx8nVK
 ZKTsmXkj0jLCeWzC+WMWjrRGS8WDAy/749MHc14vQ5evsPc2NXLmx8VNJ0rbBnvb2/Xy
 5zI6/pvcBwkVjN6NACbeFpP/E8FMP+cwvZJ0Ovuy025NxlUFlKNnp01rl1mOEO7w90LG
 Gr+BX+BLdl8IPeROXbXAfLtkFLRqlwTO2L54IxyzvTlT6LqkZffO7mKaveT3ZeinuHqe
 vENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ELzAVn+3sNc+4loFg06+kDTn2r7oBUPNaJZquHZJGM8=;
 b=o7uFluBZ3DEyhgvdVstr6iucOQmCty2TyEmgT/ZO+1xpaJmYkxp7yMFlGoKK4oblWC
 7WN4dsRqwbaa6ICTmsZpBdZ6n4eWnLdb9SwC7mbNjdLQMj/agXVnLCwfyPZ/ctuenW5r
 54XRnX29Btz3eU5sTA5At6/4T6mLIHYo5k10oZgBFGv7dV/qNFJcB4nheSD49OEYBOC4
 kl+bNDHtTc4UVrCmBaUe/V/C0zPNIXxuN2CITKWqizJiUfQU+/SZt8QMGv3rV/aQkrRH
 jUKSZ+QmsEHl3hip7ggdLy9q03Kx0FOkMRzXsRfHZhP0XL8RzS1W8r0AQyn3pQgtv6bS
 ChmQ==
X-Gm-Message-State: ACrzQf36WRoFwBenOUC8v3mTUuP6rASAq2zzWdEdHlIgXaKh+4vgaIVx
 WtSR2KHYt61a0zmjuY5fBr5Auu0xulE=
X-Google-Smtp-Source: AMsMyM40Wdm+aeMOq5/+3bxZYEWlyCvjAW5HTHRrIls1sP9psLlqv/cFoMirmbh8Ju7nrRwXqbWzEiB5zBY=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a0d:eb88:0:b0:367:284a:a4a with SMTP id
 u130-20020a0deb88000000b00367284a0a4amr5163460ywe.282.1666244564673; Wed, 19
 Oct 2022 22:42:44 -0700 (PDT)
Date: Wed, 19 Oct 2022 22:41:55 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-3-reijiw@google.com>
Subject: [PATCH v2 2/9] KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r
 helpers in debug-exceptions
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Introduce helpers in the debug-exceptions test to write to
dbg{b,w}{c,v}r registers. Those helpers will be useful for
test cases that will be added to the test in subsequent patches.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>

---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 72 +++++++++++++++++--
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 3808d3d75055..d9884907fe87 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -30,6 +30,69 @@ static volatile uint64_t svc_addr;
 static volatile uint64_t ss_addr[4], ss_idx;
 #define  PC(v)  ((uint64_t)&(v))
 
+#define GEN_DEBUG_WRITE_REG(reg_name)			\
+static void write_##reg_name(int num, uint64_t val)	\
+{							\
+	switch (num) {					\
+	case 0:						\
+		write_sysreg(val, reg_name##0_el1);	\
+		break;					\
+	case 1:						\
+		write_sysreg(val, reg_name##1_el1);	\
+		break;					\
+	case 2:						\
+		write_sysreg(val, reg_name##2_el1);	\
+		break;					\
+	case 3:						\
+		write_sysreg(val, reg_name##3_el1);	\
+		break;					\
+	case 4:						\
+		write_sysreg(val, reg_name##4_el1);	\
+		break;					\
+	case 5:						\
+		write_sysreg(val, reg_name##5_el1);	\
+		break;					\
+	case 6:						\
+		write_sysreg(val, reg_name##6_el1);	\
+		break;					\
+	case 7:						\
+		write_sysreg(val, reg_name##7_el1);	\
+		break;					\
+	case 8:						\
+		write_sysreg(val, reg_name##8_el1);	\
+		break;					\
+	case 9:						\
+		write_sysreg(val, reg_name##9_el1);	\
+		break;					\
+	case 10:					\
+		write_sysreg(val, reg_name##10_el1);	\
+		break;					\
+	case 11:					\
+		write_sysreg(val, reg_name##11_el1);	\
+		break;					\
+	case 12:					\
+		write_sysreg(val, reg_name##12_el1);	\
+		break;					\
+	case 13:					\
+		write_sysreg(val, reg_name##13_el1);	\
+		break;					\
+	case 14:					\
+		write_sysreg(val, reg_name##14_el1);	\
+		break;					\
+	case 15:					\
+		write_sysreg(val, reg_name##15_el1);	\
+		break;					\
+	default:					\
+		GUEST_ASSERT(0);			\
+	}						\
+}
+
+/* Define write_dbgbcr()/write_dbgbvr()/write_dbgwcr()/write_dbgwvr() */
+GEN_DEBUG_WRITE_REG(dbgbcr)
+GEN_DEBUG_WRITE_REG(dbgbvr)
+GEN_DEBUG_WRITE_REG(dbgwcr)
+GEN_DEBUG_WRITE_REG(dbgwvr)
+
 static void reset_debug_state(void)
 {
 	asm volatile("msr daifset, #8");
@@ -61,8 +124,9 @@ static void install_wp(uint64_t addr)
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_sysreg(wcr, dbgwcr0_el1);
-	write_sysreg(addr, dbgwvr0_el1);
+	write_dbgwcr(0, wcr);
+	write_dbgwvr(0, addr);
+
 	isb();
 
 	asm volatile("msr daifclr, #8");
@@ -78,8 +142,8 @@ static void install_hw_bp(uint64_t addr)
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_sysreg(bcr, dbgbcr0_el1);
-	write_sysreg(addr, dbgbvr0_el1);
+	write_dbgbcr(0, bcr);
+	write_dbgbvr(0, addr);
 	isb();
 
 	asm volatile("msr daifclr, #8");
-- 
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
