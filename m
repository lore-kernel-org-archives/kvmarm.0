Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024759;
	b=4EPZNQXQn//NQzqmyXoJLkj+UJO6FvG8loBcLo4KseIgfPj/9J1s6A5rgdxXyWSFheUR
	 DnNaCCeJ7JSSXx65X1GaWcFJZWScmy2untIL98jSJQ7TEuum59RNmN6qcnbcw+MWGDzcB
	 IHmUkGAZ0HMevKyR4RE6bcKPauwUDIgR7kHZKHDtDeo67k+IhIQXDFtX4vvhTVvtByN5L
	 q2s7LbutwoXLAEZAR7FGxaBEbjQvNVX/Z+amjGpGNCoiDrexyS+M3SBcJbe2pnqLpTv0U
	 hhDE6dKfn7eLm4/SMZvYGgf79eumC9tf3gCiH/BFA/pTrv/zIBBJ4Urp8cg7KPwMgNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024759;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=E2uOxf0rKJT7HU77NZNT4DkyxJwury1M45enAmemSE0=;
	b=4ojIM9fDt6VyXfADdxU//h/tvCQEdW/AF7Lj+RsZuprTxHyO2xbCxb6KRdgD2H6oH2w9
	 8Rkpe+fYiYGnGKMG8cM5gwfvY/2dDE1IbpNiTv/SWeFh6SFg/hWj57bmL5dkcPJGGf5yS
	 fqyLI7j8akCcczUvq+1bYuUa6Ok6aPu8ygCLuvmqC+AIx2Mbuu13amklFgpXq6KtS3Sao
	 0Fr8QejIgHfj3yIDI+IXYh+iM/GsFSMU9fYV1veWpTrg2oCM0kRZSKi4IlGbjGwZthW0n
	 nsECxLSkRGce1ohytav7UljCyjEqvchkrTF5bHJ7HhdjtvFeEHVnIPu3jZ6MMz5fz7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UDWBNWL1;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7F6606A32F
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:59:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B7F6606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UDWBNWL1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F5541477;
	Wed, 18 Nov 2026 09:59:16 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA8493FA7A;
	Wed, 18 Nov 2026 09:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024759; bh=osGrLTG+wTWwCZXbgV0cH1lOH7Nt5lHAjlM6498QZbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDWBNWL1hfLJUVhRR69dd2vCCowM9bq8Ovv0zCqiSIxRWEXGLT1L+tKkzgnUGkyzu
	 NYNu37mB4yfGggMADOkWkeKJBfEFyZ40NksiRPexd7pjrw3fJ5UTyQk/GCmgy8pLC2
	 nKf0ZoKukgrHDv332KUVRxVG8LpNZILUeulJwmEA=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 18/23] arm64: Expose the GICv5 irqchip option
Date: Wed, 18 Nov 2026 17:57:50 +0000
Message-Id: <20261118175755.1946977-19-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow --irqchip=gicv5 and prefer GICv5 for automatic irqchip selection
when the kernel supports it. The IRS and guest DT support are now in
place.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                         | 4 +++-
 arm64/include/kvm/kvm-config-arch.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index e5a26252..63e0b979 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -78,6 +78,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 		*type = IRQCHIP_GICV3;
 	} else if (!strcmp(arg, "gicv3-its")) {
 		*type = IRQCHIP_GICV3_ITS;
+	} else if (!strcmp(arg, "gicv5")) {
+		*type = IRQCHIP_GICV5;
 	} else {
 		pr_err("irqchip: unknown type \"%s\"\n", arg);
 		return -1;
@@ -405,7 +407,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 
 	switch (type) {
 	case IRQCHIP_AUTO:
-		for (try = IRQCHIP_GICV3_ITS; try >= IRQCHIP_GICV2; try--) {
+		for (try = IRQCHIP_GICV5; try >= IRQCHIP_GICV2; try--) {
 			err = gic__create(kvm, try);
 			if (!err)
 				break;
diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index d8a8ef7f..46130663 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -59,7 +59,7 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
 	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
-		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
+		     "[gicv2|gicv2m|gicv3|gicv3-its|gicv5]",			\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-- 
2.34.1

