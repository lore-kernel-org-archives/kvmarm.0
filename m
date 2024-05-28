Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB58E16D9D8
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901160; cv=none; b=uONSA7yxikzbgnds4krm6S18r1gHZ91y22UI/eC9cMrqATt9+MjDmsHtVOrMpqQAo+MzdWEZx5UR3L/QOk2TWIHpvQZKqH8BU1TPqFfTjBo+ZN/+7XoTGIlQzYmOZMSgaktU/h9pwRfZQR9BlN121EdNCOjaXFburn0q2I7wkSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901160; c=relaxed/simple;
	bh=esOXHOnrFh7Yyb166h+tO++Qtyy7VZ51THLP0KkkbgI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=U3IRTkqnh5Leo/xH8v54H3RCx79TGj7DxVotJxdMnMEYln6/+DlMczXm0aoTxg/h03cDCsw278qMIFvICff2mnEASHHbr7efADO5YvqfLvodgC1RZ8amkmJ2VIhStiqQDNsWJNCg0RluJB+luLa4B73fs9rhF8xhdKIVWmXkgJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oNLUgj+I; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oNLUgj+I"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-42108822a8eso17420025e9.0
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901157; x=1717505957; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m3nkVC0BZfe7eSiu3kY+AhUkzuWFPIanJCfYHltbpNY=;
        b=oNLUgj+IO/BFKacVMvBLijCDsG5l2LS/a4QXlEcKKpjPG3Dcc/+7qN6ylH5bgfKaOn
         mFJam9y6dUFgbi66YCObCr9EYLT4k3yd85sJ7bnrhQ1srBoQRs7LPrL7Hi6+hHcADf8B
         NLRVgw8VBQBK09K78KQgDPAXcoK+vtoGRbTt/HSMZfLJZEvJ7dkAsh6L+7OEAFAv096z
         idJGPf8iIdOeT+Z5GgaZVBVrmEyiMME+VnXm7MbyAe/XTi3yMXmxZ5tijdv9QP+in4eT
         nCJBBy9ijojv5E+7xuTBp0chFCTvdF6Oe0bh5iDCtwEfm7NHXIolxOpVmbUmW6JQ4IzP
         kDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901157; x=1717505957;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m3nkVC0BZfe7eSiu3kY+AhUkzuWFPIanJCfYHltbpNY=;
        b=OF+IvCnj6nzrXv++6oZvQsKRsMD6RiPajrgr7QDf9bif/9sVK0Ehbo5TgQbXhkJ8Yn
         WmqZEAhLP1fj38xzp/8rO1fVWEa7HY96xFc8U3IMZReKmo2Hg5Tt+mAhHg/dqJPX2V+z
         UCVnwUVz0Sxle+vBCjTmhJ6jbGFqHKWox3nRfPAmB0J/SvkESueK2Xhdxb9jC+BehOWB
         EFTOCAX73pmE2CeKYjLY0GPV2bcVS/YycKhiA0o+M8TuFOKY3RhF5ND7yRzY6rKTaC5f
         4BfdMg0WR6wsyoqOthAecxLRzjBjZI0QXOW+8V2DLCGr7KtyO+1ysTLzpeEmUBPxFh5z
         /4qw==
X-Gm-Message-State: AOJu0YzjxEqYuZLohjd8ZMcy3sOWeCAgMuhlHoM71VzL/i/5diGKLiVW
	P8ud2ZBJ6niz1eU/UIg8/RxzDD5HCAq/VPhLi9u+14GY/HHyz35nX7odqwy871DSC0X/jBRXWk0
	GCMBj/lVMMp4b479405yx/Ht+UIh/rnLReNRcNpcCd3hCg+XDWIfo8eF0egngY2uCOw0SXj1RJp
	jlqDf2ZgpC2nyRJAoEKV0OaLrATB0=
