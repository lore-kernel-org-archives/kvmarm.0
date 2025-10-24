Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6600308F0B
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 09:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296925; cv=none; b=WxsQy2YPfCsQLn79wd1BAP1PnZXsEuoq4aS3EWM7ujMrwmPxK7nJRYHE447D3uuoXbqJp+FphViIayDsLzI+SGUNttDz2eW7pPWyvUNMBkSN2639S1r26ZuNtJWxclEdHYvzUPC6QhvpA6UQg4fGGA/4o4+rYfZcQosLirgD85A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296925; c=relaxed/simple;
	bh=UBtcusgJ7z2jq89Oy4rqEYHCbw3bb8BXY289JNkl9eE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iY2Viqx4nw+t6d85OKjCyqvBPnIP6Ed7Z9p53QeB/Kes7ErOOvbanmaq+/WCIDvvAslo8m7F76h2+aaHppyfOv/9qAX0CyEm44G7A/j7p9+EV79nulHCzvYbBtuLWU2szDIusUV7a2m/s2fr3AV4PPq9zuvFviGpExR7dgkrW9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4ctH4v0sfVzJscH;
	Fri, 24 Oct 2025 17:03:43 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8BA4518048E;
	Fri, 24 Oct 2025 17:08:35 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 24 Oct 2025 17:08:35 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 24 Oct
 2025 17:08:34 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>
Subject: [PATCH v6 4/7] arm64: Provide basic EL2 setup for FEAT_{LS64, LS64_V} usage at EL0/1
Date: Fri, 24 Oct 2025 17:08:16 +0800
Message-ID: <20251024090819.4097819-5-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
References: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200004.china.huawei.com (7.202.195.237)

From: Yicong Yang <yangyicong@hisilicon.com>

Instructions introduced by FEAT_{LS64, LS64_V} is controlled by
HCRX_EL2.{EnALS, EnASR}. Configure all of these to allow usage
at EL0/1.

This doesn't mean these instructions are always available in
EL0/1 if provided. The hypervisor still have the control at
runtime.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
---
 arch/arm64/include/asm/el2_setup.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 99a7c0235e6d..9dbd0da8eee8 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -83,9 +83,19 @@
         /* Enable GCS if supported */
 	mrs_s	x1, SYS_ID_AA64PFR1_EL1
 	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
-	cbz	x1, .Lset_hcrx_\@
+	cbz	x1, .Lskip_gcs_hcrx_\@
 	orr	x0, x0, #HCRX_EL2_GCSEn
 
+.Lskip_gcs_hcrx_\@:
+	/* Enable LS64, LS64_V if supported */
+	mrs_s	x1, SYS_ID_AA64ISAR1_EL1
+	ubfx	x1, x1, #ID_AA64ISAR1_EL1_LS64_SHIFT, #4
+	cbz	x1, .Lset_hcrx_\@
+	orr	x0, x0, #HCRX_EL2_EnALS
+	cmp	x1, #ID_AA64ISAR1_EL1_LS64_LS64_V
+	b.lt	.Lset_hcrx_\@
+	orr	x0, x0, #HCRX_EL2_EnASR
+
 .Lset_hcrx_\@:
 	msr_s	SYS_HCRX_EL2, x0
 .Lskip_hcrx_\@:
-- 
2.33.0

