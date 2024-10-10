Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EA4206073
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584798; cv=none; b=REhxh18l/AKYRo5Gk+QymbXMfpY/fnkc+X/HbosSjBVgzlZZPnEwJjdEmdJnVpCCfcWqqRxdtOaCfptqSZ2U8iA9UmuchllC/uClwYdAYLxONIqvatekcEEh2D4QlToXT4ZmOIewJ7sRhvV7NlineoKvoNR1ijRyQJyxWmtK3fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584798; c=relaxed/simple;
	bh=7Japh8LNPjEnA4nandXvXnjfnzZjLu2hqYfo+wet/X8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GvHP/uRSbre5kyMZOu+0OE/9H3h35fms8iAxlzfujk41gcrkM4r/3cd3C2AIf2xYFbbTJ43Gh1ctH2IKNme9v3PTIJmTBQvfT0KI20cNDfSi78HziKYEsNxD2h2sTEOuL4By+dfGqnfyr1ZqxW2p6OrEU1V4/ss3J8ILRI/fQ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iubZGgaw; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iubZGgaw"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7b696999c65so863530a12.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584796; x=1729189596; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ndpfmsd07O3XHkbROvy9SWySHpmtrF0LUOG5EHCQjAE=;
        b=iubZGgawn73CkwV1h+qXsqo+H7iNtSCS/mw2SizsCWTNofHXkOllQx/hQ+4g8zWzmf
         DcUy3vKX1djOP2GwVzoEY8P50KlxvIZLW5HlGZy0OPkJ1Ks8r5fO1nNRlC1ByAdzvg6+
         Aa0ICg0KqG+LP4PnXKjQjWHkzYmqh8VpGgaGuUeKiIujKJemK54U5Qrrfish1CmYCabx
         5nG2+GSy913bm39Ydgv5TbyA7PzkYOHF1njMBW4eCB2g17HdRptbRlCepqN9KZrJHuft
         YgC3jc13Xjd2fhUZY1DKXQtTurdjymDAoeFefaItGJ+EFEBY5AXGx5tITpgfbvFdDc71
         OR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584796; x=1729189596;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ndpfmsd07O3XHkbROvy9SWySHpmtrF0LUOG5EHCQjAE=;
        b=gYa0lFMMbqjzBm6iCytIwozlWhyWr5GWZm984V3r8RGwqd3jIYwS8hvMPCwL7Eproe
         lQrjhlimINR7U6zIJ4z4QehBznuZwxpdkVJStH36MxbEBJpDK7x+uG0jTvq5Y/aBCSfY
         xWPUs0mjjfzA+8Zf6sLl4NkkAsjl2cC3GuWU8s2ROgLAvKwgEjBnMhgoXy+ewSZy1nMM
         3SZSijOvTJUq5YxKIYv3bb/GZfa2YEtfWuwsTTMo6w/K1HBRx3BNx9mDyE5FMyV6AweR
         UHmHoFl/Jc41BFAGGdgejJEn9a1Fg/i+ZWgd7xQenz9b2rpIX39OPn475PrMiPA4BakC
         pRug==
X-Forwarded-Encrypted: i=1; AJvYcCXaJIXB39MQNU60fbUM55Qzz8UfE7r47SC1PPZuW3B2sGvlqLHokIOGiJZ5IHhIuCjjI0dZC3s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWNsTMBdg20u/eWVFQuu07YSjYWqfT1Ug5LuZ1MEIQYuEm7kmC
	juQj6kO+/x5WGmbNm7RCO/NJ0eY0Dvfvop2aXjmHYWmDV3RQUNYxSTBF5Q9doJOKvBGRumG6x+/
	Ucw==
X-Google-Smtp-Source: AGHT+IGJc8hgBZq6lOovV4Dgly5ctIXEs7jDnJfEupYxVqninaLorgqTg5WNW0BPJZYnJnHdEtp0yWaf7UM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a65:450a:0:b0:717:a912:c302 with SMTP id
 41be03b00d2f7-7ea53525e73mr49a12.1.1728584796119; Thu, 10 Oct 2024 11:26:36
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:51 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-50-seanjc@google.com>
Subject: [PATCH v13 49/85] KVM: Move x86's API to release a faultin page to
 common KVM
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

Move KVM x86's helper that "finishes" the faultin process to common KVM
so that the logic can be shared across all architectures.  Note, not all
architectures implement a fast page fault path, but the gist of the
comment applies to all architectures.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 24 ++----------------------
 include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e14b84d2f55b..5acdaf3b1007 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4370,28 +4370,8 @@ static u8 kvm_max_private_mapping_level(struct kvm *=
kvm, kvm_pfn_t pfn,
 static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				      struct kvm_page_fault *fault, int r)
 {
-	lockdep_assert_once(lockdep_is_held(&vcpu->kvm->mmu_lock) ||
-			    r =3D=3D RET_PF_RETRY);
-
-	if (!fault->refcounted_page)
-		return;
-
-	/*
-	 * If the page that KVM got from the *primary MMU* is writable, and KVM
-	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
-	 * may mark a folio dirty even if KVM created a read-only SPTE, e.g. if
-	 * the GFN is write-protected.  Folios can't be safely marked dirty
-	 * outside of mmu_lock as doing so could race with writeback on the
-	 * folio.  As a result, KVM can't mark folios dirty in the fast page
-	 * fault handler, and so KVM must (somewhat) speculatively mark the
-	 * folio dirty if KVM could locklessly make the SPTE writable.
-	 */
-	if (r =3D=3D RET_PF_RETRY)
-		kvm_release_page_unused(fault->refcounted_page);
-	else if (!fault->map_writable)
-		kvm_release_page_clean(fault->refcounted_page);
-	else
-		kvm_release_page_dirty(fault->refcounted_page);
+	kvm_release_faultin_page(vcpu->kvm, fault->refcounted_page,
+				 r =3D=3D RET_PF_RETRY, fault->map_writable);
 }
=20
 static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 504483d35197..9f7682ece4a1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1231,6 +1231,32 @@ static inline void kvm_release_page_unused(struct pa=
ge *page)
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
=20
+static inline void kvm_release_faultin_page(struct kvm *kvm, struct page *=
page,
+					    bool unused, bool dirty)
+{
+	lockdep_assert_once(lockdep_is_held(&kvm->mmu_lock) || unused);
+
+	if (!page)
+		return;
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
+	if (unused)
+		kvm_release_page_unused(page);
+	else if (dirty)
+		kvm_release_page_dirty(page);
+	else
+		kvm_release_page_clean(page);
+}
+
 kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
 			    unsigned int foll, bool *writable,
 			    struct page **refcounted_page);
--=20
2.47.0.rc1.288.g06298d1525-goog

