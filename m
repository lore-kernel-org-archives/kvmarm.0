Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54EA30B520
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980334; cv=none; b=SMfQhrtcwkrQLAZq4DQTmuL8lB+HqRUfeVhtCoUjSqwxRqlucynQb+KCc9S0h0ms7W5ZKHwcRgHlGfgsxRmidtnl/2Mt3HU4dptxK1WcrBtXafCTBxue9432F0wodc88otnUZ6VnSbFqj+RIM/Vhv2s38MmeNME7qZm3TlGg+8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980334; c=relaxed/simple;
	bh=UVioe3cP1bYPqsGVmWsr21dHZMl8z/Ov/PsUa6Us+s0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FEXaL3NDPa//BARueyEHQimRl5pscxHKI6Q27OBQCKQTkhVek7agjtNEkSkdCxj01+5QHvMCuQHfF3D71CJxZJJg8V5i7V7DMFOE9ZrBgIs5qXaoEFk+Rzqlx+AkRXg1nhHQtfKJnB5ng8fUkAxNmU5ZBNPD2rVDIr2T4+NJBpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rVP3aaak; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rVP3aaak"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso3026947a91.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980331; x=1765585131; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=igvZhN+qFglUKI0D9M5DwytuE53IkpoWDDVxPCMFY70=;
        b=rVP3aaakqzkoLEn6aqc18PoJisMMY4FV19rIj1Qfe074ZDFs5F1vwTssprkL/MMbor
         y658b1tO74EAxgeCI7VBgW51kY5cV6w5skjDy9GcQmHXCfHF3Crpt97D+17mxr2wOjAD
         ZeO/HuIx51whXq7a68XMt19DGez141qFCePAy2/hC11cJvawxzezm2CQJ2YqDuhqVm+W
         ksZWDoKrOSijBPCzOyB1qyGCpVD2yzyBL+PafqdVQKjmMeDnlbEoNINsw/oUciEzSb1f
         Q4JqnM9UF67uVkuSPR88VrLAQEb2/nP2mUPHpO9n8V9quRTYPSd3YNEHMGmJp+9cPG3i
         TrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980331; x=1765585131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=igvZhN+qFglUKI0D9M5DwytuE53IkpoWDDVxPCMFY70=;
        b=dkhLJ9+LroqJ67y4WzfRd/G1xXrWAbbfExX98tQ1pTiL2hJ6SQjcHk7o6L0xj6Jj/5
         JhsT34N8Ptc1QwasF4Okwmmhe/VEd4EClLMoECH72VkcBxN/8rpSaDRySgUlpGrYvEPA
         jov/0kS0EWGl9Q8f4dfhsDOqvP7nrlyvbu6wDCk7rM6IQeCTqTa8TqCAUIYQ8XwdJLK1
         J0sQMzW31UgtwqJFcD2U1G9G333PbpKaAXcZAix93QNT9DffT2Z793XiU8qPq9A0HMDe
         Esko6p85f0G6Yx4yyi0fgqJFcIvQ60uTa8VMm4axdyfHn5hnkSFKekFRohXEeVJ8qdD5
         9fIA==
X-Forwarded-Encrypted: i=1; AJvYcCUWYUPqnP1Md3kBbg0XitdJs4+pN/MSKDl4iSTMaNkfOKKPiiGgGOH0rlRyu8y1diqvrNs5nqU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/4ZTXLlqGcxvI3nlUyCrXfyQJJQQur8XJ6mhToGFdasW5vhpz
	DYU2wJHNEYFt/RCOSUYKdqzxav+6TphqfcMn01sWnD4NBkjR6F+OXWvxAFQgmkoRLZDzehHi1bE
	ss3b2cw==
X-Google-Smtp-Source: AGHT+IELoQ04EyxWWYOkaKJLtcnZ6DpPNmUnBZcM+48DKxRjXGIekKbShjkFhb2K5/ObBWXw0pAx2mabe98=
X-Received: from pjbsk6.prod.google.com ([2002:a17:90b:2dc6:b0:340:a5c6:acc3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fc47:b0:343:d70e:bef0
 with SMTP id 98e67ed59e1d1-349a267fbc8mr680584a91.21.1764980331409; Fri, 05
 Dec 2025 16:18:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:18 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-43-seanjc@google.com>
Subject: [PATCH v6 42/44] KVM: VMX: Dedup code for adding MSR to VMCS's auto list
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper to add an MSR to a VMCS's "auto" list to deduplicate the code
in add_atomic_switch_msr(), and so that the functionality can be used in
the future for managing the MSR auto-store list.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 018e01daab68..3f64d4b1b19c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1093,12 +1093,28 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 	vm_exit_controls_setbit(vmx, exit);
 }
 
+static void vmx_add_auto_msr(struct vmx_msrs *m, u32 msr, u64 value,
+			     unsigned long vmcs_count_field, struct kvm *kvm)
+{
+	int i;
+
+	i = vmx_find_loadstore_msr_slot(m, msr);
+	if (i < 0) {
+		if (KVM_BUG_ON(m->nr == MAX_NR_LOADSTORE_MSRS, kvm))
+			return;
+
+		i = m->nr++;
+		m->val[i].index = msr;
+		vmcs_write32(vmcs_count_field, m->nr);
+	}
+	m->val[i].value = value;
+}
+
 static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 				  u64 guest_val, u64 host_val)
 {
 	struct msr_autoload *m = &vmx->msr_autoload;
 	struct kvm *kvm = vmx->vcpu.kvm;
-	int i;
 
 	switch (msr) {
 	case MSR_EFER:
@@ -1132,27 +1148,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 		wrmsrq(MSR_IA32_PEBS_ENABLE, 0);
 	}
 
-	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
-	if (i < 0) {
-		if (KVM_BUG_ON(m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm))
-			return;
-
-		i = m->guest.nr++;
-		m->guest.val[i].index = msr;
-		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
-	}
-	m->guest.val[i].value = guest_val;
-
-	i = vmx_find_loadstore_msr_slot(&m->host, msr);
-	if (i < 0) {
-		if (KVM_BUG_ON(m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
-			return;
-
-		i = m->host.nr++;
-		m->host.val[i].index = msr;
-		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
-	}
-	m->host.val[i].value = host_val;
+	vmx_add_auto_msr(&m->guest, msr, guest_val, VM_ENTRY_MSR_LOAD_COUNT, kvm);
+	vmx_add_auto_msr(&m->guest, msr, host_val, VM_EXIT_MSR_LOAD_COUNT, kvm);
 }
 
 static bool update_transition_efer(struct vcpu_vmx *vmx)
-- 
2.52.0.223.gf5cc29aaa4-goog

