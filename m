Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF0242E40B;
	Thu,  8 Oct 2026 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791461741; cv=none; b=qZZw4V7/NDJnboGF9cd98WmZ+M529JUIDu7TsnTMWo3irMmcvEZa/vJftKf5Jit+d41zIPfagawQ2IsApq2e3zjCSobpXoF9EGmvhZDt/u7Oyk5CQftx0VA5CuHURDC02CfHCvPq3rMnrE4OOE+LE7+OkMGLtXNxE25Kh/stL30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791461741; c=relaxed/simple;
	bh=hmqaMDC97RgiJmN1F2jM2y5vWKqluMYIQR51eKEs9yg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LAbEevDYk76UOMYf+GMEBFqntVGU+OiT1JCDKz7ZfV71540VkWzY7BkhhXSrGUPVq5Bqu1uCOVqs4BQ8puoU4/m0BjvRczjm/NQ+SKNEpMHknIHNt/OOfKkfvOux5aPNTnWFqWAiFA0RVN3MgeWaWDoUq5V2jyPujCGOAUwmz10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzA9wXo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzA9wXo/"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54AC6C2BCF7;
	Thu,  8 Oct 2026 12:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791461741;
	bh=hmqaMDC97RgiJmN1F2jM2y5vWKqluMYIQR51eKEs9yg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LzA9wXo/HNHhlrd3f75Zo3ogYWTfXC4BQ12PMRrW3h/VzQkZfGdQcfzBPrug6ExmF
	 I7zc/+jjt3YwV8E6Zmu+caIooN66BlEfRx8r0Yx4Tt9Gm6lgwgaSGh/Uh+CbBi2UZ+
	 lYQDNcvK6VAnZ1zSUdvhidUMMZVHx3w2U7OFoNLiuSsj06KbqSazF0fLjtDtU7M1ZY
	 EJaCzWg55ARAUwpr2cJkH4849pNssYl9A/25oP1H3An/mItm/3ci3maL4zgGHR1hZJ
	 rWP9dGB4/SZBQh8VgSkC2YVQ7fGNcdqQSBUdHORR/LOmgZp6m00RG2mO9FYBS8r+qb
	 PhJr7Dp0nokRw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31691CA600B;
	Thu,  8 Oct 2026 12:15:41 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Thu, 08 Oct 2026 23:15:40 +1100
Subject: [PATCH 1/2] arm64: Add Apple M3 and M4 CPU part numbers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-apple-m3-m4-kvm-v1-1-7bb4cbf3d63b@gmail.com>
References: <20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com>
In-Reply-To: <20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Myria Sarvay <myrialsarvay@gmail.com>, 
 Yureka Lilian <yureka@cyberchaos.dev>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Sven Peter <sven@kernel.org>, 
 Janne Grunau <j@jannau.net>, Neal Gompa <neal@gompa.dev>, 
 asahi@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791461740; l=2684;
 i=michael.reeves077@gmail.com; s=20261008-m3-m4-kvm;
 h=from:subject:message-id;
 bh=PEdWG9ncjIcAyWnZOURiTkm/6ky2y2vMSIKvBUKuJzk=;
 b=cmRFNqs17RvnRnCr7VfpE/rtJU8SOHUN/kqOC8PGveztbckVISV2jz1woxdxz6iL7lF+i2/6x
 eaXweQ+BZRiBOjN4iboqPrHRG9JyfT9bHQEBHADO2bdLppMOxGrykcL
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=oi7WuppQ1A+qFZp9DdfIwDnpC3WZ+XY6fJK1upV/CSY=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/20261008-m3-m4-kvm with auth_id=1131
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

From: Myria Sarvay <myrialsarvay@gmail.com>

Add CPU part numbers and MIDR definitions for M3, M3 Pro, M3 Max and
base M4 so CPU workarounds can identify these cores.

Separate M4 core codenames are not known, so use the SoC codename with
ECORE and PCORE suffixes.

Signed-off-by: Myria Sarvay <myrialsarvay@gmail.com>
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 arch/arm64/include/asm/cputype.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 1fa29616e..ca44c354c 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -155,6 +155,14 @@
 #define APPLE_CPU_PART_M2_AVALANCHE_PRO	0x035
 #define APPLE_CPU_PART_M2_BLIZZARD_MAX	0x038
 #define APPLE_CPU_PART_M2_AVALANCHE_MAX	0x039
+#define APPLE_CPU_PART_M3_SAWTOOTH	0x042
+#define APPLE_CPU_PART_M3_EVEREST	0x043
+#define APPLE_CPU_PART_M3_SAWTOOTH_PRO	0x044
+#define APPLE_CPU_PART_M3_EVEREST_PRO	0x045
+#define APPLE_CPU_PART_M3_SAWTOOTH_MAX	0x048
+#define APPLE_CPU_PART_M3_EVEREST_MAX	0x049
+#define APPLE_CPU_PART_M4_DONAN_ECORE	0x052
+#define APPLE_CPU_PART_M4_DONAN_PCORE	0x053
 
 #define AMPERE_CPU_PART_AMPERE1		0xAC3
 #define AMPERE_CPU_PART_AMPERE1A	0xAC4
@@ -250,6 +258,14 @@
 #define MIDR_APPLE_M2_AVALANCHE_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE_PRO)
 #define MIDR_APPLE_M2_BLIZZARD_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD_MAX)
 #define MIDR_APPLE_M2_AVALANCHE_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE_MAX)
+#define MIDR_APPLE_M3_SAWTOOTH MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_SAWTOOTH)
+#define MIDR_APPLE_M3_EVEREST MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_EVEREST)
+#define MIDR_APPLE_M3_SAWTOOTH_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_SAWTOOTH_PRO)
+#define MIDR_APPLE_M3_EVEREST_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_EVEREST_PRO)
+#define MIDR_APPLE_M3_SAWTOOTH_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_SAWTOOTH_MAX)
+#define MIDR_APPLE_M3_EVEREST_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_EVEREST_MAX)
+#define MIDR_APPLE_M4_DONAN_ECORE MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M4_DONAN_ECORE)
+#define MIDR_APPLE_M4_DONAN_PCORE MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M4_DONAN_PCORE)
 #define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
 #define MIDR_AMPERE1A MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1A)
 #define MIDR_MICROSOFT_AZURE_COBALT_100 MIDR_CPU_MODEL(ARM_CPU_IMP_MICROSOFT, MICROSOFT_CPU_PART_AZURE_COBALT_100)

-- 
2.56.0


