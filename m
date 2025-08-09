Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485CF2777F2;
	Sat,  9 Aug 2025 02:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754706813; cv=none; b=N31vViVUpSXrnnL6tWpD0eGf6Cueyq+zZDpRfi+bCvUtgWBvPtPUKbY0X71slWcQT2ntWTAKF6+A+E/MLH421bD07hIwux+3+bDyxf89x5Oo7cM++EQV3uQpneqKfU821adLb880eZt3mALVIYUf5w4kMB67wVWg5yhgNTdIWGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754706813; c=relaxed/simple;
	bh=bL8yAbxiuQ22bQVHGv33iwssGxRBYo5+qxn51pPBsUs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aBdjM6zyIw6frc+Pchh3PS0gIe1rqvtl4Gdv5WALJUOOi8gtkbsSqLRIRfIfN+nEX2JijSb2maQzXyM5iXLsE4t3NI0sWjOWvblQaYvz9/PRlf9M0exteBwFkJ17Yg8X6ufN2KfwDSRS9C2yf/9+OQXBL9UztxDPEHfJpJhFp6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=brrwSjZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="brrwSjZY"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E66E5C113CF;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754706812;
	bh=bL8yAbxiuQ22bQVHGv33iwssGxRBYo5+qxn51pPBsUs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=brrwSjZYVe6DJOgiMa6/vKnk+IWLapUTy2j8iVVYIjvQszwrnZO+8g7oZ6Hfwt85s
	 Gj/NPyZVvS4nrwsjqsJSMbYBYsamssQTQIn7Shn8D7uYbaIruRSoL5LfypHn8LbPLH
	 RWRCJxg03fn+DzfdecEOAsda+prs+r3vnLsALZ9yk9hf/wREohDbL8TRw0DSGFKW9i
	 J4nwT6mjbGT8FYwtHa8bMMe1vVK0hS1dxlD/SF9x69HFP/piienf5Ce9g2tbNTk/Co
	 YrE5YzE4B4sl/Vky++cfxSRwgvlQlGUQI2GeIxxpmLz4Gu1sbFrX8x4p1mZtvo/aPb
	 /WiVDlGpoc86Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC441C87FCB;
	Sat,  9 Aug 2025 02:33:32 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Sat, 09 Aug 2025 02:33:24 +0000
Subject: [PATCH v10 6/6] KVM: arm64: Bump the supported version of FF-A to
 1.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250809-virtio-msg-ffa-v10-6-189eeecf8ae8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754706812; l=1485;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=rli6Os3TRNMcjM1Tg+jZU9NsfEjaWrpVPYJg1zkUw64=;
 b=X2RNV1idUQq0rqDRDkahKbNK+IHDHq4CSzOIfKKcWhLavNLE8079ljldJGBNHc3FIXCzoL/GL
 o5K9qPjfyGDBUCjeyRuVyG229qoxNXUOr2IMAErkgcjZoUi9xepxer5
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
index 22a369f8d1d8edcde45d77377e29dc08256c0bcc..68a7798857dfea9c93dd66069b0f99fb0a030c15 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -931,7 +931,7 @@ int hyp_ffa_init(void *pages)
 
 	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
 		.a0 = FFA_VERSION,
-		.a1 = FFA_VERSION_1_1,
+		.a1 = FFA_VERSION_1_2,
 	}, &res);
 	if (res.a0 == FFA_RET_NOT_SUPPORTED)
 		return 0;
@@ -952,10 +952,10 @@ int hyp_ffa_init(void *pages)
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
2.51.0.rc0.155.g4a0f42376b-goog


