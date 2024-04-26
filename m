Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D2C1487C6;
	Fri, 26 Apr 2024 13:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714139674; cv=none; b=SlKbVdNCVYZEifojl+dB0XaEL1zcSJn9yp38qkljSf/4Zx7limv3sx/4dWZou2OvK8c8k8nDX1vJVx0YbN6wsbewiw7yccNCfl0gkAZv8T0QdN35IleK8201bdOLAfhdUedfvZ8lH3LIwLCdcdeCm723l3WW+yKL7k4YPOVpfDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714139674; c=relaxed/simple;
	bh=XzlBEvzmaHxv8L38RsHV7BNKS/eL1vkrGnnq6JM9ZAA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P89hhFb8HoR2teJCzCt1mwNs5zdrLR++iL2b7d43Cx7LsSFNOtYlY05f9d1OCQZenIcfLe43CTObBEaHi4Oh8H5A7+M1ucyO8pGn5gt4C4Xh7iM16poB+PFRxZyrV3ineVvTBNOO/Aq9AjxKNROcX6CfCzq2ZIAvnrLGXrbfCDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VQvNC2wp6z6DBBW;
	Fri, 26 Apr 2024 21:54:19 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 0903F140A87;
	Fri, 26 Apr 2024 21:54:31 +0800 (CST)
Received: from SecurePC-101-06.china.huawei.com (10.122.247.231) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 14:54:30 +0100
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
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier
	<maz@kernel.org>, Hanjun Guo <guohanjun@huawei.com>
CC: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, <linuxarm@huawei.com>,
	<justin.he@arm.com>, <jianyong.wu@arm.com>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH v8 06/16] ACPI: processor: Register deferred CPUs from acpi_processor_get_info()
Date: Fri, 26 Apr 2024 14:51:16 +0100
Message-ID: <20240426135126.12802-7-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240426135126.12802-1-Jonathan.Cameron@huawei.com>
References: <20240426135126.12802-1-Jonathan.Cameron@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

From: James Morse <james.morse@arm.com>

The arm64 specific arch_register_cpu() call may defer CPU registration
until the ACPI interpreter is available and the _STA method can
be evaluated.

If this occurs, then a second attempt is made in
acpi_processor_get_info(). Note that the arm64 specific call has
not yet been added so for now this will be called for the original
hotplug case.

For architectures that do not defer until the ACPI Processor
driver loads (e.g. x86), for initially present CPUs there will
already be a CPU device. If present do not try to register again.

Systems can still be booted with 'acpi=off', or not include an
ACPI description at all as in these cases arch_register_cpu()
will not have deferred registration when first called.

This moves the CPU register logic back to a subsys_initcall(),
while the memory nodes will have been registered earlier.
Note this is where the call was prior to the cleanup series so
there should be no side effects of moving it back again for this
specific case.

[PATCH 00/21] Initial cleanups for vCPU HP.
https://lore.kernel.org/all/ZVyz%2FVe5pPu8AWoA@shell.armlinux.org.uk/
commit 5b95f94c3b9f ("x86/topology: Switch over to GENERIC_CPU_DEVICES")

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Miguel Luis <miguel.luis@oracle.com>
Tested-by: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
Tested-by: Jianyong Wu <jianyong.wu@arm.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---
v8: Fxed spelling of my own name...
(tags picked up)
---
 drivers/acpi/acpi_processor.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index ecc2721fecae..88108aecbcfa 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -357,14 +357,14 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	}
 
 	/*
-	 *  Extra Processor objects may be enumerated on MP systems with
-	 *  less than the max # of CPUs. They should be ignored _iff
-	 *  they are physically not present.
-	 *
-	 *  NOTE: Even if the processor has a cpuid, it may not be present
-	 *  because cpuid <-> apicid mapping is persistent now.
+	 *  This code is not called unless we know the CPU is present and
+	 *  enabled. The two paths are:
+	 *  a) Initially present CPUs on architectures that do not defer
+	 *     their arch_register_cpu() calls until this point.
+	 *  b) Hotplugged CPUs (enabled bit in _STA has transitioned from not
+	 *     enabled to enabled)
 	 */
-	if (invalid_logical_cpuid(pr->id) || !cpu_present(pr->id)) {
+	if (!get_cpu_device(pr->id)) {
 		int ret = acpi_processor_hotadd_init(pr, device);
 
 		if (ret)
-- 
2.39.2

