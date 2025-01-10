Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EE21E32C5;
	Fri, 10 Jan 2025 11:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736506839; cv=none; b=nITkdtlPiMKVTJpEuO0MBV3WnYxEv83RgRGJh59Wkv4AsdQWLYRbiM1ZSgXzBZMCuP8P9YguQkP7BRbNZsInTVVRTIUkASy2n7B4aErXM6xXnNRlCXEReEorx89tQUo/y+z6L2IBxsFK3l8QvLeTaRGDlxsa2VMdKgPMac56jDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736506839; c=relaxed/simple;
	bh=Za9GLFN307WlkUl4niP5UUi9dXFcP6CZJGyLTcZ6JB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rED3zoRbmvFFpRqsT5V+RcnoAiZsM8EIjaCLWXaQeDeDEn6tzYjucPC0X425vJTLgN8nj4MlT1WJAbm+/OK4Vr+u4FyQhBhIrRyqYdh1M7jG9TK1HquG/yn31NxEvweKesBST0se+fSE0ViJQglGKvJQhma7eZ5sRyuEl2cd21A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rfipLdXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rfipLdXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21EDC4CED6;
	Fri, 10 Jan 2025 11:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736506839;
	bh=Za9GLFN307WlkUl4niP5UUi9dXFcP6CZJGyLTcZ6JB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfipLdXDNDrYj9mvGzw+/seBMC8NGic0jCoI6n1JtOoDqS5avsb6sPCPUGh8YYeRE
	 EcyKAOK0b3HuWZkDF+YLdY/QXj2sFgFdhbuQ7xhaQhxxxhP5JrZ3F5an2SB76ucQ3f
	 FN9zW54e0WsW0BvJR+IA+tGFUApqzOqYwJ9fY87oi2pxB0oqO3yB858RB34365Lt8e
	 0XuYN3Etf571wfynznXYuisKYaz8V+sdAzJOhmH86p9mqhXgV/BCRmY02HqSyLCLqY
	 FVuotW9UMB4pdWvjVxUCuuERnoXVJ+WldI8SnPzJbm0SypCVWZ9MoI6kHioo+Hoq3/
	 ivHIh4v6wv68g==
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
Subject: [PATCH v2 1/7] arm64: Update the values to binary from hex
Date: Fri, 10 Jan 2025 16:30:17 +0530
Message-ID: <20250110110023.2963795-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
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
index 8b9f33cf561b..cb244668954c 100644
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

