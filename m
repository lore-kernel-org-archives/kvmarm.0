Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9647A472798
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777564971; cv=none; b=HOLvX3cI6cWPZWuyZVCUIviX0KjP2sNojTqS6uukkUOHU+YfkhZD4OJdfBfFO5M+JIFoOcd/u13AB8D/jOsH1JBauWaWQY+SO1ptp6vJpAIV1CkHkzhIGlXmr1lsN67pTpxa2eoFnKXZxG0fiXo68bPhb3H3He0jC5c5KMuqWUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777564971; c=relaxed/simple;
	bh=WVJLqy3r6bzkLBth79KRaspMMTHZDGP6okQuQEbTpG0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YYGNbFD6NP89mI3khkkWlQmJiEwpHZeC0uKLj3NxUfg4FlzBEX85xAE/b0Qq+trbSreQn/Vmlx89QjIiJrtl3PX6gvWRfDD1Ra2y/zK9vPfWYb2sMt/9u20vtXQH9HvNf8VG0czNEGwUsdhzWPIg/PqacZouuLIVMFKl9/TjIoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KEYINFQ7; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KEYINFQ7"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44a2a68f519so137039f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 09:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777564968; x=1778169768; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mz8D/T3QxACqjwu+5huws7UhafLI3x5hmsgeMhwaaFA=;
        b=KEYINFQ7kED5rmA5oRu39Rz1BS06Zx8RSBH4Xh28pHt05AQ9JUoDKZjirbd4YyTxmK
         zmpR73cU7JtaXWttckABmoE5a43T7hfsak7CloGO2lV3A+XK1wqJkwqO3+z3AXGGgUsx
         ixoo0GfCyT+ACXBnnfXVFKEUoeMRMoAZnXrX1EF6ig4SmuIQZBdHemw+IyqGgj5ULmIb
         JvOafAfOFKPSfhsDhTWOO0Lm36KO23CHz+r0w0YskNnvaevmy189XB13NP2G8PAEyCTF
         7rzRuNCjKqicxHYx3xVF8ONQXFPrMs9R9iF5QoK7FPXqTG/6WM+ZdqO0DN+QBJjTrx0+
         3oPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777564968; x=1778169768;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mz8D/T3QxACqjwu+5huws7UhafLI3x5hmsgeMhwaaFA=;
        b=fXl40BuC+Rt2+y+e8W5jSKRgWRkBowDLe873q/CptSFbFWke/k/LkMbp/K+7Qn3Zai
         8h0cTyvl7Z1XOfgKSqgKLgXMev7L2vQjR7Wo/R255fVk29tZ5WaF/c70NBvYJ8zboHjH
         wMfpLCpxTLyLI9YFytQxVeIwCnm6UEFlS2vngHnl76GBUvep1LXT+AZxXucEJLVr+Rqe
         sxjgOHBhobRx9s14yNszbPFsONNN+0ElV2lv06aH7Hikt8aqJ9Xo5KQtZdXqmJSZS/XZ
         zid1GpoFD1qjjMn3EfivAD2QfK0LFFqoPm0lzmrdVLsg6fAfRKs6EfsGALOPrDK5HB6C
         gGuw==
X-Forwarded-Encrypted: i=1; AFNElJ9tl2VzTsNgOu/61l4lE+IwrHY7M//QtH6oSlJNWibg7tErY4PAWppAp63yZMVviGJCcBMI/VQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9+TnyloSjmaYV+tBGa/VWgpRLVqCbTpykx236Xv6BI4YPV2Sk
	tQ2YfYxOhtBxizMHAxDKM7FnuqSQD2TM8CgMzGWoFppoJch5fKAfu+JJ7ADiQ/zAvVg0qEeCRJt
	6n45tqTAtoJ85ppeWI92IIgYYLzA4UA==
X-Received: from wrqr3.prod.google.com ([2002:a5d:4983:0:b0:43d:6f5f:8c52])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a40a:b0:480:1d0b:2d32 with SMTP id 5b1f17b1804b1-48a8444a342mr47560585e9.12.1777564967927;
 Thu, 30 Apr 2026 09:02:47 -0700 (PDT)
Date: Thu, 30 Apr 2026 16:02:39 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260430160241.1934777-1-sebastianene@google.com>
Subject: [PATCH v2 0/2] arm_ffa, KVM: Fix FF-A emad offset calculations
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

Changes since v1:
- For pKVM, removed the strict placement enforcement for `ep_mem_offset` as it is not
  compliant with the spec, and avoids making assumptions about the driver's memory
  layout.

Link to v1: https://lore.kernel.org/all/ae9KN9nkOgDYJcGP@google.com/T/#t

Sebastian Ene (2):
  firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset
    calculation
  KVM: arm64: Validate the offset to the mem access descriptor

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 24 ++++++++++++++++++------
 drivers/firmware/arm_ffa/driver.c | 14 ++++++++++----
 include/linux/arm_ffa.h           |  2 +-
 3 files changed, 29 insertions(+), 11 deletions(-)

--
2.54.0.545.g6539524ca2-goog

