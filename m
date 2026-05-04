Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00322386C20
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934561; cv=none; b=CYsJTe3WR7+kICW+OWEAnSGYi1vv7KssZoRD8m2thQ3dw3XkzY/tS4ZL4jFupvL1NqQBzYZtbCcDZvOtjJUh+vRLL8leuDMwH7M/ZAPhZ9r2c9euv3cswVIV3mqALxhq6Pf0CejYrZ6Jvi2LhsxHf1rA5jHQzL+TrXcBtvaG61A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934561; c=relaxed/simple;
	bh=/1xQMlHTpDPPKdx9q0rSMVLO6gl3M86K+ccnqA5gdNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bD5MDHSe3CqSaHIYoUXTHGBlNPgMTaGcF9ohmECoi2YwJe4t6jKypG/A81PhzpvF+9S4jxLtutIgLUyalx02P5Q7R9GVGVxU5qwQwSwd+PD7fL6yX7QGeKtT3yAgHeMg4x6/3h9fgFOyrtv+Ig9tDQj1Ts+Eafm49JXVYg501cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SUz3tiy8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SUz3tiy8"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b7c2ee830aso101429465ad.3
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 15:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777934559; x=1778539359; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ua9DP8bxNVeP3OMgw66O02tdFbDSKg07QfaNr/ggdeQ=;
        b=SUz3tiy8TRuoY3fZI38b3Xfw6ZR4RI5TNLJbdDYjsFlmn/HO+l9Awkuhpzi1ul/KvT
         PsYd6Kpg16GcikomYQs8li5B1eWaOi41x0o5lHENyix8ZmDvJdtj4/t1uZVHmcKueXfG
         g4IXbLRAr4OxyX2lYAGfFiBME8vmSLxR0451+FVhmWGbwJmn/UG2omd1toDGtpqUEqwj
         TVgf/15K1ZNJZSEOeeqI1jv9ho9h1UxG6Yv5mcsbOGDEbSZSIWEDxkAPk7jYcrmWeWj7
         yLJDLIcUpV4FOrxC5OXRTV2wi4+l3aOQdxR4lt6zbREYxnpK0aGxGxbmEvYTTCSwd9EO
         Vt7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777934559; x=1778539359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ua9DP8bxNVeP3OMgw66O02tdFbDSKg07QfaNr/ggdeQ=;
        b=b3lc9XgNEaduKh0z4pZgehK0f0wnqI3i12rJ2+wVXBEmiCsOg22iS+MkFrYgn72x4J
         5SiaoNcUMaZgsy09hykHMqJ7fmesBhTbIPTei6jIkFk+Ynyrh0NNPyRpK+ymuE+jODcv
         /5GiCgIrqkE4jfwT2Sml8XI5Bp4o0w/dRDFVtK1pBhEcA8F0OS1CzRvsnkQWuiGwxB5o
         6qbDIuWeYh/Ygv9rBraTYtKXEnr/hyeO4znp3pCqzxKydgPaGxD390+nWAjIrFHMsRRL
         oW/t9Y7KVS9g/gPX/xuFTyuppORY4JrD0fLshlWiJjGqI1ClCfn/ETtD9S/zvVPSdCqO
         zzeg==
X-Forwarded-Encrypted: i=1; AFNElJ/5ZTdWO1Qu80mb1r72B0FxTf4BIJd28zKXeZwLKcNak1xACNFzrhe+zdwdhr54pkJmfUU870A=@lists.linux.dev
X-Gm-Message-State: AOJu0YztQHfyleP8riaVJbTCkYlB9xsdmhrreVWYMIp7IXnYCqharTHV
	a9+X18jhOesueCYIT9h+Cp/dk1h9lVcNIow64NG8z+MBPihQxcd0afrp9Z5ojxJ0vtqBbmQCBW1
	Fa2BHUwm0zt8EWxd6wEOGJw==
X-Received: from pgvh2.prod.google.com ([2002:a65:6382:0:b0:c79:81df:1175])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7e86:b0:3aa:3e4c:9182 with SMTP id adf61e73a8af0-3aa3e4c9385mr220269637.7.1777934558985;
 Mon, 04 May 2026 15:42:38 -0700 (PDT)
Date: Mon,  4 May 2026 22:42:09 +0000
In-Reply-To: <20260504224213.1049426-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504224213.1049426-1-jthoughton@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504224213.1049426-3-jthoughton@google.com>
Subject: [PATCH 2/5] KVM: loongarch: Grab MMU lock in kvm_arch_flush_shadow_all()
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Gavin Shan <gshan@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, James Hogan <jhogan@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_arch_flush_shadow_all() may be called concurrently on the same
`kvm`. This could at least result in accounting mistakes (e.g.
underflows on `kvm->stat.*pages`).

Cc: stable@vger.kernel.org
Fixes: 752e2cd7b4fb ("LoongArch: KVM: Implement kvm mmu operations")
Signed-off-by: James Houghton <jthoughton@google.com>
---
Note: This is compile-tested only!

 arch/loongarch/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index a7fa458e3360..5dbce9b18e1c 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -486,7 +486,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT, 0);
+	kvm_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT, 1);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
-- 
2.54.0.545.g6539524ca2-goog

