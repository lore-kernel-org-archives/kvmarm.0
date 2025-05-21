Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A20B4B1E7B
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747825520; cv=none; b=GTFTje6XlDadi6MQpkXDbjetMUwAtVwTbs88igA3SiuSOE/vcx3cV13N5hbQ8fnGUtYys8umee6QqQblzJFbcD5m0rYbE1rYF9V+dyono1v5qHlFi1ChY7jZ9/3r0fOJfWVUa97JqhwrcjeQ8PllqSz9RApT4bxmKZ7jScgoAcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747825520; c=relaxed/simple;
	bh=42u/zmytvqbcX3xApId5MoKd0PTEG2SAmeYvKU2zQd4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A1lLdgKxkXo8oWAJ/r0bUVnchd77bwBNXbruMH3GTNNr7aAPwsQq/qh+4lkRQnFw/aOf4X611V7F55PFpKlavN3HSi6n+ixi4NC6aqLeVc1qxnd7STFbJUUY5cNEtKTpyXfqVxQzpNzKMqIYD7yPfGYWPw1VN1yLy+bJsCihKc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AqN4FMLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AqN4FMLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E54C4CEE4;
	Wed, 21 May 2025 11:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747825520;
	bh=42u/zmytvqbcX3xApId5MoKd0PTEG2SAmeYvKU2zQd4=;
	h=From:To:Cc:Subject:Date:From;
	b=AqN4FMLB6wqzCn4JgVF9n7vZaP+jMQ81756k1kI9Fu6P03YWo/fNGAGaqnTfLmqX7
	 xCqnx5ZJLDb7AK5RW31f4rstkckzyXVgdm7aKrJbtK0wj5tTFQo3oweG6cAVPCtrVv
	 d3CeRIM2BP9Vv8bKCGugkK3TsB9UAxRvvkj8/PbHnaFRw+gs8kwTKDKAWfb4T+GYyO
	 VkromKhPXv5Qf/INpi5E5r5SQHQZYJWQG/1F8FxLSzJkwB73QoJTegrhmE0Wexf5H9
	 7O2a6ya/+TvH1qePD1vLeKdk8J384+TO4iYQ5fOJovVekjTGyJUH6b1huidRezsaGn
	 Bs7g2ND+Rnzzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uHhG9-00GuFW-OT;
	Wed, 21 May 2025 12:05:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: nv: Handle TLBI S1E2 for VNCR invalidation with mmu_lock held
Date: Wed, 21 May 2025 12:05:14 +0100
Message-Id: <20250521110514.66305-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Calling invalidate_vncr_va() without the mmu_lock held for write
is a bad idea, and lockdep tells you about that.

Fixes: 4ffa72ad8f37e ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 56b732003caa7..2381663d2ee98 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1044,6 +1044,8 @@ void kvm_handle_s1e2_tlbi(struct kvm_vcpu *vcpu, u32 inst, u64 val)
 	struct s1e2_tlbi_scope scope = {};
 
 	compute_s1_tlbi_range(vcpu, inst, val, &scope);
+
+	guard(write_lock)(&vcpu->kvm->mmu_lock);
 	invalidate_vncr_va(vcpu->kvm, &scope);
 }
 
-- 
2.39.2

