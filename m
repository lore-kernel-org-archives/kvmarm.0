Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004F5C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 21:12:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89A5C61057
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 21:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 89A5C61057
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9604B204;
	Thu, 11 Nov 2021 16:12:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 55bvSNK+6Hjb; Thu, 11 Nov 2021 16:12:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 108F14B22C;
	Thu, 11 Nov 2021 16:12:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E088B4B1E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 16:12:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VHrpsVijDFOU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 16:12:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E1E84B18A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 16:12:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6A0B961057;
 Thu, 11 Nov 2021 21:12:17 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mlHMl-004tjr-LI; Thu, 11 Nov 2021 21:12:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/4] KVM: arm64: Extract ESR_ELx.EC only
Date: Thu, 11 Nov 2021 21:11:32 +0000
Message-Id: <20211111211135.3991240-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211111211135.3991240-1-maz@kernel.org>
References: <20211111211135.3991240-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, tabba@google.com, james.morse@arm.com,
 mark.rutland@arm.com, qperret@google.com, rdunlap@infradead.org,
 suzuki.poulose@arm.com, will@kernel.org, yuehaibing@huawei.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, YueHaibing <yuehaibing@huawei.com>,
 stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

From: Mark Rutland <mark.rutland@arm.com>

Since ARMv8.0 the upper 32 bits of ESR_ELx have been RES0, and recently
some of the upper bits gained a meaning and can be non-zero. For
example, when FEAT_LS64 is implemented, ESR_ELx[36:32] contain ISS2,
which for an ST64BV or ST64BV0 can be non-zero. This can be seen in ARM
DDI 0487G.b, page D13-3145, section D13.2.37.

Generally, we must not rely on RES0 bit remaining zero in future, and
when extracting ESR_ELx.EC we must mask out all other bits.

All C code uses the ESR_ELx_EC() macro, which masks out the irrelevant
bits, and therefore no alterations are required to C code to avoid
consuming irrelevant bits.

In a couple of places the KVM assembly extracts ESR_ELx.EC using LSR on
an X register, and so could in theory consume previously RES0 bits. In
both cases this is for comparison with EC values ESR_ELx_EC_HVC32 and
ESR_ELx_EC_HVC64, for which the upper bits of ESR_ELx must currently be
zero, but this could change in future.

This patch adjusts the KVM vectors to use UBFX rather than LSR to
extract ESR_ELx.EC, ensuring these are robust to future additions to
ESR_ELx.

Cc: stable@vger.kernel.org
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211103110545.4613-1-mark.rutland@arm.com
---
 arch/arm64/include/asm/esr.h   | 1 +
 arch/arm64/kvm/hyp/hyp-entry.S | 2 +-
 arch/arm64/kvm/hyp/nvhe/host.S | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 29f97eb3dad4..8f59bbeba7a7 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -68,6 +68,7 @@
 #define ESR_ELx_EC_MAX		(0x3F)
 
 #define ESR_ELx_EC_SHIFT	(26)
+#define ESR_ELx_EC_WIDTH	(6)
 #define ESR_ELx_EC_MASK		(UL(0x3F) << ESR_ELx_EC_SHIFT)
 #define ESR_ELx_EC(esr)		(((esr) & ESR_ELx_EC_MASK) >> ESR_ELx_EC_SHIFT)
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 9aa9b73475c9..b6b6801d96d5 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -44,7 +44,7 @@
 el1_sync:				// Guest trapped into EL2
 
 	mrs	x0, esr_el2
-	lsr	x0, x0, #ESR_ELx_EC_SHIFT
+	ubfx	x0, x0, #ESR_ELx_EC_SHIFT, #ESR_ELx_EC_WIDTH
 	cmp	x0, #ESR_ELx_EC_HVC64
 	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
 	b.ne	el1_trap
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 0c6116d34e18..3d613e721a75 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -141,7 +141,7 @@ SYM_FUNC_END(__host_hvc)
 .L__vect_start\@:
 	stp	x0, x1, [sp, #-16]!
 	mrs	x0, esr_el2
-	lsr	x0, x0, #ESR_ELx_EC_SHIFT
+	ubfx	x0, x0, #ESR_ELx_EC_SHIFT, #ESR_ELx_EC_WIDTH
 	cmp	x0, #ESR_ELx_EC_HVC64
 	b.eq	__host_hvc
 	b	__host_exit
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
