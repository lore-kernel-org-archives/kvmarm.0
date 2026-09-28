Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE304E5321
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609142; cv=none; b=XSHVGk6dsHNE1KqXQ23ZceJ1g2ed0uHVkYbaFjD5HSSxb5OoVw3GpSe1iwvyXWzK94G2Vd9tbio7syOtQL6dyAHQY+atr3uXD6beCAC28JevFrmHGfRFskzDyrEy/0E/H6VyXrWHewU4acXTx/F5cvJiuRv3gSUcER52NXZaClA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609142; c=relaxed/simple;
	bh=UsrrMKeoU6FyB7ktPMuLLTHGrlKvgJcUMP9CZWK2MkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O7pjzzAdh44YKIcAOuqfO78eAnah1LesUFU0rfTctxmhLZo6JNqYHrYOqHqlhjVITgUwd8xuKjrk1wW9j+77XAoomNaeV2GeTKihQ7N8I0Nfuzxi01IvXU/0CwWDE+TYNs3fpqY9DCklP6Kni3tZIcb0kf58T8BG1I0ZYIYn0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nYt5ziIv; arc=none smtp.client-ip=95.215.58.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nYt5ziIv"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=UsrrMKeoU6FyB7ktPMuLLTHGrlKvgJcUMP9CZWK2MkQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790609139; v=1; x=1791213939;
 b=nYt5ziIv/3E20y3DRnAM19W1Yns0ZSvwjweI4mhJwzoz+yuzHfSfNw8FeqnCdt9hupruQpSh
 TTWfbJgMJfP9J5F/cI8RLuIs6TKRdCQH3lKxCe9zib9GpYBYM2xRUGJRjdgkZLkWyHbrpGDzaED
 vXmxoA0NZNdmOqXFkaIxTd0A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1db0060865db2ffe;
	Mon, 28 Sep 2026 15:25:17 +0000
X-Mizu-Trace-ID: 1db0060865db2ffe
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 02/10] KVM: arm64: nv: Don't WARN on an invalid VTCR_EL2
Date: Mon, 28 Sep 2026 16:24:59 +0100
Message-Id: <20260928152507.2116110-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260928152507.2116110-1-fuad.tabba@linux.dev>
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before walking an L1 guest's stage-2 tables, KVM checks the starting
level in VTCR_EL2.SL0 and the IPA size from T0SZ against the granule
and PA size, and sets a stage-2 level 0 Translation fault when either
is invalid. The check also WARNs, so an L1 guest that programs an
invalid VTCR_EL2 triggers the WARN on every walk.

Drop the WARN.

Fixes: 61e30b9eef7ff ("KVM: arm64: nv: Implement nested Stage-2 page table walk logic")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 3c4fc566eafc6..98c1f8c193319 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -279,7 +279,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 		return -EFAULT;
 
 	ret = check_base_s2_limits(vcpu, wi, level, input_size, stride);
-	if (WARN_ON(ret)) {
+	if (ret) {
 		out->esr = compute_fsc(0, ESR_ELx_FSC_FAULT);
 		return ret;
 	}
-- 
2.39.5

