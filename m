Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E9BC43219
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:14:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 175E64089E;
	Tue, 12 Apr 2022 09:14:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xWhjuEOr6y3Q; Tue, 12 Apr 2022 09:14:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0EE04B2D0;
	Tue, 12 Apr 2022 09:14:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A37934B25A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mIfgHn1S-aPp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:13:55 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50BE74A369
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 52EE7618E3;
 Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08A8C385AC;
 Tue, 12 Apr 2022 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649769233;
 bh=ZbncnZ32bg/pWl5i1LBdjIUJlWirb6o/1JxeMS9My4s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GSCNpxfr9zV9PtuTNKURArEQ+F7+KJsFo5eDU6+TnLy9RcDYnC/MHb01HduzEBkdV
 78eNCNh0HBaiWsWepEjyJH0VcdPuxXw1PvhqkhJwayNR/jAEwwV/bkxKxJDGKoza4l
 Sd7rl910megsYGrDHMR1SlbLuB+TdnVwPLfimmN7GgA6kEelO1atY4TEaKMR37zwrx
 1RY/bsZui1+ZOEtQSXHdVC112a2HBTh/pSbILDmbkduKq3CiLubHO+bwBXTGSloIjI
 RZsyM9qYFUevOq267XXVv6HfOSutlBMN/rcm7GCEyRneLOPz+4OgvdvXdCgdJbpYYi
 mDkrRI8oX0Ttg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1neGL9-003mvX-Jl; Tue, 12 Apr 2022 14:13:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 02/10] arm64: Add RV and RN fields for ESR_ELx_WFx_ISS
Date: Tue, 12 Apr 2022 14:12:55 +0100
Message-Id: <20220412131303.504690-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412131303.504690-1-maz@kernel.org>
References: <20220412131303.504690-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

The ISS field exposed by ESR_ELx contain two additional subfields
with FEAT_WFxT:

- RN, the register number containing the timeout
- RV, indicating if the register number is valid

Describe these two fields according to the arch spec.

No functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 65c2201b11b2..15156c478054 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -133,6 +133,8 @@
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
+#define ESR_ELx_WFx_ISS_RN	(UL(0x1F) << 5)
+#define ESR_ELx_WFx_ISS_RV	(UL(1) << 2)
 #define ESR_ELx_WFx_ISS_TI	(UL(3) << 0)
 #define ESR_ELx_WFx_ISS_WFxT	(UL(2) << 0)
 #define ESR_ELx_WFx_ISS_WFI	(UL(0) << 0)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
