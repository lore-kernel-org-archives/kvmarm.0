Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C168550A6D
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 13:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951899; cv=none; b=fbVNqhtgbQGj2FaSssdzDDonOlL3XWeBx+1c92mUysT0z3suvdBQ2/Xj7qjqx+MvhFrtxf4EJpSjgVqoIUiGIpWgkTf3FjU5IZk9roYq28wTHz3Acgba938tMQD9VBQ7UYdLAwFTkCiRxUdbcGy9npxvtri9DK3UEa2J0zGIVTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951899; c=relaxed/simple;
	bh=gaLZllqPivKc/AOiKu1jj7N/j0Ex573Jp5GbGT8E3Z0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ui7GH4GilrXln/6Hwz/cLTJzaWnfcfg/BIsXNJ4QWRNZ15a4A7xxrSMm9/emecjwv2rTgSqjzkBhO8BKR9SnGz1p904j4rpX5TBE2xsRSlJXjfm7ji8IwzBYE0GeXva3Z5StP1nPs+LQEJHzG5rA63DDb55+NVKqGBzaXc50tEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GU8ntl/U; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GU8ntl/U"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc647f65573so20122458276.2
        for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 06:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715951897; x=1716556697; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hl+KMyEDlURK49WZiyYeI4jwx1i7R7dEFUI5TRFvOZQ=;
        b=GU8ntl/U4c9U/TGlrNpLzuV5TZOKvdtduOUHuo4HAYJe+IED12VVeNkwPEkyBPndBY
         4nRnUTqEZRfI6X/JZLFPWoidlSyMZTM+VkSZUZSYtpCm8vfE0V0SMcSuMS9K/AoZMFPC
         Oa0HL2l4WAlVtgEnfiNCI0dDHh2XA+3ErVzmZY8VQt9Nvzr5eyrtA/lXDKTn5oX7+hde
         EG+iQSl0x/SSBhzw83ARHQVKNChLf7UR/YTT4IDxXlNxLB/kb4oJiibUtIIBk+TMPZSJ
         Uxtbr2oDmtnTqenqd1Dygu1z0XmDIuXmfhpdUZ+21MGABC+cAHdq0Ed6S6PCA/SVX/Qu
         B8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715951897; x=1716556697;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hl+KMyEDlURK49WZiyYeI4jwx1i7R7dEFUI5TRFvOZQ=;
        b=bqk3TDTnke40sxIW+6eDXqAeKRD4cznn7OnPqus0ElunyZDzuF5g2pdld5n26E2S1K
         n0WdZfqxEVql8BkLegCFU2zNc7lZnJbLqd7NGSJyk07pMRUKIKzEmtoJtFRWVgUNs0uv
         f5x0ZJcQ2WCn59vHYiicKbQjNxO6FHK2uA1zEvTIDQtU/et0gxwrl+4+Lxe62QBtFump
         l9lTwxOGRLKf2ZRuj8FaYprQnGQg1IoJQo764yWhhLKt+7KYgErgfj7X5SEmM1gni1Xd
         hFJSRBxjCtvnCithheFgazxdQvVqhOGWILuYFsFqm9ngZ0VFDxibfp1W4FFBmW0i86dl
         J+EA==
X-Gm-Message-State: AOJu0YyjWVfVrgCwmqA8bdI8Z80nkP35JUxBN+7IT37pYJIJLHipOmVk
	7tbwSUJgQhnPUUNumsiZe+tP+RF2jwj0YgZjpbtWBcneUv6Xc0VnQYQHi49Ll1tE8qLxOZk2BH+
	3+Of3xeCngMibXa0yx6/t6Yx5wIrYCIz3hbfSy29WG/XmAXIQgiXlZx5cXdpQUPBhjf6ksh3uqF
	bqHqspDeEr8v5XpUAcZ4YjA02xNDk=
X-Google-Smtp-Source: AGHT+IH7UGXrVoY3CtAUX+9LQLBSIuLVl6OXjVWzHmtN6O/3XSCGVNKz67xzQbOzC/zBTcs9Zu4nw5um0A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:100f:b0:dee:5d43:a0f3 with SMTP id
 3f1490d57ef6-dee5d43c91fmr5109647276.6.1715951896719; Fri, 17 May 2024
 06:18:16 -0700 (PDT)
Date: Fri, 17 May 2024 14:18:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240517131814.719933-1-tabba@google.com>
Subject: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state in
 protected mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

With the KVM host data rework [1], handling of fpsimd and sve
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

This series is based on kvmarm-6.10-1 (kvmarm/next). It should
not have any effect on modes other than protected mode.

Tested on qemu, with the kernel sve stress tests.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20240322170945.3292593-1-maz@kernel.org/

Fuad Tabba (7):
  KVM: arm64: Reintroduce __sve_save_state
  KVM: arm64: Specialize deactivate fpsimd/sve traps on guest trap
  KVM: arm64: Specialize handling of host fpsimd state on trap
  KVM: arm64: Store the maximum sve vector length at hyp
  KVM: arm64: Allocate memory at hyp for host sve state in pKVM
  KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
  KVM: arm64: Consolidate initializing the host data's fpsimd_state/sve
    in pKVM

 arch/arm64/include/asm/kvm_host.h       | 11 +++-
 arch/arm64/include/asm/kvm_hyp.h        |  2 +
 arch/arm64/include/asm/kvm_pkvm.h       |  9 +++
 arch/arm64/include/uapi/asm/ptrace.h    | 14 +++++
 arch/arm64/kvm/arm.c                    | 75 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/fpsimd.S             |  6 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 31 +++++-----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 57 ++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 15 ++---
 arch/arm64/kvm/hyp/nvhe/setup.c         | 25 ++++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 40 +++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c         | 16 ++++++
 arch/arm64/kvm/reset.c                  |  2 +
 14 files changed, 271 insertions(+), 33 deletions(-)


base-commit: eaa46a28d59655aa89a8fb885affa6fc0de44376
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

