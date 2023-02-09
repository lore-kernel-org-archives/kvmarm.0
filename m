Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2E7A927
	for <kvmarm@lists.linux.dev>; Thu,  9 Feb 2023 17:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E51C433A1;
	Thu,  9 Feb 2023 17:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675965529;
	bh=tzWKgTRp6aGDHs1UrJIOpDzstSP+fi5dGowkonXSLHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyx6YoWWp0P2OdB2V1LQXnfp9LUmzYhcQbsgHDRgk1W4zn4ghXJed6QSBqxKw5im/
	 0qkU2V7a+Fh8W7yDQTXf9v4wI1LtxKhYqMxRWFcBs36REC4y44LqUtufmHvS90Q2KD
	 uarQ363gDh6nglzsWnME/AA3xDZR2CXLf92enwcMf+4Mc0iHvDu72K/exNE2q4Ve9c
	 OnZXuxc9gtmw+Of5YxwzUr7xkKNXJA+8ibeqbVmLK6RjuYumeYAx4AFYPKnc2F5ZWL
	 U7Gi4/9spe9hOmArTsJ1ZjxrCQcbWkQ2MnUtScySYcABKpXXyCu6akOErsNImpyAYQ
	 xOnkxC7b8OrWA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pQBC3-0093r7-6j;
	Thu, 09 Feb 2023 17:58:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 06/18] KVM: arm64: nv: Add EL2 system registers to vcpu context
Date: Thu,  9 Feb 2023 17:58:08 +0000
Message-Id: <20230209175820.1939006-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the minimal set of EL2 system registers to the vcpu context.
Nothing uses them just yet.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 33 ++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8919e971abdf..f53473071bcb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -325,12 +325,43 @@ enum vcpu_sysreg {
 	TFSR_EL1,	/* Tag Fault Status Register (EL1) */
 	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
 
-	/* 32bit specific registers. Keep them at the end of the range */
+	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
 	FPEXC32_EL2,	/* Floating-Point Exception Control Register */
 	DBGVCR32_EL2,	/* Debug Vector Catch Register */
 
+	/* EL2 registers */
+	VPIDR_EL2,	/* Virtualization Processor ID Register */
+	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
+	SCTLR_EL2,	/* System Control Register (EL2) */
+	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
+	HCR_EL2,	/* Hypervisor Configuration Register */
+	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
+	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
+	HSTR_EL2,	/* Hypervisor System Trap Register */
+	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
+	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
+	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
+	TCR_EL2,	/* Translation Control Register (EL2) */
+	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
+	VTCR_EL2,	/* Virtualization Translation Control Register */
+	SPSR_EL2,	/* EL2 saved program status register */
+	ELR_EL2,	/* EL2 exception link register */
+	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
+	AFSR1_EL2,	/* Auxiliary Fault Status Register 1 (EL2) */
+	ESR_EL2,	/* Exception Syndrome Register (EL2) */
+	FAR_EL2,	/* Fault Address Register (EL2) */
+	HPFAR_EL2,	/* Hypervisor IPA Fault Address Register */
+	MAIR_EL2,	/* Memory Attribute Indirection Register (EL2) */
+	AMAIR_EL2,	/* Auxiliary Memory Attribute Indirection Register (EL2) */
+	VBAR_EL2,	/* Vector Base Address Register (EL2) */
+	RVBAR_EL2,	/* Reset Vector Base Address Register */
+	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
+	TPIDR_EL2,	/* EL2 Software Thread ID Register */
+	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
+	SP_EL2,		/* EL2 Stack Pointer */
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
-- 
2.34.1

