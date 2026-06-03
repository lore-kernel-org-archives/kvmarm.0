Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F220477E4B
	for <kvmarm@lists.linux.dev>; Wed,  3 Jun 2026 12:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780488580; cv=none; b=TLMcibcUnSB4fXPDU3vdqMfcKqIgMY7jaubeqOlMw2ecw2cz0ZmLzF2IhP6a0tBGjNKeTe6NSx1beadH9UDNBGAtrcINM65pwQX0BcrdqEBnZQVD7tELd6JbadZbUAM5F7U37ROAysfeLGB9CWtG+EwWy8cg8Dmg5Pe+nLlHlUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780488580; c=relaxed/simple;
	bh=3GWDWLWCMXc+5OOno8Qwns2iSCPZvQEoDk/ip8tJyEA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kqTaskGC8tpLanJQeUmHvxHBVguBefqPtI6rSZm4qhd2Y7yiRPCUd0P9uW9JUhJ6GW4FfM0y6gorZfsLNxg/NZWCnti2wM5HElBeaz/3+YICjkBSp5+8fQtGQzr2i3QWdTC9WBAmDtS0gimxXWIvTCPQYqIP0h+iXc95JlJPqME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lxm1PhSX; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lxm1PhSX"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2bf237e1433so56223835ad.1
        for <kvmarm@lists.linux.dev>; Wed, 03 Jun 2026 05:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780488578; x=1781093378; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PtMTRcfS8t3A0zoUtO5rbb4BAKaZHdusERWAc+kj3aw=;
        b=lxm1PhSXqwvw9I07g6QraQfKoaDoAXOpNSZOQl5cFPQi6e1SGf2wM968OWda1ZTju+
         Mqyr73jwNkaTjWV1TQrhpJ2ukL55FJHAPK9JClP+vSbWCvHDVel40HEECDxeE3nxzt34
         kD6TfBjTD4oRB7L7/qsy564XbMcKmq7gX3tZQhxiPNUkGZCFwZYevEF4GH3VIW2Bvp/v
         5YBeQWt3qG4TSrqpO108H5FMNaer4SPGu9lXil62XoU/bW0A5Ybox7FwxAmRpjdWmItJ
         R2DpRdnkhmDnCaj8SruA5UZp9POEI4lJsUy4ofeDPsXMdCfvu1NPe0+Q0+1swpNJeRTg
         /Lvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780488578; x=1781093378;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PtMTRcfS8t3A0zoUtO5rbb4BAKaZHdusERWAc+kj3aw=;
        b=UuDorWHJYH/tLWwT0bELEzceJ1HCI2FSrauWU7CstUqoamUCNDil40a+o3TUAAjFVB
         vafK/AQabfNhjWuw6JFrRDES9y7QE4uZ39dkiOsPNW6FW3evngYy2hC78gIi56fyrUPg
         mpGR9gPB5gzMwRgc3r3Szy0cWTQxFOWKZHj+xe8OYlKvSS1ZIklLczBI2Df3ofdTDKXp
         R+d6DQU3Ekp6d+BgzTsmbY1/OIeZMQKcdIJPIdkNwoRRKS8WBTallEHLs1wCrz0yVkJC
         +Za4HR8DsrQ7CGbihK84PW5zPfIGnA8in8P7BG3W5u1j16vWMCWSGOiLDAqnJqIbIknf
         Okww==
X-Forwarded-Encrypted: i=1; AFNElJ9wC1HUVAW3+yxkY2oXPkvUgSDYD3eAosHXBD6iUT1pfo9oKRPpnbhJZ57+k4aw8nkFZplw4UE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxtXTyq7upYbMkH1MCULYcgngUTWqI84tPnkilRllrA/7zuljb
	I3WQmpk3WFdkfVf9utnXXNNJnkgHBHjlGqxlDPfTZobUXgV2yffZAJ9tw0aT4A==
X-Gm-Gg: Acq92OHEDSQWnpEdXSsIE7ZH1HCAsOtJpS+ALndzifF3M1CilRrpXHBpBE0bIvFK4rB
	DAVGGekJMAEa4cXGXz6Tl043vZ8gN8VD29ntXZ5FZCx/9A1O/OluGuGdi6nZPrCaYlKUGFl9jan
	JaQhqHYkIA6E85a3d84mM27o+fqVpYwx7a4cIESIQL43SCt0tsccpTz1qXjTLFcH2viokX3Eyhs
	6fTUEwRcz+U2oaNaxj6DXgeCjWs0fQENeeqEm06caUzXDYiibGw+yrNcHfYTQnSAP96XMrEcQEw
	5k3XBXdZDG20H08wpIT0A3ZmbA5GU/ZtLHta3O+pgNBjNgX2DFjVlE111z7wBKelvc+CYVUNOAq
	f5EsmOb0Ifq1WOmcudEGFU5LhjKO+4ZZH5Hwwxo5QB2HBm0oPMq7sxxhGvq0aHVBWwM881mdj0E
	vnTRmU70uNDt8Z7xyqhNyudNCRTF0U/QzTty3lvb4q/6T6IFTALRghvA==
X-Received: by 2002:a17:902:da88:b0:2c1:69cb:441a with SMTP id d9443c01a7336-2c169cb4529mr27294735ad.18.1780488577735;
        Wed, 03 Jun 2026 05:09:37 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629cfb4sm25082855ad.59.2026.06.03.05.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 05:09:37 -0700 (PDT)
Date: Wed, 3 Jun 2026 21:09:33 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	stable@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH v2] KVM: arm64: Take the SRCU lock for page table walks in
 fault injection and AT emulation
Message-ID: <aiAZfdeyanIvP8SD@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

walk_s1() and kvm_walk_nested_s2() expect to be called while holding
kvm->srcu to guard against memslot changes. While this is generally
the case, __kvm_at_s12() and __kvm_find_s1_desc_level() call into the
respective walkers without taking kvm->srcu.

Fix by acquiring kvm->srcu prior to the table walk in both instances.

Cc: stable@vger.kernel.org
Fixes: 50f77dc87f13 ("KVM: arm64: Populate level on S1PTW SEA injection")
Fixes: be04cebf3e78 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
Changes in v2:
- Wrap only the walker calls with scoped_guard() and move the injection
  lock into __kvm_find_s1_desc_level(), as suggested by Oliver.
- Reword the commit message as suggested.
- v1: https://lore.kernel.org/all/ah7_BAAzHggzdZeI@v4bel/
---
 arch/arm64/kvm/at.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 9f8f0ae8e86e..889c2c15d7bd 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1569,7 +1569,8 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	/* Do the stage-2 translation */
 	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
 	out.esr = 0;
-	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
+	scoped_guard(srcu, &vcpu->kvm->srcu)
+		ret = kvm_walk_nested_s2(vcpu, ipa, &out);
 	if (ret < 0)
 		return ret;
 
@@ -1665,7 +1666,8 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 	}
 
 	/* Walk the guest's PT, looking for a match along the way */
-	ret = walk_s1(vcpu, &wi, &wr, va);
+	scoped_guard(srcu, &vcpu->kvm->srcu)
+		ret = walk_s1(vcpu, &wi, &wr, va);
 	switch (ret) {
 	case -EINTR:
 		/* We interrupted the walk on a match, return the level */
-- 
2.43.0

