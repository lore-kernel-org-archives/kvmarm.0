Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A393F3C0C
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 07:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772783074; cv=none; b=GEtVDAEXjg+tQxDzQILzTRix3reJMjR8vnDyi5Cx84boUCHwBN0Fbr47XQAHudvpWXdADjgK31rhDmiqGJEAarxXj08bUGYCsPltz7sLFmiGKslsm/AAmZBg9RcQS+YtKCIEOFVvulgV9L931pGRuiBlwetX6QSbLFGHs35PncE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772783074; c=relaxed/simple;
	bh=ceac8py+hJd7v6E7ofHLa9+viDLZkZfsQBoO6g0Y/Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ah6rzD6Bfy+j8FV2qs8WL9MbP0FHYmnxrahYmut357dE2hkYnOQFNKdc3k+CnMNjLDTtqOwsF20QZY44Kot9ES4bzTplOwvgu0YSy4TisCDK1ob1EmYt/W4vxKJwykWXyjBV90MI54UFDrfdBuJUZkRjOllsrqWPhri2oD+sw0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cR8/GLYS; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cR8/GLYS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772783070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kOHlri39bLdqWuALVeplzccv5GnuqSwkfxjMG5OT0y0=;
	b=cR8/GLYSzD7JV1DG0HRAvoa1j7W2pUUuJV8ZLESltAhIu7itJIZ6sScp4vGLa4t9akEL14
	MPUUCHWmn9qUTrwEix9LHyDRKNNWa9yXsyOvikU/BmCSM1SJOBflG54qRE9QX9N7Nq+JHL
	qD4MtitR2lb4sORGMyZT0rsqvpRdW3g=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] KVM: arm64: Remove the redundant ISB in __kvm_at_s1e2()
Date: Fri,  6 Mar 2026 15:44:22 +0800
Message-ID: <20260306074422.47694-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

We already have an ISB in __kvm_at() to make the address translation result
visible to subsequent reads of PAR_EL1. Remove the redundant one right
after it.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/kvm/at.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 6588ea251ed7..c5c5644b1878 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1504,8 +1504,6 @@ int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 			fail = true;
 		}
 
-		isb();
-
 		if (!fail)
 			par = read_sysreg_par();
 
-- 
2.53.0

