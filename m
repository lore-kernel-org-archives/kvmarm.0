Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E1217FEC
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 18:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F7AC433CB;
	Tue, 15 Aug 2023 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692124757;
	bh=Pu5/m4V91n7ForLZVXmW/QgYRJioM8DMdMmzU8H8Dck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSyjblIQNU8tz+FwRLEb779vvHt3RsvHwrlQbBHZFnnu4k+DO/6x2LzPfsAyEws/l
	 ojFiYU/mFtYlfCmiH4NqNiT2gmp2oisnI12J4g6WF2+/fN4vSXT/yS11uvRZ9UdzYQ
	 wjrUK4ijZxW8ziVdHvOzynnwa+z+jvZx1iofatthFNrrOJhpDII9vmZlqvAGRnBhp9
	 LDO2ltAYOShlJcTzDlvz5jkm0TSK0v6mti35bzJusMdgWbzcQDNetkShFv0xPSEm+z
	 VuRTIDFsgkb7eaHjMTV+NRrT7XsbQNSJbWkHv0fKa0ajIOfoiLPIKSY8lGppNNvMm9
	 3NlhNKasSzVEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qVywl-0055Sd-NR;
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
Subject: [PATCH v4 02/28] arm64: Add missing ERX*_EL1 encodings
Date: Tue, 15 Aug 2023 19:38:36 +0100
Message-Id: <20230815183903.2735724-3-maz@kernel.org>
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

We only describe a few of the ERX*_EL1 registers. Add the missing
ones (ERXPFGF_EL1, ERXPFGCTL_EL1, ERXPFGCDN_EL1, ERXMISC2_EL1 and
ERXMISC3_EL1).

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 85447e68951a..ed2739897859 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -229,8 +229,13 @@
 #define SYS_ERXCTLR_EL1			sys_reg(3, 0, 5, 4, 1)
 #define SYS_ERXSTATUS_EL1		sys_reg(3, 0, 5, 4, 2)
 #define SYS_ERXADDR_EL1			sys_reg(3, 0, 5, 4, 3)
+#define SYS_ERXPFGF_EL1			sys_reg(3, 0, 5, 4, 4)
+#define SYS_ERXPFGCTL_EL1		sys_reg(3, 0, 5, 4, 5)
+#define SYS_ERXPFGCDN_EL1		sys_reg(3, 0, 5, 4, 6)
 #define SYS_ERXMISC0_EL1		sys_reg(3, 0, 5, 5, 0)
 #define SYS_ERXMISC1_EL1		sys_reg(3, 0, 5, 5, 1)
+#define SYS_ERXMISC2_EL1		sys_reg(3, 0, 5, 5, 2)
+#define SYS_ERXMISC3_EL1		sys_reg(3, 0, 5, 5, 3)
 #define SYS_TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
 #define SYS_TFSRE0_EL1			sys_reg(3, 0, 5, 6, 1)
 
-- 
2.34.1

