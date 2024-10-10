Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674BD20125E
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584775; cv=none; b=t3X4pDGVw+NSLAzIeNZrxRKOC6b7UiT/J81O0taWfq7UXp6/Fq1SelGg2k24/xbZVwEvU3pFCxZgoYzegnxgauNqCgRikHZ4h4qeKSAJNpBfbDwOXpUrJXH2pB7CT780bzuzLTIL3duw4lHDOioxgnXBLXXleyE4zjtNED2/Zd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584775; c=relaxed/simple;
	bh=AMgsQWUhFHfCzgS24A9rVoaxkKJ7Z500dfTCiVjIUZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e+u3vahikq02TLfjHmTbAWa97oWLCUZFh06NPzf2xPw8sb0ifJuSPWqX47UG2T12n8WC3qAlDTULXCy7dN5bd4pxE/5QZMSrHvDMKdHFo36rykZdPAO/r4GTi7smU2vySFQP1MUDhoh9tORzqxmQAL3eOGyPtzyPFFZXRCbiLbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SKju0y3b; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SKju0y3b"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-206da734c53so13139735ad.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584774; x=1729189574; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLMllFEXz5NbCB79T5EDeXxXCOdT0E/lPN9LlBgR2FM=;
        b=SKju0y3b4pBlpZpt7FMpyh7NQjJCIZo1FPcB2AowMGjida+DSST2iap8HAh7Kn/EIg
         AwJ7bf1tR0qm9hwYpImtks+yuJjQPWXQKfOObhclVWnFp3Uh7rjz39qdjnXnG/G3KwAQ
         4OTZm8nrXvAqcZ4rSthmtrNFrwjGQzBk1pAqzQifjtyRH+fW9lMrE5eq3dxZ5xdAw1Ze
         5yYmJ8GaZk0BmrcRBMDje7+ioEolNXgzKjPk3zwcuDmpZ+KafCaMjH/YTi+b3lr6FtT5
         2QbfQ9UC+48UJFBvI8bJN/fDRXPMctbokw6RkwmgziZYbMqShO2otFvaR0YawzVbje0F
         kk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584774; x=1729189574;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bLMllFEXz5NbCB79T5EDeXxXCOdT0E/lPN9LlBgR2FM=;
        b=JZKJSD2B7YQVBkQwi91E+jc7R8l2iz3Brx0Hpuy+CU6XgvyhVl1BT7WUKwn1QfPfnd
         gnYJSUfHGfG7/MUq50DeKcNWwRHd5sZXmnxici5rLIUL9wkH4trBZN/nkCzVo1YnxOQv
         dZjqKDqmdmNEDDQaEPa3uO0ICalfhudkmlCxhMaBtlX3WKh/0KjjiMWAKnuJMz/f3ZMX
         xzvXpSgXGQ1Zvw7tw1bh/zUIDy8CEo9NGG68NuJOQQCJx8RWCADeVtpmlL/0IXD/VLVV
         voEimnGHHKgCWbgi6omSvyM+Xow3COtkQp1UiJCNFuS1OSypTG1Nx8qSbqJDVFwM1oL6
         GV1w==
X-Forwarded-Encrypted: i=1; AJvYcCWj+Rz3h3jXpKzBqWLA6iYpVHE3TdKkUao1DC5sfvsx52Rkql/usmYdUNdaCAuVLISQgTJiNY8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTrwjYrAeg1GJKzr46Lkl82qcPrLhj/bIY44Tb9M+SJKJH0vZB
	iYpRMPfIrIoxY3oeoYIdiOc5HppmHL/uicsS8RoC7NIo1ueicm/ii01bwCmoUY75qNzCwPqEek+
	eQw==
X-Google-Smtp-Source: AGHT+IHTeV3dFyfdACUyzit3PmgjtoD4THwZ77SaAB8Cv7KtK6sEvfc4IjBdPT+nDHGdhMcMXcKC7R1qaBw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c8:b0:20c:716c:5af with SMTP id
 d9443c01a7336-20c716c078dmr946605ad.3.1728584773496; Thu, 10 Oct 2024
 11:26:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:41 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-40-seanjc@google.com>
