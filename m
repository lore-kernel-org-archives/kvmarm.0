Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396E11A9FBA
	for <kvmarm@lists.linux.dev>; Sat,  8 Aug 2026 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786179513; cv=none; b=NCeZ5uotaLFtqNIVM8i6ZRR6BSxeZ/W59o+pj4rndmRrZCriuzRjJygwHC1RJYIMukcpCGtxu4jZgKKKZNmC7AJkepNq5oJZKSh0ycMQwBlZtwYB2q3qEsZEsk1F5j4MZ9XHiuiPbeEiRmo9Pwaky+fZu5L3xshm+rHxMuKqW7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786179513; c=relaxed/simple;
	bh=MBM6i0g97jlAhoj4jbNygjX4IQIv6AnWMC/+/U+xaJE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mDRoyYgPWP2XKO21SKg2bursifNoaldZkv8hqB3zWYSVjXcM1tQL/9V04KC9VbZx7pWkFtsj6g9YLtHyxew5U44jWqfoS8bXL6lwL2V6XMzTDZxVDINWvGLikXoamGbxBMnkrhZCE6CI4Gq17Y2+DHM/u84QGk0E/oLqSU1r02Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d/FXZKoo; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d/FXZKoo"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c1f3117bc6bso22215066b.0
        for <kvmarm@lists.linux.dev>; Sat, 08 Aug 2026 01:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786179510; x=1786784310; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FrZdKcH2ruwKtKo5KlReOpSBpXMc1Hr8DvI2W2K/qho=;
        b=d/FXZKooSw49Awk7oRXCai4tXOtuxuaT0DRk1keE7fxNjFiG+nyRahievDtkOWo1Rj
         KZJXqNY1/OIYsJiFLWcPiBSD4U+UI5Ry1aeSnKk/nFsiSdmJRp8bt4oM2C23u9aL2dXT
         N6q58Qz30YXVVRYXrs+GngrKHkp2y6+0jr88KEO3ZJK24qGykA21AAnQBEAMPVWPIKAs
         8lYC6gDSD2rb8hdEmPK4DZaVmDBkraSAxvBNylfhwFEsQIKqlTAZNxTXs+fX+kLy4l0g
         PYsJd1eqnqUKXiVT/OOt73ZIRMd0fSNF+hK78IFUaT2GMBiAZXh2WnZPNVlluWn8yF6M
         Q2cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786179510; x=1786784310;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FrZdKcH2ruwKtKo5KlReOpSBpXMc1Hr8DvI2W2K/qho=;
        b=a6UYrB3eG+ek/jJwjl1nkfN35DiJw/xMDOi32tU5EU3b6SCm/6AOtNhlKm1hBH0e8C
         eFVoMduI+g+XDrY1rigf4jhztGX69PItEfL1AZQA90rQ90XZXIYCDjtFCRJx5i8tDuxr
         LuIfs4FSUPI5cfkF39tD0Too+o1Czj0L+iVj3oCYcDIkxP/MFve+VssG5psjxXduMeR5
         xPltiU4ltD2pB921Pr7G2iv1F54Jb2HxQuqWC2gctWv/IlMwP4eCAoEU1+dXfISp0oI2
         4ls81owjvmZYDUi8M0bIyl25ABpG6kTx9FMTJH1sCiSXTzPknLGVc6daCyvWJa/uyNUW
         /LQg==
X-Forwarded-Encrypted: i=1; AHgh+RrQxfJXUT+miycxPTgxNhnNDe+wJdHjGiVKckemZcMtPXkmHmjQV9hGQUVz/Ws0XUyEq/N5WB0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwrGl+96rhR+U/Q/HJP9OY7jWAdci0mvBM7Ef909d6bOjf5oY1c
	coQmE+gJE677lZ/1LsgMvgOoKtEeBROuhd4JxR3LS8BZre/vbVPCKDVA1WDDbj9VKaidaUCeGV3
	dns1UUvCR3lFIxw==
X-Received: from edwt14.prod.google.com ([2002:a05:6402:3ce:b0:69f:274a:c867])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c04:b0:c1d:fb83:9394 with SMTP id a640c23a62f3a-c207339a850mr702312666b.24.1786179510049;
 Sat, 08 Aug 2026 01:58:30 -0700 (PDT)
Date: Sat,  8 Aug 2026 08:58:21 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260808085824.732659-1-smostafa@google.com>
Subject: [PATCH v2 0/3] KVM: arm64: Fixes for timers and pKVM
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	yaoyuan@linux.alibaba.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

What started as a  small patch ended up as a 3 patch series thanks
to Sashiko.

First patch from Marc to consolidate the offset calculation,
follow up patches fix issues with non-protected VM and timer
offset and protected VM running with broken CNTVOFF_EL2.

The patches have all the information so I will keep this short.

v1: https://lore.kernel.org/all/20260806150105.4010701-1-smostafa@google.com/
Main changes:
- Add comment based on Fuad review
- Add prefix patches that also fix the non-protected hang properly.

Marc Zyngier (1):
  KVM: arm64: Make timer_get_offset() work in all contexts

Mostafa Saleh (2):
  KVM: arm64: Fix timer offsets for non-protected VMs
  KVM: arm64: Fix hvhe and broken CNTVOFF_EL2

 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +----------
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 14 ++++++++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      | 10 ++++----
 include/kvm/arm_arch_timer.h            | 34 +++++++++++++++----------
 4 files changed, 41 insertions(+), 32 deletions(-)

-- 
2.55.0.654.g21b8a5bc05-goog

