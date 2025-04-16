Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7935D219A70
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744826721; cv=none; b=YKYmhrHPXvia3ptTAvrQYmDDRX3nvyLnadg4/Bih98XLMWR+i64trpMXDg3dpNCj9w0XS0T9l65ueT+3StlTH1WI6vHlL/LfRgAEWAFNK+6Rg941JJxT2NKbcLEf689dAIxcALiKmDxZriJK9LhDYTXusZDhuRSM3jMu0hz7rr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744826721; c=relaxed/simple;
	bh=mwforEguNwh38hMZjlrNS8MyeAClbrwYJZ9ftBkHh9E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fJuV1pu/Q4jXhV5pI4JByp4GFodx9cACdsI9+fPDow7wycxQDOjVbAvqbS4BvAb4Wmijb///IppENrcds9Bz/1Z4ejRU9hfeW42nP3nMIAwTxDfD3db6OhoXyBzDbLQpHerhqZRTwiXXpGR3jgZMYZUsJ7CG4TRX8fj3nRKZ7BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vVe51u1O; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vVe51u1O"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d0830c3f7so53788685e9.2
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 11:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744826718; x=1745431518; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4zrBJJLCZeJhENR6VmafxLFJBE/IGwmNNec6pbe9xA=;
        b=vVe51u1OO4XVapTbjkwOsEqQk0mFdnlsv5WqE2np3IdEyqcjJrwKpuQThgrIkLeTlL
         Gq2jX6jude7aHGqt9wN64DhpRLv0Pa0TLYmvSkEX6tRoLVV1/SgkxE7kxpqe7tnfD2Am
         V7s5jeK2qSzKSOinMgOu8U+VbaGHxobZ/tAb2BNqPgXgw2yLn8RCoRGHvQLwHVktOReG
         Np0Xql6IAYV+1sssTl8jPfFswK9+Yq0PMo2g/SMdchHmr5EGudCd4yM+3oSsPlvMyJE1
         YH6sJH8wQnumdv+iRwtLJHwxy+s5juDDx8UyTV5P+7JE1funJcYopFuwzFIL74KOolD5
         1VRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744826718; x=1745431518;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4zrBJJLCZeJhENR6VmafxLFJBE/IGwmNNec6pbe9xA=;
        b=rXY5PRAlvAQyWcBq2XZXDKQ1b0x0aSdfvFBqt8oI4iub2S+lOO5oDE50f2hji2u5Dt
         bWqNnXPUoERFr7vYEACm3Of2pNm7NGE/1b3f5KsXqhqRIFXseVEHuCmYAXcAPQt2X7ba
         bu1OQF60UceUbC6vjN1uxEO+8emTs9jnr8NCg0Ez+MX0a3JQjPgVFB7MzLS8mo/0iM8g
         CohayY8H4IejaljL+rRe9LeFdvI+2W365CzkOgxEvxXNP8Oyz6jBeKpbDElJWm6ZUBtD
         WJqWaN+sWFIuBeaT5JyRdstpXO47xl/yBOw9k+6DTpjPG7sAaruKzryzwvv3IZkPA1vy
         dfqw==
X-Gm-Message-State: AOJu0YyNXRfnWU3/hoWGLuutlVu5P/Mq3tpuCpAjSQ+PYeNpNWuxwDCy
	gyvc7FvQ8TdBzEEsRqrXXb02bEVZIMavAIQrzY/XUsITiulxdxUu/tjzaafNqo/md/qLy3N1e0r
	LnV8/xAWz01o3xv0cWPTNvQWBXBFO3MkXmBd+g/sok9Zenk/Vp3J8XWJeD3Xc6QSD5Jm5xCz0gE
	qs5R37l7GjIU5UEG9pesM1G776qTPHQTMi5un4Yore+i8=
X-Google-Smtp-Source: AGHT+IG37/jJdPo16ODppABBlkwhdau6i150sm+0uUTYuYiDLU7nXYICCYXasqDCVq/D4SyObvt76W48aTqKsA==
X-Received: from wmbbi11.prod.google.com ([2002:a05:600c:3d8b:b0:43b:bf16:d6be])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1ca3:b0:43c:fe85:e4ba with SMTP id 5b1f17b1804b1-4405d637b49mr28449355e9.15.1744826717658;
 Wed, 16 Apr 2025 11:05:17 -0700 (PDT)
