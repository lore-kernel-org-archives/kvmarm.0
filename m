Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7B8160790;
	Thu, 18 Apr 2024 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713448518; cv=none; b=JqaCNMzXi3gpzg028kw947EsF9xG2rdIzFtd1pcGtUmCeC6TwhncwzpDRs5vnGw+R9QQa6UQsmVjXm3Ggz0t/MYFAn1fNk/CCC6SRj1tPDBkX19wG7lnlD/OlrMQl5vGhFtqgDR7xtVHmftdrXE3c0Nlpa3aLic94Ly/BinkzQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713448518; c=relaxed/simple;
	bh=8YdjqTW5LrOhh9bRGI4v7+bpk8jGAptG3mXdXeuigWw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A1gJKgopLNfFwBymPRrt//W5X3SzHEFmc9yfvB7LcwbbX6S0LZtRhqufdk/11J7rCcIOYHp44Q3kWACXL+MYrFFUtPp2WSPwkeKXENXSD5RTP+ba3Uzt51rxJvcGOrhM6H0znNnedYIMCgyO92bWsCoD+PI8EyGilGXDIx1i8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VKzkc2JbSz6D94x;
	Thu, 18 Apr 2024 21:53:12 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CC601406AC;
	Thu, 18 Apr 2024 21:55:15 +0800 (CST)
Received: from SecurePC-101-06.china.huawei.com (10.122.247.231) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 14:55:14 +0100
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
Subject: [PATCH v7 02/16] cpu: Do not warn on arch_register_cpu() returning -EPROBE_DEFER
Date: Thu, 18 Apr 2024 14:53:58 +0100
Message-ID: <20240418135412.14730-3-Jonathan.Cameron@huawei.com>
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

For arm64 the CPU registration cannot complete until the ACPI
interpreter us up and running so in those cases the arch specific
arch_register_cpu() will return -EPROBE_DEFER at this stage and the
registration will be attempted later.

Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
v7: Fix condition to not print the error message of success (thanks Russell!)
---
 drivers/base/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 56fba44ba391..7b83e9c87d7c 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -558,7 +558,7 @@ static void __init cpu_dev_register_generic(void)
 
 	for_each_present_cpu(i) {
 		ret = arch_register_cpu(i);
-		if (ret)
+		if (ret && ret != -EPROBE_DEFER)
 			pr_warn("register_cpu %d failed (%d)\n", i, ret);
 	}
 }
-- 
2.39.2

