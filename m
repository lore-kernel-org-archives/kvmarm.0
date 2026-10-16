Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4D54FE2D3
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165254; cv=none; b=nPCPEwLuaFmyPAwSwQ60v1SDyLaoPWcho/hGubkLFM0LDpueIDOoO+NyM9ilr+tSvCqTsYrkQbZbfMfFNjy6zXdsVy3nGCvcBOnfDa42ylZJPd8yVZykF3Oz7BwhkwtjSAiLuY6imTw7fZX0ZexpCDUELXzEsIcLegn8Ycmwfnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165254; c=relaxed/simple;
	bh=XACC63SfK2iN2Pca4ahKzDDrrGl4Z5xorcS9RRjHOMs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mPxByYosw0uSlLL+OHi2SCWseW1EvKj8tFdBLypTGpg2iZzfP4nA8pzR8gzaqMMVvsCuF0iXH3utRACR480VmDpgbLEZoYB05AuJyYivf+Hoa291CDlCQXc8we/fYr+2UmmTbk7YYx8nyQTMoY5kwgtUdKef8ceJwUSZAtzR0ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iMgw8Elf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iMgw8Elf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1727E143D;
	Fri, 16 Oct 2026 08:40:49 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A7423F673;
	Fri, 16 Oct 2026 08:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165252; bh=XACC63SfK2iN2Pca4ahKzDDrrGl4Z5xorcS9RRjHOMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMgw8Elf1CE/VlRx2Y2whrGVYAYJEQ8kmd6LKdZCsFKZbd/ycZWcC4jhm71Y8Ms8g
	 XawzYQNyJXbQUw48WAyLZPJ8SloKAwf7bTcDNOB6yhyZV+LHIrqDDzOVoF+bIQQf5v
	 OWkOXqqa3cq7093umW5Yh4mgL0wz2PvuSOrESBeU=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 08/21] arm64: Define GICv5 interrupt types
Date: Fri, 16 Oct 2026 16:39:26 +0100
Message-Id: <20261016153939.913764-9-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the PPI and SPI type values used by GICv5 interrupt specifiers,
and the type-field shift used to construct a full GICv5 INTID for
KVM's PMU IRQ attribute.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/kvm/gic.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 991aa912..bef871be 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -10,6 +10,10 @@
 #define GIC_FDT_IRQ_TYPE_SPI		0
 #define GIC_FDT_IRQ_TYPE_PPI		1
 
+#define GICV5_IRQ_TYPE_PPI		1
+#define GICV5_IRQ_TYPE_SPI		3
+#define GICV5_IRQ_TYPE_SHIFT		29
+
 #define GIC_FDT_IRQ_PPI_CPU_SHIFT	8
 #define GIC_FDT_IRQ_PPI_CPU_MASK	(0xff << GIC_FDT_IRQ_PPI_CPU_SHIFT)
 
-- 
2.34.1

