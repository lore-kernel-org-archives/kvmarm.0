Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D751422D4;
	Fri, 12 Apr 2024 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712932947; cv=none; b=Rpch0tz2rs1MMbAWDY/t5hn5rU2dY8eX+b0FNNf8DctSWJDF1ENxtCkm8Ei0XvC7XrmeEfNwEOhemM1PhxpmjJm2nEs9t0/ElTGkckwoTmxE0oXl89pvr2LJx5Z2GdWN6Xn6ZocNR3shxpzoH0B3eTVw5CIloneOQd5J6klXedc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712932947; c=relaxed/simple;
	bh=2GdqiP0JC/ghCLdQfEGwLcBG/F3i4l8nIw33SDUmodY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UBJ3mijiTZahZ9JiNc1eNga/c+FLZgqFBk1uH9TDjSyJmrjCT+SlnwxQnr0I3LJVbYHpgqCTQemKo0FT2BWdvSZCpOFMVpjSEArIYRr587Z7ErMxJP0n35t7k58wQimuZFII0RiZS2AoagXYvG8RCT3jq4z6go059JVYRNc2l90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VGK0Y3rFyz6K8wp;
	Fri, 12 Apr 2024 22:37:33 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id E15E81402CD;
	Fri, 12 Apr 2024 22:42:23 +0800 (CST)
Received: from SecurePC-101-06.china.huawei.com (10.122.247.231) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 15:42:23 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <linux-pm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <x86@kernel.org>, Russell King
	<linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>, Miguel
 Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>, Salil Mehta
	<salil.mehta@huawei.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
CC: <linuxarm@huawei.com>, <justin.he@arm.com>, <jianyong.wu@arm.com>
Subject: [PATCH v5 10/18] ACPI: Warn when the present bit changes but the feature is not enabled
Date: Fri, 12 Apr 2024 15:37:11 +0100
Message-ID: <20240412143719.11398-11-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412143719.11398-1-Jonathan.Cameron@huawei.com>
References: <20240412143719.11398-1-Jonathan.Cameron@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

From: James Morse <james.morse@arm.com>

ACPI firmware can trigger the events to add and remove CPUs, but the
OS may not support this.

Print an error message when this happens.

This gives early warning on arm64 systems that don't support
CONFIG_ACPI_HOTPLUG_PRESENT_CPU, as making CPUs not present has
side effects for other parts of the system.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Miguel Luis <miguel.luis@oracle.com>
Tested-by: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
Tested-by: Jianyong Wu <jianyong.wu@arm.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
v5: No change
---
 drivers/acpi/acpi_processor.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 0403eddb3f80..3fb167ee9807 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -187,8 +187,10 @@ static int acpi_processor_make_present(struct acpi_processor *pr)
 {
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_CPU))
+	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_CPU)) {
+		pr_err_once("Changing CPU present bit is not supported\n");
 		return -ENODEV;
+	}
 
 	if (invalid_phys_cpuid(pr->phys_id))
 		return -ENODEV;
@@ -466,8 +468,10 @@ static void acpi_processor_make_not_present(struct acpi_device *device)
 {
 	struct acpi_processor *pr;
 
-	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_CPU))
+	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_CPU)) {
+		pr_err_once("Changing CPU present bit is not supported");
 		return;
+	}
 
 	pr = acpi_driver_data(device);
 	if (pr->id >= nr_cpu_ids)
-- 
2.39.2

