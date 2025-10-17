Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721CA1E521A
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661181; cv=none; b=tnrLb7JT4jHr/wS0CvdSp/rwRACiSD3ifu4wtKpfZX+XQDfgzktpszrUf3ZBKWPuiPuoTJWz7V/ZvMWILKqg35PfzE7Uyux5ItJNcOMvdj+ciLfDLERXFTyt4tQOBdeRMrZJ9tG16n5JCiE0IfZPkVJl4em/iHmHyLsdHuasG8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661181; c=relaxed/simple;
	bh=gVnI4GkFUztKHqGbjzSVkprmmFdtZW16vSgVFL0Yqz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nxHKZilCoqvIEew6mrQ3eaVsXglt1JJYf67/FPr3oEQAfVm0V4lp3lWHKDYXTbbmtmm9I/Yv/T7CLSs6CYWh4sDfwAovmvSYi1y/CCznW6nVo5uOrhxRDSRi9GLO2zRND0DaqZAfMRedbQj0lDnhNpR3J3eNDsU+buMGDLhhZ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lxkc8fl4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lxkc8fl4"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bcb7796d4so676786a91.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661179; x=1761265979; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+a1al4eiPUacV4Mot5X5KU5+gR34Rt/H3K9T45t0ZTE=;
        b=lxkc8fl4E54Esn7v3hdi5TtBK3Mk4vCbrTe73unMTBFeVEIRUBVh89u2xAlUjNcJG3
         OWpmyn1ME6l9tfb99/DEXtCQnwNe6/43k40boH+lZH/pVVrMKCYm9m6FOKOcI54BoeId
         VQ0mSuGcko0bct24Eer/+0FatYsjhK+EBjUURbaPzYxaEiD6UYm5jnZny2nheCJIo4/e
         GAvxNK2UYG6yvAeOq/YP+A9BcCaagnNSOrRdJ1UXTxXZZDCC+5kghlDRt2ZvXLmsM8u6
         7UvmBuSeczZnkZgZKY4SdV4vpXTHWJuDjMfQCsmw+6dWxHh7uN6abQPZS2JUECcUeYAW
         o9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661179; x=1761265979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+a1al4eiPUacV4Mot5X5KU5+gR34Rt/H3K9T45t0ZTE=;
        b=bMa6qADcwfvnYAnbtnJgcM/nqj/0lTsvZe32x1CdnSpVheiX0zloIc9HbOn0rmEV7C
         1TiFcPRqXtPrfXU19/cJMgk6hpUhzAFMh4dSPY2DxLibIXLPFKhWWZR8se5PTSVN5w7g
         FlRhsmoJ17j81Y1FO2aSYFAjn7XbiF4P9xNtnf/C0yOH5nkp/slVidTJdJbaaH+HRMa4
         qk1MQZRvNXO7YkEY48f1T1HPYlKLifiKe7qAqiYJMZK/VFCunKmC7qitTc3zTytl3177
         VUFLWNDEFnUk4ZGOfiJpoX8aZvyoNi4QKYFMz1J0IqrR7ePSkccS/QwOV9MKnFN8rIHH
         oTYw==
X-Forwarded-Encrypted: i=1; AJvYcCWfUA/cteBxkbv/NdMmBoSQiJsYzgVNDryXHBVAFcrqCpOHlNb+idZ5uujTBEXQuQ5ZKYFrPa0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfMVPSNzx0OHUwN0CbgpTlRH5KBHrgIDZVXkIrPM2NchxaFTtX
	iJ91WRh/nAiMvukczNm8MCruY2R4syaC2DWFlJutXXv6OCETJSxGt9/XWBN118qonelA+THQGrM
	IIa4Wlw==
X-Google-Smtp-Source: AGHT+IHzIstKbR2q/VP+R8akfQ7d0mH54WcISHRgZ7r9iWOK+ijBTCVCrvD3k8+Ee7BqK468kooIUIkBSz0=
X-Received: from pjbgj21.prod.google.com ([2002:a17:90b:1095:b0:33b:b662:ae3a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1343:b0:30a:4874:5397
 with SMTP id 98e67ed59e1d1-33bcf87f454mr1982502a91.9.1760661178904; Thu, 16
 Oct 2025 17:32:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:24 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-7-seanjc@google.com>
Subject: [PATCH v3 06/25] KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_tdp_map_page() to kvm_tdp_page_prefault() now that it's used
only by kvm_arch_vcpu_pre_fault_memory().

No functional change intended.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3711dba92440..94d7f32a03b6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4924,8 +4924,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
-			    u8 *level)
+static int kvm_tdp_page_prefault(struct kvm_vcpu *vcpu, gpa_t gpa,
+				 u64 error_code, u8 *level)
 {
 	int r;
 
@@ -5002,7 +5002,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	 * Shadow paging uses GVA for kvm page fault, so restrict to
 	 * two-dimensional paging.
 	 */
-	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
+	r = kvm_tdp_page_prefault(vcpu, range->gpa | direct_bits, error_code, &level);
 	if (r < 0)
 		return r;
 
-- 
2.51.0.858.gf9c4a03a3a-goog

