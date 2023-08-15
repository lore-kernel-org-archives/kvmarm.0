Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4860D14AA1
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 18:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE77C433C9;
	Tue, 15 Aug 2023 18:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692124759;
	bh=xEMT+XBnxJYtZ0bSy2k/P7m4fOPYVCKCMLejZksgoMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMHBSDe77VTM5Y5TW/e98re10KdJPuiFj0VoOj4aDDudOQ5lH/fHbuWcp5oBXiRBW
	 DXuywKLszK/ELOkrCr1njG4ytaFXouePMefyex17chM5PEPxL4B1DsmHr9MBGf3QcO
	 K6jqocA7Ruf7PVLQWZs0E4vCwjOvqcorHm6YLBuS/uh6PDOVsqXCRE3No2IDlGKjEK
	 UAZU3y09ns9XF8ivtWxC78l6I9qDk9Tn6a/C3Bq3tipEdjry340hiEzhFksBy3O4N2
	 ZdsE4iWs/lg4PkkHOE6fD/7VKdrzRWGWxgHOxw5dMghnk0tbLjNXnOfc7/JDjV/Csr
	 fQCgOJx9rxRBw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qVywn-0055Sd-37;
	Tue, 15 Aug 2023 19:39:17 +0100
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
Subject: [PATCH v4 07/28] arm64: Add missing BRB/CFP/DVP/CPP instructions
Date: Tue, 15 Aug 2023 19:38:41 +0100
Message-Id: <20230815183903.2735724-8-maz@kernel.org>
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

HFGITR_EL2 traps a bunch of instructions for which we don't have
encodings yet. Add them.

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index bb5a0877a210..6d9d7ac4b31c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -735,6 +735,13 @@
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

