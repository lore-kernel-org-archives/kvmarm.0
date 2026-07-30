Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8583B9D96;
	Thu, 30 Jul 2026 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395461; cv=none; b=nuh7Wraja+4qy91fNhC/QaKWnzxKMvqhedwj1D8T9YW57mIGSvZEPwhoSYVl6geUinaqUAxZR6vr3/jhBFvIs7D3zXc1WnACO0kj1pov2JdR5aphvWIJo4pYoqbizKecvRdsHKhqbNewobhMK8Kvr2A8iUbUBS6ckHX8EcADTCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395461; c=relaxed/simple;
	bh=SEvD3URA+Glwh5OyaIiOOIT8bjqwmBtVkDQKkVbONYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPnfT2/f5wWJqyPyMjZ+JDZMBSD60FE9eivBRfhm8NQ0s/moJ3VUzAWn4KrVcnfLWH9mehJ8anTzqYwUESsmDZDEZO2yuNVsrpUcP6tN0yWMk2M+FolI6YT8MOSYvZkRBbgnw/duWvT/P8zkHuYJNnF6vlEEgAe4cnz6cy2aIoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oo7Ls81E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oo7Ls81E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC48A1F00ADB;
	Thu, 30 Jul 2026 07:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395451;
	bh=QDe8YvYJlu1JYh0yp9syTuhzrxaVjIvimEEjOf5rRHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oo7Ls81E2VZ5IXdXmm0UMEQLx+VGMT8bfl2tOYvgogY8OGoM6GBYiWNqPC1ttohlt
	 uZk1/8qGdj/VtLxiO8JMF+DouT+cdS8OZC/Gvj3d9g3MCfnKDzkscrn7E59IolAKk3
	 ttPY+h6KMOhfg+gAZ8Is7vX3nrJs51xlyxwlv/IQKB+DPniCW+4gdJQ4l6NBpyvGfj
	 JqWHcsQig2qrpkbbzhxTKKcCzuNTLXv7uGX1kBCcC31E5tVHfbnDfngMbVbyOHS4lb
	 QeVvcuP7ScAd5sfTQOvD0z4Cl40hA2Ve5WIpuH3ZnnWWX/d0aZxE6H+XoYieZXpcTr
	 OOYA2sJxPw8QA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKuo-0000000AOpW-0Igh;
	Thu, 30 Jul 2026 07:10:50 +0000
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
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 08/29] arm64: Add ARM64_HAS_NV2P1 capability
Date: Thu, 30 Jul 2026 08:10:01 +0100
Message-ID: <20260730071022.296811-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
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

