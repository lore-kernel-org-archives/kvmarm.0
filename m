Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F6D329C6D
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 17:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040953; cv=none; b=lJAAvsWA3rz/sq2s/pMNfVc/jHnWIr78C/GY9tud11F24ElXvECmQ4lIxSSfrQfhVwJ8vGGeMutJed/6ztvYRxgr8A3GvZx4I1ku0X7ea6jtw0J+8pB4E+nkqcCp0caDABXpoCVj3kboqjt2kGzKCo8zM13WDppVz8CQ/dA3yCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040953; c=relaxed/simple;
	bh=czXjp88771QWlZG+w7UUCiqmtBZTI4FibyNYmjwDxz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8cMNdHxAuW+q1VJ+qcUUSrF2NaN6IFUYkJOo/rmn4IX8poIRKO/Y2cOc53Zqizkdro6tx4zGh7mR3YciUAfBddFiy05dZdNZ/ocSquDlLsrHxK1e1VovIs/JlWB8ilIu77TXYKCZ3Pl1+drAdJe8auoUgwxqan8XKtI+xtTgbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SqdKUoSu; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SqdKUoSu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772040950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdQT2vpoiDSisab0IRJ3JiNt86FNe7zWZY8TG/Rk8ck=;
	b=SqdKUoSu4/OSRX9Yqdh+ua06wG8G+zR9/XxQNlsYiq+hbs3Ngp6R3EgJzqMldqReO4dGn7
	A2tp0zh/C3nhlsAJ8GyDVLBg9p3zfzjDi9SwSomrEB6zn1wC5kZlhNxlX1d5yvw2c8lmiT
	7BsiTHXeTk3+I+qQSk2ypxcxUW7EMSg=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: nv: Inject a SEA if failed to read the descriptor
Date: Thu, 26 Feb 2026 01:35:15 +0800
Message-ID: <20260225173515.20490-4-zenghui.yu@linux.dev>
In-Reply-To: <20260225173515.20490-1-zenghui.yu@linux.dev>
References: <20260225173515.20490-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

Failure to read the descriptor (because it is outside of a memslot) should
result in a SEA being injected in the guest.

Suggested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/86ms1m9lp3.wl-maz@kernel.org
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/kvm/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index a957542ae3c2..79e6091b738f 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -296,8 +296,10 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 
 		paddr = base_addr | index;
 		ret = read_guest_s2_desc(vcpu, paddr, &desc, wi);
-		if (ret < 0)
+		if (ret < 0) {
+			out->esr = ESR_ELx_FSC_SEA_TTW(level);
 			return ret;
+		}
 
 		new_desc = desc;
 
-- 
2.53.0

