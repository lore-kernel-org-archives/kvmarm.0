Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4312E6131
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995562; cv=none; b=k2jATzgbjmsfYiNMkFcKsOzMc8dtS56We0lKzPL1xH7z9bBleJwQM09cWwfmoWs0j8Hsaery6BwdMuXRoSLH5BjhMekZeWbiw7DcoOlrRMZIjrYx0hzbDtQx/tmthFuo+UJIb1oF6GV/XLPG84S6NgZ1MJEtuWCdeAc6QbCEfC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995562; c=relaxed/simple;
	bh=AVQb9HmPNf8oxRRHljirf4fJSoie2xDvLf8ivblSELE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ArmW4OJJb2+jV8zePvNCa6twoMAvGOTaZarCWQ1q9Krqc1FYZVwbrXPHh79wmQcRmFOMbY6/ZF46zZcNWDSWtVuyTYZDnpk9zYELmz+Oxp/g/SZI6uSVhWFjFgmKRuhReX4FAw6snCMmrP8nXXgcJe4Kx0s6kbRiJZ6ByuiMx80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S5XfMnM/; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S5XfMnM/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PO3ov9tymt6PQuITttjJ82Dm9TKT95zW5gYEVyoUPoo=;
	b=S5XfMnM/++5vAWL5QUBibffBTbwIs8mAROqcemMRZ1kzdsVva1JHp32eb7E9ww0eltTyU4
	RFOHXPIqyPHD9FdY+fUdutEMVP3e7gchtvyL6RlV++oUd3BdNxchd+ZKiYw+tf37sT5xD/
	cIcrt9AyfSM7Hlpwd8N53zPivUF96qA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 09/27] KVM: arm64: nv: Advertise support for FEAT_RAS
Date: Tue,  8 Jul 2025 10:25:14 -0700
Message-Id: <20250708172532.1699409-10-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that the missing bits for vSError injection/deferral have been added
we can merrily claim support for FEAT_RAS.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4218172ed1a4..c7063f670187 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1424,12 +1424,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64PFR0_EL1:
-		/* No RME, AMU, MPAM, S-EL2, or RAS */
+		/* No RME, AMU, MPAM, or S-EL2 */
 		val &= ~(ID_AA64PFR0_EL1_RME	|
 			 ID_AA64PFR0_EL1_AMU	|
 			 ID_AA64PFR0_EL1_MPAM	|
 			 ID_AA64PFR0_EL1_SEL2	|
-			 ID_AA64PFR0_EL1_RAS	|
 			 ID_AA64PFR0_EL1_EL3	|
 			 ID_AA64PFR0_EL1_EL2	|
 			 ID_AA64PFR0_EL1_EL1	|
-- 
2.39.5

