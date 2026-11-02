Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793628826;
	b=XyN1SRtg5ZY2TW3VTOa5LtQiBrpMBD7tUpSgu8mdmzOuFGeLBTvVzCEThhAUJT4XmRZJ
	 5PLXztuF1VhywAarEKG2OMQJNr3Qksas75ISTkd3Zmz4ZUakefGje2MDzIqeeIrO2+wrY
	 dGm3snXpsqeIjWynNhVFV0Kxi0noLZBFAD7bQuIZQ1qPCggqddTH8oQoaIm1wlmEQ/OHa
	 VXS/FGH7VsYGaH5yjvLxxpOY9r+9ojXIcLcIPNq1r1XZElNBNEAtS5vqBi+P4CPKZnbYN
	 M4/imPYmT31V4GBW8rEU9g+xlU25BbOR60Qe4BWbNT9s9H0rj7tFwvZipNVsDbdE7Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628826;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=76K72pEWdfxOay4+O36IImo/Yc4P30Q+GZluQh4Ft3o=;
	b=UmkkzCuPe7wUF40iD5PQCuZ3M8CtScXRjTCsYsFQpeUs2WVc6A2oOnXlniA60usNuB2E
	 nm4ITCByMY0xPSMfKnMghZMZGiCTg/CCSOd5U1Dz2O6Gin0j6Umf1b9omQhRhfV/pswex
	 h6d02QCM+CiyPU0hCULJgweQtAe8JKMxijICo+PBkxs+HAP9HDFqxYinWQSt+5o2d19DA
	 PgxWaYdSv3uWSUuRk9cax1LdsC5MItqFUVglQH34nTKozKlKMH8eqBFh6DL2GwEMbNjh1
	 NGtOCFqZWwwFFJfc1u9MBlX2+zPYndmwjh6pGorA1SprIpquNirTHz2GgbuflRaZo0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=u8uArIKx;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D7C606A32D;
	Mon,  2 Nov 2026 14:13:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96D7C606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=u8uArIKx
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE71319F0;
	Mon,  2 Nov 2026 06:13:41 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8FB63F59E;
	Mon,  2 Nov 2026 06:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793628825; bh=Z1wTMEkKoVCrv8XQGReu1ie2hkH7sv7V4AiWMZvW4Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8uArIKxLShS1Pf1Vmb9ibDtl0ljwY3IMeQUjp1R0YwjTq2C38pI0mDDuzgYlP3ht
	 TIHiOon/DFe/T9I9C+3q/Qu6tiCg1RWEpScfn+pxSdHxl7NBoQ8LPV++jCdO/Hhnb/
	 wbilikk0OQ6vmbAFxKJyCH9WRPXVBMZqwOJRtHwk=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 03/11] KVM: arm64: CCA: Check for RMI support at KVM init
Date: Mon,  2 Nov 2026 14:12:54 +0000
Message-ID: <20261102141304.126883-4-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102141304.126883-1-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check if the RMI support is sufficient for using in KVM. Specifically, we
will only support creating realm VMs when KVM is set to 'rmm' mode.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 arch/arm64/kvm/rmi.c   | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index cecea0820e52..d067063a3686 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -34,6 +34,7 @@ menuconfig KVM
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
 	select KVM_GENERIC_PRE_FAULT_MEMORY
+	select ARM_RMM_RMI
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 5ecc8b349869..9d118768550d 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2023-2026 ARM Ltd.
  */
 
+#include <linux/arm-rmi-cmds.h>
 #include <linux/kvm_host.h>
 
 #include <asm/virt.h>
@@ -12,7 +13,8 @@ void kvm_init_rmi(void)
 	if (kvm_get_mode() != KVM_MODE_RMM)
 		return;
 
-	/* TODO: Check if the RMI is available */
+	if (!is_rmi_available())
+		return;
 
 	/* Future patch will enable static branch kvm_rmi_is_available */
 }
-- 
2.43.0

