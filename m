Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF44202F93
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584780; cv=none; b=CrXam1yIwT3CWBlJrsz6ORVYYQ+mq23L/XJmVJ6dBOFMVmIGaQMKacUyErgQHTUWNwGhQeQF1oHWIW4Ub7n+Yp2QapWK4RNTvrSmlxUkQQmfug3GURnt9fJfKDGLP87tKe2fKo+t9uABVI9gnbPtJCXzKgdRNufUSghddz0h1e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584780; c=relaxed/simple;
	bh=wP8WMCipPwqkHPMKwQ03EbdALKWDvH1se8OSiGfXvd8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JdupKfT9pr+PN5FMZdrO2+aQ1HXmj+WxN8Eyg9VW0ftugJFHkboWopyviMKcLHvulFYwjhuD5cVMdFbioTC+7NrzhWbWlA5saZBlqNKH86nN29YUcJWBIr3PnGB820fV2DI2nQ1+GaRfgSkZkvRtT5A+SHFvb2Ie4AYdPAl1YDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xN5xGkmP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xN5xGkmP"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20b921fa133so13297375ad.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584778; x=1729189578; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgK+YcjRpEQ+YhbfYv/o4akq/yPA2qNOXCMP41gc9EY=;
        b=xN5xGkmPPCMRtB+hke+Afg+964Q18CBhiNQbkHa8rN7zrWJ+stTvStHQGa77EEGb5R
         CPUKUB4PoQej16QUfo7uY5J6MXqg3i0e92LfSUOL+YG3aP4zOgYo64D6cYGAG1Aqi3K4
         0WqVSctUYWM9M8gTKVLN9+VBs2w5LA7M1U667SzwEKIOflUvi4SdTyTjf1D295N2a1iD
         cBsoBv6i36L1fQYulZMZU+oVacIxffJKkxt9uqSnNWx03eLrrC9wTzOaS2GnBf4ykDVs
         ZMhJ9zWlt9JdDgm+4BS6Ym0lGiR23017BQPiFFgdVRe69EEVzdnqdl9tHHBE2qVtbiVc
         S2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584778; x=1729189578;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sgK+YcjRpEQ+YhbfYv/o4akq/yPA2qNOXCMP41gc9EY=;
        b=EVVE8/h2aydcMD9g0Vso6HtAjrkbPUx9vzztub1DHwBBtMUYoXJkQqlFws7GqUGUhe
         0ACZ6I3a+Cz207eYkBiqhFCTdrymv8+3ViMRiXKNruG7erDDhYekfasH2nLWvSsgnaqn
         7ZQ9pPXHis34L+QuINIdN94vAdWcFAhNe+tyLtpO49eHixlapNF3qA33qXwMNY8BkuLo
         jQ8ATeth2ItwZ9f470CXpHLREPyT1qRwHiTd9d4hw+iDK9OBBBM5QW31PSx3vDljvzxc
         ism8YbY/81JqXtdcfFW4xGmjyhHOGV38D+nlYgKslgaPOEkJLcNcAuX5p6LDmeawHWIT
         kGuw==
X-Forwarded-Encrypted: i=1; AJvYcCXEqNVHRl7d3O1++xQu8NNffFT7t39xlY3ZXtb5FmeKhBQkBgRmWFrU/eYJyVr607mpTWxr4W8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw73NvmKnfL51Mz2wDJpHUgAFP8qC2HoSIlp+PcEi2JMfsM+vg/
	0Y6AB4d2kX4nFNEMVTLr/rqzW7j+5s9B9lYlVOLFg30+0jgw9HzGT/szFyXtA0I1v5Iw5y/YBMY
	bNw==
X-Google-Smtp-Source: AGHT+IHgES02wxBmUBuw4MXImaMxOgBvLS6HzbS699NHinso/VI3SIlimd+hdhb5F/AgwxmTSyUtUzYKtBo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec85:b0:20b:7bfa:ac0f with SMTP id
 d9443c01a7336-20ca037f212mr485ad.1.1728584777475; Thu, 10 Oct 2024 11:26:17
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:43 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-42-seanjc@google.com>
Subject: [PATCH v13 41/85] KVM: x86/mmu: Mark pages/folios dirty at the origin
 of make_spte()
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

