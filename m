Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9682E2D6611
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510294; cv=none; b=fNZDKuacauvHeWHVLNscXZCXgfNh4Al+NAab3XjFSyMYSxfHSl0/m0nkk39eJZpbyOaXPgzMV7HTR+uVzfLe2+Q5lJ8l1s8s0oSDSxfGE7arQbqzVWqWnwQw3WQoYGoVxog4iBDpHUjx5vGPL5RyKaIwB9YIXwBg1iQuNrHpYJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510294; c=relaxed/simple;
	bh=C/4r70x0T0JzgUP1RnZOZXEA4d1zjXrhrDvqbtcZVy0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E7NP3PkUqAOROuuwO3zDBY9r2VZqc3EfdpTNL03/qze5p8lXa6n3ZMBItasTXmZ/oZ8ZnrI4mp//WSRQVubUmsTBOg7PXmvKW9isnWX5tSczPUO0mIioZyminhetojPiQG+zGJ1K5M7GM2iGCBzG+oFMNeYNYpapop4XsR4Xdis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JyxDEXVW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JyxDEXVW"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f3cfdd3d3so333341a91.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510289; x=1755115089; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ThGb/1cQlCkxXgvsmi9By0m3uFp5vZO1mPp34NlVQTI=;
        b=JyxDEXVWUmLC2pGTM8g8nzM5C315BoSVTGisreRdvwBzmedHx6OnW1JHm9WE710g6T
         kMDaqM7C3mbW0zsAqcuFePUhU3rFYB1Y8Hwx0KNwQlsOFs4SAJFeJlDA8ENLLJSHTOkC
         SWScz/gDqM4uSyhNnsx0InZOZAAqIfAcbEniX2Ggewepql9Eid6PP8UQRlopasRqKLRO
         acSOTCmFe20fAQX7iYeD4wKwdEZtSH2eb/7m/HxHh/p6QKXXhlFf47mx6WwB+9sWrOfe
         2ZC1l9/LnPF078MzXAHlNIIx2Y3VzCalMrcz/GZfdxOQDtm4Z/9k0wKmJ5WOSMTJAa88
         ecTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510289; x=1755115089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ThGb/1cQlCkxXgvsmi9By0m3uFp5vZO1mPp34NlVQTI=;
        b=qcArLkO7HuMWAWhEr2RJfTSi/4YyDRv18b2so8g8lHW7zCe+jD1vM79m7oAd081JGn
         K5GHwtYAnG4bxaVykiumV2NslrZV7UUlVOF8w0Etg2ndCuZDVmQxwPAS6vzDtT1wexdO
         zEIdb9yCPVHJtJIukWP6KWnusYbB3qpWXElFRu/AFfqgUbrV1M9tjj2Q5XaPb1JZb4pN
         PFhNit75Dej/yfUv2PHvPRIGxmqMMQU89360awb+wf/bQF300MWlMmCHVsp54m9I3FV5
         whwZdLaT164YrJY7CT4Q6/a8OU5mR8BpEdDdjVG7Xn/IIJ1gpyHmjfDJS1kT9oEAAg+a
         xfYg==
X-Forwarded-Encrypted: i=1; AJvYcCW82/tnb5nHpaEnVSRiPspS0Sbn0vwTTU3BT2QNY1fkeZDW+KazvzRVqi/LwfKQNbfnDOEHevA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzas3ZU7gwpJPtOUwh9fSuKEKPC8FFG/EuWAP/0ub0CE38E2Sk+
	oNRvxSYlrBLN8hSs7jfw4PYxqBh5UBfoUnuohzgDAmImoAfXZI9svMslV8pPjLvbe3xHHEb2UlL
	Vasz68A==
X-Google-Smtp-Source: AGHT+IEDX7osU0iIbko+P3lNad2rdh21UdoQ7zV3q9ejnGRLDtg0+KAFySIgmFRbYCqEx1sz5hOKZCwZh1w=
X-Received: from pjbci4.prod.google.com ([2002:a17:90a:fc84:b0:313:242b:1773])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dce:b0:31f:5ebe:fa1c
 with SMTP id 98e67ed59e1d1-32166d77ff2mr6724469a91.0.1754510289629; Wed, 06
 Aug 2025 12:58:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:44 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-23-seanjc@google.com>
Subject: [PATCH v5 22/44] KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Rename the two helpers vmx_vmentry/vmexit_ctrl() to
vmx_get_initial_vmentry/vmexit_ctrl() to represent their real meaning.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8c6343494e62..7b0b51809f0e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4304,7 +4304,7 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 	return pin_based_exec_ctrl;
 }
 
-static u32 vmx_vmentry_ctrl(void)
+static u32 vmx_get_initial_vmentry_ctrl(void)
 {
 	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
 
@@ -4321,7 +4321,7 @@ static u32 vmx_vmentry_ctrl(void)
 	return vmentry_ctrl;
 }
 
-static u32 vmx_vmexit_ctrl(void)
+static u32 vmx_get_initial_vmexit_ctrl(void)
 {
 	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
 
@@ -4686,10 +4686,10 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
 		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
 
-	vm_exit_controls_set(vmx, vmx_vmexit_ctrl());
+	vm_exit_controls_set(vmx, vmx_get_initial_vmexit_ctrl());
 
 	/* 22.2.1, 20.8.1 */
-	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
+	vm_entry_controls_set(vmx, vmx_get_initial_vmentry_ctrl());
 
 	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
-- 
2.50.1.565.gc32cd1483b-goog

