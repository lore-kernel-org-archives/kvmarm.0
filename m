Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024716;
	b=ZgNJHm0i7r9fqw2kigYkpcC15uS/DVYfAT9I/pcGCDmVcgX/vlxIRmxAHDhmTKyr6Lv1
	 j7NocDzDrDqXCsEptKG7Gceg35EGWUybl2UMtOdmS+QYY6UKwr6cQ8LCJDpkBNvVXYEYP
	 ihSpZ3mseqkd3vfVyAN5UsFvLtw48qFJdWIGzDQw90rUoU0wwi70B7BWdqBR469MXixGh
	 ksg2YGDlv4x4DPwhxPddPoGiw/dI23S1+Y5EagvmyRILwLPt6v+EezTkaVVT6qrLt2iNu
	 Q9INvyZcK7hM/EzG2szASx2tHDHs9M2CwclCS5POSVXHw7Sphl29Q3PvTY4/H+H291Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024716;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=a1rYG1TalQ9YJsdpzA/JS3EHWX9ayK0ZVdBj8cqmZ40=;
	b=osBKtAMGySU8JgvA1/1lIPjhtTLIFKVO4apkS6wjPD7ZXX3Lk5ftl8IDlLm/x9OHQQlY
	 HgZX115temAyw8Bx6Ac06h83IS/kfZ+3igTbYzUByeETDveC9ZeVebS7Dxp/7QK6Itmy/
	 cV37dgBWPmDBseKLdlkI6/IY+jF9p0XDSy7bYt9O4nEKzUSeKCa2qsPRJJlG6M7IXuVEZ
	 u/0YlIsc63rdUBu5EcwD0/0T4x7IPY9C4dTTrmMhsfZtwAmA6dsMd0Vd91JQ8B8WmwD56
	 68T28DY2yq5SJDM39FhjM4iY/c6zP227llVC/R8laWWXVkY4NDpq3F62TdYh448uM8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XUorBv+5;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCF7606A331
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CCF7606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XUorBv+5
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B952B1477;
	Wed, 18 Nov 2026 09:58:32 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61CD73F632;
	Wed, 18 Nov 2026 09:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024715; bh=6LC0Esz0vtaHqOKJrOblFkqFYsHjYoYynkmx3V1YY8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUorBv+5BYXRmwmIWIfIyz+4MgwsWz0U87h+LHxBUHSQeUvhU2DThAAs3CormI+5w
	 Lr539mChwoOlzp2NPE0pOtVLIoLj/Hm3wuTiduKBVYBctaoZsbN/n39w62PNPGiflw
	 ZmClNw5N21e6+6N1EGEcyVrINI22MLDfWFrxVnGI=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 07/23] irq: Allow the initial interrupt line number to be set
Date: Wed, 18 Nov 2026 17:57:39 +0000
Message-Id: <20261118175755.1946977-8-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow callers to select the initial IRQ line number before allocating
any lines. Track the selected offset when reporting the number of
allocated lines.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/kvm/irq.h |  1 +
 irq.c             | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

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

