Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8511339B1
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 21:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780607774; cv=none; b=DpREtrRn+3RYa7bWqTXxkaj+Ru2CVHudF+b6BZEO3swfR3HvDVzEe/Lln2yzDbUJy0CRrZgFFbfntwiyP7IGn+J/bdbEL3bM0hEuaC+wMGrGZt4Rj04RgFhmQRNB3nFIpfZGWeDaweQXdclWJuEjmdp59jZ2RH9WzVrFDMM8eH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780607774; c=relaxed/simple;
	bh=eCX8oxct0BmaDUeXMCi7VVCO1Fu0v9uiaoGrKeDqBkw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fjyWqK4WwSU4f8HaFkYNBZECavw8X+nskJ1GPbBXkp6Yz+Hdb9q86Qs8LWgbo0MY9ds09i7/4n+l1t8OsCs4vHzP9g9lde6L4tz5VUnQ63/Xh+ClL+ljZ4vmrgg+Qmcx+3HuzJjyMaa/z3F59uxLSYHtMdTcYogBRSzAWIQ7/bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bXlUq5Na; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXlUq5Na"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bf36a6905cso8599465ad.3
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 14:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780607773; x=1781212573; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O/4ZDPfisq1bDU+cypy52bTEPD40rVLXrFwdCfhs680=;
        b=bXlUq5NaJ6FGzIVFWBzMgGoTcr8JJ8EnPx1Uecp61UifRgLuu7DykXNiGNZVHnDu+c
         uoNDSfz9jouDh0paDwspggThaO+vOjZlUWHhRBms/yvXmaJ7UZLf2y1ZhUsHiVTkdLFK
         PIyxG/oNmoSmGIKY6EyTD4GpdhgjVVlUT+JTxOnlzF3H5tPtP2zZNx6wE6tMvPtrF9OK
         w/CNrVEq6zl6YJ9/nClH879apcJ5cd2h3YG/mcK3sdt5mTg2Fqcz6zU4nHYelC+QEkn5
         i7TrO6hSbwdkAPLUF6UL5UC9tSg5V1f6oCGYc6w0D3YHSRT2h0pGQmTJ6OjbEFS6bDVa
         9jxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780607773; x=1781212573;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/4ZDPfisq1bDU+cypy52bTEPD40rVLXrFwdCfhs680=;
        b=KzdwVu7puLh1cZnXHaj5n4uhQnVLWoCFAgyiEY8Wa1MiXD0xVYeBC85PYsbs/TwRE5
         WBNWmPWcjVv/Gncf44Zv2UZJO2d+Sumr7cfsTTJnz03sfi6kLzLVISwAO/l+12xIXehz
         3MhvPmm2nKQ3Wxy6+YFZXnM9Nw3H/HnAJMgBsB874MGerSQcPE0eus1qsC/BcA9GyGYB
         3AvvWnDZ7PK3b7VBFIWZ3pvD3aLA4CdbBJHr5yvrivYtztIS2kQ9cTTGvbLCUXcU4XPO
         vullDn0v3CgRX0AprO4ViIGuL9s6bEAJ40PhZZlMffMlq/8QNOXAdYAgaEI8JuQQ6kcQ
         UOgA==
X-Forwarded-Encrypted: i=1; AFNElJ8V7t/Z87t1b/riI/+dK+oQwePwfWfZl4IWAoJpcXCBLoZWT7X/oxdYNZ+4xY/FgWowgYeAXAg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqsmUynaJGphiWXNpQPKxNtzE8Z4fwV8nXFT9sE2AlkdyrXl8h
	y3tUon96/nbTtSAvvR5fiKwqdwzoD5+rMmufxXoGvi/Ymy5RLLNvz2aI
X-Gm-Gg: Acq92OEFg1d3vb4+xa7UEXTKNn/v4lDAfNUwrqDZBgvUyQjwop6e9wo8CnXlU7HKBF7
	edh6fyUHGViIKrrWmp4WmBZny4+Sy0rxz/jW2kQ1FZFhkedzXwJdfcchA+X1kTswCxAOyOTWn4Z
	NmZaw3DuNgyqHKmq+HQVGRyhxH6w4oFX2IMkWefJSote8P2mrXkwSIa9zdI2aHuuk2VxhMJOFN4
	59C8TE6vNppf3saGeIes8JAfIHYXCcpg9wsDPGFfQNq1mP7x4tSbEyRpGZfin/AtnS2p+bi7m7b
	MpCk2YZVZp5Y1HJbJyd3rhsO7bCG219Ee8bciaFhXxlXJEmSwk5OZDbKZ4nHAPlyjhsUxZQnghz
	VbA3n/Q02vNFYdFA9P/em5CxSN2uq2hJIM2GuzzE11+c5BG5jAbLJyIP4SLDyKznCwckNcglL6l
	rHtr0nV/rdFYyNYY4lVFhq9NWyW25VP82Uv0yaAdFRAqXtRtw6dA2sgQ==
X-Received: by 2002:a17:902:e78c:b0:2c1:42d2:2a66 with SMTP id d9443c01a7336-2c1e8368d03mr3172835ad.33.1780607772824;
        Thu, 04 Jun 2026 14:16:12 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6d59csm65156465ad.4.2026.06.04.14.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 14:16:12 -0700 (PDT)
Date: Fri, 5 Jun 2026 06:16:08 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, Sascha.Bischoff@arm.com,
	jic23@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH] KVM: arm64: vgic: Use list_del_rcu() when flushing pending
 LPIs
Message-ID: <aiHrGM1f8czcUby4@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

vgic_v3_fold_lr_state() walks the ap_list from last_lr_irq without holding
the ap_list_lock, relying on vgic_irq being freed via kfree_rcu() and on
interrupts being disabled. vgic_flush_pending_lpis() removes entries with
list_del(), which clobbers a node's next pointer, so when another vCPU
disables LPIs via GICR_CTLR the walk can follow the clobbered next pointer
from a removed node, or from the node that last_lr_irq points to.

Remove entries with list_del_rcu() so that the next pointer stays valid
until the walk completes.

Fixes: 3cfd59f81e0f ("KVM: arm64: GICv3: Handle LR overflow when EOImode==0")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/vgic/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1e9fe8764584d..73efc0f95bfb1 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -204,7 +204,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
-			list_del(&irq->ap_list);
+			list_del_rcu(&irq->ap_list);
 			irq->vcpu = NULL;
 			raw_spin_unlock(&irq->irq_lock);
 			deleted |= vgic_put_irq_norelease(vcpu->kvm, irq);
-- 
2.43.0

