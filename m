Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE26A4A24
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 00:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740616395; cv=none; b=dejnftrCrbQWqigVMMISiaxdmXuamUKXL72jz1OLAZ6OxSusq2gnMEYZcxqbGfOJxgGFAhZ/LkT3ObVJUDU2pwWv/0LKT9EIdr6KOFM/npb8r01IhAAmQLN+sc1eA02k2ttbhhMGbyBPR/eRMCZ6r79kIgk5dGYbyxtdC501jAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740616395; c=relaxed/simple;
	bh=be/ZUGnpm8e7dztLvliWBuYLZBElJlzpV2+69nHUWIo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=c1RdcONbCSGfDnBikG5Ppm4qtxHh0tWk/CMJERz4nCazfWqHa30Y8O42zV+ZW54QI2opQ+lG3AzFHwKGjFzxCFkAU4eEXdn9hlwxZD/WpoSjkhQ6jNl1mOLftz83xJYJ76qbqCVxoOpJFB1R3y/kuPtHoWcFRjkoxHcAQB1JiQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c+5OJqP2; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c+5OJqP2"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e4c2618332so336529a12.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 16:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740616392; x=1741221192; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wMaRPzN9DtDhFSXMETT7W68/dj5OM7TC62vNvIpIxu0=;
        b=c+5OJqP2VnEYpDaa07HDeoqeGFdapjT0z6hzd285QGO67AeoPiuNubWOjnUkNq4034
         IQbOaRcoWydVS1IlBJg/H8IRtAtapP2R/BbNuCbb5nxj1z+JZ52JqbSFeFdvcLEFgnkq
         3OlnfnkPy3RhixMk8NrOkm1JUOrC61JDXeoGsYHEjJgo+XbAwFBSzhXnOK6VKc71aQCc
         Kvlg61nZ0RuTIV+7Lz+NV5+2GXjd7BDF/pmz5soL/9mybxXM7xAhJqdck+UI6qaWYwTi
         fTLsO+7sGVe2F7muqrRY3ufe+zjBiD+UbE2jVi+Gf2bu6tzyWcWqn2qgAXXzsUK7oVW2
         xszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740616392; x=1741221192;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wMaRPzN9DtDhFSXMETT7W68/dj5OM7TC62vNvIpIxu0=;
        b=mYHE/FwYiK3u3et9soSFRsk9jZj9jnVKKw7fJ1J0w3lr30TbZWOjULAMjDBcqWumB2
         iHw5OLqW5Akyt21m9rUvQJ+0Dt+2s3OSsUmlfjjyVL2K+MZ+1+oD2EwItsbqxd53jZ7Z
         IGZ0/Fqp+hdAb0sLslM6LZj34fL0kLnI17V08oz78/S1946uvYUdQDmZMBcHEBDA5/BY
         07yOARc+pTTjROG6TdzPW99OqCNAHzggR/Uh8U1UapbX3EkFipMoa97D2r6NaE5XrO08
         M/yW56zTsm+yIQXFhgIBWZOCJda1On7/J8rQJbc5N2KGkg/HjSyV5GhJOg/i4jVp0OtY
         YorA==
X-Forwarded-Encrypted: i=1; AJvYcCWbmkC0NyZuHm7U/9pmA7YkTz+zD1h8haUWEq8IRnWUbMKUhwxRpQOdg3rqSkUiTC9sCB0jQkk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZjUv1sXz5mHg85aPRG3FL5uamkWGmTqem3dtlEnSVjUVWa6pQ
	nf1Tv7Vo1LzkrYGayEGF1X9yv9l12YgW3saRASdapPCJmooxMbCfWt0dk8XObEKtgsmDM6BR5Ac
	NjLi6jA==
X-Google-Smtp-Source: AGHT+IGS4fdHxE39pl3VbWkoYw/QY5aHCxMCm+ank2eEa2pcJSljLByRM9MEI79KT3OUTeH5ozYKhW5tXaC8
X-Received: from edbev24.prod.google.com ([2002:a05:6402:5418:b0:5e4:b657:188e])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:50ca:b0:5e0:9269:f54e
 with SMTP id 4fb4d7f45d1cf-5e4a0d72136mr7684875a12.14.1740616392345; Wed, 26
 Feb 2025 16:33:12 -0800 (PST)
Date: Thu, 27 Feb 2025 00:33:04 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250227003310.367350-1-qperret@google.com>
Subject: [PATCH 0/6] Move pKVM ownership state to hyp_vmemmap
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

This series moves the hypervisor's ownership state to the hyp_vmemmap,
as discussed in [1]. The two main benefits are:

 1. much cheaper hyp state lookups, since we can avoid the hyp stage-1
    page-table walk;

 2. de-correlates the hyp state from the presence of a mapping in the
    linear map range of the hypervisor; which enables a bunch of
    clean-ups in the existing code and will simplify the introduction of
    other features in the future (hyp tracing, ...)

Patch 01 is a self-sufficient cleanup that I found thanks to patch 05.
Patches 02-04 implement the aforementioned migration of the hyp state
to the vmemmap. Patches 05 and 06 are cleanups enabled by that
migration.

Patches based on 6.14-rc4, tested on Qemu.

Thanks!
Quentin

[1] https://lore.kernel.org/kvmarm/Z79ZJVOHtNu6YsVt@google.com/

Fuad Tabba (1):
  KVM: arm64: Track SVE state in the hypervisor vcpu structure

Quentin Perret (5):
  KVM: arm64: Use 0b11 for encoding PKVM_NOPAGE
  KVM: arm64: Introduce {get,set}_host_state() helpers
  KVM: arm64: Move hyp state to hyp_vmemmap
  KVM: arm64: Defer EL2 stage-1 mapping on share
  KVM: arm64: Unconditionally cross check hyp state

 arch/arm64/include/asm/kvm_host.h        |  12 +--
 arch/arm64/kvm/hyp/include/nvhe/memory.h |  35 ++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       |   4 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 106 ++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/pkvm.c           |  54 ++++++++++--
 arch/arm64/kvm/hyp/nvhe/setup.c          |  10 ++-
 6 files changed, 147 insertions(+), 74 deletions(-)

-- 
2.48.1.658.g4767266eb4-goog

