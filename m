Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB982E4277
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267658; cv=none; b=exdgrVlAQmFnvc5lbi2O2C0D7N5F9gbqDbTbER9EvOyR/Db7uXo9xJ9dxLvyJnj3LRCUYMFK8IQonK8bMBAXsL4EgoxujjdyhhZsx9sf6xMazKko6y+wG+rjw/qnGHkcYboqr/uJjvpGVp/xJ6nRoNdSNJvUYCL0LZfVEx8o7Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267658; c=relaxed/simple;
	bh=eCDIU4W7AYZKs5u75nkP8rbOQPe6kfu1T+spxjDjQ8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oLlsQJXJ97/FqP9edMrQ7SGCHQPzZMzyRKZwikU2tcRiaNGNUAbcWbM08rL9XOwpnVrVlE8XZsvkXOaywCeitnDsuJS3KMjHeejlHS49xlSeef4uaOVFjpKdUPC2N02kLg3v7kQMrawx1biUzlZv7zsn831p9N2HT9Fd2fbHvP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EaGlGaYP; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EaGlGaYP"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45867ac308dso4605665e9.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267655; x=1753872455; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nXopSo3A/Iyt2jZoa3DRKyyiuLot/i5BO7eQNmUe+bo=;
        b=EaGlGaYP/cypYRntjv8bFTV2jiH7C6RMqt4laZk5Y6RTsnzTKkU1mNWhZ0jDthp3Zb
         gqEkRmT0J7JCZH1iQ83hz8NmKtrFUi9aqZ5YC6drrAv3CnTKfrCTBoV2N2r12R6LGgiv
         k87GTfrOlIIyUVpoBGYLp+79naD3wNomzaM7nEzPvtqRSc7h9slBYHyApaoNjG6ybdkE
         gzcrKpzgMtLngbS6cO/wUFwYmnbKAmbPdjhxv3YhrL6fo7z1E4y+By2I1zu0yOVJeFrT
         uagfQAUO5PuTN/tPXYb24N/tbcwBJpC+0kIseDVEI9RoKLWDgKEuOjC36QEPlshRKO+4
         OCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267655; x=1753872455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nXopSo3A/Iyt2jZoa3DRKyyiuLot/i5BO7eQNmUe+bo=;
        b=HWpp/k/yXOKUYCOdY0IvH39ogaL2q9GYOXPha2RETlFTeUClegiXoGn2p+1zk2QvSF
         2f127CdQ8rdMYavpTGY8LPHR7xxhcDjrKv12NdCrbMWHx6HvADvIl0Xb7mHeJWK+0YL1
         A0+a3QKuDOD0x9KOs9SpLdBy15Bqjm0VK10nVxhw4bNVwHP0asQ+OuVAZFb5HEGkHn3w
         yfn1zPlXW1u4IBfHsEQiNz9SDW8r4yrQGoruGOsSnoWq+CCh8Hh+Bi4rI2cR4LyS6kih
         dy9H7HdCRaAGZhDm3hgylocMCnRVEJVlZofbm7+HihUV8UPS0Ydu/oqwQSVvRVVmkLtp
         BuXA==
X-Forwarded-Encrypted: i=1; AJvYcCX7N7/sv1WR+0b/uArL66XZnltTvPtaFWg5MIbIl1ocICxcHmwbbY+S1tCh/6rMG7jFkwBhHe8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0QVBBHnp/PYpcFVlhv9ygn/21ca/wdKORN6z9JStLjjcGWMj9
	qV196AmErwpa1fgNMRm8056WHFbaZQ7xjZuS1ICGsguG0Ifa9LQL7krlmKCUzvAI0URRoaCT+zI
	I3A==
X-Google-Smtp-Source: AGHT+IF7LN4zz7H7kl5hmHOJM2RWeLy8eWEca0zN52GnDIcb6JpxZKh2nX+K8PpdE1V0cGZIooZEsfLT5w==
X-Received: from wmbdv17.prod.google.com ([2002:a05:600c:6211:b0:442:ea0c:c453])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3107:b0:456:1752:2b44
 with SMTP id 5b1f17b1804b1-45868d2fe87mr17408105e9.23.1753267654654; Wed, 23
 Jul 2025 03:47:34 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:10 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-19-tabba@google.com>
Subject: [PATCH v16 18/22] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
 backed by guest_memfd
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

Handle faults for memslots backed by guest_memfd in arm64 nested
virtualization triggered by VNCR_EL2.

* Introduce is_gmem output parameter to kvm_translate_vncr(), indicating
  whether the faulted memory slot is backed by guest_memfd.

* Dispatch faults backed by guest_memfd to kvm_gmem_get_pfn().

* Update kvm_handle_vncr_abort() to handle potential guest_memfd errors.
  Some of the guest_memfd errors need to be handled by userspace instead
  of attempting to (implicitly) retry by returning to the guest.

Suggested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/nested.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dc1d26559bfa..b3edd7f7c8cd 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1172,8 +1172,9 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
 }
 
-static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
+static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 {
+	struct kvm_memory_slot *memslot;
 	bool write_fault, writable;
 	unsigned long mmu_seq;
 	struct vncr_tlb *vt;
@@ -1216,10 +1217,25 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
 	smp_rmb();
 
 	gfn = vt->wr.pa >> PAGE_SHIFT;
-	pfn = kvm_faultin_pfn(vcpu, gfn, write_fault, &writable, &page);
-	if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!memslot)
 		return -EFAULT;
 
+	*is_gmem = kvm_slot_has_gmem(memslot);
+	if (!*is_gmem) {
+		pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
+					&writable, &page);
+		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+			return -EFAULT;
+	} else {
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
+		if (ret) {
+			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
+					      write_fault, false, false);
+			return ret;
+		}
+	}
+
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
 		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq))
 			return -EAGAIN;
@@ -1292,23 +1308,36 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 	if (esr_fsc_is_permission_fault(esr)) {
 		inject_vncr_perm(vcpu);
 	} else if (esr_fsc_is_translation_fault(esr)) {
-		bool valid;
+		bool valid, is_gmem = false;
 		int ret;
 
 		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
 			valid = kvm_vncr_tlb_lookup(vcpu);
 
 		if (!valid)
-			ret = kvm_translate_vncr(vcpu);
+			ret = kvm_translate_vncr(vcpu, &is_gmem);
 		else
 			ret = -EPERM;
 
 		switch (ret) {
 		case -EAGAIN:
-		case -ENOMEM:
 			/* Let's try again... */
 			break;
+		case -ENOMEM:
+			/*
+			 * For guest_memfd, this indicates that it failed to
+			 * create a folio to back the memory. Inform userspace.
+			 */
+			if (is_gmem)
+				return 0;
+			/* Otherwise, let's try again... */
+			break;
 		case -EFAULT:
+		case -EIO:
+		case -EHWPOISON:
+			if (is_gmem)
+				return 0;
+			fallthrough;
 		case -EINVAL:
 		case -ENOENT:
 		case -EACCES:
-- 
2.50.1.470.g6ba607880d-goog

