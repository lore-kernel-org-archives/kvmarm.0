Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708DF44D6B0
	for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 10:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768990603; cv=none; b=KxNbLcFmmJHEXpOH0ayQzcKrs2huA62ygrnHZhvgEY5eL7a6SJAHNdnhmUjmc+jJB96W7jx2gan7Y70VzwzFC7Yf8NhPSipbA91KMBAbVfJm5sGqV6ZINTwHp+p4Q5iPSXwxv+QkadTkY1Y9xa3CK9X4T37g4BVZ7xvau1BL7AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768990603; c=relaxed/simple;
	bh=DBJZZRs/h/af7KxNl8l2fGPhBoXEKSi8bZWRgDolhJE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fbu+47o0+VC2VWyujtT4B2o+/tHF3GVeEhDVNUT4KNQKpTrSDrdQazOxG9+pN7sjpeLMyPog8qcTbl47FoINWdthm4GpOlZaCxbEP+V8B1A/96Pzu5BHts8idM7gZOEPBgTnygoi8SlZ7R0QCJSim8obkQtdTxy/XTiBdIrwEOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lwZxIFjd; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lwZxIFjd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768990599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nJvSFAuR3Pk/7986jCrxf9amO+0VQYQ+3sUulNfFyU4=;
	b=lwZxIFjdRpZOja2XmzGbHhHRf+eXBIHyxXHA1bs0AkCJbgGHA99lfd1FGFtkFExDabAK8z
	5lAdIBzM77+Up6idcEwd58Gw3iFyNLOnRkmWJZTjZPsPlBkvOjK73jfVWrY6JMxHuXJyE1
	KK5mklWJU1Gki5ziL+WnZaFiVeKZenU=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	zenghui.yu@linux.dev,
	wanghaibin.wang@huawei.com
Subject: [PATCH] KVM: arm64: nv: Return correct RES0 bits for FGT registers
Date: Wed, 21 Jan 2026 18:16:31 +0800
Message-Id: <20260121101631.41037-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

We had extended the sysreg masking infrastructure to more general
registers, instead of restricting it to VNCR-backed registers, since
commit a0162020095e ("KVM: arm64: Extend masking facility to arbitrary
registers"). Fix kvm_get_sysreg_res0() to reflect this fact.

Note that we're sure that we only deal with FGT registers in
kvm_get_sysreg_res0(), the

	if (sr < __VNCR_START__)

is actually a never false, which should probably be removed later.

Fixes: 69c19e047dfe ("KVM: arm64: Add TCR2_EL2 to the sysreg arrays")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 834f13fb1fb7..2d04fb56746e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2428,7 +2428,7 @@ static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
 
 	masks = kvm->arch.sysreg_masks;
 
-	return masks->mask[sr - __VNCR_START__].res0;
+	return masks->mask[sr - __SANITISED_REG_START__].res0;
 }
 
 static bool check_fgt_bit(struct kvm_vcpu *vcpu, enum vcpu_sysreg sr,
-- 
2.34.1

