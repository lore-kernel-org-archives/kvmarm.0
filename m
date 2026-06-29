Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A0B3FE64A
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 09:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725785; cv=none; b=afkI4i2S6cqpEiNYXaO5o5lShY00kSyu/4nzzU+CSskpWlb9rqZmWEZIpMkL1460x8BMQNbj/oJEzXUoWkHZRT4GdVGtwwYSikH70BPEnqg+I7IaGGgO55Ph4dMVPjh26f4EhRmEufEll82JGzsbFMXqKzQrbutszzYwkGbjEHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725785; c=relaxed/simple;
	bh=2zBgh4m1N7TvcBWeVoAmS/YX4Hm7U8l/VbANdLXbh7s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V3bX7A1WdlF3u51pwOdHg228TURalkLBUgLnOFgdU7jR798CESFRIehG9VAeUj/6btKspSA3zXlQ1SjFZCRYNkk3Pv5pcEelf8GHMw3KU99FNTWS1b2n8vdeidGejLA8MePL22YKI4NtCQ0yIgWLIbk72x7ySvxieAF1hgGutcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IWuQEVtT; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IWuQEVtT"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493b0fe9659so6108425e9.2
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 02:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782725780; x=1783330580; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FnfFrOcHXwa5bmm+nV3SBHa/UP6ZPQaBfRpC1K8u2Oc=;
        b=IWuQEVtTMDOOdnkQVG3HVS/y21NUeNIo0uhQMRrlDBCM6o7ynsvXEi/V8dH2XqjyVd
         okEZqUJQiAt+6T5vgjIOWKnbsZ7T6P7sOKGjnO2lFL0k5yECsf0nz2qB8WAGeHHqQDyB
         kaWOtHrek7ox+6H9kjvVHsCVBKjV7JEIF6wclahchH3mmIGKb4cmrD4VE5VVVDuYBzLC
         10hNP6NL93doJsGbnWBH1Aq4XhjafN3UcyMVJZ+0tddsgH8tYLPrIXmVqqKXIaWuGF96
         l4gKooVwpXHUAlPCA2syoeDB7LuA4gVeqpA2XR7WKEAZqvY/pK3bpa6yvOGeOjgEAEs1
         tFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782725780; x=1783330580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FnfFrOcHXwa5bmm+nV3SBHa/UP6ZPQaBfRpC1K8u2Oc=;
        b=V8lxCu9Oxw8tBxTC82EIfHMT8BcE36pk4pt3uuiOwTjh8kCif7RoArSY/HNFdUjTJl
         2m6zZEwY1T7cvDLNX2+t+f9GEaklzPnlSzfO7CWFGWqT23QnfzUdg+p4Yb49mAgTIx+n
         qUts+lwfSyGoh0pwF+Hi3xzNL5PBndDfBboVyViKDZfiGIueXWqA4X0HPdGXdO2tf5Ad
         5JyhGvghhBdY8vYypXHedigzXkBcFBrVPKRKt7cJodncfTEDkoxte4Rg75j8M9Mt/17U
         SqJLPgESQZ+WtQEyESLdgUzP16bHhlAjdcylKNSIK8ICbT8EmSshCXcUV48ye9YdhhL6
         C5Ww==
X-Forwarded-Encrypted: i=1; AFNElJ9q+oHMKia/lEUbfNq/owS4ikylya+aY0bvKCbH+tjIPRZLqeG0KyL5vU1iiDLQVgl4I2xhvTI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyK6s9Yytw9lhCWHxZAKK+gx99Ov5edKcTAZgpHQk/xM4i7Xnhz
	vkmWVuML7ylU5pygxmKlCHeSPHDCjW5IcI78190/J1GitAQZFb/AfvEeilw9pI+pDELx7YnkOll
	3k4IdI9Lx3f8e2K3PfLnDyzvdLuq+XQ==
X-Received: from wma2.prod.google.com ([2002:a05:600c:8902:b0:493:b2c0:5a0d])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a111:b0:492:68bc:3237 with SMTP id 5b1f17b1804b1-49268bc34e3mr160747885e9.32.1782725780006;
 Mon, 29 Jun 2026 02:36:20 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:35:57 +0000
In-Reply-To: <20260629093558.2425257-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260629093558.2425257-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629093558.2425257-7-sebastianene@google.com>
Subject: [PATCH v7 6/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
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

