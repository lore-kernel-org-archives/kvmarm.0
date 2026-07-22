Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30BA472547;
	Wed, 22 Jul 2026 07:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706181; cv=none; b=vCizS6ZnUn8Uit30hLhDoSoDFdGDVRNPjJysAeGeEtXvHwQUvajcjo0aYmNFnvee1z/FWxJ0jBKHGinqL/zRcKpnA0KF4iW0nrMqKQQhW+4po06S/udB/Kwkgyrp2DgvG5zLmRD99TY/1Mj4zcezPF+v97DKe77tJaVtYxSwYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706181; c=relaxed/simple;
	bh=Zy278rRax54mrzMxjAGL/u8/EClB1XYWGsGocRgrokY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4OGgsU/nnbnRUhbh7KLvTtmJI5IIUvq8nvEvKa/z3XOU4/uFlJv28Pz286Vc0EPdWwGHY6Omuadgd6RIgbzvDQrtvxg4CSvK86U3Mh70H1GsMZBgD7VKyFI8lK06zvUHdRcV1bINtCPbBovGItWlskhmSm051/FzgazzdSmz6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXWFxdUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXWFxdUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD32E1F00A3E;
	Wed, 22 Jul 2026 07:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706178;
	bh=ji8nSRKlAPdWEdBVe8ICSTMa6u+ah4ntK0FcnZBJE6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXWFxdUoqLt5fcIV+FraJYXSEWtwLRWIjnQFxcTPufsFxJFpFiAGvs1SR4ru7Q8f4
	 ItcFnb1IE81RB5HonqGoDjB4UtOJ99v29efraYLlOY71MvKSsyzvs6Oc9Oml+UX1oP
	 nk3aNyTIBJeOVBTzSHm71hzKAxdykJQabE0QbYKYrnlO3EOE4CKN6aUg7lqKnLIxUT
	 hHMZP+gOy6xasN16MYu/TqMfg05gcgDY1SPvEsX0BvDJ6LvTB4PkWhqpgSrEe3f7wD
	 F9QsJ+Z0vcPMLA0Pk4ZRNS72WYGfleotbJ4b/DjeOjbBPxynnB+oSIwqXoBPLQu2YP
	 kKsukxFsLD9eA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbV-00000007VfN-0bUI;
	Wed, 22 Jul 2026 07:42:57 +0000
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
Subject: [PATCH v3 13/28] arm64: sysreg: Add NVHCR_EL2 description as a mirror of HCR_EL2
Date: Wed, 22 Jul 2026 08:42:19 +0100
Message-ID: <20260722074234.3330999-14-maz@kernel.org>
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

FEAT_NV3 introduces a new register that contains the HCR_EL2 value
exposed to a NV guest. As such, it has the exact same layout as
HCR_EL2.

Describe NVHCR_EL2 as a mapping to HCR_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 28755f70f0bf0..42839d2b15ae4 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4266,6 +4266,9 @@ Field	1	E2TRE
 Field	0	E0HTRE
 EndSysreg
 
+Sysreg	NVHCR_EL2	3	4	1	5	0
+Mapping	HCR_EL2
+EndSysreg
 
 Sysreg HDFGRTR2_EL2	3	4	3	1	0
 Res0	63:25
-- 
2.47.3

