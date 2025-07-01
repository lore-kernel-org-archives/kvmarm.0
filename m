Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC253306DA4;
	Tue,  1 Jul 2025 22:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407608; cv=none; b=QqhtAWylhOYocFC2K4mhLxY38I9tDlStQ/6hwITfM7dLaHZY14v2tHROO73JBvHyGFeomqsgx64D4gVeJmQS7YgAvNaBI+bN+pJVg/n+rAi4iFbB7NCVbp7L9tyDmBDGnY1ZuY/kvzBERz1j5+5DZM7H4Ej4HbyjiMuMNfUBbn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407608; c=relaxed/simple;
	bh=Hy1s1+7DoBD3FHcZVBMxtjRrk13K4R0eTQWvOyyFT0s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LBD30tzUrs5Id57oQFq33Zo3zWbr9e5IlX2th84Qa3MPxOM6gYKJ3ByLjkOZGG3Wlu7GOQTa/mUZHeKNLxka5t8z5/duFoTYfBKwK8QkIDmSuygsICxzhK0x5yG8inyZp0ifipcElgnQqsVGsvQ9qRku5E8gfpP+3tLthRyhLDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UEShh4f7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UEShh4f7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C2A3C4CEF1;
	Tue,  1 Jul 2025 22:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751407607;
	bh=Hy1s1+7DoBD3FHcZVBMxtjRrk13K4R0eTQWvOyyFT0s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UEShh4f7Yd6TXm/z3mtUsRgFdiLxNCQESiIRdkKNSU9aojoVlGwKkLSlSVhhkkR6D
	 qI/oma+AaYDzEvc1iSQmfuTO8pJ9OOhCyR2CdXC3IBtfUn88AhyufuzhlPqBYXks/f
	 Jn/B9hrxCmzLsT8rQLuRxW+nkeHw+hFEO9R2tE61zgqluRAuCPv4pX/SyZG/DsjY4m
	 3dpWbNCB6M8X5zucdjrHYUBPayGYPx3GsIKK5ctxUVUo4mlcdkGVRlKLRkUJAQGAX6
	 4g80jPXt4OwKVH1rHHQM75Y01NGjYjvNKISgVnU1O2hNPKsIB6klHpQC4odeKyXrnk
	 4Jzx9GVgQBCjg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AD5C83038;
	Tue,  1 Jul 2025 22:06:47 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Tue, 01 Jul 2025 22:06:36 +0000
Subject: [PATCH v7 3/5] KVM: arm64: Mark FFA_NOTIFICATION_* calls as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250701-virtio-msg-ffa-v7-3-995afc3d385e@google.com>
References: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
In-Reply-To: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1751407606; l=1008;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=r9z6my3JAUeiJyyoAaVHQBDOJAVkijitymt3p9hEt6g=;
 b=GhtpikNRmTzy093EmL+2jycBtO99E2KOmwD5uhU5MgIsakYL1LIJrYOh35MHfpMxGs4qbniZ+
 iVGc03BtiMoDmu0KjAYsVfKexjQTzOHor1q82VSfde2DuEpyULX5jYT
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

Prevent FFA_NOTIFICATION_* interfaces from being passed through to TZ.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 65d241ba32403d014b43cc4ef4d5bf9693813809..5fd6474d96ae4b90d99796ee81bb36373219afc4 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -670,6 +670,14 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
+       /* Optional notification interfaces added in FF-A 1.1 */
+	case FFA_NOTIFICATION_BITMAP_CREATE:
+	case FFA_NOTIFICATION_BITMAP_DESTROY:
+	case FFA_NOTIFICATION_BIND:
+	case FFA_NOTIFICATION_UNBIND:
+	case FFA_NOTIFICATION_SET:
+	case FFA_NOTIFICATION_GET:
+	case FFA_NOTIFICATION_INFO_GET:
 		return false;
 	}
 

-- 
2.50.0.727.gbf7dc18ff4-goog


