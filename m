Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FD6342535
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 08:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020557; cv=none; b=Tvhs57MTEOjiqrBefVZ/hIEuYwmSnF2AJZcBGOB0OcXeX4KW0q5KegvizG/bCPbwLw0H/3Y6w2Fcl98+Bfw6z7W4jSuGsbm9dNMj9829Yf0gAFW7pM6VfonuHlBHBmRD5hds4HAsDWtcOj7K5zwS3XgD0OsNBS4zrITsgnQ+neg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020557; c=relaxed/simple;
	bh=D6qZfKldpwjM+c/fUFYWGD6EGtCzM/BfOJ+cjy+IZ9U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OCmDfWchhfQt1Fqe2dI82sUZXPOVZqUm85ORE7VXqdMDLj8ImmVWD9S7HNyZwZWiDcUN29L6fGNqJ4lIN7dE8uNUrRPGpsD9nKqQ5OXiYVv1h8YdIX1coZ50yESJv8O5XauXtvNdkJ2CsZdoowYHu/GHoHGAE4WxLPj/YZemxXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oA/HhvwV; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oA/HhvwV"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso82748795e9.1
        for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 01:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777020554; x=1777625354; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YJY1gPOgAaLT6+Kz2+e0ENJlulAl4LJwepN5ROf8PcQ=;
        b=oA/HhvwVeI0tuwLHoraq/iJOgaWeVlKVuY2SCuU4mgbbDwqQHZ5xk4CbPjXdiNLB1n
         eLmCt429KZOwBG2qi9WoCyP8rHEM6tmo4wuX5K65r1AqZAGWe/baTAiIzTLDwa8JPrxt
         KV32SnsISWUcDNQlHIGwT4SD7vPgiDrhNHZjDp1nA9F73cL4wvnpR4Z96xZgfwZIQ/LF
         LOdHW1Cy/fTCHtBDIg/XVrGlL5rIbK9DA0hofUvuD6oXFxecY7cXrrp8gBaM017g5khc
         vPA3LwTkY8W+LmiZ3LQ/xAhi0poY6DIIzgXJoUQRcnaj2saY5ySe/ieUB7dkqpMxrfP/
         FIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777020554; x=1777625354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YJY1gPOgAaLT6+Kz2+e0ENJlulAl4LJwepN5ROf8PcQ=;
        b=EVkj7YTOEqQrenz77bjiW+vTCrGf5XgKkij/9iFSRZibS630cPAAwA2MpEHPHwtKzN
         EZIXiDHJADRtqO6uhLGkK5HabqZUtbyidUWxSywMPw1RveBVW7gtoZvN5q2at/eQx9RX
         R2AwQ1K9z8uaB/8u6IBJd4DqehAF3MlmGhAY/jPxwJYSg8AEoyyuj9EEvnzCRXcSyTYK
         gvw358BNxzJC6cID7zTMmqViJIjLhmCPL77RPpgONv5sSuIoRMmw/+WqeuRBVOlLNpU2
         njTtQq5TtsvrCLqpvQ4TOtKG+zUTufcDw6xkeDwozgB97E8+N6MTTwazbkhtJmy9rNs8
         wdxA==
X-Gm-Message-State: AOJu0YzkVOqjmi+j7iPwaqBG265i16Sl/k35bLaf3FHsaUudBQQ2IlQi
	sqKOAde6xTWzrN2xECQHfUtT6Dy7RQz9x8bKZq67kPdFapApzy3BLLbuRlQeHRYUws1b/ypxdXQ
	xpv9YH1rDkjAP/OQq49mUyf3rqeJEoxBJmGmisGHXG12etGcFNHUEd7ic7eQm4upn8YVdAeyLm9
	YEXwXWse7MZLAOCzREEyZDX4gepn+gT+g=
X-Received: from wmpz12.prod.google.com ([2002:a05:600c:a0c:b0:488:ab5f:9e9e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19cf:b0:48a:66a8:9981
 with SMTP id 5b1f17b1804b1-48a66a89b9dmr10997185e9.27.1777020553789; Fri, 24
 Apr 2026 01:49:13 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:49:06 +0100
In-Reply-To: <20260424084908.370776-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260424084908.370776-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424084908.370776-5-tabba@google.com>
Subject: [PATCH 4/6] KVM: arm64: Fix kvm_vcpu_initialized() macro parameter
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Cc: tabba@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oupton@kernel.org, qperret@google.com, suzuki.poulose@arm.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

The macro is defined with parameter 'v' but the body references the
literal token 'vcpu' instead, causing it to silently operate on whatever
'vcpu' resolves to in the caller's scope rather than the value passed by
the caller. All current call sites happen to use a variable named 'vcpu',
so the bug is latent.

Fixes: e016333745c7 ("KVM: arm64: Only reset vCPU-scoped feature ID regs once")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 851f6171751c..0e5dbc1c5879 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1548,7 +1548,7 @@ static inline bool __vcpu_has_feature(const struct kvm_arch *ka, int feature)
 #define kvm_vcpu_has_feature(k, f)	__vcpu_has_feature(&(k)->arch, (f))
 #define vcpu_has_feature(v, f)	__vcpu_has_feature(&(v)->kvm->arch, (f))
 
-#define kvm_vcpu_initialized(v) vcpu_get_flag(vcpu, VCPU_INITIALIZED)
+#define kvm_vcpu_initialized(v) vcpu_get_flag(v, VCPU_INITIALIZED)
 
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

