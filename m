Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32983354ACF
	for <kvmarm@lists.linux.dev>; Fri, 30 Jan 2026 09:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769766291; cv=none; b=Z8469Qz6Wk32bkfteIEhyLI/2ynutFuoCSEFPWGNWB5vSoSHtvEFGgPRaLGlMOkWd3ny1blVlo2iR2Tt+UP44Vfedaalfy2XxL2Gxqj7MnKJg1J8/+KflTWZRwcDHb5BTtDAVziXlWghC13d1bEm7SvEi8NJmEVdbAiiUXdujLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769766291; c=relaxed/simple;
	bh=V4bE5zvyrlI1EnYf1stjxhW7hoiZwshP7jSBwzvIMgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UAkMWAwKu0fBQibNSM4n9+npLXMHC9gESZrPYicjFFJvHisDxPXI5kzRNlqX+fxxm+JsjNdeILC5ofqLO7CeWoik7oKgqBj4Ix7Jf7dHhrb/N9VOuzH+XMhgGSNsxhdz5d/QZcMeN/esYbrifpBftvxyJolEjbL9mXlyX3i6MIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kyht1wy3; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kyht1wy3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769766287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=f5EUBZ9dcsQ8t0gdihtzP5GMIMef8v977R/zbeHqjRo=;
	b=kyht1wy3aohi0RqXxWer36V24GEjuIn6TKENl97zz08XDESg9lmeO7shOI1qwBXO5f0YPi
	2jA0pVm3eLaL5CeK+6dDdZaMjd9GDT9368v6Zv1K/nA/icc8G79GfjVtU0qzG4cmBsz2k3
	02fLaAYYcPEqbir9aB9tVKQ3ZIPhboU=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	zenghui.yu@linux.dev,
	wanghaibin.wang@huawei.com
Subject: [PATCH] KVM: arm64: nv: Add trap config for DBGWCR<15>_EL1
Date: Fri, 30 Jan 2026 17:44:35 +0800
Message-Id: <20260130094435.39942-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

Seems that it was missed when MDCR_EL2 was first added to the trap
forwarding infrastructure. Add it back.

Fixes: cb31632c4452 ("KVM: arm64: nv: Add trap forwarding for MDCR_EL2")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 834f13fb1fb7..34a5460adaf0 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1166,6 +1166,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_DBGWCRn_EL1(12),	CGT_MDCR_TDE_TDA),
 	SR_TRAP(SYS_DBGWCRn_EL1(13),	CGT_MDCR_TDE_TDA),
 	SR_TRAP(SYS_DBGWCRn_EL1(14),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(15),	CGT_MDCR_TDE_TDA),
 	SR_TRAP(SYS_DBGCLAIMSET_EL1,	CGT_MDCR_TDE_TDA),
 	SR_TRAP(SYS_DBGCLAIMCLR_EL1,	CGT_MDCR_TDE_TDA),
 	SR_TRAP(SYS_DBGAUTHSTATUS_EL1,	CGT_MDCR_TDE_TDA),
-- 
2.34.1

