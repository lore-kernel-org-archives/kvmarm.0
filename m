Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C76613AFB
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 09:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TO/VZ6K6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FF9C433C7;
	Mon, 23 Oct 2023 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698054893;
	bh=zT2QPgw7vw5++jMkx6AuGaWC+WBl9BSFBzJHzx8LmAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TO/VZ6K6zoduZx6SVrM17xo/zqe7WCPAokDucHOaIuV/hKbZRQQV9Ez5YPybp6dm2
	 ps0WrCBA8FI7VfD+btLYdOhOcKh9xJSDq285lnhJOBqRSU7+X6BxGamQLFSSH877R6
	 njNLv1iApBBToURQ8bzKKCzzErCwf/hUmHOg+HJpRzpKdqcQDuwmzRf4FyF6cq1WMg
	 TP6R2N9OY+swUxmVq9MPDhSWuAolB3wN6Nr4P5LgRQK2uawE9yvCtr/MfGBIfiZ0sb
	 orOz/xLVHUWur1O0HqToQOrgwO+FPlBJtYdX+RM6M5yP50DhjNEcsdabgaJ7dYP7e8
	 rKnn5IbJO84SQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qure7-006nPT-00;
	Mon, 23 Oct 2023 10:54:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@redhat.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/5] arm64: Add missing _EL12 encodings
Date: Mon, 23 Oct 2023 10:54:40 +0100
Message-Id: <20231023095444.1587322-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231023095444.1587322-1-maz@kernel.org>
References: <20231023095444.1587322-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com, miguel.luis@oracle.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Miguel Luis <miguel.luis@oracle.com>

Some _EL12 encodings are missing. Add them.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Miguel Luis <miguel.luis@oracle.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20231016111743.30331-2-miguel.luis@oracle.com
---
 arch/arm64/include/asm/sysreg.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 38296579a4fd..ba5db50effec 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -567,19 +567,30 @@
 #define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
 
 /* VHE encodings for architectural EL0/1 system registers */
+#define SYS_BRBCR_EL12			sys_reg(2, 5, 9, 0, 0)
 #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
+#define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
+#define SYS_SCTLR2_EL12			sys_reg(3, 5, 1, 0, 3)
+#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
+#define SYS_TRFCR_EL12			sys_reg(3, 5, 1, 2, 1)
+#define SYS_SMCR_EL12			sys_reg(3, 5, 1, 2, 6)
 #define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
 #define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
 #define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
+#define SYS_TCR2_EL12			sys_reg(3, 5, 2, 0, 3)
 #define SYS_SPSR_EL12			sys_reg(3, 5, 4, 0, 0)
 #define SYS_ELR_EL12			sys_reg(3, 5, 4, 0, 1)
 #define SYS_AFSR0_EL12			sys_reg(3, 5, 5, 1, 0)
 #define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
 #define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
 #define SYS_TFSR_EL12			sys_reg(3, 5, 5, 6, 0)
+#define SYS_FAR_EL12			sys_reg(3, 5, 6, 0, 0)
+#define SYS_PMSCR_EL12			sys_reg(3, 5, 9, 9, 0)
 #define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
 #define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
 #define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
+#define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
+#define SYS_SCXTNUM_EL12		sys_reg(3, 5, 13, 0, 7)
 #define SYS_CNTKCTL_EL12		sys_reg(3, 5, 14, 1, 0)
 #define SYS_CNTP_TVAL_EL02		sys_reg(3, 5, 14, 2, 0)
 #define SYS_CNTP_CTL_EL02		sys_reg(3, 5, 14, 2, 1)
-- 
2.39.2