Subject: [PATCH v13 39/85] KVM: x86/mmu: Add common helper to handle
 prefetching SPTEs
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

Deduplicate the prefetching code for indirect and direct MMUs.  The core
logic is the same, the only difference is that indirect MMUs need to
prefetch SPTEs one-at-a-time, as contiguous guest virtual addresses aren't
guaranteed to yield contiguous guest physical addresses.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 40 +++++++++++++++++++++-------------
 arch/x86/kvm/mmu/paging_tmpl.h | 13 +----------
 2 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 62924f95a398..65d3a602eb2c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2943,32 +2943,41 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, stru=
ct kvm_memory_slot *slot,
 	return ret;
 }
=20
-static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *sp,
-				    u64 *start, u64 *end)
+static bool kvm_mmu_prefetch_sptes(struct kvm_vcpu *vcpu, gfn_t gfn, u64 *=
sptep,
+				   int nr_pages, unsigned int access)
 {
 	struct page *pages[PTE_PREFETCH_NUM];
 	struct kvm_memory_slot *slot;
-	unsigned int access =3D sp->role.access;
-	int i, ret;
-	gfn_t gfn;
+	int i;
+
+	if (WARN_ON_ONCE(nr_pages > PTE_PREFETCH_NUM))
+		return false;
=20
-	gfn =3D kvm_mmu_page_get_gfn(sp, spte_index(start));
 	slot =3D gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
 	if (!slot)
-		return -1;
+		return false;
=20
-	ret =3D kvm_prefetch_pages(slot, gfn, pages, end - start);
-	if (ret <=3D 0)
-		return -1;
+	nr_pages =3D kvm_prefetch_pages(slot, gfn, pages, nr_pages);
+	if (nr_pages <=3D 0)
+		return false;
=20
-	for (i =3D 0; i < ret; i++, gfn++, start++) {
-		mmu_set_spte(vcpu, slot, start, access, gfn,
+	for (i =3D 0; i < nr_pages; i++, gfn++, sptep++) {
+		mmu_set_spte(vcpu, slot, sptep, access, gfn,
 			     page_to_pfn(pages[i]), NULL);
 		kvm_release_page_clean(pages[i]);
 	}
=20
-	return 0;
+	return true;
+}
+
+static bool direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
+				     struct kvm_mmu_page *sp,
+				     u64 *start, u64 *end)
+{
+	gfn_t gfn =3D kvm_mmu_page_get_gfn(sp, spte_index(start));
+	unsigned int access =3D sp->role.access;
+
+	return kvm_mmu_prefetch_sptes(vcpu, gfn, start, end - start, access);
 }
=20
 static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
@@ -2986,8 +2995,9 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vc=
pu,
 		if (is_shadow_present_pte(*spte) || spte =3D=3D sptep) {
 			if (!start)
 				continue;
-			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
+			if (!direct_pte_prefetch_many(vcpu, sp, start, spte))
 				return;
+
 			start =3D NULL;
 		} else if (!start)
 			start =3D spte;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index 9bd3d6f5db91..a476a5428017 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -533,9 +533,7 @@ static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     u64 *spte, pt_element_t gpte)
 {
-	struct kvm_memory_slot *slot;
 	unsigned pte_access;
-	struct page *page;
 	gfn_t gfn;
=20
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
@@ -545,16 +543,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm=
_mmu_page *sp,
 	pte_access =3D sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
=20
-	slot =3D gfn_to_memslot_dirty_bitmap(vcpu, gfn, pte_access & ACC_WRITE_MA=
SK);
-	if (!slot)
-		return false;
-
-	if (kvm_prefetch_pages(slot, gfn, &page, 1) !=3D 1)
-		return false;
-
-	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
-	kvm_release_page_clean(page);
-	return true;
+	return kvm_mmu_prefetch_sptes(vcpu, gfn, spte, 1, pte_access);
 }
=20
 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
--=20
2.47.0.rc1.288.g06298d1525-goog

