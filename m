Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2473093A6
	for <kvmarm@lists.linux.dev>; Sat,  1 Aug 2026 15:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785598662; cv=none; b=OwzBCKrS9+P+aBDyU0maWf59nBW95Oxe1v3vdgg0ORhumnFSHRh/o/EMLwy7zT+wJ1MBkiarLegAFP3QgdP3TmSzDlaYU4EBvGpvM0tVl60v8tHD57vc0MdvOYt191BXWznT2DbMFTdmIw6BVPt2Azww3qalmzPJql6+N8r+HFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785598662; c=relaxed/simple;
	bh=HJIn6ArNToUyryFG1+tm+1I7IC6zVMv0l1gSzPCFxrg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BXcZgSTpeQhWs1Kh1iAx57KEz+MtXdY41n/cQXda/3NY0RXaULO5r8IwBUOeLzwLyjaBL58wAtiYKOuTuOyHbKA61gEtEH126zc3bBgSmV+LnohO2TDtCPykwswLXi6v453w+BG6HXeDkL9HLCgsgByzO17wTNALk9o/Ue4iSWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z7Rk1zrF; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7Rk1zrF"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso3198995e9.2
        for <kvmarm@lists.linux.dev>; Sat, 01 Aug 2026 08:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785598659; x=1786203459; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u7Hwn0xlTzxIN2uBpUzcPzgILfRygUZswZJisr8yQeU=;
        b=Z7Rk1zrFtfiDqGEziDxWNMAO+T9AgV4uF54jNXx+3ddOTWvqaoZXO1wrh4616dELjE
         7484RCdn/1TTJzrk49GDv7aHCcK86w1nKUb6K5/Z10+cqzTi8fBsF65rrYt3FKvVGkPJ
         j6yk/8Mh0DXAotGSvDq5ArCepoLW0yaYwVl1Cy2nHuQ+5u68oDDpmKDBmwPg+7kHJFU7
         BMOUYw9MFHfD0BLNEnf6IVlr7QHn5GZfjX/RlRwgQ2vNuBGiSOinu8fkxYsFmUsAgFlu
         vvgVZiOWIvx2mNEF6JcgT7ItS3x8PSM5ib8YstX0ynIU8g+27D0oSneGghdEyhlwLAlj
         TTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785598659; x=1786203459;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u7Hwn0xlTzxIN2uBpUzcPzgILfRygUZswZJisr8yQeU=;
        b=VLQ/cum535ejjBjYh7M/ILV3SlVd0Id74j0OfjazUrEfpRQMgs5slFwdufSBm+USsM
         aGeuvdof1jZ789LqLgROuoHsNq6MbLucngR/t5cVpoetJgJabJJw6kMpxUOtgsD9LFzN
         Q+gyYY/qTHLitvb6fiS7lvEpqnx8KXyYvPjXaSpLDFKbh0WtO4dhtTkM641G2k+qd2SS
         /nHQ9ysRB5pA/BZPKVeCKvUK4rU7e2yYDXR4wcz5N3ZS3b6RdWvXhmkrk6rWp+Y1uUW1
         ARsLfOh6TuRf3//nM0GjF7Ooxjtl/fmwF9pmdnvz3Cu3ZFR0gPYcjKW9EGP67B+scAtS
         WgzQ==
X-Forwarded-Encrypted: i=1; AHgh+RqMhHxuyMDV236Z1gn/S28qHm8q6UK1Z2Zad79BkjGfDMrqv+MyBNMwfi7mWzdH059aoqGqYAU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdzIdUSNkyyuDDa/1Cy6z6leXKWpmLJTr6zARc7zxklhHG3KfN
	bYXIj+LnxBsMrrGQ9qXLNYO0/Xw7UdRaXBl6SheMXZViFSSk7XhQ5LVJ
X-Gm-Gg: AR+sD11uU3F8MJROjXBy7WqK/rMi2hFwslfimg4qyOt5OxfCVWAalIchArO/vR0azBU
	Sf/oNb8+O67UkcWO+fwr+UU9ECJdDN0Akx++tL1qb0fN+LKnDxVKaMoWVid170rS1VG9SwbrGsB
	e94jz74pSZQuX2QQt8nAbLkq6tFAfRMzcxVTxhSs9ruxnYqOgZW56C2QNSEbJM/2BUjYlbTCbcE
	FYKvJiKSF9YRc42gphg0JII/3O1FTFdm94MEY2469xMj33+r0cOmCw0UWfondf7hXs1I51zVUXp
	k4X0KAsWxRcTmNJD5vPBnNGnApUtZR048JfsPTyphDKvj/0PQUwNA/8KFoNwfRoFnha1wQV2046
	Q0oRmpLWMdjKmrxXT1lbSxb69QIXyY1VCdXYuDLKmabnZyG3coScHcZE7DEHsrGM66h1zhcLl9i
	d1nKaQbXhUp955ox1xQJa6yaPp4R5BpR85X0MSnu4cQEon7RM53VqLx3DqLD98TgAp56dDvIH5j
	T3A9tjfYhV+mBuArftq+OLtkhhsv+cs6Af4y7k6jXfz7y0LP3HVSt8qJfoXacUVTWY9hyWq78QM
	biM2OKl/jRcuP6bqVgTZ9/cDXA==
X-Received: by 2002:a05:600c:871a:b0:498:952:e276 with SMTP id 5b1f17b1804b1-4980c66c991mr73253905e9.8.1785598658895;
        Sat, 01 Aug 2026 08:37:38 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-114-005-130.95.114.pool.telefonica.de. [95.114.5.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b67529sm65115055e9.8.2026.08.01.08.37.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 01 Aug 2026 08:37:38 -0700 (PDT)
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
Subject: [PATCH] KVM: arm64: Preserve AArch32 CP64 registers on rejected reads
Date: Sat,  1 Aug 2026 17:36:16 +0200
Message-Id: <20260801153616.71960-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_handle_cp_64() only seeds params.regval for writes. If a CP64 read is
decoded but rejected, emulate_cp() still returns handled and the caller
writes params.regval back to Rt/Rt2.

This can happen for write-only GIC SGI registers and for rejected PMU
counter reads. In both cases KVM injects an UNDEF into the guest, so the
MRRC destination registers must remain unchanged.

Instead, the uninitialised regval is copied into the guest registers. With
stack auto-initialisation this is a deterministic zero or pattern value.
With CONFIG_INIT_STACK_NONE it may be stale host stack data.

Match kvm_handle_cp_32() and kvm_handle_sys_reg() by seeding regval from
the destination registers before emulation.

Fixes: 6d52f35af10c ("arm64: KVM: add SGI generation register emulation")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Runtime tested on a Raspberry Pi 400 with a minimal KVM harness running
an AArch32 guest. On the unpatched 6.1.21-v8+ vendor kernel, the PMCCNTR
MRRC test took UNDEF with r0=0x00000001/r1=0x00000000 instead of the
guest's sentinel values. With this patch on v7.2-rc3-278-g38436106b2f5,
the same test preserved r0=0x12345678/r1=0x9abcdef0.

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4860,11 +4860,11 @@
 	/*
 	 * Make a 64-bit value out of Rt and Rt2. As we use the same trap
 	 * backends between AArch32 and AArch64, we get away with it.
+	 *
+	 * This also makes rejected reads preserve Rt/Rt2.
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
