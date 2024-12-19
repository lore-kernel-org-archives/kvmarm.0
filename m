Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDAE1C4A12
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648134; cv=none; b=F0zarSQMeGngT5rqDij74H9NGD3ix99F92zxbMdtQFf2aQ4aKnXudSmst9dxZZ1VZsxgj939LOb+jD5aIX7MT0dwMOor/PUnzVbEO7WR1SRymcrn0z/flMkXy6z6E8W+TNq1IMZ0UnedaCDVnQCQZublVcZ2Xuf/lFa/rx50PDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648134; c=relaxed/simple;
	bh=u+FRuBh6oPcRd39RB1X3YXdFi0sGmA1o8OQeQzH50ys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c0Q0oBfXJ9wtHayMHqJRoek+kH4E7DLUlJDyF8G714TwWONedDKw+4nKuDPZKUzIPQWqVBtzyGptC7T62ScLLN0zW65pKPne6An5HvjADUfF3muUSzWesyhA/dIRyX7sKlT0cPbtxGCOxKSiJI6O4ejPxZAUNiXkfiPcmPivAqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w8ItU0uU; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w8ItU0uU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=woV8GEMyI9QZA42MEPVw34bmPVe6iAasJEohDa9INno=;
	b=w8ItU0uUeaKSCgei4hZqRUJrtT4mf1LYwvGalDzmSbEEn6ulSxneKCMcDAU/LyaW1BiFiV
	ZcqvrobxM8wTKq7ym4gSult36lzKmM1UDCdy828vLkpEIzBahhg7qfWpbEUUpLUyYsvAgH
	nubxhwP+EvlUhVupLhQPdaqYlfsNnEA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 19/19] KVM: arm64: Promote guest ownership for DBGxVR/DBGxCR reads
Date: Thu, 19 Dec 2024 14:41:16 -0800
Message-Id: <20241219224116.3941496-20-oliver.upton@linux.dev>
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Only yielding control of the debug registers for writes is a bit silly,
unless of course you're a fan of pointless traps. Give control of the
debug registers to the guest upon the first access, regardless of
direction.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d9c7911ec58a..aac79e34cd50 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -643,8 +643,6 @@ static void reg_to_dbg(struct kvm_vcpu *vcpu,
 	val &= ~mask;
 	val |= (p->regval & (mask >> shift)) << shift;
 	*dbg_reg = val;
-
-	kvm_debug_set_guest_ownership(vcpu);
 }
 
 static void dbg_to_reg(struct kvm_vcpu *vcpu,
@@ -690,6 +688,7 @@ static bool trap_dbg_wb_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	else
 		dbg_to_reg(vcpu, p, rd, reg);
 
+	kvm_debug_set_guest_ownership(vcpu);
 	return true;
 }
 
-- 
2.39.5

