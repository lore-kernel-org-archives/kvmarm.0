Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC291F12EF
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584728; cv=none; b=ohcdzO/TpXz36zGXQK86te7hT2Xo3DRxFRUpHvPplsBYMKDYLf2N88wngE3GAY9DBGvgPpSGjp7rC9CzP1nVAyIrLwD/NG0xn6ghk5zgH1UqSUq3qsEscrkwybC13W7JyzwYvqOAuWVeSs4tukqUPcp/jPqhW8CQzwplvnAd0g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584728; c=relaxed/simple;
	bh=42VPy3Va09DWIWyeI7bQhF4N8yIw+oK2ibHTdiPXTHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u4OLq5JR3BA0VFI7D7vFol9aBwOxC87TDwCUb+M63tPleHpjO+7tAIr9/sEL16nWF14ma9j+n8D+nrMtyExn184AKrw5snmSqkoL//Vi5nkyEUQe/vrmZs9MeASeSzI4H1PGFZqr2QPK8RQTtMMU2/HiDLZYVrzvQNi2bvjWOmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z4pFsN7c; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z4pFsN7c"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71a122bf521so1617049b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584726; x=1729189526; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+RZpPtsk3Pe/RqqhWN1oE7ZGzOesPmt7slwmkU09yw=;
        b=Z4pFsN7cTkP2ksKsD50ULZ0WE/I2tnNSFrhwhsd2upuWXog0csrEB/e+cXQHysHikV
         0Z9Udc4TPIRZ0HovEe1QtlLhGUc2tz28c8c0xMWTBnwQo2wWiH1M5Jbwd3ypA8cbywPL
         o3duIUJCGRsa9UPwo/iM1LrEIjWm3pXOydu9BUGvvse6rOgYJIG0ZuNs8tgvF0GQjWu4
         bWt915ECvCaRtyGu75lIQnakL7ks9UKYXYWUYx/s7UqaCEhvhl3rkgi0+1J/fEvnEXw/
         VwuJDSijPlzS1rf7sEr3+cl1tooyniHCDUPkq/tLmS4g+9CWf8wapaX5ONqHkNpjDpXW
         1Jiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584726; x=1729189526;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H+RZpPtsk3Pe/RqqhWN1oE7ZGzOesPmt7slwmkU09yw=;
        b=EXS5zY8Dvj9rjIOQcKqBSe2sjegrdq8WgG3H0t+tCEXI0enK7en4gQblElSu8L7mVk
         lZz4BZL04nsb0nZXzDxlZ/Ks+LGrxpDAN8JNkWazgoeCDvhiYCS/sJnRQ5Px9YMX0SoM
         y/gIJTEdoySdiDlzQAxVu9QqNSIZX2t4xnKVeBCJPGvjr58YYX3hj6uMruYs8L9/IRmX
         P6A4ptTmEf9xXAPzI03QFmH8zdI01sUbyvOWTP0fTOCY3i3fZCGp/ATEFKWBG5/ZhGJK
         gqjSKT096bLNuLRBZolVp3m+veW4dOkTtztDA6iczJtHQDtnJ5FUQX++buIRiQQQ/QCA
         SFbA==
X-Forwarded-Encrypted: i=1; AJvYcCW6j4FsRoPeqdAKsdDHkIQleXJgI2APWeyFYlC2F8gEEiBlcYiMTUJh2cDfDT6IVZIAH5LYUPc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5uy+1CII3n0BPrmGILI79qO4mhtflLSoAB6zYJ8BWXT/MJjdD
	UdTshI/zG1me5kLoT/iw3sTHhu9St8j/zfgo9uMRZflf0XHiF44YJJtLtCG8FGWM42vrAIL3nav
	t5g==
X-Google-Smtp-Source: AGHT+IEgY3dn5eo0Xr6pp3rAg0uVd1WuwbDag/Dk23UVvT7MMuxyKVAtWc2T42TlMp1H8D9GJ1Oltmo921o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8c17:b0:71d:f452:ee99 with SMTP id
 d2e1a72fcca58-71e1dbcac44mr6866b3a.3.1728584725637; Thu, 10 Oct 2024 11:25:25
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:18 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-17-seanjc@google.com>
Subject: [PATCH v13 16/85] KVM: Replace "async" pointer in gfn=>pfn with
 "no_wait" and error code
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

From: David Stevens <stevensd@chromium.org>

Add a pfn error code to communicate that hva_to_pfn() failed because I/O
was needed and disallowed, and convert @async to a constant @no_wait
boolean.  This will allow eliminating the @no_wait param by having callers
pass in FOLL_NOWAIT along with other FOLL_* flags.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: David Stevens <stevensd@chromium.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 18 +++++++++++-------
 include/linux/kvm_host.h |  3 ++-
 virt/kvm/kvm_main.c      | 27 ++++++++++++++-------------
 virt/kvm/kvm_mm.h        |  2 +-
 virt/kvm/pfncache.c      |  4 ++--
 5 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0e235f276ee5..fa8f3fb7c14b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4374,17 +4374,21 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu =
