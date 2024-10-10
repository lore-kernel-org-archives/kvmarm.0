Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE991FCC7C
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584763; cv=none; b=lb6FPSy3T4QnGSsvHcwriIhxbl/Q6LmrQZOzxiCi/q2T9wPJuO+Z8JkVW+ztDLf1QaR5F/Q60b/16oObeDt/GMHZwgLD5n/1uLGPGJux6wMOK5ee6cSMUSONICSxxq30f0lQpJaKp7VxI6HNEqE/mJDZy4sOKww/EqEuEu/Za6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584763; c=relaxed/simple;
	bh=mQXhN5iZpOZWnnd2N5GwBNgcRKXl5xUfnEr6O0WaUwk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F4iCQ9tuPEJ02A/tHI0kttWW2SC1LisCg8njpssF6gfLXlEFZjvzg+16L6SCd7q5LEMJEXMK3oGWRbJdeqjeiUBs9LGG7YHSoHG1GrTjaYfJHJn8QTnjowDqY8+iYhxpTNV5FR/v4VzlwKdS/4Ryvxs6mO3F/P6f1PguCmuyHbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H1UhCi8b; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H1UhCi8b"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e20e22243dso22280917b3.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584761; x=1729189561; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DlXoUFYFzJpPJut8ySNZ/avzuJs4Hk+oSmN6VTWgSk=;
        b=H1UhCi8bY3ObNPD0o+9OJV88wSvWMkxbddFh72e72N7GCgM8/sXRyYZKuoeNiiZbeR
         WJ7LFK6QbJQsu4RWHaPaj2bzSPtVQDAH8mipp0QYWVU34mVoXF1yNJ2cMgezko8aTCYU
         If2fC6aN/t0GTnKYSWa1rr7GmJaQWN3HGP26OXmw7lR/H12XjOnbyTfjkMqMXxvEVdWT
         bB3s6pyu22vSpqa9XOVdSMIIR/MqAJ39b2eyVNKpv7kbUSqcnrfZjY981YcPxkBKW0Ur
         qvewpOAG0/RNIlgH4kRU9SS4qSEDsF7cu25w7Qgz0ay+f6/68hNaGeFF7y8ReZ0yYF1f
         jUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584761; x=1729189561;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+DlXoUFYFzJpPJut8ySNZ/avzuJs4Hk+oSmN6VTWgSk=;
        b=niO/W9nxsKjYW4cyro1uu7L44r5rTA5E3tTohQ3Kcehd66d/w6LSzcyHf3c29hYWga
         7dhb3/dQzAk2S9SZ/Wz+gdZzZ3PGfEAFIbnnDmYAsytBfIXMXTMMpQ9Fq7uddp0SKVJI
         xV8d6m9Do5IODRkJesoNAPnGjBjN/B1hvZEPqnpPJZS/ChUoIfLrC6hFICOSQGHn1zVC
         tpSsxrmpJ3NrdcsFdjihiKhf16dJNtUphoxcKZkoWI97+ZLvwmZOtVAdJXsUIwbyxXVq
         8JaN4EvgGpfmxrbHVHa31V17dP93caUe5t6QR5V7NXseaOTs4gDSRnKzPLSO0IzyPIqa
         lKDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVB+AOKc6QmnBhIzC9a/ZVTBikbNmlNGXi6XB63WmZRw19ENW/lx7TVjwIiv3mxfvhlfrolUgg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7uo9s6NeCSY30SF4iO98JhEnH/iwRfRoolpE79O3i6ahk6tye
	vbmlYqcNJCUG4E58JKprrY4knyD1w3jHvHFNv/d8jbz4fh/qJQ2Ehyc8X9YMuF7lB9hfgkadwxS
	UQA==
X-Google-Smtp-Source: AGHT+IHYBe/gylmYYB76Y4JbCGQqBxyU7NvKFk8CzbtQRqqOSH0kk5njqmBLFW7wxt+Okx9MKc9CHg/F7Og=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4349:b0:6e2:1713:bdb5 with SMTP id
 00721157ae682-6e32217cfd3mr118607b3.5.1728584760829; Thu, 10 Oct 2024
 11:26:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:35 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-34-seanjc@google.com>
Subject: [PATCH v13 33/85] KVM: Pass in write/dirty to kvm_vcpu_map(), not kvm_vcpu_unmap()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Now that all kvm_vcpu_{,un}map() users pass "true" for @dirty, have them
pass "true" as a @writable param to kvm_vcpu_map(), and thus create a
read-only mapping when possible.

Note, creating read-only mappings can be theoretically slower, as they
don't play nice with fast GUP due to the need to break CoW before mapping
the underlying PFN.  But practically speaking, creating a mapping isn't
a super hot path, and getting a writable mapping for reading is weird and
confusing.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c |  4 ++--
 arch/x86/kvm/svm/sev.c    |  2 +-
 arch/x86/kvm/svm/svm.c    |  8 ++++----
 arch/x86/kvm/vmx/nested.c | 16 ++++++++--------
 include/linux/kvm_host.h  | 20 ++++++++++++++++++--
 virt/kvm/kvm_main.c       | 12 +++++++-----
 6 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d5314cb7dff4..9f9478bdecfc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -922,7 +922,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_svm_vmexit(svm);
=20
 out:
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
=20
 	return ret;
 }
