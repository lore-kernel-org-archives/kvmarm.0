Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6AA39FCCA
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781454822; cv=none; b=FSJvIIOuVB/B9fJdvjvPeZ2Y+CCmrW2jIaEgABI2agi5AO3bK/AJ1WiotB2BSYjS3zFs4IsamAN1tV6FXWDVdwPAPZVS0CDZOajVr4mkMOwDPbLPztlxQXjo7H0xty727wlAESB/A0Zqa2tTBc0vHQW8GPmFLThroG4UAQUH1jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781454822; c=relaxed/simple;
	bh=S+ANIzhr+1I2ni2Ik563AGs53yzGHssDeuVeRRuhqk4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VcC1XaA59BZhWdp1ZV86Ieh52Cf6PY2pEaUhdDY57iHbk+BBCSaLtFTzAEc3QnKV6WJ6qNEh36aEIaBfHk6kiAi3CMlwLeVKUFAJhikNH8eRQbdf6V8ZkQuLVJEiDtR8j6cOvy08Md81NJslJXRnuAxieGCF9rIvzE/cW+OcAB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lxf6w4Y3; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lxf6w4Y3"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45efa7755faso978301f8f.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 09:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781454820; x=1782059620; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1TuWrlseib9lZt4HAdFooYmABBxqslHnBMn4+TnN7o=;
        b=Lxf6w4Y3WT2ABLaNE9rn19nAswTFqFnZ/mxQAogNF6ZYINruXSXDEpGGcogmhhm6P2
         T0DJTYpkU7zL5kpSeffVdgQfy20EAYeUVI7A9KwUqsJoT+S2Z4vu1KHPsl9auCXjAFzS
         k42uyKGkbzcWfwEFSOHqWgqNRMAXLnzrK5OVvVEz0eSLjcVKOvTtBGCdGQZbKcBiUxR4
         rZ2PuQyxPTjPBkBibtV8syow1wxBkT13Oihamk0/aWqz0vcalY1CZPPqtNARMKUPKo5I
         P7QUPQ/O4yVs8RxDG0DMQXyg7qJTAmWHY/R1kpyKMFGpkXMdseaT9RXD+mdGCH3cGVFJ
         sG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781454820; x=1782059620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1TuWrlseib9lZt4HAdFooYmABBxqslHnBMn4+TnN7o=;
        b=ZU2Pz+3wcbCegyJTcR1HYkhi/A4PfekQ8Jby5YcQ/yTyk7dtdoQqc0YdPgxzsFGOZ5
         OR6FmH6/T7EN7WSZ3C2C6EuB+sYXHEN6ExRCYPf+YRsnL2cUr9hZG2uHbrub3djtIlwl
         Jhcm+MSr9ntut66XA6lMx88sqQPI598aZyjanXOAKt61be0RMc8LQfT2jX7yOfcx2huW
         m/fYBiTGnvfMhYzQTLBXn0HW3KUTR8AdxE55bQXQwr+YePsw/d7Br0oxslVZmmNS3fW8
         1ChyTNmIrn9xjKRv0IwKbbWzY+O+TeTaNZ3JknjGtzA2obTG/elhqhn2+2/rh6XmSg2h
         IXsw==
X-Forwarded-Encrypted: i=1; AFNElJ83+XgFyUcHkVHjnC4t/X/dN13CtSYcQ80NOXo8Fcmg+T42KiwfwDFcPxcMLTeSSc1egS2a1cY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXwZIGXBUJm1IHck2txA9RyZIWKNmFUbHRcm9gd0LphTbI4lvj
	/pPTnSaSoeEBMgLlIZEi2ZBs3a4mES67klJXqGzwDzDtWsGq4kUiRKm/+BCfB6x7iF2lO3RZgo9
	dnw==
X-Received: from wrmc12.prod.google.com ([2002:adf:e70c:0:b0:460:18fc:1a70])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:288f:b0:460:13db:4a03
 with SMTP id ffacd0b85a97d-46074a5289amr8873252f8f.7.1781454819748; Sun, 14
 Jun 2026 09:33:39 -0700 (PDT)
Date: Sun, 14 Jun 2026 17:33:31 +0100
In-Reply-To: <20260614163336.3490925-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260614163336.3490925-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260614163336.3490925-3-tabba@google.com>
Subject: [PATCH 2/7] KVM: arm64: Unconditionally set IL for injected undefined exceptions
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

inject_undef64() derives IL from the triggering trap's instruction
length (kvm_vcpu_trap_il_is32bit()), but the IL of the injected
exception is fixed by its EC, not by the triggering instruction. The
architecture mandates IL=1 for EC=0 (Unknown) unconditionally, so the
conditional is wrong. The undef-injection paths are not reached from
16-bit instructions, so there is no functional change today, but the
logic should not rely on that.

Set ESR_ELx_IL unconditionally.

Fixes: aa8eff9bfbd5 ("arm64: KVM: fault injection into a guest")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/inject_fault.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 89982bd3345f..9dfae1bcdf99 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -170,14 +170,7 @@ void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 esr)
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
-	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
-
-	/*
-	 * Build an unknown exception, depending on the instruction
-	 * set.
-	 */
-	if (kvm_vcpu_trap_il_is32bit(vcpu))
-		esr |= ESR_ELx_IL;
+	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
 
 	kvm_inject_sync(vcpu, esr);
 }
-- 
2.54.0.1136.gdb2ca164c4-goog

