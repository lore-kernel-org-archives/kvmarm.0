Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5B02AF03
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346262; cv=none; b=tS7muZNW287J+vAH1y2c9CrsW9JuEYiN2w/kniSDeP3/BpkFJ310F7qcyeH+nV4RQ+EIsS7ToowajdwQNPjqHrbmt2nqPd3M3uP1ScS8UnlkMqBICLNxvsGfRZ2JeeFf7aLg+UGYl86E3vS2qyAYTS7yn8k0Np0ksBfxSBfwQO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346262; c=relaxed/simple;
	bh=dQ9qorAXD+99ZSVcYUzhNM/vuSLuws8QppeyWh8FHgY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Jl4Eiqk+zir2EHOotrAL/HR3pQBU/4FgkMJF9HF4ZvPxeqBw0jt9i+RtwMG4ZPT4VTgtNpe7KrTAlkjECDLjPTA9PLlbH/oSJZljf0mWthrPtGhT/oFZ5xUD69FqBWLmXW9hMh/0W89yk45zHYcEf2VETp7mL3SXI/76xDkIaoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iEfOY3H/; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iEfOY3H/"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-436219070b4so21335385e9.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346259; x=1734951059; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xQDDzZt4y0tR25eU8iMMeXksMyuUkWpuvz05sBggv+g=;
        b=iEfOY3H/0v6uYqbbbRE4e6pK9sX8vYURUPmLLRuS02QBttY08FY4eXHCITtz39Mauh
         J2rOh8dtcrILlO9+IOsV00SiXZYiV/zHmtYbtxAwItPCQJG7sA2FJOc8JZRtg/B8vMPj
         jzW6smcB7E1LErWEQAcf+hjFAcBzTOjKNEOllkpc36PBKW7v/0SPLZpgwGJNPChRgY1S
         1krZM3Swd9kklvPOvTPz22xGYlemn5MedVRQQxbpJyzv2JaUmhnkkqZq8IMH0m9cJE/Z
         dQNbC06sTxBQcxSgn+76wGJHrcDqTFb42+pNKNtBHT6vY4z2lK/K+OxA1OuTRzKswRgf
         1DwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346259; x=1734951059;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xQDDzZt4y0tR25eU8iMMeXksMyuUkWpuvz05sBggv+g=;
        b=Onon+aumyXf2oFS3KHjNQ2TiFL9na2xK+rV5z80LVHfLyfY9Yoz5hNkjCcdj6JNxKl
         I6kQvESMF/CSbex6UxuXWwVWINIHgErSKAdyacKP9FN1T545a0wLM/8TSn7oYnzuQrQr
         wu5vu3OiFBdDjhFUb/Ub/aaAHKoRgeSoSwkZswAXy6niiZQ2RvsODWEJNbFabcKC/2d8
         fSshHhAj37avPdkXA+s24sQkt6W4BnLxd45GdZYNL/n0o7Fu2o2wMiXVj8+8wWvCIZw9
         UwI0DufiMrAWUHOzqljdtVTK6KsymL5Aeq6Kvj1Zf74CfWs7SQS64DkPrvkY70ptReL3
         ZdZw==
X-Gm-Message-State: AOJu0Ywrll1d2xXlQ4lf2wSQmKw1Htu342/plD72AvEOQPT0WdE0nqlS
	vy7Gq5DEC7pS00LIW7BURmLSDP5WQH+7ncvMCrbq5uwszvU8xEp+dsCZzUf5rEbSvqtaO4cae4K
	Jd06f5xboarbIE41a1u0bJRX/mAifYzkjIkx0pLv32GxX8hBe9dVz/WsFiI+S5DgknfKEp+q63X
	iO796aV0Fe0SKPJJhGHahNQIAk8rA=
X-Google-Smtp-Source: AGHT+IFBE3ka5DUpquNIVyUccGkw78xq0QQq56z5catf4lSJVI6W8C5lL8e99RfPzfOguFI3u5iJMdYweA==
X-Received: from wmfq8.prod.google.com ([2002:a05:600c:2e48:b0:434:a922:b240])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c12:b0:434:f623:9fe3
 with SMTP id 5b1f17b1804b1-4362aa3d8bbmr117977035e9.16.1734346259304; Mon, 16
 Dec 2024 02:50:59 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-1-tabba@google.com>
Subject: [PATCH v5 00/17] KVM: arm64: Rework guest VM fixed feature handling
 and trapping in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from v4:
- (Oliver) Add assertion in kvm_init_pvm_id_regs() that vm_table
  lock is held.
- (Quentin) Carve out patches that fix RAS and that remove the
  feature KVM_ARM_VCPU_POWER_OFF from original patches, for clarity.
- (Quentin) Add a patch that refactors existing code to use
  kvm_vcpu_has_feature() instead of __vcpu_has_feature().
- (Quentin) Fixes to commit messages.

Other than added assertion, no functional changes between v4 and v5.

This patch series redoes how fixed features for protected guests
are specified in pKVM, as well as how trapping is handled based
on the features available for the VM. It also fixes a couple of
existing bugs in the process. Please refer to v4 for context [1].

This series is based on kvmarm/next (60ad25e14ab5), since it
requires the patches from the series that fixes initialization of
trap register values in pKVM [2].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20241202154742.3611749-1-tabba@google.com/
[2] https://lore.kernel.org/all/20241018074833.2563674-1-tabba@google.com/

Fuad Tabba (17):
  KVM: arm64: Consolidate allowed and restricted VM feature checks
  KVM: arm64: Group setting traps for protected VMs by control register
  KVM: arm64: Move checking protected vcpu features to a separate
    function
  KVM: arm64: Remove KVM_ARM_VCPU_POWER_OFF from protected VMs allowed
    features in pKVM
  KVM: arm64: Use KVM extension checks for allowed protected VM
    capabilities
  KVM: arm64: Initialize feature id registers for protected VMs
  KVM: arm64: Fix RAS trapping in pKVM for protected VMs
  KVM: arm64: Set protected VM traps based on its view of feature
    registers
  KVM: arm64: Rework specifying restricted features for protected VMs
  KVM: arm64: Remove fixed_config.h header
  KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
  KVM: arm64: Calculate cptr_el2 traps on activating traps
  KVM: arm64: Refactor kvm_reset_cptr_el2()
  KVM: arm64: Fix the value of the CPTR_EL2 RES1 bitmask for nVHE
  KVM: arm64: Remove PtrAuth guest vcpu flag
  KVM: arm64: Convert the SVE guest vcpu flag to a vm flag
  KVM: arm64: Use kvm_vcpu_has_feature() directly for struct kvm

 arch/arm64/include/asm/kvm_arm.h              |   2 +-
 arch/arm64/include/asm/kvm_emulate.h          |  29 +-
 arch/arm64/include/asm/kvm_host.h             |  25 +-
 arch/arm64/include/asm/kvm_pkvm.h             |  25 ++
 arch/arm64/kvm/arm.c                          |  30 +-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 223 ----------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   7 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 341 ++++++---------
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
 arch/arm64/kvm/hyp/nvhe/switch.c              |  52 ++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 404 ++++++++++--------
 arch/arm64/kvm/nested.c                       |   8 +-
 arch/arm64/kvm/reset.c                        |   6 +-
 13 files changed, 446 insertions(+), 707 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h


base-commit: 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df
-- 
2.47.1.613.gc27f4b7a9f-goog

