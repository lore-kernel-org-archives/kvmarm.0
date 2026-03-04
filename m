Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5E5353EDA
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 16:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641347; cv=none; b=NFGwQTVX2xgNP6qJUK5xaVRbUWWVBteAbEgkqUzcvd4qQkI3fCBUL1vMbFqI4SwjOUXR3I6ZX9Z0lkykl5fgunRLFldrD1toijBLD6Jzu2sga+JpwSARTPkRjMpB2vEMD0AJUSSWxT4+60r3li0SdhYzmE95y1c33SG0z1oDJxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641347; c=relaxed/simple;
	bh=cvnyQnDq+kA5IyO6MNTtGQveKVAjiAkxaJxS7jL1DnM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dgg0Q0kkxyrBJ9OUIKU8ajvM02mRXUaZmRFcU7lMXw8VrmzfnDwE+CuoT32+O2bt/1vkuKcCycMe1ToptSVFpHPtuhsaAprKo0IyU755pam4clR3gMNC3okSq8n+zmJyHFc7qbfr0bdh/FRxKykAPLsYgWnNBvj4awGIG6WJMi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=USleZYtM; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="USleZYtM"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837246211bso82809365e9.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Mar 2026 08:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772641344; x=1773246144; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=23c+ROMNUk5Dd7yUKgLUSdTwchiyCsLiWmB8a96IYHQ=;
        b=USleZYtMGqTmfxR4BBPk4nKrffybgRknPYJnWjF1dHz8eX8tFKyaYidrwleqTUZhFn
         VJnQAZC6DAmU6VR2y7Q0CHm7Fud6hUlsEdjtlvTnwCMtRAjl4gYG+5ptRi/rw4JL7jcv
         KIl2xafOy7CVnUjru0qZlefbMyRVDacb3Qst4Lmqr2wZOzUm2Ewyhw9I5P4a9CUiUBnm
         Blf8Hhi2kMmyW9LZzyXqIppa7aj6Tw8nmZ9UdKLVYfJZtsYFSWLCnGexDS1NB00viZ2Z
         sLFT6jGnYRYbbIvbcpmrm8VJUnGsXNUi2zMg9uiBO3yrB1v3HKT9yH5dqn4VhGcG30oi
         F7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641344; x=1773246144;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=23c+ROMNUk5Dd7yUKgLUSdTwchiyCsLiWmB8a96IYHQ=;
        b=tmTqHeyeq5Q7eN4197RqQ9ZA2K9EnZb9R8Mm8hXj+tVJjAZMrJjjQxrmxG5NeSMmQ1
         yeTQCPu2onBwi9vFuFDMorqFg25zKKBopXlXT0hCJVoOps4S8xC5McZrDNF+21flKvHy
         PMzu9+nQU0HwUpu6sB/8Onvf0NCmzk8HwcpwKb4y4d/qKeZu45uDcgQQZQBsKf4BJTDl
         uD4I/+Ic2pFm8FuJCZ4ZuaxTi+Zx5C2RYKR42LItbYEabDjSRFgrkair9WwjlRCIhgr8
         80qFR3muq2H0JLhm68wOAOflqH03ejEUlVeucyslLZuH0w1iKZZn0YIzYqhpu6zo42lX
         F70w==
X-Forwarded-Encrypted: i=1; AJvYcCVmG7Wg1MlUtFvA+XS4mrhuJhWaIi69af0l8TyXQcBYQilMq0z2LkednNJ8n2w3QUdzlDlI39I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxh1lyJ9UNLWAxMNipX2FqKvRbJMmQx/Papuj/RPzR61zLVPIQ/
	Q5SwvPJKJ/HJkiq/Q/+D1ivXMajyGOahOHAXUW259/8fLKJtYfg+kpVzHVH7Jbc7Xvfg957ISa8
	2rQ==
X-Received: from wmo14.prod.google.com ([2002:a05:600c:230e:b0:47e:dc0c:276f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e8a:b0:483:c35d:367f
 with SMTP id 5b1f17b1804b1-4851988a6f7mr43226855e9.21.1772641343626; Wed, 04
 Mar 2026 08:22:23 -0800 (PST)
Date: Wed,  4 Mar 2026 16:22:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304162222.836152-1-tabba@google.com>
Subject: [PATCH v1 0/2] KVM: arm64: Fix a couple of latent bugs in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, yangyicong@hisilicon.com, wangzhou1@hisilicon.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

While digging into arch/arm64/kvm/mmu.c with the intention of finally
refactoring user_mem_abort(), I ran into a couple of latent bugs that
we should probably fix right now before attempting any major plumbing.

You might experience some deja-vu looking at the first patch. A while
back (in 5f9466b50c1b), I fixed a struct page reference leak on an
early error return in this exact same block. It turns out that another
early exit was introduced later on (for exclusive/atomic faults), and it
fell into the exact same trap of leaking the page.

The fact that this keeps happening really highlights how dangerous this
"danger zone" between faulting in the PFN and taking the MMU lock has
become. To stop playing whack-a-mole with inline `kvm_release_page_unused()`
calls, I've routed all the early exits here to a unified `out_put_page`
label so they are handled safely together.

The second patch addresses a staleness bug with `vma_shift` when handling
nested stage-2 faults. We currently truncate the mapping size for the
nested guest, but forget to update the shift, which results in us sending
the wrong boundaries to userspace if we subsequently trip over a hardware
poisoned page.

Finding these issues just reinforces how fragile this 300-line function
has become. We really need to refactor it to make the state flow easier
to reason about. I'm currently putting together a series to do just that
(introducing a proper fault state object), so stay tuned for an RFC on
that front.

Based on Linux 7.0-rc2.

Cheers,
/fuad

Fuad Tabba (2):
  KVM: arm64: Fix page leak in user_mem_abort() on atomic fault
  KVM: arm64: Fix vma_shift staleness on nested hwpoison path

 arch/arm64/kvm/mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)


base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0.473.g4a7958ca14-goog

