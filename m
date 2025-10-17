Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1930B285056
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661191; cv=none; b=XVpR3OrbuoHIrGhWpLdS4xIIotLqqys3n12YxfIjbtHOUSOv1Z2O2Zc7BQo5q6b14CQLe7nWF62HcUOcZ0v/svu4jGPfv9yweSE00eF3Ki0wXkwo/prIqC9I2aMcyE9MwaEvspylzxiF5MebGhoVpoLeDMd+0D1FDuTxDDW+fvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661191; c=relaxed/simple;
	bh=T+m3BYVvUt838TFNeB0JdBMWut/8n0JmQsfeAiJxDYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCJ0Z/anpGta0I/DBcHHQ9xoXiAjrLw9y9jW/rxoGm4AVOixOkYgKIoIUvd2bBKIQiF/lWc+m1mKWERK/viba65O1F/RuHCMa9cIyBQa+7IogOH4InO8O0ZtoP662JHCz1u1d92fD59QM/qOsnjafgxJ3x4TlfclnitwQlVxgbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2izr2nxx; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2izr2nxx"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5edecdf94eso1699921a12.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661189; x=1761265989; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YenbGRez6bu/UEaTbB8eZbtDNA5csFA4mZUF4JnZu9w=;
        b=2izr2nxxciuckMGQZd7ywPxGhFtM4sQt5G0csWati7nfs5KUnCgNqGlrnG4MO/QaMx
         +gQizE5Cw5I/g60dRTdZXwTaG6tz8BB46sReZA9SJXEpT1ape4T7nt4t3K+z9SEPz45P
         2j44pE3oK9HrTlaGRWfYjDE/dJxJSn2VzvWihE0QdL6BJq25/fPkEFl9ZpWs0/hpEF+e
         SuMofFUlLmy+TFfT6Z6HR6oH2BgYMCULN2Q4Lc+BCL1HV6IWj/oT4kf47o+owruI4w5s
         1rmciOHf1YVS0QWdySd6jvSGkQo03SM361X20BPckmPFPBQv0T5TROs4V9VyYqWnLo+R
         uUbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661189; x=1761265989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YenbGRez6bu/UEaTbB8eZbtDNA5csFA4mZUF4JnZu9w=;
        b=S+f9bkEE3rCtjtuCPem4BibYlR4Dda6m2JGK5Q+Inr5aBYgXtWEcI2Y4zprRRI3Ooy
         wHKxb5CzEmTlbpSTZ3G4nbTp6ztHI+vO5Upjrt2oqLj2kEtaaWnRrxh+aLxiy3Kln08F
         XZwJscoE+jMC58TgEQymiON2HwUIK5WFMWvGrXvPBrjPgxdb4YJ5wsf0dE8cMeDqPZU3
         2u/g6vgP2NI6GdAXrLMd0e2/l0b7J7jqIduPuN5CS0ts1VuvGvZJNizRrC6gHFRku+pR
         UdKX1p9GAk5K8ewNnOdYZKpGcyb1wv6LITOtuA0IjBQZ3fPtMOO6k3nmKPGK1TVzXmCK
         O95Q==
X-Forwarded-Encrypted: i=1; AJvYcCU3AwyL4Nv+F0sxgpCVfh7KeMhq7Ln/MH6kzAyPhwK+sxYJZrpYPZwBYOX8mOhMdtGYtIHoPsc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMk5DDCzpBhGOWKT9yyz0OMHcmkdvRs9RxfZU28Po6oYj/nsw3
	dOBtgnWD5jfqdRigK3f4spUvnX6TnMcyW89u7dtQZdgt7TmnFxOlqMVGD10nGAWNkP+bu25e1am
	bWVMqcQ==
X-Google-Smtp-Source: AGHT+IFzwgrTUpyTLmlR4n7vLZlT3Ntvx3uZ2AlOGbeNdkR1Pz/L5L7m7JolYZt52l8hjag9eabuD/ERTOw=
X-Received: from pjbpf6.prod.google.com ([2002:a17:90b:1d86:b0:33b:5907:81cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19f0:b0:286:d3c5:4d15
 with SMTP id d9443c01a7336-290cb947798mr22501395ad.36.1760661189400; Thu, 16
 Oct 2025 17:33:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:30 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-13-seanjc@google.com>
Subject: [PATCH v3 12/25] KVM: TDX: Use atomic64_dec_return() instead of a
 poor equivalent
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

Use atomic64_dec_return() when decrementing the number of "pre-mapped"
S-EPT pages to ensure that the count can't go negative without KVM
noticing.  In theory, checking for '0' and then decrementing in a separate
operation could miss a 0=>-1 transition.  In practice, such a condition is
impossible because nr_premapped is protected by slots_lock, i.e. doesn't
actually need to be an atomic (that wart will be addressed shortly).

Don't bother trying to keep the count non-negative, as the KVM_BUG_ON()
ensures the VM is dead, i.e. there's no point in trying to limp along.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 220989a1e085..6c0adc1b3bd5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1722,10 +1722,9 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
-		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+		if (KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm))
 			return -EIO;
 
-		atomic64_dec(&kvm_tdx->nr_premapped);
 		return 0;
 	}
 
@@ -3157,8 +3156,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		goto out;
 	}
 
-	if (!KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
-		atomic64_dec(&kvm_tdx->nr_premapped);
+	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
 
 	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
 		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-- 
2.51.0.858.gf9c4a03a3a-goog

