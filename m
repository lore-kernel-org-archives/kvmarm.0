Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73502FE39D
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769669; cv=none; b=iULqdKoY+qvdOULiwEa8uZuH4l5U2x2aMWWR9Ed/bwAeJ8z8NdiGF6WYoBVKVsIwu2vovnu8Dy89HB+l4dsC7zRriB4PPDYUDwnM1mi4S9XGdWXlZZdoyoknGdd8H+hJT8rd9aPgulkLQ0fx4Sa+qxv44DuXbEyy9K8TxFah/k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769669; c=relaxed/simple;
	bh=WCxjveG85jEEirX3+ZEjjVpqxosxj2gmLmYBllHeBRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XhtNQvRuOMsTR1kCLKcYK+beBa8DpryHzKVXDQho4WATHX0kE6xXEEF+b3u44w8wTZxXPtaWX9+YKkw1Hm5IXx58lyUpHhjQhxK/eKco1JB8XmaqmDfsoa4z+WfgiLi8VYjdxNA1k1vQ+/0kur5VM9xeJo2rnpNcp/AYDGnFI7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VmnbAkY1; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VmnbAkY1"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so8576005e9.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 09:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769666; x=1753374466; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9hcizvzxVzWO4/kQqjXHw92JJzwP/fSnU0kfx5Or1Rg=;
        b=VmnbAkY1bd8jhNVcbucANDk5cKLvvz4MakLpyizKW9+Zsrw7UuWYA1/GW/oEkpeYOI
         EqccfSNeh9L0sFfi4q34lYZMJqiED0HMeOee9UoNE9ZJ0RCXlb8c7RnmBhljd7Mw6myV
         ov5IybSI9CXdch4xA0RrhKw+D98lgjbpyEUyAJ0n21p7G57BEe8ZxijLmPKmEVfJdssO
         pX8RmJ+j6KLG50UUAuvySoLcEkTor2oDIKVfnp4LXct1em6+I/CezZknMW8Hu46XvY8S
         BFY0OtublQa/I+QYH3M9flvv2DksCLCm+T5AcQYGtbGLTzoZhSzWg1yWqlxFa0g87tVV
         duJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769666; x=1753374466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hcizvzxVzWO4/kQqjXHw92JJzwP/fSnU0kfx5Or1Rg=;
        b=U2wb8IyI4Yqpo4BOhatSM+UPQ97493JYAw6DDuB3m+b0opamd9P8/f7ygmZ63e7DIx
         VbZMN27IeWTz1eNMKO5bGLGgO5NXQ94SHShjABiMabXm298qAI4iYSPEt1JUfCyaSMAY
         oIz2cBwpniMpo2I7e1k2/bdzSXFv94y+Fomu5EzDvhgscDnyigaxVTkl/C8k3NTiXJJb
         EpP94hxlKTcRMEWaHL1ahakvZVXJFQUqK4QDqbL9ldL8Fa1DSKqXM4EdD86YBE5IU2OO
         idDt+uarDQU589zb/WFLxMs5mMb/Ilba854oQG3qa9cl7Ox3NL9PiwaaEvUqK6jx3G2j
         T4sg==
X-Forwarded-Encrypted: i=1; AJvYcCV6w/tD/DUi5eeAJxjK9GqBRYstvwalBYOXt/584vy8KWqYD8LhRiNXYOJE4Kuw2Cu8Mdk8X+4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8WG6z9abeqRUZs8Q8mQ7UyK+5ohlMrbfEGsrNbmjmnw6lUr/o
	gTrUKFQVm6/HLPzezJfgeGCvu4yPVhRQhKbPvbzrYpD3/LPXQQErAOLxjH246tZlPIkugX3P92d
	/xg==
X-Google-Smtp-Source: AGHT+IEEuq7D3nYp2xk7nCkef5mMIaWIaIcknj6Ge3ixESMVMRr3DmDdSG+66XhcfnXqgmLH5zZbYyYdgg==
X-Received: from wmqb22.prod.google.com ([2002:a05:600c:4e16:b0:456:26d1:4451])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1912:b0:456:2020:165d
 with SMTP id 5b1f17b1804b1-4562e2a5cfcmr88497235e9.31.1752769665804; Thu, 17
 Jul 2025 09:27:45 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:23 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-14-tabba@google.com>
Subject: [PATCH v15 13/21] KVM: x86/mmu: Handle guest page faults for
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

