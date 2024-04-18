Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CCD165FCE;
	Thu, 18 Apr 2024 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713448890; cv=none; b=vEuxg7JlWm7wnnxl8n0VozwPzRQV1i5llDWpQMD3Q7+h/fuTC4FQ/4ZLBI/ixlH2Wq1m+zaFbDmBOakxzR4WcA4e18MaXePW7W5XM/IqUzzjxUZ9oaWgdOWyiGBtyGAtwz1eTVOm+izoqINMYkch6ihWyHFlyODCa6ZasfDXe+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713448890; c=relaxed/simple;
	bh=SbGXeSLK8beeZDzTBZrZDvu/cJJOz8jYwN3LyQLDBxY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kOGtGS/g4jBjYMPuk9dmcEs3ibG8a2Bn24AolFhB3EyjWay5PIMD7PVZJyYJOdIIMo5q+VU4qOGZ5rYB/P1WmyIQVCNwviSa2VWcyM4JG2XssnkA687JSbb03ebny5YvapOFtS3MPcM5uik5/x1hQmd4BAl1uCOOQiXk9uk/dhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VKzsj6lgQz6K5r4;
	Thu, 18 Apr 2024 21:59:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 4E3DF14038F;
	Thu, 18 Apr 2024 22:01:25 +0800 (CST)
Received: from SecurePC-101-06.china.huawei.com (10.122.247.231) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 15:01:24 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra
	<peterz@infradead.org>, <linux-pm@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-acpi@vger.kernel.org>,
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<x86@kernel.org>, Russell King <linux@armlinux.org.uk>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Miguel Luis <miguel.luis@oracle.com>, James Morse
	<james.morse@arm.com>, Salil Mehta <salil.mehta@huawei.com>, Jean-Philippe
 Brucker <jean-philippe@linaro.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, <linuxarm@huawei.com>,
	<justin.he@arm.com>, <jianyong.wu@arm.com>
Subject: [PATCH v7 14/16] arm64: Kconfig: Enable hotplug CPU on arm64 if ACPI_PROCESSOR is enabled.
Date: Thu, 18 Apr 2024 14:54:10 +0100
Message-ID: <20240418135412.14730-15-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240418135412.14730-1-Jonathan.Cameron@huawei.com>
References: <20240418135412.14730-1-Jonathan.Cameron@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

In order to move arch_register_cpu() to be called via the same path
for initially present CPUs described by ACPI and hotplugged CPUs
ACPI_HOTPLUG_CPU needs to be enabled.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
v7: No change.
---
 arch/arm64/Kconfig       |  1 +
 arch/arm64/kernel/acpi.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7b11c98b3e84..fed7d0d54179 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -5,6 +5,7 @@ config ARM64
 	select ACPI_CCA_REQUIRED if ACPI
 	select ACPI_GENERIC_GSI if ACPI
 	select ACPI_GTDT if ACPI
+	select ACPI_HOTPLUG_CPU if ACPI_PROCESSOR
 	select ACPI_IORT if ACPI
 	select ACPI_REDUCED_HARDWARE_ONLY if ACPI
 	select ACPI_MCFG if (ACPI && PCI)
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index dba8fcec7f33..a74e80d58df3 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -29,6 +29,7 @@
 #include <linux/pgtable.h>
 
 #include <acpi/ghes.h>
+#include <acpi/processor.h>
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
 #include <asm/daifflags.h>
@@ -413,6 +414,21 @@ void arch_reserve_mem_area(acpi_physical_address addr, size_t size)
 	memblock_mark_nomap(addr, size);
 }
 
+#ifdef CONFIG_ACPI_HOTPLUG_CPU
+int acpi_map_cpu(acpi_handle handle, phys_cpuid_t physid, u32 apci_id,
+		 int *pcpu)
+{
+	return 0;
+}
+EXPORT_SYMBOL(acpi_map_cpu); /* check why */
+
+int acpi_unmap_cpu(int cpu)
+{
+	return 0;
+}
+EXPORT_SYMBOL(acpi_unmap_cpu);
+#endif /* CONFIG_ACPI_HOTPLUG_CPU */
+
 #ifdef CONFIG_ACPI_FFH
 /*
  * Implements ARM64 specific callbacks to support ACPI FFH Operation Region as
-- 
2.39.2

