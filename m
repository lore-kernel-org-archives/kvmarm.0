Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738FA3E4C66
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459972; cv=none; b=J4zUPEUPmHEC3Qmk/15nOaME9ylmxUoYD+VFvx0q2bTd367jc0gknytYtJkck3aRKGaWvFKOWJOFB0NeOGJ1PEgohSdUEGkzi+QCTm+4Pa8/N+uHe248eBIaxycvDZ8shhdIVyqsXYTTgcKOud5N0ActWphrxhXQUzINzSPADUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459972; c=relaxed/simple;
	bh=2zBgh4m1N7TvcBWeVoAmS/YX4Hm7U8l/VbANdLXbh7s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DezIgek8+2flZDq/nPYppfl9holFXsUvNyMDQESajBDlTf2dMbXSK13KIMIFDVvmpb06A+8mqWyq0K7vJoBTceG9xlj9Gp8Tk7tqUEgLyMG6vD/232yEQs6pKqVwmv4nSWrf0NUJSpgDd+QpUikVUvR2WNb92k9M14wXAYowiJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HvcxiYXW; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HvcxiYXW"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-463aaa77ffeso334391f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782459970; x=1783064770; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FnfFrOcHXwa5bmm+nV3SBHa/UP6ZPQaBfRpC1K8u2Oc=;
        b=HvcxiYXWNX3NNWHVhwV2c4r0AIoueDVKiH4PpNw4dKxR9JtiFajOJykaYFhnOpL5nX
         xKPQ8ULbRDFTiCBgW8icHGrNMQyC9F0Irof1/u/1cFrjBg18bnJvweGkUypINm+BloLj
         lPpUiQPNEsGjhhOufPStwKpe7Ah1UiV1qq71xO+qZGAZcCbziZXI8dNWrS+qYTfB2vPS
         YPyTXyAC5F0gyaeQpCcBuq3CN5rUIhl6ySgb7USBOQM/psL5n0pd/nOywil2bgGbCG0L
         nbPQ8kT5eTbX0Jyw6e9IaE5+BzARA35yx3jY2uWW7sGFYcAUV4z00uResrgl+08F6flA
         8ttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782459970; x=1783064770;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FnfFrOcHXwa5bmm+nV3SBHa/UP6ZPQaBfRpC1K8u2Oc=;
        b=dmQf94ZEpU9ZAXnTNarv+dIY5ic3+wW+v0yh43VFG5ZxPalicDM6tAibiv78O5LUPT
         n6c70xvpYiFkpSBBlcb79C7yUPNg5+L0B7kSCyA9oogfpR152FcDL7UsJxaVKRyq7wXT
         gEMyydJZVX0tNkYOw6Vf2NfhJBPAR+ihz4ifzNuQ5CaVTeB42vjCMoIqbbHpCqzcLq/r
         CeN/qXA1OJLmyG/FdwWrTN0FghR3d+Gwfu2NeAQsz75Q2j8G10fAWScJ5sF4xnOx9TTw
         CoRw5u4qE07VD5CsQmFOMAzhgT6e7+7MCvNG77SafkwFqj0KfyLlgF3tA/XzpFP/IYrk
         EbTg==
X-Forwarded-Encrypted: i=1; AHgh+RpWVchHw3qiIgGNzwXWNB5Cy1h8midfDNIDZcgI2HGTlAcxm/4aY6aIcANEvys7u8SkvPxHvcM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXbSFQRrZNChjS4Qq93z9qVu8qB5ZkYkSiTYtEOc7zw1FG0U29
	mgOAfGm0duoKpXjxU7VVVLCawVFUwegryF3RZUIyLVFInN6g+LaJkb7RuoFGcw3Vx1RWoNKlbd8
	qKe8A6wT03L1KQKYFvVtXxwb+62AHZw==
X-Received: from wrua15.prod.google.com ([2002:a5d:4d4f:0:b0:46f:90fd:5da3])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4688:b0:46d:d693:88ca with SMTP id ffacd0b85a97d-46dd6938909mr6707494f8f.45.1782459969666;
 Fri, 26 Jun 2026 00:46:09 -0700 (PDT)
Date: Fri, 26 Jun 2026 07:45:44 +0000
In-Reply-To: <20260626074545.433234-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626074545.433234-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626074545.433234-7-sebastianene@google.com>
Subject: [PATCH v6 6/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow the host to send FF-A notification queries to Trustzone and proxy
these messages from pKVM.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index c22fe4514741..712811e89435 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -678,8 +678,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
-       /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
-- 
2.55.0.rc0.799.gd6f94ed593-goog

