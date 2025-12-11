Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053202EBDE3
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 11:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765453112; cv=none; b=SFS79RurIjX7dzLbx5D1yf9vFS3tPQY//n7kigH3R7VC0S2aZNtcqtHIEP3vRplULFcnvUkBW4B79xS/eDAQNoFmZbpVhS7wuweIEoXBv+peD+ndUGaIOIZ0fWXzXEzklCNsWKCHvKHirr4pnmdlorQTSAuA6cgZ5wj/Ft/8k2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765453112; c=relaxed/simple;
	bh=0NUGEdE2gGvvTSabZ4VjEwBUuxj4vNHbJ1kfrp5W+qM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bEV1GzDMdQ9QNE/jJRlLvPmNycWyvc+UCe6kxdKiGS0nqZTBeRtUX+fBG5MvteFUGyRiabufkiRo7NSLSVxQ4lI8BFzwfRyoVjJ/7aV/h5J8wWRe+R7Mjq/1qT08tPZwSrw4pEDgZo0Q0W/dlgchsRCshE8dgyM7LzuX25U7is8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Vh8I9Zd; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Vh8I9Zd"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42e2e50cfaeso587209f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 03:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765453109; x=1766057909; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CckZrUPb46HYjW9q/J8GG7tJwmYowZwvL5Toejifz2s=;
        b=4Vh8I9ZdgofqvBkw8ZHPiPh3CS9BSeI+jPzCZqt62+oKFgjA/sTytV/wOcG92ywEHw
         IzTIEo5pJ7X8sUl4SdqFyE1mqgOHTaxfRGnLBDyE4FRGDiOF2gm0tXmWhK69Tblx33Y3
         /dmzz1FsalJT6dcLQIpAXD00TmFObBpLmpnm6VyRo74rp5wGZh9ebRSrlZ5tlWzDkp5p
         CQBJT+nZHuMQmnXdKCI+ohD63A1l7vJAuioDJBboLQlWkW6ZQdZyLR9MPWHuakdJV1qq
         BvqqNq4qo49pvJljHTQTJu+TW/dTkUK2jAZWM4JIFXZOrohf8TVmw7jKAuTMyxJTe7DM
         NmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765453109; x=1766057909;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CckZrUPb46HYjW9q/J8GG7tJwmYowZwvL5Toejifz2s=;
        b=S72MwmWy0WHluxGMur/Wkc05HrlrAnQP2NeSKbrQDcpaJONt/K/ocH7Kl2UhlMHE2h
         TKFJQTXWGvTky8kvFXZNkhiBpHRvfNvCygQDVFOlk28215vEov2aJGzyD0mj8aTU8Jex
         HTYo+1ntGtTP0rtvQqyf7IcudO3NxflFRqrbqO2ELMVFWXI7sLKrPz6EWQNZsTe4PPRA
         cGzsX1wJS381UgIXWHXDxZliqIyKKACRbY84YA2IPxa/mhiL3uSCJZugSgKm/bPYREsD
         V7dHX0J5H5hqnwHVdY0p0Nbd5BusbLIp9mCY0LKEnKsRbghyYdhsyBvrU6zwDMO/aPYQ
         tToQ==
X-Gm-Message-State: AOJu0YwQPiFNqsRmwwDUfA1m/kHf/3zjcw1xwJm8WTjwn6dHRow4PmzJ
	i8zbqA5VafO8tzs7FS0AdehUlZ3nNwEwKhnuKOgXMld87FJSgnn70NmkBrZVnCVYF/kkYsyPSkb
	zFfXbEXIu+QTBFRLQRL8nOsRlrrER+6y3ySE3fJmGmi5KHicEgIkxNWL5Ae8lOLNAxgbCIGOQi9
	/9ccsJC+IIMwEVb9RBCGSkc/bmy14cep0=
X-Google-Smtp-Source: AGHT+IHGT/x5KyuVOljq6fzfjB0iRjK178XSlQN3GeksKcr8VmbWiVYNPeYgJhy+9wL3xLSwnbIaeT020w==
X-Received: from wrbhg14.prod.google.com ([2002:a05:6000:1e4e:b0:42b:2c97:16d9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:adf:9bca:0:b0:42f:a8bc:813
 with SMTP id ffacd0b85a97d-42fa8bc08bemr2137499f8f.5.1765453109288; Thu, 11
 Dec 2025 03:38:29 -0800 (PST)
Date: Thu, 11 Dec 2025 11:38:23 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211113828.370370-1-tabba@google.com>
Subject: [PATCH v2 0/5] KVM: arm64: Enforce MTE disablement at EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

pKVM never exposes MTE to protected guests (pVM), but we must also
ensure a malicious host cannot use MTE to attack the hypervisor or a
pVM.

If MTE is supported by the hardware (and is enabled at EL3), it remains
available to lower exception levels by default. Disabling it in the host
kernel (e.g., via 'arm64.nomte') only stops the kernel from advertising
the feature; it does not physically disable MTE in the hardware.

The ability to disable MTE in the host kernel is used by some systems,
such as Android, so that the physical memory otherwise used as tag
storage can be used for other things (i.e. treated just like the rest of
memory).

In this scenario, a malicious host could still access tags in pages
donated to a guest using MTE instructions (e.g., STG and LDG), bypassing
the kernel's configuration.

To prevent this, explicitly disable MTE at EL2 (by clearing HCR_EL2.ATA)
when the host has MTE disabled. This causes any MTE instruction usage to
generate a Data Abort (trap) to the hypervisor.

Additionally, to faithfully mimic hardware that does not support MTE,
trap accesses to MTE system registers (e.g., GCR_EL1) and inject an
Undefined Instruction exception back to the host.

This logic is applied in all non-VHE modes. For non-protected modes,
this remains beneficial as it prevents unpredictable behavior caused by
accessing allocation tags when the system considers them disabled.

Note that this ties into my other outgoing patch series [1], which also
has some MTE-related fixes, but is not dependent on it.

Based on Linux 6.18

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251211104710.151771-1-tabba@google.com/
[2] https://lore.kernel.org/all/20251127122210.4111702-1-tabba@google.com/

Fuad Tabba (4):
  arm64: Remove dead code resetting HCR_EL2 for pKVM
  arm64: Clear HCR_EL2.ATA when MTE is not supported or disabled
  arm64: Inject UNDEF when accessing MTE sysregs with MTE disabled
  KVM: arm64: Use kvm_has_mte() in pKVM trap initialization

Quentin Perret (1):
  KVM: arm64: Refactor enter_exception64()

 arch/arm64/include/asm/kvm_arm.h     |   2 +-
 arch/arm64/include/asm/kvm_emulate.h |   5 ++
 arch/arm64/kernel/head.S             |   2 +-
 arch/arm64/kvm/arm.c                 |   4 ++
 arch/arm64/kvm/hyp/exception.c       | 100 ++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |   5 --
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  44 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c       |   2 +-
 8 files changed, 114 insertions(+), 50 deletions(-)


base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
-- 
2.52.0.223.gf5cc29aaa4-goog

