Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5308621E097
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712196; cv=none; b=NOHYC+5TIHZOXZIUEp46b2rO9lPg8c7mApBO9+Iuw9pcSeBnb414zelMWTr79VcIuWaDyepnVeg8Nf0ysTEJFYW/zMDKWE/kQ5aP2J0y+rypjC4ISvThGAg5KXWgjIUPfS8vBSvfKSzutCVsJVTI3FQqLoGfNXdklNjZe3kGzKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712196; c=relaxed/simple;
	bh=g2OslV2BQNQWuhxxD5NU+Ia0fQCHU6gHIZf+rxuPPQE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vhc3KbKzDd1HE3hLYTL1TGAHYCLBAc0Owg2BXTBnEuRDPNHdW003YtmvEt1TPyFP7hl2HJA4XIT2IKL7kXGS/WS9GiCtxEGW/fCSIF89NdgfnNP6w/HD9irc8uRD6Vln/Q+SGgdGPhbgk2ekQefl1b5tsIQnAIok2igN1PQvaJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ENAUSqtr; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ENAUSqtr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lGoWG+s9LxEqQfS9yBWhAIJDdkyHgHH0caA5SPx6MTg=;
	b=ENAUSqtrDQJDlvp6N+ujMsLSq+FRn3MEt+htBjH6KCN8sQTSAN5BSE6CJRl91TaXivUalL
	9hWLybi1JdB76lNFF4p5L6Z4MJ8d/IMQaa3FscCLca51dds0hYTwww+XK5CWQEibS7O108
	jPbCfnro/RFtTZzq5FGVW6VmmY10NS4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 03/11] KVM: arm64: nv: Expose FEAT_DF2 to NV-enabled VMs
Date: Fri, 12 Sep 2025 14:22:50 -0700
Message-Id: <20250912212258.407350-4-oliver.upton@linux.dev>
In-Reply-To: <20250912212258.407350-1-oliver.upton@linux.dev>
References: <20250912212258.407350-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The supporting infrastructure in KVM's abort injection code was merged a
while ago, but the author (me!) forgot to relax the NV limitation when
FEAT_DF2 got exposed to non-NV VMs. Fix it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4044dc66fa39..5e46e95e2684 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1463,7 +1463,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 	case SYS_ID_AA64PFR1_EL1:
 		/* Only support BTI, SSBS, CSV2_frac */
 		val &= ~(ID_AA64PFR1_EL1_PFAR		|
-			 ID_AA64PFR1_EL1_DF2		|
 			 ID_AA64PFR1_EL1_MTEX		|
 			 ID_AA64PFR1_EL1_THE		|
 			 ID_AA64PFR1_EL1_GCS		|
-- 
2.39.5

