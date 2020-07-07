Return-Path: <SRS0=EuCB=AS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977A3C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 15:12:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F63220663
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 15:12:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="frYEk8ia"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F63220663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C42544B112;
	Tue,  7 Jul 2020 11:12:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vh8ZCfDWzvbM; Tue,  7 Jul 2020 11:12:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 332044B101;
	Tue,  7 Jul 2020 11:12:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE774B101
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 11:12:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R2D-sA4XjmW0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2020 11:12:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33ADE4B0FF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 11:12:01 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1BAF52065D;
 Tue,  7 Jul 2020 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594134720;
 bh=C4bPJbq0e1P34S5uLx3jO+V10U+5mus3QC4vneFLX1Y=;
 h=From:To:Cc:Subject:Date:From;
 b=frYEk8iaPRhfVRhVtZ5aQCYq7V2EWVUpPQ1xar9FIMJtduC6Os5mcGHmWesD2xu0j
 bxNCIk4f9NvMsPil6ThxO/O7OddeaOOHn2PYV3T/QTBDeqhhHAgqRuAxsXYk1t++rw
 GVsJbkqA7f3SQDK8ZCTW/skBpHyrtMSbJrTVCyXQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jspGI-009mGD-I7; Tue, 07 Jul 2020 16:11:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH] KVM: arm64: Don't use has_vhe() for CHOOSE_HYP_SYM()
Date: Tue,  7 Jul 2020 16:11:12 +0100
Message-Id: <20200707151112.2514630-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

The recently introduced CHOOSE_HYP_SYM() macro picks one symbol
or another, depending on whether the kernel run as a VHE
hypervisor or not. For that, it uses the has_vhe() helper, which
is itself implemented as a final capability.

Unfortunately, __copy_hyp_vect_bpi now indirectly uses CHOOSE_HYP_SYM
to get the __bp_harden_hyp_vecs symbol, using has_vhe() in the process.
At this stage, the capability isn't final and things explode:

[    0.000000] ACPI: SRAT not present
[    0.000000] percpu: Embedded 34 pages/cpu s101264 r8192 d29808 u139264
[    0.000000] Detected PIPT I-cache on CPU0
[    0.000000] ------------[ cut here ]------------
[    0.000000] kernel BUG at arch/arm64/include/asm/cpufeature.h:459!
[    0.000000] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.8.0-rc4-00080-gd630681366e5 #1388
[    0.000000] pstate: 80000085 (Nzcv daIf -PAN -UAO BTYPE=--)
[    0.000000] pc : check_branch_predictor+0x3a4/0x408
[    0.000000] lr : check_branch_predictor+0x2a4/0x408
[    0.000000] sp : ffff800011693e90
[    0.000000] x29: ffff800011693e90 x28: ffff8000116a1530
[    0.000000] x27: ffff8000112c1008 x26: ffff800010ca6ff8
[    0.000000] x25: ffff8000112c1000 x24: ffff8000116a1320
[    0.000000] x23: 0000000000000000 x22: ffff8000112c1000
[    0.000000] x21: ffff800010177120 x20: ffff8000116ae108
[    0.000000] x19: 0000000000000000 x18: ffff800011965c90
[    0.000000] x17: 0000000000022000 x16: 0000000000000003
[    0.000000] x15: 00000000ffffffff x14: ffff8000118c3a38
[    0.000000] x13: 0000000000000021 x12: 0000000000000022
[    0.000000] x11: d37a6f4de9bd37a7 x10: 000000000000001d
[    0.000000] x9 : 0000000000000000 x8 : ffff800011f8dad8
[    0.000000] x7 : ffff800011965ad0 x6 : 0000000000000003
[    0.000000] x5 : 0000000000000000 x4 : 0000000000000000
[    0.000000] x3 : 0000000000000100 x2 : 0000000000000004
[    0.000000] x1 : ffff8000116ae148 x0 : 0000000000000000
[    0.000000] Call trace:
[    0.000000]  check_branch_predictor+0x3a4/0x408
[    0.000000]  update_cpu_capabilities+0x84/0x138
[    0.000000]  init_cpu_features+0x2c0/0x2d8
[    0.000000]  cpuinfo_store_boot_cpu+0x54/0x64
[    0.000000]  smp_prepare_boot_cpu+0x2c/0x60
[    0.000000]  start_kernel+0x16c/0x574
[    0.000000] Code: 17ffffc7 91010281 14000198 17ffffca (d4210000)

This is addressed using a two-fold process:
- Replace has_vhe() with is_kernel_in_hyp_mode(), which tests
  whether we are running at EL2.
- Make CHOOSE_HYP_SYM() return an *undefined* symbol when
  compiled in the nVHE hypervisor, as we really should never
  use this helper in the nVHE-specific code.

With this in place, we're back to a bootable kernel again.

Fixes: b877e9849d41 ("KVM: arm64: Build hyp-entry.S separately for VHE/nVHE")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 5716f5de9707..fb1a922b31ba 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -62,8 +62,26 @@
 
 #define CHOOSE_VHE_SYM(sym)	sym
 #define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
-#define CHOOSE_HYP_SYM(sym)	(has_vhe() ? CHOOSE_VHE_SYM(sym) \
+
+#ifndef __KVM_NVHE_HYPERVISOR__
+/*
+ * BIG FAT WARNINGS:
+ *
+ * - Don't be tempted to change the following is_kernel_in_hyp_mode()
+ *   to has_vhe(). has_vhe() is implemented as a *final* capability,
+ *   while this is used early at boot time, when the capabilities are
+ *   not final yet....
+ *
+ * - Don't let the nVHE hypervisor have access to this, as it will
+ *   pick the *wrong* symbol (yes, it runs at EL2...).
+ */
+#define CHOOSE_HYP_SYM(sym)	(is_kernel_in_hyp_mode() ? CHOOSE_VHE_SYM(sym) \
 					   : CHOOSE_NVHE_SYM(sym))
+#else
+/* The nVHE hypervisor shouldn't even try to access anything */
+extern void *__nvhe_undefined_symbol;
+#define CHOOSE_HYP_SYM(sym)	__nvhe_undefined_symbol
+#endif
 
 /* Translate a kernel address @ptr into its equivalent linear mapping */
 #define kvm_ksym_ref(ptr)						\
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
