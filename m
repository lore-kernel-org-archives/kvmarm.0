Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1312EC57B
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 12:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261152; cv=none; b=fMLLEd4CA6UCE4iRyGC0MBWyjIOG+JeAD11pcivN3l7ITP4mPoGBVtUEHvcdNoAqEwbNXc23fjUsWztUcuc2xgqDvZAiqcoghWZIiWzJ5CfXWa0spwJgizHV9fmlVLF3DGFIUrRvhU38XhYZPmGIFzAjVLhS19yM849x442qrdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261152; c=relaxed/simple;
	bh=hBwv9skNJm6gVipNKQz+FBZkjSA/GCj+1Z3d2D33gDs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cOO9eYkR6ZNlr/yTBfmqvkvsWppRnq0oZN4bvpWmBQRQuMlnuDWIFRfe/A1FeszejjxEAQ+N1MSyusxQieglrOo3N2uJUnA0CAbC+NRs+b9ZfNFr4B/Ma2/qrN6GnY8F2G6HlmwSs+sNNl2eRydjEWcml06U8sixE5Tfin/O9PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HuZu0M/2; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HuZu0M/2"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-63e0b49cd15so7832781a12.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 04:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762261149; x=1762865949; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bb81JLsWJk82J+wzmAOK9fA3Gew6mQBIHRnpR84BUr8=;
        b=HuZu0M/2VY+9oYV7Rxm0YY+y9IYqlBXb/uInkGQSVSq70wdcfyk2ooLsaJQ0kmR598
         flaEWrmVvh+q6twcxMuLF4ZsQD0zn/nNr/07XU7gTbrfeMYV0I+va34EVvrkpsg13HZ0
         1A9dzBF4ODigEiCgAvDJV/kSAstd5U/qhj83lh3XY6dwmhqAooL3f36u+GsiGbwBHwWB
         TEg3G6CHpW/cf5U4blczDXBvy5R8p2OOslSQbNUMPy8LYZ2FO/tPt4xpvBnElR9PBqBf
         tsqtN/k+RvPHPNcoK8tc2Vid5umr0PM4mZR9Bmk1Fbm159y8MmQPx/AvP4CF9hxSguPb
         F6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261149; x=1762865949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bb81JLsWJk82J+wzmAOK9fA3Gew6mQBIHRnpR84BUr8=;
        b=LJfJehExKT509kfGwLotM/Kkgrb6p/sjqcIRtz88cHYincv3dp3tJSN+/3E5etP2Br
         AryzElwyozk+M+B8qxaBzZxkU1npBfN86XtuL/hKl6mOCEVqpwhlRmzZis7p0MbCWWG3
         ktKeOoS+HtXAWKFK0FkptxajZ7bW3FXvJDJ0Vyisbednp+B++TMnTZnZXrLZ/y5g8J4m
         3SJ6+YiALuhj9nTcLi8yb4MCuEh2k78nIK6xyEs4NkdLJFcXBHVuswAO9+Ac8vn4rfX3
         Ei3t3NidJRh95vOMGZDV0UTnxQySQgqohmy8WQBsyQgT2pKkHRDpW1nQzoRTEO5nKF/m
         oydg==
X-Gm-Message-State: AOJu0Yw0okIcXNt54t9Mo+7am72C4EsJvvyYHFhs8bDzre0VjsASN4qV
	ziLgodj7Re5MAh8P2jy8rPsTofpOfmJwRC2yeEUyHPG4v0zAXgEgK4K+L51+MkcBwElWIMDEuDo
	tZX/ELOdw427+ze2NUxx3+eCZZF1ZX4RdAAnmR1k6hF7wrVLnpNerXYzKz0bHEamBvZyvTe2Fac
	lf1Mbv3f+YCINrxxfw7ZcA/XmwPtzyGLs=
X-Google-Smtp-Source: AGHT+IHUIOJxyeolBcosQO5hwfJGjU0ZOr0h3B9Uz02Yp0VjiDtO0sBxCHmO9LvEuqq8wtzpWFZ9kwMaRg==
X-Received: from edrm19.prod.google.com ([2002:aa7:d353:0:b0:63c:2658:67f3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4619:10b0:640:e78f:f34f
 with SMTP id 4fb4d7f45d1cf-640e78ff72dmr1945558a12.10.1762261148622; Tue, 04
 Nov 2025 04:59:08 -0800 (PST)
Date: Tue,  4 Nov 2025 12:59:00 +0000
In-Reply-To: <20251104125906.1919426-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104125906.1919426-3-tabba@google.com>
Subject: [PATCH v1 2/8] KVM: arm64: Trap access to ALLINT if FEAT_NMI not
 supported by the guest
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Access to ALLINT is part of FEAT_NMI. If a guest does not support this
feature, any access to this register must be trapped to the hypervisor
(EL2).

KVM didn't configure this trap, potentially allowing a guest to toggle
all interrupt mask when it doesn't support FEAT_NMI. Fix this by
checking if the guest has FEAT_NMI support.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 0f8311263edf..3fc62808c548 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -688,6 +688,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 		else
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_MCE2;
 
+		if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, NMI, IMP))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_TALLINT;
+
 		if (kvm_has_tcr2(kvm))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
 
-- 
2.51.2.997.g839fc31de9-goog

