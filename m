Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFCD2C3278
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829766; cv=none; b=q3tsMIgSGcTptM0FYxUP/kVeiSXgFq1OlmzsTt6pfFyvDjKdnRfJY8S4HHSeqgwo57kITM9Wo4Ta9JAmgrMuQZnH3XzmN161n7LkxvEm9FYvusmFU1C/NWBGGqdoxQPvgdTHemD9MgaIPBN9eTyeDyHmdgLStZxHrG0jJF0uUw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829766; c=relaxed/simple;
	bh=maUowEREwbh42ONfrRcy3bj/yfM0pHhiYCFRpCgm01Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y18kKyU5Hk3Gfz6EQd7xLPdxXzJK0PZBkbh5Qtx8Ft7BVyxxO6F6vlapOgXC4uBLBpb3DCiRXGEGxWQDTc0qjCsQ+mgzGctzmrdgZLPczb1HHGsx+yaQbysLj/2gpH9iJkQ77zBzcEbmbO0x6wYWoGBvE8aNV+6UpVkUj6nLn1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WLZY3GlN; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLZY3GlN"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2407248a180so8046295ad.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829764; x=1754434564; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2SSy7htSrqmTnWDs8KQ8CPqcAnDaIUsFMxYImLgL19Q=;
        b=WLZY3GlNc6XceKTFXjrCSY0jMbyPwp0mSn+W0AD6uXYJXxCy+eZNAox5pSYfLIkdV1
         m1DIW8ZccnqwL0dtffPEMUE14LolxCJZfo7RKdNPFlvFFj1t6Ybn1m5Vz7pj11jqdpwe
         JLPVawvtnQGNRkWoYFTJT9suvObBpHfVmcRuLBcfAx66fP7MYFL9+S0+6Wz9voMmjcKt
         3V2hTZ6ZXsgA8qz/uIgQ4dCs+FOmKaJuRS141ts/jBJzGigNgtCNe/xQV9CNpk8HYW7G
         4gSY43bJT/tnk8gnTnG8L169TemzbwTt0RsFKZgOMj4vi+v/YC/zl7IIfTojGMYJPQUa
         0u+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829764; x=1754434564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2SSy7htSrqmTnWDs8KQ8CPqcAnDaIUsFMxYImLgL19Q=;
        b=ZqWy9VQ0+dS5xoPCA6xePHWYA7MOhCS2EMN+eAr8tT9JWBzQwaZOzZzWLUnlPntLhK
         BVW/9cBsKbAidG6qzjfpbRLAd9v2Qt0jTFsBfO7JKV8N2i9tVynVx72OdXuOb/KD8Qbm
         8GgUFyspSXy9hfIAaFV486QEPJHwEj0gxtvpFWaDzaHHtoMpbn6ccUN0T4NwYltYegez
         EublizAthHzejjJ0ZPsrNz8wdrHmu8FkaLaxVGODpS1WUQMUZWQ3wIGyHfp0j3c7UEaM
         IKp2p1uxfVe2riC0xcD/1TyxZJGPwTMEkpzQdrwbY52tCRT2H7wDZkFW+E7iNAqF2Zds
         LP1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVA6cq8qNdoz3TFarmXwQA/x3Xce2fZCvEZBnaIaVPq29WkSct+COPlIXuS6DdtCVzlpEpas4k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMP4xelYRKv/KFL3CMdfWBxQYRJZk/4MtWkMhZ5vcxxXXDDn9d
	rOZ23ew+7CGeSajcich1fdybruFCZV/3o8/a9R351rCE5o1ab+afAdrjxehnL5Q+fbU9vIwVXVV
	vJj3yqQ==
X-Google-Smtp-Source: AGHT+IHj/510Mv9kPU5X6CNDct4tYO3yblGBJUqMpY3W6X6yaMqYIgXW779LIryKFKVtTEcES1VIMsFWj3M=
X-Received: from pjbsh18.prod.google.com ([2002:a17:90b:5252:b0:31e:cee1:4d04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e541:b0:240:7c39:9e4e
 with SMTP id d9443c01a7336-24096b56cd4mr15158665ad.44.1753829764046; Tue, 29
 Jul 2025 15:56:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:50 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-20-seanjc@google.com>
Subject: [PATCH v17 19/24] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
 backed by guest_memfd
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

From: Fuad Tabba <tabba@google.com>

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
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.50.1.552.g942d659e1b-goog

