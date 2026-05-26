Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA641C84A6
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808789; cv=none; b=Yfo5d5RGzYIkFr5E6iJd5drEsrraiiIpr6b7gFcdOnd4O3hB7LPy4mzz9WgHYrzPG/gh69EWZXIxwyjmi7ypdfE/Y1oPFZe3odximqPjknJtCAy3KVRMd36OaQg9H1hCfAH28RPNJGE9craw0QRaLNseMJRZEtD0X5lRu3/eSs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808789; c=relaxed/simple;
	bh=kViNV8bt1ZUesG6y4m7RkUFq2YymwQWHXWgrRE5dr7w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PrKFEeKv+xnJVDzzLGogxbeQrrbNmNKzA3bC4WdAGgCduPJReKwloxqcl2MmCftQ53TYzE3ZE/umHGvwyc3XeDV71pEynZ4DhKcgbpp6UhNdW2lzpZSBfKWhCrLpWuUggD4ix31knZAHhWA62wMfz3VJBdfgrmjgTBOBjyFoSHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LCQWn4Lc; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LCQWn4Lc"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48feb0298d7so86789635e9.1
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 08:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779808785; x=1780413585; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lrWlfTK5Lutt6aW80bi7cx4j7i0TUVnce7pHBOYoWwo=;
        b=LCQWn4LcRby/pnQvA07J7vOAlY7CcPJfmUe0vRQNEf3+GE2QUSIV/jMQ3zW4rTTv24
         CJnHFDFj30eU1bgUvpD6mF5VSr+fx0lKFdhgXejQZWBoP7rtPVre8/+XCDmi3vZaM53M
         /Lq1OsNlzdtJ7BqZpoT/1xK8BoGNc+jCMzUdXcdB2NvAzIYWIBn8l39oykil47Z4nzcs
         dILuBTb9sjyF3kedlkZX9YyopWqcBNAAS781hRRMSjeCW6JClbI3rzfTJnzcu1difRo+
         jabmujQ4VkSQLlClktVCrlJYv22tCs6dBS2KR7Tgqfsio6c/lsCUzTTEeK838k/rt5Gp
         63Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808785; x=1780413585;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lrWlfTK5Lutt6aW80bi7cx4j7i0TUVnce7pHBOYoWwo=;
        b=Y10h3AQAY7Q39oQoSlmj8Q/e3Lc03wb6/WZV3WxZ/lhouezEQvcHDu/VYxp35LL6x1
         g9R8qXuYWCwjyrDghuDIChUKYuQBPaYqP1VZ7BWc2jCswYqQWAZVsDbE11gAjCD03fYD
         H1DrrErLdgG3L+gaDa6Tyu7lCtXFqFUXcLKXvA4bn2/QufVDS3z3LwLi6QXYSRwFkheO
         H3utyiKfU4UUbSjZnMr0KOm4LtEaGlKxZBTh5y277KJw7jDNt12nG8Ydb+kFxGH6gOJp
         BcLudQ9K+9LJlj5YwFFAeq38X17hZaZTbn37RO5JBRsfQD4E3LDo04F/oA4nFaij+WEg
         ySKg==
X-Forwarded-Encrypted: i=1; AFNElJ9vv+4MJ0HpCorwuJc//MiQU6nFdP01t7rSPr5zGUbx0UgUCQ4Q+9sgH7DbWDg/Kf1mNr5OpSQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMcBiSDZYzK38qeaQzQTylYBzjELBWO6ZBXR7eR4rnWcJVr3Z/
	Tw/w5nt/CS1MJW1vd9VEmEy1tj+0oOKqLauhmz6x7HnZlI+BIpIK4TsAN9vFb141g/gx3J7ZIfx
	u3+MkofOnLKk/+g==
X-Received: from wmbem24.prod.google.com ([2002:a05:600c:8218:b0:490:51ba:4f8])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4511:b0:490:6869:46c3 with SMTP id 5b1f17b1804b1-490686947bemr126353045e9.30.1779808784404;
 Tue, 26 May 2026 08:19:44 -0700 (PDT)
Date: Tue, 26 May 2026 15:19:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260526151934.3783707-1-smostafa@google.com>
Subject: [PATCH v5 0/6] arm_ffa, KVM: Fix FF-A emad offset calculations
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
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
1. Updating the core `arm_ffa` firmware driver to correctly calculate the descriptor
   offset using `ep_mem_offset` rather than defaulting to `sizeof(struct ffa_mem_region)`.
   It also introduces bounds checking against `max_fragsize`.
2. Enhancing the pKVM hypervisor validation logic to no longer strictly enforce that
   the descriptor strictly follows the header, aligning it with the driver behavior
   and the FF-A specification, while also ensuring the offset falls within the mailbox
   buffer bounds.

While addressing these bugs, Sashiko uncovered other issues that were
fixed in the same series.

Changelog
#########
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
- For pKVM, removed the strict placement enforcement for `ep_mem_offset` as it is not
  compliant with the spec, and avoids making assumptions about the driver's memory
  layout.

Link to:
########
v4: https://lore.kernel.org/all/20260520204948.2440882-1-smostafa@google.com/
v3: https://lore.kernel.org/all/20260512124442.1899107-1-sebastianene@google.com/
v2: https://lore.kernel.org/all/20260430160241.1934777-1-sebastianene@google.com/
v1: https://lore.kernel.org/all/ae9KN9nkOgDYJcGP@google.com/T/#t


Mostafa Saleh (4):
  optee: ffa: Add NULL check in optee_ffa_lend_protmem
  firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
  KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
  KVM: arm64: Ensure FFA ranges are page aligned

Sebastian Ene (2):
  firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset
    calculation
  KVM: arm64: Validate the offset to the mem access descriptor

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 38 ++++++++++++++++++++++---------
 drivers/firmware/arm_ffa/driver.c | 21 ++++++++++-------
 drivers/tee/optee/ffa_abi.c       |  3 +++
 include/linux/arm_ffa.h           |  2 +-
 4 files changed, 44 insertions(+), 20 deletions(-)

-- 
2.54.0.746.g67dd491aae-goog

