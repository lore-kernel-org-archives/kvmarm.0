Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F853BADB3;
	Thu, 30 Jul 2026 07:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395468; cv=none; b=pFk67ls3fxX7DhoU2G/AWgqMbT6vFvqIlV52i9akCC6PpgUtsnNDpE4jVprVLMp96aEgPZFgNeoXYL8Ws4mS7DnE1sa/UYY+GOg5Qg+5mfH17p/LIQ/6R8xqpSJiAAiR0vdueMvweeR/fGiYr2w1JENK5zFHwhQnT7lGtgcL+og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395468; c=relaxed/simple;
	bh=rUcyN6uAGe1vOQ9GUqQn+mE1kPx8Ir0yEVvo3/IzGYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EA4hA21SJL05SbICP4Xd1H0bp5FPZ8qOvOFPjefG/62IZMXO2VGGS+0yD41cMXIM8S4kPzvGJhdLQrzKldbaFe3bHF+agIziWB6+xavVBHKpJHAqHghdhiRWboUGGZ4c2XTibiNdcFi0kHyfvWy0mmFhMJ3IEllaw6EE/liA7RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4V4bVAh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4V4bVAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529381F01563;
	Thu, 30 Jul 2026 07:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395453;
	bh=xoiK/RNeZLIkLzyKO8ly8OA0RZ+EXunPBVOADEEok6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4V4bVAh6mS4qkI/+7dmo7LyHb+juTfPiSvUYwNyBc6I10tT7DAq7hGvwYlMbvwmf
	 IlWHefKhLzJ3wWGJ8+lXbkRcWtg0ETp/U8d7ikQypfjCFtIpOX+daZyS3PgxqIS4uc
	 k2UCN1wf7GaQXd6lovqP2y5aH/4q3BNAD5McPWhH7D+bEFuGWP3FiC0Cfy93Uoqbn/
	 JaR0Xt4O2UEwwluhD/+3J4fmr1h6BBBdXISKjsKxE8c4CtFmBbjK5olnAv0gm/bWvu
	 vtLFwIOEfFCeQAz5S1B0RqPik8PEI+bI28utrPK/uR9fjse0WL5D7EjH0frxWFIEHa
	 SI3mdDGAtTvSA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKup-0000000AOpW-2m7a;
	Thu, 30 Jul 2026 07:10:51 +0000
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
Subject: [PATCH v4 15/29] arm64: Add ARM64_HAS_NV3 capability
Date: Thu, 30 Jul 2026 08:10:08 +0100
Message-ID: <20260730071022.296811-16-maz@kernel.org>
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

As a bunch of KVM code is going to depend on FEAT_NV3 being detected
on the host, add a new capability that will describe it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/cpucaps | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 242dc211d8efa..7e0414509e89a 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -52,6 +52,7 @@ HAS_LSUI
 HAS_MOPS
 HAS_NESTED_VIRT
 HAS_NV2P1
+HAS_NV3
 HAS_BBML2_NOABORT
 HAS_PAN
 HAS_PMUV3
-- 
2.47.3

