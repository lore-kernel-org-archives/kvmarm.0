Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501D0433DE
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 14:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740146984; cv=none; b=AQZGFaw6tnqjh0F3NX1t/xV+qApqOCY5Bzm2KmiSQVKjbh78KfiEB+RLgEoO/jrm0MddJn7+xWiYAbUw7rlZPZtQsqTj4wq5Ec0B7UroBXwOBEPKQrZ0KSoqhF74u1x6Y1B65etHv1JDAj2wJqxK0JNA1BouQHMK1MxSkfN2q0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740146984; c=relaxed/simple;
	bh=FIqWnRW0JMwTHpPu2ucKG5rfMmsGdl/GMrootG+DMZI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dn6YlZMZduHJPcTwJ73ZUmP7fNKOJrtGQvghZAuspZ9sSwFIq2VQb4nqeYyEIF/GuCMcL+eB0QRFq0CbvXg2pYoBSOqC3pfEqHk/D9e3a0PojeAVboP4EMK1kTCouERLlyEksEdyNJnTY3qBOWzpv19aXCNytEWptyUXsJ90BF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YzsPw6zzCz6L72m;
	Fri, 21 Feb 2025 22:07:00 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E899140C72;
	Fri, 21 Feb 2025 22:09:40 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Feb 2025 15:09:32 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v8 4/6] =?UTF-8?q?arm64:=20Make=20=C2=A0=5Fmidr=5Fin=5Fran?= =?UTF-8?q?ge=5Flist()=20an=20exported=20function?=
Date: Fri, 21 Feb 2025 14:02:27 +0000
Message-ID: <20250221140229.12588-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 frapeml500008.china.huawei.com (7.182.85.71)

Subsequent patch will add target implementation CPU support and that
will require _midr_in_range_list() to access new data. To avoid
exporting the data make _midr_in_range_list() a normal function and
export it.

No functional changes intended.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cputype.h | 15 +--------------
 arch/arm64/kernel/cpu_errata.c   | 15 +++++++++++++++
 arch/arm64/kernel/image-vars.h   |  1 +
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 2a76f0e30006..ccb4a155d118 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -276,20 +276,7 @@ static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
 	return _model == model && rv >= rv_min && rv <= rv_max;
 }
 
-static inline bool is_midr_in_range(struct midr_range const *range)
-{
-	return midr_is_cpu_model_range(read_cpuid_id(), range->model,
-				       range->rv_min, range->rv_max);
-}
-
-static inline bool
-is_midr_in_range_list(struct midr_range const *ranges)
-{
-	while (ranges->model)
-		if (is_midr_in_range(ranges++))
-			return true;
-	return false;
-}
+bool is_midr_in_range_list(struct midr_range const *ranges);
 
 static inline u64 __attribute_const__ read_cpuid_mpidr(void)
 {
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 99b55893fc4e..1f51cf6378c5 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -14,6 +14,21 @@
 #include <asm/kvm_asm.h>
 #include <asm/smp_plat.h>
 
+static inline bool is_midr_in_range(struct midr_range const *range)
+{
+	return midr_is_cpu_model_range(read_cpuid_id(), range->model,
+				       range->rv_min, range->rv_max);
+}
+
+bool is_midr_in_range_list(struct midr_range const *ranges)
+{
+	while (ranges->model)
+		if (is_midr_in_range(ranges++))
+			return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(is_midr_in_range_list);
+
 static bool __maybe_unused
 __is_affected_midr_range(const struct arm64_cpu_capabilities *entry,
 			 u32 midr, u32 revidr)
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index ef3a69cc398e..de3d081e5a57 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -49,6 +49,7 @@ PROVIDE(__pi_arm64_sw_feature_override	= arm64_sw_feature_override);
 PROVIDE(__pi_arm64_use_ng_mappings	= arm64_use_ng_mappings);
 #ifdef CONFIG_CAVIUM_ERRATUM_27456
 PROVIDE(__pi_cavium_erratum_27456_cpus	= cavium_erratum_27456_cpus);
+PROVIDE(__pi_is_midr_in_range_list	= is_midr_in_range_list);
 #endif
 PROVIDE(__pi__ctype			= _ctype);
 PROVIDE(__pi_memstart_offset_seed	= memstart_offset_seed);
-- 
2.47.0

