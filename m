Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03FE238176;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747397651; cv=none; b=u+cuuq4W8aUdc2YcInjl3prH9P4ctLOg7z9QwZcil0NSrrgjntfV4xqM2FzTKPR+AcwLOM8QvX8Y8ndz9yis8XSlovrJiyrNNRyhaSanmUlDP1JHhtxpt/IP2Jq2NveP1dyFZSIIOd/AwxsEYYgwO/sgCR310DZTCwgSc+nzPF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747397651; c=relaxed/simple;
	bh=J6h7ILB6u2p92bToPEUMc7SmKaX4SeQ7fwuvz6UJhcs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h1YV92xB3VY+YpcJBEGE6KtkT2Jjq122jPnKGbJxEHmGTrt+CtshiL8u70YgMGWsQiWlqHq17pcBNXTonYL1eoCyR0uds7TXceC9DLrHsO/G9gJMMMx7wJnXsup0Ugx3QRD4a8Eel8tNfmFZ9sUQafukJfmCgdtkyUmyIYckQFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pnWfOWd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pnWfOWd7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C455DC4CEEF;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747397650;
	bh=J6h7ILB6u2p92bToPEUMc7SmKaX4SeQ7fwuvz6UJhcs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pnWfOWd7x8ZqLFiLqji8GuMFYGRlkL44Gmp95jUD+8eMD3NQ85TPQOzIMJ+AT6o9P
	 ey5w4/CL/MPwHVdoUNau8Nt3NLemauCaoUXNz36ztZTtByAwdQnfNEpz7C962QOj8o
	 Zz6XHfh3NqZT23ql2Of7V4TYJNlV93uVz0CsbZjtEzQmyuS55PhLpEoiMtefEpmp0p
	 YltinF5AAAPPj/5emS9I2BcUEmFaRq97oEbmYk8arufAyIKMfMCtfBhywGaO3exwfY
	 qu8B+SlnBuB1bf5aNzbR8LglrHSq8OhSr5MKP+mc8Hw2Ksbk2tStqj3ShjyLI8akPZ
	 77LyswhUI9MgQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42EEC3DA6D;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Fri, 16 May 2025 12:14:01 +0000
Subject: [PATCH v4 2/5] KVM: arm64: Zero x4-x7 in ffa_set_retval
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250516-virtio-msg-ffa-v4-2-580ee70e5081@google.com>
References: <20250516-virtio-msg-ffa-v4-0-580ee70e5081@google.com>
In-Reply-To: <20250516-virtio-msg-ffa-v4-0-580ee70e5081@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, sebastianene@google.com, qperret@google.com, 
 qwandor@google.com, arve@android.com, perl@immunant.com, 
 lpieralisi@kernel.org, kernel-team@android.com, tabba@google.com, 
 james.morse@arm.com, armellel@google.com, jean-philippe@linaro.org, 
 ahomescu@google.com, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1747397650; l=1625;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=LMpReGw/k7MiHAdq22ZI2li2EKc28upqB6Z9WwV7U10=;
 b=N184+8YrogmptYxdr3tgUwyC5QKpJKyFjClV6vICc1bfnlLMzk27GqfoI0om0EZaAnwByKu4P
 H0Cwk+3GMLaDSotY4mVB+EHKJ30m2U4cLwAJkAqPXCg2hkFuJbi8xcA
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

FF-A 1.0 references SMCCC 1.2 (reference [4] on page xi). The results of
an SMC32/HVC32 are returned in W1-W7 in SMCCC 1.2. However, W4-W7 must be
preserved unless they contain results according to the function definition.

ffa_set_retval is commonly used to report FFA_SUCCESS or FFA_ERROR back to
the caller. FFA_SUCCESS requires that x2-x7 must be zero (MBZ) unless a
register is explicitly used in the function response. FFA_ERROR requires
x3-x7 MBZ.

ffa_set_retval is also used to return results of:
- FFA_VERSION which requires x1-x7 MBZ
- FFA_MEM_FRAG_TX which returns FFA_MEM_FRAG_RX or FFA_ERROR.
  FFA_MEM_FRAG_RAX always requires that x5-x7 MBZ and x4 MBZ
  at any virtual FF-A instance (applies to kvm).

Messaging interfaces such as FFA_MSG_SEND_DIRECT_{REQ,REQ2}, will not use
ffa_set_retval.

Given the above, it is safe to zero x4-x7 in ffa_set_retval.

Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 2c199d40811efb5bfae199c4a67d8ae3d9307357..b3d016bee404ce3f8c72cc57befb4ef4e6c1657f 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -101,6 +101,10 @@ static void ffa_set_retval(struct kvm_cpu_context *ctxt,
 	cpu_reg(ctxt, 1) = res->a1;
 	cpu_reg(ctxt, 2) = res->a2;
 	cpu_reg(ctxt, 3) = res->a3;
+	cpu_reg(ctxt, 4) = 0;
+	cpu_reg(ctxt, 5) = 0;
+	cpu_reg(ctxt, 6) = 0;
+	cpu_reg(ctxt, 7) = 0;
 }
 
 static bool is_ffa_call(u64 func_id)

-- 
2.49.0.1101.gccaa498523-goog


