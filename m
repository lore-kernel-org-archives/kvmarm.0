Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BF9535DF
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916715; cv=none; b=FPzRuA88T225rzcEQ57/1Tqh5cyubuQoqrVGhGrcHLIBvLzqM1+TpguV7BocRE1Wcyt0kqjUa235GVmBczqunhqnv8H9d9Z3NBi/CT5Ba42grEG5ykgRnSQBRW/8/CphaHMjwQ7tuqPpIKpcgLr29gKxPSLjVnPcsia1qnzDRqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916715; c=relaxed/simple;
	bh=dPKdXan4l5AaxJXUMKbdMXX5peIFbEULFEDKVd3lkHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IsagtjVQDuT/UjnzB6kTDI5IJlOb2z1n6X9AM16l/vwwu47O0+jCw1qrbvPc47ycTGewvD7zboL1NFrFaCUx6JCz+deXnbE1AdlF/YXOCHquSL6Gr9PH0bs8NJylwCwOPstCg5l8+cxAoqU5hs+TYCFH4lI/YO11tviVlbUhrR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3oxatDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3oxatDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1464CC433B1;
	Wed, 14 Feb 2024 13:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916715;
	bh=dPKdXan4l5AaxJXUMKbdMXX5peIFbEULFEDKVd3lkHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3oxatDnG4s6z+A61cPYn7couUwntOIAP/fdlaM75D/mCinx+G463rOJLMsrIlZdC
	 WLc71jarvgTUhHSFice/BoPA2DCIdxmWh//AsKlqIzEl4Ngj4+F/GDAQ3qFMR6eQcw
	 ylLPnNmfe4DTZ+vr8UNwA46ur0qVhP44M0PZic1jdUzlvQepWTlfwbXiDpLoxzjBax
	 +zCEeyaTQZ6RHcdQcE3ciayo1EPTrhpNIGWsqmMTuZ8cf7lZWbaFUo2k0QysEupxDZ
	 GWOOMPyXjHbhnDYho4aLoWauQvHQkKG6CmikoKMzXLrNZdU3HNapgdy7c8tN8v+NJk
	 ApnUXk22rVrNg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9k-00394l-VV;
	Wed, 14 Feb 2024 13:18:33 +0000
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
Subject: [PATCH v4 11/26] KVM: arm64: Drop the requirement for XARRAY_MULTI
Date: Wed, 14 Feb 2024 13:18:12 +0000
Message-Id: <20240214131827.2856277-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
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

