Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EAC1FCC45
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584767; cv=none; b=qFH7fsR45n7OMUoUzJWerNaHOqDrnLaUfk+shEpOUfJ+VqY6TyYfgRT5p+cZsuRemYrpB+S74MLBx+SAU0YB31FshjOgqPQiACtLHJTsbkUmpS/VzHMnnFIVG2FFX6wbeF64q3K7bIz3Onk/A8PFOVXiK8Zfz5f1HCuWJwwADL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584767; c=relaxed/simple;
	bh=JluxJpntN2XzeRJ5Yz03kdoesvuYdAA2z8LW9UOaBnA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pr2BZivmeEMdSSGsDKK2NhYa13gGcZEaAAbJgP6XymxVVtlaestVDpd4VLkLnM+AUnKo/HT0T9DQQcngViHoV5AZq2biBnBF8yQn7wBmCbMbnuDhmXbhDgMC5g9roZCeNKoInwH0+dHMNaDtuS9xdn5oH21Etl6wAgRw/F9XWsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oAH6rEVd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oAH6rEVd"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ea37e8894bso1587459a12.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584765; x=1729189565; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ByBZxBThzycQ9+5cWv7LHsEIs8PvxVG+sWS1etQw10Y=;
        b=oAH6rEVdX1iG6YddvXZLMMqqiJVvTUdxUwNrp1pAuiCDNqEsLs/pnpQxaaYuUcyN/h
         J+lZl+f4g8VpROT3/RfQtaazUGKAALPrvEa0sK8nb5h7acp3J+Rz5hf0nqCDbIMCp9o5
         idORLdRYFVhkCg10qFNLBqvtaTnDaG/ACkCvolE1GuqzsJZjMZJ+r/uTV9ONnK0gmSre
         0JIB4xptVmWEMYRQeErK37pSnWDzsLEytYVl1xMcjrv1zUuA/NKd+QUZEVcXSTmhcBk5
         D4UErXFSKzuXiOGykoQOblDYhRGqqFJeMctWTMIJFSQ9ElHDNIm9vE/zyunkaF3hyDKF
         le4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584765; x=1729189565;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ByBZxBThzycQ9+5cWv7LHsEIs8PvxVG+sWS1etQw10Y=;
        b=kF+Uswi5pHnmh9ys3fid3yilm4oSJqy+sQhzq4TU8ng6fODG/Ut0fL54s9mb3Kkzbu
         rragYKPWeVn0qlbxgyNTL9dTRf1lplUm3YL1FqrlmblkBQkMvkPnT8z26BHTv7S5lSPH
         LQT4jMYrwlc964X3Cy5b6oDK5SA1SUVRHYiIynhdq8PKg4/A1WIvgxYV9nROpyxElDYm
         I5zUOMcFRTMw6abnYqlf+Ocga4GE5sDUrhnfet34o5W+JzuOD5iHrgVi7QTcri620dWT
         +he/B96UUYvUasUMuMyYjACKJ6YOrhW3XxUdFkD2S+YCUdcDMUW0LRBRou/0taaCtPjn
         MHdA==
X-Forwarded-Encrypted: i=1; AJvYcCXv84Kgxjz2+STKoDtfIVSQ9gD4Erp4op0mct22Hr2kYrlnxNxuuINsK4HX+vG1Pv8oDhwhLw8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVym9i5ze8a+WhoKC5oYvuCji8DVOcQiOeUtWonAIjZl8qe5hY
	Ko0d95kzDydmI7QHgmAfwaVYSRgrL44iEnLMJSFfqJ2DVB/XSfW0hcW5Hd0SThFwiz3wUeoANdu
	y/w==
X-Google-Smtp-Source: AGHT+IE23QkhjcWr/3QASJ/S9+dapZUNy7Z4CCepJKqapzuUx8eBu6OhWGfM5laLrlsw47tRhKuFSYugMsQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:ff61:0:b0:7cb:c8c3:3811 with SMTP id
 41be03b00d2f7-7ea5356a658mr52a12.5.1728584764791; Thu, 10 Oct 2024 11:26:04
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:37 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-36-seanjc@google.com>
Subject: [PATCH v13 35/85] KVM: Disallow direct access (w/o mmu_notifier) to
 unpinned pfn by default
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

Add an off-by-default module param to control whether or not KVM is allowed
to map memory that isn't pinned, i.e. that KVM can't guarantee won't be
freed while it is mapped into KVM and/or the guest.  Don't remove the
functionality entirely, as there are use cases where mapping unpinned
memory is safe (as defined by the platform owner), e.g. when memory is
hidden from the kernel and managed by userspace, in which case userspace
is already fully trusted to not muck with guest memory mappings.

But for more typical setups, mapping unpinned memory is wildly unsafe, and
unnecessary.  The APIs are used exclusively by x86's nested virtualization
support, and there is no known (or sane) use case for mapping PFN-mapped
memory a KVM guest _and_ letting the guest use it for virtualization
structures.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b845e9252633..6dcb4f0eed3e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -94,6 +94,13 @@ unsigned int halt_poll_ns_shrink =3D 2;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
=20
+/*
+ * Allow direct access (from KVM or the CPU) without MMU notifier protecti=
on
+ * to unpinned pages.
+ */
+static bool allow_unsafe_mappings;
+module_param(allow_unsafe_mappings, bool, 0444);
+
 /*
  * Ordering of locks:
  *
@@ -2811,6 +2818,9 @@ static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pf=
n *kfp, struct page *page,
 	 * reference to such pages would cause KVM to prematurely free a page
 	 * it doesn't own (KVM gets and puts the one and only reference).
 	 * Don't allow those pages until the FIXME is resolved.
+	 *
+	 * Don't grab a reference for pins, callers that pin pages are required
+	 * to check refcounted_page, i.e. must not blindly release the pfn.
 	 */
 	if (map) {
 		pfn =3D map->pfn;
@@ -2929,6 +2939,14 @@ static int hva_to_pfn_remapped(struct vm_area_struct=
 *vma,
 	bool write_fault =3D kfp->flags & FOLL_WRITE;
 	int r;
=20
+	/*
+	 * Remapped memory cannot be pinned in any meaningful sense.  Bail if
+	 * the caller wants to pin the page, i.e. access the page outside of
+	 * MMU notifier protection, and unsafe umappings are disallowed.
+	 */
+	if (kfp->pin && !allow_unsafe_mappings)
+		return -EINVAL;
+
 	r =3D follow_pfnmap_start(&args);
 	if (r) {
 		/*
--=20
2.47.0.rc1.288.g06298d1525-goog

