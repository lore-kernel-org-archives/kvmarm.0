Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B7D161320;
	Mon, 28 Oct 2024 09:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730108436; cv=none; b=c8uBqIRO8n1xKLbW3y2I6LVvT7pxhNrqpQ7ZDlBEBNPMVgylm6HqV7SOMWiJ9XZ4MOPjHDebzEYFGCo/n3/HIlFvDaPwZVu8WtrsYDCPEHzXVY4EtxdQpqKaot30ILSGdjA8nGi9eC/Af/NeC87wMjtexxbTbczVfLUIw3SL3QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730108436; c=relaxed/simple;
	bh=fOfCtMTTqempwM/M8Zy6RaQ+0MELCkS3ty5RpQLNX8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UksVwZnq7PJLsk6SCDolaNiSk7pGannRjqw7aEmffTBcpxkhETMOHe2/nbofduoMz4f7R8VztzleTVULAOd5J5eKbHItUHjk9nnYySFbb/LhnZR4pYF3EViVEeqZSl5FrpDjekMmBX78u1g/H3zGoqlhXKvnCj3hCxFkornIzl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMWEb3Q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMWEb3Q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD72C4CEC3;
	Mon, 28 Oct 2024 09:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730108435;
	bh=fOfCtMTTqempwM/M8Zy6RaQ+0MELCkS3ty5RpQLNX8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMWEb3Q3yr8sCY6ZLd++1Af1iFAAgAf3jSpETEVxbSccuguh6Cym2Gy0O5Ke8gqrC
	 l5hThnrs87kVHIuDBxZmVkSq1poOrkDHM5x5HUXaraiyME1BiLZ2esgzvPO7Y4Ot5e
	 bjGZudSe67agjEV28Y3gCStBWuGGggC97WWT2CcNoUsTBDAWL1FvpPwbas9N+tdNtK
	 w8X2G2eQhWRt7LfDwo4moHlF8IhsecpR/PWczONikDyrTvfKsVbhSaFyFwA8akimW2
	 rAF62ze9EJPFvPfwyFiRkrpRcBbThL/JNNr5imv6a2GX4RfpPJgaauHUZDlKbVpeoF
	 Ta9UPxKwRrkTQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH 1/4] arm64: Update the values to binary from hex
Date: Mon, 28 Oct 2024 15:10:11 +0530
Message-ID: <20241028094014.2596619-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This matches the ARM ARM representation. No functional change in this
patch.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/memory.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 0480c61dbb4f..ca42f6d87c16 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -178,17 +178,17 @@
 /*
  * Memory types for Stage-2 translation
  */
-#define MT_S2_NORMAL		0xf
-#define MT_S2_NORMAL_NC		0x5
-#define MT_S2_DEVICE_nGnRE	0x1
+#define MT_S2_NORMAL			0b1111
+#define MT_S2_NORMAL_NC			0b0101
+#define MT_S2_DEVICE_nGnRE		0b0001
 
 /*
  * Memory types for Stage-2 translation when ID_AA64MMFR2_EL1.FWB is 0001
  * Stage-2 enforces Normal-WB and Device-nGnRE
  */
-#define MT_S2_FWB_NORMAL	6
-#define MT_S2_FWB_NORMAL_NC	5
-#define MT_S2_FWB_DEVICE_nGnRE	1
+#define MT_S2_FWB_NORMAL		0b0110
+#define MT_S2_FWB_NORMAL_NC		0b0101
+#define MT_S2_FWB_DEVICE_nGnRE		0b0001
 
 #ifdef CONFIG_ARM64_4K_PAGES
 #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
-- 
2.43.0

