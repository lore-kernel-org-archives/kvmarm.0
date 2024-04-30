Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7D219DF45
	for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 19:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714505526; cv=none; b=M5dPp2e/Ix11yfyZqjj+0gHpuw+j4g1M2VWRixx9GU+mbgn/oabnorGQJxF3mUWb4ndsY4SZslpItAw2fFaqmzrW0KEjSH7pHsNVhzM+AA0osEhBNf9nnm4RavFIODlZutw0KpTMnSTzuhmgyptB+E1m7IQSIJKY0D4svSsLRWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714505526; c=relaxed/simple;
	bh=LpfSAtfaCACOaLvBplHLMq/lCqNS1Zqd5xDlARtwz50=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dAGIqmUJLKcL1584T9BbEHEX+qw2yZUueytP/JJaw90O1QOJBQtEF5qUFMcFWXRMHrPzKE4KF17uMRPTTrR206yPD8kp3cwvQqOQMajoEhuyJWOPAF3sfD1rW1Qm4cJWro67gBNshZDN+d1hqHRgu1o+f20hTcDa7gBsU1zrR3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KuwK9wJo; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KuwK9wJo"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-601fef07eaeso6658586a12.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 12:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714505524; x=1715110324; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=teE05Ylose2pcYDprhAFOjLN/sOw6wgj1YwY4a/EgBU=;
        b=KuwK9wJoMGHMOcooQ4ByueNbf1EF0iqUBS6LrWbuIVbQUGdbSe+NfbnryR95GKkCze
         qconxssLJ89og52J8NHxeZczNbbFQcx4njE9iPKI5ezOvgt76IG4vomAC7IpwpRRO4bj
         Xr8ltzYOu1M0HNfsNIwAdByybJoDtTe+++7OXmvI1UdhscQs3GRvqKoF2Fq66GmtLytb
         hRdfsl1n0w7FWD4MOz+fw7l/xvYBklaLvShjCCwfLf3pwMKlnFbrNmSVk5Bg8YZXscNc
         NMolD63C8JMw9i/1g8iKUNh9hlPxWdNHCFaw/mGJt/QPFlkBHNU6xtGg0v3KDZ/MRUiD
         HCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714505524; x=1715110324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=teE05Ylose2pcYDprhAFOjLN/sOw6wgj1YwY4a/EgBU=;
        b=wsTwxI3WTyi+/jnjQIAIob6Y6aq7EOcN5s2IYjGNpIB6ru063gUO6G0fJk9RizmK4W
         BJmwu9/psvffio7HF/56zUU+qQLZ5GOj+49U01G60wzpKeq/6P6UPULwu/gO8Pe68TzY
         csmSijEJOUtYv8kbL4xIpQckjadaUibqAjcX6TguDcME1X3xXZboJVrc5gky6v1+nq9M
         t5f6o9oUWaA9g1i0FStQ8b1VLv5OmYaT2vu6p7M2ETq9XCbhiYa+hf3AJq4reeQjDNKo
         0PMvwN0WcVKUog9AUhubN4s8XjtWx0xUoad6HfC3JP0bRFiQ/VGE41by7ixaVJjuxv4c
         Nu4g==
X-Forwarded-Encrypted: i=1; AJvYcCXbg0U3DDwZcNnh2LCR428P76edoLDK5jbhgVKOohNGg3Bk7fHqMIoEguwDfOQir3jJ8XBpX2Rh2F3ripIB4eu5augi8iWG
X-Gm-Message-State: AOJu0YxyOhDlhxvyAs+NeQJLppYqLeEvAnj2j+3FCTIwKFggWg1/6txA
	DLU7zhVhgQcBqY1IFEv2VSu9f7NoWC7jN/SySmRpS4UEfYrR132dCiN8POX0e6Vpr6xuUyO4yyL
	54Q==
X-Google-Smtp-Source: AGHT+IEbG2WGq5H7HJJ3oJz7X/vycBy/FzdcOadqmLeOQqQxGZZjzOUu53htbVlU23el0Z9xOdv4S0UMTZ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:6a1:b0:5dc:5111:d8b1 with SMTP id
 ca33-20020a056a0206a100b005dc5111d8b1mr1313pgb.5.1714505523833; Tue, 30 Apr
 2024 12:32:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Apr 2024 12:31:55 -0700
In-Reply-To: <20240430193157.419425-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240430193157.419425-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430193157.419425-3-seanjc@google.com>
Subject: [PATCH 2/4] KVM: VMX: Move PLE grow/shrink helpers above vmx_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move VMX's {grow,shrink}_ple_window() above vmx_vcpu_load() in preparation
of moving the sched_in logic, which handles shrinking the PLE window, into
vmx_vcpu_load().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 64 +++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6780313914f8..cb36db7b6140 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1402,6 +1402,38 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
 }
 #endif
 
+static void grow_ple_window(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned int old = vmx->ple_window;
+
+	vmx->ple_window = __grow_ple_window(old, ple_window,
+					    ple_window_grow,
+					    ple_window_max);
+
+	if (vmx->ple_window != old) {
+		vmx->ple_window_dirty = true;
+		trace_kvm_ple_window_update(vcpu->vcpu_id,
+					    vmx->ple_window, old);
+	}
+}
+
+static void shrink_ple_window(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned int old = vmx->ple_window;
+
+	vmx->ple_window = __shrink_ple_window(old, ple_window,
+					      ple_window_shrink,
+					      ple_window);
+
+	if (vmx->ple_window != old) {
+		vmx->ple_window_dirty = true;
+		trace_kvm_ple_window_update(vcpu->vcpu_id,
+					    vmx->ple_window, old);
+	}
+}
+
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 			struct loaded_vmcs *buddy)
 {
@@ -5871,38 +5903,6 @@ int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static void grow_ple_window(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned int old = vmx->ple_window;
-
-	vmx->ple_window = __grow_ple_window(old, ple_window,
-					    ple_window_grow,
-					    ple_window_max);
-
-	if (vmx->ple_window != old) {
-		vmx->ple_window_dirty = true;
-		trace_kvm_ple_window_update(vcpu->vcpu_id,
-					    vmx->ple_window, old);
-	}
-}
-
-static void shrink_ple_window(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned int old = vmx->ple_window;
-
-	vmx->ple_window = __shrink_ple_window(old, ple_window,
-					      ple_window_shrink,
-					      ple_window);
-
-	if (vmx->ple_window != old) {
-		vmx->ple_window_dirty = true;
-		trace_kvm_ple_window_update(vcpu->vcpu_id,
-					    vmx->ple_window, old);
-	}
-}
-
 /*
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
  * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
-- 
2.45.0.rc0.197.gbae5840b3b-goog

