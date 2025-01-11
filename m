Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E2310E9
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 01:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736558694; cv=none; b=FZ+1LAEYjbxMJPIG40slwEED24/JrmfnSMRuXwbWBylUkjwP2s4h+MajS9W6zg9tEUjEyXgfYbQH8rMyacOqnLOdByGYdw/GVodNe7kghnQzJO6fLDOWr9BSSJx92FUSkxNva9KSTcJ+vK/UvylSHh89nj9m6yh8eRnFKqJPxbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736558694; c=relaxed/simple;
	bh=TNA4ediMoh+0GARbkBQh+cxo7semdS4NBzhtyKW9kfI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hdJgM1vVYYtgcJG26p3mM3PElcJDvAXhK9msr9tBES5KfWiUQx1BOsXuUVJ/kW86NpKpU+EAqB6CF7NGqYgpWN4qHAiZ1/di97S/wIcfJZJ5pSvAAWpte/MJWrQdYxF8m+sCVe9JyIEmHdVKDkCjMyGbds/ebseja0UoyNcHuMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UBHCY2GC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UBHCY2GC"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efa0eb9dacso4852746a91.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 17:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736558692; x=1737163492; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wth181Oju/yKYvdF4NH88lRCMZbnQWr4S1ULRikLXgA=;
        b=UBHCY2GCTQ/wyCRsTLqcZPCbFMiL2N3BWriXDbKOE4kSYkeVYRJzr6JfBMO+h81HA2
         CygH9WOf68qHu72zImLc21RNVjuYg6JGUHa+TVV/IQZ90qEm/Gk/LUsFN7OUkxvfZxMS
         Gd9xYtqEIhDRoDg6FcSMN2hKd8stg27w31v1E/GECY5aHz1jKQHGZD8d/oywLR0YZcQb
         UWYJEmPmlb1fECz3Km48KF82+xY5H4SoIJqVzuyAHpBCt4dyh0y6PCrU8K/sxRVsqYwE
         o3SJeBUYOS8PPvMeUS2ENxTu7H5hTO4sXteYF+LkwJ/lbr6MNec/UU6x+Zhl/u1GUDak
         xW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736558692; x=1737163492;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wth181Oju/yKYvdF4NH88lRCMZbnQWr4S1ULRikLXgA=;
        b=ZJ8koBtDLqtsk4gR4KlJRduD3du6WjQKXps2TkK0++FOgpiRnGZspz/fA2nu4xLkSU
         FgN5TCbkyKox56bdTUF4yYLG+mdJXIvaLd2P1Ez2Y/joIWXDhJG8UqhMzLjAQaMjxoev
         VHpLIUF2sPo26wskjriPRe0RaYrwsTsAKFA/zvS1tOTUqICbx/uVRtv74SxPSvaWmSzB
         /YudkNOVWjujQEEYhY5UqbbwdCoWtjBf4vCoYrILZI0mV8/9ph9hMGPIvLOnzIw0xQp1
         0DR3MTv4TKNBtzVG+dx8fxB8tZXd+hcf/chNl9biO/aMfNtE/KZ8CatFpLO/umyRqzqm
         qJ0A==
X-Forwarded-Encrypted: i=1; AJvYcCWYxfLR6OzOPCJtZnjBodiwLjax2KnM8UQkGAqkHbexrXQitipzque7r4Bg8zEFi7i22Jx1sGQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWvfdB8Z1EkMx6UKD+B34evpkJuaTOZnQBmdTNEW/Rlip7Ydgi
	3S9PjmH2dqaO/E3BKGrUV7RRtsT+PrPQXrL9whbwDRXW2afwpxtr8c8JeyIcTfnCtVIw0687itc
	7qw==
X-Google-Smtp-Source: AGHT+IEfMuWFVKhsS9utsiRr0qZN46F4y7a5kx/arb7GLt+tjCHLQTHDuOdaekKI3i56eThn0gAXDuFPjYQ=
X-Received: from pfef19.prod.google.com ([2002:a05:6a00:2293:b0:725:e39e:1055])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:230a:b0:725:ef4b:de30
 with SMTP id d2e1a72fcca58-72d21f4b537mr18483242b3a.14.1736558692541; Fri, 10
 Jan 2025 17:24:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:24:45 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111012450.1262638-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: Add a kvm_run flag to signal need for completion
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a flag to kvm_run, KVM_RUN_NEEDS_COMPLETION, that is set by KVM to
inform userspace that KVM_RUN needs to be re-invoked prior to state
save/restore.  The current approach of relying on KVM developers to
update documentation, and on VMM developers to read said documentation,
is brittle and error prone.

Note, this series is *very* lightly tested (borderline RFC).

Sean Christopherson (5):
  KVM: x86: Document that KVM_EXIT_HYPERCALL requires completion
  KVM: Clear vcpu->run->flags at start of KVM_RUN for all architectures
  KVM: Add a common kvm_run flag to communicate an exit needs completion
  KVM: selftests: Provide separate helper for KVM_RUN with
    immediate_exit
  KVM: selftests: Rely on KVM_RUN_NEEDS_COMPLETION to complete userspace
    exits

 Documentation/virt/kvm/api.rst                | 77 ++++++++++++-------
 arch/arm64/kvm/arm.c                          |  1 -
 arch/arm64/kvm/handle_exit.c                  |  2 +-
 arch/powerpc/kvm/book3s_emulate.c             |  1 +
 arch/powerpc/kvm/book3s_hv.c                  |  5 +-
 arch/powerpc/kvm/book3s_pr.c                  |  2 +
 arch/powerpc/kvm/booke.c                      |  1 +
 arch/x86/include/uapi/asm/kvm.h               |  7 +-
 arch/x86/kvm/x86.c                            |  3 +-
 include/uapi/linux/kvm.h                      |  3 +
 .../testing/selftests/kvm/include/kvm_util.h  | 13 +++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  6 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  8 +-
 .../kvm/x86/nested_exceptions_test.c          |  3 +-
 .../kvm/x86/triple_fault_event_test.c         |  3 +-
 virt/kvm/kvm_main.c                           |  4 +
 17 files changed, 90 insertions(+), 51 deletions(-)


base-commit: 10b2c8a67c4b8ec15f9d07d177f63b563418e948
-- 
2.47.1.613.gc27f4b7a9f-goog

