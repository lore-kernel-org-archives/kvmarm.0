Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C381F4FAC
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584733; cv=none; b=TtX4nGYs/c5xK5tvPcalkfZo+yfGpffQJfr3LqIMglkG+pIciVuS69OXHR1ttVh1ulOzvnSkExa2iT7682dFgmC/CoT6JzUTfI5HgB7+mMxWVKBKqrZALokkzOzL30/M7SjCvPiBjqwZT83nAtxxF9OhwbuLBn9aFukutTQZPVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584733; c=relaxed/simple;
	bh=gORZY+kwKqxFhTI7jRiw4mW6KKJknMWDgC2YkpetElw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fOb38K0ptUaVHqSA7tD7Zligjj4RaAV6jLPm63Th5xbDof3M543YXm9VSk1O0XBnPpSuuKXgnSg0OmxLO5JZYgD8PIIoTinP3vVkRPaEVP3YzR5UiSdtNw3Dmx5rVTwGrEHeWNUzsVU9hoD/Nno807pxe3rDICdu1tU0ma384Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FjhItsM9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FjhItsM9"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e18b6cd304so1250441a91.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584731; x=1729189531; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KxFe7qyo4eHIzhTxczhq6OF5aBNVD8CbU/vq6HHGwtQ=;
        b=FjhItsM9yeRAuKgiMlpLvSkq3PapC4ft0tBNZT1FXSjuL+WjOVkvkK3uLXxvF32Yn2
         UaZUjaJLuo51/dv0gILnl86N91ExmGDHgk9zjAtkcHScyHlDu46ByBFqdcLDi1zSBm5w
         FmsxCHXxvqeNQWxF4RhRgqMks9SiTiWTs8BvBhEA1Eae4XMLdgc2U4Hl9hCg+eSUZsMw
         KtvXIDvCwdLk0qw/a/56oGKcpxsxK2M1fzhc5I0U6IT/hXlUm5nS4njkIV/ogwQiCp7C
         yzDXQBNbx0GVDdT4eE417CW8Jw/0LgFk0US6oGwLmM9lcUe4hRq8IrKpyvwmFY4jfoAA
         uxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584731; x=1729189531;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KxFe7qyo4eHIzhTxczhq6OF5aBNVD8CbU/vq6HHGwtQ=;
        b=llmkQO+TJlCVfI/AmKQh1ReSAKtlBho8mWO9NO+ab9wXV+KqENHeXprlanUMRZ1OuL
         2BPZGT4hjwWYZfQD7Am7VoCRwgETHCmq3paYkbRtCZDht8D73Qo74/8uZL6A9SYV9RHb
         RjYQ1GWiXImQXg6DpbqIhS0MliOge/nTjcNKN0FLW5+f4yMPXC8SpqwAYvUKo5VeW1D2
         zfAkcnzOsB172MaT1rqcuYgbXlAK0SMpSTHhEHAXR7wvmStYcqqm9kyM652rSFMslnfu
         MwhlkZslOfT9WtCj88nEIesjkz/+eIRR3+tkoJFuGsRzFGgS39RpBIbUSLrYEACj85iB
         rB1w==
X-Forwarded-Encrypted: i=1; AJvYcCXCIWYQyhxFU0raf7WOCmbyulgUFi16NgpbFrK87TfYgxd6kvjB0iobLiN13wx0coJx6PIzg+I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyP252ark2xIU/oEZCAko4Fqi3TbW43/G8O/A5KduVgn74HNnir
	hOGgR9yoRHW386cKZKqdmammegMeIJ1JTKiVhf/Li82LRl6prM4ri0nnJbfkC0O6MNSdjeyHICS
	bzQ==
X-Google-Smtp-Source: AGHT+IGFsZ8G+8oqHMXYnd6l/b9oSo3/s957bEBlaeuh+YsQIWv/Tzia2RQhXQw4+rIMPn/3epGKWmgCn2Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5107:b0:2e2:ca3e:10fe with SMTP id
 98e67ed59e1d1-2e2f0f88a54mr20a91.8.1728584729847; Thu, 10 Oct 2024 11:25:29
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:20 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-19-seanjc@google.com>
Subject: [PATCH v13 18/85] KVM: Drop unused "hva" pointer from __gfn_to_pfn_memslot()
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

Drop @hva from __gfn_to_pfn_memslot() now that all callers pass NULL.

No functional change intended.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c                   | 2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 2 +-
 arch/x86/kvm/mmu/mmu.c                 | 6 ++----
 include/linux/kvm_host.h               | 2 +-
 virt/kvm/kvm_main.c                    | 9 +++------
 6 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a6e62cc9015c..dd221587fcca 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1570,7 +1570,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
=20
 	pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable, NULL);
+				   write_fault, &writable);
 	if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_=
64_mmu_hv.c
index 8cd02ca4b1b8..2f1d58984b41 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -614,7 +614,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	} else {
 		/* Call KVM generic code to do the slow-path check */
 		pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, &write_ok, NULL);
+					   writing, &write_ok);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page =3D NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book=
3s_64_mmu_radix.c
index 26a969e935e3..8304b6f8fe45 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -853,7 +853,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcp=
u,
=20
 		/* Call KVM generic code to do the slow-path check */
 		pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, upgrade_p, NULL);
+					   writing, upgrade_p);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page =3D NULL;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c67228b46bd5..28f2b842d6ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4377,8 +4377,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault
 		return kvm_faultin_pfn_private(vcpu, fault);
=20
 	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
-					  fault->write, &fault->map_writable,
-					  NULL);
+					  fault->write, &fault->map_writable);
=20
 	/*
 	 * If resolving the page failed because I/O is needed to fault-in the
@@ -4406,8 +4405,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
 	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, true,
-					  fault->write, &fault->map_writable,
-					  NULL);
+					  fault->write, &fault->map_writable);
 	return RET_PF_CONTINUE;
 }
=20
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 071a0a1f1c60..cbc7b9c04c14 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1235,7 +1235,7 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn,=
 bool write_fault,
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn=
);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t g=
fn,
 			       bool interruptible, bool no_wait,
-			       bool write_fault, bool *writable, hva_t *hva);
+			       bool write_fault, bool *writable);
=20
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dd5839abef6c..10071f31b2ca 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2967,13 +2967,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool inter=
ruptible, bool no_wait,
=20
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t g=
fn,
 			       bool interruptible, bool no_wait,
-			       bool write_fault, bool *writable, hva_t *hva)
+			       bool write_fault, bool *writable)
 {
 	unsigned long addr =3D __gfn_to_hva_many(slot, gfn, NULL, write_fault);
=20
-	if (hva)
-		*hva =3D addr;
-
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable =3D false;
@@ -2996,13 +2993,13 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gf=
n, bool write_fault,
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    write_fault, writable, NULL);
+				    write_fault, writable);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
=20
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn=
)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, false, true, NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, false, true, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

