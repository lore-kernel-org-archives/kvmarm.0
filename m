Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F7336E369
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855014; cv=none; b=mmMGBUbcotlDVPSFQK+3jGeyM0oKz2Zck3wIbdoz5MHrfypADtu6nRzZblxzuNRJZrY7bRUieG3Uul2i1c+PCIyF1GeBmtSoTdu/K8pbMTera0CzcxRBgiL7GS72CBFScL+L/95G+0sO2XgZMcq06W7/DYjnN+I8PfQUpzTgcv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855014; c=relaxed/simple;
	bh=Q2c6cNYSKoGYP4CYOI8nHGq0kI85fWBL8NZOIPZmdhU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DUzb8xlCEkunOIuLuWZqTcr9tjuJ8n6iDsXYkjkhlyJ0QezVu83kQWaiPzFTmUVrGQA00wq/K7pygx86sSPKIo8tjAkX0oELLI7SjRB+UPHNoBNgyuvPQAGixlzI7FToOmfCECF4AkqBcoDeKa3vMCETR314jiFtpI3pYrO9zoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=umVi+29G; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="umVi+29G"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so1121478a91.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855011; x=1762459811; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pr+88J8V2FFjpoCz/RKjLuOTT6WQDejtYqs45iSU51c=;
        b=umVi+29GlBMqC9PBZwUtq52Zvsm9mhX1HUBpuKEf7XecdfuWCGrPnSkLz4djFm4ReC
         ibPTQ1nVHKXnicXup3lM1Mg9YYRg6W6j2EFq5USq354esNTw5oFa/CbNUtJ/XRsZP64D
         3VVktGd21ALuRPrIWmQAg4OeAEsrjDDNJxTzhpBTjJMQ0z0BfXHIJ7U0iqzcC519OGYc
         0ehnRNhzB7SKzSGxyCNfl516wBp53si0mLAiMnO9hTlwYAUCaxD8I22OgXPtI4cOwwjd
         NzS/Px4A0SXFUDveGjVCZwJsULMigMsrk7a2//sepo5pbwcTQnkQONYUuofUAb61Jc2Q
         OLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855011; x=1762459811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pr+88J8V2FFjpoCz/RKjLuOTT6WQDejtYqs45iSU51c=;
        b=PZz0iOd6Uz8lBXqxh6eQlSJ78XUtXktAf+qnn6BQCmdJ+Dz0NTEFDa1TkykJ+6boy+
         VQrph5pRfByswWXWg5av1ULzo4VQOMFaSGH4n9JkLkmHfOWM2BWq0WPT6ie9p9HueIEK
         /f0QMNnLKkN6YR30iBlS33wvZ+n6uaDN5FGdffaIz5ImqGXw7RG3V/6CT5VjYBPhmHAb
         S33d/CiBh8ktRfnPGSQLb2HDKsrcsbDmiD4rfmfqttYiWhFDVpBiLf8b1mqtdDfO1NTd
         Hnfplc86zSGc5yFqajWxrFtWL1krDxnjyMrGXXPODHSSmi39GaBdBTabF30rHNMRQ7cw
         SAsw==
X-Forwarded-Encrypted: i=1; AJvYcCUXyzemPlwOAa5wBDWnBJYNUx34U4I8JL7fOtRs65wOpoUh3eLr1Bl3u8qWuTRynpeY4qGFGMk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHAJ+dJoC3b7BCDupAJeYNMuqrEOp3CmfN4uKjpUF79IZiWIf2
	x1+cNf1XQB8eK/IKNRBoyJ1vO9slkBOV+ByhQobZT+Uf1bTu3NwRkUFw44emvnsC1QGLN+rp8Ur
	acsSbRQ==
X-Google-Smtp-Source: AGHT+IHqKKH3jALoT7jRe2OHIQ2mXXV+pELYiJKGwKEjf4ZIM+twJ+5jG3TjV8eGRlfpIUNYgujs+bg0n4E=
X-Received: from pjji4.prod.google.com ([2002:a17:90a:6504:b0:33b:dccb:b328])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c8d:b0:33f:ebc2:63a
 with SMTP id 98e67ed59e1d1-34082fc2cb0mr1192488a91.14.1761855011296; Thu, 30
 Oct 2025 13:10:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:28 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-6-seanjc@google.com>
Subject: [PATCH v4 05/28] KVM: x86/mmu: WARN if KVM attempts to map into an
 invalid TDP MMU root
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
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

When mapping into the TDP MMU, WARN (if KVM_PROVE_MMU=y) if the root is
invalid, e.g. if KVM is attempting to insert a mapping without checking if
the information and MMU context is fresh.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c5734ca5c17d..440fd8f80397 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1273,6 +1273,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
 
+	KVM_MMU_WARN_ON(!root || root->role.invalid);
+
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
 	trace_kvm_mmu_spte_requested(fault);
-- 
2.51.1.930.gacf6e81ea2-goog

