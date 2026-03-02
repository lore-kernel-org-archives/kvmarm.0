Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FEA36309D
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452636; cv=none; b=QTYHrBh9xoMVCNV0p0O7IAJvB6ymvR305Yv6mjNuO2Gs8xBuYhnaqJuyBwDibGC284Yxo6DYnczihH77GPlYqcSL62ujBANoKdUaiGMNkEns77Hmg/8oSBbuoL7octYmHyKKW+w89yKvu+fuScMXVYqF9mwH0DWbt4id8Q5xdU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452636; c=relaxed/simple;
	bh=JlNnHzoiIRqYxiZrfDRL/9oPoOp6cFzedhdEYt7uTLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDWrCWX87xdRyyPM/ExXRnT6N2gTNtR3hpq21OTH4pbb1yFxXrK/R9jeMyxh1gRDIOLJs4hIr+EEtIYN1+Zy7xbGOBiblH45HfMQrwxDSAewJgiM9yw2Xj8rOgj+E0oLQNSHYylxbX/4rDGK411GmaWTsx1qFQjBh5N/FA8wRD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHiEF3e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHiEF3e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6769BC2BCB2;
	Mon,  2 Mar 2026 11:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452636;
	bh=JlNnHzoiIRqYxiZrfDRL/9oPoOp6cFzedhdEYt7uTLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHiEF3e+Y+p4LfnFm/jEHZdHib262TD7NuaDcXJP+8Tsr+vh1dM22XTL00TSaSDoL
	 CNvrMifwL4M0OgZ2c9oCBkSebhpr+pwp0T4cS8dJ05vtkeIbX0DkD975Hw4G+YvS3k
	 hixL2XLD9XPEyvcH6CB38fBucakK4T9VXWx3gpOKWb1bROCQucs8oio8pGPhoHN4Ep
	 oC2IstDHJVzT9WXPR2UM6FqOeCVnAg6YH8fA4W0VQgWPCvvCmTJTHr52ZYOdA5P0AZ
	 sS3KhjLxK4ewwglzLLxb3CYuNx/r/4fSLjOxyiPHIle31kYi3b1MaePfDuKZR4+TqO
	 ygpVlo3b1kYng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1ti-0000000FDFJ-2lvC;
	Mon, 02 Mar 2026 11:57:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 08/11] arm64: Convert CONFIG_ARM64_MTE to FTR_CONFIG()
Date: Mon,  2 Mar 2026 11:56:49 +0000
Message-ID: <20260302115653.1517326-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302115653.1517326-1-maz@kernel.org>
References: <20260302115653.1517326-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

While CONFIG_ARM64_MTE=n prevents userspace from using MTE,
the sanitised ID registers still advertise the feature.

Make it clear that nothing in the kernel should rely on this by
marking the feature as hidden for all when CONFIG_ARM64_MTE=n.

This is functionnaly equivalent to using arm64.nomte on the kernel
command-line.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ab0a7d72608d4..a56d242fe1489 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -315,7 +315,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SME_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MPAM_frac_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_RAS_frac_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_MTE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_MTE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_SHIFT, 4, ID_AA64PFR1_EL1_MTE_NI),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SSBS_SHIFT, 4, ID_AA64PFR1_EL1_SSBS_NI),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_BTI),
-- 
2.47.3

