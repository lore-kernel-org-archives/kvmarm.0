Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D5336CDE0
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757082107; cv=none; b=p9ybfNzSW+kTKiCvd1r3omjVvFPAPvuXxZ+Sm29UyR0TeM40aQq5rAghRwu08C46xzfSGjs/SPk8DMnEyH19EYjeIktT28kWeKh6NnaHgJ6f49t9RR0jgb0S5xU6XKPM4HD82SECRUgTzJK+MBywzznYSBI2qneHe1N6+5oZT0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757082107; c=relaxed/simple;
	bh=Rag0UCxSkIr4c0/ZPHBPldt69736y5FGeaU3KrN1hNo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DKsAY7nE6VmMYWYi17FMod7gU7SypXV68vwjNTUL+rWCK1j7SCsrK4P+enDHUrHKQgdKG2CUPdToVD8F7ilKCdkmanBgp5VYTGJyiMnJJAuozBXfogs5/ezQO2mxYyaR0186q0IuHa0XsCmM740sqzD4RqnVZAF4o9LobJMZyHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dVrfMrWa; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dVrfMrWa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757082103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bk9b6r7aoaDV40iV5fZhYOow3N4L/PXmOOYdf61n0CQ=;
	b=dVrfMrWaDKXzhQZwaBLIvpVrQSVACSf4bAbeWxMGNFSleVo3Gq+GrklUKC13+xtdoVNbf7
	kjGoBJ0cdLzLH9V10VJ+YaqE5c3gFFCfyidqzZu1yC9/rOl04DWJX6k/WpopCYN8kFDd19
	WLmDeYR4Z23yFYUuO6LZKOAyrOdSqrg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/6] KVM: arm64: vgic: Drop stale comment on IRQ active state
Date: Fri,  5 Sep 2025 03:05:26 -0700
Message-Id: <20250905100531.282980-2-oliver.upton@linux.dev>
In-Reply-To: <20250905100531.282980-1-oliver.upton@linux.dev>
References: <20250905100531.282980-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

While LPIs lack an active state, KVM unconditionally folds the active
state from the LR into the vgic_irq struct meaning this field cannot be
'creatively' reused for something else.

Drop the misleading comment to reflect this.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 include/kvm/arm_vgic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 404883c7af6e..9f8a116925ca 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -139,7 +139,7 @@ struct vgic_irq {
 	bool pending_latch;		/* The pending latch state used to calculate
 					 * the pending state for both level
 					 * and edge triggered IRQs. */
-	bool active;			/* not used for LPIs */
+	bool active;
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
 	struct kref refcount;		/* Used for LPIs */
-- 
2.39.5

