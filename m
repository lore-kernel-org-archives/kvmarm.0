Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B10C23C8A1;
	Fri, 16 May 2025 12:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747397651; cv=none; b=fT9Ap3RHfj/YnHvWeSuTeo89ynQkAiotrpn5r7Q/v0bIPe1Y6d7DQiQSd/oKq10Elm4yBb8jv91EKWTSPwc6sy21hoV0k2GoEyM/TtSaVn4jeynBUh93Bn2t0wV1alFv4ZPxNhzDfCedfLCnICM2U086UzokgMPktHeYTiKiWQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747397651; c=relaxed/simple;
	bh=9U/85KTSy2soaOEUs61BjUU0CpktmnMb+qsPkLo0B5o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r/AxVz/i9gWA0lkXAyq60wgis5FnsL9K4LswBg3/AdVoAsmpaaJUUfziXui6SNktjOKjAAdNEVSyccwK0tV1LL8ODjXmA3nIK3SpF2TWXLX08Uze0QphJKuwHmY2/0ClHkhTnM5M8FB8u3wOkEZFMIUdBnfIujLhoOrBtPOl11Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJ4FtaOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJ4FtaOg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEA5FC4CEF2;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747397650;
	bh=9U/85KTSy2soaOEUs61BjUU0CpktmnMb+qsPkLo0B5o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WJ4FtaOgH+39q/9UjmhBnMooZm5KoX+Lc6xfPXvNDMNsfCAUl1pWOMLWya5iMBnLU
	 wQHuSLJspVLnn4hZ+7Wrs6EHUyfiEcN/uxOz+R2KXldLh6DTJYyiHxhBmln8LXzWok
	 7ectKHLZB0vpmDVhMnBdDfTzVVRZbku0PUpce2wSurbzrXTxDycqtBywlvLJT61q8K
	 MBsDGJeSnouqRehj/aQ/ijXR3VoX2bK68XluFlyhvQqwle27WmbGw6KWo+2WDBFxsy
	 sOax37hTqGWCACMP9df94JZGvlK03PflBQsWi8oaj2vZD2xKSx0D7gVX3pO2LyFUPH
	 JRO3lU3n7EHZA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C7CC54756;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Fri, 16 May 2025 12:14:02 +0000
Subject: [PATCH v4 3/5] KVM: arm64: Mark FFA_NOTIFICATION_* calls as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250516-virtio-msg-ffa-v4-3-580ee70e5081@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1747397650; l=968;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=tJ9HD4wjZlLzjCNPRFEt/uGpoSjzet6nmsUHE2M2Jd8=;
 b=7xqRt3arz28xQfkhqfvJ+B+4UnOt54PAFFfiTGYmU2Bp36rkep1XJN9kBTDpFAIJFbkYVqlts
 V8tkLlIw+XJDtVSOeWXU/FptsGDEfrLiQLuC1y1FcBgYG2ZSPS91GWU
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

Prevent FFA_NOTIFICATION_* interfaces from being passed through to TZ.

Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index b3d016bee404ce3f8c72cc57befb4ef4e6c1657f..a545d25002c85b79a8d281739479dab7838a7cd3 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -632,6 +632,14 @@ static bool ffa_call_supported(u64 func_id)
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
2.49.0.1101.gccaa498523-goog


