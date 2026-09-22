Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8585326C6
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 10:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072198; cv=none; b=sL+yimRd26drWoMs3U4mouMHHRmssJPsfC3fnr2+c1bPRXV2F6EJusbvodfmkiCmex0hxoQ7Qn13/cRfFDLmO2epxYXgj2Tfg4Kcctu2An5CBqb1WLwhFYnwgUGqjKKWXWnV7BTTZnoVrdE9rkX4A8obWof9++3RrhIs8plC5oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072198; c=relaxed/simple;
	bh=GgpGc0XIjAacsdtFYETgkKESfJhnEXgGXDU5RsrhnBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q7X80J+gNebBfwDBbUJs5U8Xes27kf/pQEC8ajqgGwkkgv/N763jAJfvUARWoFHnWyoQBk1BFWIc8FPthBTrLqaBPIaVFMrdB2xX5SXw+TYIElkkJpwsL9M/ysbGq33fE9xMI4EyLcRRBhF+u7etXLzQshmBeYoPbQBN1xS0/yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fn1x4I1u; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fn1x4I1u"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469d249c4so3503342b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 03:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790072192; x=1790676992; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4BNeBv2Xk9F1CB1cgKUVArUM1oX+ebQd47lsZ5uxxag=;
        b=fn1x4I1u3dlgQvS+6utxzTg2+D3Db2qlNv7cGs2eylh7TBFVXLb38o+iKMCHGt1CtS
         YMDF2rFteTgYIAXqBbztqtzfhBxuL+1qEhntGh7ugy1reorCX9VMhnb4+mZWfG1XFaYJ
         GBp3+ZwMSR8JgzLMLjlSy9hAOVdXvSWoaJbtluYTJ7D3Z/BLFlfVth4pVjby7i8Y5S5v
         pssnhY7lHquXcLJqKP7rq+Hlw3/CcAOG9FUcOv6QQJ+JTrtm39OVzvXs23AzqjvFVyeW
         KMnDxjEni5GeCeD29p0+cLA3IfIlDTrIbbgwyYSYsTI0FnogMX07QQSbfyTvgo4w59Sc
         Qezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790072192; x=1790676992;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4BNeBv2Xk9F1CB1cgKUVArUM1oX+ebQd47lsZ5uxxag=;
        b=dlcmfynQi/c3Moh3Cj9Ug4MrQX2R7QQ9/otsgIpQ/R2TrPGiSppXKuXfT5zal709t7
         wD6n/fND1Tb7JsO6P1gc6vwa7T4OnvW0yrIB7dLDgGOlzRuYcriK6DAWuV0xd/A38Hi2
         MPaTVJe8gwj2hStem1xx37xzBI/srZ4CBtbSjU1MvwMrKynNvOPq+bTHrNvgs4ZVochV
         nlBoHGxOj1d82azGn7NMJ0UOgIVeRkTD1nzqwC7QYLGcVJVCpXuMiif7ya+/0Nob5OPQ
         txSj8wNaVGsx6U86TfrM3c9Z6KpZv6mMkhk4HdWpbZxW1SxW8ISjnU7Sd/Y9QcmfXFZB
         ugPg==
X-Forwarded-Encrypted: i=1; AKwUvBzTuiitk4/uHoGHoYubFGbiV/6u3wNzqlCRLynUpySz48N3NJxeeCRHfZWhTHR2qx+lV3FL5Gc=@lists.linux.dev
X-Gm-Message-State: AFuF++npQJBAAvZjO3WJHbPEa/8FqCUABFjxoV7AYfxd3aT+jPSwuAuv
	6vbiMzea0qxYnZAl7jg9R1wL2u8WHePL0Aaxsu/oAmFGK/ztzhcNLxpF
