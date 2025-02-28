Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E584C25BAC0
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 10:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740738348; cv=none; b=RLqE6LOI+L8uf5by1N0Q36pqyri9VH9ww96zuh8w9ZdTiKvs3Dn6ZewQ6tWwJF+OihSreOqDeEv1KVxgjWxqSREKGoDOHBBFvbTH84aD98X9t+yspsCx1UD7STnvcSQTWu0GPiEaE4FC7OJbTBJPicMBoS4cg+oc238sDYhmWfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740738348; c=relaxed/simple;
	bh=BWZCnyWZRcFFgGDc2fMhBTLM/sH8dFOBJJTpn5YiH3M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=N2BVWhZOrOX9kg/vsD0ZNdQkLUbC/O3Y7MHZCPmBVoBroUspcmM9dFXxDzC8EOHsrpL1Z8OSHCmjSOeHFKeHr2fFxD0wZ10azw5vKTGn3gFrsQvG4ywgRkNvn+fDLfDCq47/PAUzhzEFq8I0CzdQH4BozQgJYlTwiQoCTrZeX+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QLkDDINP; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QLkDDINP"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4394c489babso10872955e9.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 02:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740738344; x=1741343144; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yZiixOEWYaq9wXDNP/eyMuN3kYA78c0bj/N2a/BCkL0=;
        b=QLkDDINPgZsLe4J9j9RT1Cu9LjunmjwN8awDd4OVoxtbJYkUSvekYtMYjczHZWfBIT
         u2Rw8qTmAqEpfgvu0Hb19NYfuZGJDsFbfH5XZFID7fOvxVlYVayyxIARVlIZ1H0OTNql
         DNsc580nVJWBhi2rc3Qq8YRbwnusYOFsnpQGBogTwbYi44LMzL2/I3CbaQoaDxIt+vno
         LBsFd0L5D8peOBAjUKWXEcki0WDrcPsPa79zNn9qNfRiuT4mcg1E4zMp5iViro/NO3Ix
         ph25thROl1iq1bGdpaCXZU3x8KLbMT9D6tIP0AsHf/1GPf+0hNTyUP0HUeFldMo3L+3t
         AuGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740738344; x=1741343144;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yZiixOEWYaq9wXDNP/eyMuN3kYA78c0bj/N2a/BCkL0=;
        b=ZKWnoPPRSoZt/u6M09H3MrEuWJMyu3UhtQKvMfgWZt6Gc67TfpLz5VptY7FtA02SP4
         FlAY3mx9/g+58lJnZZqqOgSpRRbDiOYaAt31VCt+iSX0WUPn3EyOSAHloT7DwVOfeYwz
         tLd/Wvy4JCXXg6z63A5+yQ8d86q9W1/Ig9Ub9ey3AaZ2fgfSktTAUeTTX+5Pl6VGBi7r
         nhxkDmwTjgc85XLeJS0cdwXG9cHu7mawNQveIWH/YwoA41rvGZFtrhxpjwJ543c5nRAG
         S/VcVkeLARnzgQy8hJL80gLc1aFx+JXlscKx0b1Ke2opRdvvQqf0Vzwt4nHRTgIBr8DB
         CARA==
X-Forwarded-Encrypted: i=1; AJvYcCWhUbhFIJszZXq87YZmoIVuBYKLaDrrI7vR2kOzO/JqXxPX/OAzOtoqIaUxFwdCyqMf8wZnN0c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhXQJy7Wi6Q/X6ysIle+883cQijBw8hgYOt9cGysItuj2Qq6YX
	KYiH9/02z6IxR/np3pvnpgzI74jA1vCeZ4Vr53wqav6UHqJR7Fisj/JyEARTJXnRkYSI+UB41Rr
	OQW95Ilarriz7LrMqQQ==
X-Google-Smtp-Source: AGHT+IHep39Sd5eGh94BVx9flL1lcXtt9eAIYrt+u2ImlSXt8vPoiGgYIDF5HPduTl3nT7mvrQjfLoUwEOlBu9qB
X-Received: from wmbec10.prod.google.com ([2002:a05:600c:610a:b0:439:804a:4a89])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1551:b0:439:9f12:1809 with SMTP id 5b1f17b1804b1-43ba6766c16mr20538485e9.20.1740738344390;
 Fri, 28 Feb 2025 02:25:44 -0800 (PST)
Date: Fri, 28 Feb 2025 10:25:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228102530.1229089-1-vdonnefort@google.com>
Subject: [PATCH 0/9] Stage-2 huge mappings for pKVM np-guests
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi all,

This series adds support for stage-2 huge mappings (PMD_SIZE) to pKVM
np-guests, that is installing PMD-level mappings in the stage-2,
whenever the stage-1 is backed by either Hugetlbfs or THPs.

The last patch of that series is an optimization for CMOs using a shared
PMD_SIZE fixmap.

--
Vincent

Quentin Perret (2):
  KVM: arm64: Convert pkvm_mappings to interval tree
  KVM: arm64: Add a range to pkvm_mappings

Vincent Donnefort (7):
  KVM: arm64: Handle huge mappings for np-guest CMOs
  KVM: arm64: Add a range to __pkvm_host_share_guest()
  KVM: arm64: Add a range to __pkvm_host_unshare_guest()
  KVM: arm64: Add a range to __pkvm_host_wrprotect_guest()
  KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
  KVM: arm64: Stage-2 huge mappings for np-guests
  KVM: arm64: np-guest CMOs with PMD_SIZE fixmap

 arch/arm64/include/asm/kvm_pgtable.h          |   7 +-
 arch/arm64/include/asm/kvm_pkvm.h             |   2 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   8 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  16 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 218 +++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  86 ++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   6 -
 arch/arm64/kvm/mmu.c                          |   5 +-
 arch/arm64/kvm/pkvm.c                         | 129 +++++------
 11 files changed, 326 insertions(+), 157 deletions(-)


base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
-- 
2.48.1.711.g2feabab25a-goog

