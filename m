Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB29E71B32
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647549; cv=none; b=FHYgbZxci9u9ntjfIKxP7/CxkH4sxBuSRkW0NpWTFGCKQv1/a6Sf/nDQdyMjfLyHh7c2xrh2gJGWUNTQ/4gPHQoOnPxI6GbtGJnmBSLKTDATvmr310zQKBHWlPyzGzKL9+QQmxhvIQQFmPwKSygtDoHQFB94gQIfb1M5hHSLkXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647549; c=relaxed/simple;
	bh=dPKdXan4l5AaxJXUMKbdMXX5peIFbEULFEDKVd3lkHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sqJ/0pLKUDfkvcw5InVAlJmIWY6o7EbiQiMsiHbmuRp+XkJEekmCvwmC85wNdRDpt4X2UGJliJUVQjCPr8XGMQ7xhqW7O0uErjpG0Gi0Xiz2tCm1m6rczNCezd0aM5EsItJu6tDy9sjGtjBgCjD4l3koB5XLe65/rcGnzLX56CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mchHqElg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mchHqElg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CFFC433B2;
	Tue, 30 Jan 2024 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647548;
	bh=dPKdXan4l5AaxJXUMKbdMXX5peIFbEULFEDKVd3lkHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mchHqElgJezVdgy15oO574XuDDQL2v7kGipB55RDrmzWHT1vXHgCERnb4zTKM2ARB
	 2UVbCKA8ZJ1Z1I+MTKVfUR8wT3UfmP1umHJdDji4Urd2WFSOAl9b+L0RkJJ/7Hrmw5
	 255Zu/cIky4277g8WZDCP8p3Jq4dKPDkXLxvfX3nT0wps5vutsYwxPo7oo6vcYnvoJ
	 VLcf6Uu/wud60ObOKgZ6j8Cl5mWSRYFV6YCSK191X2I/3rJ6wIAFw3ZYCN03AtB0p0
	 BkEqCA8WtLce1OZf/1k5+kb/bwNSuarN5aMdehyMa7bosQKc/HouCqJVCJMm3N0axt
	 kT0kIadBS+G0w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzK-00GNsE-Vp;
	Tue, 30 Jan 2024 20:45:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 11/25] KVM: arm64: Drop the requirement for XARRAY_MULTI
Date: Tue, 30 Jan 2024 20:45:18 +0000
Message-Id: <20240130204533.693853-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we don't use xa_store_range() anymore, drop the added
complexity of XARRAY_MULTI for KVM. It is likely still pulled
in by other bits of the kernel though.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 6c3c8ca73e7f..5c2a672c06a8 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,7 +39,6 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
-	select XARRAY_MULTI
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.39.2

