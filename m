Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EEC77118
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417736; cv=none; b=tcSHKobmp0vzw7snYDU9C9PxT38PBO3uZ2o2xiU3wr+fpM6Wltsl7tbUPNVeZ6hMa1GVftP4mO+qIcv6r8OT3gBIjY5TQSFe7D/TWoJIjMzpOo2zRIvOzTnIVHxuz4h/CBTJTjwIT6uK6u79QC2Abuzk+brm8Um2lcDzloa4QvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417736; c=relaxed/simple;
	bh=P6bgE4k0COAChJPa/ZtNl+UdNe9n/UdVar2blPNgjPI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BClTP5oVuYJ00IePqnN0sujbOtOvy19s1ij1gtd8kUEiagKWgXRQ6PhDJgV5It52A5gmcAugvlqAQL1KvLKiW0rIB7uh0fN3cNZLfq/9OmvtdSY7ZxpnmRzzJ5DibFUA7l+pofaYCWCCq9TzwCX3piX1TBgAGE28Ecv0ZQnN4I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4S41GDFM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4S41GDFM"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df771b5e942so7277784276.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417734; x=1718022534; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QYoEm1/ej6y3TpMd/I4kFH/bMGwmmKwE5sXoV7/XmYw=;
        b=4S41GDFM4FiHl2tGZM9+u9er5Ob/+edISviK3sNjae6xwdHkw1GRbQ4hB13Ni4Z+/9
         i7TxR9zI8K127N1J5Cb91nLitxx6ZAWdHWfGU94DGUgkrUsdpqclKrklSlg8l1l7KWv4
         y0RUSe0N7toxbw1pO82e68KCZ7LQLxQXGQhBROH5zG3Xv3jxU07OhQnbuQqTez6UK6D3
         UfaMh9ILRzX6/y9ah4sKhuGSB6OzRJtPq+X6QrEpEqMT4zdnzZYE7HAF59xOdbFB3kC5
         oUoddl42kQygJUnowBW4LF6DM7Q4vyuZDaph0340YNXqPjaAUbuxzAUj27DCrXKc1m5V
         aqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417734; x=1718022534;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QYoEm1/ej6y3TpMd/I4kFH/bMGwmmKwE5sXoV7/XmYw=;
        b=G2Q1DUXRNCPKE8QStSphDXRSK//ur9EPmViNDmHR0TKKyXxLp0oeFyvbCoLrBDXDW/
         sRGtyW1WmgUdORiIzXWjQDzDRdnQfVGphzdbv+Wq8kfo9hJ+G1ZwlHbL/61EBORuI6NO
         sG0WGC85rTJBbAmHM24vhNEjGM62Ef7i3KNWqW6GEJ771LUDURhml4I/P71Mg2Pn6Dj+
         MOgZADtOFluiwCmL+RfJULjSuyeSMHSE4nyJkhgeCK0N4CgxkV90YsWHSKcXL0K2cv/9
         keT97uSOUZqkrUkBPA2RIVrHt424rVRNneWl1Ekb9Qy7Oxc5wGOviU5XK7D40+npCk1D
         PB+A==
X-Gm-Message-State: AOJu0YzyQ77nqAhsPByvS7vruU0vgRSsxqTdbUJVu2rolMZtaaWFVIdL
	GaCtitj6kWdBy6ySjsJYmN+sKEeFqU3klktvPywjgT8HAyl8GznzquFeU6WyyJfxe2uqfNqy3aU
	2xXLeWPhuH3TxbwjOnrQcfLuRkzGP4U5n9uMvqQtn5Tp/gJy9+dVWMBzfFG7M6SrUe7G5kIPh/1
	hSlLo+QLYJxKgILG9gr99lmaCDzkA=
X-Google-Smtp-Source: AGHT+IFNEEknH9oJEDjs5Wc2BPagG/l5JTrrOXMSAOHeix3ryWiIpGm0Y/0Qr754I8/rGgdGUMJ3z+YTwQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1542:b0:dd9:2a64:e98a with SMTP id
 3f1490d57ef6-dfa73d8d92emr629446276.9.1717417734046; Mon, 03 Jun 2024
 05:28:54 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:42 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-1-tabba@google.com>
Subject: [PATCH v4 0/9] KVM: arm64: Fix handling of host fpsimd/sve state in
 protected mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Changes since v3 [1]:
- Rebased on Linux 6.10-rc2 (c3f38fa61af7)
- Dropped v3 patches 8--11 (Oliver)
- Removed unnecessary isb()s (Oliver)
- Formatting/comments (Mark)
- Fix __sve_save_state()/__sve_restore_state() prototypes (Mark)
- Save/restore ffr with the sve state
- Added a patch that checks at hyp that SME features aren't
enabled on guest entry, to ensure it's not in streaming mode

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

This series is based on Linux 6.10-rc2 (c3f38fa61af7).

Tested on qemu, with the kernel sve stress tests.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20240528125914.277057-1-tabba@google.com/
[2] https://lore.kernel.org/all/20240322170945.3292593-1-maz@kernel.org/

Fuad Tabba (9):
  KVM: arm64: Reintroduce __sve_save_state
  KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state
  KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
  KVM: arm64: Specialize handling of host fpsimd state on trap
  KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM
  KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
  KVM: arm64: Consolidate initializing the host data's fpsimd_state/sve
    in pKVM
  KVM: arm64: Refactor CPACR trap bit setting/clearing to use ELx format
  KVM: arm64: Ensure that SME controls are disabled in protected mode

 arch/arm64/include/asm/el2_setup.h      |  6 +-
 arch/arm64/include/asm/kvm_arm.h        |  6 ++
 arch/arm64/include/asm/kvm_emulate.h    | 71 +++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h       | 25 +++++++-
 arch/arm64/include/asm/kvm_hyp.h        |  4 +-
 arch/arm64/include/asm/kvm_pkvm.h       |  9 +++
 arch/arm64/kvm/arm.c                    | 76 ++++++++++++++++++++++
 arch/arm64/kvm/fpsimd.c                 | 11 +++-
 arch/arm64/kvm/hyp/fpsimd.S             |  6 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 36 ++++++-----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 84 ++++++++++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 17 ++---
 arch/arm64/kvm/hyp/nvhe/setup.c         | 25 +++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 24 ++++++-
 arch/arm64/kvm/hyp/vhe/switch.c         | 12 ++--
 arch/arm64/kvm/reset.c                  |  3 +
 17 files changed, 358 insertions(+), 58 deletions(-)


base-commit: c3f38fa61af77b49866b006939479069cd451173
-- 
2.45.1.288.g0e0cd299f1-goog

