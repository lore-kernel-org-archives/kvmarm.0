Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC93330BF67
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135743; cv=none; b=IJHYtJsVKtuGBmmObLVNS9LUk8P58ihGEB//849eoE7PM/Y6STyIsFAvoawO7+3WhNSs72jjBQ3O46b5x4Ud21VIf3bOnvEf4t00MO8A6f13zbLF2nE45FaTuk4TgYqwyBMPEMU4zi+cn6ht1umUZ6E31+jasaVI3t3lwZwZ9T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135743; c=relaxed/simple;
	bh=urAFT6EJOW1W5qRLVZla3ZmDxnhGkG5YJibpWY0+6OQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uoZssmWSHn8llxErb8twvy8Jh5NagKYQT3g6JOFdxGvZcN2/k8TTWi6amhTru3PX75k0NKUcAtMUGdaMvItq+jY3NCUNQevWd8cIBiRkg7uh8THGRUSqjQLol6TddB2Ioh4OCkYjjBdAzqxOZ+oYWPVSASqhzv68SGRMVwV8vM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b7SUFdLM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b7SUFdLM"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34eb6589ed2so9158126a91.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135739; x=1767740539; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=huRdRK/iPbU8RR9eXbhBU7huR1SivgrOj8/wOFgY0o8=;
        b=b7SUFdLM/RYqs311thT2SXAJgIjI5ttT9I14dQyjqBcUCGuOIjqUv/gHvdGkatVaKQ
         1N4rF/6WDHorcdzBzCFuloVWQNimoA6ioiRcvabRjHcKIgQcKppdlQilWjAiBSLynfOt
         Z8MIbjKRK2M8jtaq+6ZpZFZ/69oSuih7Gl571e7sYekYrNxCUMTTsB9vh7eIremqtq2i
         ITTjsSi4wxgsEBplmsRxg7qPFsJFGlOX12dLZN3P7TNEPBZnvlsXpmYf1wWiG+xtC5fZ
         so4rH0MEJHYnLJ0xg64iYuu8t8RK7i8vgj0ngeHbajqm16hFU+wr69vt7CMafrtKZuhi
         m1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135739; x=1767740539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=huRdRK/iPbU8RR9eXbhBU7huR1SivgrOj8/wOFgY0o8=;
        b=C8oIgDoBCfrK2OUeVa4Z/PfCSu1e+HwN+yKwv8qYqJr3ZTD3GOtUO2W3hDluVkJP9T
         O7VzrN2NdswGYCdX7FYgHdDza/5Og7uwq+XL3hQysTybk4fBeRpuqdJWg8MnjzGW5bCr
         f+8H8CTRpYg5iLLvrYLYL/VaIMbAKHz7aMC89gx78uBI6ifhvi+kuv9jtYg3dBp4hXno
         Osi0DzY5TfcELZ2x3JGxMTemgYgWObC9ijk1RAn8AJkhSXtN+9SgRkrUlhWPIV5/5Gnk
         cfIavm0t0baVoXfamsbH9ISsGjrjrd1/ZtM5vNjKoEEKf0gfQknPlK1+3czRxo7Ntdg9
         tErA==
X-Forwarded-Encrypted: i=1; AJvYcCUzF6YKYz/+GKB09m8gefUS12nAH+9c5BFnzbQAiZ3+7M3k2PRxaJv0cTruOZL0NZHwgJzihdA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCyU/YjfWTY3sm3ndo4NFGtN3yGcKmAVy71yX/UMxO5KTEQcE0
	TKSAND6QGKVAXdYZNsclwF8opIkjvvnd+0vHce/kyeRQp1L1JYc4f4MOTBRrbSt7NQ7gEcy/Btm
	1fducEg==
X-Google-Smtp-Source: AGHT+IGZKtBCYgVUD+NyJMek1FLHVR3iv8QadOzR34XMxVrGwi8alAagMVcgqb3s54atcYK8jGvrWX49Hsw=
X-Received: from pjwt5.prod.google.com ([2002:a17:90a:d145:b0:34c:7437:183d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:580e:b0:34e:5516:6655
 with SMTP id 98e67ed59e1d1-34e92143ca1mr27682847a91.9.1767135738632; Tue, 30
 Dec 2025 15:02:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:44 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-16-seanjc@google.com>
Subject: [PATCH v4 15/21] KVM: selftests: Allow kvm_cpu_has_ept() to be called
 on AMD CPUs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Yosry Ahmed <yosry.ahmed@linux.dev>

In preparation for generalizing the nested dirty logging test, checking
if either EPT or NPT is enabled will be needed. To avoid needing to gate
the kvm_cpu_has_ept() call by the CPU type, make sure the function
returns false if VMX is not available instead of trying to read VMX-only
MSRs.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 448a63457467..c87b340362a9 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -377,6 +377,9 @@ bool kvm_cpu_has_ept(void)
 {
 	uint64_t ctrl;
 
+	if (!kvm_cpu_has(X86_FEATURE_VMX))
+		return false;
+
 	ctrl = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
 	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 		return false;
-- 
2.52.0.351.gbe84eed79e-goog

