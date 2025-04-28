Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C94210F59
	for <kvmarm@lists.linux.dev>; Mon, 28 Apr 2025 21:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745874471; cv=none; b=WrFAdevXpsp3cqQoAmvPUbWZjHROfE1Qtwn1HCBrU0rjRi4ViwmnFmFf8Ngk/MmeHL7ECG3pntplprWZL2ByGbffCiDw9gW9PsBFs0sHj8haWQuZeXMg9uIYo+4clQHGO2bPMA74FRmnpbnglA2aCzHIpH5pwYaJ+oAfxVn9tRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745874471; c=relaxed/simple;
	bh=I3CEwKjiOw/f7nFmYsNkksTJaqqOcfPtnDq3c6iskUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOofbua15qU6WUoV+Ue8kLPGO9HJNnq3GGlBLM6WmbFkHTKqUq3epI5C9wO9m/6FzBs+Am3Lf0hGSOuXfP4vRVeOO991Ed7BOvTetAEW2V5bNJECpd45O8zoda8wcmYwCs8/JqZDRSap6ttjhMVeQvgMUS/GxPD20N4Wt6qO+28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ILeQxzGc; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ILeQxzGc"
Received: from romank-3650.corp.microsoft.com (unknown [131.107.1.188])
	by linux.microsoft.com (Postfix) with ESMTPSA id 06B0A211AD28;
	Mon, 28 Apr 2025 14:07:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 06B0A211AD28
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1745874466;
	bh=xt1rbRXU40eBeYFqn5S5410daeID7AsrUbw+WPHynno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILeQxzGcrqOI4PpdKoj7u5guh0X0UX9/VyUrwB0JxYD13NsGVGsLZHHEMhXrkz1XI
	 T1m7CheHstc2Y2+zmY8+VfPt0ye9i1Hv2lytSJggpw039jJ4ClPFk/GxeLHaKmFhPC
	 X8uoP1iwndOfYCt6dIZggjhIHT+M1l89I3vcvyzU=
From: Roman Kisel <romank@linux.microsoft.com>
To: arnd@arndb.de,
	bhelgaas@google.com,
	bp@alien8.de,
	catalin.marinas@arm.com,
	conor+dt@kernel.org,
	dave.hansen@linux.intel.com,
	decui@microsoft.com,
	haiyangz@microsoft.com,
	hpa@zytor.com,
	joey.gouly@arm.com,
	krzk+dt@kernel.org,
	kw@linux.com,
	kys@microsoft.com,
	lenb@kernel.org,
	lpieralisi@kernel.org,
	manivannan.sadhasivam@linaro.org,
	mark.rutland@arm.com,
	maz@kernel.org,
	mingo@redhat.com,
	oliver.upton@linux.dev,
	rafael@kernel.org,
	robh@kernel.org,
	ssengar@linux.microsoft.com,
	sudeep.holla@arm.com,
	suzuki.poulose@arm.com,
	tglx@linutronix.de,
	wei.liu@kernel.org,
	will@kernel.org,
	yuzenghui@huawei.com,
	linux-hyperv@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-arch@vger.kernel.org,
	x86@kernel.org
Cc: apais@microsoft.com,
	benhill@microsoft.com,
	bperkins@microsoft.com,
	sunilmut@microsoft.com
Subject: [PATCH hyperv-next v9 06/11] arm64, x86: hyperv: Report the VTL the system boots in
Date: Mon, 28 Apr 2025 14:07:37 -0700
Message-ID: <20250428210742.435282-7-romank@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250428210742.435282-1-romank@linux.microsoft.com>
References: <20250428210742.435282-1-romank@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hyperv guest code might run in various Virtual Trust Levels.

Report the level when the kernel boots in the non-default (0)
one.

Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
---
 arch/arm64/hyperv/mshyperv.c | 2 ++
 arch/x86/hyperv/hv_vtl.c     | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/hyperv/mshyperv.c b/arch/arm64/hyperv/mshyperv.c
index 43f422a7ef34..4fdc26ade1d7 100644
--- a/arch/arm64/hyperv/mshyperv.c
+++ b/arch/arm64/hyperv/mshyperv.c
@@ -118,6 +118,8 @@ static int __init hyperv_init(void)
 	if (ms_hyperv.priv_high & HV_ACCESS_PARTITION_ID)
 		hv_get_partition_id();
 	ms_hyperv.vtl = get_vtl();
+	if (ms_hyperv.vtl > 0) /* non default VTL */
+		pr_info("Linux runs in Hyper-V Virtual Trust Level %d\n", ms_hyperv.vtl);
 
 	ms_hyperv_late_init();
 
diff --git a/arch/x86/hyperv/hv_vtl.c b/arch/x86/hyperv/hv_vtl.c
index 582fe820e29c..038c896fdd60 100644
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -55,7 +55,12 @@ static void  __noreturn hv_vtl_restart(char __maybe_unused *cmd)
 
 void __init hv_vtl_init_platform(void)
 {
-	pr_info("Linux runs in Hyper-V Virtual Trust Level\n");
+	/*
+	 * This function is a no-op if the VTL mode is not enabled.
+	 * If it is, this function runs if and only the kernel boots in
+	 * VTL2 which the x86 hv initialization path makes sure of.
+	 */
+	pr_info("Linux runs in Hyper-V Virtual Trust Level %d\n", ms_hyperv.vtl);
 
 	x86_platform.realmode_reserve = x86_init_noop;
 	x86_platform.realmode_init = x86_init_noop;
-- 
2.43.0

