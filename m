Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B509267B89
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 10:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988738; cv=none; b=Gm+xV81Eh9OcXdyzlGP2ZafuadSkKNVrrduMEt4p/k8rwd2DhNZSZdutIOKa26MhwhDDP5tFLJCaXr6fCA30hp15Tm1JzNAO/EYQd8P/71th6or9hRvO/i6BM6DkkYXB0IvH2obPBAiGIPsVicr5u5K98yu24PX0+V8kWLT9uDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988738; c=relaxed/simple;
	bh=40zV5nNeu4DWVyIoe1XkZE2dt6wRM/YAhZpzs4jqqs4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RYIUEHlUa0jG8IERW0wVSAiiDgRPiHGv8qX6Zwxw9cj0a3H+1EoKBF5LdmqE9/+HAzGXNVGt/dDgGq6/6Js2Y8AhqVIYxllwbBKaPajhF7xtA6002G9g/PVQPqzFaTwW5y3Sqac0oZTjiFLUnErsVyRg0I+96AGeD1wIjAe1QBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d+P+ahOd; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d+P+ahOd"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c11f0760aadso186205166b.1
        for <kvmarm@lists.linux.dev>; Thu, 02 Jul 2026 03:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782988736; x=1783593536; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rYY7gICYK6mnr7SZ0h8JVgwFO2ykA+NhgpS4kfMsPR0=;
        b=d+P+ahOdYHNzsSlc+A2KeIDGlkifXP+e34zZs2d3Hnu8qO+pNRWHUtDJ9+BSRcsWTU
         aGxnT0S5ZNyW/RQsGTos135Q8caIRzBH1lIGRCgm+9Zx2xRHQukaYSVp0JAuLEYHz1Zc
         x+goalU5YC/3wOo+rheThCDLzVlqPRcCqB0+GWOYrZbP7s0RROIGIWOUsBKbtJSz3E3n
         wslqlFm4EnCBeGOTp/9kTRc4uzns2p7J191fEUsfJuIPuDwYM2pWpVBnFFiRhkk0E0KH
         rG0UZLofb3RkAHGcS1XD4ESWp/NaBB2h0WvuiyoWyX9MiyUgMK1CVPy3mOAPNBsLbTQW
         7lgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782988736; x=1783593536;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rYY7gICYK6mnr7SZ0h8JVgwFO2ykA+NhgpS4kfMsPR0=;
        b=mx1+n1bE4iDN1QZeqDQqq7IJDo7Gnh5j+qtGBvKj8lQHG1+3XzipeDO6nd4em5BYH3
         UKydFyWd2WzAXUwg9vzRxO8Ghij1NZFWS9NxOCYaS8T2XeOzV69onn7i5+0SBSZcneZe
         dNV3xFD1wJ1s5Pap6BmdiocchQrTsuCTm005BliPip5p96NG7e/LeoAfo4Ik0GEnoXcA
         cZ2gax/NLphqDP6I0r/a4C1fERcCjCSgYqLLngcFXxh5SxrwxcNDx7TpVO+tIR+c+8xf
         0YfKjMQVpkJ2H+h18Wphdc6xxPKnoOnFHdokRKibReLmbD7PT8jFu5wTqI4EQO4Xs2Bg
         pr9g==
X-Forwarded-Encrypted: i=1; AHgh+Rp6EIWb30rG/yNoBrl87544kdl21r0IeRwYIZGM9cLlpswb6eBEjcnum/SqF6gT1KPPT5fyR/I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/87U3lqm52r5wLJgYpThFhBlDAcATAkzR/E3UUoogMg8zXCOq
	zScCcslclviCq1UIylggYTNDAMyrLi2LiEk5TTdaP6V9yAIxG2iqazUM5zJLdxaAW+Jsqp7D2kX
	W9l3Mnaayf1UYpTQ5u4JYHWyf7EN3Zg==
X-Received: from ejn3.prod.google.com ([2002:a17:906:583:b0:c12:a94f:8b78])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:46cc:b0:c12:93ed:47dc with SMTP id a640c23a62f3a-c12ae7bb5efmr165217966b.40.1782988735859;
 Thu, 02 Jul 2026 03:38:55 -0700 (PDT)
Date: Thu,  2 Jul 2026 10:38:37 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260702103848.1647249-1-sebastianene@google.com>
Subject: [PATCH v9 0/6] arm_ffa, KVM: Fix FF-A emad offset calculations
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
v8->v9:
- addressed Sashiko double ffa_rx_release in "KVM: arm64: Fix bounds
  checking in do_ffa_mem_reclaim()"

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

v8: https://lore.kernel.org/all/20260630102058.3219867-2-sebastianene@google.com/
v7: https://lore.kernel.org/all/20260617145130.3729015-1-sebastianene@google.com/
v6: https://lore.kernel.org/all/20260527150236.1978655-1-smostafa@google.com/
v5: https://lore.kernel.org/all/20260526151934.3783707-1-smostafa@google.com/
v4: https://lore.kernel.org/all/20260520204948.2440882-1-smostafa@google.com/
v3: https://lore.kernel.org/all/20260512124442.1899107-1-sebastianene@google.com/
v2: https://lore.kernel.org/all/20260430160241.1934777-1-sebastianene@google.com/
v1: https://lore.kernel.org/all/ae9KN9nkOgDYJcGP@google.com/T/#t

Mostafa Saleh (3):
  firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
  KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
  KVM: arm64: Ensure FFA ranges are page aligned

Sebastian Ene (3):
  firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset
    calculation
  KVM: arm64: Validate the offset to the mem access descriptor
  KVM: arm64: Zero out the stack initialized data in the FFA handler

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 44 +++++++++++++++++++++----------
 drivers/firmware/arm_ffa/driver.c | 25 ++++++++++++------
 include/linux/arm_ffa.h           |  9 ++++++-
 3 files changed, 55 insertions(+), 23 deletions(-)

-- 
2.55.0.rc0.799.gd6f94ed593-goog

