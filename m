Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015264FC32F
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165239; cv=none; b=WPVOhpRuMSXEJuVO+DM3oPvk7g74MgmrVnatfOjh62k7OoAQYnVzx5AAaRq+9ac5n2UagWO0KbJ9FJPApbPPhfc3PYBYyLqpePaHTIw8HL7VIadhr6LN/Ba1+ClVFhzNjta7V3d3ocBGzKZ+7LrF2Xv5ckAGqA2E18znM260c4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165239; c=relaxed/simple;
	bh=8WFCN5sOhr/wPIvnIZhtBdogEAJ77L5Um5AZqBPDWIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j4qVoa4oZYz62A+h2Z9jKSOg24i7e0HqR0nltA96Z4nuMvgXS46WNATY/3nUgTAdSK4sGPAY9bdc34UtP2yyqZYwLvP6dUjIN61FQkjBCoBzsLdK3j4CyABgnZKJ7aYlcxdSVbLt7VrZYa/W8WcJQf5AzqHmXCxV2/ZuxxRXVwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GTR5nrWj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GTR5nrWj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 314B0143D;
	Fri, 16 Oct 2026 08:40:33 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DCDF3F673;
	Fri, 16 Oct 2026 08:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165236; bh=8WFCN5sOhr/wPIvnIZhtBdogEAJ77L5Um5AZqBPDWIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTR5nrWjQ8zMUfXf8aqEdEkjUxeCKpXafZu7BejlfxkFF4miQm8PB/rhl3XwtQ/fK
	 b8iifjft3s1/4c4leRYvye89yO5hpKTdrYhnr2yQSUMdH5vmhzIqg042oDHcN/ZKNH
	 lMaed6gwwZree9KnmKm+NdGZUvEUvruk0zN44cAw=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 06/21] irq: Allow the initial interrupt line number to be set
Date: Fri, 16 Oct 2026 16:39:24 +0100
Message-Id: <20261016153939.913764-7-sascha.bischoff@arm.com>
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

GICv5 SPIs start at zero, while earlier GICs use an offset of 32.
Allow the offset to be changed before any line is allocated and set
it to zero when creating a GICv5 VM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c       |  6 ++++++
 include/kvm/irq.h |  1 +
 irq.c             | 15 ++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index c1bd0771..23c68862 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -236,6 +236,12 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	if (err)
 		goto out_err;
 
+	/* GICv5 SPIs start at zero. Set this before allocating IRQs. */
+	if (type == IRQCHIP_GICV5) {
+		err = irq__init_irq_offset(0);
+		if (err)
+			goto out_err;
+	}
 	vgic_is_v5 = type == IRQCHIP_GICV5;
 	return 0;
 
diff --git a/include/kvm/irq.h b/include/kvm/irq.h
index 2a3f8c9d..17113979 100644
--- a/include/kvm/irq.h
+++ b/include/kvm/irq.h
@@ -23,6 +23,7 @@ extern struct msi_routing_ops *msi_routing_ops;
 extern struct kvm_irq_routing *irq_routing;
 extern int next_gsi;
 
+int irq__init_irq_offset(u8 offset);
 int irq__alloc_line(void);
 int irq__get_nr_allocated_lines(void);
 
diff --git a/irq.c b/irq.c
index cdcf9923..7c4bfec4 100644
--- a/irq.c
+++ b/irq.c
@@ -8,6 +8,7 @@
 #include "kvm/irq.h"
 #include "kvm/kvm-arch.h"
 
+static u8 irq_offset = KVM_IRQ_OFFSET;
 static u8 next_line = KVM_IRQ_OFFSET;
 static int allocated_gsis = 0;
 
@@ -18,6 +19,18 @@ struct msi_routing_ops *msi_routing_ops = &irq__default_routing_ops;
 
 struct kvm_irq_routing *irq_routing = NULL;
 
+/* Override the default offset before the first IRQ allocation. */
+int irq__init_irq_offset(u8 offset)
+{
+	if (irq__get_nr_allocated_lines())
+		return -EBUSY;
+
+	irq_offset = offset;
+	next_line = offset;
+
+	return 0;
+}
+
 int irq__alloc_line(void)
 {
 	return next_line++;
@@ -25,7 +38,7 @@ int irq__alloc_line(void)
 
 int irq__get_nr_allocated_lines(void)
 {
-	return next_line - KVM_IRQ_OFFSET;
+	return next_line - irq_offset;
 }
 
 int irq__allocate_routing_entry(void)
-- 
2.34.1

