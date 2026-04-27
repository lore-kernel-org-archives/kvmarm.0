Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C5239B4BB;
	Mon, 27 Apr 2026 08:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278504; cv=none; b=P5EUPWT8eRGXfGTsbkr43b941QYmHttaivH9QEhGqYs5Dr2q/Gusozraad3oiSgd982h6KsBsQzpZ3p9rvROeAQxvXSyaYYhUyvSbyRKW345myPxf8Z/tus/8oruAlc02c9Mn+YfwHQUkT3KrCC5CS2ywVrF3A/apf87HmxfQ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278504; c=relaxed/simple;
	bh=ozzuj0X/PtzwBrR765l0/YzAmLPg8mI7Pw/GI5p4YRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppLzDMDkNaSkDPzb/yf3RPS/S2esYkNHLdcUa1TJMquqH35HF6T6BGCf65qvsosUZeOQq9xlJ/TFThBfy5aEzn2zS6+/mFQPj0OAZL/DOOGwYdnlR+99Yc44G41qidYeV8QcNmAelldUgaE69D7w48xrWKXZzLTYgrmX60u9B2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qABbb+zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qABbb+zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ECBC2BCB8;
	Mon, 27 Apr 2026 08:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777278504;
	bh=ozzuj0X/PtzwBrR765l0/YzAmLPg8mI7Pw/GI5p4YRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qABbb+zS7pJg/PB72zJd5lhhRbJrAX0d22Sr/Hon2QDiDKCdOJgHXXcIwcwGOa+Xc
	 oUqh0nZidU1Andz/gCaMgXjodzgyDBYSyLQYXoFsl8WRR5XTp7Ke8nl+FF14OicnAg
	 Uc5u+ZM34NrCkin0Bhylbg4GHgTQK0f7EDSf3Ece9R0prnWq6yC0KeSAyTtljVIxC7
	 i0Kld02dkRTPJoTh55kxnMRZd5J+OrOMMB80Gk+CPmLgXGgm+PwPM1g40Wl4y3dFAQ
	 kiFi2BtcM9bAAkAC4PLWmhmwxbGh7JTg9CsMGjL09Z+pQSgIWcXxGU3MYtxpaD8j13
	 Hddm8tWpOlGIw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 02/11] coco: guest: arm64: Fix a typo in the ARM_CCA_GUEST Kconfig help string ("and" -> "an").
Date: Mon, 27 Apr 2026 13:57:56 +0530
Message-ID: <20260427082805.931832-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427082805.931832-1-aneesh.kumar@kernel.org>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a typo in Kconfig file.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-guest/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virt/coco/arm-cca-guest/Kconfig b/drivers/virt/coco/arm-cca-guest/Kconfig
index 5f7f284dae1a..d295146bd92a 100644
--- a/drivers/virt/coco/arm-cca-guest/Kconfig
+++ b/drivers/virt/coco/arm-cca-guest/Kconfig
@@ -8,7 +8,7 @@ config ARM_CCA_GUEST
 	select TSM_REPORTS
 	select AUXILIARY_BUS
 	help
-	  The driver provides userspace interface to request and
+	  The driver provides userspace interface to request an
 	  attestation report from the Realm Management Monitor(RMM).
 	  If the DA feature is supported, it also register with TSM framework.
 
-- 
2.43.0

