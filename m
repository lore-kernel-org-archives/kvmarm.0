Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4984B471406;
	Wed, 22 Jul 2026 07:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706180; cv=none; b=E3Jtwm/DcxaVMf21ULKYGk9La7knpTTqsuB5QORZncYg/J+tHFboA7etM4L3LKfdvC46juIuPDtJ/RYMA4AHoA2EokLlV//qIEQbMTWnlHULQGQtHQZRMx9vBn2CSlMnDMHimrJswhbv03nfgsgFxfLv1bT3JQmlcpoBY2gXZ8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706180; c=relaxed/simple;
	bh=SEvD3URA+Glwh5OyaIiOOIT8bjqwmBtVkDQKkVbONYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVKZsqEXzJW5yHil+4aupkyHD8kT22prVPwIoDCDOMTwUBcq89UauTAJaC65YMAGfozx4gP02PXwOs+we6trDSK7+I6sCUXpaovf8fwk2uaf1tYJ2mD6WnpeiuFPUI+R6TFdzYqochCQ7tbctcDRT1G/ptSN3R0nUjY6KLekVlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUZGt4+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUZGt4+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C301F00ADF;
	Wed, 22 Jul 2026 07:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706177;
	bh=QDe8YvYJlu1JYh0yp9syTuhzrxaVjIvimEEjOf5rRHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUZGt4+DXlIejv/l/C+PeL+u/GYxaylHBLpy8TuPp5L2MmhQtHy+tMFDh3xO/ov4o
	 Fnz+8qw9cMaOJvfW15g1fRvmFIeY38hVuiASMCIpHdSXtt2lSohmy6O2f7DhT5PRud
	 ECtKmlQeHufflamTEy/NK5krjGw2WPgMfc1V8vthfu7Yb64v9ib5C/L4VAdp+feanF
	 x21ArEMy0zfkvjcnMXFGKBlsjO1l0RvmuKW1zI/VkzStJczSLFIYgZQFChU4PuYPZm
	 X1g6CH5z1DQss50e/E3vqt/vntpXvagyskMZ/ZOUbXJidV0sLuhJX8Vudl8JjtUg7o
	 +O1b5rGt3TLAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbT-00000007VfN-4C4p;
	Wed, 22 Jul 2026 07:42:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 08/28] arm64: Add ARM64_HAS_NV2P1 capability
Date: Wed, 22 Jul 2026 08:42:14 +0100
Message-ID: <20260722074234.3330999-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
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

