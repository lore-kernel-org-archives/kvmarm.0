Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805172874E6
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 20:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780606762; cv=none; b=BZsLZEsGtdhkJYekh6rxN+7vBPAzcfAj0r94pqcAGk7l8RvWJy4sO6qd6Hr29PWwox6Rpa3k7nJyxpHBWl8dlRpZ0KoDn9QJL80icNJHPSh7DCYPjY0Y5IalkjSz44Q1IW9VszVEbZwUfR9Wu10yZIThKf81uvbSLRVzMC5c8q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780606762; c=relaxed/simple;
	bh=chwY3WZnApr+X84SB6feTbcy1B932iGsQl3V9ECK8ko=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=STtBFdvF6uqFLu0wWQIJMM6fsUV4nmS9GpwRYg2IXCXPT9Bn5edDilPDsj85DgXFIp2CJnA30ocIzBJYW0O794C2RuhkMiUS/l3zuHSlihd9ILyrNj5RYwraGmnmPR48k/3L2Lb4qi8TT8uq4E8Ud0PZiWwiDVbem8USa24BfaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oa6/6gpU; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oa6/6gpU"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c0bb4a94b8so9619085ad.2
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 13:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780606761; x=1781211561; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DxKhicoquanRcHmBFTA0cKSjkW5cU988lyFYAH+YfGE=;
        b=Oa6/6gpUlk3C/dQ+AEvzvFPObjTInMBdXtqtptzrtwxUho2DFsvYWXDnCVJ7CYamzM
         2CaB6jK1VvPY737zWtms0U49pDB603CjvBOLGhh1syy3ZEiu4rgrasdqAj1qvo8aQzeW
         hVjtnmDezMebJRWVVFb3S4c+hhB2FUZiwVKpCxJufAB4v2AQqmGADLSYks++E/LpGjU7
         SAkfxVF3I3fvnDuPixJDqyfTCS3BkuTGJiafqUMT2wCKCkcOENt2SLmVraudCStfS15e
         KYCnzbwCOhBe9HiTRf4hPbLssrUZRuN8sM5s/aCxRrnb8q+6YPoJYC+eimupNJg31dpJ
         9mwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780606761; x=1781211561;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DxKhicoquanRcHmBFTA0cKSjkW5cU988lyFYAH+YfGE=;
        b=pA1awQuE8xT23n/f3iiHAVxSsW33jzm3lcEaDcvYLqncNsw8qytG+3oPYnDMNmW2vy
         uHpucmodeJUvOy4+egnUxzDF3vxcPS/IjhsTDJpwWB5yW1zH2mQ1YDmLEg/YZEtLiluy
         ahHEOTrwB93TF0XFoW4qsNuPUVcmtc9l/4gWhyJsoxQX7d6XN4eyB8wRxxH7vQpXj+GQ
         K/lS7J69g3jPvneozV5Fj4Kh2K+QY++mnhgeLjcNQNOQv51h8qGPO6DgiWQkwz5qYctG
         RailJsRTDrTV/V+vTK4pczx6+6mHsNoz2XIFkGwY2F5IsSd3ECPb9ltehT2Nq+XxW5jh
         M/hg==
X-Forwarded-Encrypted: i=1; AFNElJ+Wte+vcmwlOu3phXQFeClfV9LvpAAgUxOeXkjlsQiYsGvO1CV+OdQH2vUIK5pnroJq5mdCJ2I=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaOAM3e9plZQP+Iy52XxzQmBSDE8L/5jkS3OY8vYHE6mbp/QS1
	lrhsvk9Lr7pEAbrukvBI3sQAz1xIdSfhkju5golERrcJs4GKNM115XEL
X-Gm-Gg: Acq92OHEpYXfkKc6WhT4US8N2YRHqTj5WOO0tVIPFKlh3dMAwRh6+4aaqSONTAxYk3e
	XFBfjg7WObg4micWt5SlpYpIIRIv6bmP+lUjOcq/29dEunIp4mrjglxh+wk3w7UPwYeaetweHy4
	U7uovTxqT5gnuVrPlBGaUaPIQgc2F21Fnqx3NKfU9xwUT0IjQt1SWMyt4viYPQ8hczOK9Sklbii
	XUKyD/S/bm/yu3z6+SygUnEv4VWbl9pcH20SKJQUJsJk7posXFtnFyY2sZd6L1Q8yEn2cpN7otG
	mouOT/hniJH2NhAXcP3GqrfCiqr1UCSeutU6e+THCeCRvlPBUqeKzLv4lq/RR1dA1QrYjrrELtC
	JWjiWwfgPabWhdqm+O1PatR7ZLCu+HJaZFsZ8eCyz9CdTTD3HzIAu278JgaZyMGqMZFplzqna43
	4Z9KDkRMxaS7/0eRRVBX/H7z+CMK443MeIUXLi3inO+P0jX+u5+BwIBg==
X-Received: by 2002:a17:902:fc47:b0:2c0:eee2:fc45 with SMTP id d9443c01a7336-2c1e7b2f6c7mr2868755ad.4.1780606760717;
        Thu, 04 Jun 2026 13:59:20 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6e294sm67453635ad.6.2026.06.04.13.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 13:59:20 -0700 (PDT)
Date: Fri, 5 Jun 2026 05:59:15 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, Sascha.Bischoff@arm.com,
	jic23@kernel.org, timothy.hayes@arm.com, eric.auger@linaro.org,
	christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH] KVM: arm64: vgic: Check the interrupt is still ours before
 migrating it
Message-ID: <aiHnI1mu6SGQrgnz@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

vgic_prune_ap_list() drops both ap_list_lock and irq_lock while migrating
an interrupt to another vCPU. After reacquiring the locks it only checks
that the affinity is unchanged (target_vcpu == vgic_target_oracle(irq))
before moving the interrupt, which assumes that an interrupt whose affinity
is preserved is still queued on this vCPU's ap_list.

That assumption no longer holds if the interrupt is taken off the ap_list
while the locks are dropped. vgic_flush_pending_lpis() removes the
interrupt from the list and sets irq->vcpu to NULL, but leaves
enabled/pending/target_vcpu untouched. As the interrupt is still enabled
and pending, vgic_target_oracle() returns the same target_vcpu, so the
affinity check passes and list_del() is run a second time on an entry that
has already been removed.

Also check that the interrupt is still assigned to this vCPU
(irq->vcpu == vcpu) before moving it.

Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/vgic/vgic.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1e9fe8764584..18b280de9a29 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -818,15 +818,16 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		raw_spin_lock(&irq->irq_lock);
 
 		/*
-		 * If the affinity has been preserved, move the
-		 * interrupt around. Otherwise, it means things have
-		 * changed while the interrupt was unlocked, and we
-		 * need to replay this.
+		 * If the interrupt is still ours and its affinity has
+		 * been preserved, move it around. Otherwise, it means
+		 * things have changed while the interrupt was unlocked
+		 * (it may even have been taken off the list with its
+		 * affinity left untouched), and we need to replay this.
 		 *
 		 * In all cases, we cannot trust the list not to have
 		 * changed, so we restart from the beginning.
 		 */
-		if (target_vcpu == vgic_target_oracle(irq)) {
+		if (irq->vcpu == vcpu && target_vcpu == vgic_target_oracle(irq)) {
 			struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
 
 			list_del(&irq->ap_list);
-- 
2.43.0

