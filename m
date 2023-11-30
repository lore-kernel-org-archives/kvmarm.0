Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CE938DE3
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7cNcvi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3A7C433CA;
	Thu, 30 Nov 2023 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701351774;
	bh=50B8ImhgoUGNb+dUNsqUimewe4oID5dKKZxerHWS8q8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=F7cNcvi/GBNx5iX5sX8mkOT2f6AiOBehG4MVs08l3v4Et6gmEHUGAxzAstB9T9G1k
	 qdpLBM0rW5+J2znaIRQGoxWM+7wuGrCFBIY+QCfw88wpncmKxD2xPrpnLaJM575Lp9
	 abAi3113SLNsCNsvLcGr9DgaL7hC2aOM03L26SrE=
Subject: Patch "arm64: cpufeature: Extract capped perfmon fields" has been added to the 5.4-stable tree
To: andrew.murray@arm.com,gregkh@linuxfoundation.org,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,sashal@kernel.org,suzuki.poulose@arm.com,wanghaibin.wang@huawei.com,will@kernel.org,yuzenghui@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 30 Nov 2023 13:42:41 +0000
In-Reply-To: <20231128115725.964-2-yuzenghui@huawei.com>
Message-ID: <2023113041-circle-rebuttal-198c@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    arm64: cpufeature: Extract capped perfmon fields

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     arm64-cpufeature-extract-capped-perfmon-fields.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-2888-greg=kroah.com@vger.kernel.org Tue Nov 28 11:57:47 2023
From: Zenghui Yu <yuzenghui@huawei.com>
Date: Tue, 28 Nov 2023 19:57:24 +0800
Subject: arm64: cpufeature: Extract capped perfmon fields
To: <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>, <sashal@kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>, <andrew.murray@arm.com>, <mark.rutland@arm.com>, <suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>, <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <20231128115725.964-2-yuzenghui@huawei.com>

From: Andrew Murray <andrew.murray@arm.com>

commit 8e35aa642ee4dab01b16cc4b2df59d1936f3b3c2 upstream.

When emulating ID registers there is often a need to cap the version
bits of a feature such that the guest will not use features that the
host is not aware of. For example, when KVM mediates access to the PMU
by emulating register accesses.

Let's add a helper that extracts a performance monitors ID field and
caps the version to a given value.

Fields that identify the version of the Performance Monitors Extension
do not follow the standard ID scheme, and instead follow the scheme
described in ARM DDI 0487E.a page D13-2825 "Alternative ID scheme used
for the Performance Monitors Extension version". The value 0xF means an
IMPLEMENTATION DEFINED PMU is present, and values 0x0-OxE can be treated
the same as an unsigned field with 0x0 meaning no PMU is present.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[Mark: rework to handle perfmon fields]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -449,6 +449,29 @@ cpuid_feature_extract_unsigned_field(u64
 	return cpuid_feature_extract_unsigned_field_width(features, field, 4);
 }
 
+/*
+ * Fields that identify the version of the Performance Monitors Extension do
+ * not follow the standard ID scheme. See ARM DDI 0487E.a page D13-2825,
+ * "Alternative ID scheme used for the Performance Monitors Extension version".
+ */
+static inline u64 __attribute_const__
+cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
+{
+	u64 val = cpuid_feature_extract_unsigned_field(features, field);
+	u64 mask = GENMASK_ULL(field + 3, field);
+
+	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
+	if (val == 0xf)
+		val = 0;
+
+	if (val > cap) {
+		features &= ~mask;
+		features |= (cap << field) & mask;
+	}
+
+	return features;
+}
+
 static inline u64 arm64_ftr_mask(const struct arm64_ftr_bits *ftrp)
 {
 	return (u64)GENMASK(ftrp->shift + ftrp->width - 1, ftrp->shift);


Patches currently in stable-queue which might be from kroah.com@vger.kernel.org are

queue-5.4/arm64-cpufeature-extract-capped-perfmon-fields.patch
queue-5.4/kvm-arm64-limit-pmu-version-to-pmuv3-for-armv8.1.patch
