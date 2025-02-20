Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA3E1FA851;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059354; cv=none; b=lelXiqajAJ2J89dc7qNmhA9PMguAUe9VKrfZej41AAeaHgSXNaboIi+Ci499N6xHlmcbN71bkIn5jO9uexoRtlVuSJygdkLmYuIl4IWecXUxiR0Zwlo6UkE5EV3noHVDD8H5nCgycsdxFzLfZr56u6uWJBu4tgQY5SFuedZOWkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059354; c=relaxed/simple;
	bh=4L9e3x4dCeFSSHA1otQ4XS7vmrkCkOdcXz3bm7vANK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z8YuDsaTolQMVYFWAe8z0NQk6AEEQ7yv7reCJQQu943xXR3jroAGeb4/VFzrQnXT+6LLpkb8928rqHfpuxKYbFtdSBb5AUdSjc5bDFlSKaZEtWRi9ScWic0qawMUP65c4MCW5A08QQadnZkeAG29xKO813lpvA4sptWyIX/j6BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDRDzYNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDRDzYNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAEDC4CED1;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059354;
	bh=4L9e3x4dCeFSSHA1otQ4XS7vmrkCkOdcXz3bm7vANK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDRDzYNdjy42OOJyWBgWmxqB0to6d0ML42uNMqLtYV4qCjTG+2pLRA0zFV8MYBhev
	 dg5n4UySvizp3QlEBCmE7O7czFFlfU3bhAtHsJR0q7NVwynDav+Xn8XBcsdC2yQijv
	 Gfs6QuNU66gMRmzQ8iIjYKBL8+BwGHr88e7y0+/UgvIsjm9TD9d3XVowMq2aNg6b69
	 g+N+o2pz5OWgNQrKQJJ/EN2iVshPlr6SKNkaEgrvwuZIK4k+4AnxCTsSXbXAv5/2aR
	 3J3D46nx8VnEUF47CiW0X1W2ePO/LiHRq/D8eWAtVlEahkIj2NCxawhm5Ufwna6Ckl
	 nrUCnRieP4vYA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vQ-006DXp-KR;
	Thu, 20 Feb 2025 13:49:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 05/14] KVM: arm64: Advertise NV2 in the boot messages
Date: Thu, 20 Feb 2025 13:48:58 +0000
Message-Id: <20250220134907.554085-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make it a bit easier to understand what people are running by
adding a +NV2 string to the successful KVM initialisation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b8e55a441282f..5ea09f13c7bc0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2806,11 +2806,12 @@ static __init int kvm_arm_init(void)
 	if (err)
 		goto out_hyp;
 
-	kvm_info("%s%sVHE mode initialized successfully\n",
+	kvm_info("%s%sVHE%s mode initialized successfully\n",
 		 in_hyp_mode ? "" : (is_protected_kvm_enabled() ?
 				     "Protected " : "Hyp "),
 		 in_hyp_mode ? "" : (cpus_have_final_cap(ARM64_KVM_HVHE) ?
-				     "h" : "n"));
+				     "h" : "n"),
+		 cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) ? "+NV2": "");
 
 	/*
 	 * FIXME: Do something reasonable if kvm_init() fails after pKVM
-- 
2.39.2

