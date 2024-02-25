Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C8FDDC4
	for <kvmarm@lists.linux.dev>; Sun, 25 Feb 2024 09:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708851782; cv=none; b=gApV/hWZLOSNNbKNeyp+HTtvwTmqcP9VQuG9/9/bp270oZKTnFtEbMLCLX0q5e/QYofnWmXyJvKOU07bAv9S5ec3eVpJYHICjG7j7/DBZG46YPvyckcYQXEOzxgGnBMDj+jmTbhGHeLRex3mBsZZ92eBHQfo9ASPptuLBu5B1CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708851782; c=relaxed/simple;
	bh=BhKO9PDBNegiMdZZdRH/v6D5eq38Xipa+7Mr0Cwvt8A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jZFllyXQQRfbAsC3p7hE8xgQmj63+mBBGL8Y9Nwo0Kme1WxK+bR79JWr8DWvnFavnNNbXvNI1ixi53lfXHSlc6HAEbaTboo2U3cj0HYUXbzQ1TYFYxR2ak9/nS8slnXG4O6Rhzkf0jWsK+LvKx5ECvr/JfL5Ft8SuhEDsySrlF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=Mb4P9DXT; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="Mb4P9DXT"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5dbcfa0eb5dso2098591a12.3
        for <kvmarm@lists.linux.dev>; Sun, 25 Feb 2024 01:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1708851778; x=1709456578; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V4hwb3pMKOhklL904VE2Zqtqr31z33P4MP5BzucroJg=;
        b=Mb4P9DXTIJIEVjw3xUYwFF/5gw5S6jxoVZgslWmYr5HX7mm7M1iQp1WlDzLhJ3TDZR
         3WXyHYxQurKSkf8Prdz3/Ohad7oxRGg1vpCtUchcYMkLZ8mnQydxoqltbJGUohHyKtSX
         sABwOyH0WdIYSiaRsaAeTk8QzE3Sn4PWKTyHRFr9WgnQZ6Slg9/FE3jqJ8VlKxHXwbc8
         6cNEQKq4zbVUBx2tbX7PaQko92KRGdiTzf7nYZQ/JEN8VQOgWN53QhuEhlAWsdkZHla+
         QOpXQcOdlxe1+ZWV3bMYzyzZT+tfnu6HOJe9BJ2zq9gTps7EVW3IKL1+cwIZlggIQKrg
         IHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708851778; x=1709456578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V4hwb3pMKOhklL904VE2Zqtqr31z33P4MP5BzucroJg=;
        b=kQc3x5K/g2+iVUJw7OYl7otMmTEWnveRLcrgHsC71Vz61HN4qgpoC89gDypg3wVkwN
         gKcAbudFcdZA6xdIM27Hc9Ci7SLZP/ZwzT6KFWB+FSHXOjyLaToW8qvZWmiX9hVa2KXc
         yf0Euw+x8a8W84BOOXJRxKrmSoXXd+71AsdJ+XXiMfQOvMfWaZSmxd+boY6b2NPNB+b1
         AvC6LtS1YCelJsFuL6dfn/Boe1qONw37Tl2S10IJN9XlZpkWNBmMWWmTsY0unEyXAPD+
         StUqzTiAfAzSWuMdUql4LkJqdzCFcg4syZsA/8J4j6Fzvx4YOZg+i4WqgiQ0uBoNNnKK
         ZgFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXRmO6tb4lmG6ohEnMQckepX2sYi5cnRn86fIazgdMqezCBjL7Bvvc1t3DoAL2YhfrmMMypfCsPzaikb0ywgSb5rsO7z67
X-Gm-Message-State: AOJu0Yyg5lWgJngk/2QK9poY5kY4CmhUhZvFk1o+ZptOhp8Pvc+FV8s8
	zerzUkg2BnVFw2YXOJxQPYnvLSXldoEdoAmlyUuR0OtHc7wakQ3P2x+ZWwT5B0keCaf1uR05R71
	krw3vtk1nUiD5irkZ+NXty8l+3XBjN16viXam4nVDq9a569Y=
X-Google-Smtp-Source: AGHT+IGKAsn5LYGykt9Ucw4vyFygaP3Xutj4HGQWD9tAELbXQUR6KtKqhIGhHTiJVu0ALIpwr2a0Vw==
X-Received: by 2002:a17:90b:3609:b0:29a:c027:3983 with SMTP id ml9-20020a17090b360900b0029ac0273983mr6549pjb.36.1708851778031;
        Sun, 25 Feb 2024 01:02:58 -0800 (PST)
Received: from localhost.localdomain (2001-b011-3808-dc23-dcdd-edc7-9b03-9c72.dynamic-ip6.hinet.net. [2001:b011:3808:dc23:dcdd:edc7:9b03:9c72])
        by smtp.gmail.com with ESMTPSA id o18-20020a17090ac09200b0029a3da37123sm2298071pjs.23.2024.02.25.01.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Feb 2024 01:02:57 -0800 (PST)
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	sauravsc@amazon.com,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Subject: [PATCH 0/1] KVM: arm64: Affinity level 3 support
Date: Sun, 25 Feb 2024 17:02:36 +0800
Message-Id: <20240225090237.775573-1-r09922117@csie.ntu.edu.tw>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi everyone,

By supporting Aff3, we not only allow broader usage, but also get the
chance to fix the issue pointed out by Saurav [1]. The current code
returns 0s for GICR_TYPER[63:56], causing guests to fail when its VCPUs
tries to find a matching redistributor, when the VMM programs non-zero
values for VCPUs' MPIDR_EL1.Aff3.

For testing, both 64-bit (with ICH_VTR_EL2.A3V == 1) and 32-bit guests
are ran using QEMU, Aff3 usage is emulated by modifying reset_mpidr to
write non-zero test values to MPIDR_EL1.Aff3 when Aff3 is valid, and
populating the Aff3 field of kvm_sys_reg_set_user's user given value
if r->reg == MPIDR_EL1.
The 64-bit case is checked to have MPIDR_EL1.Aff3 populated and both
64-bit and 32-bit guests seem to work with interrupts being delivered
properly.

Note: I checked with Saurav to make sure he isn't planning on working on
this as well. Also thanks for the maintainers for giving directions for
improvements in [1].

[1]: https://lore.kernel.org/kvmarm/20240205184326.78814-1-sauravsc@amazon.com/

Wei-Lin Chang (1):
  KVM: arm64: Affinity level 3 support

 arch/arm64/kvm/sys_regs.c          | 24 +++++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-debug.c   |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 18 +++++++++++-------
 include/kvm/arm_vgic.h             |  7 ++++++-
 4 files changed, 39 insertions(+), 12 deletions(-)

-- 
2.34.1

