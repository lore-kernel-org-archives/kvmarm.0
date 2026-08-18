Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FFF41DDF5
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 08:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787040779; cv=none; b=senYUkaL9SKHbc3Nq7w7oBzlkTOn75yrfsUIhBheQvpW1fnsQbX3OfYP0ORcs9N8/hLhMCEz+w0nPxpbHt4M1znzTr0xSacovatCp3sESXs+WTpYsN/E6hrwPw3mXoBVHDgjndTt/HgBaLJfMC96XoOuO6nClRGGInOJe5ftlzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787040779; c=relaxed/simple;
	bh=KUoipSs9DV2GhPl9YTTVY+WfBDpInNarT6aPDX8hhug=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YwvUd1CFcStNCPvRDBXCkmjitAuxKz7v33GpbyLMTgcyftz2yi0Kxw/XbvDgxGlCmacXszpFmnyJ5o1P7bE5oyGSySZqLuzQieb8FNfnVkewsPvTpLTFZu5twhOOzSmqEOYc+HjIPmMUfUn/+F6oVGjFB4nW4P54g+gNQ+ONfeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U7hIV0ck; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U7hIV0ck"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso5141626a91.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 01:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787040775; x=1787645575; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mMKkYkkk95GIb9XsCQRRxhKodLzIwxWFmxxwcGqUN7k=;
        b=U7hIV0ck9OyWo9bTDY9LEzUAUI7+u45yMy4KiDqubOJtsIIqAKoOpRRfFuCGJ/uBgt
         pUCIWgGhPn82e+y3CVx2Mqy9iho83pc0nABHwzXD7KHV/cajlY9ec96B2sVNA1/PSOdM
         61E/sqBEidB5R/h0b3v9PiHrVgdhgK3AcpmznfRn36hnTPhdspRDCowkAw2QsQdeC/BC
         rmv2asEtqzSdR92MeI/V5LhVfbxR/R4eZtcJtaq1w9W8Nu4e8tLpUpmSf8E3o1jCcXJw
         Ru0U7HtL+kCcvXNlGGeAup9vz7qeewwu/CiMd/dlcYPHJLgXtc2V8DbD4vvKlBzpG5+7
         aW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787040775; x=1787645575;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mMKkYkkk95GIb9XsCQRRxhKodLzIwxWFmxxwcGqUN7k=;
        b=N4Sqg6ESk/l0LVxp3ehTO1I4nNCu7JuYDxlMkgqFa/0oDx1KIFeUqV5SpvcM24Pf5T
         RqciL3qkHCj6oVtvAErzVpVXwVRoMMDsB6NNuOfSWDWh1fYbHRSZZetEKQLpCqNDCMK9
         lZXDr6rRvbzMo/Q2zB8PvOZbNy4HnT2ep7IsSwaHDyxeVGdxQ0Z5EZtLKhv4DEPVjdLx
         7wYLwm3IJFtk/DNuq2u3fU5E11CnKUYZkHWNuo80hZpomFNpmzsm1Af4+/ELQx9DBPIf
         A84BXFNjT0BneF07hKEkULxN90P6ImywbCMVVQuBF6JUQ7mr4rFkr0F4r1f3pLMrqEKc
         eRoQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpbkxcu2ahrs60paSKAHfYOHk/wzKZndfgmACl8veo5X2dJ/HB+DORrAjq9yfNaLZajzXfblOM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxT0ekJVzthudIC2Ip4XVTW1BBd0ETqywG/GSgXlN79nPL0j3QX
	IZFN5KgWV7jZbUjfiFNRTqfQuXCCHuBCvCcJi1fYa6Bv7sQnG6q5rgvcBnfLxzWhTCuBenaDYY9
	ZR0jXjJGi+FlPWnjtnNIHJ/q3aQ==
X-Received: from pjbei20.prod.google.com ([2002:a17:90a:e554:b0:393:13be:cfa8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5606:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-3933b78b698mr33144681a91.6.1787040774461;
 Tue, 18 Aug 2026 01:12:54 -0700 (PDT)
Date: Tue, 18 Aug 2026 08:12:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAPIThGoC/x2MQQqAIBAAvxJ7biElMvtKdJDabA9qrBVB9Pek4
 8DMPJBJmDIM1QNCF2dOsYCqK5g3Fz0hL4VBN7pretWjDxQwJhQ6Tom4u6J0qrXaOG1Xa6CUu9D K938dp/f9AI9JCcplAAAA
X-Change-Id: 20260818-gmem-no-return-page-614927a29f97
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787040773; l=2686;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KUoipSs9DV2GhPl9YTTVY+WfBDpInNarT6aPDX8hhug=; b=EgeFYXGdnee+DqtAZAuFl7wPqeYsRZalvhJWB/S8hZkwyGM7a68a6iJ22FyMAzillodZx4SYz
 nbxSWklOZHEDh9KJySZJXlhyxArVikRqndiYwykZKzHFaFyg+9DTUs0
X-Mailer: b4 0.16.0
Message-ID: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
Subject: [PATCH 0/4] Stop returning struct page from guest_memfd PFN lookup
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

Holding a page refcount across fault handling is problematic for guest_memfd.
In-place memory conversions between confidential computing shared and private
states inspect folio refcounts to ensure exclusive ownership by guest_memfd.  A
concurrent guest page fault taking a reference on the folio causes conversions
to fail due to an elevated refcount.

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

I really want in-place conversions to merge in time for 7.4 and so I went
ahead to try this, building off Sean's sample code [1].

The main difference from [1] is that I think sev_handle_rmp_fault()
currently doesn't correctly handle the case where a racing truncation
removed the page from the RMP table. With that fixed, I think
sev_handle_rmp_fault() doesn't need to adopt the MMU invalidation protocol.

I also split the patch up so it's easier to review :)

[1] https://lore.kernel.org/all/an5RJYTwlYeym--O@google.com/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (3):
      KVM: SEV: Treat unassigned RMP entry as benign race on PSMASH failure
      KVM: SEV: Drop page refcount early during RMP fault handling
      KVM: SEV: Drop page refcount early in VMSA reload

Sean Christopherson (1):
      KVM: guest_memfd: Stop returning struct page from PFN lookup

 arch/arm64/kvm/mmu.c     |  4 ++--
 arch/arm64/kvm/nested.c  |  4 ++--
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 arch/x86/kvm/svm/sev.c   | 17 ++++++-----------
 include/linux/kvm_host.h |  6 ++----
 virt/kvm/guest_memfd.c   |  9 ++-------
 6 files changed, 15 insertions(+), 27 deletions(-)
---
base-commit: 1b731e5ded480bd1e5546aed35584238661ce72e
change-id: 20260818-gmem-no-return-page-614927a29f97

Best regards,
--  
Ackerley Tng <ackerleytng@google.com>

