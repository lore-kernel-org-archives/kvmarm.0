Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89FB2D948C
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572058; cv=none; b=nArZWVyAnLttKciRpm6fsVg8QyzkhVef+N4ko90tvMcNdgL33vYpEOqjWCC9pQkIVzc1rtercrISxicfObbvUmpQ8AmfxDD8xXxbVtIKsamgDfZ+JYYnUE1R5Tcxp70qxHjzZFVJNdS1JVvfeSr/G9mCP/00Aklz4zqBNEMztPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572058; c=relaxed/simple;
	bh=rwFpQdz+xqsV9TRx7fn+9BFSSTMO137zIdaSVB+FJjM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HnfdHc0ipk4kA/v3jegDWHKAyGIs3AzEuFfD/rJfQk+VOh9/q8+HNy6a78erP6uXmCljw/67v++Bo6wt+oTUoafHuIaMJwh7X6NU53lQZwJ/Ldwg87BsdaySAGgPHP7D+gaM2cNNC0Bq91HMRS9pRTdHnDSuOFbEKLoS20ukQfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eb/C1fv8; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eb/C1fv8"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4f7ebfd00so2097243f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572051; x=1753176851; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HKm1OPddzPOCVybWQJf7fIOws1hHLUPbnC0KechHFr4=;
        b=eb/C1fv87PziDM6R/87piklkWf9kXMiXuRgc8R0UMeI48Vya04jvMEdAoKvshCc/P3
         TswnZPWJSxH5G/YWqW1yMGE1D0NkAYuxhCXOYr2Lhij8BZTnnJ2CTe+KcwhpXdEuYHT3
         RyV46Z3D0XM0Kzm+IXKMJU0WIyLvNcOXlP1DKTfZ52qvVHBL7VOZeqZ8RokghKnVYa+o
         SDl+pKClu5V5RD/CPl3pE7PzSDams7gzYRR0t5KWuL15iAtksH/h3CODZw9WgtJfQoxV
         oMCY7zyqti/q3HNkrf7keKGQnsbqHPVAlU7OxN5RmYuRvpwD1DrkC1tsflcshlayeHrI
         +oNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572051; x=1753176851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKm1OPddzPOCVybWQJf7fIOws1hHLUPbnC0KechHFr4=;
        b=w5ZavKkH7+kFQ28thzeRytVdqd5L1llwXtSHnUFUhtyzomw3HQcI/8UMkduwAgjuHd
         1w892DXnZHnaXA8EwjjCYqv7bjaQZrMGVelmn+MOmoDMD88UTJthEFId+EA8I8SSVQbw
         +YR+EagXZcW7ronN2yf+rrzs93Snt76Dk4f9A9orMwtt2N4t1PG1NK2D4ID+RtlWb3iF
         d0MmWEnn+HPT9kK1cr3ENBC9RywE4gxdcmM1Kp9SBp3JE5/1pWUrGemzFmU1ItrzpsR/
         PVkG3D0Y8dq4W9YWJxurDPUjQd3REfd8NH5IciqEJLT7WAinMKmRAYOFHVMfWg09XQjy
         rHYA==
X-Forwarded-Encrypted: i=1; AJvYcCVc3ICdnHUbgZfi/Tgz70q0XAXMBDIwj3HmQGhSqKG9jxEZ/DT27tsXFbfGCc7FYcYwF7Gng+0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/I4NM2KF30l+JKgMyGgHpY4Fysz1Qi2bCoi7C69a/6r5PlTxb
	lyKT1gfhOB9BPBCrSJRlR2TBLLkoZyji9zazJ3/eiiHdD4/Db3JHcwWL+bsYJD/BnS9VJcGw6CW
	XeA==
X-Google-Smtp-Source: AGHT+IFb2OSH7lEKwhbKN8+t42ZlOCnkfwV4bEknRLarq2YT9adSgiVMvCqHjEbxvfjY3zoBqSDXrJRWaQ==
X-Received: from wrpf9.prod.google.com ([2002:adf:f449:0:b0:3b2:5edb:a37b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2086:b0:3a5:67d5:a400
 with SMTP id ffacd0b85a97d-3b5f18b3eaemr14590340f8f.33.1752572050760; Tue, 15
 Jul 2025 02:34:10 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:38 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-10-tabba@google.com>
Subject: [PATCH v14 09/21] KVM: guest_memfd: Track guest_memfd mmap support in memslot
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
memslot->flags. This flag tracks when a guest_memfd-backed memory slot
supports host userspace mmap operations. It's strictly for KVM's
internal use.

This optimization avoids repeatedly checking the underlying guest_memfd
file for mmap support, which would otherwise require taking and
releasing a reference on the file for each check. By caching this
information directly in the memslot, we reduce overhead and simplify the
logic involved in handling guest_memfd-backed pages for host mappings.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++++-
 virt/kvm/guest_memfd.c   |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9ac21985f3b5..d2218ec57ceb 100644
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
@@ -2536,6 +2537,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 07a4b165471d..2b00f8796a15 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -592,6 +592,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (kvm_gmem_supports_mmap(inode))
+		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
-- 
2.50.0.727.gbf7dc18ff4-goog

