Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B770327EC7C
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707900; cv=none; b=gZUumOoPsTG89AE0FqElcUEMTIo/78dpC/c1CAFR8Bge4yBdq690nNRkFbSarN83YRNKiEuatUgJ4xdiyso0VcIEe1NKqDtpIkvULs+s7al++qCoYLX+OzixKDsuWm7pyGItKubvYvBCqvBtFtL8sZqo9I4xEW1uO7pJG5psKa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707900; c=relaxed/simple;
	bh=ONZSxhFlHjrCEE9Fm6phM5SqH29oxrERKV/bEQ6mXxo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=m2/Ld4S1DNf8b5hVVZF7/H8Fvl2sfoU/2QONd2J/en9egefytp8ceTxi1AkxflUBA54V1tGJGnyu8mT/QiCqYw0lHrijbHpaE4in7Jk+N0qupwdvaF9boTvqQaJkqtknkGc8PyR8iKGbZPgctVWymF/sIvvWyGXtlHigdIUNFkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vb8Nl/bq; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vb8Nl/bq"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-461a159d77aso805161f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707897; x=1782312697; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DRCIDgfvyWb8F6dd51kKp09a/LacrvNUI0KU4btuiv8=;
        b=vb8Nl/bqgAfYPxaB5nwU8x7s/EBjokaha+K44SuksShk++LK8PluIJ5K8dM0nRki4W
         uNPAi4dRU9D+ydpwwj80J1DnQDKYDVtH/tujKckg+9/an4w1W5ze/2KXVkTUKoObdtoa
         dhdH/zh5pJoJTd2bSKhsxZn2/Z0HV+TVtLSpAZ2Kvodsnxm0pgLPRnL9c60EpjQ1BcL7
         PXmQqSqHUIf9oaLQqsDqMk81YEGVIiaAHuxifrYLeIbND5U7Q2MoLpKx7eeE4ZuDlCPP
         1rUjNfq7RuTMbszKMQX9toPaPLS5KQ+QAfF8ZblOO+OjAlmjQ501piLrGVv1IppMK/kO
         aMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707897; x=1782312697;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DRCIDgfvyWb8F6dd51kKp09a/LacrvNUI0KU4btuiv8=;
        b=QupXdtFeNIEv3DDngW4yDrVeMeMtn2f5xhwwz2l35oKY6/obpr9jPRCM98Ci2v6TBM
         3iH/t8b/Iy9FxFqse/mjdVLIwAzpgQ4pUyoKEs+3KBK2nkNIvzAyFm1cH0+CdfpVddL/
         ag67Y7eoVgKGGj5O6rTAAeBb7kIyRZG2KPfjPRPg3j8mdOYEqA0yn4nyY3qKPGfaSJCy
         q0CEhzY6WCbJu4L04SLz1oehwVmf6HtnRuy6l9+uEKsJvY2ASTnAZCsHVrGPEAWbJHBB
         UtuKKXA2X680UKHoYp4NPkutmI3sJvssbZOv+HSSiYjFE4zcfmWOlJ2jG+zqRYiXF4JH
         YHbQ==
X-Forwarded-Encrypted: i=1; AFNElJ/m10VTYteymZY95QNNL7b7spZQM69gYLsaX5mH4TpCIrClHgdelyEXZGZ53h3yTBaXwD1XKO8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1kdp9UCgQN67OCB+A/ioX5rpZlNo4/NWgPG1H81v93SBT4pyg
	zV95u4l7uf4tcVzbmtdCwFnjHd1oZc+gwoesKC1maoFCmhC1nLw/gfLZHIIh9cx8G9E1N0q0A8b
	b7uHcnAI3mwfC7DDnKjpgW5QDy2HjvA==
X-Received: from wrsi9.prod.google.com ([2002:adf:fdc9:0:b0:43d:677d:1980])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:edcf:0:b0:461:bfd6:510c with SMTP id ffacd0b85a97d-46235e9ae48mr6358501f8f.3.1781707896957;
 Wed, 17 Jun 2026 07:51:36 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:51:23 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617145130.3729015-1-sebastianene@google.com>
Subject: [PATCH v7 0/7] arm_ffa, KVM: Fix FF-A emad offset calculations
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

Mostafa Saleh (4):
  optee: ffa: Add NULL check in optee_ffa_lend_protmem
  firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
  KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
  KVM: arm64: Ensure FFA ranges are page aligned

Sebastian Ene (3):
  firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset
    calculation
  KVM: arm64: Validate the offset to the mem access descriptor
  KVM: arm64: Zero out the stack initialized data in the FFA handler

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 47 ++++++++++++++++++++++---------
 drivers/firmware/arm_ffa/driver.c | 25 ++++++++++------
 drivers/tee/optee/ffa_abi.c       |  3 ++
 include/linux/arm_ffa.h           |  2 +-
 4 files changed, 54 insertions(+), 23 deletions(-)

-- 
2.54.0.1136.gdb2ca164c4-goog

