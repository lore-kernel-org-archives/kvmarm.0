Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA247314A98
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 23:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787268763; cv=none; b=hLvesSZjdrs42GYzJI6xcqm3JXzGCZbK9cqMGqZz2y0dTdtzHVCF+95KRQgcjfTGuZa0SVajGOSN+W2oTO1wQBEpcsBwm+baoV3mbc3M84x+pz4CwC9WxqiadCIQ5gB22ceGF3tRhC/lbsg1FOW44Ap++/pUgSRDcfaAoLFCzVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787268763; c=relaxed/simple;
	bh=0qkgLp/4gNYJUuC928LKmD9dsDMVKNfciXFJMMiMswQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gVXDlpgzG0AKo2X0zA31evzXd14K82d/GCQOqYG9kn3ylgyTjDFzN5BUsw0DbH/fDgAjXGoBQvKud7ONDia88jY9qRjmIksXDRUlnzm/X7kKKoygcE861bRAG0Q1YYG2DxOKJcDRiMp47fCCdfbLl1CVLWqb/7ldaJlAQuwhaNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XA4mNIVG; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XA4mNIVG"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ce7dff6253so15370355ad.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787268760; x=1787873560; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AMZ8TZYQN/8a08d3ypLOFhqk0OwFZ/bONgMFOnHGK/o=;
        b=XA4mNIVGuQ85cIGym3pNCkQPGI9j3n6JGVJliN3A1aeJibUxPuvlbYa7fruAfktxfh
         DaIrtVZS7p7tEudaj+7+jiFhTmUTOc5205TBdhBCwtee8arvPjQmOL0qlI2YdSkS6VwR
         3kr5ROyKsQsiRwzR8dClkItUlD9W6ZiGQFlySX1rGjNd7j9qM0fbJW875eTmnAdIceHn
         fK3moHHBNw5jygXfboiagJwTd7pXx+Y0RJVwTazeYw9zhLPl24gL+LFhkNXv33TyuqdX
         tWxl32GNhG6NL5Y1dxF2xWyQrweVOxzD5UwZP5fcsGGH0DKIIzqABvYwBkfEBvbW+F2J
         H+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787268760; x=1787873560;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMZ8TZYQN/8a08d3ypLOFhqk0OwFZ/bONgMFOnHGK/o=;
        b=rCnUmvHY+VUsrkrhmy52Ro7fFiVxWKtb1vpYnFa5zYcVygt1f6QOxfWUrLcPYb3mpN
         GtD8yBo413NZ2Eb0W83MqUvIWizPsIduBnPuKZw5JpojApMnkBdnXzTEySz5i62pREQE
         nFhhw9oipoc2LcthFnmBncnhxBKYBNdTREj4ExlYhwHAF0Ekg1vk+ERwrQZiVRJCO0gZ
         VrRg2BnA2z2ox0bnpaSyoDZ8JccNMvx9NWLStkWRZ70Z0HOwjSoClfggFIY3TdPAajIe
         aTJq9kg2i476zqxHUBQEuoo+mr8cvnT3qD0YGHyhFd9+v7L40o8TsvCcZdP5wxe/HtTy
         O9mQ==
X-Forwarded-Encrypted: i=1; AHgh+RovBBjxRJTSYKCyPDN6NLt5RPMSYhwLLweCsZX5YXJS+RdHjct4EWfXMTYaev+LMvnAjD5ej7w=@lists.linux.dev
X-Gm-Message-State: AFuF++l35io9Ls/1ZngpqO2jQk35L7XzuMq9NCNVn1kWkxlohDiHiEWT
	DOr4zlmMGhMslyjS3nMR1JlkoDmXLb6FwgSM1613G9SVrcD4MdoT++L/sr6YhMCwJBSCFNongrt
	3iUCPNS6FIc9W4JOIkaKJwQWmmw==
