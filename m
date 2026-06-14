Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3108B2EDD6B
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781454829; cv=none; b=tKx3OIBotyT75SVlpTzeIEhVqYsPqfVzrrNnNF3xKOW3CqieCg08Zi1O90ET+V1EQ+zWCZOSC9oMICwvjNjJ5JU9DlZcLOMX5N9BHI0VpmgbblxkrFJaZaxyLJm4w7xlvKF/L94v+WPQcQXsqOicyzjV8nUEzwHHuzJ2b5OvU3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781454829; c=relaxed/simple;
	bh=rB6p4hgnJajGerBJPefFKCwu6SD4tYdi0vEtVCjN+DE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aqKYw7xiVFVGV9CEUQIpkH8u2TICgIkq7AS/fUvGRa8Xy5k4cNzkxF1p4WzNe/kuVzAbnvkbY+Mhc/9AokFvxkj/iHR3FU9aABOS/KTW+gsbdeMz8wT+ybU7TgReqfP+KqLWWrWXzeEVrBSyjEx5/3FbLT/VkqU3W+ukBT0SmFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VekEh2Vb; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VekEh2Vb"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490e547f3cfso23777305e9.3
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 09:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781454824; x=1782059624; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NFNzURuXDPJOtNYOPDVBgp1lrFOmwFX8HD0T0LBBDZw=;
        b=VekEh2VbacqsZtNCsXuNdZeW1UZg8IJJqmCoAAv5phl0ql/uEfnT6gBlhc0kNfwggi
         FGyD+k+UVw42QrKRbon3W+po2lUOTzOV2+vBPP5XbD7Cmy/MIEDwN53HaQF3a/4i9yUq
         VAOnIPJOPpoKnSP73obYH2dmLgjATq5uogNIhvrjgAbq15ZJyQx5uArlDWewjx9yO4NJ
         R87gmnVO1axN6A+NZlqmOBFoCdtypG7jPQnjfVJGiD9S9UFcpJ1nXwALcchEpHHy8HxE
         ZGDsf76v4auUoIv6cNjGotKTJJ37Vcm4e2owVtarFXD3x52R6xKvJ3L54MqqikaOba1W
         vi9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781454824; x=1782059624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NFNzURuXDPJOtNYOPDVBgp1lrFOmwFX8HD0T0LBBDZw=;
        b=GB+j5LWNW0Xv9fm/vcqh99DW+456xEqetc4ZAPqNXZPOnXTyAfN67s9Pz8yGa/0wU0
         5jp8h4NIENm23VYd8PMHJNN4aq7UEbN0RKh+EQ4DN7s+Fs88K9iLKIgpZMjm/SWWZotF
         6EXL8bZydqq7sQVg05nj5IaRVbdsaL0SSsYgMK5HmUlwWnlbKHjnrnnmU8aFK/KG0lmQ
         tKPhbrBOUKFwKaAKqcG/6lPMYptXfoRdoudM0iU2i66hbV2EKNxrAAobGlA9QNWpnLmM
         Rjs7dkfgnrKw/ONMX0hxJVyQ5RQ4UASBd0J6J0qkMeSuWigOzO1s7A0B9UvXlJbAOSsq
         BTdQ==
X-Forwarded-Encrypted: i=1; AFNElJ8oGvOj19VyYUFRFuxkJ3I/n/QpvjkBKGPjuZCVt1XIjy6xao0UA81K+JWyoZsoZon5jcG8vh8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxirqHAM0rNBW/IYTdRqZOZ10qVoF1gvLAwPSSj6GwXjPW83Wxo
	kMeXa9GTUbWJXcseqcRkWavU7ygQmhsVtVO7+g/aVZ8OC5SAZleWJzG0b0zn9cZ2tv9hYFL++uu
	08g==
X-Received: from wmqi7.prod.google.com ([2002:a05:600c:3547:b0:490:5e18:ff1c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a215:b0:490:e89a:b221
 with SMTP id 5b1f17b1804b1-490ec5071dfmr86889055e9.35.1781454824318; Sun, 14
 Jun 2026 09:33:44 -0700 (PDT)
Date: Sun, 14 Jun 2026 17:33:35 +0100
In-Reply-To: <20260614163336.3490925-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260614163336.3490925-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260614163336.3490925-7-tabba@google.com>
Subject: [PATCH 6/7] KVM: arm64: Set IL for nested SError injection
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

kvm_inject_nested_serror() constructs an SError syndrome without IL.
The architecture mandates IL=1 for SError unconditionally.

Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 4b39363cf891..4262d4c17a87 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2938,6 +2938,6 @@ int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr)
 	 * vSError injection. Manually populate EC for an emulated SError
 	 * exception.
 	 */
-	esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
+	esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
 	return kvm_inject_nested(vcpu, esr, except_type_serror);
 }
-- 
2.54.0.1136.gdb2ca164c4-goog

