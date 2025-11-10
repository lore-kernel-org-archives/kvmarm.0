Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D67115A86D
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782332; cv=none; b=FF2kACOSoSc6YlrY/XmZK69XSslWnFna48pU2rxlEO8HmSwgqpwCyhYfl0gyS6OUPoePnZP7pGRo2D3CLtHB+KWY5r5T+BPSrnVTV7kEfcVu7qekESuwZBvellI3Quc6P6pWw6S9cj6StrqJFl/s0F/o47GZ2a9sF2we/8Kdo14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782332; c=relaxed/simple;
	bh=ZEqN0UPvK3HCK09MSfR+qkub5GZsyBTz/VhtlYBy2S4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gKEM49AbAiYM9M6P+DERmtof5/ZH5MRpGENvHKx1SaOXGfCvEKs180MWnEhjp6/zCgb1T664mA5hSwxk2/HzP6HebB86Xn+2mg96H+2tcpnSbH/sqHvlba0lXYegpyIEVBmQBq190MWEDoqQgyMIDSZthvz+lqnbnTaEgpeN27A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iDMSEEkI; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDMSEEkI"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4774836c376so16011805e9.2
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 05:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782329; x=1763387129; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hQotLZ7bYQhnw+F+e2EgZGDV56Lv1I3QeSzBHAS6ry4=;
        b=iDMSEEkI9c7jh1gHwOV1vQ68shFtULrUZ4KIbv5Ud028Zzc6U/34wR0FHtdHcfQR1I
         g/JikR3B+f87SSZfC3xzzsou6L1nOTcwrB9mS2yEI91Hmaror+pGIWCWYZrIIniGAFDC
         1u4iBYLr65zYNj2MhR2Y2TuZL4ZNU/MPlgBgJjqQ67wjBPHuAJM72iSZcB3dX16CKdtW
         ksCfsmnW8c4RlbdQPxcyZWK7b6F7LjPMEJYt3bAhcrVcWV15CmdZj7vOyQOOpyPjZcXc
         qW9hQb0n56QN2+h3FVbTGglVwBwCkm0OXAtUStksN/jQDbXbIpinxj6B7VHM0gNCvyfj
         JQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782329; x=1763387129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQotLZ7bYQhnw+F+e2EgZGDV56Lv1I3QeSzBHAS6ry4=;
        b=sFVNKv73U1WQB+xtDnpuZo1i/Qbdn5slg/FQbtzV7ev26ei8PU3tUzZK0OUHd/x1FU
         VUrAZs5IqBNeO/zl561p2aNS2S6H4Lmhp5ak8Iztw3egbQMzW4pZR6o/3BYDmUtsQg7x
         dzXunEJvC8QEsgXiuf6yUlSGeCtY4v54wDK1em6AiP4nhTIuDlbOdjuo0FfzsdMgZUsm
         /N+F4tJFamzO0jAIiWABvAapIwo5+WXMRN5gL+sImXljhcsm18oGhDhxrzkkVvPnPcx1
         Yw1JgwynbA//HPX9tQBwF8k8swX4mlZBgMunQKi1SdJmX0uW8KjF6VOQVpaUVj4TJ7+1
         wQKQ==
X-Gm-Message-State: AOJu0Ywn5ogJL1ZZEk/i+BOioN0yL4rZFoa8lcB0ZxQe/Rol51gqvCXY
	+tzMA0HWHTh4MIbzNl11msYEzq/wzOXd2ShRXB6AEjElTGCTHH0QUkyT5xR8Zi2XnHGC9SQ6aMN
	8OU11jNZgTT9YNL/aLpBiRhnsx4g2F007Zash2j596OPlqHuDWmY7jT6OWFul7JcysKG3oAX1C4
	296zS3kot+E/DzJZvZ+7ynfNaeoZenH08=
X-Google-Smtp-Source: AGHT+IG/Lsm74PCzoMKxnaXjl9MfGJ8C+06toxg5c6W7aR24YKcuZNfY0RM1Zp40z+F1Ny8UT9itCXjEjA==
X-Received: from wmoo8-n1.prod.google.com ([2002:a05:600d:108:10b0:477:55e7:9973])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f08:b0:475:de14:db1e
 with SMTP id 5b1f17b1804b1-47773277167mr59270015e9.24.1762782328944; Mon, 10
 Nov 2025 05:45:28 -0800 (PST)
Date: Mon, 10 Nov 2025 13:45:19 +0000
In-Reply-To: <20251110134525.3768197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110134525.3768197-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110134525.3768197-3-tabba@google.com>
Subject: [PATCH v3 2/8] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
register accesses. These accesses are trapped to EL2 when the bits are
clear.

The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
had the polarity inverted. When a guest did not support the Trace Buffer
feature, the code was setting E2TB. This incorrectly disabled the trap,
potentially allowing a protected guest to access registers for a feature
it was not given.

Fix this by inverting the operation.

Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8d06a246dfd1..f6f8996c4f97 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 		val |= MDCR_EL2_TTRF;
 
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
-		val |= MDCR_EL2_E2TB_MASK;
+		val &= ~MDCR_EL2_E2TB_MASK;
 
 	/* Trap Debug Communications Channel registers */
 	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
-- 
2.51.2.1041.gc1ab5b90ca-goog

