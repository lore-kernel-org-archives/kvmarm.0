Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BE93F44CB
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785010; cv=none; b=Eum4WsUnUq3om6DGgPv/CgthczdFTbvYoubhTh+7W7ws0vHl/UkoKIMeZ/DBT8+WJwSTFAZVXhuIxZ9RCBhsL3K179iSVjyEncG3ZpRO0yKtsk5crjjJLOmsYFoyd8J16l0kGPF3CTsW6dTOpxN25w0v3tKyhzoj1ZQpaxOm3RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785010; c=relaxed/simple;
	bh=waaYT4/DFUf9UowO2Osfh/Wu/cdI6fDHVQqOxUVGlxw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sfwS94cGs0iKy+Gj/ZVNqh6tvdVODE+qZxqaf8RZu0wVWy9VUB0H5nHe5mljRcvyzEvLLP4KCsqleKUkCm7tfwOA/5rbiaReZ4kI/k6PEioWr6eSJPqvRteQ6zD+QmgvyBTkflJL7bQWVvoNJTxLdFwisLsoFqWEUznwaYxnXA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hFMeIvvq; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hFMeIvvq"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45eec2ba533so694935f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 05:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781785007; x=1782389807; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rqX7MefVbPP0W7Hi9ByJyRvIz6FhPEE0my94/je5OUw=;
        b=hFMeIvvq94epX+zCgjLgRdQiXhMlu6kYicK2OHP7TMDHL1chyiTS+LAtik7iagsiDU
         1Vb+67d+xjnTCqmg8ZQhVCI8Q7beFf00FRNW7wUVuSqSUUCZ2BnkgIllKKdzafEUbZfg
         DMiUoRHPQOD4K3uZgDkrkGWgQiiUBXTeWypc6VkcBy6tUmsl7IRnCgXYvgYq3AAqVBGa
         bCremeTvRYgIcJpvD5iwnteBKyVq4ETBMHr/W5ukG9tOxqBB3j/okXVqXdoFsYtS3h4h
         3CrxDL0BTNteJUreQYftqu6P4jIY/nnfut77p/1piFttgvTtWGxNFwY7INR/VOIoNbQt
         vrRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785007; x=1782389807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rqX7MefVbPP0W7Hi9ByJyRvIz6FhPEE0my94/je5OUw=;
        b=mdLsGPSGeeEghjdufQj4maybgiW/1s3yvhioZyp/xFW82Fc0B/vUTZHA/znuQ4wLNq
         39H/7oxnmj5qHqRbPUSmSizC9xCqewcIrhhB/O/zuTfLMxkg+3p5v/nVWm5irp+lnp9p
         GQYPGQKKQ3juyE4KTNS+W7ytbzQ0UKP2/QctZMeQlWRM+p8/5Yj/oJq6kIzBoYhbtixI
         Dl8nM7zs8JuAt6Feytfb9ejFBpLssi95C5CXzYQLHkbU/v6Kkvy85NwLb8QtxmbZQd5h
         z7u6v8hdBT8eV30crxiEItqyTCwb433TEMgVHsJx0V84RbdLKZZrUj2+kqnqNctK0PrO
         q0eA==
X-Forwarded-Encrypted: i=1; AFNElJ8rYb+IYQ2Y/J2iOb9Zg5SJnwG3czTn1wR/GQGlhY8dbYjnmHqyy+PbcOneQOFVWF5KLqL7IRw=@lists.linux.dev
X-Gm-Message-State: AOJu0YygHGfwxK5K2b5fl6V+0EcHaDzbuLhNTRSvikUXmwUNqidIBKwO
	vOBfqoILWCEG7XHnBTAFSj93tHPx6tPkmIWZUja9qZvkYPbDFa2EEjJOnkTjRK6Q3S45KZTUqew
	sTA==
X-Received: from wrvz3.prod.google.com ([2002:a5d:6543:0:b0:463:7bed:40ab])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5390:0:b0:45e:eec6:5020
 with SMTP id ffacd0b85a97d-463ae25709dmr3971523f8f.38.1781785006903; Thu, 18
 Jun 2026 05:16:46 -0700 (PDT)
Date: Thu, 18 Jun 2026 13:16:38 +0100
In-Reply-To: <20260618121643.4105064-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618121643.4105064-3-tabba@google.com>
Subject: [PATCH v2 2/7] KVM: arm64: Unconditionally set IL for injected
 undefined exceptions
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
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
2.54.0.1189.g8c84645362-goog

