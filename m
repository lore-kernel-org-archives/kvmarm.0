Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1566322C67
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 20:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310196; cv=none; b=rgRq1P7WQ8kSYCnsuoS04EDrdkvwgOmjMj9p5sOkurlfU1tLKZeXzY/YAQOKR/8rU/fXzXxFpVdeeDbxUbxqvRjWr2US19GBt1W3v+gCxAE6D4EMZ2ggQMcwL2FbbJ+V0Z7cvWr0JlFKaLoQ8R2sPU6REXiqVjL9Rg4xWIp2nJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310196; c=relaxed/simple;
	bh=O8asY9iehL0nCxQ7X/jU9CAwMx7UcWlswYFwKXvB8Fc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jhuGDuNENnuD1UU9VohkWcsWoKrjkeMJRQYfTslmWu6DwE4jnKjHYWg31ytfOISS23GPFdT7x3OjzcFUiBTyMSaVt59/jhSaEh4+24wKJqUCAk16abpLHm6kQ5Xnqv0Gsisxvweg64RnLdzi6wCA3lo6kfBX6URkwZrohQYYeiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N6Iq7TsR; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N6Iq7TsR"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fd64c32e8so35302505e9.3
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 13:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779310193; x=1779914993; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pLV0D8OV4jhyDEJovr2ZsBSnuczUGhYNsjjzP+Stc4o=;
        b=N6Iq7TsR8/RGzX/rFtJCPDQVAxl8R1LzqNr4QdTKna5L1/QwD7q9q5S42eDXIK6g3m
         oikwmc5fuYcMbBW9VvxlmoH/vb2Y5RyDPNIVyC+w3DHn0cp2Q8QJkLL9oD83o3nOribu
         btCEndCNM1QMa3gzh7hJHaxxByIpkOLUczH3t33n9OvNQp93N4c0exhWGd5rGnZ7K41B
         +luC7SVkzhw6oYU4cPl6TRsVHTLWte3Cf6wpxRxk61gd8mCwgl1N2dVoPEUHPp1wyf2R
         1zdUY/Y9pB5+ocjUpodrucGN5+UocBDDihk4FWqWL9EXKP05ac8hlCFYDNvIAJNdJDxi
         ouPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310193; x=1779914993;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pLV0D8OV4jhyDEJovr2ZsBSnuczUGhYNsjjzP+Stc4o=;
        b=qeOAFyn3V4XQbZXX+nxFQ46n6TOt1fp9D8U2tn7D6Ndn4l7kXFC7WwHLTXiDkNcVTt
         bu2D/XmIwIzlfagAiyiFM8XlRznl6vBtQNoltHU3ec0pRGQwsIoqppIvU6reCQUbSlxu
         uaEgAMBe2jGRe98sre90yo9xikIB2PIeFQr7DxtD+Iiqx/u/gVQokuDFvvCnnXxgnE3u
         rXSLZZlzrbMx9P+UU/bl1sf+OSS5n88UKz3KLzxl+iAVtFnlBuaQJUAoh7160k3zo1oJ
         CT7F30dJKnL54ytlmhJZm1GK0jQ7hFWSpBQ9ecQU/YDswN0VDn5Xieg810zYB2jHI/9M
         VKNw==
X-Forwarded-Encrypted: i=1; AFNElJ9dS3xTL5XQf43mSy7KSSE8AriDvvsQ53XLC9BfUdOyjwSl0nZrGtwUu9j5hvSyjjZ/2qbAygQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YysRtH87zvXqvS9xbrb7DJ1gNQ+rn9OyxUTnYjt/8BEnVdZDt1A
	JKZJ8atlC9cHUS38cCunbc0Gx0MiGDh2UK+Bm28OHYLsCwr9fjAU08vNG6iNehgDrkD+WZvoG4b
	+3XOQc+bLKoQ7Ng==
X-Received: from wruh9.prod.google.com ([2002:a5d:6889:0:b0:444:bd72:fec6])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:138f:b0:488:ae6c:42c6 with SMTP id 5b1f17b1804b1-48ff4f4f44dmr311573965e9.14.1779310192858;
 Wed, 20 May 2026 13:49:52 -0700 (PDT)
Date: Wed, 20 May 2026 20:49:43 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
Message-ID: <20260520204948.2440882-1-smostafa@google.com>
Subject: [PATCH v4 0/5] arm_ffa, KVM: Fix FF-A emad offset calculations
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
v3: https://lore.kernel.org/all/20260512124442.1899107-1-sebastianene@google.com/
v2: https://lore.kernel.org/all/20260430160241.1934777-1-sebastianene@google.com/
v1: https://lore.kernel.org/all/ae9KN9nkOgDYJcGP@google.com/T/#t

Mostafa Saleh (3):
  optee: ffa: Add NULL check in optee_ffa_lend_protmem
  firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
  KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()

Sebastian Ene (2):
  firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset
    calculation
  KVM: arm64: Validate the offset to the mem access descriptor

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 30 +++++++++++++++++++++++-------
 drivers/firmware/arm_ffa/driver.c | 21 +++++++++++++--------
 drivers/tee/optee/ffa_abi.c       |  3 +++
 include/linux/arm_ffa.h           |  2 +-
 4 files changed, 40 insertions(+), 16 deletions(-)

-- 
2.54.0.669.g59709faab0-goog

