Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2936D275112;
	Sat,  9 Aug 2025 02:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754706813; cv=none; b=uVvRavfvCflHyNyVG1+eQabPotKBt1TuRK48GN9mLsya8rQmp7fak/MsG807Jj7cI7dU8DiYjfd7REIjG0v4UDyOufc8D3a6wK9+ytqPZCC7o3pKzRYcRnPWRw7Njsp4bdSt0P43vlp+BlaNXhtqo3yJGubhUAn6YwNsAu1Sp+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754706813; c=relaxed/simple;
	bh=6U1E5QmPT8CBgdgVlPTNe/BuFUXewN4X5e1CezxtHPc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pFzxjsqJkHBnCFjN7kx8CD20MM6HWLqki83bwvmfDsEQsDk+yusidp2CPhKzXZNPs6swjuFuRef+fB26Tnlc5lzh4x/KWFhwIeQvmNqNDPOxD2WgzAhfE5eqHTPc1IyYC+4Quol14nn3erlJPhJxXOvEliGBOPdTShRF0xKR1MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=am1H2Ixh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="am1H2Ixh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCB4AC4CEFA;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754706812;
	bh=6U1E5QmPT8CBgdgVlPTNe/BuFUXewN4X5e1CezxtHPc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=am1H2IxhMXdsVjx9qg5AmJL1R1kWnp0jQGAQ1VNsTGnofvUjE6DN+tJKSNbFKN1FW
	 lnFzaGfEF/IwTetPsAC4Jx6VrS2UHwKxOnMwjON4I/XogmB0x2Ah7MQS4hVJ/Cju9s
	 29B/BzY0cuwIR/sGOMRx5SMCrFVQgggrr26I48/yps/7guu+bJ8WOR+35bZ8dSSW8b
	 e5ifN/nIBMpee50QGwS4tlqoEaIqE77GFne2JALyEFmJxs4VPOVEH3tykaTy7WZPU4
	 BCUWLkztunU1TOs0zBMym/7PtEqOoMNhBHW27RKt2z0yiaIIWNo1g08ihiJ3zTZO85
	 xe/axJ+WdGl0Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07E6CA0EC3;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Sat, 09 Aug 2025 02:33:22 +0000
Subject: [PATCH v10 4/6] KVM: arm64: Mark optional FF-A 1.2 interfaces as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250809-virtio-msg-ffa-v10-4-189eeecf8ae8@google.com>
References: <20250809-virtio-msg-ffa-v10-0-189eeecf8ae8@google.com>
In-Reply-To: <20250809-virtio-msg-ffa-v10-0-189eeecf8ae8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754706812; l=1035;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=IoW1xMVSZLfjRkHlbEaNpwQ0anIxPUAXwOJ+lN5gGek=;
 b=G3n9+VuZjYM8nP+rNuVl9LgzFl6g+m0nuvjNZJwUfvNrEGWf2bsFVmzGaJ4U/NKzOzODOCtxr
 qB6/RMN08IXAyTiVDVI9sW00LEHRL+dHRnRpxda2BqSK2s/16asrL3Z
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

Mark FF-A 1.2 interfaces as unsupported lest they get proxied.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 9311268ad77f50fc596ebae77f451ea144418359..bcb2fab66a61190733682c5bda44e2fa6766177a 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -673,6 +673,11 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
+	/* Optional interfaces added in FF-A 1.2 */
+	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
+	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
+	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
+	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
 		return false;
 	}
 

-- 
2.51.0.rc0.155.g4a0f42376b-goog