Date: Wed, 16 Apr 2025 18:04:30 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250416180440.231949-1-smostafa@google.com>
Subject: [PATCH 0/4] KVM: arm64: UBSAN at EL2
From: Mostafa Saleh <smostafa@google.com>
To: kvmarm@lists.linux.dev, kasan-dev@googlegroups.com, 
	linux-hardening@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	broonie@kernel.org, catalin.marinas@arm.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kees@kernel.org, elver@google.com, andreyknvl@gmail.com, 
	ryabinin.a.a@gmail.com, akpm@linux-foundation.org, yuzenghui@huawei.com, 
	suzuki.poulose@arm.com, joey.gouly@arm.com, masahiroy@kernel.org, 
	nathan@kernel.org, nicolas.schier@linux.dev, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Many of the sanitizers the kernel supports are disabled when running
in EL2 with nvhe/hvhe/proctected modes, some of those are easier
(and makes more sense) to integrate than others.
Last year, kCFI support was added in [1]

This patchset adds support for UBSAN in EL2.
UBSAN can run in 2 modes:
  1) =E2=80=9CNormal=E2=80=9D (CONFIG_UBSAN_TRAP=3Dn): In this mode the com=
piler will
  do the UBSAN checks and insert some function calls in case of
  failures, it can provide more information(ex: what is the value of
  the out of bound) about the failures through those function arguments,
  and those functions(implemented in lib/ubsan.c) will print a report with
  such errors.

  2) Trap (CONFIG_UBSAN_TRAP=3Dy): This is a minimal mode, where similarly,
  the compiler will do the checks, but instead of doing function calls,
  it would do a =E2=80=9Cbrk #imm=E2=80=9D (for ARM64) with a unique code w=
ith the failure
  type, but without any extra information (ex: only print the out-bound lin=
e
  but not the index)

For nvhe/hvhe/proctected modes, #2 would be suitable, as there is no way to
print reports from EL2, so similarly to kCFI(even with permissive) it would
cause the hypervisor to panic.

But that means that for EL2 we need to compile the code with the same optio=
ns
as used by =E2=80=9CCONFIG_UBSAN_TRAP=E2=80=9D independently from the kerne=
l config.

This patch series adds a new KCONFIG for ARM64 to choose to enable UBSAN
separately for the modes mentioned.

The same logic decoding the kernel UBSAN is reused, so the messages from
the hypervisor will look similar as:
[   29.215332] kvm [190]: nVHE hyp UBSAN: array index out of bounds at: [<f=
fff8000811f2344>] __kvm_nvhe_handle___pkvm_init_vm+0xa8/0xac!

In this patch set, the same UBSAN options(for check types) are used for bot=
h
EL1/EL2, although a case can be made to have separate options (leading to
totally separate CFLAGS) if we want EL2 to be compiled with stricter checks
for something as protected mode.
However, re-using the current flags, makes code re-use easier for
report_ubsan_failure() and  Makefile.ubsan

[1] https://lore.kernel.org/all/20240610063244.2828978-1-ptosi@google.com/


Mostafa Saleh (4):
  arm64: Introduce esr_is_ubsan_brk()
  ubsan: Remove regs from report_ubsan_failure()
  KVM: arm64: Introduce CONFIG_UBSAN_KVM_EL2
  KVM: arm64: Handle UBSAN faults

 arch/arm64/include/asm/esr.h     | 5 +++++
 arch/arm64/kernel/traps.c        | 4 ++--
 arch/arm64/kvm/handle_exit.c     | 6 ++++++
 arch/arm64/kvm/hyp/nvhe/Makefile | 6 ++++++
 arch/x86/kernel/traps.c          | 2 +-
 include/linux/ubsan.h            | 6 +++---
 lib/Kconfig.ubsan                | 9 +++++++++
 lib/ubsan.c                      | 8 +++++---
 scripts/Makefile.ubsan           | 5 ++++-
 9 files changed, 41 insertions(+), 10 deletions(-)

--=20
2.49.0.604.gff1f9ca942-goog

