Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A103D33508B
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 09:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763545106; cv=none; b=btm7QuivOADc8jaib+Jt49GPX6oRRTr6bVnNhPEIWhia3exHmchFjp8S6FKp2b6EKl0N5k60xJkzI5EiPaZgqoNPEC0CfRv47RLYmWs4BK4kd5105nBpgxnCIUGDquPmBJVFcevy0Qe2aDDcobJf7Rwl1f9jAdNbB7h6UbT0404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763545106; c=relaxed/simple;
	bh=F5GbJ+oK66AHTo+N38MGPuUCLZSwic9TPhBuWD87HyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/ue0I3prbND4ln+ClBqDT3JhSNZ0tt8M3GhGDA12glbp7KADjNkUcQ8ciPtapDGauZwQBp3ciiEP6Z9UBG73yMzmHuDk9wZwJjb3UmGtVCjxSl5eub/V0/YYIM9iMhzPBltp2tX/5h/mQAIDixSL/9fkazFUYdPrP/wh4X3JcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIX/qtnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIX/qtnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73C5C16AAE;
	Wed, 19 Nov 2025 09:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763545106;
	bh=F5GbJ+oK66AHTo+N38MGPuUCLZSwic9TPhBuWD87HyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIX/qtnw/ORNhXdHwNh4s47ytIZ7wzm4SghLF1/a7MXyBs9Qysm1bRrYATfofYAer
	 4PC9OKJ+eIsB+1GWsembyxSCnNeoGl5WwRbmuduSE5dpwOe59Snbcuq0obYXIDiakw
	 lc5DY9ukPRTQ4k9LVYSuenNCzfLmysyZzOMBWE/iQNbJR6jtXTe6FONerli2qS96xY
	 orKxNLUqS+m2lfcf96koeFgRNTidHI6toawUHD8sGoHXBl2qm6oQZbTj428qIVUxjG
	 gs429ImkgFbPkI6R3S3H+P26uXG9Scph2ZMATAi3xtDLRiqolvd+AxMhDmjrzRMxHJ
	 UKiMDAKUhMmsQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 2/2] KVM: arm64: Use kvzalloc() for kvm struct allocation
Date: Wed, 19 Nov 2025 01:38:22 -0800
Message-ID: <20251119093822.2513142-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251119093822.2513142-1-oupton@kernel.org>
References: <20251119093822.2513142-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Physically-allocated KVM structs aren't necessary when in VHE mode as
there's no need to share with the hyp's address space. Of course, there
can still be a performance benefit from physical allocations.

Use kvzalloc() for opportunistic physical allocations.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e791fa52f874..ecbe2c8dc00c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -440,7 +440,7 @@ struct kvm *kvm_arch_alloc_vm(void)
 	if (!has_vhe())
 		return kzalloc(sz, GFP_KERNEL_ACCOUNT);
 
-	return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	return kvzalloc(sz, GFP_KERNEL_ACCOUNT);
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
-- 
2.47.3

