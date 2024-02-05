Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F385E17586
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129289; cv=none; b=rTelUqr44SVo6p3RF/gT3r0B0/NrciLXLroVPf7jn+VNCN5QSXePKL8fZe9q5cT7wsHWPJ4b7EzogA+Keim03jQzxdNCsnYtF9sZrjtTuy/9GcILZDymtSFtTBZn+5Fycz6INqKiEBayJkLsmW1hD+/RGOf1VxCtrj+NlDB84TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129289; c=relaxed/simple;
	bh=dPKdXan4l5AaxJXUMKbdMXX5peIFbEULFEDKVd3lkHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q5dCUo9cC/fKtfWqUJTVDb8bj0oYAcxfJVg8B1/Aao/C2/0c/b2yXrLaopQGRpk4U7fSRNvEnm+46F3EWW4EuXIcWYuODwHUqBq62E+zMAev2p3v333Yu69+Id7dey5p5v2wE7XXcAoq9+BCe6MdLp1NrKTRWbgm70sFfTXce+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuqHlXEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuqHlXEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C785EC43399;
	Mon,  5 Feb 2024 10:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129288;
	bh=dPKdXan4l5AaxJXUMKbdMXX5peIFbEULFEDKVd3lkHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuqHlXEc4MrYSSsep+2zRQfHyRG2/3p7pjhZFnHkZX51y1iLu5X74QU6VrAFNOhqp
	 /me/+bQLfkmCOrF6f53YODW4s+BooGv3/Rs7OWihUYDyp2VL5hybFGeRBrjJhGPn+s
	 diUHM+TdCyzQ2X5YlNBtGaKuAgXsYX5MhnfhNLiJXk2timqjx/oI1kQVb68kVYMQ+Y
	 xvrdXfr4U4Z/LCPbE3DNxAfdkdbpzc4LnzoOXNoHns8vHsUbWBhM341mX6lTPkU2/v
	 bezTAV2lLyg8Jq6xNY/6tFspL2M/PP2qF9oss+RVJxO64u/kFOnveuEwVJUe/3Nh++
	 hO5rFSNmE/xcQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJL-000Nc3-1L;
	Mon, 05 Feb 2024 10:34:47 +0000
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
Subject: [PATCH v3 11/26] KVM: arm64: Drop the requirement for XARRAY_MULTI
Date: Mon,  5 Feb 2024 10:34:16 +0000
Message-Id: <20240205103431.1104133-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
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

