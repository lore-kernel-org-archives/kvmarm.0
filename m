Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A963C292B4F
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058816; cv=none; b=p/gnUxuPcX7VSbY4eUSXXaTvEWG1chP/bKEwqpID0r5kXI13UZ1TdiAb6p3ABUPUxZf0qUungQ9DhIsT3/mZKtGztj0nZjElvZntCCgD9nUk+ItVq6QBbVP7UQCC5TRZu4CxXyKN8kV2kTsEFjXXoRYOZHLsOtj1abDg8IAhHIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058816; c=relaxed/simple;
	bh=fnBHlQaIaKmvu5+hck0Rmd7IjKt+m56uo5UueV+jRQs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dFXKXW8fKrL3Ukci557EN/k5trTbGKL6xsO6KQksMaW97+XMArPd36kThxmjvYEy/T+p3AZil25YYGVJIOnhMNauiIU5vvTftO03nmhnNiBmehE8BuYuL+4ufT3mkMPzjRObYWgAtAkRp4bkSaYk69Izzfrty1wWO72+p0/pBQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aAQUNdkK; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aAQUNdkK"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso3564124f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058812; x=1752663612; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Auu8uvlzSKOU324XIVBTX5mUMTIARGkUiREXwmkL04g=;
        b=aAQUNdkKz9SYwfQgyKvMG2CqfDs/fsbKfY9NkggCtGcO0sqeHfeBVGDTlsTMGm/Rvc
         lFFgVIdYAZLND4XYZnY+yRx4kPufJO+H21K+LJ7HUVdTalA4Qqw2NTmTm/tK1VwFL5cs
         CfAiRSfsPkmNg9738UvI5AyatMFUlovRwEtReQA9JykC1y9Arjs74R7l8S9RwApamwgQ
         gcm2pqWHtVM2nGBC+WbHAheaAYgNYU5pc/L1PUg2bWo3Qq4RyTgT4wNZ/ANvU1Ovss8D
         /JCy55Zw+oPLrZw4IFLB99F5Gl9VQ0Bwgh/4Cg9/Y24VzQ5oWTtl+/+1OzNUVpeFXXef
         Fzhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058812; x=1752663612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Auu8uvlzSKOU324XIVBTX5mUMTIARGkUiREXwmkL04g=;
        b=DdGpBeeu7JTiAWETbJZPQGnTysJbERTNJjX3yTgCTiZa4nhZnzfNMY93C50I9OkAtF
         VrV0WGq7BezNrSGYeizlrd0dGLDUVGHawVPcoqoNCyqiTwjjtvjpDbcl+QnAt2beS+kZ
         Oaofkv/bgvpLpCRIsUNNetMW0j05sQjUZvi8TCsYoJhGODzR/+TFXRxFGTcbb1xOo6M4
         zNgzEJbB+nC0tuQhlKpzUS8rQRA9gXODE/R1wutb2owPF5UIxzWpzwbPD6ltMbu5KXVw
         t9RLvjyqi7xEik0LlvBDYu2IaIg9fLygN5VnyXMrriQmoD1hlWEVA1blJxQxDp2ymTLB
         0Ekw==
X-Forwarded-Encrypted: i=1; AJvYcCXUk41dyedjXkTPvyxlTziHWw/MOl4Zki4zzuZi6BJNwkyvGCO8zZxeAUCJujYBfS3Nzx58RbU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7HX7VL8VZiOjhqVUl00c++Za1KLHFc8BkE/8AWMyC77L5bLwh
	AxX4dlAkzlo5ebmIYBNlrb/5Wyr5jO+QHBZ17a8isXno2Y8FA9tv2LCE8f1LRbF/7wH4iXw+mzq
	Q1A==
X-Google-Smtp-Source: AGHT+IFPeiRjT/hk2eJKjjXIwZ7MAsw5CZ9JjPkhCk3imTKy+4sECTwl7nHXrtoS7dfr9P6aVkCK1zl5Ww==
X-Received: from wmbha11.prod.google.com ([2002:a05:600c:860b:b0:453:b96:8ef9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:3c9:b0:3a4:f787:9b58
 with SMTP id ffacd0b85a97d-3b5e454249emr1500559f8f.58.1752058811734; Wed, 09
 Jul 2025 04:00:11 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:37 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-12-tabba@google.com>
Subject: [PATCH v13 11/20] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
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

Suggested-by: Sean Christoperson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bb925994cbc5..495dcedaeafa 100644
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
 
@@ -4513,7 +4509,10 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
+	if (fault->max_level >= PG_LEVEL_4K) {
+		fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
+							      max_order, fault);
+	}
 
 	return RET_PF_CONTINUE;
 }
-- 
2.50.0.727.gbf7dc18ff4-goog

