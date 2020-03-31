Return-Path: <SRS0=dOSa=5Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E54C2D0EE
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 12:17:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2DF820838
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 12:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQJbrnsR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2DF820838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B1804B093;
	Tue, 31 Mar 2020 08:17:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O8WI8DygXiRP; Tue, 31 Mar 2020 08:17:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE9E4B0CD;
	Tue, 31 Mar 2020 08:17:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FA474B0BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 08:17:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GfGMVE9UvbIx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2020 08:17:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3297D4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 08:17:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6140120714;
 Tue, 31 Mar 2020 12:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585657037;
 bh=uFQ//zmRylro3EhbpN2ECpSH3uEqWDKkifUv85qs7S4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=iQJbrnsR1chnjthV1ZKBdOCr7YCVeF4m666WUD1FJozkgYzupxMMDYQBGO2lqs9sA
 ViH//EZb51dn/j/DTLU8hjsQ3mO9ImZx7gdlDiUSRhn5fwxJD9APRbECogfuTfdaVn
 yiIi+F80vyHYDPlQO++Ov1SSpk12uQWJW0OvAWiU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jJFpT-00HBlI-FB; Tue, 31 Mar 2020 13:17:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 07/15] arm: Remove the ability to set HYP vectors outside of
 the decompressor
Date: Tue, 31 Mar 2020 13:16:37 +0100
Message-Id: <20200331121645.388250-8-maz@kernel.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200331121645.388250-1-maz@kernel.org>
References: <20200331121645.388250-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, arnd@arndb.de, catalin.marinas@arm.com,
 christoffer.dall@arm.com, eric.auger@redhat.com, karahmed@amazon.de,
 linus.walleij@linaro.org, olof@lixom.net, vladimir.murzin@arm.com,
 will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
 KarimAllah Ahmed <karahmed@amazon.de>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, linux-arm-kernel@lists.infradead.org,
 Olof Johansson <olof@lixom.net>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Although we have to bounce between HYP and SVC to decompress and
relocate the kernel, we don't need to be able to use it in the
kernel itself. So let's drop the functionnality.

Since the vectors are never changed, there is no need to reset them
either, and nobody calls that stub anyway. The last function
(SOFT_RESTART) is still present in order to support kexec.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/virt.h |  5 -----
 arch/arm/kernel/hyp-stub.S  | 39 ++++++++-----------------------------
 2 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index 47600a5894b1..dd9697b2bde8 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -39,8 +39,6 @@ static inline void sync_boot_mode(void)
 	sync_cache_r(&__boot_cpu_mode);
 }
 
-void __hyp_set_vectors(unsigned long phys_vector_base);
-void __hyp_reset_vectors(void);
 #else
 #define __boot_cpu_mode	(SVC_MODE)
 #define sync_boot_mode()
@@ -75,9 +73,6 @@ static inline bool is_kernel_in_hyp_mode(void)
 
 #define HVC_SET_VECTORS 0
 #define HVC_SOFT_RESTART 1
-#define HVC_RESET_VECTORS 2
-
-#define HVC_STUB_HCALL_NR 3
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 6607fa817bba..26d8e03b1dd3 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -189,19 +189,19 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
 ENDPROC(__hyp_stub_install_secondary)
 
 __hyp_stub_do_trap:
+#ifdef ZIMAGE
 	teq	r0, #HVC_SET_VECTORS
 	bne	1f
+	/* Only the ZIMAGE stubs can change the HYP vectors */
 	mcr	p15, 4, r1, c12, c0, 0	@ set HVBAR
 	b	__hyp_stub_exit
+#endif
 
 1:	teq	r0, #HVC_SOFT_RESTART
-	bne	1f
+	bne	2f
 	bx	r1
 
-1:	teq	r0, #HVC_RESET_VECTORS
-	beq	__hyp_stub_exit
-
-	ldr	r0, =HVC_STUB_ERR
+2:	ldr	r0, =HVC_STUB_ERR
 	__ERET
 
 __hyp_stub_exit:
@@ -210,26 +210,9 @@ __hyp_stub_exit:
 ENDPROC(__hyp_stub_do_trap)
 
 /*
- * __hyp_set_vectors: Call this after boot to set the initial hypervisor
- * vectors as part of hypervisor installation.  On an SMP system, this should
- * be called on each CPU.
- *
- * r0 must be the physical address of the new vector table (which must lie in
- * the bottom 4GB of physical address space.
- *
- * r0 must be 32-byte aligned.
- *
- * Before calling this, you must check that the stub hypervisor is installed
- * everywhere, by waiting for any secondary CPUs to be brought up and then
- * checking that BOOT_CPU_MODE_HAVE_HYP(__boot_cpu_mode) is true.
- *
- * If not, there is a pre-existing hypervisor, some CPUs failed to boot, or
- * something else went wrong... in such cases, trying to install a new
- * hypervisor is unlikely to work as desired.
- *
- * When you call into your shiny new hypervisor, sp_hyp will contain junk,
- * so you will need to set that to something sensible at the new hypervisor's
- * initialisation entry point.
+ * __hyp_set_vectors is only used when ZIMAGE must bounce between HYP
+ * and SVC. For the kernel itself, the vectors are set once and for
+ * all by the stubs.
  */
 ENTRY(__hyp_set_vectors)
 	mov	r1, r0
@@ -245,12 +228,6 @@ ENTRY(__hyp_soft_restart)
 	ret	lr
 ENDPROC(__hyp_soft_restart)
 
-ENTRY(__hyp_reset_vectors)
-	mov	r0, #HVC_RESET_VECTORS
-	__HVC(0)
-	ret	lr
-ENDPROC(__hyp_reset_vectors)
-
 #ifndef ZIMAGE
 .align 2
 .L__boot_cpu_mode_offset:
-- 
2.25.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
