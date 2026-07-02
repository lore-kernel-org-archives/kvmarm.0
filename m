Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF07B30E82D;
	Thu,  2 Jul 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008183; cv=none; b=CsPfBh9r7r35dNy49iQgU3eE0+ON7ptfMoWu930eoZZR93GWb9EtcepDufokUp9pPThynSg2NvT79pxwiJQPe2SHWhC1Ds7GHhePF51K6LhIlc1pDrZa1u1y92J0VNBiTnOURPqgAhW2G11n0k/RBqIZcqJQ+trVOsW7iZXtpZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008183; c=relaxed/simple;
	bh=SEvD3URA+Glwh5OyaIiOOIT8bjqwmBtVkDQKkVbONYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tItgzZWLJZQWepsImguoS5AhOr5pJrBD3PuVeK2acJIYjXTfFi5sw6RD5aVHbg0vkVpemuFNn71vtxT++KPDrWeJwjJDWQoNkYuvUkpBRQsOgnEahUiMgCLj6DlcXs+/kFXfXZ4IY9v33HtZyRUfpRgl8TRN69HFxzecwX/vE/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEB/aSI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEB/aSI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7521A1F00ACF;
	Thu,  2 Jul 2026 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008181;
	bh=QDe8YvYJlu1JYh0yp9syTuhzrxaVjIvimEEjOf5rRHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hEB/aSI6bmXkzCiz0R4aOaqYbCGUA0pLpnQYaYGYk6BGkNyNpNVoGDU9MURvwdNTy
	 QnzbAycfkR6nK4sCPuHaCnuHLXu0x/jCUcE2k5u7kuRfLKjWneatHUAgd6lr43ZJin
	 B3ACju3Ms0ev7jASNxRmsp1AS26iDJ60gVaU4OJegxRNbt3H77qySa7M05PIO39Kj/
	 fbfirEd2hvNtfEW49YErR9JGrnuGknVQKqGk4ZvOMgAaESMZSUhFGAJOpa2fhYdVOh
	 h55f9dLiFWJ6/VH4CNo0ZpcJ/KYbUuJ3P/HL42mPPJSHN6xFxlVlmNxshUjVVW8630
	 2Z0X3iJScTgPA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsR-00000000ojd-33PD;
	Thu, 02 Jul 2026 16:02:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 08/28] arm64: Add ARM64_HAS_NV2P1 capability
Date: Thu,  2 Jul 2026 17:02:28 +0100
Message-ID: <20260702160248.1377250-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we're about to deal with FEAT_NV2P1, add a new capability that
will be used to key any support for it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/cpucaps | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 9b85a84f6fd49..242dc211d8efa 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -51,6 +51,7 @@ HAS_LS64_V
 HAS_LSUI
 HAS_MOPS
 HAS_NESTED_VIRT
+HAS_NV2P1
 HAS_BBML2_NOABORT
 HAS_PAN
 HAS_PMUV3
-- 
2.47.3

