Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E9923506A
	for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749568300; cv=none; b=Mr6eUPNmgKf1V+/U2skeGpy6+yPe7TEkLNd/jTVSKxAg3MtFW1dKVdEqT+LMSPZZgNUDEzI0CKkYqPU3NuK3W3nlc/cax8iMWaZI4p9M48Qv0q8/gLlGeV/matiPAiBc+O3+ZD6feqg8C+zo/QaSMsxCUUyIqClyzzHgRi+0cK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749568300; c=relaxed/simple;
	bh=KhXdvP/n6Pr3uERJTqt+/VZUjJ+mmGB8cHIouf8VUQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iXgk92fqYoX9q8tx5CHBYjnVjuasYDoT33OJ+lSLt7YXkqea5QO9oZ69STLtxb8YHItCgQBU8+UK/0wHOJdV42COzLDXTKrl7UUZ1fDOR27iwrBzCx7Ppau/YOjP9IoSIh4+SDKGV3DnPJS+SEsUy1Pkou0ZACgJj0kAD/1tov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGjbXw5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGjbXw5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7FCC4CEF0;
	Tue, 10 Jun 2025 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749568299;
	bh=KhXdvP/n6Pr3uERJTqt+/VZUjJ+mmGB8cHIouf8VUQE=;
	h=From:To:Cc:Subject:Date:From;
	b=vGjbXw5Fpp4cwCsu76hZdvuR/hkGijhY97Zo1KC9+NKMrljZ9LPcgIOvTgKO0y+Tl
	 spMei1D2h+2xhaG1sMDyUFKSdN1L7de4njilgzpGD2J4rWqWVIiGC8Aa8ZqRTtFIQu
	 NEetHtqpKPs4LTMNla/U+aU+sFJWDav9EYpQqWu7vf+CRBWFGVPzriYVIFOnXKK9xF
	 Okfh0D7m9tLA8qK/8G6RvN1BRqbs8hinWWXMUspcvPYGfTu7ou5RniRDwnO3FVLy55
	 tspumz6pfAB5PPN/cfA9yXF/42rofglmiq9hEyFCVkpPIIcUBczp4ooS4UktJ237Pq
	 k2FMDlsm24w5g==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvmarm@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] KVM: arm64: nvhe: Fix build failure with gcc
Date: Tue, 10 Jun 2025 20:41:32 +0530
Message-ID: <20250610151132.1758206-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Address a build failure encountered with aarch64-linux-gnu-gcc version
13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04)

/usr/bin/aarch64-linux-gnu-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__clock_mult_uint128':
/linux/work/arch/arm64/kvm/hyp/nvhe/clock.c:27:(.hyp.text+0x120d8): undefined reference to `__kvm_nvhe___lshrti3'
/linux/work/arch/arm64/kvm/hyp/nvhe/clock.c:27:(.hyp.text+0x120d8): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `__kvm_nvhe___lshrti3'

Similar to commit 9bfe7553fadb ("arm64: Implement __lshrti3 library function"),
this change use the added helper.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index a76522d63c3e..3dd2c780bbfc 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -17,7 +17,7 @@ ccflags-y += -fno-stack-protector	\
 hostprogs := gen-hyprel
 HOST_EXTRACFLAGS += -I$(objtree)/include
 
-lib-objs := clear_page.o copy_page.o memcpy.o memset.o
+lib-objs := clear_page.o copy_page.o memcpy.o memset.o tishift.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 CFLAGS_switch.nvhe.o += -Wno-override-init
-- 
2.43.0

