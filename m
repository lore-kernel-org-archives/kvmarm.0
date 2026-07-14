Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65A543F8AF;
	Tue, 14 Jul 2026 09:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020613; cv=none; b=A07G+m55RjzlkAY3o39Ntzpr+q8BIXa+7iFjVkVPUgvMy5Y7bCHuhvE08tDQ6U9LYvY118USq/RDDmuARS3Pir/aqtOA22QSF79Vk32LseNo2E5I9Q+25AlYwtlml7Ijd21vpgUsc2U9OyxCbKqJK3A8lMi4eRUkw1wMzma8CQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020613; c=relaxed/simple;
	bh=oS0X5gZHA61g9Vf/fBgFVeC3lnQswW3HRCPJyt8UPk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf5nLeHKGlPAX4o3xkGc0kklyhK5q4PcEufRJcU7hdu9i7ZdqVgDmc5lYdLe0n6RilswNddW0ZFUWtNWXYFYsP2xhD7l1aZXu9lvbHwolXyhcJT0KKzJIJT/p9JHXiopskh4N77rarJLx5KJkj7CsGHZLxrkIntTKsRMmAL2Djo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WI1mTTmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WI1mTTmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA821F0155E;
	Tue, 14 Jul 2026 09:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020611;
	bh=RtXDFqw6p2zDy0q9A7tS+b3EKzCFjxgTHXGegH5U6qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WI1mTTmII4RB1pCV/8PoHcMdbn/pMnKE6jRrqD9HL93Z3/qIdZwfSvi0TFTFW6ejO
	 MYITybGoNs0F+sSR3deNQ9zv2LYnwi4UhsZF8k/46kKJyHScgZOWUIggDQUn8lPICp
	 HlKpu0YcAvu1ltz60tN8qsZN7oUcFqRsxeuk7LEfiJvlPnCBpLVW5ues2oOgSQP+yl
	 aVd0PpT7dvQXwjnNmo2BWkGEEby9emRcfOTx5VCxxRBfd41+pAZl4wBHIJCmMUivog
	 57jnRNsIO6SRVpJwn5y2uJcMgW8la9uffcw14mqgJBYtxzwPlmlOm/sL6LVb7euCrG
	 /nr3/IJ6Q4Yxw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFx-00000004ny1-40MM;
	Tue, 14 Jul 2026 09:16:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 14/28] arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3
Date: Tue, 14 Jul 2026 10:16:27 +0100
Message-ID: <20260714091641.1970822-15-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
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

FEAT_NV3 introduces 4 new HCRX_EL2 control bits. Describe them
in the sysreg file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 31e4ea455a9ce..afe9337851a2e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4548,7 +4548,12 @@ Fields	ZCR_ELx
 EndSysreg
 
 Sysreg	HCRX_EL2	3	4	1	2	2
-Res0	63:27
+Res0	63:35
+Field	34	NVnTTLBOS
+Field	33	NVnTTLBIS
+Field	32	NVnTTLB
+Res0	31:28
+Field	27	NVTGE
 Field	26	SRMASKEn
 Res0	25
 Field	24	PACMEn
-- 
2.47.3

