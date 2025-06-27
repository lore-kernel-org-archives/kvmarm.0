Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AFB21ABBD;
	Fri, 27 Jun 2025 07:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751008381; cv=none; b=IVr8f/oRT3rMXHqluGb1UNsigZAp68uTxWGLx5Uoz/1lQ1yxNXkr6czlQFyh8CMz9POgqkxoEi3zmQIt08XxNiqMloE+28HAymTurkii6gW0/KfWWAMwddTndrPqf1PGvF8PreR4lS4Ef+enMjAMyhxkt5XZSJ3qMgWYABN48w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751008381; c=relaxed/simple;
	bh=Hy1s1+7DoBD3FHcZVBMxtjRrk13K4R0eTQWvOyyFT0s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E/YUfCZza+NpBgc7yxO1zEvnQqeBTlN8oyo44WIo3k8fc6HRO+A8DwW1ah0b5zFw8PIxrzx5jQgLQfwfc9ov7G6Dh8WubOrT1TIk/oydT5VHG1XsKn8kOA2j9kOqJ64Xrp3WQ02+jJ2cl+TgwMz8uldzvwwT9PvGqKB7oTrwAaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJuiG4YM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJuiG4YM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7D0CC4CEF0;
	Fri, 27 Jun 2025 07:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751008380;
	bh=Hy1s1+7DoBD3FHcZVBMxtjRrk13K4R0eTQWvOyyFT0s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aJuiG4YMBOnUYy6Bf7lJDa7qxDSRvmdgAKOn4B7iplx2Fy+oduR2dEnRtg+qJUpxi
	 kaVMIC+9HFzEzfylCWBrOTqHyp5TIbPCQQ8oE9GU+TYpiQSNMS6GyUsiPYOfQDYjbQ
	 epjXvfmu/m+6gxl090tMsN9F501nGuh0V0bN2y7Pqf3BqiaPZMvGLLH4FfwWIN8tJ4
	 oH0G0lARu2ynDmTwMWyo+07hPqfMFUkKvIv9l2dlSE8T0hL4+XVn3zjFfHpew6NOre
	 yRAusC8f76bYf2s1No8jrwfQm4s31u6sSnPumP2rdLWGsZtLRYum9YqBf1F4X6rYhm
	 bz3EEldMOyzNg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC77BC7EE3A;
	Fri, 27 Jun 2025 07:13:00 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Fri, 27 Jun 2025 07:12:27 +0000
Subject: [PATCH v6 3/5] KVM: arm64: Mark FFA_NOTIFICATION_* calls as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250627-virtio-msg-ffa-v6-3-8c02fd94edac@google.com>
References: <20250627-virtio-msg-ffa-v6-0-8c02fd94edac@google.com>
In-Reply-To: <20250627-virtio-msg-ffa-v6-0-8c02fd94edac@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1751008380; l=1008;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=r9z6my3JAUeiJyyoAaVHQBDOJAVkijitymt3p9hEt6g=;
 b=kSubU6hZxrun/Kj2M/soW1+JuFCU4uyHFxW4AbQLs9mrWTMeJ9SV9po1gQ77fETVLFj6YN6+5
 gNhinik24APBQkzgpGRWnGeITmQ8tPmxwcO08HGPkgg3laRlxti4t9g
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


