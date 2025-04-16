Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94326189BB5
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744817214; cv=none; b=PpKnjfXuW+/AMl01ODDf7cKSoneIXFymdHabCPT+1bDZsYcCgO8H2Id56+fMQ2dQOw/njqM+M4HFkI7XVfIQYTTmxywnbWkJXsNnUQOncTzIYRMGFW/6PsYdq60yBN1shfYo+H3RTax6J7evXA142h7BJJYZypamnXTyS+ooBKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744817214; c=relaxed/simple;
	bh=Y6taT1bvJ3WoWsDqnE+pO1kbM38sZq1Qzqeoy+M40KI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OO4ykHqOg9s/pB/j/7fP8dM64Bta4tvEG3fO9+vRpWewCUFQZ3lL6Mjp1XwoGB73/K5RL+YbMAO4Iw9VSocuNmukE/UnOUVSyCaf23agvQOu45HV5c4HpYayHSIRBz3iaUWDrlRk6K9OKRDAvhseMEjyBnArICInEI+b/OyAwxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bccmzo2z; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bccmzo2z"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5edc07c75efso6424271a12.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 08:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744817211; x=1745422011; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4H1rdwsdSrifJxMs5eiLI+4nIAiDgFXwyzylypkYumU=;
        b=Bccmzo2z0OM4D/EeH84szAngKD66y25Vm+DkrjITSat4iMHG/UGC3LyG5VR4tZDXOS
         +tcvama2JYbkKGo0JcdpldSx5fa9EjR1cgg/2L7YPxKn76ZsWQVDRPYXmJKCQgA1YkXW
         z3euU4zDUbwnu05CDGP4tXBbmvDUXa8QDWPJck+gwXYFwULFX0K3vJlkUIQR/NlTpO1T
         EPkIHPbnD26SbFOwGl3Ur99UjRnEizZ5hs8bdahXbGndJCcPh/F5AN5U4geejUScLpmv
         YQeOLuOXZ4dVxHIzIfyBPxj5imSC/6BehzF+9mhlf8QiiYQ7JEP6NAYekC9sa0ZDKg17
         Pnrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744817211; x=1745422011;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4H1rdwsdSrifJxMs5eiLI+4nIAiDgFXwyzylypkYumU=;
        b=MVZrLNV+K7GsyXoEoU0d3hpDFlbi1W3lupqUpFJMt1+ccK1el9GPbGeZl5gBS9uemL
         dYNoc0fUxwE+Fq3YaJYMzgVKCinOoSyRQ+hgCpa+JP8+DJkbp2PRCC/Js7lv4O3Lp1fV
         6YDPTL9e7ddj+wojrorQXtlwa3TVepTWKAZwlIABgLkOfgDb32KS49tilXB4eY2eV/Ml
         BDRN4/kyXhroS1TyTclD0X0RqZFlk/7a7Yg6uySDhlhAwJr+fZgBU/SrnQcAxLBcKaz7
         HI8Q8dbdQdwdDI6oMbz6EetkitcCFkYXttfIhZfU0QuVdfwASlZmlOQ7EPjJ3DtARwUw
         VBKQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3eBJlRiq1F5tgr5TJ/2VWhrcDynZG9AFUuSdqclPgiIuu6kyNjhDa5r/8hZ2hgVnx/b/pFtc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd1+MM0ny1Zr7Ft45JWfgbWJMQ6CSPrOkuqHdr+z7gj0vUWBUa
	ieTaeOA8AtpSqz+WJmehyoxnU7e0plG0uVoJgTXQwWRxGe2Xoc6+fwAtZeKHo7lLhBs3nARNOBE
	4kAnoaA==
X-Google-Smtp-Source: AGHT+IHuqk+2+OpJM1qcSmjpRDqa8HEvy7iDhIfBrhRdZNtdJ2xDUzaYWX9wIlKoApyZVheRJqd8RH//SOf0
X-Received: from edbcf8.prod.google.com ([2002:a05:6402:b88:b0:5ec:bf29:2e78])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:849:b0:5f3:4194:187
 with SMTP id 4fb4d7f45d1cf-5f4b75a6b98mr1899450a12.18.1744817210816; Wed, 16
 Apr 2025 08:26:50 -0700 (PDT)
Date: Wed, 16 Apr 2025 15:26:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416152648.2982950-1-qperret@google.com>
Subject: [PATCH v2 0/7] Move pKVM ownership state to hyp_vmemmap
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
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

Patch 01 is a self-sufficient cleanup that I found thanks to patch 06.
Patch 02 is another self-sufficient cleanup that came out from the
discussion with Marc at [2]. Patches 03-05 implement the aforementioned
migration of the hyp state to the vmemmap. Patches 06 and 07 are further
improvements enabled by that migration.

Changes since v1:
 - fixed page-tracking comments in nvhe/memory.h
 - rebased on 6.15-rc2
 - applied Marc's Reviewed-by

Thanks,
Quentin

[1] https://lore.kernel.org/kvmarm/Z79ZJVOHtNu6YsVt@google.com/
[2] https://lore.kernel.org/kvmarm/867c4pnspi.wl-maz@kernel.org/

Fuad Tabba (1):
  KVM: arm64: Track SVE state in the hypervisor vcpu structure

Quentin Perret (6):
  KVM: arm64: Fix pKVM page-tracking comments
  KVM: arm64: Use 0b11 for encoding PKVM_NOPAGE
  KVM: arm64: Introduce {get,set}_host_state() helpers
  KVM: arm64: Move hyp state to hyp_vmemmap
  KVM: arm64: Defer EL2 stage-1 mapping on share
  KVM: arm64: Unconditionally cross check hyp state

 arch/arm64/include/asm/kvm_host.h        |  12 +--
 arch/arm64/kvm/hyp/include/nvhe/memory.h |  58 ++++++++++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       |   4 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 106 ++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/pkvm.c           |  47 +++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c          |  10 ++-
 6 files changed, 158 insertions(+), 79 deletions(-)

-- 
2.49.0.604.gff1f9ca942-goog

