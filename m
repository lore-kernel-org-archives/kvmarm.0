Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADAE27877B
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 13:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754402181; cv=none; b=FycvRINKQmXVCDLe43WhjCe/sQMFBIe3HaYEdKQ621RIYaruf9uN+949Y2YMoG8U8Sgf23RFiBzQ2d1h3hKWfureUeCw3N2m+f/qu3BStaR2FrufoiglBOSEWr8cHgMsFIX46R9DLlm1+z56AfKaw3a1XgAzlTPNeRVoBGw6038=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754402181; c=relaxed/simple;
	bh=Nmkxzlg94uZl5uojShZLlh74PZrGx3i2ILnBi6ZtVVE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tIowQ7r2sdcCWSB8CRXZHK9rZREeF/p7wGzF+w/AbL6nXWHvuPc2APmYeNHji7xLk98Z3et/ycAi7C/hM4dur9zKmLedb3gXRUOD2DguOgRekyE2uDtFYJrhP3brFqXULb5kDoUkw3xZ+wr1v6VFb/bZhAfOAt0sJmFOjaYeq7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wWmQJC5Y; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wWmQJC5Y"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-458a31421a3so21057745e9.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 06:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754402178; x=1755006978; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v+V5afcNzjmQTBS8vhpoJ2KI1ZaPZAnRYb5xq/a2u/M=;
        b=wWmQJC5Yr8vv6sFL0s6+XEcjDEwLJGLKcZv9PxAT6aek7VUGEn5aJhAP69voPkORns
         Wts2+alKtvOUayX/IkwXtVgL9rkAA2CqE4s8A0jstoDtwRwBi/EjdMFqnRlHL7+SY8x6
         uvHMaiBZ/twG04TNurqzN71CU/E/C5WgiGc9yqPJMYgy9a/7xIrHC989ZZVRvMM/UUmn
         YY9596N55xcAixTMgiCx6zqkH4Z4vew2o287+kIJAaKJdLcXPgjY7MGBflaFFfLd/12k
         2vTneVK11iJ5/MiYJIOk5RHgMUjJCgFtHT0s+cLGitmRLWdwa06Uot1FNTid5QSZ0EJz
         zjhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754402178; x=1755006978;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v+V5afcNzjmQTBS8vhpoJ2KI1ZaPZAnRYb5xq/a2u/M=;
        b=jt+nNiM0WVZqBPC68CzoqbdqKzKylKM1/e2+XNisi60sxkCxqdZnjVeLGdSSfOjuPQ
         qXGxtmVd9WQhu1uiL6rFH6gHoOAAohqmSe99eJBkJG+GEAxFGED+fyG7ZUjHcHK5/xKL
         DZUzexjRPN7DPsdPhSgfYmbIhYwbWVuZ+ocZeru4ROL6ru9nrX0/jTVpzv/u5FvqK756
         YRyMBls25VE6ryPyngKhK/CopZOKDvwB31ngIhXLETtH5H7RUFun1ERBfMItmw66qYpY
         ba7EmptHzJU2ZS0VOtFC0rcSzEw52J2GI1jlD3Deqmir+WdcQY0o0zc9VoCZkDsDPZge
         pvkQ==
X-Gm-Message-State: AOJu0YzSRlx2XAa4w7ZKp3cU0/Ty+mGsUaqed1rOD9aM8jlyi2W4j4IM
	0REHT53w00woeua3ZAm3hIbBJbjj37hcnyimvmd2ePrjqO8xA13zc9KilUF7qch9fHQYt8Vb/uu
	H4g6a6P2QuNBRKAGAPvHt2fY79SGvCm+UIigClCLjKdBf0+8FacPKxrtJcYw3ZLkGS7nTeC2Zhc
	uo6L31cMQczuttb4ZYJJQbJD6a4Vntn6c=
X-Google-Smtp-Source: AGHT+IEv5Jetv/aXeCICi/z2t2gF4WBR54hMEQMLieFPQ9MiysPpZWHtfVuZ/f9eWtdzqFWO5hblP1TNWA==
X-Received: from wmbbi26.prod.google.com ([2002:a05:600c:3d9a:b0:458:b8ca:551])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c81:b0:458:c002:6888
 with SMTP id 5b1f17b1804b1-458c0027a9cmr82212805e9.32.1754402178529; Tue, 05
 Aug 2025 06:56:18 -0700 (PDT)
Date: Tue,  5 Aug 2025 14:56:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805135617.831971-1-tabba@google.com>
Subject: [PATCH v1 0/4] KVM: arm64: Fixes to handling of restricted registers
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This patch series is mainly about fixing issues we've encountered in
pKVM (in downstream Android code), related to the handling of protected
VM access to restricted registers and injecting undefined exceptions
into a protected guest.

The last patch isn't pKVM specific, but a fix to the vgic-v2 code
encountered while fixing the issues in this series. The issue it fixes
was indirectly introduced into the code with hVHE.

Based on Linux 6.16.

Cheers,
/fuad

Fuad Tabba (4):
  KVM: arm64: Handle AIDR_EL1 and REVIDR_EL1 in host for protected VMs
  KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
  KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef
    exception
  arm64: vgic-v2: Fix guest endianness check in hVHE mode

 arch/arm64/include/asm/kvm_emulate.h     | 184 +++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h        |   3 -
 arch/arm64/kvm/hyp/nvhe/sys_regs.c       |   5 +
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |   2 +-
 arch/arm64/kvm/sys_regs.c                | 184 -----------------------
 5 files changed, 190 insertions(+), 188 deletions(-)


base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
-- 
2.50.1.565.gc32cd1483b-goog

