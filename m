Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893392C327A
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829760; cv=none; b=DDGxFrX9aXqUCmHAAXGkwzaoQVqQVrJ370NOfCaQ8xwdShBD8PCsyWf1Az3oieDHm8fE6ejvossLvNYWk6PGS9Wippn0ELP22moXrG5ABimmkYqciW1v6R0FHNFUcFWUUa0xc3Bja43WR4wtbUb8LBBTzKqM43cxcfgTYlPSdH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829760; c=relaxed/simple;
	bh=tSmg9vevb3jqaRkYY5Aaxyc4WM6Wx1gkdAMDVUweHc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xto1KuJTCKp330dRfO1r7cfEpxFu1m6NqcrFZ57lAwydod8Dn60cbKcyDZ0cb3+KjzkNeLTuSP66hkDHAbBX6wCg2ASGRZw4bOkP4/JG1CoBtrtgjYinAY82xySeH4Y/2FwNkpBrmTdhjgM2OzQB1bscK7Gw7OfSO3QdHvCqQwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0er5NYZw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0er5NYZw"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f030b1cb9so3516677a91.2
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829759; x=1754434559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zsUJ7ZFybSscOwB+F/7yDFweXn/Ii9vNr67NR9vaee0=;
        b=0er5NYZwg2SltqA21T7EiKElWHUbhqx3lmC3L049Ej1CjQlffhWAHywajijZcDPzyz
         apP+APPqDqstbA8PG7dHFA6jNxuqIbFixf00Kqrl0dDIpemmx2C5CnKSE155X6lSkSqb
         l9SKF0PBv7TxqXK036S+8I8qcixf0xlUno2z8Zfwm/MKKGt2C19A4AbUz8Kdm6RHgc/2
         mQ5jUtnoXVeQoh2zyx4Ij4/QPgS25x9DC215PNM4+/SPNleOiybcsN39OlX0UvghfWCV
         /yntt7YGxRvZB+1smr/PUsVEhhIXpZ1VbISlp/bFlPZdXch6JCquwFOgB5XY8w27A2HM
         xcxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829759; x=1754434559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zsUJ7ZFybSscOwB+F/7yDFweXn/Ii9vNr67NR9vaee0=;
        b=ngCtNoa8/uMEOoeLzLpr+IHAgxRVLzEJqwl4mek34JLzKOVl7GQrQAZrccx2fHhSXH
         IWoZWk9gZMzTvTvC9pVxIK4txZNOtF6vNAxw8M2EoRfvR8yF8QQIruRUPILKf+JvGZvD
         viMiWDvgrwMtPhPxxFWeF3bkK7cTTh5hW3zbuBPztKZ1bb/TUUk5ri9UeJqhoUKnASXx
         2MNX3+CjXW5FwBnJ5B0mUivt3zDqPrSrl4LwkBWDRmBcCVIv/Q7Cb/tLD9DdAIbSj0ak
         mmFU70SRMqO0opN5Nol/zdABJcz34Mdo7sDplBVt1rXoexpldjJIuRfcbE4LucBnICA9
         pORQ==
X-Forwarded-Encrypted: i=1; AJvYcCVl1hFfuSZ0IE146Qx2yRoN+p+L1AkflnRNhVMyq+SHl94BOlAs4TJ83e+PpYjNGvzeCLqPef0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNAavwekxG/onVUPX8qOta0Ng7SmnJr1LxElvGcJahnJunaBRA
	k/tIVUWmErW64WyrLWdmqaLxnnm8D29KEcVk4P1F2NwAWwwwLyUxbEUSlfKwyhiVpk2AYrDgoHC
	yIDJilg==
X-Google-Smtp-Source: AGHT+IEUawy8XEGsXpdKDRLNNEWp47UfSJOlj3wwR4Kg29zUXO4HT9ko5KQTWasgzc65ODEqhN4o5kIR7eM=
X-Received: from pjsk9.prod.google.com ([2002:a17:90a:62c9:b0:311:462d:cb60])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:31f:3029:8854
 with SMTP id 98e67ed59e1d1-31f5de5561dmr1600493a91.27.1753829758931; Tue, 29
 Jul 2025 15:55:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:47 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-17-seanjc@google.com>
Subject: [PATCH v17 16/24] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
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
[sean: drop the helper]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e83d666f32ad..56c80588efa0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4561,8 +4561,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				 r == RET_PF_RETRY, fault->map_writable);
 }
 
-static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
-				       struct kvm_page_fault *fault)
+static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
 	int max_order, r;
 
@@ -4589,8 +4589,8 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
-	if (fault->is_private)
-		return kvm_mmu_faultin_pfn_private(vcpu, fault);
+	if (fault->is_private || kvm_memslot_is_gmem_only(fault->slot))
+		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
 	foll |= FOLL_NOWAIT;
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
-- 
2.50.1.552.g942d659e1b-goog

