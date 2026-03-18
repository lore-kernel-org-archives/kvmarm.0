Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A809E3EBF0C;
	Wed, 18 Mar 2026 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849289; cv=none; b=OI/r0z92qP5vaJW3iAnjr1bmx9VT4o5FIsFwRkcnrKUND1u4z3Xw/I3dnBqXgZkbO5BsxZZA0zE4rCQ7SJ5kzewtFupcX3nGxJaBakxPz/r5gP5ruBqwvbdkOds96cerKnVmhiIJ3JLWse5+9IzReF7Lk8Kaz2f38RKmMhlBl/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849289; c=relaxed/simple;
	bh=PyWxmAiB48WGIzmumjWIFgY1AMagZygtxtkphaDObE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dwn30P1jTcS2AEJyYxu0KJfbQMb5WQkWDHU7rm+phhsbGdv4yoSI3iG0EmI2tw7bpmx1SNHMHFZbmJlBws576LxEWWGBxf7CRD3lW7IokxmylXxqqtP214EPgHWqRUJ55CvHXKkWFICjrWTfNCqKg2v9isdBMA+6xjNuYaIauR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA6DF1E2F;
	Wed, 18 Mar 2026 08:54:37 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 649383F73B;
	Wed, 18 Mar 2026 08:54:40 -0700 (PDT)
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
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v13 05/48] arm64: RMI: Temporarily add SMCs from RMM v1.0 spec
Date: Wed, 18 Mar 2026 15:53:29 +0000
Message-ID: <20260318155413.793430-6-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
References: <20260318155413.793430-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not all the functionality has been migrated to the v2.0 specification,
so for now we still rely on some v1.0 SMCs. This mixture is not
spec-compliant, but is necessary until an updated RMM is available.

Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch in v13
---
 arch/arm64/include/asm/rmi_smc.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 8a42b83218f8..049d71470486 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -30,14 +30,15 @@
 #define SMC_RMI_REC_ENTER			SMC_RMI_CALL(0x015c)
 #define SMC_RMI_RTT_CREATE			SMC_RMI_CALL(0x015d)
 #define SMC_RMI_RTT_DESTROY			SMC_RMI_CALL(0x015e)
+#define SMC_RMI_RTT_MAP_UNPROTECTED		SMC_RMI_CALL(0x015f) //
 
 #define SMC_RMI_RTT_READ_ENTRY			SMC_RMI_CALL(0x0161)
-
+#define SMC_RMI_RTT_UNMAP_UNPROTECTED		SMC_RMI_CALL(0x0162) //
 #define SMC_RMI_RTT_DEV_VALIDATE		SMC_RMI_CALL(0x0163)
 #define SMC_RMI_PSCI_COMPLETE			SMC_RMI_CALL(0x0164)
 #define SMC_RMI_FEATURES			SMC_RMI_CALL(0x0165)
 #define SMC_RMI_RTT_FOLD			SMC_RMI_CALL(0x0166)
-
+#define SMC_RMI_REC_AUX_COUNT			SMC_RMI_CALL(0x0167) //
 #define SMC_RMI_RTT_INIT_RIPAS			SMC_RMI_CALL(0x0168)
 #define SMC_RMI_RTT_SET_RIPAS			SMC_RMI_CALL(0x0169)
 #define SMC_RMI_VSMMU_CREATE			SMC_RMI_CALL(0x016a)
-- 
2.43.0

