Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789BBC2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 09:51:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CCF7820874
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 09:51:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1pZvU7Aa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCF7820874
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64E2F4B628;
	Mon, 26 Oct 2020 05:51:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0uZS9PNd9gHo; Mon, 26 Oct 2020 05:51:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86D3D4B63D;
	Mon, 26 Oct 2020 05:51:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8F994B490
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 05:51:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vigcW90QyDP5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 05:51:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5006A4B49B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 05:51:34 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 371D2223EA;
 Mon, 26 Oct 2020 09:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603705893;
 bh=ZaUD2F7SZRHILLCA2CT1oSveAZ8OhGgoocNvSoRV2wo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=1pZvU7Aa6agPVnioglcUm4qkb2jtf2T35dlvC+jDvwBJSQpc2x4qwkAfNv6Xvb42J
 oM3MJWdU3mY29SWhBrkhDvy3j1wuEFdsExwq7kVnIS6ispkPKtZW0/oQcwqioSPeF6
 pAH7Sk4vXF6HQ2FCey/atuPDXdMLfxlHE8Q3fx9U=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kWzA3-004HZn-EX; Mon, 26 Oct 2020 09:51:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 4/8] KVM: arm64: Add kimg_hyp_va() helper
Date: Mon, 26 Oct 2020 09:51:12 +0000
Message-Id: <20201026095116.72051-5-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026095116.72051-1-maz@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

KVM/arm64 is so far unable to deal with function pointers, as the compiler
will generate the kernel's runtime VA, and not the linear mapping address,
meaning that kern_hyp_va() will give the wrong result.

We so far have been able to use PC-relative addressing, but that's not
always easy to use, and prevents the implementation of things like
the mapping of an index to a pointer.

To allow this, provide a new helper that computes the required
translation from the kernel image to the HYP VA space.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 16 ++++++++++
 arch/arm64/kvm/va_layout.c       | 50 ++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 331394306cce..e0d50e614bd9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -98,6 +98,22 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 
 #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
 
+static __always_inline unsigned long __kimg_hyp_va(unsigned long v)
+{
+	unsigned long offset;
+
+	asm volatile(ALTERNATIVE_CB("movz %0, #0\n"
+				    "movk %0, #0, lsl #16\n"
+				    "movk %0, #0, lsl #32\n"
+				    "movk %0, #0, lsl #48\n",
+				    kvm_update_kimg_phys_offset)
+		     : "=r" (offset));
+
+	return __kern_hyp_va((v - offset) | PAGE_OFFSET);
+}
+
+#define kimg_hyp_va(v) 	((typeof(v))(__kimg_hyp_va((unsigned long)(v))))
+
 /*
  * We currently support using a VM-specified IPA size. For backward
  * compatibility, the default IPA size is fixed to 40bits.
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index e0404bcab019..1d00d2cb93fd 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -11,6 +11,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
 #include <asm/kvm_mmu.h>
+#include <asm/memory.h>
 
 /*
  * The LSB of the HYP VA tag
@@ -201,3 +202,52 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 					   AARCH64_INSN_BRANCH_NOLINK);
 	*updptr++ = cpu_to_le32(insn);
 }
+
+static void generate_mov_q(u64 val, __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	u32 insn, oinsn, rd;
+
+	BUG_ON(nr_inst != 4);
+
+	/* Compute target register */
+	oinsn = le32_to_cpu(*origptr);
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
+
+	/* movz rd, #(val & 0xffff) */
+	insn = aarch64_insn_gen_movewide(rd,
+					 (u16)val,
+					 0,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_ZERO);
+	*updptr++ = cpu_to_le32(insn);
+
+	/* movk rd, #((val >> 16) & 0xffff), lsl #16 */
+	insn = aarch64_insn_gen_movewide(rd,
+					 (u16)(val >> 16),
+					 16,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_KEEP);
+	*updptr++ = cpu_to_le32(insn);
+
+	/* movk rd, #((val >> 32) & 0xffff), lsl #32 */
+	insn = aarch64_insn_gen_movewide(rd,
+					 (u16)(val >> 32),
+					 32,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_KEEP);
+	*updptr++ = cpu_to_le32(insn);
+
+	/* movk rd, #((val >> 48) & 0xffff), lsl #48 */
+	insn = aarch64_insn_gen_movewide(rd,
+					 (u16)(val >> 48),
+					 48,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_KEEP);
+	*updptr++ = cpu_to_le32(insn);
+}
+
+void kvm_update_kimg_phys_offset(struct alt_instr *alt,
+				 __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	generate_mov_q(kimage_voffset + PHYS_OFFSET, origptr, updptr, nr_inst);
+}
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
