Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214184;
	b=wdae/xlvOT65u90Ne1N+uMqq3wTXfCDZGYASzn89lJ+Omi6Yx0Hf8nCsx0q3/hsNbKhL
	 xaCJjwh8ws5jWOEXVliZVRJZ2Y2DQJ18gajtFnOz4AToW5dEIj5S+l3ROQvPjSqO+jIzm
	 pZClCxd5tq25eI4Dv5p8qARKDc45abbLqZcmJDAQOEY8C1XoPYmNnLIsxQ7PGsjKbiAJ1
	 dg5NPu9IlMTkE85OwZqbNCKdnf6Za1R/DPgB7AdpsMAOUVYb0gUFCKvzVBwHR0p+W09br
	 nPdlM3LXS6r4XO5BXroe13WmX1tEipgBo6vqb7HOFcRGn4kaLnFW/qXYZq5BNh6mnHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214184;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Reply-To:Date:
	 In-Reply-To:Mime-Version:References:X-Mailer:Message-ID:Subject:From:
	 To:Cc:Content-Type;
	bh=LaqWhYbOMD7sY9Ovf2nEN4IH4sn07uRJnSek/bjgEtY=;
	b=5Fc85J4lP8kxJHIxpfn7AvNL1VnGmJy9jMyyayYMl84hC/PWuUkftUut8WBaMLChPG0/
	 vRJVP1Fc5wC8x0iwFSQ0cG5EyZsSlChofBkRupAFiyp0n/lr9Ryjqz+f7B1sRW+8nnJUS
	 cWs7H7rNJE8nCpZltvbj8luCD/rSCzGBOZIgq7XolDrayOt9GJ8WUPWBq3IXYtfErokTz
	 dxSiYHMFNcRglyDLnLMne5EE02eLqqAW7ej3dPbiUuv/nZoxpnM6zWbFLUaM+gUn7Z8Cu
	 esi5ZdmOxiOn+y+Git7zRyOSPO11AZdlyRGuKF6f+6BfV5v7Nh1h8rkc2gds0jbS7XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SRelg7ym;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D855606A339
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 19:03:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D855606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SRelg7ym
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ad30487d55so1920896a91.2
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 12:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793214183; x=1793818983; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LaqWhYbOMD7sY9Ovf2nEN4IH4sn07uRJnSek/bjgEtY=;
        b=SRelg7ym7xcHnKqSh95pRwfJN3CvpXWHSRuF3+HDzy9lkJHxi5kJvEJuJwFoqiX2r/
         uJupVzgCz7jJFbMyMpp1N4k3rmj9jJ9j6xZWCfr1PfGlahcc7AA53lwTWerAb7gKqgVP
         MrRIq4EoVKXt+Q7kibLMmKBJWK40SPCSWe6PkU0JhtUSXyMPbW3f4EHwlyevXgpxhT0a
         2XuFZHiHDD+rtdUwu0rMekg9PgSi/bblwBD0TnN2OZRhZfCZZyMICmoUp7qSqXm6j3iF
         kRvvRzyjpQDMhzjD6iF01OQ2T0LweMJWOA6vH03UOxfWrnD2+gwYkzt59ry5N2oOnaMo
         g/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214183; x=1793818983;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LaqWhYbOMD7sY9Ovf2nEN4IH4sn07uRJnSek/bjgEtY=;
        b=MD1CkgiR2+XZxpm72Hw23cXOKJa8kXncjGtQuGxCKhXzgLstClkAmThEY2QymySmYI
         KpF3XuqtdvDsVkGOoWzBt8dAd1A/gk8hiAbl7+SSUl0Q8rk8r67yA2IFhiokDyXG7kxI
         1ULMNcMo8nHJQ8j1y8ZfR4bvIq5gi/ws1ZBrV7OSO/xo4TSaU6RCLLYxyrELrHvIzDM8
         BEPJ1oJqzY87ECaYQ50uXScplSb8IzXl99NWlyYbSfxmcNNR1fZPcNViWqebUaho3iQP
         VMKaEcDhMU/k0YjIHFD0MJ4I4BiaXnRHOXkmftD9G0gZLoE/DKHIUGwKHjy4MY3mbzAL
         C9iw==
X-Forwarded-Encrypted: i=1; AKwUvBwkF0kkalOzWcc6oBw5FP3/L6/fEgFtoJKsz3PRe/n7sSObCPt3tjXTvXnsHYfEtxVdQbo10x8=@lists.linux.dev
X-Gm-Message-State: AFq9FYLKchKn1L1bmjBl3iAF01FGHYwJbW4YzLThHVoteMzq3Ydd0Dmh
	iImI/uq+07hqRpMPsbOT4kEY/qHEsXKtWCYAiYUOw4PZV+VwyW7ijL7gAo3ybN4H7SGq0/QBPba
	/wPDjNA==
X-Received: from pjbmh6.prod.google.com ([2002:a17:90b:4ac6:b0:3aa:f38e:cb2d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:264d:b0:3ac:9d83:8856
 with SMTP id 98e67ed59e1d1-3ae57e3d6c1mr2423992a91.9.1793214182870; Wed, 28
 Oct 2026 12:03:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Oct 2026 12:02:53 -0700
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
Message-ID: <20261028190259.1819571-2-seanjc@google.com>
Subject: [PATCH 1/7] KVM: s390: Drop unused and unreachable kvm_arch_vcpu_should_kick()
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

Drop s390's kvm_arch_vcpu_should_kick() stub as the one and only call site
is wrapped with "#ifndef CONFIG_S390".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/s390/s390.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/s390/kvm/s390/s390.c b/arch/s390/kvm/s390/s390.c
index 18fb200f854a..9900a1a1c148 100644
--- a/arch/s390/kvm/s390/s390.c
+++ b/arch/s390/kvm/s390/s390.c
@@ -3922,13 +3922,6 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 	return false;
 }
 
-int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
-{
-	/* kvm common code refers to this, but never calls it */
-	BUG();
-	return 0;
-}
-
 static int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
 					   struct kvm_one_reg *reg)
 {
-- 
2.56.0.313.g2479322e68-goog

