Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C672264C7
	for <kvmarm@lists.linux.dev>; Sun,  2 Aug 2026 18:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785694951; cv=none; b=YTcEwK1a66kXUP4tQUgQyr4zkG5iYAgy0o1z6+xEmq1A/L+4KMd30rMwNiYQ4es9eckNLGgnSWSp8E8C6rEq3aS97cEpWMLsYALepKd4cjXNPNXzIx4BsqIASzFUhgXeCCy+hDpY5wMPu/xoqcfR+WhNYU0czqIwCQFcpnTuzew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785694951; c=relaxed/simple;
	bh=L/4yfN0r7nIB8kAjf781EJfIlqPTgPdAq2Eibjb6hDg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rUiAATC1zyL47yXmrSvquHgr7R6HpdcdkQ1fqPzheCdP59aguJZki9nb9JCLNl99638SzfcU47xPuVSYOAbMnIlEKYz4WgYrflqm3BbwsON5UBn3frVLXW0AhdlK0JCfMm/s39NBh82r5zSJgKI21s0gAiwHVPyY4Ke2E5UM8aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvASoI0y; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvASoI0y"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4956242332dso12220665e9.2
        for <kvmarm@lists.linux.dev>; Sun, 02 Aug 2026 11:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785694948; x=1786299748; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pLz8CqUuxfuhpUaYrzuwzfN7xMtH1IZWfv3SLyQlY8s=;
        b=cvASoI0yJPN4P14hwRAA8n04Y4wMNl46LSE5SmXPKuhWABO/Z3TCgS5+t0BdtY3uWY
         +g6DNEF8p+Fu/tfWWMg7EpSyfrMZQAJbi5pcYa3npgQXgmF6aFGfMpf63VQYW8DeoFZR
         zmkCKp5I0lzgM3/1P8Aam5GuXgVLIsXEpS1s/6twhJv5mWD4WeAyG4Gwb/0sniUsRPUU
         sFFMSLcm+n+VEaO731lKm3e1Yxqf+HsBpZiFtpdgW2DM3EM21UQQ7XKBcSX/AI9dMLx1
         +zCATYJpA2cVDteBJgaAAohvUJgeP/jvBtT/01MQQU5mGK5jV83VySbMN605TKpGUfaB
         HDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785694948; x=1786299748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pLz8CqUuxfuhpUaYrzuwzfN7xMtH1IZWfv3SLyQlY8s=;
        b=cO84Od/uk++xh3nReFs2fs3sDLM/ipQm61GQeW329odwMS5dEqr5vImOmM1tvFixh/
         Kodyge4Acw7FFsCSmxr0OZIhEa5nB4reGitt2OXyKayspXGBL6dWFn5dxOO5KsPhUtSD
         ELYDRNO+c+1EaSfOFk5xKSH9RogHQKEODBeYEWTAI1MCXjqH6rhBNo2bDO8ujSZ3zIRC
         DSzg7h1qEgOX+5vf1Zjs/r0kDhTsQpimqMsVVUq52CiUPb//H01HnR2lgvFSlPoBysuq
         PPF4ExNPsBfHmLW2pSUJl5wVLjVVYhhxmrwCoAOFa2UIzkgzG4snCimUdNlmJZVAlVZN
         EYoQ==
X-Forwarded-Encrypted: i=1; AHgh+Ror8/MYMRpZq0CTpxV1p+DkNdPGqlRYQuT/+EgI2QE9eF7aCKANSJoQf+dgxt462LqXuhhnsSY=@lists.linux.dev
X-Gm-Message-State: AOJu0YycaRq1gS/6ZCLpHDN0EcrHEhCnTQh1kPFDg8/jVb92MOnYMxMG
	RbKCo2tkgiPFUhgIWB2DDup2R0iog6WWPConV8t7FfCtxkC1mrEUqBoM
