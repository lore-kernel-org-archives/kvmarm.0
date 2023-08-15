Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1742218026
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 18:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AB1C433CC;
	Tue, 15 Aug 2023 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692124757;
	bh=f8G4gBvZrescwweQMKJS3/9ifLPSvT1DsxeWiW/U9N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPW7ic+zxr0dXXvCbummaTf/f7PVt64bzpJc3qno0RJxfUuGQdrCIlPz295t6LA32
	 C0GlC1zNpIzNCuzshCAopMkcbx0066Lvy7UtOH5mbJs/9omv08t6YmQehlCzrVaQJo
	 ToqTSP1rf74/XpP60Djzjo2PnwSLU8LxYgFguXWynJp15rNockh03aSrGObHCBuLXd
	 neLM29G2pVuwhub0l1Uy938SPZfGolCVJtBA+mIsx3+5T5r3x2UgaeL0QMIq1Npe8I
	 uqbsS6dcuxjZfi7TmYbAT5xKBTPueyEUpiw9zRCKx0ZwVLliurLgGsABLXk9sHP0pG
	 +Y7WDz6FiCmDQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qVywl-0055Sd-E7;
	Tue, 15 Aug 2023 19:39:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Jing Zhang <jingzhangos@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 01/28] arm64: Add missing VA CMO encodings
Date: Tue, 15 Aug 2023 19:38:35 +0100
Message-Id: <20230815183903.2735724-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230815183903.2735724-1-maz@kernel.org>
References: <20230815183903.2735724-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, jingzhangos@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the missing VA-based CMOs encodings.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b481935e9314..85447e68951a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -124,6 +124,32 @@
 #define SYS_DC_CIGSW			sys_insn(1, 0, 7, 14, 4)
 #define SYS_DC_CIGDSW			sys_insn(1, 0, 7, 14, 6)
 
+#define SYS_IC_IALLUIS			sys_insn(1, 0, 7, 1, 0)
+#define SYS_IC_IALLU			sys_insn(1, 0, 7, 5, 0)
+#define SYS_IC_IVAU			sys_insn(1, 3, 7, 5, 1)
+
+#define SYS_DC_IVAC			sys_insn(1, 0, 7, 6, 1)
+#define SYS_DC_IGVAC			sys_insn(1, 0, 7, 6, 3)
+#define SYS_DC_IGDVAC			sys_insn(1, 0, 7, 6, 5)
+
+#define SYS_DC_CVAC			sys_insn(1, 3, 7, 10, 1)
+#define SYS_DC_CGVAC			sys_insn(1, 3, 7, 10, 3)
+#define SYS_DC_CGDVAC			sys_insn(1, 3, 7, 10, 5)
+
+#define SYS_DC_CVAU			sys_insn(1, 3, 7, 11, 1)
+
+#define SYS_DC_CVAP			sys_insn(1, 3, 7, 12, 1)
+#define SYS_DC_CGVAP			sys_insn(1, 3, 7, 12, 3)
+#define SYS_DC_CGDVAP			sys_insn(1, 3, 7, 12, 5)
+
+#define SYS_DC_CVADP			sys_insn(1, 3, 7, 13, 1)
+#define SYS_DC_CGVADP			sys_insn(1, 3, 7, 13, 3)
+#define SYS_DC_CGDVADP			sys_insn(1, 3, 7, 13, 5)
+
+#define SYS_DC_CIVAC			sys_insn(1, 3, 7, 14, 1)
+#define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
+#define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
+
 /*
  * Automatically generated definitions for system registers, the
  * manual encodings below are in the process of being converted to
-- 
2.34.1

