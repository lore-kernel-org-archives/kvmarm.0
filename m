Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F892F3C3E;
	Mon, 27 Oct 2025 09:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761558617; cv=none; b=WA2C/bTPwaHbOxdGQMBIepI+YxyjwOA2PjmZGEsDPZbaDIVNvdi9pF5vzZxwTANnwbVbhRm6U0m1ExQzmPnLYTOztCU3s8MDHoyFKcKRuh1DgW3VZ9TBXuCTXLePZEve1z8cpKlrCIG19V04DWYZJs8eQ9BEjlRf2TT4xDH4w80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761558617; c=relaxed/simple;
	bh=sYVeDu9M+oOjuuqkIzrIaSA25SCHmjEU+UGiJsr+pIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cS1O82n27lrj95AVQb5gTruIeV47NhJ2ytvTzwJCMuvzU5xJ9QB3p3Eglvq4bbBGw3528suryeUWrW6UgQbEJHc0FRJUaqB3l6BTegQwNBxPjKq9Kia54zGsqA/Nk1f2krlJ8qQNZxY79nLEs12vsGEz6T+ZevRaSAJdJgAJUhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZPZ1bFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZPZ1bFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A4CC116B1;
	Mon, 27 Oct 2025 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761558617;
	bh=sYVeDu9M+oOjuuqkIzrIaSA25SCHmjEU+UGiJsr+pIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZPZ1bFUuuncJhc4B/P7C9RskgcEpGw2RoVAU8T9wvYlG4AAU3jw6Vl2WRuHoHS7q
	 OQwj41HoZsrW02ax6zau3P/XS6kadJoNtmtlh4NMjUs9G6Q+xKlF6ebsRKhnnvKOir
	 w0gxy82ueM//ezhigaVLEsoV1/d4STz50/tYSkR4Qd1CpIp7qAE3XDR/AoszGjmXOT
	 eZx+ELcgKtO/CLo1qCJOmxEnpizpOpqv3SfgdKWQMwV3WkCQftQXtkwa+aeTN5v5NT
	 pxZhjeStnhUX3hVy6vhK4AlmBV6YkzlQoSquNVDEsOcDCLXjXl2zYf+krecuPGhrwU
	 EslZqOQAWoUAQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	aik@amd.com,
	lukas@wunner.de,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH 03/12] coco: guest: arm64: Drop dummy RSI platform device stub
Date: Mon, 27 Oct 2025 15:18:54 +0530
Message-ID: <20251027094916.1153143-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251027094916.1153143-1-aneesh.kumar@kernel.org>
References: <20251027094916.1153143-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SMCCC firmware driver now creates the `arm-smccc` platform device
and also creates the CCA auxiliary devices once the RSI ABI is
discovered. This makes the arch-specific arm64_create_dummy_rsi_dev()
helper redundant. Remove the arm-cca-dev platform device registration
and let the SMCCC probe manage the RSI device.

systemd match on platform:arm-cca-dev for confidential vm detection [1].
Losing the platform device registration can break that. Keeping this
removal in its own change makes it easy to revert if that regression
blocks the rollout.

[1] https://lore.kernel.org/all/4a7d84b2-2ec4-4773-a2d5-7b63d5c683cf@arm.com

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/kernel/rsi.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 5d711942e543..1b716d18b80e 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -158,18 +158,3 @@ void __init arm64_rsi_init(void)
 
 	static_branch_enable(&rsi_present);
 }
-
-static struct platform_device rsi_dev = {
-	.name = "arm-cca-dev",
-	.id = PLATFORM_DEVID_NONE
-};
-
-static int __init arm64_create_dummy_rsi_dev(void)
-{
-	if (is_realm_world() &&
-	    platform_device_register(&rsi_dev))
-		pr_err("failed to register rsi platform device\n");
-	return 0;
-}
-
-arch_initcall(arm64_create_dummy_rsi_dev)
-- 
2.43.0

