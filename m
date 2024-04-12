Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F67F1419B0;
	Fri, 12 Apr 2024 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712932887; cv=none; b=ND286K4tVWQmrCWotrcIdZ/GX6UCgEgS2nL7kpp8Yoh8VTYVYIWdyyanr7sGqXpI1wIJlPJ6QToTb4NLYHMOzRS9sf/apB7rLg3NAiXuJauzd1C3c+15guGmjxQNLVZxG4IWKHRzy9eLQel4OsCQ7q6fus07PPoAYUHAFjo/fck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712932887; c=relaxed/simple;
	bh=h9Q/p4u1h1HqfFprhL65by7i9QVZUBczkA6t+LZrQF0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YKqQ/BnU9euEBd656n1X7j5PhWvtQRAQut/39GsYPV/jk4Jh52NbzqOyPDs8tCynwoQvt8NNjvwX/2Q6O0RMfamst0eQedNA1X3P2vJtk+SFctnF3zUj0IOpVtV0gj+6HpNi2j2FtEQzJJOaI94Px7IIO6U72cQkRQxbDViKixk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VGK2x00Ksz6JB2x;
	Fri, 12 Apr 2024 22:39:36 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id B87871408FE;
	Fri, 12 Apr 2024 22:41:22 +0800 (CST)
Received: from SecurePC-101-06.china.huawei.com (10.122.247.231) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 15:41:22 +0100
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
Subject: [PATCH v5 08/18] ACPI: convert acpi_processor_post_eject() to use IS_ENABLED()
Date: Fri, 12 Apr 2024 15:37:09 +0100
Message-ID: <20240412143719.11398-9-Jonathan.Cameron@huawei.com>
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

From: Russell King <rmk+kernel@armlinux.org.uk>

Rather than ifdef'ing acpi_processor_post_eject() and its use site, use
IS_ENABLED() to increase compile coverage.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
v5: No change
---
 drivers/acpi/acpi_processor.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 6b2ee0643d11..15d89f80857b 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -461,12 +461,14 @@ static int acpi_processor_add(struct acpi_device *device,
 	return result;
 }
 
-#ifdef CONFIG_ACPI_HOTPLUG_CPU
 /* Removal */
 static void acpi_processor_post_eject(struct acpi_device *device)
 {
 	struct acpi_processor *pr;
 
+	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_CPU))
+		return;
+
 	if (!device || !acpi_driver_data(device))
 		return;
 
@@ -505,7 +507,6 @@ static void acpi_processor_post_eject(struct acpi_device *device)
 	free_cpumask_var(pr->throttling.shared_cpu_map);
 	kfree(pr);
 }
-#endif /* CONFIG_ACPI_HOTPLUG_CPU */
 
 #ifdef CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC
 bool __init processor_physically_present(acpi_handle handle)
@@ -630,9 +631,7 @@ static const struct acpi_device_id processor_device_ids[] = {
 static struct acpi_scan_handler processor_handler = {
 	.ids = processor_device_ids,
 	.attach = acpi_processor_add,
-#ifdef CONFIG_ACPI_HOTPLUG_CPU
 	.post_eject = acpi_processor_post_eject,
-#endif
 	.hotplug = {
 		.enabled = true,
 	},
-- 
2.39.2

