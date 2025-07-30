Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609601FDA8E;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753910117; cv=none; b=MiGhaW4xtKG7ksKq+UO5P1JdSMYL5xwBkaR1JTxxjTnIici2k9UVarWCTb6hOd5jkz+BypGcwYLEbwGsxkSx+c9D27FON267R44iHqvDYquqPiYhMogHzd7mP6Oc6LQMY8itLSz2BA0DpbpflwCNRLvBeWCVlcqnE8rW9TbsaHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753910117; c=relaxed/simple;
	bh=hh98tLlJXCvRgiyG81K7JCiTYqxoYUgJDKnikV3MUPI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c+yrfHZKwNheVpRBJ59QyVSAsFv9MeJIstAantVFL4Hph3vuKMa1NKJOHJIvCzf+1zh6COYhW6AWnjCqhADFDf0vwm7JbaWgVrGboNUtiTRV4Bhtiu6xkexFyVlw4LTtu7ZjKdFVUTrspGqaLM/lpwMmOx81dd9oPRXVoLMbqtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JiU80DVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JiU80DVr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 140DAC4AF09;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753910117;
	bh=hh98tLlJXCvRgiyG81K7JCiTYqxoYUgJDKnikV3MUPI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JiU80DVrnhKarGT98QOx797L8u1EqeYqSj2HwYDQVy/a7rTmONWpYjAQNCb49j8zD
	 zk4I3hdwRZ6AX5JpqJgG9D0rklk1/sDoI6cu9+Y0rMOuWGPBBB2HqIayoUJDFTRVSP
	 qNIYiF2pAe2eI3TdjVYTtvfPaTbnA7deQZVDp32WbBJkLNUAbCPqQwFlcCaKNIfHJV
	 8DzqazuGUg8kXF+dPvGs0udZPzcFwCEk7HE6jvYMOotgPqj+a1ORBznoE6klT7AUOY
	 uY0p/OTDZqtVb475fl4I42quUbhBBFmbMFwHhNhvU6SWxmoGp5IXV6kx3vfCxPHBwx
	 paopgyEyLemOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06924C87FD2;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Wed, 30 Jul 2025 21:15:07 +0000
Subject: [PATCH v9 4/6] KVM: arm64: Mark optional FF-A 1.2 interfaces as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250730-virtio-msg-ffa-v9-4-7f1b55c8d149@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753910116; l=1210;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=vsxUjiUKITemxut7aihGZIJXjAQ850iOOIHve4ASG3E=;
 b=gKWwH6ozG59iqR56sr71aowlsg5jb48PB7dhsPM3n2+nBl+wpjlo4dJv8qRVxTZz7bvHNPEDt
 uDKRggaQq+mD4c4yB9+43JIcp2dm573jv1UsAVQbkMgyDHO60vkhUyg
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

Mark FF-A 1.2 interfaces as unsupported lest they get proxied. Also mark
FFA_EL3_INTR_HANDLE as unsupported as it is only valid for physical
instances.

Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 48183fa78014e420372c4fb5e489519bc652bf53..7fe96fe626d630a9009551e8dec1683617acafbd 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -674,6 +674,13 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
+	/* Optional interfaces added in FF-A 1.2 */
+	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
+	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
+	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
+	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
+	/* Unsupported interfaces added in FF-A 1.2 */
+	case FFA_EL3_INTR_HANDLE:		/* Only valid for secure physical instances */
 		return false;
 	}
 

-- 
2.50.1.552.g942d659e1b-goog


