Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9EB283C92;
	Thu, 19 Jun 2025 09:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750323808; cv=none; b=Kx6KhgH67OQkDFJrJ/7zuU3mZVbBwOmAsPYfUBfFrVsznTkDs/iKJDiW5B61aO56kSJyz5UpVsXfKflEnIto6WfS1/bE2g2UNu/Qxi9Mvx0MSLwwqF4JCjf8L6rDuE1qPOuFVjBL+Oc1+LapPfocGqhKf/FV1buc1n6gB0vhx4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750323808; c=relaxed/simple;
	bh=TQleIpVqxX9w9y+oNAtop5bLIFbXUlUOvBs+KyP0ZR8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i5Tw/AiJxQTESITbbaVh0WOKiP2RkJcCno86wosqWP/a6HRyS4MHibV5NBBvDOlXF9mAJ7JO+4BhpknKGKCCXc6LVtOwzqkqUGwVgTyojo6WzjrohgjrV+5C3zDf2yxBfR57uoSjFTLbPBn4gsQLXe5pT0XPO+JbOZKNmM3VRZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7L8NF9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7L8NF9N"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AE19C4CEF0;
	Thu, 19 Jun 2025 09:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750323808;
	bh=TQleIpVqxX9w9y+oNAtop5bLIFbXUlUOvBs+KyP0ZR8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=o7L8NF9NOcsympMD72nGSsnIOax9GF/SqHr4lHLcDv6e+/q3kXvV/jAQdq2QJcYuS
	 G/TocW/Ge14Hkzo0GKxK+MUXEagYH71pSQnmNXPkMdKN6BoWYmR7br/NPVnyDEcVxv
	 YwUBCfqSfYoGXBy7wsKavCtrVO9ulVgotcsa1AK8TY3djtW8kk/m0vw+3I9g1uhr3F
	 ZkLlcpqpCjs8VbeRP/q6k1Ue7pe2kIpSsFi81Z20qe+1lFxxnp5kc0IAyf3kj3D6MM
	 wUc27fqxsETtuHHwBzKWSYQ4kuvTh44yFOJfILWhDqh8zdrirCq2uR0TIAl5M7iccV
	 eX67FLeGyIDog==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414A9C7115A;
	Thu, 19 Jun 2025 09:03:28 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Thu, 19 Jun 2025 09:02:57 +0000
Subject: [PATCH v5 4/6] KVM: arm64: Mark FFA_NOTIFICATION_* calls as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250619-virtio-msg-ffa-v5-4-412c98558807@google.com>
References: <20250619-virtio-msg-ffa-v5-0-412c98558807@google.com>
In-Reply-To: <20250619-virtio-msg-ffa-v5-0-412c98558807@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1750323807; l=1012;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=Qis+O0P+EgX/jX8E8VR0D/SyhX2jCqrXBKwBh6kK8LA=;
 b=owTK3dNtjpqdVYFwLQpJgygVZi0v1UFmK/ckwYhyoMUDJT3aHG0J9frH7mg1/ZBvkhych1K8x
 I8eWPG0jIqrCiQGY9atRRA7H998+kDveRDiZd7m9NaPUXVb0z549ydB
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
index 23b75b9f0bcc62724f0d0d185ac2ed2526375da4..6965aa947fb4529c35872ee3976ab8d0b02becca 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -669,6 +669,14 @@ static bool ffa_call_supported(u64 func_id)
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
2.50.0.rc2.701.gf1e915cc24-goog


