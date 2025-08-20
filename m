Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF251A9FB5;
	Wed, 20 Aug 2025 01:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755652212; cv=none; b=CFHrHitQEK4HRweCLb877eWbrLuy6DqHDoy8GG9YBI9sO3ru0ahb6LBkGJgB6B5bwnhveloa/NEs7oq9Lev4YLyP6aWlSIfaOI5zQf2RHJMT0Ewt+7x0AhnO+9/GH4oo+1XGqg7OZNKJMnw62k/XeIDgaE8+mp4UnMkvC2Id2zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755652212; c=relaxed/simple;
	bh=91Dm3OaQoci0blezXj2osVi2Hwa4r5Z+TXwDN3DncVc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EchFlXwdjyducO94N4sQ2uAmcRVZ4ux0Hl0/Fvnk1F5glbl1ZQ2ZfO6TOu3rGhfB5wbY2LkdTSuje1bDL76FNMk9L7ADyMn3vZ3BK0mf7cnFUMJXgkpxkhMyEce+DELkjMsQqPBX6jvHHkk1+0+fI/nz0e3W58da0HSotxNxaOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+CJel44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+CJel44"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DD26C2BCAF;
	Wed, 20 Aug 2025 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755652212;
	bh=91Dm3OaQoci0blezXj2osVi2Hwa4r5Z+TXwDN3DncVc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=F+CJel44zHKB1+Jj5dIcJyp8aaAvojvp7l8Qoi050VOasAModbJqaCPMAn/vYCF/A
	 A5FXWV76ybQvAez/8dXlAoWhn0jDpRN0R48lQMOyFHShP/WiQMKUhsXxYn00km9jvc
	 Um+FZqwgW3ZoSDEcPOBu98Y2h9WzPTSN9Ecjy5z6Z57A6UjT0sO/gcI50Wzaxdds0j
	 qApjVpQJSmLJnpxJ6SL4PHVpcUlKEakakvPU+vmqGe4/SH/QOKsQVWRgk7jhe81VyZ
	 Kx2+lp27ar+4d116moMbXn+Qn6fr1ETX3LbVTfy836SH5Yy7YckH+zdSJhTNhGThTt
	 alGo5yGvy3nug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9486DCA0EF8;
	Wed, 20 Aug 2025 01:10:12 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Wed, 20 Aug 2025 01:10:10 +0000
Subject: [PATCH v11 6/6] KVM: arm64: Bump the supported version of FF-A to
 1.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250820-virtio-msg-ffa-v11-6-497ef43550a3@google.com>
References: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
In-Reply-To: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com, 
 arve@android.com, ayrton@google.com, qperret@google.com, 
 sebastianene@google.com, qwandor@google.com, 
 Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755652211; l=1485;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=sIp58KQQ8EflePxKp11J+AU7g2DrDyk3wz9EOd9cxBI=;
 b=lj+3dEbL13Pvy/tWvzCZlmQ7YHuFzNRWcXR2BqWeAoOCSrdWmNgd6zvx3JAb+58XElapFUzLE
 gZ5HXR0KqnhBRsLBMVQVRsH8Rsc+edAI5GbW5Hz9O9TkFjLcr3vDva0
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

FF-A version 1.2 introduces the DIRECT_REQ2 ABI. Bump the FF-A version
preferred by the hypervisor to enable implementation of the 1.2-only
FFA_MSG_SEND_DIRECT_REQ2 and FFA_MSG_SEND_RESP2 messaging interfaces.

Co-developed-by: Ayrton Munoz <ayrton@google.com>
Signed-off-by: Ayrton Munoz <ayrton@google.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index a8ec1a94f3f8a86551895f4606918246c4ac1f39..4e16f9b96f637599873b16148c6e40cf1210aa3e 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -936,7 +936,7 @@ int hyp_ffa_init(void *pages)
 
 	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_VERSION,
-		.a1 = FFA_VERSION_1_1,
+		.a1 = FFA_VERSION_1_2,
 	}, &res);
 	if (res.a0 == FFA_RET_NOT_SUPPORTED)
 		return 0;
@@ -957,10 +957,10 @@ int hyp_ffa_init(void *pages)
 	if (FFA_MAJOR_VERSION(res.a0) != 1)
 		return -EOPNOTSUPP;
 
-	if (FFA_MINOR_VERSION(res.a0) < FFA_MINOR_VERSION(FFA_VERSION_1_1))
+	if (FFA_MINOR_VERSION(res.a0) < FFA_MINOR_VERSION(FFA_VERSION_1_2))
 		hyp_ffa_version = res.a0;
 	else
-		hyp_ffa_version = FFA_VERSION_1_1;
+		hyp_ffa_version = FFA_VERSION_1_2;
 
 	tx = pages;
 	pages += KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;

-- 
2.51.0.rc1.167.g924127e9c0-goog


