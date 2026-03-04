Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6213659EE
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 16:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641351; cv=none; b=GH2TMashM785QkfgV92SPmt6z0J6zWfBvyFx5FtrUWF3e69GJEEoyHrUXwEF61PQQ0OjyRBj5grfBvuwBqXtNnS71RFcMuStv5dHzlZrSfMlXt1qhiMpDBNyDIhnj3VlYDqD4qUSsmEPA0NYIT+U2KQjS5cWRNcsDhei57khJiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641351; c=relaxed/simple;
	bh=LYtSjN2RhqcKr3aNj5Cb08Kuh0Rl1UyF8cnoKSiyKPE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ujyRBldV+rDflSu7yNHfUKOw7if2+tbmespMSRnt0WeeO1huL9faEk88YMaRFBJbDmq8TEeUKjLQFM7viA+0uF7ezckcJy5OpVYgCSLqzrBfIsaFUSoFFPGdqmWqB5plExjbw3L/oklCSxcmvcLy069ak7TU4KuiMdAxeYPk5bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pWVMWqMe; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pWVMWqMe"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837907ec88so78652095e9.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Mar 2026 08:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772641346; x=1773246146; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hIPQsaRMySh/GQ9beSIags017EfvQfEs6fVmzxgycwo=;
        b=pWVMWqMeWuVSX0Jxt8FyxXW1P/sqxrHzYNHF+vCvr8ulyRWel/6lj3h0CJtZEGiNW0
         MpWSS4X/2PpQnUthN/mrfUpyCIygO7NhUQ3eGD8H0gyDcmCmBnEZpG1ZO8NoZoRm3Xr/
         A15+aIEhLVlsw7pmuXbiBN31boclOSK2xIT8zciHj6TZCwwKgMRsa39YyN/15yiexQUp
         SyXfDanP4m0cSEs1yrGbU+iKPVx+OoOdp1UVVEpOyYPSJQz7Zkg2KshIbCqq4imeYYvg
         XD33ED4dd4yguBPMLxt1MzfU1S9fH2NDVcETqkSgN1EQU0okA9zmBs5ad9x+IX9NwGQb
         zgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641346; x=1773246146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hIPQsaRMySh/GQ9beSIags017EfvQfEs6fVmzxgycwo=;
        b=SMXRlhV6CUmu88Is+sS87LSTqG1LPDsG5JRyKqlMDmEHTCxc1zqSQANy2b3/XYC5l2
         AzldKWLfx4an1VcNLdZk9XVyRZ6A743b88PrBJNYwuu0Tb7rAsQ+T1EjHoue6d6TQiFs
         38v0v0BCI+LnxERYnlaRR345GD7AI+mtccF0loT+UkrD1hsgp5tsD6OGhP5To1E/lJ4c
         95xuGFwtsDZIb4taqTRLCrGCVnxoHoQHSjZsQbkm9NFaxw2o24I+8CuG6XfHQRL2+kGN
         1YK4JHYsS9oLadMTO0KzVxgxQt/q0Bv8UF8Pm7KttazALtt7B6KTDgTUuUoyPkI7n9Dg
         GCZw==
X-Forwarded-Encrypted: i=1; AJvYcCX1w6q1zvIlOWV6+2UmNKMg9kOW3Hvn9OkmiX38D60oZpSAyfUUTFNtUw8BFzVW+wDusCXcxmw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0Y48OQI8UsTqR8NJk4P7D63TLc93R3mY3Ynl/v8encr1qTqlq
	crf806vJ4hOM0fYfvgNqTZysAOAWs94Pdkm9rVBpows0fhe4b/bghdqBIzG0e4pJ1Kp8HxiTX7u
	ICQ==
X-Received: from wrov11.prod.google.com ([2002:adf:edcb:0:b0:439:b0ed:2aee])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b8b:b0:46f:c55a:5a8d
 with SMTP id 5b1f17b1804b1-485198312a0mr43881475e9.4.1772641345799; Wed, 04
 Mar 2026 08:22:25 -0800 (PST)
Date: Wed,  4 Mar 2026 16:22:22 +0000
In-Reply-To: <20260304162222.836152-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260304162222.836152-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304162222.836152-3-tabba@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: Fix vma_shift staleness on nested hwpoison path
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, yangyicong@hisilicon.com, wangzhou1@hisilicon.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When user_mem_abort() handles a nested stage-2 fault, it truncates
vma_pagesize to respect the guest's mapping size. However, the local
variable vma_shift is never updated to match this new size.

If the underlying host page turns out to be hardware poisoned,
kvm_send_hwpoison_signal() is called with the original, larger
vma_shift instead of the actual mapping size. This signals incorrect
poison boundaries to userspace and breaks hugepage memory poison
containment for nested VMs.

Update vma_shift to match the truncated vma_pagesize when operating
on behalf of a nested hypervisor.

Fixes: fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page faults")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e1d6a4f591a9..b08240e0cab1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1751,6 +1751,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 		force_pte = (max_map_size == PAGE_SIZE);
 		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
+		vma_shift = force_pte ? PAGE_SHIFT : __ffs(vma_pagesize);
 	}
 
 	/*
-- 
2.53.0.473.g4a7958ca14-goog

