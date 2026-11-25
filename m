Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619670;
	b=O6R8SvHPw9yz/lKgedK3b+trVqYQKHka6abARSJf9m0PVbnB7wo6PbAb6k/LblHkwfjR
	 NgJfmUMKQLsL57lcwGvbRQyJKYqThL+SC3pBrA43Y3itnvjcdJIFrTHRGrFlDfDB06SVR
	 nxb595ytSCII9Xfk2zsr21EmbLsnjA8oV73T9FUTX+4iEawEHn4ET001XBn/Mxo6WXmBr
	 mqW5HBcQWzPnWnCWB0v25eki7CiTH+RrzpTJZdzSu/xV9rNUQ6Cok8/TCuioKXkoERLED
	 pLMkhcMms9lpSNuWSTloJ/pLc+hybfTw31lQXvFIlMTA2Nvzug/iBlVgSL7BlWlTgaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619670;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=a1rYG1TalQ9YJsdpzA/JS3EHWX9ayK0ZVdBj8cqmZ40=;
	b=cezYtHPoI8Vz2PEsKs1CFrjI3X+VOYBSVE0WGcCAu754OZ3qv0g183Ua8wPFBQNiWdI9
	 96z23wAF4Iok1qzZ76FDQklmHjIA5vMND6q73TdZWWwD0MOqX8e//l1ALBOjqaZ4bfCFs
	 6FO6dKOBNvhDdidleUHRIKnoTrYKvsXlYQ3At7iYV+sIElYNx8l6wib0O8A0SoAPauSij
	 NtzdRkOw6giNur7uEgqMsloEoEjVinP/4GMSvinWu5e2D/F9QH2PvLGtB12oWaaDfHStm
	 dZ9bm87BXZYr45gEVPh91BQ9IuIX1kUoOag1oDMpiLLaZ6cqGlPjcg0JQoOP5SJzBsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZHG6tb3w;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73119606A32E
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73119606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZHG6tb3w
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CF56175A;
	Wed, 25 Nov 2026 07:14:27 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3DD03F86F;
	Wed, 25 Nov 2026 07:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619670; bh=6LC0Esz0vtaHqOKJrOblFkqFYsHjYoYynkmx3V1YY8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHG6tb3wXZYWEyFQ0SW1+lY/7Vu5/Og2YQxg5b/P8XqIOtOurAthuLuCUdUAai74J
	 Y+pBuIX2TMVc3tyH1T4ijLe3+k5NLv+Orl39uMhP53QhDdOB8p1UmfYcjRWflf7k5k
	 lrk+qRLEliicNiG5+i78ydb1W4GKB5q2ne6mL8fI=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 07/23] irq: Allow the initial interrupt line number to be set
Date: Wed, 25 Nov 2026 15:13:40 +0000
Message-Id: <20261125151356.2875108-8-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125151356.2875108-1-sascha.bischoff@arm.com>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
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

