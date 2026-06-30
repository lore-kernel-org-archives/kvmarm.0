Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AA62D9484
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814881; cv=none; b=osfi9ZkZPCJYyF+d+3eaJM077x7B9HkKpbs887iyEsgOe6215w5A9svQ7miKRZvFnZvbl1/crmYY7H1Im2BzplF8fZjWlI8JmegL4VhTn6FIsiyszJ3dNLFICu0ISdoRi4/VxPKs78GJtNcQgF3GQrlFPJ4dR9Fl7NLBuS/2BZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814881; c=relaxed/simple;
	bh=+FdCcdGSvbG17UvdLzYD759HRlwSCrGh4SVfz6aKQ34=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LloMkjyxWiT6IIsL+aKypuoH7yF46eQMq+3b6CbgaWAk1AQG/IuwIWWACHz1QZJhz35Rmn1a3Qa3V5737ADPOFl9tmHBtlvxxJifhiNQCeQPE6A9/KYX/m2fOhrc5iPu4+Abr1/41kpFT/elLoAUvPKg19/1iAm+p02QiCpY//8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V3m12eDA; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V3m12eDA"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493bb6a4336so3937885e9.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 03:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782814879; x=1783419679; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OJzLaDJYkTsSZ24JLp6E5r3GjL3vXjqVNcTnlWofIQg=;
        b=V3m12eDA5ZpuYSacZ+Iqpn8EKajIoy9KhgxyXj8P0OW0u+rB/Xn1lVtwf58wGQoL3j
         qFTH7khnXg1+begjcyUkrs2UUEUEtw2BgKtOKgRKdiBhpz+kE0iCFph/M/zn3Mhjlt5T
         F7cbTtVoctWOoJcf/lcNZ/9HFBYyU5JrVsu4XTjsniROO4Wdw1zxyNZ8guOtQkiWSWJ3
         44xkDLbkWLBWultC6Ojurf6BBcd296e5Sp3saat8Jpc+zYE72tMPiFb2jQzC/T42U2Ql
         Osi2CLjDDm6odw6s2SKxgZdd1CxxNxIfsu3rh1BJfYbxWKKlwkfjb5mAiSyYfk/lJbfP
         80kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782814879; x=1783419679;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OJzLaDJYkTsSZ24JLp6E5r3GjL3vXjqVNcTnlWofIQg=;
        b=LbHIUyXkDxW4mmW72ju7PHBLlq2rK7L9FNEegKJzQbVtFIniZAMHI1g/G0vDd6+ntT
         PCksM5FEjB2VAdsv46r0UCpPpLsWFAHQe1fOF6S81grs85FdCqzjA3tehJqyhgSP5oKR
         5c8pUug8pqJVccyPHv5cNwisplUlHvwhmsGEqS2Zmp2OM4bBAcXfoPfTse19+ln9pgO/
         7/Fxxw8rjnoCWXr+2N3iEP1TERImMkx3UxHLTy6cjeVq7CsNdwNGlVwq3VM6G5VHq1Jb
         441PaYKwsYBobBXUlpt4nOL7wpy4zcehlS4k9fwmAopQQ/kLHh9TIM5bpVEXD/qFBCqm
         /fBA==
X-Forwarded-Encrypted: i=1; AFNElJ/AR+68RghXtBGYOMyUmI5fiVlo0L87GvMIfS1X4zNZM6m5db7KAgfMjNE/x9UTkJn+kD2S8go=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEO86CrCIKk0sRkIEen0SWaKKY5bost8rWVso5S5fapJAjnkDk
	oZi7IhP4uJDxtJcNice/NvXDjyvMX3O+o6EsJm7MzWwV+dlYZHUIkx4tfHcbwDZK2wvz4vtzC2I
	c7yxtc17FggH2PzWNknDAuzk9q5SMvw==
X-Received: from wrux9.prod.google.com ([2002:a5d:6509:0:b0:46c:cc8e:4391])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3546:b0:493:2805:ae06 with SMTP id 5b1f17b1804b1-493b827cae2mr44265025e9.2.1782814878460;
 Tue, 30 Jun 2026 03:21:18 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:20:53 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260630102058.3219867-2-sebastianene@google.com>