@@ -1126,7 +1126,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb12->control.exit_int_info_err,
 				       KVM_ISA_SVM);
=20
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
=20
 	nested_svm_transition_tlb_flush(vcpu);
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0b851ef937f2..4557ff3804ae 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3468,7 +3468,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
=20
 	sev_es_sync_to_ghcb(svm);
=20
-	kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map, true);
+	kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map);
 	svm->sev_es.ghcb =3D NULL;
 }
=20
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9df3e1e5ae81..c1e29307826b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2299,7 +2299,7 @@ static int vmload_vmsave_interception(struct kvm_vcpu=
 *vcpu, bool vmload)
 		svm_copy_vmloadsave_state(vmcb12, svm->vmcb);
 	}
=20
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
=20
 	return ret;
 }
@@ -4714,7 +4714,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union=
 kvm_smram *smram)
 	svm_copy_vmrun_state(map_save.hva + 0x400,
 			     &svm->vmcb01.ptr->save);
=20
-	kvm_vcpu_unmap(vcpu, &map_save, true);
+	kvm_vcpu_unmap(vcpu, &map_save);
 	return 0;
 }
=20
@@ -4774,9 +4774,9 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const=
 union kvm_smram *smram)
 	svm->nested.nested_run_pending =3D 1;
=20
 unmap_save:
-	kvm_vcpu_unmap(vcpu, &map_save, true);
+	kvm_vcpu_unmap(vcpu, &map_save);
 unmap_map:
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
 	return ret;
 }
=20
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ff83b56fe2fa..259fe445e695 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -231,7 +231,7 @@ static inline void nested_release_evmcs(struct kvm_vcpu=
 *vcpu)
 	struct kvm_vcpu_hv *hv_vcpu =3D to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
=20
-	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map);
 	vmx->nested.hv_evmcs =3D NULL;
 	vmx->nested.hv_evmcs_vmptr =3D EVMPTR_INVALID;
=20
@@ -318,9 +318,9 @@ static void nested_put_vmcs12_pages(struct kvm_vcpu *vc=
pu)
 {
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
=20
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map);
 	vmx->nested.pi_desc =3D NULL;
 }
=20
@@ -624,7 +624,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct=
 kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 =3D vmx->nested.vmcs02.msr_bitmap;
-	struct kvm_host_map msr_bitmap_map;
+	struct kvm_host_map map;
=20
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -647,10 +647,10 @@ static inline bool nested_vmx_prepare_msr_bitmap(stru=
ct kvm_vcpu *vcpu,
 			return true;
 	}
=20
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), &msr_bitmap_map))
+	if (kvm_vcpu_map_readonly(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), &map))
 		return false;
=20
-	msr_bitmap_l1 =3D (unsigned long *)msr_bitmap_map.hva;
+	msr_bitmap_l1 =3D (unsigned long *)map.hva;
=20
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
@@ -714,7 +714,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct=
 kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
=20
-	kvm_vcpu_unmap(vcpu, &msr_bitmap_map, false);
+	kvm_vcpu_unmap(vcpu, &map);
=20
 	vmx->nested.force_msr_bitmap_recalc =3D false;
=20
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8739b905d85b..9263375d0362 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -285,6 +285,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool writable;
 };
=20
 /*
@@ -1312,8 +1313,23 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn=
_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
-int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *ma=
p);
-void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool =
dirty);
+
+int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *=
map,
+		   bool writable);
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map);
+
+static inline int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       struct kvm_host_map *map)
+{
+	return __kvm_vcpu_map(vcpu, gpa, map, true);
+}
+
+static inline int kvm_vcpu_map_readonly(struct kvm_vcpu *vcpu, gpa_t gpa,
+					struct kvm_host_map *map)
+{
+	return __kvm_vcpu_map(vcpu, gpa, map, false);
+}
+
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, b=
ool *writable);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,=
 int offset,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 40a59526d466..080740f65061 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3116,7 +3116,8 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
=20
-int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *ma=
p)
+int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *=
map,
+		   bool writable)
 {
 	struct kvm_follow_pfn kfp =3D {
 		.slot =3D gfn_to_memslot(vcpu->kvm, gfn),
@@ -3130,6 +3131,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, st=
ruct kvm_host_map *map)
 	map->page =3D NULL;
 	map->hva =3D NULL;
 	map->gfn =3D gfn;
+	map->writable =3D writable;
=20
 	map->pfn =3D kvm_follow_pfn(&kfp);
 	if (is_error_noslot_pfn(map->pfn))
@@ -3146,9 +3148,9 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, st=
ruct kvm_host_map *map)
=20
 	return map->hva ? 0 : -EFAULT;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_map);
+EXPORT_SYMBOL_GPL(__kvm_vcpu_map);
=20
-void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool =
dirty)
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map)
 {
 	if (!map->hva)
 		return;
@@ -3160,11 +3162,11 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct k=
vm_host_map *map, bool dirty)
 		memunmap(map->hva);
 #endif
=20
-	if (dirty)
+	if (map->writable)
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
=20
 	if (map->pinned_page) {
-		if (dirty)
+		if (map->writable)
 			kvm_set_page_dirty(map->pinned_page);
 		kvm_set_page_accessed(map->pinned_page);
 		unpin_user_page(map->pinned_page);
--=20
2.47.0.rc1.288.g06298d1525-goog

