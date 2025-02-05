Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDFFA32
	for <kvmarm@lists.linux.dev>; Wed,  5 Feb 2025 13:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738761805; cv=none; b=csnsNprBmFnF5FuuN+Ni5KChpTQ8dj/QhmdK8ydkfydQsRAsxRtXcwMOFsFPF6+iTSilQqS031rG2/DNkY8vavByZd1nir3z/uAWELwJ/ZuBqdH6Y1KdqxkETfNJI+BHjJA7bBfK1HJP3iV8qr2FTLRYRINqyUAfXleQk6EhRZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738761805; c=relaxed/simple;
	bh=9DCk9W2rTfBfNuX2jyhPLrs/gOn/H42YlyJB9oCm5Rg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L21yK0iW0k+kmMYr8abDAH7pDU2Jo5xHQ8dF5PzCLOwhFx7gQopflf2fqG0RkZT+Xz2mHK68IsyIRRlLieM96qdn+l+bKU+2Gy0TCNE1Vgfp8+ONGiTligdTrY1qJFlQEz1phrloNyofeGOdD8FFiveTuRUpl17oPvdcoFzJVSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Yp17w0k0Kz6FBYy;
	Wed,  5 Feb 2025 21:20:44 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 8511914034E;
	Wed,  5 Feb 2025 21:23:22 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 5 Feb 2025 14:23:14 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v6 3/4] KVM: arm64: Report all the KVM/arm64-specific hypercalls
Date: Wed, 5 Feb 2025 13:22:21 +0000
Message-ID: <20250205132222.55816-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com>
References: <20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 frapeml500008.china.huawei.com (7.182.85.71)

Currently ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID returns the
bitmap corresponding to KVM_REG_ARM_VENDOR_HYP_BMAP and it only
returns _KVM_FEATURES_FUNC_ID and _KVM_PTP_FUNC_ID. Change that
to return all the KVM/arm64-specific hypercalls exposed by
KVM/arm64 to guest operating systems.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/kvm/hypercalls.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 27ce4cb44904..5cef2590ffdf 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -359,7 +359,11 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
-		val[0] = smccc_feat->vendor_hyp_bmap;
+		val[0] = GENMASK(ARM_SMCCC_KVM_FUNC_PTP,
+				 ARM_SMCCC_KVM_FUNC_FEATURES);
+		/* Function numbers 2-63 are reserved for pKVM for now */
+		val[2] = GENMASK((ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS - 64),
+				 (ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER - 64));
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
-- 
2.47.0