X-Gm-Gg: AR+sD11tAS6UP96Hs2H916jz3rWmJ8yPXD3meP6/z+8H3wIgMOzJj4RAYLjtTFSRuvv
	vWRrO0CcZ1hNOR28tFCGdMKhdnLIsr/FhgEQyT0MTRxfYGpsalCgyha8UCCs4WMaX7CQYbmlVaf
	cj1OLrcN2zRew1q1a3TDFPlHUefgiVO/05En9FGD4n8ZNxbZV87F7MgAHtPuiNvB17OrxxQQpwN
	EJbcu/BhDYuaTJEN05Khx9SgxlIkUFxvVUyBFnkvTSMdARMrFuHnwj7XfmM8huDILvLlBlkJSNt
	nqydYYWQS4liaqPF1W2bShhANUOfuyw0X854s3dtOJvxs7aKOB0A5tDvXjqDn+vLDcWZDHm6VNN
	0P3SFkGS8WAnGM9P2JBUS1Z5/1t+ieGryOz909CRhNHd6wYgbb29lzfERveV3T7JoLbUCLFKWNr
	FcZTSP2DdB4YuVot4GxhGq71sEgT1h+kIiRRNpw8+u24KyaTILfnEpJM9DJ/6pSr9jrVjQqCqZX
	IClyNLk9DXVPBiSzja2GVV+S+Z4/XNi9GQ4/+FgzRJydbeT1GSZjJtoVffiiIg6NuSqZn7TIn7p
	vZThFD9jZJNfsAQfZn/0z/VtKwCGMNutOTKQyCt2Ny14Urgr7PjmuuOI4IQA+7et9aMmnpHTK4h
	VPA==
X-Received: by 2002:a05:600c:354a:b0:495:4e89:3f30 with SMTP id 5b1f17b1804b1-4980c673874mr155891915e9.15.1785694947549;
        Sun, 02 Aug 2026 11:22:27 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-ac60-3101-f9d3-c495-76bf-b296.310.pool.telefonica.de. [2a02:3100:ac60:3101:f9d3:c495:76bf:b296])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807ba13e9sm234230405e9.13.2026.08.02.11.22.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 02 Aug 2026 11:22:26 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Preserve GPRs for AArch32 CP64 reads generating an UNDEF
Date: Sun,  2 Aug 2026 20:22:22 +0200
Message-Id: <20260802182222.2239-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_handle_cp_64() only seeds params.regval for writes. If a CP64 read is
decoded but UNDEFs, emulate_cp() still returns handled and the caller
writes params.regval back to Rt/Rt2.

This can happen for PMU counter read accesses generating an UNDEF. KVM
injects the exception into the guest, so the MRRC GPRs must remain
unchanged.

Instead, the uninitialised regval is copied into the guest GPRs. With stack
auto-initialisation this is a deterministic zero or pattern value. With
CONFIG_INIT_STACK_NONE it may be stale host stack data.

Match kvm_handle_cp_32() and kvm_handle_sys_reg() by seeding regval from
the GPRs before emulation.

Fixes: 62a89c44954f0 ("arm64: KVM: 32bit handling of coprocessor traps")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Runtime tested on a Raspberry Pi 400 with a minimal KVM harness running
an AArch32 guest. On the unpatched 6.1.21-v8+ vendor kernel, the PMCCNTR
MRRC test took UNDEF with r0=0x00000001/r1=0x00000000 instead of the
guest's sentinel values. With this patch on v7.2-rc3-278-g38436106b2f5,
the same test preserved r0=0x12345678/r1=0x9abcdef0.

Changes in v2:
- Rework the commit message to use correct terminology, omit the
  unreachable GIC example, fix the Fixes tag and drop the added
  comment in the source code (Marc Zyngier).

Link to v1: https://lore.kernel.org/r/20260801153616.71960-1-kmehltretter@gmail.com

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4860,11 +4860,9 @@
 	/*
 	 * Make a 64-bit value out of Rt and Rt2. As we use the same trap
 	 * backends between AArch32 and AArch64, we get away with it.
 	 */
-	if (params.is_write) {
-		params.regval = vcpu_get_reg(vcpu, Rt) & 0xffffffff;
-		params.regval |= vcpu_get_reg(vcpu, Rt2) << 32;
-	}
+	params.regval = vcpu_get_reg(vcpu, Rt) & 0xffffffff;
+	params.regval |= vcpu_get_reg(vcpu, Rt2) << 32;
 
 	/*
 	 * If the table contains a handler, handle the
-- 
2.51.0