Move the marking of folios dirty from make_spte() out to its callers,
which have access to the _struct page_, not just the underlying pfn.
Once all architectures follow suit, this will allow removing KVM's ugly
hack where KVM elevates the refcount of VM_MIXEDMAP pfns that happen to
be struct page memory.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 30 ++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h |  5 +++++
 arch/x86/kvm/mmu/spte.c        | 11 -----------
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 31a6ae41a6f4..f730870887dd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2964,7 +2964,17 @@ static bool kvm_mmu_prefetch_sptes(struct kvm_vcpu *=
vcpu, gfn_t gfn, u64 *sptep,
 	for (i =3D 0; i < nr_pages; i++, gfn++, sptep++) {
 		mmu_set_spte(vcpu, slot, sptep, access, gfn,
 			     page_to_pfn(pages[i]), NULL);
-		kvm_release_page_clean(pages[i]);
+
+		/*
+		 * KVM always prefetches writable pages from the primary MMU,
+		 * and KVM can make its SPTE writable in the fast page handler,
+		 * without notifying the primary MMU.  Mark pages/folios dirty
+		 * now to ensure file data is written back if it ends up being
+		 * written by the guest.  Because KVM's prefetching GUPs
+		 * writable PTEs, the probability of unnecessary writeback is
+		 * extremely low.
+		 */
+		kvm_release_page_dirty(pages[i]);
 	}
=20
 	return true;
@@ -4360,7 +4370,23 @@ static u8 kvm_max_private_mapping_level(struct kvm *=
kvm, kvm_pfn_t pfn,
 static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				      struct kvm_page_fault *fault, int r)
 {
-	kvm_release_pfn_clean(fault->pfn);
+	lockdep_assert_once(lockdep_is_held(&vcpu->kvm->mmu_lock) ||
+			    r =3D=3D RET_PF_RETRY);
+
+	/*
+	 * If the page that KVM got from the *primary MMU* is writable, and KVM
+	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
+	 * may mark a folio dirty even if KVM created a read-only SPTE, e.g. if
+	 * the GFN is write-protected.  Folios can't be safely marked dirty
+	 * outside of mmu_lock as doing so could race with writeback on the
+	 * folio.  As a result, KVM can't mark folios dirty in the fast page
+	 * fault handler, and so KVM must (somewhat) speculatively mark the
+	 * folio dirty if KVM could locklessly make the SPTE writable.
+	 */
+	if (!fault->map_writable || r =3D=3D RET_PF_RETRY)
+		kvm_release_pfn_clean(fault->pfn);
+	else
+		kvm_release_pfn_dirty(fault->pfn);
 }
=20
 static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index 35d0c3f1a789..f4711674c47b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -954,6 +954,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, str=
uct kvm_mmu_page *sp, int
 		  spte_to_pfn(spte), spte, true, true,
 		  host_writable, &spte);
=20
+	/*
+	 * There is no need to mark the pfn dirty, as the new protections must
+	 * be a subset of the old protections, i.e. synchronizing a SPTE cannot
+	 * change the SPTE from read-only to writable.
+	 */
 	return mmu_spte_update(sptep, spte);
 }
=20
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 8e8d6ee79c8b..f1a50a78badb 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -277,17 +277,6 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_p=
age *sp,
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
=20
-	/*
-	 * If the page that KVM got from the primary MMU is writable, i.e. if
-	 * it's host-writable, mark the page/folio dirty.  As alluded to above,
-	 * folios can't be safely marked dirty in the fast page fault handler,
-	 * and so KVM must (somewhat) speculatively mark the folio dirty even
-	 * though it isn't guaranteed to be written as KVM won't mark the folio
-	 * dirty if/when the SPTE is made writable.
-	 */
-	if (host_writable)
-		kvm_set_pfn_dirty(pfn);
-
 	*new_spte =3D spte;
 	return wrprot;
 }
--=20
2.47.0.rc1.288.g06298d1525-goog

