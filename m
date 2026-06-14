Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928E53CAA48
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781454824; cv=none; b=n7eehvlVx3wlw50v8rDDw4eGdKnIRiQ4EOD97wc+4+lQI4FrR4fUp5EWOE636t0DXqWszuNMKplUnW3nENc2HQQDNnDjsCYqYX7BmIij1nkREJmLcbdJKV6DzPm2wZSYHtv/vgaCbqimRv0+8ao9EK0qSXIxJMmVnyvYU/Rk9wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781454824; c=relaxed/simple;
	bh=A2AhPH+33IQk5h5kTOaTRTDdWlQAO0nttY9d2WHTjzg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SCVArAoLZ2tRrpwzKDyQ3273yvVHxGySCZ+V6Tani4XB/rWW2a+WCrCKV1VE3eX7u2zOaTaNCUv8PHwAoucyKX/IBRy+3aGOeWLKnP2nfse2OkuB9KRw5mrq9hPpG/2YrpWP/iGOmOYrz2oWHgvzifgxxP5nCFfiD38KHmsGnrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PZ9vRAiN; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PZ9vRAiN"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bf481a6e4e6so198896666b.3
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 09:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781454821; x=1782059621; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pUEfSSWjUxPUEBOeVgJgGyeprvmKo0fkBhbWmKqUI0k=;
        b=PZ9vRAiNLbYi4FmLtb60ZDK8vf2OLcVZPfOVR8t1Adv4Mne45iHa3FnhgGcqITXswN
         pHHYkrZqI7l9Gc5wDAqtVOUlqtlcv1tfj/MUzYM0vqsbdWcHS9GEY32jlNPJvBPYe3n3
         +wvzWKdzKjJ2bilIKC2N73dbAIIscyTxYmEw6vM6XEwbyeLNr8VCvkd2f4NsaXg0Rc/1
         ncUwpL9UgJKWXY3IkVl8feSCwMvNCYwHzggnemI9PAY0cfafhF+xxR4xBfhKy7Y4bUF5
         aNgaj9KYljPcuAwH1ziXqgClDSL3nPM6EF3TYokAQEYBIYx4o5M0j82CALx8QnGjDeZ4
         Delg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781454821; x=1782059621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pUEfSSWjUxPUEBOeVgJgGyeprvmKo0fkBhbWmKqUI0k=;
        b=outWbioTTtmQkYkDHZVaP0xJHsv3xUlYqUckS7qZsIMoNecYfSWHW41+sNIrRq94mw
         JOtboo9cJMvFnvYNZVrIalEsgFsdmzRbkdLDOKMlWZXNrFvF1oi7muZIA2htion+BNgr
         wEmo/80Gza3uEt5DBXEvfw7UrMt+qCtcx66a49LLpHUWIX0gNKvtp08ScDNud3moRgb5
         YdW/uXJ7do3Au+qPuP4kjE5RVDTicwo6BdbU2w7eXu3wQxrI9BXuLs1AfYvM7+kjNFfZ
         FuN7TMZp3Gon12lExT5AGYL35Cx6Jsb9XtLY4tt8G6uAJnpj3ocfp3Sdfs4+Ax9UlLPh
         WU9w==
X-Forwarded-Encrypted: i=1; AFNElJ/QxSQvEJPW/7AEaD4XzgQauWFL5L4It2GOaOqquBFLs5qlhya5EXRSl7DfO4rDwvCa3IAgbwc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1BOqWIjDC1YC1j89BFhA9IRmhTxWljJK2cPQTBtQRrJACuwXA
	+o55YcHJV5q2DHPZJDpVPMg4HrGCa0WgLwndAbV8u/rH+A5ei64qghsdZBbgkdFan7qJJjEtSPK
	VLA==
X-Received: from edl15-n1.prod.google.com ([2002:a05:6402:424f:10b0:67b:f7e5:4f5f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7ba2:b0:bee:9809:3ccd
 with SMTP id a640c23a62f3a-bff499220e7mr377106666b.4.1781454820693; Sun, 14
 Jun 2026 09:33:40 -0700 (PDT)
Date: Sun, 14 Jun 2026 17:33:32 +0100
In-Reply-To: <20260614163336.3490925-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260614163336.3490925-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260614163336.3490925-4-tabba@google.com>
Subject: [PATCH 3/7] KVM: arm64: Unconditionally set IL for injected abort exceptions
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
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
2.54.0.1136.gdb2ca164c4-goog

