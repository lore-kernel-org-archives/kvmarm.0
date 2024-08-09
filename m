Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C41D224EA
	for <kvmarm@lists.linux.dev>; Fri,  9 Aug 2024 20:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723236726; cv=none; b=TKeMto4ZaWxRj8OSUgXuwzSoRDTHH0tOVdAWY7Xh9Kwh+7/5P7+RSgDHfWgUG+rVPwP/6PWVG4vQKrrbx9X15M6lcW/kDDT5tfnpX2A1GV3/diPRozpFuc9wXfcq3G4CPhNqRXAXgXJ8/NVUfvanuiTMG+fmVIrQTueXruwtx8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723236726; c=relaxed/simple;
	bh=1anqAy8fT1MGYT3I+PKXHPOtjMAFrcgXwt1RXjcw+Po=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=b3b+CZlwM4bfi+dy9Mu+ETjtecH/bV84YAq93veMC+PLeT3q0iS2d1rxws27ZrH8FV9qNFUT0sr1UvKePjq8LmR+6M0rdG0ueGpxOiifCMUKGGlHpKiDsXQpyZmYTRahFhwFnjip0FcGQa6hvYVQPcKA4oslr/8WdlaIjYH+KXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Azs1uhn2; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Azs1uhn2"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02b5792baaso4564071276.2
        for <kvmarm@lists.linux.dev>; Fri, 09 Aug 2024 13:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723236724; x=1723841524; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A4+5TrpZq4HAa4w9PgdpjPk93jtMryZRUO8oHZ/7sY8=;
        b=Azs1uhn2VSVZYzZJ2VfDM8TkYWpW8+o32r/aVfq1UaGtNcGqfupkXse2VZ8w0pqtUP
         5tpk4psC9hg23yn7zUdvjZ1pqs+ko3x+14EoNJYVlOF/MGeR1LSqRfZtRRKYARodnMAs
         xboF7c2jURbZ6TJHGSA+ZYiysh7ukrCjZZEEltijDWHEMI9H4aIS3GF8cBKPSBBclBJ+
         n7d37gmJocY9R4CjVXOqGwcFt4+VLZKZRX6ruXVYeOnY0Yr9gzFb/vH+nRMST68RGLTI
         WBRvneN1Pr7PTCENRKa5+jfnpro0uE7neNGC+lv+3NYxhR6dA93rGDgbowv3dMHuvByq
         nY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723236724; x=1723841524;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A4+5TrpZq4HAa4w9PgdpjPk93jtMryZRUO8oHZ/7sY8=;
        b=CPR7IVLRZYrD8uffDJu28QsL38eoOX2KRF4WHC/FhLiZn30koVW9l1EkTVqov5/Tku
         jZPktKGJ2xQob/G646DHYygSmPgVKNjBS0F48t0HTdX1L4kK7vNsQLOMggfoKf+XoWP8
         /MbGCGgtyi6IzyOg0ek+UNeCVzmN42Dz09OBmrM9u4MaoCxyjkbuIFiN7QTHoEmkEqzf
         P73qfmdXNFCZ8kr2fwM1EzjwCSVMtbSlqG+H5+rlLQdiSoqkpUrJrFcFNcrF0BiUI9IC
         r41zgsAdpLpKODl+vgpkn1gMSoKYvZlyBAhbjYVTBeSdXpxK+KBDqAxdRofEN1xXCi19
         Bh2g==
X-Forwarded-Encrypted: i=1; AJvYcCWGEr0oOEIq6vBfHEwXMCl6SlTXYsBPStpRd2D60vBcM2oHyJjqba2G/xS1YyDzfszb6piibC0lCLPg5nbpZrSA2lutWzOy
X-Gm-Message-State: AOJu0YxDV/NHulRqKDLcsd+eOYYbPFMY1a+6M6RN3z1p4Z4J4v+RhLeI
	/4bqz1uxvG7wDaPeZPqOme5hkDGN2pXNS60FEDKRJ4gfZo9wV/6no9gzWMTA6jQFGorNVZEHPq7
	ASAj7If3/vw==
X-Google-Smtp-Source: AGHT+IE9n+LsI9d1YYx3M/iz2GdVBTIdsBXN4Gvuxr/50LgDSU5FDsg4j9qGx9xJ04AkL3tGxGnDh3bNCAIxHg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1749:b0:e0e:89e6:aad4 with SMTP
 id 3f1490d57ef6-e0eb977fa58mr18658276.0.1723236723973; Fri, 09 Aug 2024
 13:52:03 -0700 (PDT)
Date: Fri,  9 Aug 2024 20:51:55 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809205158.1340255-1-amoorthy@google.com>
Subject: [PATCH v2 0/3] Set up KVM_EXIT_MEMORY_FAULTs when arm64/x86 stage-2
 fault handlers fail
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: jthoughton@google.com, amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

v2:
  - x86 patch unchanged
  - Arm patches merged [Oliver]
  - Do memory fault exits in *all* EFAULT cases of user_mem_abort()
    [Oliver]
  - Add patch to tweak docs for KVM_CAP_MEMORY_FAULT_INFO

v1: https://lore.kernel.org/kvm/20240215235405.368539-1-amoorthy@google.com/

Anish Moorthy (3):
  KVM: Documentation: Clarify docs for KVM_CAP_MEMORY_FAULT_INFO
  KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2 fault handler
    EFAULTs
  KVM: arm64: Perform memory fault exits when stage-2 handler EFAULTs

 Documentation/virt/kvm/api.rst |  7 ++++---
 arch/arm64/kvm/arm.c           |  1 +
 arch/arm64/kvm/mmu.c           | 11 ++++++++++-
 arch/x86/kvm/mmu/mmu.c         |  1 +
 4 files changed, 16 insertions(+), 4 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.76.ge559c4bf1a-goog

