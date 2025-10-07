Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CEC226D1E
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 19:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759866825; cv=none; b=NYn+B+YstX6NCWUaSiISbe+13X/tUXglDRxeWVW5WPbD3lGzzI8naTWUYHriKW/+vmOapkFoKpy6Mz/yI5v3WTggrEQvqLSndHYnVy+NE+3NXqUw7jpU3esQ6B61uBqGbo13a7hmHsl2Sj0PDXsyBZqQUDLSubL8EcOJaC/sMW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759866825; c=relaxed/simple;
	bh=wM7pjPNUQXaPSUqgzFYiGhVBV3R4g0CyM+PxR0tqB9w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Eqab+55wb+Af3ChOWL8dnINnJyC8bFt38zDCMQB5xmK5YFqVlJs170zWZulfKDZ8ERYr8z4qoonzL9pRasirVV28Ky4HfWQFtB2noy6FUO/kW03+DCtR7L8VJtMpoYMIijQbfJbzS67nOQtq5rmtiteF+HRedTP3GwevdxeqOd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=twnB5laU; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="twnB5laU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759866821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Wqv4yv/75M/8EG1izdJCR0W8yLEK/nQi8TrcStoRvY0=;
	b=twnB5laUZinFozFN236+/ccYLfccCukNTFz7UrvN407msJ86hxub377ZcTq5cfHMDhd454
	a6AfyrkIDJ2xkGecSW7ogcdw7ELZw7eWKZPW29G7JSLDCU9bGwtapN24PLi/bb9hOBGl6c
	lxGXlCVEYX/8AJyPeOdfMsQOUnzhFeA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: selftests: Actually enable IRQs in vgic_lpi_stress
Date: Tue,  7 Oct 2025 12:52:55 -0700
Message-Id: <20251007195254.260539-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

vgic_lpi_stress rather hilariously leaves IRQs disabled for the duration
of the test. While the ITS translation of MSIs happens regardless of
this, for completeness the guest should actually handle the LPIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index 87922a89b134..b890d7d91de1 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -123,6 +123,7 @@ static void guest_setup_gic(void)
 static void guest_code(size_t nr_lpis)
 {
 	guest_setup_gic();
+	local_irq_enable();
 
 	GUEST_SYNC(0);
 

base-commit: 10fd0285305d0b48e8a3bf15d4f17fc4f3d68cb6
-- 
2.39.5

