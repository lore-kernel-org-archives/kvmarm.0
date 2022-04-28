Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EF0C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 14:04:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2EE94B2AD;
	Thu, 28 Apr 2022 10:04:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nPIRjOUl-ckk; Thu, 28 Apr 2022 10:04:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEAAF4B290;
	Thu, 28 Apr 2022 10:04:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAEC04B285
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 10:04:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WIPIooIEMzjU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 10:04:12 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA06649F3E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 10:04:12 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9C9E461000;
 Thu, 28 Apr 2022 14:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71A6C385AA;
 Thu, 28 Apr 2022 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651154651;
 bh=vLx33q87eXGXQ2LRwNhK6vgYZeRec9h1RejRTtSSgD8=;
 h=From:To:Cc:Subject:Date:From;
 b=N72b2lJPxhRlrxKzbNYsbfwbd5W7FKUb/HbySA1PIHa3vHMaV1fbU37oET5qQRLGM
 Sp2FYyYYSpG/PXnAlSU85EaV5Jxy8yj8taY8QkigcbDCtBII1LVlOgxkwEWDD5FItN
 usZK0MKdHHqg0rXCV9ukWYFRTwDsFMqYekyFRQXFB84VOsJzQXSwO8PL19Kms1vIFh
 plKZBJk6nr5tiDG7Xd3m5tmx4GutBzEBJSNr2kqume+cFOAfSSYt8xmNvplQybsKHr
 XAXCSJ2uolgVz7RVfgVf3HVRSM7VbsoMZ7Ez0I13XQZ/vRTiFVdefVQrd9Z729fTBf
 LtLqsfuy0410g==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, dbrazdil@google.com
Subject: [PATCH] arm64: kvm: avoid unnecessary absolute addressing via literals
Date: Thu, 28 Apr 2022 16:03:50 +0200
Message-Id: <20220428140350.3303481-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1625; h=from:subject;
 bh=vLx33q87eXGXQ2LRwNhK6vgYZeRec9h1RejRTtSSgD8=;
 b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiap7FPmVR8RjP3uOW9iGq4+cTaDa9BMjP/SZ7DXRS
 uMvp5CaJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYmqexQAKCRDDTyI5ktmPJFnKC/
 9mwnUocnM4ue8AKxpnruQWg7tCiJEfaqjRfmzpUHdbfKYwH+ouJeI0iezPLzev41SSkQaYKPaRzGaj
 kOrv1H5QjL7fbSgoKy4+UTO4aZb1LGF+hNQP1csXr0iK3Y9X3RM0xRnuWDMfJ3QE8EymD92dwjWNg+
 8V9Xjfl9wwx2VTUv3zKF19ZhjIihl0wkV8p0D6mbzSCYTg/rQN/V18dWhVgFHqaIjyZqnY+p1oG6kv
 6CvP70RFl5tnWV8R1bXC4JWrcUqAHLeRTVegtM7zjPjECKhpAv+YCijafP8etEeoQx00fcCYeYETGP
 xGaOObOdTOj7FE+vvaAe6GltF8Rw4D/oTYd2xMLWDNib8dGzLuzRXpL8Y2m7V78KGp98+r5sVa278n
 p6LAmFrM3//g/qZjPsQwfVlexg1aaQzmyUcWuyzcRY3C1Rf9pFu3p4hJ60iqgfVEF8HvTRsxfpQ8lH
 v+xlIOzEUcgZ4cmfVGvEgZr5i/bSVZFR8ITVcOSjpgaAA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp;
 fpr=F43D03328115A198C90016883D200E9CA6329909
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

There are a few cases in the nVHE code where we take the absolute
address of a symbol via a literal pool entry, and subsequently translate
it to another address space (PA, kimg VA, kernel linear VA, etc).
Originally, this literal was needed because we relied on a different
translation for absolute references, but this is no longer the case, so
we can simply use relative addressing instead. This removes a couple of
RELA entries pointing into the .text segment.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 3d613e721a75..366551594417 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -80,7 +80,7 @@ SYM_FUNC_START(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
 		      PSR_MODE_EL1h)
 	msr	spsr_el2, lr
-	ldr	lr, =nvhe_hyp_panic_handler
+	adr_l	lr, nvhe_hyp_panic_handler
 	hyp_kimg_va lr, x6
 	msr	elr_el2, lr
 
@@ -125,13 +125,11 @@ alternative_else_nop_endif
 	add	sp, sp, #16
 	/*
 	 * Compute the idmap address of __kvm_handle_stub_hvc and
-	 * jump there. Since we use kimage_voffset, do not use the
-	 * HYP VA for __kvm_handle_stub_hvc, but the kernel VA instead
-	 * (by loading it from the constant pool).
+	 * jump there.
 	 *
 	 * Preserve x0-x4, which may contain stub parameters.
 	 */
-	ldr	x5, =__kvm_handle_stub_hvc
+	adr_l	x5, __kvm_handle_stub_hvc
 	hyp_pa	x5, x6
 	br	x5
 SYM_FUNC_END(__host_hvc)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
