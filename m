Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06B2C28D13
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 05:10:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73ED34E2CC;
	Thu, 25 Aug 2022 01:10:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rZ+oAk0N13zG; Thu, 25 Aug 2022 01:10:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ACE44E2CD;
	Thu, 25 Aug 2022 01:10:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 718A94E2C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vhVE7LHVTFCN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 01:10:12 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D3FF4E2C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:12 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-335420c7bfeso326528447b3.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 22:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=mbWwPoUmijWxZF1qqEuvmzXuoM73rXdJ5r3D+vU7B94=;
 b=r8VhFLOaJT2TiUfv5+8axKHdrA7rd9E3CpESCV4oQAWgvQswx5RdABZz3ahHrg7fzv
 ttpqQCCUQxkXo+K4PSCAiJwLlIaaNI9WnmqxpF8e1QHDG8fgfywLytaA1eDi6Kafx/8u
 +cqUU1Yg8lR/QkMl2G0o6DiG4wglSuwNEh07eEhQMwELJ4u8LQ4Ym/Szse8yiZp2eWL9
 18+wMWphGzs99MzWHLecuNFbW868I3BVRiBJ23r8/6RJxC2HLGBRSeD7dMi6+d08vtuW
 tLAg3yvOYQsfnzGwFL1sfHzqISWlVUCuJhgEfXtUq1zr2KOI9BDEInIwHt+eIFjCjBPO
 loTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=mbWwPoUmijWxZF1qqEuvmzXuoM73rXdJ5r3D+vU7B94=;
 b=lh1hpQtnjrZIxdZ3MS01nFVNxZ/EzZ10LhvxLulF2bllhlM0cCygrqkMCxvo1YsO6D
 +x1rjQQPNPmiBL3ph5tmiI1cY81eTJq7RT6VN8BV3Id5dwPkXyCc2yUPZkfIMDkY6qZx
 Qtwku8vVqn+zpIAcpkyc8zqjAX0SXUJz12lU0yOqOciOPaDzadRzUSglVMk8JA2TEQMZ
 +v++oSWpuXkEPRHcoCREJA1hZStqMrGCeoMe720VsPCiRPdN43SxRR1HwhB+ikJQvEp1
 eHJQmij9cX/ZcVx+sKOo+uZaSQ2VCWigNcVMdw9mPhaQgVw06AtSpWxIl/xOJZJ+E5nG
 FNjg==
X-Gm-Message-State: ACgBeo0ElXe+OX6Z6p472bkaHbGTt/nRerHEkY9tbyVB7f2sdfiXSvj2
 Ml0Mpu/5dGbOOigCl1ak92aA1RDoleI=
X-Google-Smtp-Source: AA6agR6Y3Gi8FMQjP63JX1oEF6pk6Y3m+wYPfkv8vdoUapXy4ra3FJcrC1HheWBCS6yZioM75J0QQ0KL4KQ=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:2f4a:0:b0:695:8b9a:1788 with SMTP id
 v71-20020a252f4a000000b006958b9a1788mr1971181ybv.126.1661404211856; Wed, 24
 Aug 2022 22:10:11 -0700 (PDT)
Date: Wed, 24 Aug 2022 22:08:39 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-3-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 2/9] KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers
 in debug-exceptions
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

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 72 +++++++++++++++++--
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2ee35cf9801e..51047e6b8db3 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -28,6 +28,69 @@ static volatile uint64_t svc_addr;
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
@@ -59,8 +122,9 @@ static void install_wp(uint64_t addr)
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_sysreg(wcr, dbgwcr0_el1);
-	write_sysreg(addr, dbgwvr0_el1);
+	write_dbgwcr(0, wcr);
+	write_dbgwvr(0, addr);
+
 	isb();
 
 	asm volatile("msr daifclr, #8");
@@ -76,8 +140,8 @@ static void install_hw_bp(uint64_t addr)
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_sysreg(bcr, dbgbcr0_el1);
-	write_sysreg(addr, dbgbvr0_el1);
+	write_dbgbcr(0, bcr);
+	write_dbgbvr(0, addr);
 	isb();
 
 	asm volatile("msr daifclr, #8");
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
