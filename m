Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61521E7C1C
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584713; cv=none; b=d8b9LeYV85XSyUFOXJ4QjIuuBWYJKnbN2mYSGOzXuxQeY058ksGmBkZxeM1t6jMamxqlx3FIo8wu2vtqCLYplh07L4b/Bd2Zuz0aMq7LdOAJeOZguwFp8XefjjNTKDCIZgCxrfHVP1fU8nLxPnK6MuKBqoocvpJFEelW52lEuhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584713; c=relaxed/simple;
	bh=sB5G3PQtHd5Wp6fJfSwA75+Ou8nv+Xyz2zynkW7I+sM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T5+ItIuwLos3qwA8dpKGPySXmNtyUBK8s4mtr4EGbzW24mGKxXWY/I4io3TUPXYRMT9MPRLI4zuLpfZCkvP4RxIgueLTjLhzwEt6/c+pbTtGx5AuIRMiNJCZ7ZwuexvoxRdzNKKVqL5+e0BsP6IPLZmuMMydQz+/dM91qnwsq2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vYwlWAS3; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vYwlWAS3"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e2e4874925so21229537b3.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584711; x=1729189511; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ix/Xs4/Qn/2DvOT3Bh000Q598gzWwOGIiO61AJ4Bto=;
        b=vYwlWAS3Z9FhShiOTP/nMZ0R3bVatpZ7l/qHCzatRDr8xLQWE5EKaywRgYYb+ggMDS
         oodfH2ATdhUeXK9wrywwKKMiZJQSnaT7n4j+3MfX3KwuRq6dSJu840t5bI2v90Nv1wYT
         Mb4S6Lj9SGnC2PgHcXwGMXooIcaTObnrctKARpAjswsQQDOETkciwjIHn8c472xQr2WU
         oKFZNMwDtg00WiRZcvqIs70eEy3lGBm7dwnNHH7D4sdq1QCMW5dhjj1sqLRatkhaFY3b
         82+lp6rqEk3f2qVnZ/zvKkeGJQ6Cwn+EHSA81AzIMFiHMh7sNvMVIh2sQAdlom/2/xS+
         p3Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584711; x=1729189511;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0ix/Xs4/Qn/2DvOT3Bh000Q598gzWwOGIiO61AJ4Bto=;
        b=d6EhacXsmLW/ZjK1iBDQIRuFJ3cI0sReNj1RkUyaeKC3ifJhLxeZxiL4rgeUdfHIS1
         WTXH1UrESXDvQFD2VGr4LiXv18jICEm6WoeOj8stugnkRjDJv4+RAn5blFn4Ikk16WfE
         jLTdeADwZvTuMNVjt5APOehojZ6iRD4eQfF7JZqXzeltrlc9x0nA6EFj9g8SQuFYZxLb
         qTt3N+ehQ0Crls5ioQGynzJo0iv9ufnthmltLdAYAfrSQY3OHQymf70dhWncReGl6mdh
         Kr8sVCaK6gwkOCwKYe+V5qixY8crLG9lKsI99fWfJNzFRRqIkSysVzH0ZrZZoajMkro0
         ALqw==
X-Forwarded-Encrypted: i=1; AJvYcCUQQhj3pnxfDNgXkSTgwa2q6zVaoVQqpO8387cuylz0Jw77M4dPkRiyOG4P3Cvssg7TZ2tdMhU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAzuR/CYbUjZwvLzt8acjk/e+g4Jhau2sfEACAZk5mlC4R9g1g
	kF7hp84F6eeizmWBXxirqtsmx7/Dz9Qiq6eV8s9xrY8ebQmNspfBpH1vBm8nZEhLcjA4umuqmm9
	nTA==
X-Google-Smtp-Source: AGHT+IGD2TfP2dloLIlDYfRlI1lvmWPD7YUtu8EYW3dxRXY7JxJbZQIAJnuRF8jcBfCYGhk25T1qJs7AAuY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:5b41:b0:6db:c6ac:62a0 with SMTP id
 00721157ae682-6e322305467mr243067b3.5.1728584711093; Thu, 10 Oct 2024
 11:25:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:11 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-10-seanjc@google.com>
Subject: [PATCH v13 09/85] KVM: x86/mmu: Mark page/folio accessed only when
 zapping leaf SPTEs
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

Now that KVM doesn't clobber Accessed bits of shadow-present SPTEs,
e.g. when prefetching, mark folios as accessed only when zapping leaf
SPTEs, which is a rough heuristic for "only in response to an mmu_notifier
invalidation".  Page aging and LRUs are tolerant of false negatives, i.e.
KVM doesn't need to be precise for correctness, and re-marking folios as
accessed when zapping entire roots or when zapping collapsible SPTEs is
expensive and adds very little value.

E.g. when a VM is dying, all of its memory is being freed; marking folios
accessed at that time provides no known value.  Similarly, because KVM
marks folios as accessed when creating SPTEs, marking all folios as
accessed when userspace happens to delete a memslot doesn't add value.
The folio was marked access when the old SPTE was created, and will be
marked accessed yet again if a vCPU accesses the pfn again after reloading
a new root.  Zapping collapsible SPTEs is a similar story; marking folios
accessed just because userspace disable dirty logging is a side effect of
KVM behavior, not a deliberate goal.

As an intermediate step, a.k.a. bisection point, towards *never* marking
folios accessed when dropping SPTEs, mark folios accessed when the primary
MMU might be invalidating mappings, as such zappings are not KVM initiated,
i.e. might actually be related to page aging and LRU activity.

