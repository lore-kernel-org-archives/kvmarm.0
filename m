Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C1B29B8D0
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 07:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756970914; cv=none; b=oa+nST5UuUOyR9/gTl1OSknAvNnEnpb/EfGigZvwT6QyGzOwP89gmmTdb62zpmkYoWoXM0J95t3GELwNnPm8cycBoUHV7qR57llHwEoLGApt6iXvqvhZRzL8wSCsJnROX3+YJFL8pF5sv5OnQX5NBYxLdn/H3/LjaBpvMrOvX4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756970914; c=relaxed/simple;
	bh=YwrXeTrhmmj3cmYkXhfGgMLAkqhL/U3SC3PoesZOlyI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qXccbLb9ILqoRWdXsfYP3euliHQheTQHXdWn1HID6xUfxiSIEDszR8S8Enx4a1nJ0U+JFATTGmBxGwupY113ElxgouHOgwWhOWTZAeg2BwJunHPvtpuXpi7ivdRTfgd4nIgevkIC7MjsmA7AWdyi7CSY/hwMsZqjbAH3AETzoi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=enraoxnw; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="enraoxnw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756970910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ViD1vkkdB6dd7rtduUClJej4q8lCMsu2TXtuwBlRXew=;
	b=enraoxnw3xxFE9mf7j6dqwR3Li+LV+NrFhm061Zz5noCOy8snCdqlswAF8uIRFZvFGZSSj
	pZyp5CYc+TqppleYtzdkh0Er9Xw8xpqmGe6V9wNiqVWis47rG6eJ7drsSh6LovPrDBFIpv
	mv+1QGZXZ0H2ErE0J0gk4io/MF84hRY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5/5] KVM: arm64: vgic-v3: Indicate vgic_put_irq() may take LPI xarray lock
Date: Wed,  3 Sep 2025 23:23:48 -0700
Message-Id: <20250904062348.223976-6-oliver.upton@linux.dev>
In-Reply-To: <20250904062348.223976-1-oliver.upton@linux.dev>
References: <20250904062348.223976-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The release path on LPIs is quite rare, meaning it can be difficult to
find lock ordering bugs on the LPI xarray's spinlock. Tell lockdep that
vgic_put_irq() might acquire the xa_lock to make unsafe patterns more
obvious.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index a21b482844ce..e61b95167ed1 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -142,6 +142,9 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
+	if (irq->intid > VGIC_MIN_LPI)
+		might_lock(&dist->lpi_xa.xa_lock);
+
 	if (!__vgic_put_irq(kvm, irq))
 		return;
 
-- 
2.39.5

