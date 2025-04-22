Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD3B27E1A7
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 12:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745325558; cv=none; b=CCc0fCkLlLf0kzR6omvDZBIO6nmHaNF1hyudmcVvNb9N6cF5HWMgZX3MzG0jHVczsTpVOouccwsO4werR1/xCrinWWporG+jRrtGN6kGi3D4QqnX8tfi6q7EvC5RjtOHI3M0rhdu+JeGJ9XeqYZi1dLYRMwPyBpMwbtRRdIDF7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745325558; c=relaxed/simple;
	bh=64yiAE3W4ZJTOG58pLVENVGyfqZ4s0C/3rjyV7DX7uA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UVM0fCQc/negsCEImM/ufLJFM3io5YfBtvbg+LfAEM87z78+3t2ayieJWuJ5n5UMlmvNckBzcuab2JV42a4me5gTBHOunswtcPob0wljTBxxZXg0zdm4KnrmjTRHd3zx44fLouskLFy+GFFj6WnxeDnf1FMw94cJD2vVYUDiH1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CdbRw2v/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CdbRw2v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD14C4CEE9;
	Tue, 22 Apr 2025 12:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745325556;
	bh=64yiAE3W4ZJTOG58pLVENVGyfqZ4s0C/3rjyV7DX7uA=;
	h=From:To:Cc:Subject:Date:From;
	b=CdbRw2v/x0vgIdzw9glg8T/PRAB96626Aom+yfUcHT5jhn9ZIN7oYEym+5s4QfnMj
	 ns5PdqraI0bjyNsgdzyTdRz4BD/ZBoqeqvaTcPh4ui/MX6Nh1OmXk5pUjG4IpR6iJH
	 jKbdD45S6mUQ0qi4j3m7befSy3k3AMYWW1X7zz5OeQftKHjqhp6vZEpsyTmZRtfEgV
	 PFKFJ410tSIMBb8APtKCe1c3TDTQbYZ4wH1gAibf6YSmwgEFqLC37HQZp9AMkFH5g2
	 DiSSVTDrdyzr3JxcCzv2xg/EifG/WgwXfIGhsEPSsJ8DJ7HGzdGSqaJZ6Hxm1LaYiY
	 JWLo2dKE7gmew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7CuA-007cSc-GI;
	Tue, 22 Apr 2025 13:39:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: [PATCH] KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
Date: Tue, 22 Apr 2025 13:39:01 +0100
Message-Id: <20250422123901.2675976-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, scott@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We keep setting and clearing these bits depending on the role of
the host kernel, mimicking what we do for nVHE. But that's actually
pretty pointless, as we always want physical interrupts to make it
to the host, at EL2.

This has also two problems:

- it prevents IRQs from being taken when these bits are cleared
  if the implementation has chosen to implement these bits as
  masks when HCR_EL2.{TGE,xMO}=={0,0}

- it triggers a bad erratum on the AmpereOne HW, which catches
  fire on clearing these bits while an interrupt is being taken
  (AC03_CPU_36).

Let's kill these two birds with a single stone.

Reported-by: D Scott Phillips <scott@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 974d72b5905b8..bba4b0e930915 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -100,7 +100,7 @@
 			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID1)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
-#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
+#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H | HCR_AMO | HCR_IMO | HCR_FMO)
 
 #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
 #define MPAMHCR_HOST_FLAGS	0
-- 
2.39.2

