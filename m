Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D50217709
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115021; cv=none; b=DheFKxL5JqoH85nxvSSoAcW/YLJW54+SfFWdEBjLeEzpKQ1H6xvQU3eEGIYAONLizaZoE4w3uqDOdwMIA6pC8hIkhllu+OfUuCSXIaHGKFPhqbw+si2An6nhb+3QZYEcLKGvn/hmYQw4xmpMPNxf4LxiWOYLGI6CRvShEq3Zca0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115021; c=relaxed/simple;
	bh=Zuk9wHx+2NXTfbreEBBHNHX2ywKgmbAI6rQjK7DP9Qc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cPeJGD414u+CClGOw2CMCF9oCYtm83ZA7MHHemJUhUXuvdA5bwyYfHMpBa8qbuDkww+JxCY+GaQiyP/rh9bZd3MC5AbSkdpxQjbL6mjtrMOk59rCdrAReTePq8I396ww8TSryQ/zcnJnoxhx9IO9iJqQDFdH5KS4wQQ9wg7W0pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tgBk3yf9; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tgBk3yf9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TNGVLWPt8OOGwhyuC7N5e7Zf3gBMwbkGBru66OsuXJk=;
	b=tgBk3yf9uCDGloI6BvPapd/WniyZhoXKhXa5yWBCWgK4Zi2kVCgq0ndjHjzkEbLYT/t+zd
	egmSApkiCi9QhVXv/vnPE9WPKtAjHs8u2yYlz+vrykuSvVO1V2vUnIVAEgFxtOMgyigscn
	n/MlP3Fb5T8rsNUQMFr7GGRyM7O8d8M=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 09/27] KVM: arm64: nv: Advertise support for FEAT_RAS
Date: Mon, 16 Jun 2025 16:02:50 -0700
Message-Id: <20250616230308.1192565-10-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
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

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 54de7a712251..4c1458cc61be 100644
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

