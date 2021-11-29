Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C4EC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:06:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89AB94B0AC;
	Mon, 29 Nov 2021 15:06:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wIWKSHeV3X0L; Mon, 29 Nov 2021 15:06:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9526E4B177;
	Mon, 29 Nov 2021 15:06:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF53C4B149
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:06:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fh16KDwcAh4G for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:06:35 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CCB04B15A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:06:34 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 1A8D5B815E6;
 Mon, 29 Nov 2021 20:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE28BC53FCD;
 Mon, 29 Nov 2021 20:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216391;
 bh=HOZdzEjZoeKGETrJPFOERpPygAZITG+WMe69qICsnxY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Ava+keXKw6IIMzpQUO+tL1qONJ2H21WVoLC4+orWHICkvY+0kswSXgLyDPzkNeN6t
 yTeJqq3pCyICyTur1hzTP/Bk8TmcCC0wUuUKW6DahMdPzgQaFWifPDt0a4ft/+k5VO
 k77rKHZBJH8NPMVtp0paNX3W73Su5YoO4SMnQTPOJ3N1KEsJ9GYZXWBvuM3zZtFN4X
 65fnN+EoXxVPgXyKzMqrgce87NqIw7r1B8hEI9dwb9zA5Tu+8EnR75ztwJmdnTziAp
 VINw0fzo/NkineRWz9ZprgZmgCUdVj84Tcbd5g+TDEa6/soWD8csP1n+UMc56wQQ3f
 530ctogYlo39A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmqy-008gvR-I8; Mon, 29 Nov 2021 20:02:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 35/69] KVM: arm64: nv: Only toggle cache for virtual EL2
 when SCTLR_EL2 changes
Date: Mon, 29 Nov 2021 20:01:16 +0000
Message-Id: <20211129200150.351436-36-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

From: Christoffer Dall <christoffer.dall@linaro.org>

So far we were flushing almost the entire universe whenever a VM would
load/unload the SCTLR_EL1 and the two versions of that register had
different MMU enabled settings.  This turned out to be so slow that it
prevented forward progress for a nested VM, because a scheduler timer
tick interrupt would always be pending when we reached the nested VM.

To avoid this problem, we consider the SCTLR_EL2 when evaluating if
caches are on or off when entering virtual EL2 (because this is the
value that we end up shadowing onto the hardware EL1 register).

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 02d378887743..c018c7b40761 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -115,6 +115,7 @@ alternative_cb_end
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
+#include <asm/kvm_emulate.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
@@ -185,7 +186,10 @@ struct kvm;
 
 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
-	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
+	if (vcpu_mode_el2(vcpu))
+		return (__vcpu_sys_reg(vcpu, SCTLR_EL2) & 0b101) == 0b101;
+	else
+		return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
 }
 
 static inline void __clean_dcache_guest_page(void *va, size_t size)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
