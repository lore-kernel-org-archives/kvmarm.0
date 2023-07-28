Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D0D10975
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 08:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774B2C433CA;
	Fri, 28 Jul 2023 08:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690533002;
	bh=b/KYwTc6rsqn/2WuBZNiDqtFcBzTCAQq9Q27juNg2YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhbEji4p+NNhLxj2VYOpdWYv7FXZCr1DTtDTd9WecU8hQvz/JDdlqk+fI+kFmKLn+
	 b87MRuspX3jQJ+c4/A+kXnzOxHx1D8ez/VkMgh9ccf0tjOh804U5OfRYGRyN9qgVO4
	 bxR+LrWvnSTosQ3N2QJcncTcnIxngjR7dJrNYqthW4vVHY3cFfr2Awg2cYyFhYUqha
	 wih2D1LBTSVUmGY7BlmbqVi+wHBdod2k4HDKeYyPbxWvPIuagiNALTeOai55LjTT5n
	 T1lmnbO1LutS3rAf/ir86Zg86KF6EMlQ32mOxnU+KWK7JY5IZt4QFfoqa1RN2NqGPv
	 LvmxIOT94eeYw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qPIrI-0000EO-Ib;
	Fri, 28 Jul 2023 09:30:00 +0100
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
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 07/26] arm64: Add missing BRB/CFP/DVP/CPP instructions
Date: Fri, 28 Jul 2023 09:29:33 +0100
Message-Id: <20230728082952.959212-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230728082952.959212-1-maz@kernel.org>
References: <20230728082952.959212-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

HFGITR_EL2 traps a bunch of instructions for which we don't have
encodings yet. Add them.

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9dfd127be55a..e2357529c633 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -737,6 +737,13 @@
 #define OP_TLBI_VALE2NXS		sys_insn(1, 4, 9, 7, 5)
 #define OP_TLBI_VMALLS12E1NXS		sys_insn(1, 4, 9, 7, 6)
 
+/* Misc instructions */
+#define OP_BRB_IALL			sys_insn(1, 1, 7, 2, 4)
+#define OP_BRB_INJ			sys_insn(1, 1, 7, 2, 5)
+#define OP_CFP_RCTX			sys_insn(1, 3, 7, 3, 4)
+#define OP_DVP_RCTX			sys_insn(1, 3, 7, 3, 5)
+#define OP_CPP_RCTX			sys_insn(1, 3, 7, 3, 7)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_ENTP2	(BIT(60))
 #define SCTLR_ELx_DSSBS	(BIT(44))
-- 
2.34.1

