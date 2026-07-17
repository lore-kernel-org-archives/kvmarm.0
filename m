Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18BE3546C3
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293748; cv=none; b=oRH8LqHLtNweRe4+U5c8vKzk49cctTppzcHxFZL35ATpJMqNpGw8vyGd6LeEb+7Wpe3f/+R3vjyJJm5iwnFgTbnpHDc80989ZSNUvJdPNC5vyP9JAcejo05F77rmIvXcgEMjDY3eYW6tUOg4WCgwOG0ZVRNbxDbJ1AHvmflQ+sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293748; c=relaxed/simple;
	bh=kHv+nS4iJ3RfuYjzkETMJs9ejwONqp1/BT4HoVMehqc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=u2tfLMnsYVwc3dcqLjTODjZ0HWESgWUhVpdhD0ggOTIEvDgrofsShaz/5IN0MmrEWqMppb/peyPN4VSgKB3cSXbBlsy2qLxVYyCK/5sx/DeFovQibKt+ZRULuQh86MQ6KRo0O4TG+nagfoun7CwUs818MpULjI/EycHTvPmt5U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qtdd2Gne; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qtdd2Gne"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4954b1c6310so4588905e9.0
        for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 06:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784293745; x=1784898545; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=S08p5kQZpXbD9KawmMzLPf/sCiQ1d3STxcaWnwOPLP0=;
        b=Qtdd2GneJNb/y26zGkhWMt7O3RtXB+jfpZ+koqkf5jsmATOJwOX1NzIT+efft7kVZF
         nz7+uqz6iHYymyoG+TFQm8d9PVoiuR5HMGSpzfzqO9N27jAx/Z2kNh5zR7hHofnU2rpu
         i26Lgg/Xh9fsi6u+X0yh+jwT6MqjbNSXQkLVcwUhbfeAbzNKAbMlwNpooOqLaHjwYnFc
         Fmw81i1ExBaLBp2d4lltucccFMN8ySgKfaM7QWa2Io/JoAJxzrhyoragRHekIuFNe1Ye
         z5hDN2zH8/JuxYBWGnRDaEcXFFPYFQSRhn2XRxpBRYDfcaStJqK9L0AqZLlwIu3j8bbO
         DpyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784293745; x=1784898545;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S08p5kQZpXbD9KawmMzLPf/sCiQ1d3STxcaWnwOPLP0=;
        b=ku82L5qG2I+t0b36TAOxIkxthYbzu2bYYAbcVzf4cvxfno1cigNgZEMwgKO/2EXvri
         JP3Y0LCk8GnTPv9vkD2Yl2OMHHBONfBueG+wGriCkFOnDl85PTf9JJ8pQXulgUe2PFi/
         EbaC4zRKHvGNkqmgmVhwEJbNoAQ1IeMfht6dWhWHFXYHn6gPpMNbUPy4rMxH+DwANSDe
         XPZgNUBPng0XKL8eVd/MbA1ClIg6NPbS6kXwmQYlWvflOpnMZscCr/7GzbUTfPpsQwGz
         6UERr6MpRnyK4/4ykuu6b42jN2cDuhxhDKcU/p3GEnCQYd6gaXql3BCcznux4wQUkvgo
         QDEA==
X-Forwarded-Encrypted: i=1; AHgh+Rq/NuQhw487fLwAkqbsyX/XPJ3N+etIZl2mwtrj1HTNAsGzhXRFGdybB3EIy8yo2y0QORN8C+E=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYSeQRxYUa3jBOOIIdYFHxnv7c5Pu+rgAckLmAJJfhS4Ob5Tvs
	yzMMkL/kYjzNV72j4gJKjkbRK/JapZRI3Zq6w40eHzgklXyhmU1TsMWRsr39URJugiKDB19qZLM
	rHGX77sm1y3/dvg==
