Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37392D6401
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572058; cv=none; b=h1SlhtMvAhHhSdWF9+fJ04yZhg1pG3oDdP+es3XRmzhkd7b7j8n2I8NHIFqo3Y7gPnCh93INBMOnO2LnXYxnhYwYWEi293/zpWBFaUopNJmqj8Ywx0hWxeE6egB1yTKrxGNoqk1T75Rvc9XmOc0HVMji/kju73OIR7EXs0G+YIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572058; c=relaxed/simple;
	bh=5SFcmIaZT18BqEoeZQIYRV1Aqypru/hVXQDtZkdpxP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MLmyze9bdx8FTf43DkDnLRGOBftlqp2QaedQcMKBibu0VImdbXN0rsemTUmEQ8BY/8H23TACrlCSGJ64zivFtDVREZPXWv+Sn57tafKwZCBUfAyk6JDPyUCKr2vvBs5CeBo+zK1yZyoVz7U0k8y3Q+0//79Gm7yJMd8dhqQLo40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IMr6crA4; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IMr6crA4"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-607142010bcso3908981a12.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572055; x=1753176855; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NswHrgkdcqxmOhQmg+I1ZftODzAqq/smUBNc/8jSsg0=;
        b=IMr6crA4FFSMJisxn9ynEGDDbVhibvswq66sM8sfW/xC7qEidz975Ydnt87vCEzIu7
         m7wHwqhxya2YALTk9VEM2/vsV3WdjeIglkhootLwpVtUD93ybmf/U1XFbqdi6PhBJaTz
         ELMVCPAHY3aKQUxLJP1DTI8fH0UkeQrJ0jHp8u+PXH+Ox5SGAPf0+9FI5Q5KbF/v62hV
         X6qJA5G33sbRC5cwlxSRJas6ujpaoGrDzZWpqNm08w+wVNEhsdAM6TbGiPJn9n/J2qmw
         9c0lcmt7C+f2jB5Trgha4+Hum9okf3WERTgmGlsxcz/kyV1uB0ernwH8e+ZPRee56tGO
         2tLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572055; x=1753176855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NswHrgkdcqxmOhQmg+I1ZftODzAqq/smUBNc/8jSsg0=;
        b=eieADkbShuh1tYstuoNihyLk5/v76AHbtZAR1STZhKPu0BWC+11beO8wwwTt9DUzmr
         sXyD7MFiZ9YDATI4sEOC3VviTDUjRhimU/i9xlZthVCxuT2JMjVOLahR61pHq+NMZbej
         MqO3cQrgFW3f7tHqlSN2+xZ3L3CeUDxEpCKdKytoXlUOnMmTcYcOFvyjEvd9dkNQ67qL
         i6F11Mu0v6Cfl7yj6y/NtEpz2ocZv4FLiaZMQBOCk6vOk+aE4nn0f1n3LxGAwXCgLPmx
         lHM5hYepP/Q0apNTG2OYkUlDfpFj4142GRULQyehDdTgqTpInuLMi3Lz5Qc3Mzuxmbvk
         ltkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdbS+qzJdOCktxOBEe3nAJml1sXsuBn3xH4ebxaWbyNx71NuU3W9xts/m9OBpP7jUgbAZQBK8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5eX6wJiCFs+2faJRFxwMO2DH5wYZsCjCA2HmO8YV1oixR4TBX
	EkhyU61w8Cp+4y8D6dU5hbFD+R/r/l7ZxbGMJY0cfgn2BaTghKO0MqM0VeKf8isZJHWPXdhuVdN
	reA==
X-Google-Smtp-Source: AGHT+IEDLe189qOiRgDedu5bKfhg6mmUJkhqiiy6MmhlJTVyAYMWtzw6N/Xpnr+zd4xHJ/TAYV4yM5jmtg==
X-Received: from edbev26.prod.google.com ([2002:a05:6402:541a:b0:609:287d:ce97])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:22ba:b0:607:7de4:598b
 with SMTP id 4fb4d7f45d1cf-611e7636978mr9326687a12.9.1752572055050; Tue, 15
 Jul 2025 02:34:15 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:40 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-12-tabba@google.com>
Subject: [PATCH v14 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
pointer and rename it to kvm_gmem_max_mapping_level().

The max_mapping_level x86 operation (previously private_max_mapping_level)
is designed to potentially be called without an active page fault, for
instance, when kvm_mmu_max_mapping_level() is determining the maximum
mapping level for a gfn proactively.

Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
safely handle a NULL fault argument. This aligns its interface with the
kvm_x86_ops.max_mapping_level operation it wraps, which can also be
called with NULL.

Rename function to kvm_gmem_max_mapping_level(): This reinforces that
the function's scope is for guest_memfd-backed memory, which can be
either private or non-private, removing any remaining "private"
connotation from its name.

Optimize max_level checks: Introduce a check in the caller to skip
querying for max_mapping_level if the current max_level is already
PG_LEVEL_4K, as no further reduction is possible.

Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: Sean Christoperson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bb925994cbc5..6bd28fda0fd3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm,
-					struct kvm_page_fault *fault,
-					int gmem_order)
+static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
+				     struct kvm_page_fault *fault)
 {
-	u8 max_level = fault->max_level;
 	u8 req_max_level;
+	u8 max_level;
 
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
+	max_level = kvm_max_level_for_order(order);
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
@@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
+	if (fault->max_level >= PG_LEVEL_4K)
+		fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
+							      max_order, fault);
 
 	return RET_PF_CONTINUE;
 }
-- 
2.50.0.727.gbf7dc18ff4-goog