X-Gm-Gg: AYBFou3NFtMYh62vDkhgIXCOkI2FFcuCMPpKUG3o2wFVFGvkwKje3/p4/dZhJpAnrx9
	K2w3lrl7stcVpL21rakeMCXUjbIYE+YrVg5hRZWFZv0Vh8k2MMjkHQzIVcrpF3N92bzhNqTy/9b
	fCB7mQq3AKNhwCMDXyA6ifBjGKuj9KdIwJEwwaujkwu9olbzz47YxjrzjpIjciuNzdvnQIexwnO
	YKkvVr8/eCyG3ORyTmM4O+Paa/QlZ50vG1phL+g8wosfkTxrRYuxUeD+/UjavhXQCXaLh6VQlxv
	e5r1mpSNeGYgATV7Qr1zr/PocRlNPFx/NRb0v6SQt1VV31vii/Wvvptj5TPTDsKrVpwRZlrRjbt
	1YsMoRTxnzRfCFD4fONeuv92OplgK8ZEzrpof6t1o2AFb0ZCFS3BY3xl0SDUcq+P2I+dj3eQejU
	SFpH+5Tk9LRnv4ODiVOnso87PnQHlGBD81IuhvLD4LXA2SPnviqYolOPdkeN2oRbX5rBVRGYfvg
	9RbxPErKMqqV1mhVIwOYmKrdW9z5lxRgEsgBw==
X-Received: by 2002:a05:6a20:c91a:b0:3cc:faf3:331a with SMTP id adf61e73a8af0-3ddec5fa40fmr927062637.10.1790072192035;
        Tue, 22 Sep 2026 03:16:32 -0700 (PDT)
Received: from localhost.localdomain ([2409:8a1e:2e81:7320:4d0:75ae:9920:3973])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc756a30002sm679379a12.13.2026.09.22.03.16.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 22 Sep 2026 03:16:31 -0700 (PDT)
From: Yuchao Zhang <ndaugoing@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: Re: [PATCH v3 0/1] KVM: arm64: vgic: Drop last_lr_irq and serialize overflow EOI replay
Date: Tue, 22 Sep 2026 18:16:23 +0800
Message-ID: <20260922101623.39468-1-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <87bj9r4h9z.wl-maz@kernel.org>
References: <87bj9r4h9z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Marc,

Thank you for the candid feedback and for cutting right to the heart of
the problem with the 3-patch series on your branch.

Your series is vastly simpler and elegant:
1. Only caching last_lr_irq when LRs are genuinely full eliminates the
   overhead for non-overflow exits.
2. Holding a proper reference on last_lr_irq and releasing it under
   ap_list_lock in vgic_prune_ap_list() cleanly addresses the lifetime
   hazard without introducing lock-order inversions during folding.
3. Halting the VM (kvm_arm_halt_guest) on remote GICR_CTLR.EnableLPIs=0
   completely avoids cross-vCPU concurrency for an event that almost
   never happens in practice.

As requested, I wrote a KVM arm64 selftest for this scenario:
tools/testing/selftests/kvm/arm64/vgic_lpi_disable.c

The test:
- Configures an ITS with multiple LPIs targeting vCPU 0.
- Keeps vCPU 0 in guest mode with EOImode=0 while injecting bursts of
  MSIs to force its List Registers to overflow into the ap_list.
- Concurrently, vCPU 1 repeatedly toggles GICR_CTLR.EnableLPIs on
  vCPU 0's redistributor.

Regarding testing: I currently no longer have access to KVM-capable
hardware (my test setup is no longer available), so I cannot provide
a Tested-by for your series. The race itself was originally identified
through code inspection rather than a standalone reproducer, which is
why I turned the theoretical scenario directly into this selftest.

The selftest builds cleanly as part of the full arm64 kvm selftest
suite, and its framework plumbing was smoke-tested under QEMU TCG,
which by construction cannot exercise the race itself. I'd be grateful
if you could give it a spin on your setup.

The selftest patch is based on top of your kvm-arm64/vgic-last_lr_irq-fixes
branch and has been sent in reply to this thread.

Thanks,
Yuchao
