Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DDE161900;
	Thu, 18 Apr 2024 13:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713448549; cv=none; b=a+qQTG98DouaufkUtCe7Uw5Myw2nlPZkU8h9ZlFyIerfe+fvT7iAkyxRBQHGcLSl62zd5aN+i21YUIRbS1Yo65Vz6sYQ/ch0QerBO6qIx6B9wxSE7rQ6jtfg5pciQBT1kP/lntJgNkJ+pboEytBicqHgWn8jlR8ZcvRg/fMbXhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713448549; c=relaxed/simple;
	bh=gyNFptB6Y3Qour6RrRLA3wJw/nrlgnS1Xva7X2273JM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TqYBzHZh/siUVRPwJOV4DvDlFF6t+FwexgGqJ/Q9wcH3fu2ZGoGnFNAnrkCf79e38dtQUKdD/f4YYy/aFN4IlFhjBjs7ZFNPxru4P11AITcAz1q37anwNxKrGEWbv/VVxbkbXprizLJ5MkEsYOh0zmSRNvViKZ9Bhg+n36i55Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VKzlB5l9Lz6K5xW;
	Thu, 18 Apr 2024 21:53:42 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 294431400CD;
	Thu, 18 Apr 2024 21:55:46 +0800 (CST)
Received: from SecurePC-101-06.china.huawei.com (10.122.247.231) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 14:55:45 +0100
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
Subject: [PATCH v7 03/16] ACPI: processor: Drop duplicated check on _STA (enabled + present)
Date: Thu, 18 Apr 2024 14:53:59 +0100
Message-ID: <20240418135412.14730-4-Jonathan.Cameron@huawei.com>
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

The ACPI bus scan will only result in acpi_processor_add() being called
if _STA has already been checked and the result is that the
processor is enabled and present.  Hence drop this additional check.

Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
v7: No change
v6: New patch to drop this unnecessary code. Now I think we only
    need to explicitly read STA to print a warning in the ARM64
    arch_unregister_cpu() path where we want to know if the
    present bit has been unset as well.
---
 drivers/acpi/acpi_processor.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 7fc924aeeed0..ba0a6f0ac841 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -186,17 +186,11 @@ static void __init acpi_pcc_cpufreq_init(void) {}
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 static int acpi_processor_hotadd_init(struct acpi_processor *pr)
 {
-	unsigned long long sta;
-	acpi_status status;
 	int ret;
 
 	if (invalid_phys_cpuid(pr->phys_id))
 		return -ENODEV;
 
-	status = acpi_evaluate_integer(pr->handle, "_STA", NULL, &sta);
-	if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_PRESENT))
-		return -ENODEV;
-
 	cpu_maps_update_begin();
 	cpus_write_lock();
 
-- 
2.39.2

