Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1A52D837B
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572043; cv=none; b=GgjsnpKkej8xefefpM3E+spEaWgAQjmsKS+7Yie74NQGaqHr77Es+nDoYlDhh9wROskhTmUmAqY7M/MuoNuIilfkQdiK/QH1Tp/z145EBWzpfoNmssq0bzcGnXufQBwFmuoN6vEW6TSGQie0Odeu85DwJ/76KJLOgk15nFXmMwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572043; c=relaxed/simple;
	bh=FIjOwg319hyH86RPEEhW3mmTzKvA36dK9inNaZgydos=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FLQIr6VklNBBFF7UfwP0p8ppDMfo6y+PsQseIDuHN53F5NLzz9lC69D07HhrumYlqx5xoMoTEl8v+J3cZQ4jfDX+qKjXtZ5hJcbsCcIQp4Mvumeu7oZPY6P8bcyr1Xf37cfP/8zp9Cu18tlHkwXy+diZU647SRjShnq2zHL+W6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eiuJoTyf; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eiuJoTyf"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-455f79a2a16so29649875e9.2
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572040; x=1753176840; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3DYVEI39SWNvG2Wl18mhIKrWLwyIMRXgpmMWGxxyFcM=;
        b=eiuJoTyffDOVSCFL9NgF9/PCgQZ9jIiE7iaRM+EwHOCVWJ9CXTXpEFRuZjG/T+4QlW
         7RSvgHxTTq74s204cMGtUCo9yRRE1wr0pvWWFvDE3WEbIpt2s27szG+ylkkBa0AehOQc
         sYJSglVVcgdpCrYaRMc0LRbTpNfKG37OpLXPdwbf2nvd0tcF40RweSSVXw/GAiSbi7dP
         QOdV6QTqDwzUqAxvflt1PRk9H0RcCLFrMAGlFqK3a3zaFA4qTmWzF/dkwUvIPBSYPnaS
         cYDBIVtJ2NKaWBphPLD18gQgCXc+LjbAFr/ngYgNqttPBPKB9qKF3fAN6aiFVCvqE/bX
         qHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572040; x=1753176840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3DYVEI39SWNvG2Wl18mhIKrWLwyIMRXgpmMWGxxyFcM=;
        b=YYhmUjXYflLucT81V6ZQGrSE3C/NGgQ+uhuz+XFfYQv/qV1nCuZA3BC34HAn9cFMrX
         3i9HUBIOrZAR3Ss9iwDcws0YESZAmkf/+QEBD58GcX827nVtNBuT3QY01DTM/cB+vBIu
         z4IK/9m9xAZLH469vPndkeAQ0Vt1QSL+UIZ85WnP7bHL+vg8QVRlu1vIGQico494gSqE
         du+Hom+x0YQBuupwsRK2y1cWw6ZUeeD0xJfU0z2YqF0VMgZFTFjAdR6qbUWFBTf507Ld
         G+Dn1zLXjhcVw6Ie8Nfl0nvKLh8FXt5pobAvL7osKzfWursYP+lBxW0/RQ1UL6fu/HOI
         TKZg==
X-Forwarded-Encrypted: i=1; AJvYcCWZ+WeuGstAoMlHWF1kiqUc4EUfxQftqGxBSFIVs9u38n5IdgfRDBCiaH9HfURQ5T74et5ZxvE=@lists.linux.dev
X-Gm-Message-State: AOJu0YynlPt8BsJxxeqNtLRQsHWbRIjlv+d2q8iFBMTmls26gDW/pnrF
	cRg9iLGB7VCC5PJU19k4MpP2iWcqKWOgvi8ELRwaPQN38DPGOubhWTuUCtQelDk+ZbC2kA+GU1i
	oIQ==
X-Google-Smtp-Source: AGHT+IH9DNCTDPtVSANZIsCSp8MKaKu0nMzeS7WOeY3KHG9FbMBNN5PsCAbOczJ3kY0XI1NQSbVglZ8RBA==
X-Received: from wmbfp27.prod.google.com ([2002:a05:600c:699b:b0:456:17a7:3772])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:310a:b0:43d:4686:5cfb
 with SMTP id 5b1f17b1804b1-4562751c28bmr16103615e9.27.1752572040145; Tue, 15
 Jul 2025 02:34:00 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:33 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-5-tabba@google.com>
Subject: [PATCH v14 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
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

Introduce a new boolean member, supports_gmem, to kvm->arch.

Previously, the has_private_mem boolean within kvm->arch was implicitly
used to indicate whether guest_memfd was supported for a KVM instance.
However, with the broader support for guest_memfd, it's not exclusively
for private or confidential memory. Therefore, it's necessary to
distinguish between a VM's general guest_memfd capabilities and its
support for private memory.

This new supports_gmem member will now explicitly indicate guest_memfd
support for a given VM, allowing has_private_mem to represent only
support for private memory.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/svm/svm.c          | 1 +
 arch/x86/kvm/vmx/tdx.c          | 1 +
 arch/x86/kvm/x86.c              | 4 ++--
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bde811b2d303..938b5be03d33 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1348,6 +1348,7 @@ struct kvm_arch {
 	u8 mmu_valid_gen;
 	u8 vm_type;
 	bool has_private_mem;
+	bool supports_gmem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
@@ -2277,7 +2278,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
-#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)
+#define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
 #else
 #define kvm_arch_has_private_mem(kvm) false
 #define kvm_arch_supports_gmem(kvm) false
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab9b947dbf4f..d1c484eaa8ad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5181,6 +5181,7 @@ static int svm_vm_init(struct kvm *kvm)
 		to_kvm_sev_info(kvm)->need_init = true;
 
 		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
+		kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
 		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
 	}
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f31ccdeb905b..a3db6df245ee 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -632,6 +632,7 @@ int tdx_vm_init(struct kvm *kvm)
 
 	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
+	kvm->arch.supports_gmem = true;
 	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 357b9e3a6cef..adbdc2cc97d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12780,8 +12780,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.has_private_mem =
-		(type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.has_private_mem = (type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.50.0.727.gbf7dc18ff4-goog

