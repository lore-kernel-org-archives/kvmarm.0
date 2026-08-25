Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79DA3E9C19
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787648399; cv=none; b=tUu9NAzDcs6APON9kkXtx25zL8dtlTwGhqYa3JyE+KyxJKu5RgKTqLrpmfr32XrKYClfvOnXTgDvmExb5MD7VEVO88ML55z9ctpTcigt6FjpeSwyCtoR/Wqp1LICrBpvZF5h1yEu7LzhoFqqEzjzG8FBP5zg7RN/B68vR7OF0mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787648399; c=relaxed/simple;
	bh=MSUuQABVVUc6gwSvoRq9rt/EUbCdwq4ILWrmprQ0Dzo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EntieHTNLM4QQU9QyRkclg3MDm9DXZasiI2BOpfYpfGfdivoOgC0Z22cVYcpbkrnQLPNMCOKSwLZ7WA47XXvkQm5ZzxuC07VdGV2MHWIZ4F1+w+THSsAfQlBswNLJkS4Go21/GYA0oxTCWDQVQhIUd+aZM393ZEVkSuwEvYPvns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jgkIIzZ0; arc=none smtp.client-ip=91.218.175.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jgkIIzZ0"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=MSUuQABVVUc6gwSvoRq9rt/EUbCdwq4ILWrmprQ0Dzo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787648395; v=1; x=1788253195;
 b=jgkIIzZ0XypmlQHdcS+BIeouet3Ll7e9QuqukDEJOJq/pV4OcSk1HB7U9TR6XMSqoAeyt7nk
 ljke+jZ8poO13AaGJBl7+h/sIxhjozVGOzW7X5938qmGD0UBJnrmYtC9vs6phx0jFyCFTyLFNC/
 0jiwdU3NqPP5M6o5iqToBe+I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id c708cb14ba227278;
	Tue, 25 Aug 2026 08:59:55 +0000
X-Mizu-Trace-ID: c708cb14ba227278
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Stefan Teodorescu <fane@google.com>,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: arm64: Key unpin_host_sve_state() on the state it unpins
Date: Tue, 25 Aug 2026 09:59:47 +0100
Message-Id: <20260825085948.1674721-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260825085948.1674721-1-fuad.tabba@linux.dev>
References: <20260825085948.1674721-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

unpin_host_sve_state() gates on the VM's SVE feature bit, but what it
unpins is the state pkvm_vcpu_init_sve() pinned. A vCPU that completed
init has sve_state set exactly when that bit is set, so the two agree.
Gate on sve_state, which is what is being unpinned.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 73e6ee059eebb..1d8cc984fb88c 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -398,10 +398,10 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	void *sve_state;
 
-	if (!vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SVE))
+	sve_state = hyp_vcpu->vcpu.arch.sve_state;
+	if (!sve_state)
 		return;
 
-	sve_state = hyp_vcpu->vcpu.arch.sve_state;
 	hyp_unpin_shared_mem(sve_state,
 			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
 }
-- 
2.39.5

