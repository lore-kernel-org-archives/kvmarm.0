Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3AE372EF9
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 22:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773701048; cv=none; b=Hf2xhx7GArKkk9ABRhbvzWHmEU6UXL82SlkfIMLcB9/rojKezCamLg3iv0n943SvE44RuKa+1PSzl5W2kO5Y8ppNtycy5oVYtNcouKqyQjUcAP3xhzXvXSe5SjPI24wFgR8M7Qb1+GUkbfWZeCN4t3J/fg2sfymqgiwkJGCGzSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773701048; c=relaxed/simple;
	bh=T02mPnop+VlOHthIvn/hMI0Uo2ghqBUATVUzggRzrNo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=V31/v6V1T9N1d7fAsmHDVdL1XI9qWWmchWzZNwrK4LUe/AhiCU0W9NGQ+ZvjuEYSx0pNCO8HkAcxltR83HdcwQ5Tt4mcMitm3PEloDqU9G3fXSK9b8/y1cDdVL2wQTZqTFx9TS19QdKYRwK4U8Hqw+vOSTqvmJR0ut4tg9ZJ3Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QNcxPo0u; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QNcxPo0u"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-829b6b22dabso2248850b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 15:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773701046; x=1774305846; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A6pTrTiGUfN/I2rSuI/vU8zcoVY/NvupDuQnP/ABsAw=;
        b=QNcxPo0uxB7sfaHIVWwR9kpp17usmiq2fbdi8QxINujRwgjo635+GZjMOoht87PEww
         r0Sw0T/t35xVyiR3sfV8OAv8hFWTIKDinktr5/5EWPFcLOulEHtA5GCRs4tG/JbFyq5B
         uyarTIA5sz1ExGvX82YJOT26UMVHCsVkH2v398I0I/8pwtVU30U/FIeUunwZsHidvqwj
         UfHWCQtdWf+a5bQcEFhWacnO6nLSZxhWHvrSx+J+dAavv/Xt9w3rHIbwN9glBD80li1z
         oBxMtHr7rR6Q+JBm/ceMm1BjQEupMh9bkJVQWbHCWj+pn7mmaJhpu3AcctWZ2JBjCHzE
         ZCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773701046; x=1774305846;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A6pTrTiGUfN/I2rSuI/vU8zcoVY/NvupDuQnP/ABsAw=;
        b=Je2w/2gTDiiN9hECvD0ZCAm4dStqJZh2b8MulDv2hhleHTIlc1b55QZVVK+/taZI1N
         AcyzP/GEjwmp1Bs0NKuIVCX9+wPaaWahgvTNZaPZQJnNpmZzmTMSqfsoRo1mRz+IajxT
         1YhBKCIBCgjRoWv/MHdFSnlY8JDhIlNwS6UDp2/EO5zWu3p46iCpq8uaY/j/FKKu0E4e
         p0auliKPqsIxYOPakotkNLEHrYknSSa2IiPFKzJ88n236g92M0cN1k1P9/CJpHRM4iUe
         Gsp+TDULmB4nDgiwWRd7DDu5ipd6yK9sdENmDo8ODXHdt1YQUwvp4lovITUFnRT08q/L
         5zCw==
X-Forwarded-Encrypted: i=1; AJvYcCXkAj89a4vyb375qsIc7FI9Jn6kIrtYhbaOeSPN3dtXm8puGx3/aoRuNU2pBf4L7tTfQEYHFxA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyj5rTcD9E2TbBu1m1R7MmULdwoMkMgh6CWBstKY/AnRnitMJxr
	rfyfw4COQXxs6BixiQdewy7b63xNh+XmkkO7YZKDW1giu7yVZaBrHz4gjrM+1sGR8BLYvnlnMIM
	+U6dWWSHxFIsNOCQqv9hLb2/CiA==
X-Received: from pfbgc11.prod.google.com ([2002:a05:6a00:62cb:b0:82a:128b:1da0])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1143:b0:829:809e:8978 with SMTP id d2e1a72fcca58-82a198ac2eamr13166611b3a.31.1773701045869;
 Mon, 16 Mar 2026 15:44:05 -0700 (PDT)
Date: Mon, 16 Mar 2026 15:43:46 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260316224349.2360482-1-jingzhangos@google.com>
Subject: [kvm-unit-tests PATCH v1 0/3] arm64: Add Stage-2 MMU and Nested Guest Framework
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series introduces a lightweight infrastructure for managing ARM64
Stage-2 translation tables and executing nested guests. These components are
essential for testing advanced virtualization features such as nested
virtualization (NV) and GICv4 direct interrupt injection.

The series provides a generic Stage-2 MMU library supporting multiple
translation granules (4K, 16K, 64K) and dynamic page table management.
Building on this, it adds a guest execution framework that handles guest
lifecycle management, context switching and guest exit routing. A new test
case for Stage-2 MMU demand paging to verify fault handling.

Please note that this is a very preliminary implementation intended as a
startup baseline for future work in virtualization testing. Users should be
aware that because this is an early-stage baseline, some portions of the code
may just happen to work in its current state. There might be critical
architectural elements or edge-case handling missing that will need to be
addressed as the framework matures.

---

Jing Zhang (3):
  lib: arm64: Add stage2 page table management library
  lib: arm64: Add bare-metal guest execution framework
  arm64: Add Stage-2 MMU demand paging test

 arm/Makefile.arm64         |   4 +
 arm/stage2-mmu-test.c      | 100 +++++++++
 lib/arm64/asm/guest.h      | 156 ++++++++++++++
 lib/arm64/asm/stage2_mmu.h |  74 +++++++
 lib/arm64/guest.c          | 197 ++++++++++++++++++
 lib/arm64/guest_arch.S     | 263 ++++++++++++++++++++++++
 lib/arm64/stage2_mmu.c     | 402 +++++++++++++++++++++++++++++++++++++
 7 files changed, 1196 insertions(+)
 create mode 100644 arm/stage2-mmu-test.c
 create mode 100644 lib/arm64/asm/guest.h
 create mode 100644 lib/arm64/asm/stage2_mmu.h
 create mode 100644 lib/arm64/guest.c
 create mode 100644 lib/arm64/guest_arch.S
 create mode 100644 lib/arm64/stage2_mmu.c


base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
-- 
2.53.0.851.ga537e3e6e9-goog

