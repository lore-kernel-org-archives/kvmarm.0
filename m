Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793628888;
	b=hRoVhiTiijeTF1SLyMV1jvMo9iEHx78dJcUJ80rpXULvPmkEr1QB27xjAqVgAy9Q87R7
	 c3lHgOe/dqRsD8omDJtZ+DYTL99SgrOpJI8Zy/pPMllVyGpdp2w7UCLcEC/UKXI7TCL53
	 WX7xeRzWY/CwvlxNMNkMR40Y35g84efj5XFPuRbxrsZWdhBGt8JCNTuFx94ep/IaIvb9M
	 jLjf32iSd0mgyhBazgdIDDVWN6NZfDkK5x+EzABw4LtcBHY7BumWVHLe4YKfxFSh0oEoW
	 MtZGGW9j+gFtzFyqiv6/jVdK2OUsON8Bc5pHH9vCEaSJL6tFknNwhGFBuhOBg4q8YqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628888;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=I6wt0qCogvuBKigmh2JCg/spsby2CoXz9wPbiqsiJUk=;
	b=nz7Qvirk9+WwIaJkYrdsobRICJfGJs3qsD3ro/Na8YuC1R92DSQKKre1CX9CyAtfauWK
	 gKFAvkM2HcYVDH0WA66w6k/I7Tvq1VoBltVob2Y6OyLwDjpuFAZTNgwGHFd88n9UsE9Eo
	 +Jcsfz6bZ5pRYY0gOg7LJHvzSW7x9n99I3+0VxHOAhitiFAJMb4FuX+LcLt2eSYCXJHZz
	 t35U9aVele0ss+9pxVzLdBa98z14RCSLsbfkke/f0yjKMN47R54ozpl4YYlcIBj/dDTYw
	 gpgTBzUa1ufFvPBOnSfZo7RW+DLhua2gLjAixIQqJj4fQhPK686D8GKSt2ZlUc/tdlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z0na1FQ6;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFB360A260F
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 14:14:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDFB360A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z0na1FQ6
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48c7fe9736eso2731807f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 06:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793628886; x=1794233686; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I6wt0qCogvuBKigmh2JCg/spsby2CoXz9wPbiqsiJUk=;
        b=Z0na1FQ6Ro7900VnT64i+i6M/XL1A2hH+3Wz3pFZeEaEgv4wW99ZKajj2OpINApgMZ
         WHwchLFOxSQ6wBvrdMWSUFlGbwqDlDyvUBeVegNDQVY7SnZYPOxhjmKgyx6+Z7iorxmp
         2VPePVNM9+Y/NW9G01+JhMa9h3mG7u0f3yedfJ+YJX8dFRtjn/3N0hleB9bQPEmm1oN9
         rlQBwx/IyLQ0y9h1QbDqoBi49iUke6JWX4Glnf7YEWcZSAHCNB9Dh11eZkvFmt4orbKZ
         lthuQimFLloWnsm1swOPUM/FNPF5BO979kccDs+i56wBmE0UgPR4FXtS2aLLTTOs52VM
         lgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793628886; x=1794233686;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I6wt0qCogvuBKigmh2JCg/spsby2CoXz9wPbiqsiJUk=;
        b=VPCZZjf8vxrHMWj8p+nY+0EI2h8VLkfotL5XUICiVWCwaNhQaaUfAr8q7X4W32BeKT
         sdwy92fqDrtEVqsSmJcUv5HuEssX+v9BTsPQrWbHWQrjsqhxGfoiLOcuCTCSGji1wipc
         vQVLVWoFpF0uMsKbiRwOKMn4x+bQ5zgacrQkUkqarHyLznaieFt+2SVh37mOpzNQXdiv
         PrkhrGaksgFvxqnDopQ3/wRLpfdpNOrEeADctqRKvuqdDg2m3kXi1/ajjQ2CozhYwF6b
         PzI5GNFyLoQx/8OQ+j0OLGP/QS3nrBAcZJX9Kj5/oZPW2kWHRkoV0oKevrnUn9kk5gFN
         8TKw==