Subject: [PATCH v8 0/6] arm_ffa, KVM: Fix FF-A emad offset calculations
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, 
	will@kernel.org
Cc: jens.wiklander@linaro.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com, 
	op-tee@lists.trustedfirmware.org, perlarsen@google.com, 
	sebastianene@google.com, seiden@linux.ibm.com, smostafa@google.com, 
	sumit.garg@kernel.org, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi all,

This series fixes the Endpoint Memory Access Descriptor (EMAD) offset
calculations and adds the necessary bounds checks for both the core
FF-A driver and the pKVM hypervisor.

Prior to FF-A version 1.1, the memory region header didn't specify an
explicit offset for the EMADs, leading to the assumption that they
immediately follow the header.
However, from v1.1 onwards, the specification dictates using the
ep_mem_offset` field to determine the start of the memory access
array.

The patches in this series address this by:
1. Updating the core `arm_ffa` firmware driver to correctly calculate
the descriptor
   offset using `ep_mem_offset` rather than defaulting to `sizeof(struct
ffa_mem_region)`.
   It also introduces bounds checking against `max_fragsize`.
2. Enhancing the pKVM hypervisor validation logic to no longer strictly
enforce that
   the descriptor strictly follows the header, aligning it with the
driver behavior
   and the FF-A specification, while also ensuring the offset falls
within the mailbox
   buffer bounds.

While addressing these bugs, Sashiko uncovered other issues that were
fixed in the same series.

All the patches aside from the first one in optee are urgent fixes as
they either impact the hypervisor security or kernel stability.

Changelog
#########
v7->v8:
- dropped the patch "optee: ffa: Add NULL check in
  optee_ffa_lend_protmem" from the series as it was queued by Jens
- rephrased the commit message for "KVM: arm64: Ensure FFA ranges are
  page aligned"
- introduced a helper macro to get the size of the ffa memory region
  based on the used version.

v6->v7:
- taking the patches from Mostafa and sending a new version with the
  collected tags
- Added overflow checks when doing `ep_offset + emad_size` in the arm
  ff-a driver
- Move the length check before the ffa_mem_reclaim
- fix compatibility break with ff-a version 1.0 reported by Sashiko
- add one more patch to fix an issue with the FFA_VERSION call
  that can lead to leaking pKVM stack un-initialized data to
  a host when -ftrivial-auto-var-init=zero is not used.

v5->v6:
- Add fixes tag
- Small clean up make variable declaration reverse christmas tree.

v4->v5:
- Collect Sudeep Rbs
- Add extra patch to check base address alignment.
- Remove WARN_ONs in KVM code
- Use ffa_emad_size_get() instead of hardcoded size in KVM code.

v3 -> v4:
- Address review comments and fix Sashiko bugs

v2 -> v3:
- Fixed typo in nvhe/ffa.c (missing sizeof)

v1 -> v2:
- For pKVM, removed the strict placement enforcement for `ep_mem_offset`
  as it is not
  compliant with the spec, and avoids making assumptions about the
driver's memory
  layout.

Link to:
########
v6:
https://lore.kernel.org/all/20260527150236.1978655-1-smostafa@google.com/
v5:
https://lore.kernel.org/all/20260526151934.3783707-1-smostafa@google.com/
v4:
https://lore.kernel.org/all/20260520204948.2440882-1-smostafa@google.com/
v3:
https://lore.kernel.org/all/20260512124442.1899107-1-sebastianene@google.com/
v2:
https://lore.kernel.org/all/20260430160241.1934777-1-sebastianene@google.com/
v1: https://lore.kernel.org/all/ae9KN9nkOgDYJcGP@google.com/T/#t

*** BLURB HERE ***

Mostafa Saleh (3):
  firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
  KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
  KVM: arm64: Ensure FFA ranges are page aligned

Sebastian Ene (3):
  firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset
    calculation
  KVM: arm64: Validate the offset to the mem access descriptor
  KVM: arm64: Zero out the stack initialized data in the FFA handler

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 45 +++++++++++++++++++++----------
 drivers/firmware/arm_ffa/driver.c | 25 +++++++++++------
 include/linux/arm_ffa.h           |  9 ++++++-
 3 files changed, 56 insertions(+), 23 deletions(-)

-- 
2.55.0.rc0.799.gd6f94ed593-goog