X-Received: from wmco24.prod.google.com ([2002:a05:600c:a318:b0:493:c42c:7e97])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:190d:b0:495:3da0:3f52 with SMTP id 5b1f17b1804b1-4954a40e0efmr29494085e9.19.1784293744623;
 Fri, 17 Jul 2026 06:09:04 -0700 (PDT)
Date: Fri, 17 Jul 2026 13:08:58 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260717130901.2239134-1-smostafa@google.com>
Subject: [RFC PATCH 0/2] KVM: arm64: Support BBM level 3
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch series adds support for BBM level 3 to KVM pgtable, it
depends on [1]

Motivation
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
I have been looking into this for the context of:
- Page table sharing between the host CPU stage-2 and the SMMUv3 for
  protected KVM.
- Use the pagtable code to populate SMMUv3 stage-2 shadowed
  page table [2]

However, BBM level 3 is still useful for CPU only operations as it
avoids intermediately breaking translation.

Design
=3D=3D=3D=3D=3D=3D
Some of the conditions that BBM level 3 will be useful in (RWHZWS):
1) A change to a PTE memory type, shareability, cacheability or OA
2) Changing from block to table
3) Changing from table to block

At the moment in the hyp page table code:
- For #1) stage2_map_walker_try_leaf(): Replaces a leaf with another
  one which does not match the same OA/perms/attrs.

- For #2) Switch block to table is used from:
  - kvm_pgtable_stage2_split(): Explicitly splitting a block (used
    for dirty logging), where a block is replaced by a table with
    the same attributes.
  - stage2_map_walk_leaf(): Updating a mapping that is partially
    part of an existing block.

- #3) Does not exist in the code at the moment as coalescing is not
  supported.

The first patch is a preparation to be able to clean up the old pte
for BBML3, the second patch adds the main logic.

Initially, I encapsulated the full logic of BBM in one function,
which was not readable, due to different ordering and dealing with
CMO, TLBI.

Instead, I kept the logic into 2 functions, where BBML3 is added in
the make step.

One interesting case, as BBML3 will update the PTE atomically, it
can only know it raced with another core at the point of the cmpxchg
failing, unlike the SW implementation which locks the PTE first.
And as we must issue CMOs to the new mapped page before the update,
that means with BBML3 racing cores will issue redundant CMOs, to
improve this:
- We only use BBML3 if the old PTE was live
- To reduce the window of the race an early check is added before
  the CMO to exit early, but that does not eliminate the race.

Testing
=3D=3D=3D=3D=3D=3D=3D
This was tested:
- C1-Pro cores, unfortunately the version I have does not run
  upstream, I backported the patches to Android kernel (6.18).

- mainline(7.2-rc3) kernel on a Qualcomm X1 with a hacked cpufeature
  as it does not support BBM, I did not see conflict aborts or TLB
  corruption.

I tested with VHE and protected (hvhe) modes, running VMs
(and protected), and running some selftests, that might exercise and
stress this path tools/testing/selftests/kvm:
- demand_paging_test
- memslot_perf_test
- memslot_modification_stress_test
- dirty_log_test

Future work
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Some other changes that would be useful for the SMMUv3:
- Eagerly install table on block split, we can now replace a block
  with a fully populated table atomically when we unmap a partial
  part of the block.

There is more to support page table sharing (such as dealing with
TLB invalidation, coherency=E2=80=A6), I submitted a talk to LPC to discuss
this further.

[1] https://lore.kernel.org/linux-arm-kernel/20260715053408.1950475-1-linu.=
cherian@arm.com/
[2] https://lore.kernel.org/linux-iommu/20260715115906.2664882-1-smostafa@g=
oogle.com/

Mostafa Saleh (2):
  KVM: arm64: Add stage2_clean_old_pte()
  KVM: arm64: Support BBM level 3

 arch/arm64/kvm/hyp/pgtable.c | 118 ++++++++++++++++++++++++-----------
 1 file changed, 82 insertions(+), 36 deletions(-)

--=20
2.55.0.229.g6434b31f56-goog

