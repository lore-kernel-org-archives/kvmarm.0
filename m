Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1952F49FE
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 11:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765453116; cv=none; b=mbHxunilRAHf0lr0UHYk5HFzOyDm2y02BulcSKuA/1TAzof0FwSwHVqwghbI8WoyO9lJ7oY8y0hR1gIPOAeeicJRMqxKKo8TtZwKS0Y4VLMWCDf3VT2EglspLKI2rWW2a5HKQ1+e/oXhGcV3HEzhglrN3x2LwFXGp2EoMLr0EiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765453116; c=relaxed/simple;
	bh=fgQOrToOs+VeD+943R9Ee+say+r4FYRNSjPsH/Ee+7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QWHi9IREFqExPQMDDSDMCJ/4ruHpQAGsdpgbiBD9rvweOGaxx9zHx4i18mTsh1ZzIQYYBADlf8AT1f6no3WvlQ60Dr9LK+clG0xHt4TPpkkqWdJkrn8jl/vmVy/eaN87ibdEBioP/sqH//afYMxvtviZCPIJGL9anX8iae11llg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fmId6/it; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fmId6/it"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779da35d27so6430105e9.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 03:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765453113; x=1766057913; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TSfRNcqgdYRR94XeQNW+/XHpT2F5cVFLgBSNfHWFmoY=;
        b=fmId6/itw1f+Y2CtT8j8YqG2ygFp/rA3qGJ7hqKQIrfONNdfiEzQq0vge0IXQgHS3o
         sKgOy0b49EOky2HYDF6xFT1WWzKNojCQ4eh036YtSghVvrp9p1TDjtRIzJUoeA1s+W1C
         DTZVOnJtSaQmNjRh+dG1oUJmNqDUlyd1Am8ic1PQADUUZNbwY7coUbPdQpnaMWUb9XQs
         IR6ixvrFCdfjG8FbbThaLJK3eMBRmeQv+lb/Wkx+bhm7Pju6J8lKGyrpF+vTS4U+Oe1m
         PWzuL24jw9v6MnA3JySfJHuqIciSNgokR+Xwpq/nbWZdxDuQAq8MIBw6zRJF5zfDfeYV
         ap/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765453113; x=1766057913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TSfRNcqgdYRR94XeQNW+/XHpT2F5cVFLgBSNfHWFmoY=;
        b=GuhAsCIZDg6AoFfKdboE7C8Mcu/ImyA098Lcm8WaDvy9kNr31njbw+JF04FHQqCO2i
         lAW3u5McWwtPq3RUYOs6n/SsQrqAD0s+tbA491hLtQrHDvs/JJTQI0zUkfwQwW+jWfz8
         +55QoFPUccKzSfF1LWSECMd/DxeohiGSvXntAHZPs/HaGoAZggaoSf+J+C/l5hW5iacq
         F4bTUYWohwjD1Un4MAgfllpd4zR7mG2guQRfRlBpckX4K8MnUGWXVfsHij1zPu2ho1uN
         d3pVK9+/woKgl42KpLQ8aTMQ/xbLCcJ22/zQCklAI46fZutUeGvgcWO9TeQGnKQkA6Sj
         3Llw==
X-Gm-Message-State: AOJu0Yxlq9TEqRAUGdrJx7ZYmX1wm2EN4YGdounxvqFSki3sPzmvZX4L
	w4LCzlegt+LZJmeS5pHTsv78qjv4VsrJRkw6WuFAEVe+vmna9H48phpSNNIxwLvpERdrKMIZJla
	E9Cl8aBHL8SMLweKjFqB95skg9OWs7fZCzrj5erOtO2twhL7svFqnBpi9ExjqOzReBkiqR87gC3
	dHm7kz9o8YFILGlBqxEaM9fc7n/hb2XoQ=
X-Google-Smtp-Source: AGHT+IE3m9ReGHk5thHgnr5mene8nSTtvswTou0C94251E4SNHdCUfcxFkOSYWkF5uoeb8ochQ55sz6G2g==
X-Received: from wmjy22.prod.google.com ([2002:a7b:cd96:0:b0:477:9976:8214])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3514:b0:477:28c1:26ce
 with SMTP id 5b1f17b1804b1-47a837fd255mr52324735e9.7.1765453113506; Thu, 11
 Dec 2025 03:38:33 -0800 (PST)
Date: Thu, 11 Dec 2025 11:38:28 +0000
In-Reply-To: <20251211113828.370370-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211113828.370370-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211113828.370370-6-tabba@google.com>
Subject: [PATCH v2 5/5] KVM: arm64: Use kvm_has_mte() in pKVM trap initialization
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When initializing HCR traps in protected mode, use kvm_has_mte() to
check for MTE support rather than kvm_has_feat(kvm, ID_AA64PFR1_EL1,
MTE, IMP).

kvm_has_mte() provides a more comprehensive check:
 - kvm_has_feat() only checks if MTE is in the guest's ID register view
   (i.e., what we advertise to the guest)
 - kvm_has_mte() checks both system_supports_mte() AND whether
   KVM_ARCH_FLAG_MTE_ENABLED is set for this VM instance

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 43bde061b65d..f2060ca66e5d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -82,7 +82,7 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
 		val &= ~(HCR_AMVOFFEN);
 
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, MTE, IMP)) {
+	if (!kvm_has_mte(kvm)) {
 		val |= HCR_TID5;
 		val &= ~(HCR_DCT | HCR_ATA);
 	}
-- 
2.52.0.223.gf5cc29aaa4-goog

