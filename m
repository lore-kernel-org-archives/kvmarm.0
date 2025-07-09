Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8892291C1F
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058819; cv=none; b=CQh7vHOr4FW6QDEEDUjYNQ6IkcMmsSG54yW7lPTEPOkZUtrbv3cYtZlZUzRpGqBOPC68wq73afXLTDA1ZT+paLbDyDEkEhJEwZ4aEYmM2/dbFUyIPoV0nqgBGnC9E+1N+KcM0ZCMw0tJiYPstPfmFFoX2wmDGklwIwe1VzqTgCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058819; c=relaxed/simple;
	bh=Ng2OnRI9T1yqGSHhwkdj3eHMpNrupGn33LATU65cqFM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z0zvdylDgilcql3x9pPETSm1CuI504MWb4HX+dn7w/ned8Yx0tlLuRKQkJxg3f8lGx+5gs9Np7c1QFsDac6PToFyOHRHbRgwWbIbeXom9XsvZBdlcjTaDTri3/2bSsRH8msShhWopv9vvADUCywnD0ex0Im0AgM6BFlR1MuofBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HfS700dW; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HfS700dW"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4530ec2c87cso39098565e9.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058816; x=1752663616; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/RtWvM4D5LyGRaCThwRmNrNlLHpmXl4WBXByPYLdFVE=;
        b=HfS700dWwXDVRdNIdNmi9FmddNSqODSZyMxP8B0qgwPQyv45JWkTrTByh/p67OAfPA
         HnMNlN94459rwdkwDpztTec4PN6FHo0JLtrT/+fHlP4BwPwLbJJs3Fl5Upl90oc1/K3V
         tLtxjbm6Assd/L4X2cTSvEPZRtx9IS1E1w4Oi8hrvpfxzAAGn7WAdJ7ZAArw24fC2r6z
         srzQ/Ki1WWc3pcTTBcYkHZ5FGJdLBycS2ya8rl/ZfZQ281Bh2c7+oKLFZVBz8cCW3cJR
         dQFuANB0Ya08HvsDLPWlS+NY8E1IMBcpl1Az8X6x9Qn0oDST72oC+0N0KwOOMIzCyrKA
         2Fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058816; x=1752663616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/RtWvM4D5LyGRaCThwRmNrNlLHpmXl4WBXByPYLdFVE=;
        b=pMw6ECXUFd+Uwz1z7mH043sX8HfxVNSO+XyVEAFt469lBrhmIJYrOAw3bUuKGIfW74
         7FM7exg4br5EFSTnTjOvHsn3oDMMBhDtaw/tDXvnQdJUmja7suMNYjvxbYkC4vSlSs4N
         zlnTLIQ6E/0uEvwH3gEW1wWEDkvV9C6ylAp0by4qyiwRvKNgW8DKUpQQ/mcaNjb/LdOH
         ZPd+xjxwdnV9/iANFlxuDZPdg5zFkkWUOBY8pxkTrP/JRfNOMZcCpNnsXGTMLaODMb9l
         Qe3J7fvx3Pme/wOmMnrx+plyop/Jq+53jdWS8Y1dpFtSEbKyX4owdrnA/vi3x77olqL6
         i+xQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHfanRhzf5YYGKWDPxa18zwnTYxQzMelnu97NbGnML9FaAIS5qZ7icZVcW8ooWbvVY4KBYGYE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOuKaxCN9puox0awf7D6eJOjs2VZvf8DACoOhLVL7ZbJ0PQEme
	PB40zWyO/sbTT9Q3koZZ0Eegsc1j4xayE2aEpEguSYrBnjREvclyn78YACdKXp6OPpSjbsvbldK
	INg==
X-Google-Smtp-Source: AGHT+IGbecgOoimuhgq7GBsyMfiouaKkyce/B8FWdopk44Xy71H+G8NRPUx2Bg44d+1+Ni1BCYWnqV0plA==
X-Received: from wmbbi11.prod.google.com ([2002:a05:600c:3d8b:b0:44a:ebc5:9921])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:37cf:b0:450:d01f:de6f
 with SMTP id 5b1f17b1804b1-454d53087f8mr22468195e9.15.1752058816177; Wed, 09
 Jul 2025 04:00:16 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:39 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-14-tabba@google.com>
Subject: [PATCH v13 13/20] KVM: x86/mmu: Handle guest page faults for
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
index 6d997063f76f..cc4cdfea343b 100644
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
 
@@ -4537,13 +4537,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
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

