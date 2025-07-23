Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386C52E040A
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267650; cv=none; b=A8XX5uxOZldXAW1BPMhS1tq7PSco92wblYWD6HcPB0uKWnvov242tRRt6TO/cfOxJ51+mNMcaRVNnSrXQCNLwOMCEGX6dg6XCbjjSEF5a0Qac1Tjz+PemRo2DYmbIa9x6tXRTc4KqGkHlAF25OhsGOfAdKbq1PfainOKQjWx/yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267650; c=relaxed/simple;
	bh=L5CyHeZZ4MlbfulEBtmqhpa4/L75Uon1TBy3oHxttEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j/SHJqWIX25MhgOEZlS4XKp6WvKRT6wRGN8ui0df3s6m8oH0vTamYM6sY7wJRvtYuiHG/4KciJO64SlE+8oy2qlkUrGGw65dCUPTTDiDNo+wV6Y4Uy3hVUKo+SKedznivJ+3R5Y4oWtU+m+m2tyVZOv3CBBi+AW1m9Msr+JVoak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D8IT0dUY; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D8IT0dUY"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-456013b59c1so39033055e9.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267646; x=1753872446; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=klSLvPZdGJf21T5CxWAvpof28nK2FqTvAw9KK02b9rM=;
        b=D8IT0dUYP3Woc6sLu9XGwkFAwapL9l/TwBcxb/LtKeCkBMyEOz9sD5D4Q0fWqYO4K/
         aOAQn8SXFlyBamRTg1OxthPgxSHdfMHWi30MSixl5PEl8yoM1ZqfjseZXEoxGiOKQPfq
         7LsSJqqmjKr2f3gycnsYhrBWdoZUO3oJCKF1DubvBWOU+M/BzYMBhupcXYhfKRx1HS/B
         jjiR3PY+1KCDiil/APyQYDrZNP1aD9rqqgQTCXV6yFZyW7mv9lVlugYlzdm4OaeQy9sr
         5dlYN2o3T85md3DXXZLUCQm7tKuKz7RsxpCo/wmDmGDISVvuKPPQDWKaSz5qekvc2vWS
         MJvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267646; x=1753872446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=klSLvPZdGJf21T5CxWAvpof28nK2FqTvAw9KK02b9rM=;
        b=fwZ5wD3vCJmshzs9YFrpM+wTdMgbOOTpfIV9NM/Z532HYdniUEGiY5bI5iMqvoTgTC
         +5aRUkqK+ZEiZOG3tXAoRAykvlf3W8OVYO8km8d8twxNbEjo/C3B9MzFdCS59WJGl+zn
         tMYn8AskPcOdF7pjtltsTr5AjUF0GB6wvqnWiphfyrzZoXXAuPNNMSi2lh2Mmc6caiTD
         O9arp16sh//8XwoUJpHfs1vJFUjvjidkfQ+7fa1+G8CMfsjiM7o4lRa8RpkuzfwnOlkK
         8fLK34cLZXOpNYjrBo0OZ989HACoqW2t0tz1cR6tjtAC6fpqzL/0rvSLHinNTECypSfb
         3BvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWGYvUZB+ZOEpRjgKOV2ZMhK/IDux+jtNQzIz97xu1vukuRWa25ECShT8+ZE3xvJgGGb5esec=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwHFWFBeW4CtWBcnAvVr7RricL9fsG2uxhOJ+goQhzGDlAFUbp
	ZdOch8bcozk9uUz7IHeCRERnk1OqHWkUSn9yR1SoX1yQKakw7Mbfsttm/Eci1IJmLXuA/znY6c5
	R+Q==
X-Google-Smtp-Source: AGHT+IF9GujN7e5PEevnbfhJVmv/zauyrMQPlcffBVgGfUsoXqo1KZ7TOBa+t16TTquYqLmxApIIyf6F5Q==
X-Received: from wmqe11.prod.google.com ([2002:a05:600c:4e4b:b0:453:86cc:7393])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f12:b0:456:f1e:205c
 with SMTP id 5b1f17b1804b1-45868c74efcmr21231745e9.4.1753267646461; Wed, 23
 Jul 2025 03:47:26 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:03 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-12-tabba@google.com>
Subject: [PATCH v16 11/22] KVM: guest_memfd: Track guest_memfd mmap support in memslot
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

Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
memslot->flags (which makes it strictly for KVM's internal use). This
flag tracks when a guest_memfd-backed memory slot supports host
userspace mmap operations, which implies that all memory, not just
private memory for CoCo VMs, is consumed through guest_memfd: "gmem
only".

This optimization avoids repeatedly checking the underlying guest_memfd
file for mmap support, which would otherwise require taking and
releasing a reference on the file for each check. By caching this
information directly in the memslot, we reduce overhead and simplify the
logic involved in handling guest_memfd-backed pages for host mappings.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++++-
 virt/kvm/guest_memfd.c   |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 26bad600f9fa..8b47891adca1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -54,7 +54,8 @@
  * used in kvm, other bits are visible for userspace which are defined in
  * include/uapi/linux/kvm.h.
  */
-#define KVM_MEMSLOT_INVALID	(1UL << 16)
+#define KVM_MEMSLOT_INVALID			(1UL << 16)
+#define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2490,6 +2491,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 67e7cd7210ef..d5b445548af4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -578,6 +578,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (kvm_gmem_supports_mmap(inode))
+		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
-- 
2.50.1.470.g6ba607880d-goog

