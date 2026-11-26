Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693830;
	b=Qmjk+sVgtfv7akAyvIoVDQuRcVE2B1H0pgRmgjJfbjC3BA2eOjLe1YAE5deO0N3jWno8
	 5oiWaO3Drsr6qiOwKTxrR4WuvCP9oBkz7ZOEpWWI/s8rzJCgd8nKEfQ6E05opqmv/4mxW
	 AONVwHSKYSTkcrZ7oBzgrS6QH3nyZbZDKPJPfCqPCY2S3xALr4qBCckgsztTH0OcQnT+i
	 Kg13h9ns5cEMnLXAKSbHg4gfcMlLJ5bBAz2itZ7Syr5V2/jaZ2BAG4+1rTJJzEi1Q+E+s
	 trt4t+aQLB0yQMIH2kbZLJSyiipWhM8/fp9Q2Bl3reY2HWgGhembruC5QEG0d3NJ7rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693830;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=S/rDm9MSW0WTvPK5lT2NqtuJzmnuYBWQB0NK6jZGLPQ=;
	b=KtRfK1SFV+vTrbR0ftEJwTX7QIdmXVsOj5+8rUXwKAl0IN92CnXQ5ng2/wHR3TywAEJZ
	 ps771G+D8V0CO8qA8u7zzNGKE+2UPArjij+QcRWe1KUlOptdg9bVNW7rTIzmkJ13HqJUw
	 Hf652APEOPMpWpRGVWjAMyOH60aXcF1AKVLp4VF7jLDgR25NoE1+F1WxRV3e9JKo/JmO2
	 p0DrDlCpYLUrqQfifU7tnw9rZzvuNtRTz4N4SvB1LHPb12CFOD6KrnLREfWmiUg4JBl8Y
	 Ge14PUQwvQqaVdf1+SMqfQ9FeKOc25XuG9ItrfuVXMVJ12gmDEKNvmXIC5fsnFulo3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=SVIV6EpM;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09FB7606A326
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 11:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09FB7606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=SVIV6EpM
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E6CD1D13;
	Thu, 26 Nov 2026 03:50:26 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AB593F632;
	Thu, 26 Nov 2026 03:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693829; bh=M6YJ067DYPpSDU4UXJ6oaiovDlaxST0eB8C0pfg04v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVIV6EpMIHaCeoj/be0YI77r6k/jNQxqGF3zQkn24yTuVZ5dChBpBA9mroGFuEkAw
	 TgDdRFjEjY+W54RiTdF6MTRTY7s8Y2jjLjWg3YvT9oB6Lm2/mIC6DSexpXWtWhdb+Z
	 YHsg8HB1e0Jflokm9UIlFBng2oYe3bsY26pMkLRM=
From: =?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-efi@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [RFC v2 06/13] ACPICA: Add TLBI table definition
Date: Thu, 26 Nov 2026 11:49:29 +0000
Message-ID: <20261126114936.864256-7-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126114936.864256-1-kristina.martsenko@arm.com>
References: <20261126114936.864256-1-kristina.martsenko@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add the definition of the new Arm TLBI ACPI table.

NOTE: This patch is not yet part of ACPICA and should not be merged as
is. The TLBI table description is not yet public and may change. This
definition is just an initial proposal of how it will look.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 include/acpi/actbl2.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 76e4a5bc79b4..98ef50b9bee1 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -61,6 +61,7 @@
 #define ACPI_SIG_SVKL           "SVKL"	/* Storage Volume Key Location Table */
 #define ACPI_SIG_SWFT           "SWFT"	/* SoundWire File Table */
 #define ACPI_SIG_TDEL           "TDEL"	/* TD Event Log Table */
+#define ACPI_SIG_TLBI           "TLBI"	/* TLB Invalidate Domain Table */
 
 /*
  * All tables must be byte-packed to match the ACPI specification, since
@@ -3708,6 +3709,37 @@ struct acpi_table_tdel {
 	u64 log_area_start_address;
 };
 
+/*******************************************************************************
+ *
+ * TLBI - TLBI Domain Table
+ *
+ ******************************************************************************/
+
+struct acpi_table_tlbi {
+	struct acpi_table_header header;
+	u32 domain_count;
+	u32 domains_offset;
+};
+
+struct acpi_tlbi_domain {
+	u32 length;
+	u32 id;
+	u32 descendant_count;
+	u32 descendants_offset;
+};
+
+struct acpi_tlbi_descendant {
+	u32 type;
+	u32 identifier;
+	u32 length;
+};
+
+enum acpi_tlbi_descendant_type {
+	ACPI_TLBI_DESCENDANT_DOMAIN = 0,
+	ACPI_TLBI_DESCENDANT_CPU = 1,
+	ACPI_TLBI_DESCENDANT_SMMU = 2,
+};
+
 /* Reset to default packing */
 
 #pragma pack()
-- 
2.43.0

