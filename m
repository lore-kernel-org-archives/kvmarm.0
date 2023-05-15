Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19716182B3
	for <kvmarm@lists.linux.dev>; Mon, 15 May 2023 20:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDBAC4339C;
	Mon, 15 May 2023 20:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684183566;
	bh=b1oP4ZBP2/2HbNU0ajHcv5Rt9d4QSrPGjjdrWvA8y/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eB7kY22oq4msn/sUyGFbaMA7KrU16seLrxypWZwat+Vwkp3Ct1aCW1E+f0+0pQzeI
	 Z4++1yDsxRRZ8uv4zzCwf3b/9jMyB4uFGptf9UUjjQtR+9AzQob4g0IalImrh/fv5h
	 Kq5K5hiQSwnf2zvQ4QRlzBil4EWZdDXD7JwGOsIBdsJMgKgLsPgXYSWXsnKG55RhO3
	 tgySsKWz8vFAvAUzWyUIIdPkGMkPpna01FngXETNZB96b6a8l1aEAl93sSl7yJSOkx
	 X4Edg7TVzk6lrpvT+XU7IY3mdSXVJWXKVbkATuHsNEwuBO4IQfXxv15cx+rJWaUgK2
	 PSvgMPWdzE14Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pyf52-00FM0a-JV;
	Mon, 15 May 2023 21:46:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	steven.price@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [PATCH 1/2] arm64: Add missing Set/Way CMO encodings
Date: Mon, 15 May 2023 21:46:00 +0100
Message-Id: <20230515204601.1270428-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515204601.1270428-1-maz@kernel.org>
References: <20230515204601.1270428-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, steven.price@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the missing Set/Way CMOs that apply to tagged memory.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index e72d9aaab6b1..eefd712f2430 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -115,8 +115,14 @@
 #define SB_BARRIER_INSN			__SYS_BARRIER_INSN(0, 7, 31)
 
 #define SYS_DC_ISW			sys_insn(1, 0, 7, 6, 2)
+#define SYS_DC_IGSW			sys_insn(1, 0, 7, 6, 4)
+#define SYS_DC_IGDSW			sys_insn(1, 0, 7, 6, 6)
 #define SYS_DC_CSW			sys_insn(1, 0, 7, 10, 2)
+#define SYS_DC_CGSW			sys_insn(1, 0, 7, 10, 4)
+#define SYS_DC_CGDSW			sys_insn(1, 0, 7, 10, 6)
 #define SYS_DC_CISW			sys_insn(1, 0, 7, 14, 2)
+#define SYS_DC_CIGSW			sys_insn(1, 0, 7, 14, 4)
+#define SYS_DC_CIGDSW			sys_insn(1, 0, 7, 14, 6)
 
 /*
  * Automatically generated definitions for system registers, the
-- 
2.34.1

