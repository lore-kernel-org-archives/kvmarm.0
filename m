Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EDF2DA776
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572062; cv=none; b=SnOwkJPSvAYk320I/caOOcBPh4/ufa6Whzeqndc2jgpKJtfSOuGLoSS2SSQlV8o7XiNXfVX9lWqIGQ85znnMaZqi6ikgOnxzCHGszJcocGnfqWWdFy+DJFdFSzhZ9qCKp64omwPBBrVbK8QENV63JfIcxK8WCwdvfgfdEpsM9sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572062; c=relaxed/simple;
	bh=WCxjveG85jEEirX3+ZEjjVpqxosxj2gmLmYBllHeBRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VxIWCXvXWN8W+ttu7SQ7Mo2oLBWAeUhwvfsUWeX64EQEpwhqqd+O1WWZ1P6wf/p72+YOaJoRF26VNev/qSx8dWAehg8PW6OWKDww6sWqthHCMVhecI+kVW0pCQ8BAChm8GVjSKauEj5oeXS5LsW7iwjuD0quRququKT5NxhsDK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1QWPZZbz; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1QWPZZbz"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4fabcafecso2559028f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572059; x=1753176859; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9hcizvzxVzWO4/kQqjXHw92JJzwP/fSnU0kfx5Or1Rg=;
        b=1QWPZZbzbEOxuPpsHoksGreILd5oF/kLmZrfZmlNFcW5akaVtt73Ax4ge+GdEqyG4m
         7m8+cziuKu0ul+t9s8LCEfuOgAbovFSGjUjCTxusM1+SNw5Yvw8fnPzOM74x66TEVEqK
         +yel6XxJbjX4Jvm9Q68oDYBiqkKtdAVpa/Xgp7qPbSlaAi886MMDBgLwH7dSJxnJIthg
         pQnwXpLLIR5iYKD3fRnL/Y0eJZi+pTby5UIULC7rzjm9BYJfMT54zW8mwp5T2WokKn5j
         SpblVAvC7WIJaRUydK8N1p7j8Fap/C1+Mf2pK4Ig+Cql5vfuTGly3DmxytQ/DKXPwbJc
         FioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572059; x=1753176859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hcizvzxVzWO4/kQqjXHw92JJzwP/fSnU0kfx5Or1Rg=;
        b=bjphk+f+FOI4cm5NJLLWC7wZuVcMmbY290Slj3uO2s+Oy/f3Ld6NumGNBD4QOT1TdN
         LA+l1hGF0cjY0uAV5Q8VieMtwO6jT5l4lSArwBX4eB2zb5WMK48+p/FSqd1hqVXOoPdI
         WmAjK/zdUDGacw2QCZo6IELsiRTvNVueOdPNja9cK5poo1iWRKxk0SpzOJT+HtXHpz1T
         O/q4hOkOrxcHm4qSXoWYVd2YurmLNWCK6XE4OTS5mlppuokUxliEEqpcOt6/v3i+95UK
         FkfzhHE1q5B2Ek+B2ltp0RNVcrSAxhmXY0/TTBr7yMEIlbHZsT8/bK2RSQV//YDO9HdL
         b+BA==
X-Forwarded-Encrypted: i=1; AJvYcCWSPNnYItXUs1K0wsFqA3xWA3L3zx7TEpRSzePPMVLXGkZqmz1bU+sI9D46IfG0w+5/YMSeW7s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLby7qSKJ0QnOxmBKuRC2D6SPmxL3IX3NDzxyFG27dnuMPSmWa
	Necg8ujRj5z4+MOQC3jqVUbpy8leRQxDsBwO01ipz6fNsMtEqn9rmJMB4NM6w6tcfoSSMIRHo/4
	zlQ==
X-Google-Smtp-Source: AGHT+IFT79H0JMSPNQLJqFCm8BSQjlOEJfCNJpa0mFxk/CyYzTNiLJDi9MX2K2oWjDCLOvzRxItf7JYjLQ==
X-Received: from wmtk7.prod.google.com ([2002:a05:600c:c4a7:b0:455:9043:a274])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:400f:b0:3a5:2653:7322
 with SMTP id ffacd0b85a97d-3b5f351d846mr12559005f8f.3.1752572059375; Tue, 15
 Jul 2025 02:34:19 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:42 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-14-tabba@google.com>
Subject: [PATCH v14 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
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

Update the KVM MMU fault handler to service guest page faults
for memory slots backed by guest_memfd with mmap support. For such
slots, the MMU must always fault in pages directly from guest_memfd,
bypassing the host's userspace_addr.

This ensures that guest_memfd-backed memory is always handled through
the guest_memfd specific faulting path, regardless of whether it's for
private or non-private (shared) use cases.

Additionally, rename kvm_mmu_faultin_pfn_private() to
kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
pages from guest_memfd for both private and non-private memory,
accommodating the new use cases.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 94be15cde6da..ad5f337b496c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				 r == RET_PF_RETRY, fault->map_writable);
 }
 
-static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
-				       struct kvm_page_fault *fault)
+static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
 	int max_order, r;
 
@@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	return RET_PF_CONTINUE;
 }
 
+static bool fault_from_gmem(struct kvm_page_fault *fault)
+{
+	return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
+}
+
 static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 				 struct kvm_page_fault *fault)
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
-	if (fault->is_private)
-		return kvm_mmu_faultin_pfn_private(vcpu, fault);
+	if (fault_from_gmem(fault))
+		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
 	foll |= FOLL_NOWAIT;
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
-- 
2.50.0.727.gbf7dc18ff4-goog