Note, x86 is the only KVM architecture that "double dips"; every other
arch marks pfns as accessed only when mapping into the guest, not when
mapping into the guest _and_ when removing from the guest.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst | 76 +++++++++++++++---------------
 arch/x86/kvm/mmu/mmu.c             |  4 +-
 arch/x86/kvm/mmu/tdp_mmu.c         |  7 ++-
 3 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/lo=
cking.rst
index 20a9a37d1cdd..3d8bf40ca448 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -147,49 +147,51 @@ Then, we can ensure the dirty bitmaps is correctly se=
t for a gfn.
=20
 2) Dirty bit tracking
=20
-In the origin code, the spte can be fast updated (non-atomically) if the
+In the original code, the spte can be fast updated (non-atomically) if the
 spte is read-only and the Accessed bit has already been set since the
 Accessed bit and Dirty bit can not be lost.
=20
 But it is not true after fast page fault since the spte can be marked
 writable between reading spte and updating spte. Like below case:
=20
-+------------------------------------------------------------------------+
-| At the beginning::                                                     |
-|                                                                        |
-|	spte.W =3D 0                                                       |
-|	spte.Accessed =3D 1                                                |
-+------------------------------------+-----------------------------------+
-| CPU 0:                             | CPU 1:                            |
-+------------------------------------+-----------------------------------+
-| In mmu_spte_clear_track_bits()::   |                                   |
-|                                    |                                   |
-|  old_spte =3D *spte;                 |                                  =
 |
-|                                    |                                   |
-|                                    |                                   |
-|  /* 'if' condition is satisfied. */|                                   |
-|  if (old_spte.Accessed =3D=3D 1 &&     |                                =
   |
-|       old_spte.W =3D=3D 0)             |                                =
   |
-|     spte =3D 0ull;                   |                                  =
 |
-+------------------------------------+-----------------------------------+
-|                                    | on fast page fault path::         |
-|                                    |                                   |
-|                                    |    spte.W =3D 1                    =
 |
-|                                    |                                   |
-|                                    | memory write on the spte::        |
-|                                    |                                   |
-|                                    |    spte.Dirty =3D 1                =
 |
-+------------------------------------+-----------------------------------+
-|  ::                                |                                   |
-|                                    |                                   |
-|   else                             |                                   |
-|     old_spte =3D xchg(spte, 0ull)    |                                  =
 |
-|   if (old_spte.Accessed =3D=3D 1)      |                                =
   |
-|     kvm_set_pfn_accessed(spte.pfn);|                                   |
-|   if (old_spte.Dirty =3D=3D 1)         |                                =
   |
-|     kvm_set_pfn_dirty(spte.pfn);   |                                   |
-|     OOPS!!!                        |                                   |
-+------------------------------------+-----------------------------------+
++-------------------------------------------------------------------------=
+
+| At the beginning::                                                      =
|
+|                                                                         =
|
+|	spte.W =3D 0                                                            =
  |
+|	spte.Accessed =3D 1                                                     =
  |
++-------------------------------------+-----------------------------------=
+
+| CPU 0:                              | CPU 1:                            =
|
++-------------------------------------+-----------------------------------=
+
+| In mmu_spte_update()::              |                                   =
|
+|                                     |                                   =
|
+|  old_spte =3D *spte;                  |                                 =
  |
+|                                     |                                   =
|
+|                                     |                                   =
|
+|  /* 'if' condition is satisfied. */ |                                   =
|
+|  if (old_spte.Accessed =3D=3D 1 &&      |                               =
    |
+|       old_spte.W =3D=3D 0)              |                               =
    |
+|     spte =3D new_spte;                |                                 =
  |
++-------------------------------------+-----------------------------------=
+
+|                                     | on fast page fault path::         =
|
+|                                     |                                   =
|
+|                                     |    spte.W =3D 1                   =
  |
+|                                     |                                   =
|
+|                                     | memory write on the spte::        =
|
+|                                     |                                   =
|
+|                                     |    spte.Dirty =3D 1               =
  |
++-------------------------------------+-----------------------------------=
+
+|  ::                                 |                                   =
|
+|                                     |                                   =
|
+|   else                              |                                   =
|
+|     old_spte =3D xchg(spte, new_spte);|                                 =
  |
+|   if (old_spte.Accessed &&          |                                   =
|
+|       !new_spte.Accessed)           |                                   =
|
+|     flush =3D true;                   |                                 =
  |
+|   if (old_spte.Dirty &&             |                                   =
|
+|       !new_spte.Dirty)              |                                   =
|
+|     flush =3D true;                   |                                 =
  |
+|     OOPS!!!                         |                                   =
|
++-------------------------------------+-----------------------------------=
+
=20
 The Dirty bit is lost in this case.
=20
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ae823ebd12b..04228a7da69a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -542,10 +542,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 	 * to guarantee consistency between TLB and page tables.
 	 */
=20
-	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
+	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte))
 		flush =3D true;
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
-	}
=20
 	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))
 		flush =3D true;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 517b384473c1..8aa0d7a7602b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -520,10 +520,6 @@ static void handle_changed_spte(struct kvm *kvm, int a=
s_id, gfn_t gfn,
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
-
-	if (was_leaf && is_accessed_spte(old_spte) &&
-	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
=20
 static inline int __must_check __tdp_mmu_set_spte_atomic(struct tdp_iter *=
iter,
@@ -865,6 +861,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct k=
vm_mmu_page *root,
=20
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
=20
+		if (is_accessed_spte(iter.old_spte))
+			kvm_set_pfn_accessed(spte_to_pfn(iter.old_spte));
+
 		/*
 		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
 		 * see kvm_tdp_mmu_zap_invalidated_roots() for details.
--=20
2.47.0.rc1.288.g06298d1525-goog

