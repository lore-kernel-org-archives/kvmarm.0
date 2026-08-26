Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165B11990C7
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787734925; cv=none; b=WYWG0OptlXmgK7zh/nmLQ78U3U9vOllqEWHzcLHZKfkep+rdQjePqN4+bPpejv/pDn7hGwYrLCD4+E76WB0p/isBAibOzYWTMqKNxDZlDdupLDXXIg2RQzL6Gz5qiNLIY05znzdWfnEoFvF1SG8D8lI3UYQtb2rB3JGSvnN1E1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787734925; c=relaxed/simple;
	bh=OAlLWBhYYG/9ob/PX5hBH6y+Ywi1lILRcsrUDjKKezs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WrFlt3T+vWCZIKJEsPeenjB0Wxbz2Xb9DF07tDM4ShshgL4ia5sh+Wqzlu1IrHWD7Mlf/MkxW8Y41y8+ageTvhKxk1FLHJeBjrugrAvy9UemMc52cNLlI/CSfbVn+lJDL8oJCRByjSDcIej3HwXylMuFBglacz14edZ4i7C0J+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v7/I4e+e; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v7/I4e+e"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d63c16fc5bso17850365ad.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 02:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787734922; x=1788339722; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q1tZdo4e5URbud8PZx65gIP4aGbHrtpDN3AOBapMbqs=;
        b=v7/I4e+eEvxUv4EhT0RYlONMffIDO6mw0l3x9wtG9q3JZzl8qxeCm0BH3jOCw/QQCd
         5tMzerwgnkBzmjO1AU/7gsY6Qr/216nAU6XoXODsxn2pta4hPM+791ZF4utpr4cwHVH/
         HT30nw4sAUHC+Ysl9Vhs+Cy0sRKxZu45rSIBsqnKJIONAono2w57b8VeG82nw+FvfnVG
         aoqAizVXZhxn+u1xWwl0eGByK/PSM4JaTYG2fzbkX9bB+e3h6EZqDDIZKcokRh88eTeJ
         xoI+lRC3FeAZkAHvkRUATxOvvC9KE5NUZi/XIgqLkqkBhURMZ6N4c1f3wNM0V85ZQ6qz
         RZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787734922; x=1788339722;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q1tZdo4e5URbud8PZx65gIP4aGbHrtpDN3AOBapMbqs=;
        b=ZvFXDuawVBXjgDXz5dQjGK3AWhHHBr99MdtJvsOzQlNVdi/YYhZmIlrWQpF9Rqnj6q
         ZowV1sJj3hlgfO3QN2jb7KPgGRjvXF/q000EGnQ6j3ZWdIJeTO04ZrcsFGInsMNXgwBF
         svZfEkQEFUvHmjICRTICFe6MxOel/9rFWiGVNHxl538XM5uhejEDPExSAGB7iuwRjfeL
         N0ic91fqaavtbkxGJMZrvozpl+Q0qzBPfwo/MrTGN9BywqIoMkRM8m8B8pftdIaE8AU7
         u+NtFddF/+HyoCx8kN8Ii18iIhRNAn6Q7N2QFjAyt2nhC/P5U1FrVLAdSaQgxZtLXiDe
         UeVQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp64r4D6LsCT31s5UjwnYLx4VcRQRdvHNzWPdS8Hl2E8/2xo0bcNm6ZAFUUy3Fyw+BWUVUpJmk=@lists.linux.dev
X-Gm-Message-State: AFuF++l6p9+ls2dnOkpnTJkraot0Ib/lyAt2CmDqoT3mGcaLREP6moo2
	t7TH5wrq/Dq/g7EwAxiN5e5FX60kljkES3OhZyunXTChGbHa0yGNbbsSCbPAm0iiLCnIOxm5Yvv
	tJBDLy4ydVPlVmQKX/DPR1seEHw==
X-Received: from plbko13.prod.google.com ([2002:a17:903:7cd:b0:2cc:bb5f:3fd7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:284:b0:2d6:2901:6265 with SMTP id d9443c01a7336-2d707953a1emr98628575ad.2.1787734922088;
 Wed, 26 Aug 2026 02:02:02 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:01:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAHmrjmoC/43NwQ6CMAyA4VchOzszyoTNk+9hPGysG0uEkYFEQ
 3h3ByeNxnj8m/brTAaMHgdyzGYScfKDD10KvstI3ajOIfUmNQEGJRO5oK7FlnaBRhxvsaO9Sit
 lziVUCqSVFUmXfUTr75t6vqRu/DCG+NieTPk6/e1NOWWUW2FkIdEaXZ9cCO6K+zq0ZAUn+AOBh BxACsvBcKn1B1K8IMC+I0VCCm2FFUxVmps3ZFmWJ7gutz9BAQAA
X-Change-Id: 20260818-gmem-no-return-page-614927a29f97
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787734920; l=1513;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=OAlLWBhYYG/9ob/PX5hBH6y+Ywi1lILRcsrUDjKKezs=; b=daPi3Fjs1SSb8r0p9nYFDfhMv5JgbSUJww8xvwdjn/5ezcuq3olIFhfPZsB7H97tyDKbuwa/i
 HzQS2OkcWgBCL8fXp9OmJpR3tdyNqhLN3UNa4IWubqk/JfORozIirAG
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
Subject: [PATCH v4 0/5] Stop returning struct page from guest_memfd PFN lookup
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

v4 splits out a new patch (3) that makes use of KVM MMU invalidation logic
introduced into the RMP fault handling in patch 2 to avoid warning on a
benign case.

Other changes in v4:

+ Took Sean's version of the changelog for patch 2
+ Picked up Fuad's Reviewed-by: and Tested-by:

v3: https://patch.msgid.link/20260820-gmem-no-return-page-v3-0-3bf8f80a7b4d@google.com
v2: https://patch.msgid.link/20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com
v1: https://patch.msgid.link/20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (3):
      KVM: SEV: Treat unassigned RMP entry as benign race on PSMASH failure
      KVM: SEV: Check for invalidation before warning on unassigned RMP entry
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
base-commit: 76671054f9a1ff6abb976583cd8da37650acdc97
change-id: 20260818-gmem-no-return-page-614927a29f97

Best regards,
--  
Ackerley Tng <ackerleytng@google.com>

