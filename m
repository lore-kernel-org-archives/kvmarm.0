Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2033640C0F
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954740; cv=none; b=aUpE3bA/JL0wr6XWMvdpssudg9c5XmpXefW7gzJF1Ncq69gitbzeFhqO6YoPhUTFbqdeKsJIdSMK9SnEvVFj1QnTolJuG7aTp3lr76hv1r3FoHrfjtt7LeNFc8qzVmct2scenqHmOdlKv/NGLO/Lov4zVNSBsV/Xy8+sy6Cf2dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954740; c=relaxed/simple;
	bh=iFa91kcb+QoO5LC7OgcPKyS9rfZ+WFbcS4z+Y+bqeA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z7aLfHFVfQAmi+SeFgYG281vNIjIbrep83/neXVxogy0A1QDu0ZJyttizoHbNSomYfqW9TLxVhJCRmk66sZAZZl1K6zUJuxssj5JNEzhfqDgWvFBbxXfZGryN9MYmj6Qo9QaaFLSYy9vKamKowfEb/0xiTYFYTdXm3D0golazgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOH0+fNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOH0+fNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A408C43394;
	Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954739;
	bh=iFa91kcb+QoO5LC7OgcPKyS9rfZ+WFbcS4z+Y+bqeA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOH0+fNtrIUwPWUK6BNmcHcOFn2sMrJFoTEA8VxHps+lbDegKeS7nMNMQhv6EGRMG
	 s15DYSwOz25Yk010l3y6Qt3H+CWtTH6aZk0tLacdBzW9vEa8zDKY1s1ecCd5SA5iCW
	 JeRcMYVu6Q9bNDm+FMBQpNFR0egohD7WdUSPK3X3NwwXAfg1vbu+CaDhPXRZ1RD8HO
	 Jn4bzRlU2MIBvF1gHdR0kU/ZaRWJy5V038tULc3sjZyc6mIoJf4CMlz1T9wGo8Dw/Z
	 YA7vWgeK/XL3Mo3EmRXYw3l1VQtPYSSBN1euOu68T/Q2bybidnKt/tcJqTDasiL5Ko
	 c+Wlyy8TCcO2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0kz-00DjkQ-M4;
	Mon, 22 Jan 2024 20:18:57 +0000
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
Subject: [PATCH 11/25] KVM: arm64: Drop the requirement for XARRAY_MULTI
Date: Mon, 22 Jan 2024 20:18:38 +0000
Message-Id: <20240122201852.262057-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
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

