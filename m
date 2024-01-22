Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377C439AE3
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 09:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705916788; cv=none; b=njTAYgQDAUDxIUqn9gAk3Y1YBi8ObxYxY5fIPYk/wABLxvBSv0SKEQHauuW8tBdhk8y7Oc0tVWMWqrKuhLo9Vuj95Dwz8+Sna3mao3t8zonKWSRTidcByJRcK/M440JhsjR4DeD9tESB+vh+tlC9V/C7LzZaU2Y2rZDR8oBs6os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705916788; c=relaxed/simple;
	bh=kFoL+9zp/dTTX50pqYzX7T84zq2k78C/Ufd09UECOX0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hZIJzz5YuXOFlMBXUUFK4eMAddYgqhlbvg3d/0sHpBljHxXFpDh/ZpGH6XmFHorN0/WKaKuraB6TJO9ZXrxng6EaH9HOJck8UG0816TluRRN8jFCJW+b2plTu0me1muu5cwojGQGmNkMH+3DtYP69okTnuLiaHKYumX/WM0dl1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5AiVmno; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5AiVmno"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705916787; x=1737452787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kFoL+9zp/dTTX50pqYzX7T84zq2k78C/Ufd09UECOX0=;
  b=f5AiVmnofr6gAApWtU4MsMePp/R3hasQMWmXpJ6Xr3AxA80V1rxCYDPS
   hD7xwxQMKDlhaLzBm7EvZ2mW4RIjGnrtYWGZ1zY85G2xhdndTM7iuZWWI
   zXiqq+kVxuT+kFMoVKB8m5/OOf5rI0JLSWub6FXRzI/n8QU4KW84A2uyS
   Qb+bDMbB2PWnwwnByvR8pKL3b1NgZ6tnJu6Q9F8VOSW04oBaXmXJnPGHo
   ZFhLVvu/FvrhgXDisQg3cNP6+RfRLPlgVG9qBceay9jX761s71y+u271Z
   Wc7zEb0vFkzuBR+vCTH9fxyohhnNdLpBdW9Zp4yDWRI299mugIo/7SXH5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="22641750"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="22641750"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 01:46:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="778535411"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="778535411"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 01:46:17 -0800
From: Haibo Xu <haibo1.xu@intel.com>
To: 
Cc: xiaobo55x@gmail.com,
	ajones@ventanamicro.com,
	Haibo Xu <haibo1.xu@intel.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Guo Ren <guoren@kernel.org>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Minda Chen <minda.chen@starfivetech.com>,
	Samuel Holland <samuel@sholland.org>,
	Jisheng Zhang <jszhang@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Like Xu <likexu@tencent.com>,
	Peter Xu <peterx@redhat.com>,
	Vipin Sharma <vipinsh@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Thomas Huth <thuth@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [PATCH v5 05/12] KVM: selftests: Add CONFIG_64BIT definition for the build
Date: Mon, 22 Jan 2024 17:58:35 +0800
Message-Id: <af5958c00c0e2c8a5feb22cd908b89e2a6f72c9a.1705916069.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1705916069.git.haibo1.xu@intel.com>
References: <cover.1705916069.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since only 64bit KVM selftests were supported on all architectures,
add the CONFIG_64BIT definition in kvm/Makefile to ensure only 64bit
definitions were available in the corresponding included files.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 87f0f76ea639..a18d18994fe8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -215,7 +215,7 @@ else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
-	-Wno-gnu-variable-sized-type-not-at-end -MD -MP \
+	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
 	-fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
-- 
2.34.1