X-Forwarded-Encrypted: i=1; AKwUvByu9WgsUBxl4otIx9Lt10Z3k9yn+ndiN3ZE3v3szdAH/uiJurOs2da7vaUHWmbfZZz3PbOtVFY=@lists.linux.dev
X-Gm-Message-State: AFq9FYKJveOUwu9St1I7Xj94KQqRW6w9VbSSY0uA0tAhSncI9q+7if8/
	4PBe/H/1xjCdjLHyZnVTgjo25kTqWM2X2jKq18Rlxm6/L7dB5Uj0BXWaoLCFmhi1cHuLrbApcr4
	rNmJPx3KXc9a8UY7txNLmKvS5bA==
X-Received: from wmbf3.prod.google.com ([2002:a05:600c:5943:b0:4a1:fa1d:83c3])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:628d:b0:4a1:f7f4:7ced with SMTP id 5b1f17b1804b1-4ac185bd243mr235882325e9.17.1793628886221;
 Mon, 02 Nov 2026 06:14:46 -0800 (PST)
Date: Mon,  2 Nov 2026 14:14:42 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102141444.1830221-1-snehalreddy@google.com>
Subject: [PATCH v3 0/2] KVM: arm64: Support FFA_MEM_RECLAIM2 in host handler
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sudeep Holla <sudeep.holla@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Snehal Koukuntla <snehalreddy@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The Arm Firmware Framework for Arm A-profile (FF-A) v1.3 BET0
specification (DEN0140 rev K) [1] introduces the optional
FFA_MEM_RECLAIM2 (0xC4000091) ABI.

Reclaiming large memory regions with the existing FFA_MEM_RECLAIM ABI
can take significant time, or relies on a stateful time-slicing
mechanism in the Relayer. FFA_MEM_RECLAIM2 allows an Owner to reclaim
exclusive access to a subset of pages from a shared or lent memory
region by passing an array of constituent memory region descriptors in
its TX buffer along with a starting descriptor byte offset and initial
page index. The Relayer returns the number of 4K pages reclaimed in
that invocation without maintaining intermediate transaction state.

On a Pixel board (pKVM, 16K pages, EL3 SPMC), reclaiming a single 16K
range drops from 1.3us to 0.7us (~45% faster) by avoiding
FFA_MEM_RETRIEVE_REQ/RX_RELEASE (~0.6us), and single-call
FFA_MEM_RECLAIM2 stays faster across small range counts (1.3us vs 1.9us
at 16 ranges; 2 calls break even). Up to 64MiB (4096 ranges), batching
256 descriptors/call adds 15 preemption points, capping each EL2/EL3
call at ~11us while keeping total SMC time within 5%.

This series adds the FFA_MEM_RECLAIM2 function ID definition and
implements host proxy support in the pKVM nVHE FF-A handler, unsharing
the reclaimed pages in the host stage-2 page tables upon a successful
reclaim response from EL3/SPMD.

With the FF-A v1.3 specification now at BETA (1.3 BET0), drop the RFC
tag so the series can be considered for merging.

This series is based on v7.4-rc1.

Changes in v3:
- Drop RFC tag now that FF-A v1.3 BET0 (DEN0140 rev K) is released
- Update specification references and links to DEN0140 rev K (1.3 BET0)
- Add benchmark numbers to the cover letter and Patch 2 commit message
- Collect Vincent's Reviewed-by on Patch 2
- Rebase on v7.4-rc1
- Link to v2: https://lore.kernel.org/r/20261016082341.4030770-1-snehalreddy@google.com

Changes in v2:
- Mark as RFC until the FF-A v1.3 specification reaches BETA (Sudeep)
- Rename FFA_FN64_MEM_RECLAIM2 to FFA_MEM_RECLAIM2 (sashiko)
- Check total_pages against the sum of constituent pg_cnt (Vincent)
- Simplify the flags and offset alignment checks (Vincent)
- Rebase on latest kvmarm/next
- Link to v1: https://lore.kernel.org/r/20260921164748.2958578-1-snehalreddy@google.com

[1] https://support.arm.com/documentation/den0140/k

Snehal Koukuntla (2):
  firmware: arm_ffa: Add FFA_MEM_RECLAIM2 function ID
  KVM: arm64: Support FFA_MEM_RECLAIM2 in host handler

 arch/arm64/kvm/hyp/nvhe/ffa.c | 126 ++++++++++++++++++++++++++++++++++
 include/linux/arm_ffa.h       |   1 +
 2 files changed, 127 insertions(+)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.317.g454f8302e1-goog

