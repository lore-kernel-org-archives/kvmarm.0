Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252322D322F
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510277; cv=none; b=PtypEwIVlH07vWvKiRXDCwpDMSpZHEEh5zBUKZ+nEEd+pEBGAHtq5+WNUm1gqWSBosRmQdbh8pDy2MXi85HQLRkMlpNNl49Jof1AqzW55J9Ek8Q8hMWfIlhYLMcpftEwx/1Xcl/eimpHFI0XOjrBzrW4keEnLJwtby9CrgwSXsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510277; c=relaxed/simple;
	bh=C4TXme1dQYfX3HBX2bRS9WhICMNyLXZykAhB0txM4zg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZMhU0Vw0QdfOvBdcs2avRdGNZCXz54juNeOFTJf/ods3iPoouc5bSGorRjCUggvUeYPWR8/i+efbfAUjswUg/TScTl6+ssEFK0MuRg1YxfZ0IbkysLoYms+K1MK0AtxnGCMabbCogoC5wMIFp3pAG1Xmr6GViWGVc0PYlwTsVGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=spJa5HkR; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="spJa5HkR"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2424aaa9840so2087195ad.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510274; x=1755115074; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0uQwWV7lYMOxBil53zyDkn96gfX2tt2/DqWsDrl/9hs=;
        b=spJa5HkRX150Anbjukr2CIgUit9TA/a0Z3w9iKc2S+x8ck1U+qvqZcP/tw+RDe3Svk
         AbprKdXABTTjWVmrFEWI1ylE/o2uMIIBjcSywR4dkSAYUN0YkH4YFPgk01xq7dSAV5Wc
         ACsqRjiI5Fiu3QBxxTSLaVmtQz6dgRThqoUZLwN5UC2sAhVNxuv3ynLHz1mGHwbmt43g
         5SJRwcR+CEbt4FZwWeq2RMXoGP3xgYTxIvscB7FzCBuhjFWy4/EuQXnRGr7MV0Gjwoyk
         YHlIy06j3dTijX4yV0nUzTYIfeEaj6hW7UEqPHd1aepJ7dLcIsYderTaIUVHqkzi2d5U
         +wWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510274; x=1755115074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0uQwWV7lYMOxBil53zyDkn96gfX2tt2/DqWsDrl/9hs=;
        b=BUYfygGPhx7KCR3Oq5oEp6t8dLrA7wu037VWdXugjqOhTyI3oPZhDTy7wyGwxoUoBz
         jg7FIG7czYPTgykmbjt2Q9uHDn8RkxCYxH/Xft+4puyH7d/EXPzjA0O+Oxqk1M2PIEHF
         0xmHZXqdXRFaXQHw3PdS1t5p6eZcUVNC6n8UuOGFqPkkk5DHKDwpa8FEolCyxJntHENp
         tpjiBxNMFpf3MMU8T+VnGzmqY7nttjF12w+/g3HW1X1v199z74P1RNtmbs7pkPdWd3EV
         t0++ePdia2gA92xqu/OEf7cBwMSge+/moAIH0g+5xG9kpKaOsD8zR/0PF3oHPbpg0Y/7
         AQKA==
X-Forwarded-Encrypted: i=1; AJvYcCXyKTFTEIrKsM5sDKXN9sxs839XKnQrdyWqOpdmiJvqHKiKp48A0Sys/kL59mx48rcRIQFn1rc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRjDiict5QMTvp58j/OWacwhPCixQl8y2ewNRP42KYxGygqJ8z
	KH6i4orRbF9o5g/yZeFYB5Wd+pqBRJufYNR5VSc5wN27QadNxTni0ngqk4JZq0cwU+x1+D7qgk2
	p74z7Kw==
X-Google-Smtp-Source: AGHT+IGH2b2xUlwmCehGLeN80BLd5ICkd9hx9VxyJMjC6VJA8pJue1wqM8eYOcrMqHKsQHTGrwNwqHX4jyM=
X-Received: from plkh12.prod.google.com ([2002:a17:903:19ec:b0:240:9ca:fc49])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce05:b0:240:49d1:6347
 with SMTP id d9443c01a7336-2429f30b512mr54270245ad.35.1754510274358; Wed, 06
 Aug 2025 12:57:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:36 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-15-seanjc@google.com>
Subject: [PATCH v5 14/44] KVM: VMX: Setup canonical VMCS config prior to kvm_x86_vendor_init()
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

Setup the golden VMCS config during vmx_init(), before the call to
kvm_x86_vendor_init(), instead of waiting until the callback to do
hardware setup.  setup_vmcs_config() only touches VMX state, i.e. doesn't
poke anything in kvm.ko, and has no runtime dependencies beyond
hv_init_evmcs().

Setting the VMCS config early on will allow referencing VMCS and VMX
capabilities at any point during setup, e.g. to check for PERF_GLOBAL_CTRL
save/load support during mediated PMU initialization.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 95765db52992..ed10013dac95 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8335,8 +8335,6 @@ __init int vmx_hardware_setup(void)
 
 	vmx_setup_user_return_msrs();
 
-	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
-		return -EIO;
 
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
@@ -8560,11 +8558,18 @@ int __init vmx_init(void)
 		return -EOPNOTSUPP;
 
 	/*
-	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
-	 * to unwind if a later step fails.
+	 * Note, VMCS and eVMCS configuration only touch VMX knobs/variables,
+	 * i.e. there's nothing to unwind if a later step fails.
 	 */
 	hv_init_evmcs();
 
+	/*
+	 * Parse the VMCS config and VMX capabilities before anything else, so
+	 * that the information is available to all setup flows.
+	 */
+	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
+		return -EIO;
+
 	r = kvm_x86_vendor_init(&vt_init_ops);
 	if (r)
 		return r;
-- 
2.50.1.565.gc32cd1483b-goog

