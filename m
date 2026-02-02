Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9D32BF00B
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 08:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022645; cv=none; b=Y4QDlR7MDUHZSMeZHeacMoGn8Yn+F1rDqO2yO8wPyoee6BReNdlSdnoXphwx8njto7h4SYW1PCftE573NVmS6JkAarL4wmHigPp2NbVvFojv2lLj9tCBr3/5Mi7xhA4wjxY2t/EIAk3bVerKnX2TWx9invQ8Vj848CkXSGFvYpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022645; c=relaxed/simple;
	bh=NF1DOY24PyUCApSu4MuWe+e4itYOoRIfIbv3m6JMlGY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WUdTxScxvGbSUTHcK8dIJuSRFyEyFXr4mpBls6VSD9m2ji6u886vH6RLJ+9cO+RwGb4pLKGaRY8EMeaMVMZsvcil3z3Kjm0buML8Mmc6RMW42zfglI+M0O86oSPlX/AocTFmuzo55GaluFCPtHP8Hm1I1m+5mKwnZhrxDSkJpAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0K199W7a; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0K199W7a"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4806cd00e02so21939905e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Feb 2026 00:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022642; x=1770627442; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kGb5tEG1VOIoITicmnlT7KV6MD9I7+LZxxMBQmSh2pc=;
        b=0K199W7a0+Rr2auWx6KJcIBb4i0DzGhh95AhEkFFqmV2ayH7xisAfB9z6204MWtvHc
         dw8QhP/WakiFJUzxI/dICG8W8kvg4VsItBAD9cGzPJIjIu32nFOXUQS++rzGHdRWrGMK
         HA0AHhagV5XLmuydxrWskRcpp4DqSbZxUdxY4xKo/t1PkKAm9MJez77GuJ7m/2dIxQWh
         l1ZK/k8WTR3G5ANBECAxIOY7fktnbwhBeHK0H0Gxjef7YIF+GZrOdwJuYSj5w3SCZtQC
         pPe8L/Kyzp3TL5BLdbi9oKQKk59rz6ovhKb9hltAxW+4TJIS+AKRf0CxLhORSyQaMKEF
         gDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022642; x=1770627442;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kGb5tEG1VOIoITicmnlT7KV6MD9I7+LZxxMBQmSh2pc=;
        b=oqkdPH0EwBb2lrdBufzf1VM0YD4YyCVEleM1JmGpIsiWAOv/8aQkB6//U9JotIy8bu
         +IK63U4j8gG3X6x1v3XieVdtAk3DjcmZ+eN/Q9bRO870Q++PkV2+7eT20DfrqWEzijJa
         2a/D8/MkX8CDNVPSyd5h7DQ3Aojysl5F433FRv5G2adMe6d67c8zb9X2ix5KdYH6uUl3
         IOMBntRpEimluUKQYHv5Jp6mcYVY6vkLyaS1hMguUdrl8ur95V5SrZVcLgfv+ERYpxlj
         xELKPFmxyaA5DI3yRiTBeUWUVMK4G0DXlWtZyZRxp8qQK5+d6A8W4RIp6Fb8wxdrcpBZ
         rfUA==
X-Forwarded-Encrypted: i=1; AJvYcCWm9J/EjR2F2rmH/WydeJALyUOuE9e42ZMOe+6Z+jFTM+UK/BPnjUHCyvBi81kAg/EJfWM/3nM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIhbboeavgfOCpkfwSuN9dEEK8g2LU2dmcdOyGUd3/Ifn8tPr6
	jMgqUqpTHhyARXJwEf7q6f+tnX4KLv5LVfrH0F4u20sNADihVpXNldPzDsN/y++nn17FS05rrcT
	uEg==
X-Received: from wmil16.prod.google.com ([2002:a7b:c450:0:b0:480:694a:dd63])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:348b:b0:47e:e779:36d
 with SMTP id 5b1f17b1804b1-482db4d826dmr117690445e9.23.1770022642339; Mon, 02
 Feb 2026 00:57:22 -0800 (PST)
Date: Mon,  2 Feb 2026 08:57:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202085721.3954942-1-tabba@google.com>
Subject: [PATCH v1 0/3] KVM: arm64: Standardize debugfs iterators
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This series refactors the debugfs implementations for `idregs` and
`vgic-state` to use standard `seq_file` iterator patterns.

The existing implementations relied on storing iterator state within
global VM structures (`kvm_arch` and `vgic_dist`). This approach
prevented concurrent reads of the debugfs files (returning -EBUSY) and
created improper dependencies between transient file operations and
long-lived VM state.

The `vgic-debug` implementation relied on an XArray marking mechanism
to snapshot LPIs during iteration. This modified global state during
read operations and could lead to reference counting leaks in certain
edge cases.

Note that `vgic-its-debug` (for ITS tables) also uses a custom iterator
pattern, but it is not addressed in this series. Unlike `vgic-state`,
the ITS debug interface iterates over linked lists (`device_list` and
`itt_head`) which require holding the `its_lock` for safety. Converting
it to a lockless iterator would require a more invasive refactoring of
the ITS data structures (e.g., to RCU or XArray), which is outside the
scope of this cleanup.

Based on Linux 6.19-rc7.

Cheers,
/fuad

Fuad Tabba (3):
  KVM: arm64: Use standard seq_file iterator for idregs debugfs
  KVM: arm64: Reimplement vgic-debug XArray iteration
  KVM: arm64: Use standard seq_file iterator for vgic-debug debugfs

 arch/arm64/include/asm/kvm_host.h |   3 -
 arch/arm64/kvm/sys_regs.c         |  50 +++-----------
 arch/arm64/kvm/vgic/vgic-debug.c  | 108 +++++++++---------------------
 include/kvm/arm_vgic.h            |   4 --
 4 files changed, 40 insertions(+), 125 deletions(-)


base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
-- 
2.53.0.rc1.225.gd81095ad13-goog