X-Google-Smtp-Source: AGHT+IE/n1cPtZtexEi21BLaoq7D28W+Fb3PkBwUY3SJW2LZtL6tmxUkCNGSKyvg7ipDjbFvGKpx9hclxQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4704:b0:41f:41fc:318b with SMTP id
 5b1f17b1804b1-42108205095mr2539805e9.4.1716901157057; Tue, 28 May 2024
 05:59:17 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:03 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-1-tabba@google.com>
Subject: [PATCH v3 00/11] KVM: arm64: Fix handling of host fpsimd/sve state in
 protected mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Changes since v2 [1]
- Rebased on Linux 6.10-rc1 (1613e604df0c)
- Apply suggestions/fixes suggested for V2 (Marc)
- Add an isb() to __hyp_sve_restore_guest()
- Squash patch that introduces kvm_host_sve_max_vl with following
  patch, since it's used there
- Some refactoring and tidying up
- Introduce and use sve_cond_update_zcr_vq_isb(), which only does
  an isb() if ZCR is updated (RFC, next to last patch)
- Remove sve_cond_update_zcr_vq_*, since it's not likely to help
  much (RFC, last patch)

With the KVM host data rework [2], handling of fpsimd and sve
state in protected mode is done at hyp. For protected VMs, we
don't want to leak any guest state to the host, including whether
a guest has used fpsimd/sve.

To complete the work started with the host data rework, in
regards to protected mode, ensure that the host's fpsimd context
and its sve context are restored on guest exit, since the rework
has hidden the fpsimd/sve state from the host.

This patch series eagerly restores the host fpsimd/sve state on
guest exit when running in protected mode, which happens only if
the guest has used fpsimd/sve. This means that the saving of the
state is lazy, similar to the behavior of KVM in other modes, but
the restoration of the host state is eager.

The last two patches are not essential to this patch series, and
the last one undoes the next-to-last. Please consider only one
(or neither) of these two patches for inclusion.

This series is based on Linux 6.10-rc1 (1613e604df0c).

Tested on qemu, with the kernel sve stress tests.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20240521163720.3812851-1-tabba@google.com/
[2] https://lore.kernel.org/all/20240322170945.3292593-1-maz@kernel.org/

Fuad Tabba (11):
  KVM: arm64: Reintroduce __sve_save_state
  KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
  KVM: arm64: Specialize handling of host fpsimd state on trap
  KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM
  KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
  KVM: arm64: Consolidate initializing the host data's fpsimd_state/sve
    in pKVM
  KVM: arm64: Refactor CPACR trap bit setting/clearing to use ELx format
  KVM: arm64: Add an isb before restoring guest sve state
  KVM: arm64: Do not use sve_cond_update_zcr updating with
    ZCR_ELx_LEN_MASK
  KVM: arm64: Do not perform an isb() if ZCR_EL2 isn't updated
  KVM: arm64: Drop sve_cond_update_zcr_vq_*

 arch/arm64/include/asm/el2_setup.h      |  6 +-
 arch/arm64/include/asm/fpsimd.h         | 11 ----
 arch/arm64/include/asm/kvm_arm.h        |  6 ++
 arch/arm64/include/asm/kvm_emulate.h    | 71 +++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h       | 25 +++++++-
 arch/arm64/include/asm/kvm_hyp.h        |  2 +
 arch/arm64/include/asm/kvm_pkvm.h       |  9 +++
 arch/arm64/kvm/arm.c                    | 76 +++++++++++++++++++++++++
 arch/arm64/kvm/fpsimd.c                 |  8 +--
 arch/arm64/kvm/hyp/fpsimd.S             |  6 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 36 ++++++------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 75 +++++++++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 17 ++----
 arch/arm64/kvm/hyp/nvhe/setup.c         | 25 +++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 24 +++++++-
 arch/arm64/kvm/hyp/vhe/switch.c         | 12 ++--
 arch/arm64/kvm/reset.c                  |  3 +
 18 files changed, 342 insertions(+), 71 deletions(-)


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.1.288.g0e0cd299f1-goog

