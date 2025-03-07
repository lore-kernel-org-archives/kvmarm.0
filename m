Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453C92580FE
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 22:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384989; cv=none; b=bqlkOBDxAP5na9VLRyHV+qM41sGX+cmzM0rXv3VfBmOVPjjW7fjyVOvTtUKdbQGVaUyAwUyCUvCeddE/yocxmAvmTLCD3uARd28SKTQ6rgk6K4JtJgaLlv86unb9w1Hv6zRgYPvbHe0Ds6HmzW0Lryswb3Tewaze+rwzyr8iOI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384989; c=relaxed/simple;
	bh=cvz/ZTsNhYKR7Jb164PPQT4b9Cqedmh8XCmTmf4kZQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEAVXKTSraxWePE9Zj1Up3LExesFPJwT+ma5RshSkg9aoHuA4qf/jb+jiditfFzf5uyKIio4ReUYaa3KofqS3VifgSDFzX8QOukLou7IDAYI32JbHett4d8aMk2EArdnudPyhR+gFAFh/ONvDzrG0DcOMRGRkPpDLY2rCePbvr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=MnViV2co; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="MnViV2co"
Received: from romank-3650.corp.microsoft.com (unknown [131.107.160.188])
	by linux.microsoft.com (Postfix) with ESMTPSA id C7C432038F46;
	Fri,  7 Mar 2025 14:03:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7C432038F46
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741384988;
	bh=DHCZgN2nv/auyPY8jlf5/CxWk9DcxsvUe9NZhUMgcn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnViV2cok80SEu3yXZPLruR5ncKfFuUB/DN7G00ORVAuMxkiQGqPfq064cRXssxSt
	 SfJhMBk2aVXinFXplzZThgtTbdnZR2XdvsyJlDk6Q6MLVD9keTNL32J4TCwZ6P9x4k
	 ig35M2awNRwyMkTjxYPev4uCYmeSyu1H+cHpbIIo=
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
	devicetree@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	x86@kernel.org
Cc: apais@microsoft.com,
	benhill@microsoft.com,
	bperkins@microsoft.com,
	sunilmut@microsoft.com
Subject: [PATCH hyperv-next v5 06/11] arm64, x86: hyperv: Report the VTL the system boots in
Date: Fri,  7 Mar 2025 14:02:58 -0800
Message-ID: <20250307220304.247725-7-romank@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250307220304.247725-1-romank@linux.microsoft.com>
References: <20250307220304.247725-1-romank@linux.microsoft.com>
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
---
 arch/arm64/hyperv/mshyperv.c | 2 ++
 arch/x86/hyperv/hv_vtl.c     | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/hyperv/mshyperv.c b/arch/arm64/hyperv/mshyperv.c
index a7db03f5413d..3bc16dbee758 100644
--- a/arch/arm64/hyperv/mshyperv.c
+++ b/arch/arm64/hyperv/mshyperv.c
@@ -108,6 +108,8 @@ static int __init hyperv_init(void)
 	if (ms_hyperv.priv_high & HV_ACCESS_PARTITION_ID)
 		hv_get_partition_id();
 	ms_hyperv.vtl = get_vtl();
+	if (ms_hyperv.vtl > 0) /* non default VTL */
+		pr_info("Linux runs in Hyper-V Virtual Trust Level %d\n", ms_hyperv.vtl);
 
 	ms_hyperv_late_init();
 
diff --git a/arch/x86/hyperv/hv_vtl.c b/arch/x86/hyperv/hv_vtl.c
index 4e1b1e3b5658..c21bee7e8ff3 100644
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -24,7 +24,7 @@ static bool __init hv_vtl_msi_ext_dest_id(void)
 
 void __init hv_vtl_init_platform(void)
 {
-	pr_info("Linux runs in Hyper-V Virtual Trust Level\n");
+	pr_info("Linux runs in Hyper-V Virtual Trust Level %d\n", ms_hyperv.vtl);
 
 	x86_platform.realmode_reserve = x86_init_noop;
 	x86_platform.realmode_init = x86_init_noop;
-- 
2.43.0

