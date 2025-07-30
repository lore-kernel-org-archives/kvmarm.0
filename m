Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4201FBC92;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753910117; cv=none; b=mLgWTAO9mcTHO8eR/mTzammFChnix59P7aCDWOhe4F4vvze1msuU6I6/TsKLQ+xWT6ihpNCPLSJ94TEyY8udjbO5QUsWtyLXMmfraWv3Lzur+mcg5DLfgy2QuWpUaMJJw6e6IgxqDSVDAcSE5v+jca9dHvmMd5i01Gj5Ch+2HVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753910117; c=relaxed/simple;
	bh=nR3zHOT/qM6CUnGwkzXLNAPxSF2YXcCdkZcpI7GttFI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kb84zCc4r9ilyIqJKmZ7mhO/NVGcZV3BfoTTAfhSsQWnVe7t4CobplWbzf0TqT8I/2oiopDlzq/nWaSzshp5PjvzxnWS07P+34nOxHkAI5GS73accwEvArdYh/42VBtqXWBOuEukZuh3OQMxrXWP4awqjFRuoEgtjHgM+KA0S1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a7HNXXSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a7HNXXSw"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDF5BC4CEF9;
	Wed, 30 Jul 2025 21:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753910117;
	bh=nR3zHOT/qM6CUnGwkzXLNAPxSF2YXcCdkZcpI7GttFI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=a7HNXXSwQvg3xjqGM8Gso4ihQpmqL0CcqQs1zrq1eaORXpiZXRJImvKcY5bNc8FEZ
	 9tf6owXYALXBMsFEPlNdbcXLkouZbvt6vEOtBo7VolwjhodtDf+G/V6aA60yEb+uKF
	 G1NL9WdkUSj9AVgMy8NN93g2AluCQCtNkUTKXqneIQfddq2KuQlb1/VnQ68S5LtQtg
	 FIGyAGZo9OzH1AAvFubwJtkymPSNwL7IetgcYWam/mPrJJfxej2Cgu71+NcP/chGqg
	 XdKf81lR8Bu6vvrAUm7bg2BSMFMOlW49Tj9q25BG734Fjwki8DBnPMOBHLy8uHPbi6
	 tkIKN/4RSZgWQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E412AC87FD3;
	Wed, 30 Jul 2025 21:15:16 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Wed, 30 Jul 2025 21:15:06 +0000
Subject: [PATCH v9 3/6] KVM: arm64: Mark FFA_NOTIFICATION_* calls as
 unsupported
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250730-virtio-msg-ffa-v9-3-7f1b55c8d149@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753910116; l=1008;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=dUX2vyR3ZYQTFCHxhGWOxmpso/rDJ5XMeBkqofPaNOY=;
 b=9/jRFuS4Y3XNatuiRkzXiXqpRC+uPigr09Vqyv18VORTYqnGJQpijGtTKZuhxX7hDvnOHoECE
 /x4THJF+hHTC7QrEN1MAs/d37ORpJ45CP15iBecf4sUh0q2q5GWTjgb
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
index e66149d40c967c14742087d9b45970435d3f2c75..48183fa78014e420372c4fb5e489519bc652bf53 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -666,6 +666,14 @@ static bool ffa_call_supported(u64 func_id)
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
2.50.1.552.g942d659e1b-goog


