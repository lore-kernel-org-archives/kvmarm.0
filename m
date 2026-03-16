Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9AB3D170D
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682543; cv=none; b=YwqtJ24fiLjPBjThQjxRmNXGwZV44t9AGLm3bxzEkKDVelokZDeSGtrJwYpyNa4av4jgqt+K5JifafK2PDwKDtmPJEHCdzG1mdF6VhXH36beUbcd3BRaTTGNxiA8x8vmEDNidSo1Es70u8/dq4htdSuSqYt206qQDDV7jHZBhwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682543; c=relaxed/simple;
	bh=wJHKHXkfOC+zgH0XBj92cvyVS8NAVEQxbDEUxUyBuI4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dWVk8+9dL7qDrZe6TGOr4FHe3e77lhmaz4tIXnAyQCqKYKOro1jIUZ3NCPJVpvt8oxArSK+ArxKg/NokjiI8nqzaF9cHJmU02sJEPoY/Ci7PlPF7QzU1GtWltOn9Ff1wCF69adWf/gL04hUnJln7KkLwiwPn7s+wWPSS4FG1x5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oLUsyZ2t; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oLUsyZ2t"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b9766fcff6fso378750066b.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682539; x=1774287339; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XusE5Uw2A71FlWXS54s/a8QC7XzEJTYhsYfjXaXNfDg=;
        b=oLUsyZ2tq+lJ420XVGttNDWar57/Ww9adBm+r0DNIzDIiGfbiw+0ww9p0ceLYe2KZX
         Nk6zsXgWyF9ICUFe3gGokNjXqqJeH+/2UyztvIpGfIVlwaj1j9VSK8sieaL3beQNmZ+V
         YRuzmJ2u6FpdDIRaAzfdVAFIXoze2MRAioUOFwRlCs26Y1dAbLPkQ3CFscrLRyIS2bLG
         GUr81M1qMMlKduSD9tvKoGf6hcbhBThbIgMA6+GUPE7Hokhk2KfvXE2TftqpDAsMv8cX
         sTMNNb/E5g2M/IGOMenLADgtxIhdnbJng0tHIYjf/aAd1LUrdoDEru3r54InvLWfLSJ5
         IO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682539; x=1774287339;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XusE5Uw2A71FlWXS54s/a8QC7XzEJTYhsYfjXaXNfDg=;
        b=g2swewLFnvVC6amqCU+SFE5V/KeB7LjkN+9bbvM7lYq5kFxLC50g5/EHQL8dAHOT+F
         a7VJ762DBXDqbtMzWYZOL7GCThTkr+SVNasXfBILUABVu4NzgK7QWfcLl0XzQWUddpUs
         i7glZSHklA+lq95a2hCtyOy98kWPF73P2ZrHAyIgsHfQjiIRkLEWcdKWjNieqTmIVDxE
         NAq4PD0BYAsnTU8Ay3gq+9EzfEUERsa32vdRXUFH4QvtbuJR5c1Az/edRMNP25hv/8sx
         /2nxfksCz8QryZlP19aTVUFMRwv4IDd2PDTSZ552f4TrfVK16z0z03LgoeAtXwM/cIsD
         WocQ==
X-Forwarded-Encrypted: i=1; AJvYcCWv2GMH41NPqxYNXVKqv6Nh0gsZ/6uyYJK+7BClpd5uZ12CoUs2TBTxSqNRwgQ1nV27tPW0c8M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpXIugPVQSHY3pv7S3ALEsszXlsQWUAuKVFfsavyyFodWbIChk
	z1LaAv1EThJ29Vb7cEo54H9L7xIiEeStdGIOlWnI+utQxA7g4ReRNEldj5DF3doB5UkFOxV4HKy
	k3A==
X-Received: from ejcm7.prod.google.com ([2002:a17:906:7c7:b0:b8f:93d4:516f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:2d07:b0:b97:c313:db30
 with SMTP id a640c23a62f3a-b97c313eebamr240677566b.8.1773682538520; Mon, 16
 Mar 2026 10:35:38 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:30 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-9-456875a2c6db@google.com>
Subject: [PATCH 09/10] KVM: arm64: Use guard(spinlock) in reset.c
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

Migrate manual spin_lock() and spin_unlock() calls managing
the vcpu->arch.mp_state_lock to use the scoped_guard(spinlock)
macro.

This streamlines control flow during vCPU resets by utilizing
RAII-style automated unlocking.

Change-Id: I32e721e67012c4a141f46b220190bf3c28485821
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/reset.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 959532422d3a..e229c6885c10 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -193,10 +193,10 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	bool loaded;
 	u32 pstate;
 
-	spin_lock(&vcpu->arch.mp_state_lock);
-	reset_state = vcpu->arch.reset_state;
-	vcpu->arch.reset_state.reset = false;
-	spin_unlock(&vcpu->arch.mp_state_lock);
+	scoped_guard(spinlock, &vcpu->arch.mp_state_lock) {
+		reset_state = vcpu->arch.reset_state;
+		vcpu->arch.reset_state.reset = false;
+	}
 
 	preempt_disable();
 	loaded = (vcpu->cpu != -1);

-- 
2.53.0.851.ga537e3e6e9-goog

