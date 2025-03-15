Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC842110E
	for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 00:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741997978; cv=none; b=Fu0B+zbEe/rQ4Uo5H6S19juXZC1DZdNRO2Ni951ZNs7R+HNkAJL/JIDrhrxC5r7Z2ANdMbC+u2k1W3/IAq9FC6Qq26a7Atx181l3clGEzmv6/n3g10gz7HuNcTRXWDmv/ffw7ui0jOlXoy32ZHVmyivDuq6FKwzvNRql2YzgZws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741997978; c=relaxed/simple;
	bh=52Q9aFBXq4Dy0Zhc7US3IcMcJbMEmDDfDXIviO4rrO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmgHhffjsBW6sfK+elOzsJth/TKWVgWvsGhtlnjklnMuFp5cllLtXIwjlEMGtzHZqG2piEPkzRbr82iUbUq1A65REV+oVmIUXR5u9KRYEYHv/cUppIWDwFIznNTMWCSB7LWDu9ZAfuP138Yst3bkbbZKKbv/6B5d5pq0m1tM1jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=dAfmYGcU; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dAfmYGcU"
Received: from romank-3650.corp.microsoft.com (unknown [131.107.160.188])
	by linux.microsoft.com (Postfix) with ESMTPSA id C8A432038F2E;
	Fri, 14 Mar 2025 17:19:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C8A432038F2E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741997975;
	bh=TDmpFnnNjtVVT4nWQKfnOVX6uwbQyh3AG6bbf3ydHyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAfmYGcU8yB0LAwiKY8EIayPjlFEW9Qtm5IBPBjBHTrIbenjaPidGT0C+kAQ68rx6
	 9TB4g0mgWycnwqtbQO6guH2Xnpv1671Fen4fFHxXgb69c5jdKXyBUZVZE3/uWEzOZ9
	 gc+mtZ/R/T6G//RMcYluQbk3Af45/0GDWm+XYXQM=
From: Roman Kisel <romank@linux.microsoft.com>
To: arnd@arndb.de,
	bhelgaas@google.com,
	bp@alien8.de,
	catalin.marinas@arm.com,
	conor+dt@kernel.org,
	dan.carpenter@linaro.org,
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
Subject: [PATCH hyperv-next v6 05/11] arm64: hyperv: Initialize the Virtual Trust Level field
Date: Fri, 14 Mar 2025 17:19:25 -0700
Message-ID: <20250315001931.631210-6-romank@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250315001931.631210-1-romank@linux.microsoft.com>
References: <20250315001931.631210-1-romank@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various parts of the hyperv code need to know what VTL
the kernel runs at, most notably VMBus needs that to
establish communication with the host.

Initialize the Virtual Trust Level field to enable
booting in the Virtual Trust Level.

Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
---
 arch/arm64/hyperv/mshyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/hyperv/mshyperv.c b/arch/arm64/hyperv/mshyperv.c
index c5b03d3af7c5..f251a08ada5b 100644
--- a/arch/arm64/hyperv/mshyperv.c
+++ b/arch/arm64/hyperv/mshyperv.c
@@ -109,6 +109,7 @@ static int __init hyperv_init(void)
 
 	if (ms_hyperv.priv_high & HV_ACCESS_PARTITION_ID)
 		hv_get_partition_id();
+	ms_hyperv.vtl = get_vtl();
 
 	ms_hyperv_late_init();
 
-- 
2.43.0

