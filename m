Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ADC211460
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 02:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756090057; cv=none; b=RJezwdMjizi2yZONVdTPk6S9JaQOlXOwoUdyflOZoc2ZcuCKTYUhZnWsFapVScyljfXn0wMtr/C3m7B9gzgaotLEAD+JB8k2EtTip/zN8LK06pAcbWLOAQXqqmC9dy9UOhqJhzhmvveANoVz//l6V+eN+SQ8MG5DhhJ+Xj6HDpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756090057; c=relaxed/simple;
	bh=TQIQVJIFigSxW0N3ZANj2FNDWLPqmr/a7nhoLAPjrFc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m9vqBBguFxH8DW5rmmQEEhmocY3lJHWkdh69t52t/qQETAO7zXZrfGHKLru/cCe3IcnJDLmvUAxy9lWbK0i8qUI4UJAjidXje6ST7N84+Q8OoEFuJh9koxJvfWigPwxA76+cd57N7uBc/OtD0MOd+DMS9KbZzuCdiuiugDQYuCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c9FW91nmCz24htJ;
	Mon, 25 Aug 2025 10:44:37 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E1E95140276;
	Mon, 25 Aug 2025 10:47:31 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 10:47:31 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 10:47:31 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <tangnianyao@huawei.com>,
	<wangwudi@hisilicon.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v2 3/4] Documentation: KVM: arm64: Add GICD_TYPER.num_LPIs writable description
Date: Mon, 25 Aug 2025 10:39:53 +0800
Message-ID: <20250825023954.3516381-4-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
References: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200004.china.huawei.com (7.202.195.237)

Add GICD_TYPER.num_LPIs writable description.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/virt/kvm/devices/arm-vgic-v3.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index ff02102f7141..f4bd63e10b99 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -127,6 +127,7 @@ Groups:
 
       * GICD_IIDR.Revision
       * GICD_TYPER2.nASSGIcap
+      * GICD_TYPER.num_LPIs
 
     GICD_IIDR.Revision is updated when the KVM implementation is changed in a
     way directly observable by the guest or userspace.  Userspace should read
@@ -142,6 +143,11 @@ Groups:
     to determine the supported value(s) before writing to the field.
 
 
+    GICD_TYPER.num_LPIs allows userspace to control the maximum value of
+    supported LPIs. At VGIC creation the field resets to 0 which indicates
+    maximum value of supported LPIs is defined by GICD.IDbits.
+
+
     The GICD_STATUSR and GICR_STATUSR registers are architecturally defined such
     that a write of a clear bit has no effect, whereas a write with a set bit
     clears that value.  To allow userspace to freely set the values of these two
-- 
2.33.0