*vcpu,
=20
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault =
*fault)
 {
-	bool async;
-
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
=20
-	async =3D false;
-	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, &asyn=
c,
+	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
-	if (!async)
-		return RET_PF_CONTINUE; /* *pfn has correct page already */
+
+	/*
+	 * If resolving the page failed because I/O is needed to fault-in the
+	 * page, then either set up an asynchronous #PF to do the I/O, or if
+	 * doing an async #PF isn't possible, retry with I/O allowed.  All
+	 * other failures are terminal, i.e. retrying won't help.
+	 */
+	if (fault->pfn !=3D KVM_PFN_ERR_NEEDS_IO)
+		return RET_PF_CONTINUE;
=20
 	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
@@ -4402,7 +4406,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault
 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
-	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, NULL,
+	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, true,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
 	return RET_PF_CONTINUE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2faafc7a56ae..071a0a1f1c60 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -97,6 +97,7 @@
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
 #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
 #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
+#define KVM_PFN_ERR_NEEDS_IO	(KVM_PFN_ERR_MASK + 4)
=20
 /*
  * error pfns indicate that the gfn is in slot but faild to
@@ -1233,7 +1234,7 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn,=
 bool write_fault,
 		      bool *writable);
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn=
);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t g=
fn,
-			       bool interruptible, bool *async,
+			       bool interruptible, bool no_wait,
 			       bool write_fault, bool *writable, hva_t *hva);
=20
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 87f81e74cbc0..dd5839abef6c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2778,7 +2778,7 @@ static bool hva_to_pfn_fast(unsigned long addr, bool =
write_fault,
  * The slow path to get the pfn of the specified host virtual address,
  * 1 indicates success, -errno is returned if error is detected.
  */
-static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fau=
lt,
+static int hva_to_pfn_slow(unsigned long addr, bool no_wait, bool write_fa=
ult,
 			   bool interruptible, bool *writable, kvm_pfn_t *pfn)
 {
 	/*
@@ -2801,7 +2801,7 @@ static int hva_to_pfn_slow(unsigned long addr, bool *=
async, bool write_fault,
=20
 	if (write_fault)
 		flags |=3D FOLL_WRITE;
-	if (async)
+	if (no_wait)
 		flags |=3D FOLL_NOWAIT;
 	if (interruptible)
 		flags |=3D FOLL_INTERRUPTIBLE;
@@ -2912,8 +2912,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct =
*vma,
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
  * @interruptible: whether the process can be interrupted by non-fatal sig=
nals
- * @async: whether this function need to wait IO complete if the
- *         host page is not in the memory
+ * @no_wait: whether or not this function need to wait IO complete if the
+ *	     host page is not in the memory
  * @write_fault: whether we should get a writable host page
  * @writable: whether it allows to map a writable host page for !@write_fa=
ult
  *
@@ -2922,7 +2922,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct =
*vma,
  * 2): @write_fault =3D false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool no_wait,
 		     bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
@@ -2934,7 +2934,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interru=
ptible, bool *async,
 	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
 		return pfn;
=20
-	npages =3D hva_to_pfn_slow(addr, async, write_fault, interruptible,
+	npages =3D hva_to_pfn_slow(addr, no_wait, write_fault, interruptible,
 				 writable, &pfn);
 	if (npages =3D=3D 1)
 		return pfn;
@@ -2956,16 +2956,17 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool inter=
ruptible, bool *async,
 		if (r < 0)
 			pfn =3D KVM_PFN_ERR_FAULT;
 	} else {
-		if (async && vma_is_valid(vma, write_fault))
-			*async =3D true;
-		pfn =3D KVM_PFN_ERR_FAULT;
+		if (no_wait && vma_is_valid(vma, write_fault))
+			pfn =3D KVM_PFN_ERR_NEEDS_IO;
+		else
+			pfn =3D KVM_PFN_ERR_FAULT;
 	}
 	mmap_read_unlock(current->mm);
 	return pfn;
 }
=20
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t g=
fn,
-			       bool interruptible, bool *async,
+			       bool interruptible, bool no_wait,
 			       bool write_fault, bool *writable, hva_t *hva)
 {
 	unsigned long addr =3D __gfn_to_hva_many(slot, gfn, NULL, write_fault);
@@ -2987,21 +2988,21 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_mem=
ory_slot *slot, gfn_t gfn,
 		writable =3D NULL;
 	}
=20
-	return hva_to_pfn(addr, interruptible, async, write_fault, writable);
+	return hva_to_pfn(addr, interruptible, no_wait, write_fault, writable);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
=20
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
+	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
 				    write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
=20
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn=
)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, false, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
=20
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index a3fa86f60d6c..51f3fee4ca3f 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -20,7 +20,7 @@
 #define KVM_MMU_UNLOCK(kvm)		spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
=20
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool no_wait,
 		     bool write_fault, bool *writable);
=20
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 58c706a610e5..32dc61f48c81 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -197,8 +197,8 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cac=
he *gpc)
 			cond_resched();
 		}
=20
-		/* We always request a writeable mapping */
-		new_pfn =3D hva_to_pfn(gpc->uhva, false, NULL, true, NULL);
+		/* We always request a writable mapping */
+		new_pfn =3D hva_to_pfn(gpc->uhva, false, false, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))
 			goto out_error;
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

