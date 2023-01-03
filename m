Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6721C3DA7D
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 09:50:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A35C4BB6B;
	Tue,  3 Jan 2023 04:50:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id px-2Fwbl3Leb; Tue,  3 Jan 2023 04:50:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 305A74BB83;
	Tue,  3 Jan 2023 04:50:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A74DB4BB59
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 04:50:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LtrDOOSGhswl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 04:50:42 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A9EC40037
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 04:50:42 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D486B61229;
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
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1pCdwN-00GTcP-DI;
 Tue, 03 Jan 2023 09:50:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH 1/3] KVM: arm64: vgic: Add Apple M2 cpus to the list of broken
 SEIS implementations
Date: Tue,  3 Jan 2023 09:50:20 +0000
Message-Id: <20230103095022.3230946-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103095022.3230946-1-maz@kernel.org>
References: <20230103095022.3230946-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 marcan@marcan.st, sven@svenpeter.dev, alyssa@rosenzweig.io, tglx@linutronix.de,
 will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 asahi@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, Sven Peter <sven@svenpeter.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
