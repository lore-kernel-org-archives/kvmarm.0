Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214187;
	b=OxZhteRYR2BEpEmyrZFOS2+troIN4qUa7ZL+q02tbKTS29DCU2vbkYJZJwv3/VrNuk+q
	 Ol5QXpBfcrNV46HK103OxUtOBpCNy3RfWo4AxEitOZuI+FUDvzzRhrp/siyn/KpXJ+DYv
	 9s7RHeFLKhIcTsJo/WoEwLQsNlP76lKZ79DrNWZAaTnrMWDQ4Cb/UpNrkRfmcUEyqV0LI
	 3drNXXwHvdbqy4tRpEXE6nooJEfGuAxiSCPl2HjZTQ8v33GsvhQ/YAv3eBT5QmjNPSJSH
	 CkmwhpjYrNMDWxsOXoxf5FXEVNElipxRVXZnbRrRv39zd628T7wRwwJ9VF9HCpDsSfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214187;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Reply-To:Date:
	 In-Reply-To:Mime-Version:References:X-Mailer:Message-ID:Subject:From:
	 To:Cc:Content-Type;
	bh=RloCiG6ktfajfft7oZXWWlUR2yO2W/arq16CEWx06hk=;
	b=rrv+uIc3RXPQaipJo/+QyY5sv3nBZ8v/ToZq/SQFJ93HmbBoxDS7HhfzWVaFH9M3iQzm
	 ZUx85+Sf2jqASzL3DnZIvyQriCxFY54ITZsmdnfck47ilgGjE9ppa/MmOdpV8LYa02baS
	 zh3fbxGVaWxrdb886lYyTBQ5AYCVUOa85nhxdMUOP8o9mf6aL8dfpIsvdkCEQXgrHQsVF
	 2e9aozXDQEFD3C95MGqPf7pmYyQSjl0NWwdCmuH9ZUExoSomjniqudWpGmBrEuMqHrTYc
	 TNmROr/cGFFh9UKz9lfTjIsJc2aQIA5gtzggLBZNvOJqqMtadmtaRmXVmBti7Kztxaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jgOznClL;
	arc=none smtp.remote-ip=209.85.214.199
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E7260A380C
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 19:03:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94E7260A380C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jgOznClL
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e60770381cso13090645ad.0
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 12:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793214187; x=1793818987; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RloCiG6ktfajfft7oZXWWlUR2yO2W/arq16CEWx06hk=;
        b=jgOznClLJwgacVlChWeCXOkf6vNx2OifWn7Y4zHBhXsO106HbUUeLT4pFUpOaVLccM
         X2fthXMOFShqq6dp37AR7wO9X3QG0VwHPd9n1tKqCB/dOx00FPcsS7GWuWTpY1L4mYQu
         oVAUH/1NWiyfEFecCP7OLAU2wl/uFCm4pX0rC/Xi3f+/t/v1VXZLU/oEDPbsctPFf/CB
         Fd3+S2SR/VcLALJsufORjssatUex0KWkxxaMWZaRvW9U60DF90md5/xoGjk52uM57qdq
         C8YkNnYW4OYYOGIVmCSqve8GjqDgLJMsPzzt4vCfjHy5BwVSLGu9MpCGztGZzRvafMic
         PwOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214187; x=1793818987;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RloCiG6ktfajfft7oZXWWlUR2yO2W/arq16CEWx06hk=;
        b=nn7WOQbYc2D4CWc7AXtIRva1DhfsFzmyuMEGC+sIjQBlC0ZSqWmkJ2zVNq56D2kshF
         NToC+a32crJHyGyPZpQ3Y95N62Mb1KB+ewdkpu7sj6+6qb1K1fKGsJ5WzZM5+IJ1Uy7a
         Zkv15xf/CpY8cg63d6wy7m/r4JqIAZ06So3yPJiVZs/rx5aF6vnd8/1+XNkyGoNhKONl
         3fqHPP1CBIkmo2JcKRxX1oIsrZGHHG/iYbT+zJU4TlnEBIGVzG5+V4CxRFkkS1xnNo/l
         Zk08IQRJSzrHpyaPdzjCJo9v87WCudtbMB01cB9OUviJPS5HL097JTMYOuwV+TV2Ewak
         0ITA==
X-Forwarded-Encrypted: i=1; AKwUvByLKtDkPRCmQKDup8z8ufHKVnmy9mzwUdGuyxkq9aK3Zk5/Q/hd4m4euSsiQZfIUcmtZY8Dom0=@lists.linux.dev
X-Gm-Message-State: AFq9FYKSrNwA0RcY2TEXppK5Lvs1HhZNamMfh4ny31zR+AxwCoCShYW4
	7RmhK8Obp1IEYnWE4tjV717N8bcMePi9gRYH2id+8D9idLISGrZqOQ7NsufRiApQY9Fzh1C7gHB
	+6EePzA==
X-Received: from plma18.prod.google.com ([2002:a17:902:7d92:b0:2e9:73da:58d6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d504:b0:2e8:3d48:4d92
 with SMTP id d9443c01a7336-2eb003bf1dfmr27738995ad.33.1793214186739; Wed, 28
 Oct 2026 12:03:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Oct 2026 12:02:56 -0700
In-Reply-To: <20261028190259.1819571-1-seanjc@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261028190259.1819571-1-seanjc@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028190259.1819571-5-seanjc@google.com>
Subject: [PATCH 4/7] KVM: MIPS: Rework kvm_arch_vcpu_should_kick() to use
 standard implementation
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Stefan Teodorescu <fane@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework MIPS' kvm_arch_vcpu_should_kick() to use the "standard" arch
implementation so that the arch hook can be dropped (MIPS is the only
arch other than PPC that implements a non-standard hook, and PPC uses the
recently added @force param when invoking __kvm_vcpu_kick() instead of
relying on kvm_arch_vcpu_should_kick()).

Convert MIPS to the standard implementation even though the code should be
unreachable (neither kvm_vcpu_kick() nor kvm_make_request_and_kick() are
used by MIPS or common KVM), so that there is a bisection point if the
code is somehow reachable.

No functional change intended (because the code is currently unreachable).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index a53abbba43ea..c37e212bc0a3 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -122,7 +122,7 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
-	return 1;
+	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
 int kvm_arch_enable_virtualization_cpu(void)
-- 
2.56.0.313.g2479322e68-goog

