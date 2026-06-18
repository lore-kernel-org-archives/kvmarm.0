Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D50D3C4557
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785011; cv=none; b=YZTgQsdAxoqEoU9mq82gWDy4dmBy/r7W+snxAj178LfprG4OAJ7YCxE5ikhfQQEnUAtrtj5ecOpbeAJWzmdu/6b8o3ikKwiFG4sdJ624av6idBSPHoImol3Xa9jRAlsYaSlci38B4nYes/sT0tjlaYwm4TmZNOMr5lArbowpPlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785011; c=relaxed/simple;
	bh=5Di8q9yYpe7Ua8SDCZ8NXcwNMlvmGjo31kY4HzAzIv4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jt3nKqHIuOpOBBL23s5jwYDUpW1c1tuNbcav/v2jxLL9MXdjxIZCAkIUfi8FUgLSy9ZsXm8S2lTp2t4c3WH3vnY0NkJnYg9+tZvhudZw7UkSmAfcORvRbMHYOZtu0B0oMq1fyp5sTol7ben93EfuOD48u6/GgHYbXAkjlgXtUZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cHFZ3c23; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cHFZ3c23"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490dad70f95so7988465e9.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 05:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781785008; x=1782389808; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0CWrIkL6+XzrRSwpatYKrxag9f+rKkB9yY8JYBbAq+c=;
        b=cHFZ3c23x/uaBoDT40yGtGNksLcf1cijaC16T11ZMC6BvS0upSeyXqK/w0kR54MD9d
         oOkRYG4T027LmaLhJRH8CTUUNJ3xLfVQGg7T5GkS/KIkn25UiQZto4S1bHjHBBqi527Z
         KYR39Txjhk4BfDwkapKNTST6iYAAcGPdMUtpkIN5QcL/RRjMfsIZIiPIrL1KOTmhOXdJ
         EiCuVkFD/TzdgDqvp/QhRmGnpe5kkkMVabpdFQUMzZ6BEleWiWxxgJma91gJpFJWbaaC
         BbIP9Z9UOrtnGOCbjghmbbAcgDX/iEu+DpEl6wFmJDlDZ1bUyBFhLMWCZ2bt5X+pCXZ7
         VSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785008; x=1782389808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0CWrIkL6+XzrRSwpatYKrxag9f+rKkB9yY8JYBbAq+c=;
        b=AqhBsaqIgHj3g5BbB9y9SQwLDF4jvos+/S95RErEkv8CXAJE2srHfTM6OYfOyg/r6/
         yP0kAlu6oHGsaXZfHY+5sIhO5GjYTSF7FhGw8BOKeA6jdFBAsnLovvC1lKe3VqcoJ1sM
         R/gGIA+nKBGo+FVI8SgtOYqYOu//EGJgzZYCp0GwTbb8trO8EHSEQAzJMtKKXSEnq/Ff
         8qdB9Po6plxhpDURtY2obNewzJ97ATQs97wXuLH+/ag60cV+5LGMEaLxJNnjdI1aVP/1
         22/8KXoqYKAnHkdf5nPLp56jzYPVKPF2kj7Q3hFmDorHSFsD+yW4ArIdo7e7OIBel0/A
         7I/A==
X-Forwarded-Encrypted: i=1; AFNElJ88iDhQmaZKnASFK7zioZxb+apS22QEfc37z+YAMEP0SchBobaJ40yLb0cc4hts1IuKB3fmFG4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDYaKL0F9hyAwFaU/GxeHPjVTlxc/gOoMc+OfUpY5zNQjv58CI
	09fAvjKf3uLbtR2sOCLXBYgVMqT9EphQsz3KBGc/bRJ14OTxeeZrhoW2rnZcCZdWprL+R7L/PNj
	ijg==
X-Received: from wrme5.prod.google.com ([2002:adf:e385:0:b0:462:9324:e0bd])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e92:b0:491:ba04:2ce4
 with SMTP id 5b1f17b1804b1-4923410c35dmr117676115e9.16.1781785008175; Thu, 18
 Jun 2026 05:16:48 -0700 (PDT)
Date: Thu, 18 Jun 2026 13:16:39 +0100
In-Reply-To: <20260618121643.4105064-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618121643.4105064-4-tabba@google.com>
Subject: [PATCH v2 3/7] KVM: arm64: Unconditionally set IL for injected abort exceptions
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

inject_abt64() derives IL from the triggering trap's instruction length
(kvm_vcpu_trap_il_is32bit()), but the IL of the injected abort is fixed
by its EC, not by the triggering instruction. The architecture mandates
IL=1 for Instruction Aborts unconditionally and for Data Aborts with
ISV=0, and this function never sets ISV (the FSC is always EXTABT or
SEA_TTW). For a 16-bit T32 trap (a 32-bit EL0 task under an AArch64 EL1
guest) the trap has IL=0, so the abort is injected with the wrong IL.

Set ESR_ELx_IL unconditionally.

Fixes: aa8eff9bfbd5 ("arm64: KVM: fault injection into a guest")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/inject_fault.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 9dfae1bcdf99..444d219b0217 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -138,11 +138,10 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 		pend_sync_exception(vcpu);
 
 	/*
-	 * Build an {i,d}abort, depending on the level and the
-	 * instruction set. Report an external synchronous abort.
+	 * Build an {i,d}abort, depending on the level.
+	 * Report an external synchronous abort.
 	 */
-	if (kvm_vcpu_trap_il_is32bit(vcpu))
-		esr |= ESR_ELx_IL;
+	esr |= ESR_ELx_IL;
 
 	/*
 	 * Here, the guest runs in AArch64 mode when in EL1. If we get
-- 
2.54.0.1189.g8c84645362-goog

