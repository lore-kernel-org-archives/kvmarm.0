Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA0C218EB1
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 10:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746010772; cv=none; b=mEDKhmENjyjj4MCxEf96IYCNyPDYZS17hJhKpmbAdIGp40pOZ16O/dqCWbKz+rKrPRotv31dM3qFHpXFosZxhZrmZ+2B8ebv2xRqTy1iowostdRUsYiMejra76uE5fK4qe5Wo9ObRjXx1Dd/GbUw4eLuAtabHZJzAE2XeIdXIGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746010772; c=relaxed/simple;
	bh=S7W8DRIj4nQb7EgQ8CiHg8cmsjttjAH3R0TpvHpNW6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZQizv4kc/ryxNJ03/IhXNPd+29lHt1GB0dIoOY9/Yo8KL2pgyydN+G0TpofOA+lnHR6COFj3MDDqCJyUD3b1CYtrUQypnN+z+pMETQYRXeWf/Pa8BKyTm9nD34uIcIhMkTO13zDUGcJ6wPMJEiOay8XtzO+0wRKc1+WjQ1gEAyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgTl/Q3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgTl/Q3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631BBC4CEF0;
	Wed, 30 Apr 2025 10:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746010771;
	bh=S7W8DRIj4nQb7EgQ8CiHg8cmsjttjAH3R0TpvHpNW6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgTl/Q3I4PR8gwxxWS87zwESe+f7XQjWRbhF92O4fhDcE33F0A1BlIYARk6Gns9e5
	 X2jhcFESTjKEeXXNyb917E+J4alHnx8P795RH4P2XzDoxD2lNCPyd7hUg77FtgZaDQ
	 MLST8qC6gU9/yFADO5Cb8bKEQGlQtNzcFNbFN+/AuMZjeAd8rl4ErAbR/xO1E/ofBC
	 Pq6aUWJ4BBU6CEiggNZaKqvCZOWj74DFhT9CBYuJBqGpzRzTAnN+suDgtILR74cvyd
	 2hHFDrMLweuQBz4hiG2/KGPwRwNAK+VQJd/vaPQM5iev0y0cZE3h9q1Xc4cdFSfA5j
	 MaImO/UWfFokQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uA5A1-00AFD9-E8;
	Wed, 30 Apr 2025 11:59:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 2/2] KVM: arm64: Kill HCRX_HOST_FLAGS
Date: Wed, 30 Apr 2025 11:59:16 +0100
Message-Id: <20250430105916.3815157-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250430105916.3815157-1-maz@kernel.org>
References: <20250430105916.3815157-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

HCRX_HOST_FLAGS, like most of these hardcoded setups, are not
a good match for options that can be selectively enabled or
disabled.

Nothing but the early setup is relying on it now, so kill the
macro and move the bag of bits where they belong.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 2 +-
 arch/arm64/include/asm/kvm_arm.h   | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index ebceaae3c749b..d40e427ddad94 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -52,7 +52,7 @@
 	mrs	x0, id_aa64mmfr1_el1
 	ubfx	x0, x0, #ID_AA64MMFR1_EL1_HCX_SHIFT, #4
 	cbz	x0, .Lskip_hcrx_\@
-	mov_q	x0, HCRX_HOST_FLAGS
+	mov_q	x0, (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
 
         /* Enable GCS if supported */
 	mrs_s	x1, SYS_ID_AA64PFR1_EL1
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 974d72b5905b8..3eb722a7ad7f3 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -102,7 +102,6 @@
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
-#define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
 #define MPAMHCR_HOST_FLAGS	0
 
 /* TCR_EL2 Registers bits */
-- 
2.39.2

