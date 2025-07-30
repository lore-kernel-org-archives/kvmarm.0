Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93262221FB1;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753910117; cv=none; b=mcmiHthMswdhKPgHDIFEF9W2bEymhLu2j9fjKLfy7ru3SoHXe2ftHZezkNfzwU+oJDyI5j7WrTOO/zxiB15Wk1wQCYzhuUKiXjq9ULUadNdg79vNZa8wjko0ASalZ0A39Mz31T4crAG9fVMY46PqJ9L1FvV0G1Mqao0IBZytvWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753910117; c=relaxed/simple;
	bh=L/ffZHLHLfmDPG6MLYu7UcnDeKt5iIqxg63GGjIOWzE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qrG1iSYoa62s0h9mdahAJzn4R2KqGymr49eARnSagi5GSKtqYLeNBfruAQgfkUJhFpT+measDjupeet4GNUH5jleVoA02z0tZoNhtx0DLE/ANPVSbf/JTKwZlolwnY4tASj30MLcXjZeDRcNBrYf/gU6mnGFcXaCdGLPpN7C1AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdc1F7v2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdc1F7v2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FBC0C4CEF5;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753910117;
	bh=L/ffZHLHLfmDPG6MLYu7UcnDeKt5iIqxg63GGjIOWzE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jdc1F7v2NWukEnwf+M7tC1HidW+aEouvj5muF7VS1WLjRdmtWLuCKV5MbsXHZJ8Vm
	 UAJlcIj6L4ro6noyReyPpfGxvadHZfQmgs2sY0tygJ6irn8G3R2dnqioGNwyxXdk/M
	 sDEedd+UqJMqLRhsEpLobpc8TxmEbmYc0kTTC4i5B/uaS3CRmjO5yT+uIgmAkzTx6g
	 DE1WLRraz6UvqsL/gkcajjqzBAUE8QkRk7zs/XCe2r1OhT+ElCOVAwSUN+qCLHb9uB
	 a88jcoYAbDE8aVhMZWIsblJiq6uAlmphDDkKLkRPUuhdufiIaKCdtQxJuGyimmX7PG
	 TslBqMrBAdAOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256A3C87FCC;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Wed, 30 Jul 2025 21:15:09 +0000
Subject: [PATCH v9 6/6] KVM: arm64: Bump the supported version of FF-A to
 1.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250730-virtio-msg-ffa-v9-6-7f1b55c8d149@google.com>
References: <20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com>
In-Reply-To: <20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753910116; l=1481;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=P0vUAR0qDySqTxDDflFhrWZ3pm+eWYd6FxsAvZfn6qs=;
 b=Uz8YatvRCoyf30WVMnYmDCyh1423xGoL0y2Mwx58zD9islDa5g4SWpNsHFCY/S29KYqX8+/88
 Yoo+MJNcEIwDDHcyk8gV0e4EDyTQZ6SjKfdACko6GpOSGmTNztCz2sC
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
index 6afc7e97a1e1e5e23ccf9cc11553b3fdaf8a51e7..a9d827ec5a11743c86ba3f36bf3671cbecd4f3c1 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -934,7 +934,7 @@ int hyp_ffa_init(void *pages)
 
 	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_VERSION,
-		.a1 = FFA_VERSION_1_1,
+		.a1 = FFA_VERSION_1_2,
 	}, &res);
 	if (res.a0 == FFA_RET_NOT_SUPPORTED)
 		return 0;
@@ -955,10 +955,10 @@ int hyp_ffa_init(void *pages)
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
2.50.1.552.g942d659e1b-goog


