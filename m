Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9884020EE;
	Tue,  3 Jan 2023 09:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431CFC433EF;
	Tue,  3 Jan 2023 09:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672739441;
	bh=QagyCicwiw0PUhea9wxFGenMt5PRvlzgWVpE9fRmJ5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8t5ZX9HZcFmk5luOzpQRjJGb8pu7v1GjJa2RKUPzf6jz1PzAvVn5Ao4HbJGhdtjM
	 oM/RJ5zGFmZ+gzNE5shxvH50pd4qhqDPoHi7w2n87mESwTpBiN6+EcwsAz2AU6Fj2P
	 Zcbv9GVs0l/iSOCRYMn4WIKbEKYU8DV+Y0Rie0jltvIMLm1IgILqVFh/j8iRGFJws8
	 gaPYdGyeX8Iwc0KwgRclDfD1/jBOfRIhJ7vMYvCDG4laTk9H1OFsgoVgBf7pdDH3cW
	 /wFpI10IYxf3zxS1/UIHmjUa5+x7SiL+PvWUNto1uyx2yePaotHUNAVCPhJyzptjK2
	 AV9pO/guE+4hQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pCdwN-00GTcP-DI;
	Tue, 03 Jan 2023 09:50:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>
Cc: Hector Martin <marcan@marcan.st>,
	Sven Peter <sven@svenpeter.dev>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Thomas Gleixner <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	asahi@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: arm64: vgic: Add Apple M2 cpus to the list of broken SEIS implementations
Date: Tue,  3 Jan 2023 09:50:20 +0000
Message-ID: <20230103095022.3230946-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103095022.3230946-1-maz@kernel.org>
References: <20230103095022.3230946-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, marcan@marcan.st, sven@svenpeter.dev, alyssa@rosenzweig.io, tglx@linutronix.de, will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, asahi@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20230103095020.HZkKdGsTr7EpH0lRcTZXhrFHdxePqFW02PIGvh_iRvQ@z>

I really hoped that Apple had fixed their not-quite-a-vgic implementation
when moving from M1 to M2. Alas, it seems they didn't, and running
a buggy EFI version results in the vgic generating SErrors outside
of the guest and taking the host down.

Apply the same workaround as for M1. Yes, this is all a bit crap.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 4 ++++
 arch/arm64/kvm/vgic/vgic-v3.c    | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 4e8b66c74ea2..683ca3af4084 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -124,6 +124,8 @@
 #define APPLE_CPU_PART_M1_FIRESTORM_PRO	0x025
 #define APPLE_CPU_PART_M1_ICESTORM_MAX	0x028
 #define APPLE_CPU_PART_M1_FIRESTORM_MAX	0x029
+#define APPLE_CPU_PART_M2_BLIZZARD	0x032
+#define APPLE_CPU_PART_M2_AVALANCHE	0x033
 
 #define AMPERE_CPU_PART_AMPERE1		0xAC3
 
@@ -177,6 +179,8 @@
 #define MIDR_APPLE_M1_FIRESTORM_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM_PRO)
 #define MIDR_APPLE_M1_ICESTORM_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM_MAX)
 #define MIDR_APPLE_M1_FIRESTORM_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM_MAX)
+#define MIDR_APPLE_M2_BLIZZARD MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD)
+#define MIDR_APPLE_M2_AVALANCHE MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE)
 #define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 826ff6f2a4e7..c6442b08fe80 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -615,7 +615,8 @@ static const struct midr_range broken_seis[] = {
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
 	{},
 };
 
-- 
2.34.1

