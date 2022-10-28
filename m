Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC5DFA3746
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 10:54:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B40B43C8C;
	Fri, 28 Oct 2022 06:54:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8nzALP91h9jv; Fri, 28 Oct 2022 06:54:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D0E4B0B9;
	Fri, 28 Oct 2022 06:54:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FB9440BD9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 06:54:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZhsoAmGM3eF8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 06:54:16 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 032A340336
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 06:54:15 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C0BD8B82953;
 Fri, 28 Oct 2022 10:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7140BC433D6;
 Fri, 28 Oct 2022 10:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666954453;
 bh=LDpHOoUTLZOBS0Pn/x1kE1SGXF+8M+SGG+sMaN5hl2Y=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=d4EWI+TQq5fmgULaW+sIXpNP+PF4oQ4f/wMoSPvZOhsck9f8lgPDq/mzxGfU4RByN
 MIBzH3C8hwubTEoWYPkNt0tr3EsvCIlppVrP2T3GCz4z1I/UN/B8svKqZXXfJDt8VT
 jHR9AhSSIRrm1XwzoCR9f+oezqa05LO4GdrZ+FgPYtRsLZ3hDxmGZQG8+zonoWlkKB
 1ZU9MPxsKW8cQ5tvhRw8wIPJ70UxoNku/YTlt/9PMMv7a59g15I/ZwYBYQEE59Mjd0
 veM9z8PZD+MXZ8oZsMs/1GFoGMaIUzAVh7BB06rXCiC1p2Vu08A5OB/LlWz4tcQEze
 muZ+bG/ZkRMYQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ooN07-002E4C-E3;
 Fri, 28 Oct 2022 11:54:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v2 01/14] arm64: Add ID_DFR0_EL1.PerfMon values for PMUv3p7
 and IMP_DEF
Date: Fri, 28 Oct 2022 11:53:49 +0100
Message-Id: <20221028105402.2030192-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028105402.2030192-1-maz@kernel.org>
References: <20221028105402.2030192-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

Align the ID_DFR0_EL1.PerfMon values with ID_AA64DFR0_EL1.PMUver.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7d301700d1a9..84f59ce1dc6d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -698,6 +698,8 @@
 #define ID_DFR0_PERFMON_8_1		0x4
 #define ID_DFR0_PERFMON_8_4		0x5
 #define ID_DFR0_PERFMON_8_5		0x6
+#define ID_DFR0_PERFMON_8_7		0x7
+#define ID_DFR0_PERFMON_IMP_DEF		0xf
 
 #define ID_ISAR4_SWP_FRAC_SHIFT		28
 #define ID_ISAR4_PSR_M_SHIFT		24
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
