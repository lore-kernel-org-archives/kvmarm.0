Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF2E291C11
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058811; cv=none; b=mkXM+CoMV0jyzNeDvc1uZWIvHiOlIMR8xS/7Y1QbKYgBEE+iDrL5no3gTYgytTvZ2bZAeLGO68Dsh7dJSs96hZVomgUlr0sC25DBiN1jlF3SMA0XKvHFFlCYwKTL83gJX+POmFj5+DfFACdJnhYp5PyjytNKe/ZsdjjjSWix+8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058811; c=relaxed/simple;
	bh=UpkeXIr5tQW6WZUIX1SkZk2bJqJ9LIMknrPnyTPX/hM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UwwRuT0+4OhSExsSs0HGIsCRMCLqFWf8BjHndYspHm99RqZzlcZqzcSEBUZ3/9UWBVIN3Ltq9mqu0CHoI/bqpgQHM2w+tP7F9wctR3WG0GfzXQkr2CK4zTUNENhm3SEGpJv2M3Ndk+Y5lCxfQaMGoqL5hUpqRRPGwkqM+yuKCh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FJE1Kcqh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FJE1Kcqh"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-451d30992bcso39787825e9.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058808; x=1752663608; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUcEiOcnnzGKcpkNw8uc0ad9PF+XFRDotUiBVoaU7aU=;
        b=FJE1KcqhXiQuMgZcCXSecw8ci8e8muNqQU17ZP4T/+UkF08dXdLvnJ0zRYXbjh56kr
         IRQGRjNG825a6Ko8Lkh0BvxKVrS8ogHF/vbPyaH7BO3reG8oaz+hEyrvA50ERxPaRWiw
         RfCmxNG8rTxvYCtcr6RDQcZysfruI5glUuM8jY3ZIK9h6ggzKwIz+X31dKuhqzGToE3D
         tRIrQdLpLtAMBTNUTtp1Obi/yO0uN7OVBUi0Tm8VPZGfOLadzDEDO8StAvkO3f5tSKFi
         q0+wnHNvUPHTJuClEg7yvHtCC+QROPk/F/WETvcbzWLN+qgM3eQzj8W7WHfzxRGPapGR
         0Pnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058808; x=1752663608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CUcEiOcnnzGKcpkNw8uc0ad9PF+XFRDotUiBVoaU7aU=;
        b=P8GBUIXHcAn5xeTm5GXAOSJ38Dt4hxHsiuMTg4sVldefcJg9GjlW/LrUx7b7MlIihV
         2udYJzuVutnkCh5E6TazRp1HXHl80J97BNrRql5bRX+R1SEa7JI9VqtNtBbGqzkgGYq5
         JU28Ub3csptZ02KgUWWU93/8L2uClNGZod/JFgKcNAbvq6XykoeaFlxxuq/ixOI2E9GN
         RjkP71lmuzqHAkI4I1CJCVCcG1OjAS1p+o/+FDKiwfpgECyYLRmxOBrWNJ2lzqw0DBCs
         ZzGi0lYsYt/BDDodmL/AlS/qy4BYayJexDX4FYiymh37VBH8cAHcufU7NMLeaID5nT1j
         JWqw==
X-Forwarded-Encrypted: i=1; AJvYcCVLHrdpcg1wfBHcz/RVCAVcdZ7fs2C6CLJ3xOlZjybZqazgqjNwxT62ByCEZlxNu8anzZpUo3g=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRKjWsdtGdqtLQxwnsb3Bv8zuQQcdYoCYeFa3Y79astr9u1aae
	dVz1XyBITLlUCELIg2QWpZACnblzrMsIp8oUqGEn1CTDXV2BLYUfxGie0pnvdDizuEztbYstQXz
	dNA==
X-Google-Smtp-Source: AGHT+IFL75zyGMq5td+nbGAgOpuMz9UV8SdfC+YGNoaNssj8m4kdXpNab0sj5J+3kBesWtcsJWy4R8XuHg==
X-Received: from wmbep17.prod.google.com ([2002:a05:600c:8411:b0:442:f451:ae05])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:6f1a:0:b0:3a6:d7e9:4309
 with SMTP id ffacd0b85a97d-3b5e45380f3mr1576649f8f.29.1752058807622; Wed, 09
 Jul 2025 04:00:07 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:35 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-10-tabba@google.com>
Subject: [PATCH v13 09/20] KVM: guest_memfd: Track guest_memfd mmap support in memslot
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

