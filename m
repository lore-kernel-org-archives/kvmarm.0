Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1BC2DF13E;
	Thu, 12 Mar 2026 08:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302703; cv=none; b=BDimxybiH8xrGtwS4RYrgvIbbvyItQBWAHfwjMB0b8gsfRsnCYXf/ituqNdBFh2FUhrnCnixwV6OYiXc6QioyoHTDQKzJ5gYEvYngyvE29DT4hGAX4SIvOgYCSKRWfnkGWavCqjUHApIg1ml7Vm7BLDhhJngQR5tlWJLuNlnB/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302703; c=relaxed/simple;
	bh=ozzuj0X/PtzwBrR765l0/YzAmLPg8mI7Pw/GI5p4YRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr2ripBrRAhURZNgpSLOXTfNyoORYCKE2cnyaNMddvMz5E3hV29PbX66p0/Z6XqhezFlLb5JhdoveaCRACKLV3Xf3gAUXhS9kCeFf9fzlKGCzO1nEjWzyZYo4C4vXncJ3WLiReQctVIW8BoaRAOtI0qz3EFkX1ulVnZ+jZA8J0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ok9i91G3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ok9i91G3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0380C19424;
	Thu, 12 Mar 2026 08:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302703;
	bh=ozzuj0X/PtzwBrR765l0/YzAmLPg8mI7Pw/GI5p4YRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ok9i91G36sGhFiu9Y4Ttdr0KMibF0qeTM7ReY6MZgkGswNfpF87TmLgC0BkoRCbOy
	 rPVAcukPTJyOrprYh9Yyz1wnCI5CVAg22KmSBBoosNsPkXvu6ZAS3EXna0ajn5HZw7
	 Sih4H8AOiTBppiAnUJZB03Oa3kfEmuDn2bMlcHxq2X00vEu19KhMxc76rkXE1ZG4Ik
	 c5Jm7JLp4xz8rmVSxTHfPqUJ5z8l/7hKLkxWUAh41qvaB72k8+ZyQbQ31WHeWRc4mG
	 GCbkR2Fq261EkYhWPD3uLhEN5NT+Fbggq7YtXeTGVWwUxZtT9C7OQo+vKjfKHTq7Rw
	 Uq0CMeAvqod+w==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH v3 02/11] coco: guest: arm64: Fix a typo in the ARM_CCA_GUEST Kconfig help string ("and" -> "an").
Date: Thu, 12 Mar 2026 13:34:33 +0530
Message-ID: <20260312080442.3485633-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080442.3485633-1-aneesh.kumar@kernel.org>
References: <20260312080442.3485633-1-aneesh.kumar@kernel.org>
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

