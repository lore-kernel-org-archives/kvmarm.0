Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB81818BBAE
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 07:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729237718; cv=none; b=rqjY9KxpZAQOAZYsyk1sRrOH7r7p7rw3lFO4QT5oR2cB0XY5LChKnNWToFf6teGHNlFEK30zhyd/9yHqlz+JwT5aEyRGW5EGN7gBDZGsRABjbSpmrPAEYbzMXfxiheil4tHrGjuthMIpbzrITmtJb+cjOg7V4lCbefAjeFNYPwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729237718; c=relaxed/simple;
	bh=vVNpTEomHQOlgIARJrPlS5P2vtw+OkG5he2T/4dz1cg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XYydqiRw2S3y2Em0zXmkXSNtiVz2VIjYdrZhVrxLWSfecSG+f52xbjxYTg6vY0/mbdztVpqLnnUQBD7ovbM7T4P+Qfb6l4cFXW8oecIfNZRxZIDtZTo/+0Ox/PlA2Ax2lii7q+Ov6yyxTe6pjEIbTQQBvk1Tvp67ZQIl8SWv4mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bnuaSF0M; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bnuaSF0M"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-37d4af408dcso971109f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 00:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729237715; x=1729842515; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FjvDpzXFiDkZ5hAbG1IWGAo4sN6buJcIqvPuOQc09tE=;
        b=bnuaSF0MW743wBw8xuvycATo05d98XqQFF5fkaJIT0NBbh4O3N0X31lINZnXKjKo6W
         Zo5US/siF6B1G3LSBGSQ+mCT3EC77om5/jWONw8YfMr8L17mrMiIemfshMwWn10MgnoR
         g/Y3Ne+4QtBXDmw+1oBtI7SCsesINLTXAmG+eCqTi5qXnDS2ifHqLHrSBBhUuh6U/WDj
         ec3Msi3smOw9vZDlFAWhYXXPZqArUfoW9wKPLfx2AR9h7zz6dx6ZoyIFu6Y6sAy/jm9U
         bPTEhiCSHFtfGTtLyHoDZwL4aBvLO36LetE57JIcT6IZ3ghRU76clmmCmigvgzL1hvkR
         QFeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729237715; x=1729842515;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FjvDpzXFiDkZ5hAbG1IWGAo4sN6buJcIqvPuOQc09tE=;
        b=XzhtjTWjXu2zyQfAlRXfJp6VflSo8069cEl+bmejxvjqHhAKn1/iMJ/pR5iljGf2TQ
         i07GycJhW/mGGmZEVHBggD5Se3v4fFkkPd/3vHnmPW/xDbIAH2MkVi745sm6ZRSLVJ7+
         2I7LMs5isL4/yrFT/j05MmjNKq6+1iDriRun39X2GWW7Jt/12MH9xZTQ9DKIaF64aEnE
         zOFyL+P4VhYKRzmyH+cpcE/4BBzb2Uo+7OkXNBG0geZJcL+28PL2KcThzR3uPc1ag4nd
         b7RZbV8XPda4xsLZXlWuxicD/0ALHlAdSGFClLmR9KfslWliFh0T8Mh64EiVt12U9HiK
         Y6xw==
X-Gm-Message-State: AOJu0YzTLeUMwynFQNNi7nuDCSos+9kS/wcJKANvsLwGFvhYMuOJcVUf
	ujv9f8OCWeg8Pk7hACnoOleGnz+HjZL2HWnMoL/lJ2Ny6SP1RbasORL3swYo56shAM3U333Lcdl
	baFtkdYEJPDQbhLZdOB9740VU34JbRadLEYbJp7SWL/veuNbxtwLatuS1QpCwyE90S1VorVrYwp
	tni1n75uIhcqQszIi1GS9ebxwCODE=
X-Google-Smtp-Source: AGHT+IHrKRk/aszWWe2UoNU+EtLPjh7/O0/k79qozecJA4gfjbiQP62GO/vgk+OV4T7ca8u+tJWsmklZOw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:401e:b0:37d:5282:133e with SMTP id
 ffacd0b85a97d-37eb4898151mr833f8f.10.1729237715044; Fri, 18 Oct 2024 00:48:35
 -0700 (PDT)
Date: Fri, 18 Oct 2024 08:48:28 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241018074833.2563674-1-tabba@google.com>
Subject: [PATCH v2 0/4] KVM: arm64: Fix initialization of trap register values
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The patch that dropped PAuth instruction/key traps [1] did not
apply to non-protected VMs in protected mode, since as noted [2],
the hypervisor is supposed to handle trap register values in
pKVM. However, in pKVM upstream code the hypervisor does not set
all necessary trap register values in protected mode, and running
non-protected VMs with PAuth enabled in pKVM has been broken
since then [1].

This patch series lets the hypervisor initialize the values of
trap registers for both non-protected and protected VMs,
including setting PAuth traps depending on whether PAuth is
available in the system and configured for the target VCPU.

Based on Linux 6.12-rc3 (8e929cb546ee).

Changes from V1 [3]:
- Clarify rational for allowing flushing of HCR_EL2 TWI and TWE
bits in commit msg (Oliver)

Cheers,
/fuad

[1] Commit 814ad8f96e92 ("KVM: arm64: Drop trapping of PAuth instructions/keys")
[2] Commit 7e814a20f6da ("KVM: arm64: Tidying up PAuth code in KVM")
[3] https://lore.kernel.org/all/20241014102413.4092725-1-tabba@google.com/

Fuad Tabba (4):
  KVM: arm64: Move pkvm_vcpu_init_traps() to init_pkvm_hyp_vcpu()
  KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
  KVM: arm64: Initialize the hypervisor's VM state at EL2
  KVM: arm64: Initialize trap register values in hyp in pKVM

 arch/arm64/include/asm/kvm_asm.h              |   1 -
 arch/arm64/include/asm/kvm_emulate.h          |   4 +
 arch/arm64/kvm/arm.c                          |   8 --
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  12 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 116 +++++++++++++++++-
 arch/arm64/kvm/reset.c                        |   5 -
 7 files changed, 122 insertions(+), 26 deletions(-)


base-commit: 8e929cb546ee42c9a61d24fae60605e9e3192354
-- 
2.47.0.rc1.288.g06298d1525-goog

