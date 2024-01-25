Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7180E1339AF
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201050; cv=none; b=dvyo1LYtnmBAeSH1j7kOqlOtn+Abf6bv/0EjnRavaQf/Jd/KaBvZ4fZf3V4O9uBMLHG5kYFWkJxFfHUOowAjeSG+Rxi4UzLI2O4Lby7kHFMDLvedBwdTNnLxep/QPz3my03zYH5hWpAG+VH0wi5VjsCdVvrTAe3DonAH2ioRHPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201050; c=relaxed/simple;
	bh=ZlW7IoCL2r+NovVqB/kF/0f0kkdZF+QQKLgyY/9+iMg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TB6hpLpDe/+pBFCZAAUB1ZXGV3+FOymZzvDk3pxuwh8hWnHqOBMvEf3+vth67YTL6VDAPbM8rpZDl5TD6NLjB0dZ7vKtoRTXahCU5bbIsq5pGycNtE4C34O/rFfAu8DtxLaQZBb9SfVnRcCuPjKEFxw7T8ds1AR9SqdU0NUALSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FAFC15A1;
	Thu, 25 Jan 2024 08:44:52 -0800 (PST)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E70C3F5A1;
	Thu, 25 Jan 2024 08:44:02 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	arnd@arndb.de,
	akpm@linux-foundation.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	bristot@redhat.com,
	vschneid@redhat.com,
	mhiramat@kernel.org,
	rppt@kernel.org,
	hughd@google.com
Cc: pcc@google.com,
	steven.price@arm.com,
	anshuman.khandual@arm.com,
	vincenzo.frascino@arm.com,
	david@redhat.com,
	eugenis@google.com,
	kcc@google.com,
	hyesoo.yu@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH RFC v3 14/35] of: fdt: Return the region size in of_flat_dt_translate_address()
Date: Thu, 25 Jan 2024 16:42:35 +0000
Message-Id: <20240125164256.4147-15-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125164256.4147-1-alexandru.elisei@arm.com>
References: <20240125164256.4147-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Alongside the base address, arm64 will also need to know the size of a
tag storage region. Teach of_flat_dt_translate_address() to parse and
return the size.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes since rfc v2:

* New patch, suggested by Rob Herring.

 arch/sh/kernel/cpu/sh2/probe.c |  2 +-
 drivers/of/fdt_address.c       | 12 +++++++++---
 drivers/tty/serial/earlycon.c  |  2 +-
 include/linux/of_fdt.h         |  2 +-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/cpu/sh2/probe.c b/arch/sh/kernel/cpu/sh2/probe.c
index 70a07f4f2142..fa8904e8f390 100644
--- a/arch/sh/kernel/cpu/sh2/probe.c
+++ b/arch/sh/kernel/cpu/sh2/probe.c
@@ -21,7 +21,7 @@ static int __init scan_cache(unsigned long node, const char *uname,
 	if (!of_flat_dt_is_compatible(node, "jcore,cache"))
 		return 0;
 
-	j2_ccr_base = ioremap(of_flat_dt_translate_address(node), 4);
+	j2_ccr_base = ioremap(of_flat_dt_translate_address(node, NULL), 4);
 
 	return 1;
 }
diff --git a/drivers/of/fdt_address.c b/drivers/of/fdt_address.c
index 1dc15ab78b10..4c077778d710 100644
--- a/drivers/of/fdt_address.c
+++ b/drivers/of/fdt_address.c
@@ -160,7 +160,8 @@ static int __init fdt_translate_one(const void *blob, int parent,
  * that can be mapped to a cpu physical address). This is not really specified
  * that way, but this is traditionally the way IBM at least do things
  */
-static u64 __init fdt_translate_address(const void *blob, int node_offset)
+static u64 __init fdt_translate_address(const void *blob, int node_offset,
+					u64 *out_size)
 {
 	int parent, len;
 	const struct of_bus *bus, *pbus;
@@ -193,6 +194,9 @@ static u64 __init fdt_translate_address(const void *blob, int node_offset)
 		goto bail;
 	}
 	memcpy(addr, reg, na * 4);
+	/* The size of the region doesn't need translating. */
+	if (out_size)
+		*out_size = of_read_number(reg + na, ns);
 
 	pr_debug("bus (na=%d, ns=%d) on %s\n",
 		 na, ns, fdt_get_name(blob, parent, NULL));
@@ -242,8 +246,10 @@ static u64 __init fdt_translate_address(const void *blob, int node_offset)
 /**
  * of_flat_dt_translate_address - translate DT addr into CPU phys addr
  * @node: node in the flat blob
+ * @out_size: size of the region, can be NULL if not needed
+ * @return: the address, OF_BAD_ADDR in case of error
  */
-u64 __init of_flat_dt_translate_address(unsigned long node)
+u64 __init of_flat_dt_translate_address(unsigned long node, u64 *out_size)
 {
-	return fdt_translate_address(initial_boot_params, node);
+	return fdt_translate_address(initial_boot_params, node, out_size);
 }
diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
index a5fbb6ed38ae..e941cf786232 100644
--- a/drivers/tty/serial/earlycon.c
+++ b/drivers/tty/serial/earlycon.c
@@ -265,7 +265,7 @@ int __init of_setup_earlycon(const struct earlycon_id *match,
 
 	spin_lock_init(&port->lock);
 	port->iotype = UPIO_MEM;
-	addr = of_flat_dt_translate_address(node);
+	addr = of_flat_dt_translate_address(node, NULL);
 	if (addr == OF_BAD_ADDR) {
 		pr_warn("[%s] bad address\n", match->name);
 		return -ENXIO;
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index d69ad5bb1eb1..0e26f8c3b10e 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -36,7 +36,7 @@ extern char __dtb_start[];
 extern char __dtb_end[];
 
 /* Other Prototypes */
-extern u64 of_flat_dt_translate_address(unsigned long node);
+extern u64 of_flat_dt_translate_address(unsigned long node, u64 *out_size);
 extern void of_fdt_limit_memory(int limit);
 #endif /* CONFIG_OF_FLATTREE */
 
-- 
2.43.0

