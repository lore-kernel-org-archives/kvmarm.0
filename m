Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC2049EC42
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528626; cv=none; b=EL+4yKjrI4BBCJdXnnIS7+HThaqZ8BPpnIVxdw0F5gN0QChKlwk3j+E/Okm2fGAoiImTUNp0QWnbPLUkaV/SxYaE+1R1ejfwRuV61EpBCbeVR0u0Pv/AQMP7Nf5xgo8sz1ihXjF2gAmVLhMkthid0Of1Ce+9+iIHrjfROckyKrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528626; c=relaxed/simple;
	bh=Sc3lDWCpzcNSYkPYGJ1RWdAwe0ZaTgH6K4eWHiL+UxQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NGEQoNZVlEZU3CwiGAgQ//58XLzYJGYRciUK5JMltg6eb/D1PmVzsrno8UQ5SxoNnYpVtUqgyELuQEuOggHnbcxcCnphtFSziZEm5vIVVwblhbrVSyl5HjnVOS7YBJfnyEEK9f8C94w6h6Zr5KnAtqrioutO8PrTAm3EyJqF6jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GsnLnQmc; arc=none smtp.client-ip=209.85.221.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GsnLnQmc"
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48589603501so522702f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 06:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788528623; x=1789133423; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+aPWbmTLZvhLqGM4vE8H/jD9xFWXLFtEDa5uftDvlQM=;
        b=GsnLnQmcP2LaD8RiPaH0LTLtLBosGvlxaLYp7a2TDHi+YzKlbNBBdcVtI4T/Za5pOW
         gK6Oyt50KaVs3dT+qkn8XPj4fDtb5tZAN+0GJHjwo5cJIKTHPazjDYt8vm5lP1k9TWSc
         gMV6VFLE2WmJa6zwBF9LcosbGh2f9zw9mGQLxf99maq7jNEcdTbLAcgNj57lsIGmSc2q
         wX8wJECAKQkE0gIGRZq6vp3SwY3XHle6Tt1vvot1AvCDTSbiQwUc93S8O0ZFiDl5DpV6
         +XtRMySonU8DWZpe5mDvYmI8CFJ9xWb99zXKnkwMpiDVV0U87ZzW+GvDCTj4tgC5lUbJ
         +TsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788528623; x=1789133423;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+aPWbmTLZvhLqGM4vE8H/jD9xFWXLFtEDa5uftDvlQM=;
        b=BtnoCG4kQxbnYlb8tJioEFwildTEu/z5CE5A0G+sPowKLWvRoQKH9cDlf8TNpHW82S
         ykWUc/AE61+3v4+B40uyVoS4xMgvdTo0nr1dAv6ZV4ftlW6uIiYIrQa/r7QTCKsYpwb0
         ZVEw7zJ91dOrs0JDdq8MrB2S4yaD6RfSNmpO42Z/7/38Ox5FgrU0Q1EIWwfvAw55aqLA
         MAf7Tjv4kqFKYDEqvXejRJrnZsBtTzBgOXdGE/G8WuHDFTO079VZCG+3DPX1gqVbHjI+
         SqN1CF79r0eOYlMlHxJtGOJERXkDK8igAa7iNcJZiske17H006jrGKiMcdfawV4cU52+
         XlIA==
X-Forwarded-Encrypted: i=1; AKwUvBzJSh+PWnYPCQcylsRjDCArDMLG3kZenMIe2tUfz8TrA+AJZehsBaJnZU3Jz0OrcLN5U1+1vWY=@lists.linux.dev
X-Gm-Message-State: AFuF++nAt6HJzlnnJfxCONysDzPXm986TuN22zi98xWFDBFvyLXkueH1
	5bedSFl9FUGBvdlWBkkFMS/sta2968YwVgSQ2sPQR07icKCvyrsMKqLuR0JGDVrrUNenHLaCpKE
	SYNkOXl1zwuKTXg==
X-Received: from wmbdx16.prod.google.com ([2002:a05:600c:63d0:b0:49c:edfd:aa4c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc5:b0:49c:fe18:6dd5 with SMTP id 5b1f17b1804b1-49cfe186dfemr25609645e9.29.1788528622474;
 Fri, 04 Sep 2026 06:30:22 -0700 (PDT)
Date: Fri,  4 Sep 2026 13:28:53 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904132855.638117-1-smostafa@google.com>
Subject: [PATCH v3 0/2] KVM: arm64: Add support for BBM level 3
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	qperret@google.com, linu.cherian@arm.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series adds support for BBM level 3 to KVM pgtable.

Changes from v2:
https://lore.kernel.org/all/20260723182140.4025575-1-smostafa@google.com/
- Add extra checks to ensure PTE updates with BBML3 follow the arm
  architecture.
- Limit the extra smp_wmb() to non shared walkers.

Motivation
==========
I have been looking into this for the context of:
- Page table sharing between the host CPU stage-2 and the SMMUv3 for
  protected KVM.
- Use the pagtable code to populate SMMUv3 stage-2 shadowed
  page table [1]

However, BBM level 3 is still useful for CPU only operations as it
avoids intermediately breaking translation.

Design
======
Some of the conditions that BBM level 3 will be useful in (RWHZWS):
1) Changing from block to table
2) Changing from table to block

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
This was tested with:
- C1-Pro cores, unfortunately the version I have does not run
  upstream, I backported the patches to Android kernel (6.18).

- mainline(7.3-rc1) kernel on a Qualcomm X1 with a hacked cpufeature
  as it does not support BBM, I did not see conflict aborts or TLB
  corruption.

I tested with VHE and protected (hvhe) modes, running VMs
(and protected), and running some selftests, that might exercise and
stress this path tools/testing/selftests/kvm:
- demand_paging_test
- memslot_perf_test
- memslot_modification_stress_test
- dirty_log_test

Mostafa Saleh (2):
  KVM: arm64: Add stage2_clean_old_pte()
  KVM: arm64: Support BBM level 3

 arch/arm64/kvm/hyp/pgtable.c | 172 +++++++++++++++++++++++++----------
 1 file changed, 124 insertions(+), 48 deletions(-)

-- 
2.55.0.979.g7e5102b832-goog

