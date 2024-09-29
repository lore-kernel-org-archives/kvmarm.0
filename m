Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD0217C8B
	for <kvmarm@lists.linux.dev>; Sun, 29 Sep 2024 04:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727585237; cv=none; b=U8j2Xd4jpyom8eY8XVBhIj6+mp8efsG5zEgVwrA4RtSCxCvuZMVVNF6t6jbDgPk0RKLh25p7xzGj/smZGDbKa+8AjAmyzLuYFTuXdUAt880bGHPt7f/OfOJc/pIo8vaT3A5/ZONIUwEzhP3P8/LRWElIBgyQ4Zgw0y1Mhu76j54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727585237; c=relaxed/simple;
	bh=0gVAvVq9QWjCEzx+xpvsDjjt2Opmges2p9QPYWzAETk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M4qYhDVPHnqYkv0m0MV7tAahP10FzpzcvIe/GBlQhPvGKhpxTeF5wYgj8ooMiUR/vlxjp35bm+iauomeVPhx8ifEctY8GE/LnzjLb9a5aG0eiRDnJTBYvIdadv/gR0bf1ptZ2O4QhY6k+dKtT4RubjxU2EGw/z/4JG+sHSV6L04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0//1qoc; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0//1qoc"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7a99fd5beb6so368266985a.0
        for <kvmarm@lists.linux.dev>; Sat, 28 Sep 2024 21:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727585235; x=1728190035; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fMFE0GTqbW0T50ivmGcDcpWDKEF/OBy4KQ/5LsKTloY=;
        b=T0//1qocKIkx5Z2AWu+EsnTsCtsOuTGPr0EKcZ+qYrs5JrMeFATXAtukHgol1vUhdw
         79e/P+B8OJdQnpS+/jGA9dbU2TfJGbQqWSLSt8NtsYltSTFTyNxoW+t/OlAfPCvFxQ3I
         WL848Ao4vlubtbKNvs4v9FhXGSge+rAoldm42OwSKk+EktKAQu1ze4hyXKQJpB7Vm/Kp
         +EV36j3hpvYi+B/a3RMmtWKONzK1Fsa+vMgw+8GnOBOfJ13ZAxWWasgKb3YEFVsDyN86
         /QpQmb+bgCuFGozcz5guY1k/A6ffmkVsyVlzh9VSKfvggqhEBGkK0Z89mHj5FpljgVC5
         CoHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727585235; x=1728190035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fMFE0GTqbW0T50ivmGcDcpWDKEF/OBy4KQ/5LsKTloY=;
        b=EkI38I0BLY0iuQxnrB/2zY+1eAXTh46euNj29LBWotxcu0zF1Mn+qbaElZHoZC5bvf
         b/93dus/E1oZkGwgDC5qfinoS2vOffy6aP8TORiwQuxhs8wllKYMOk1uCe0dc74RB2c6
         onj4gxdb9Tz09fDWnejZaXznC4YooBcvLRG7VOXin/08F6F21ibMg/Qe2yBW8dRf+lfg
         Ulr09n3CYJSUb/7lvVRDO/NQputjEtRGEPA39B5H6I1OS0Z23MsE5XaFxPubNY7oWJHU
         PM5DJbHxuXpQ3BSqI5Zroj+mMc29zzk5jx7v/tUhNh1ewFQnGwAfZH7UiAbNUgZxfTBm
         YSfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXB2jzSMb6xCUAhxz+B5l8IA98HfXmeEucbNbneBYq/EJm3LLNecrOkQcnPoKHUUQWhy7wi/GE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzX2SbTOms1wmvGJQyOKCfJbQ/Gjn/KKQ3myJT0KI+Y2ebiEg7u
	OJfNt9zdJMY2DNr9Q0b3rvSmSVDv4hbhYtRsfbfre8XBdjnM/XEc
X-Google-Smtp-Source: AGHT+IHZvcEw/8OZTzrIKSCDcpNxoH4EfzOWCLhV8ZiAVwg04IbAxDIGxPpmTDDtLuStHKwADjYamw==
X-Received: by 2002:a05:620a:178c:b0:7a9:a356:a5dd with SMTP id af79cd13be357-7ae373a7a7dmr1433156385a.20.1727585234780;
        Sat, 28 Sep 2024 21:47:14 -0700 (PDT)
Received: from localhost.localdomain ([185.221.23.200])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae3783ff45sm265461385a.115.2024.09.28.21.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2024 21:47:13 -0700 (PDT)
From: jiaqingtong97@gmail.com
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Jia Qingtong <jiaqingtong@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic: fix GICR_STATUSR in vgic_v3_rd_registers
Date: Sun, 29 Sep 2024 12:39:35 +0800
Message-ID: <20240929043937.242769-2-jiaqingtong97@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jia Qingtong <jiaqingtong@huawei.com>

vgic_uaccess use bsearch search regs in vgic_io_device.regions, but the
GICR_STATUSR have wrong order in vgic_v3_rd_registers.
When check all vgic_register_region, it turned out that only
vgic_v3_rd_registers has this problem.

It's harmless since vgic_uaccess behaves as RAZ&WI when it can't find the
specified reg. This is exactly the same as the behavior of the GICR_STATUSR
register.

So just move GICR_STATUSR to the right place.

Signed-off-by: Jia Qingtong <jiaqingtong@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 9e50928f5d7d..822b4c1a01dc 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -651,9 +651,6 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
 		vgic_mmio_read_v3r_ctlr, vgic_mmio_write_v3r_ctlr, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_STATUSR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
-		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
 		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
@@ -661,6 +658,9 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi,
 		NULL, vgic_mmio_uaccess_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_STATUSR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),

base-commit: 17a0005644994087794f6552d7a5e105d6976184
-- 
2.46.0

