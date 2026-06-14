Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDEB2EDD6B
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781454821; cv=none; b=dAhvuT4y3v1WlxjHXVZA0HjOe9kYul5P7QoHi3MBUSKvBPWrfWp+FjkYbAjb4VKaP0fN2sCcpHGvKPYbCuFAXIYoUp6KdiQk9p4s9SnwBWf2jkgVsAc64lDKpFM6xWtFMWsGZvFRpGZJj498E7LVm6hgIF+du/II4y3iNOJwsaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781454821; c=relaxed/simple;
	bh=Om9tDyrkzAMYgiitUGCRlH8JJcWHv74okAqDlcHmcfE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LEPS0i1gr0eSLwb5ZNzoXHTPHlKnq9hdChHpebfV3Nc3ENDnEqVIHYmoPuWBNAaplc7t+aRU3bqG5s4J7/F9SZ2VV176M+r79oSbY7MY5ilW9NZ1oJTC275Ah9kVHv/rBBeScKaDd7Gi9bfNeOmhPAOAj4hQhUDFnXEb/CNXjD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SxY+g/1h; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SxY+g/1h"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490dad70f95so23320775e9.3
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 09:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781454819; x=1782059619; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r0hMb6JFLji8duaB2XeitlKTMM8QIWRSHjGJV9xdd+o=;
        b=SxY+g/1hH+dfy/cOvPLKtHajRm3ozlThrfMlDSCLo2lJfH8FtsA9HeWAblmKxmcNoD
         YNwc7b8wAUUUBw0IP7pRQuKjepvM/hVgYBkeLpXtT04JvCJOP1HKLqXAhu2cCdIW30TT
         qbXIjvv8LuFXw/azypKGWuRuTEaRmIlkGN6T9RVxdW8cBdvPMfX38Ia5SH76ZVzBj1K/
         WGNa8YTRPNyjUY0MviKXVlTAduaW3yGPFv05VFin9aUk8QT2WW2YM4tAI4V3IzSZ4gTV
         DMbYLHDaqhrlF16p9UBiZzdb26jCdUnUILKYEaxK+3OM4zS5SyqzNmaUGPDyjuGe0Me6
         aHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781454819; x=1782059619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r0hMb6JFLji8duaB2XeitlKTMM8QIWRSHjGJV9xdd+o=;
        b=fvoWF22douyLqoRuyfTQ/VjV/+2JDXVg7CxokvepLOL36o5hArtYvfDxumeAwmQGrp
         QBXLUt7rf59e0okpqNYIdBnW1cMcpBhcGxuyZ/4Kpd5OJm54ZsCgfrHrfw8J3YwMzDmU
         5C3BK8LIw+1NptfaX0SNejbtMwGT31rZBcJwxiQ4TB0qT7/6yi5DlOPjvwTqqTn+mlPA
         iX/SGGJVsDHUA8k2uf2DgofsZN1AshsjXlUDJvW+KlP6h1MiprRSQpPLuBXGXXsOCnkd
         4p/UVchHGQKi8aq+BjG6FtsyRnSJ+56DwQSDnqFBGY6BLAP//pZc+NxF+ffAYndKH+WM
         Clmg==
X-Forwarded-Encrypted: i=1; AFNElJ83fVT7sQVmWt9AN1/MFjD+Svrt9omcUndGijzZK6/zu04+IxBaAPiOQOJSku+xQ0ke/b3fRnU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7k0dnY6GBEGDIkvvERYVpti+rfswsZNS1jansztdsSWXRxizD
	8K2ZcEDj8F1C4oOtdfPzxtEWonAA/jbNYq1f0tUYPzTi+uSH0H3Ch7M60bJxuALRr48t5NWEwvc
	wDw==
X-Received: from wmcv17.prod.google.com ([2002:a05:600c:4291:b0:490:ae4c:a69c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6612:b0:490:bb45:79ee
 with SMTP id 5b1f17b1804b1-490ec33d4cfmr133385485e9.0.1781454818769; Sun, 14
 Jun 2026 09:33:38 -0700 (PDT)
Date: Sun, 14 Jun 2026 17:33:30 +0100
In-Reply-To: <20260614163336.3490925-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260614163336.3490925-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260614163336.3490925-2-tabba@google.com>
Subject: [PATCH 1/7] KVM: arm64: Set ESR_ELx.IL for injected undefined
 exceptions at EL2
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

inject_undef64() constructs an ESR with EC=0 (Unknown) but does not set
IL. The architecture mandates IL=1 for EC=0 unconditionally (ARM DDI
0487, ESR_ELx.IL description), so the injected syndrome is one that
conforming hardware cannot produce.

Set ESR_ELx_IL in the constructed syndrome.

Fixes: e5d40a5a97c1 ("KVM: arm64: pkvm: Add a generic synchronous exception injection primitive")
Reported-by: sashiko <sashiko@sashiko.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8c3fbb413a06..9767adf1f73e 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -278,7 +278,7 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
  */
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
-	inject_sync64(vcpu, (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT));
+	inject_sync64(vcpu, (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL);
 }
 
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-- 
2.54.0.1136.gdb2ca164c4-goog

