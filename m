Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDACC3BB675
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 18:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784830916; cv=none; b=Mo56bBRwz3tDGyWs2ox+/WhbDydVmtCbttY+LqOFez8C+WE+ylMbxGJXmg3OnZlhqAtLDJZlazsE9f2mnkLXywux2LSIjzWIBr/kuhYmju4IO4k6cDpajF1F3a6phSOOAT54CR+36f+8Mjp4TrpKoFgliHkANr2KFikkSm/3RUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784830916; c=relaxed/simple;
	bh=Y8zPSkJhgEwpcGvfvuTG8GkMIhbfsd22DIIsBqUqPLk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=URtOsm5GClwirbYAyW2WbeKqqH+z+5Hh/OBZAH18zbvlURfe7GsJvnXf6Feyi+svKl+prfFBsEviS4QapqeseRCyqKy3wIamDnOEI9OXwRcB62tIA+us7j3DlCduuBE7iSbGdrVyGEGzk43DLhb6ria/RFv89dyrwccxsni9PVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lEmE8pBl; arc=none smtp.client-ip=209.85.221.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lEmE8pBl"
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47d81cf0c4cso666571f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 11:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784830905; x=1785435705; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8+lHjdE+3DloA2hsk7g0E45gyAxlw5fhHa47aoUOQ2E=;
        b=lEmE8pBlGNOFRVNIFbjvhu0z8m47EgCJZADml66BguHtlDMH3GeX+hIyDWsLIDeQxQ
         cHc7sXOn+d/KgW733zCv4mHX+3XXe31v4f3fQinMnyTHEBZMS9JjSDZaVkLW/OVMqQmG
         0u0ilS/4M+4nAmsV4hguYIo9UwMOq85ko/Bvq8Z66xXVH59r7HaK/e7jhA5ZT7VfsQfM
         6GLxgrIFPrHnugI6CEDXmtfeZ5gw/OnbQ0f9hr56UR4+p2nXqon3Ab/cJF/jH8XZzTDe
         TJ3BwDjUiahoQ5EJuIEZ+OPSqmfwrpE5QrMdSyHItAaBmVi87+fE8roc3LZK+lsNNnfd
         0M4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784830905; x=1785435705;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8+lHjdE+3DloA2hsk7g0E45gyAxlw5fhHa47aoUOQ2E=;
        b=NEIxIQHPoGqSFAKKdGN7jZwyeoiq7QSw+/oGVv9+8qaekg1dTixR3MZx+zoyMidLJY
         AMooj3vpYLOAGmATpLC+szDns1/99OtyBL7dEgKEAQ/UWGqh0vyJ6COCyvGd2cMe3wvg
         Xl5VS9O18fFbPQuIh1k+hhaMHuCp2tCAdpoigcfZE3kArj6QnZNb+fVzOUUg7tLNW5Z/
         ZlMs69v696auFuEi0HiPW4gPwe1/g1lqQ+QPE174qhlgu+E2wOMSOHELupKE3m8pP20c
         owT/5vYrpsty+ASvekrOX1EsVOwxdWdV5kdiCsiUdpN7k22djlifZiQheAQLnstWHLxb
         6pVA==
X-Forwarded-Encrypted: i=1; AHgh+RrbszXiEcGg5Twqw4yf8QWJHRdRXRz50NP0VMGA9ha1OZ19rCSblxU3gx2TJXrqtXx//e997KI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZuy1FAzqqFlOjaowkfTRSWaxYiU2NTFJm9h2rD3yHM/6HWx3P
	8CHsMeaXTtHai4VYPOWc6ihsOn5JCGRejT9MnGTwIAalKUTKlc0zJs2nY0kwtA0/K0ZIv0PBLS/
	GivQcPJrVXeDw3w==
X-Received: from wrbdv10.prod.google.com ([2002:a05:6000:d8a:b0:47f:501a:8813])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2011:b0:46f:7d90:8121 with SMTP id ffacd0b85a97d-47f8d71c689mr5489116f8f.14.1784830904536;
 Thu, 23 Jul 2026 11:21:44 -0700 (PDT)
Date: Thu, 23 Jul 2026 18:21:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723182140.4025575-1-smostafa@google.com>
Subject: [RFC PATCH v2 0/2] KVM: arm64: Add support for BBM level 3
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	linu.cherian@arm.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series adds support for BBM level 3 to KVM pgtable, it
depends on [1]

Changes from v1:
https://lore.kernel.org/all/20260717130901.2239134-1-smostafa@google.com/
- Limit BBML3 to systems with FWB and DIC and remove race check.

Motivation
==========
I have been looking into this for the context of:
- Page table sharing between the host CPU stage-2 and the SMMUv3 for
  protected KVM.
- Use the pagtable code to populate SMMUv3 stage-2 shadowed
  page table [2]

However, BBM level 3 is still useful for CPU only operations as it
avoids intermediately breaking translation.

Design
======
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
avoid this, we limit the use of BBML3 to systems with FWB and DIC.

Testing
=======
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
===========
Some other changes that would be useful:
- Eagerly install table on block split, we can now replace a block
  with a fully populated table atomically when we unmap a partial
  part of the block.

- Use BBML3 in the hypervisor stage-1 with nvhe/protected mode to
  improve preformance and reduce memory usage as now it is forced
  to use leaf mappings.

There is more to support page table sharing (such as dealing with
TLB invalidation, coherency...), I submitted a talk to LPC to discuss
this further.

[1] https://lore.kernel.org/all/20260723044034.2983651-1-linu.cherian@arm.com/
[2] https://lore.kernel.org/linux-iommu/20260715115906.2664882-1-smostafa@google.com/

Mostafa Saleh (2):
  KVM: arm64: Add stage2_clean_old_pte()
  KVM: arm64: Support BBM level 3

 arch/arm64/kvm/hyp/pgtable.c | 123 +++++++++++++++++++++++++----------
 1 file changed, 87 insertions(+), 36 deletions(-)

-- 
2.55.0.229.g6434b31f56-goog