X-Received: from plpl10.prod.google.com ([2002:a17:903:3dca:b0:2d2:c22c:7b8a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:90d:b0:2d3:6cb4:e79e with SMTP id d9443c01a7336-2d64d2f0e55mr17242035ad.5.1787268759872;
 Thu, 20 Aug 2026 16:32:39 -0700 (PDT)
Date: Thu, 20 Aug 2026 23:32:33 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAJGOh2oC/43NwQ6DIAyA4VcxnMcilSl42nssO6gUJJlgwJEtx
 ncfettl2fFv2q8riRgsRtIWKwmYbLTe5ahOBRnGzhmkVuUmUEJdCiaomXCiztOAyzM4Ond5pWZ
 cQtOB1LIh+XIOqO3rUG/33KONiw/v40li+/S3lxgtKddCyUqiVv1wNd6bB54HP5EdTPAHAhm5g BSag+Ky77+Qbds+wNxaIPwAAAA=
X-Change-Id: 20260818-gmem-no-return-page-614927a29f97
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787268758; l=3107;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=0qkgLp/4gNYJUuC928LKmD9dsDMVKNfciXFJMMiMswQ=; b=ogJoOeNVzQpGoZquHAyFAMhLUlsTEwH4nWVvd8g1viOFNq1LGLdgW09j6Da0GMCMrYkPKCI0R
 YUrVrSgZ40hDPh7cUE96XyRxIlKhPEVMZJb7/gE2D0pbDbN+uO8UwO2
X-Mailer: b4 0.16.0
Message-ID: <20260820-gmem-no-return-page-v3-0-3bf8f80a7b4d@google.com>
Subject: [PATCH v3 0/4] Stop returning struct page from guest_memfd PFN lookup
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

KVM currently expects kvm_gmem_get_pfn() to return a refcounted struct
page. Callers (such as x86 TDP MMU, arm64 Stage-2 fault handler, and SEV-SNP
VMSA / RMP handlers) hold this refcount across page fault handling.

CoCo shared-to-private conversion handling must inspect folio refcounts to
ensure exclusive ownership by guest_memfd. A concurrent guest page fault
taking a temporary reference on the folio causes conversions to fail due to
an elevated refcount.

While this refcount is also taken on host userspace page faults, that
refcount is taken on behalf of the host userspace page tables. This
refcount will be dropped when conversions unmaps the page. Either way, once
there's an mmap() or userspace mapping, the pages are open to way more
refcounts, transient or not. This series focuses on just dropping refcounts
before handing KVM a page.

guest_memfd already notifies KVM of page invalidations, so callers within
KVM only need to respect the MMU invalidation protocol to safely rely on
guest_memfd for page presence.

guest_memfd already notifies KVM of page invalidations, so users of guest_memfd
within KVM only need to respect the MMU invalidation protocol to safely rely on
guest_memfd to ensure page presence.

This series first prepares the SEV-SNP handlers by treating unassigned RMP
entries as benign races on PSMASH failure (which can occur on concurrent
truncation) and dropping page references early in the RMP fault and VMSA reload
paths. It then updates kvm_gmem_get_pfn() to drop the folio reference internally
and stop returning a struct page pointer across x86 and arm64.

Removing struct page from kvm_gmem_get_pfn() also moves KVM closer toward
supporting memory backends that are not backed by struct page.

This is built off Sean's sample code [1].

[1] https://lore.kernel.org/all/an5RJYTwlYeym--O@google.com/

Thank you everybody for your quick reviews and testing, I really appreciate
it!

Changes from v2:

+ Picked up Reviewed-bys and Tested-bys
+ Addressed comments

v2: https://patch.msgid.link/20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com
v1: https://patch.msgid.link/20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (2):
      KVM: SEV: Treat unassigned RMP entry as benign race on PSMASH failure
      KVM: SEV: Drop page refcount early in VMSA reload

Sean Christopherson (2):
      KVM: SEV: Drop page refcount early during RMP fault handling
      KVM: guest_memfd: Stop returning struct page from PFN lookup

 arch/arm64/kvm/mmu.c     |  4 +---
 arch/arm64/kvm/nested.c  |  4 ++--
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 arch/x86/kvm/svm/sev.c   | 53 ++++++++++++++++++++++++++++--------------------
 include/linux/kvm_host.h |  6 ++----
 virt/kvm/guest_memfd.c   |  9 ++------
 6 files changed, 39 insertions(+), 39 deletions(-)
---
base-commit: 1b731e5ded480bd1e5546aed35584238661ce72e
change-id: 20260818-gmem-no-return-page-614927a29f97

Best regards,
--  
Ackerley Tng <ackerleytng@google.com>

