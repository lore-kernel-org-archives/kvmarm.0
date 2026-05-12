Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABA5306742
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 12:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589891; cv=none; b=KbxRAi0rYRZH/bMYTeZseDWBWjs2n9rYZDTbgPVAdq3AS4MTrIWqSTjQbdoouCzmbyGU7gcljro2qlkzSKbEglnGU8UL3vAF7YqNh3w+tO0MEfPfQRbj7WCDAUVXDNUOV6M93s8QzM21EC1YHVl4fC530QVVlIUP8qo6XRRGHRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589891; c=relaxed/simple;
	bh=Vzz3LLh3VPIk14pwmyaIkrVC+/KhEDSVg2MHBSMF+s8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=R5xXAQXhQKcRBr7TY/ankV+3lRYYFczbuSPxuJeNmvcJfMBnabOrqJmlJNl4SajEifZHVxMhj1xgMQBRYOPzxCtXKMHSqyGhh4hrV8nchOLKVSoJxmrqWBM/T1QcUOt1u5eNwJBrefONUtXq5vD3v40GIyEMH1l4j3kmDquYBu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iqteE7GK; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iqteE7GK"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48e79219704so17006705e9.1
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 05:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778589884; x=1779194684; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5fj8/TCAT99B/0+ZH0DB55n65AvGpzqDY+eLZ0gMn24=;
        b=iqteE7GKCOcM5f3mSC800bp62SRf7AVrmwky2y1oVzz9/G+q++D2GM1eYhhWttSLOT
         cmkIfKlajaOEcbKX5MGcXLM80InPl5kBl8IWuoKtcy4LUuNXaoRRcOzMVcKYsqByujTb
         iYCX3IReJ1YMMiOW8+gGoPZoXUXsA/919YxtRAJPWtTCj/HAIkBP3V+ZsUcWBNNGHApp
         LOek4d4XQPVoqXfsQcC7vwqog9GB/H/DeqrsecguXpt1snW4pVZUb3lCcz8WZvUmauYk
         98uBSl7ZfvFEFuth3wks2ib2SDGr7JP9fIrTi0RuIFezi0PaPw/tD2LF5qWInUTcznU3
         FvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778589884; x=1779194684;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5fj8/TCAT99B/0+ZH0DB55n65AvGpzqDY+eLZ0gMn24=;
        b=gm94dftaDRcG7/wa8k03P/gQHe6zvWwnn4vr4Wx1eGkCA1IrMdsnCcCI5JJarpBD73
         spWnZeeK2HXPgYqIwnM+Z5GX8+nfDUuIYmbCa7kxG5kxeoY5CflbTlKr1U6mGdFyqIbw
         r560s4o4zyfOMqlEKzDLq8gIBA2bpZEwovxuM6lXoOrYjN9UjULH0iL0sAusCrwG5krB
         lGgmXLLB4ljvrl3jAoNCm83bD62/DeGDnk66FV3CMuK7uJf56nBd2+gnHHGTRtQXpmvw
         /sQmzEL1tljBhr3dcslf0x3jnl5mngMZM2jh2xOd70hlBcfl0LC4WolHjD0Wb8SBpo9c
         4Qig==
X-Forwarded-Encrypted: i=1; AFNElJ9RXGzl1NbCt5npdBGJanfvgmmOrnDAp9Io0uvAQgU2IEC39Vn007f8mLPKAR0u9JTHS8IpnFw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFYwJU9JOccf5T7RWG6OsnbwLDSasAFwjtxKox8zxGSBrDOxfE
	ew1XfPEYExiWv2YW/9d+u4i2WEE2qjAFhybL15zwTyGrPI775P22jZtauTj6EyKjOX6JPo6HLdd
	XrwExdzEf6SaSviSjv53tOT7zhpwePw==
X-Received: from wrnj12.prod.google.com ([2002:adf:ea4c:0:b0:43c:f5f6:7a44])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c4a4:b0:48a:906b:14ca with SMTP id 5b1f17b1804b1-48e8fe7cdfbmr41959835e9.20.1778589884289;
 Tue, 12 May 2026 05:44:44 -0700 (PDT)
Date: Tue, 12 May 2026 12:44:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512124442.1899107-1-sebastianene@google.com>
Subject: [PATCH v3 0/2] arm_ffa, KVM: Fix FF-A emad offset calculations
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	sudeep.holla@kernel.org, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi all,

This series fixes the Endpoint Memory Access Descriptor (EMAD) offset calculations
and adds the necessary bounds checks for both the core FF-A driver and the pKVM
hypervisor.

Prior to FF-A version 1.1, the memory region header didn't specify an explicit offset
for the EMADs, leading to the assumption that they immediately follow the header.
However, from v1.1 onwards, the specification dictates using the `ep_mem_offset` field
to determine the start of the memory access array.

The patches in this series address this by:
1. Updating the core `arm_ffa` firmware driver to correctly calculate the descriptor
   offset using `ep_mem_offset` rather than defaulting to `sizeof(struct ffa_mem_region)`.
   It also introduces bounds checking against `max_fragsize`.
2. Enhancing the pKVM hypervisor validation logic to no longer strictly enforce that
   the descriptor strictly follows the header, aligning it with the driver behavior
   and the FF-A specification, while also ensuring the offset falls within the mailbox
   buffer bounds.

Changelog
#########

v2 -> this:
- Fixed typo in nvhe/ffa.c (missing sizeof)

v1 -> v2:
- For pKVM, removed the strict placement enforcement for `ep_mem_offset` as it is not
  compliant with the spec, and avoids making assumptions about the driver's memory
  layout.

Link to:
########

v2: https://lore.kernel.org/all/20260430160241.1934777-1-sebastianene@google.com/
v1: https://lore.kernel.org/all/ae9KN9nkOgDYJcGP@google.com/T/#t

Sebastian Ene (2):
  firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset
    calculation
  KVM: arm64: Validate the offset to the mem access descriptor

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 24 ++++++++++++++++++------
 drivers/firmware/arm_ffa/driver.c | 14 ++++++++++----
 include/linux/arm_ffa.h           |  2 +-
 3 files changed, 29 insertions(+), 11 deletions(-)

-- 
2.54.0.563.g4f69b47b94-goog

