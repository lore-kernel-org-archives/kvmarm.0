Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4422D38DE3
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 13:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDM1z98P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779C7C433C8;
	Thu, 30 Nov 2023 13:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701351771;
	bh=hbufFq2kEdRVaUNdlqfQ4AXlb8Sb5NSxfROV3d2FV/8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=zDM1z98PaDJK1O7G6w3U6XLf9+pkP/HQU2u9LuKnmT11LgIJcQcKpCd2QNLjhhDjc
	 IRy5fxi7ghw1lqQufu25KbsnoQ2kd1P1pbt9KGyhNJXTyqhaHiVNxERsqWZ1r3MmMb
	 rJePTLczCw62CC5K/mSdrVIwpNHw7ah7ZnE7ecxg=
Subject: Patch "KVM: arm64: limit PMU version to PMUv3 for ARMv8.1" has been added to the 5.4-stable tree
To: andrew.murray@arm.com,gregkh@linuxfoundation.org,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,sashal@kernel.org,suzuki.poulose@arm.com,wanghaibin.wang@huawei.com,will@kernel.org,yuzenghui@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 30 Nov 2023 13:42:41 +0000
In-Reply-To: <20231128115725.964-3-yuzenghui@huawei.com>
Message-ID: <2023113041-finless-establish-232e@gregkh>
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

    KVM: arm64: limit PMU version to PMUv3 for ARMv8.1

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-limit-pmu-version-to-pmuv3-for-armv8.1.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-2889-greg=kroah.com@vger.kernel.org Tue Nov 28 11:57:52 2023
From: Zenghui Yu <yuzenghui@huawei.com>
Date: Tue, 28 Nov 2023 19:57:25 +0800
Subject: KVM: arm64: limit PMU version to PMUv3 for ARMv8.1
To: <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>, <sashal@kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>, <andrew.murray@arm.com>, <mark.rutland@arm.com>, <suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>, <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <20231128115725.964-3-yuzenghui@huawei.com>

From: Andrew Murray <andrew.murray@arm.com>

commit c854188ea01062f5a5fd7f05658feb1863774eaa upstream.

We currently expose the PMU version of the host to the guest via
emulation of the DFR0_EL1 and AA64DFR0_EL1 debug feature registers.
However many of the features offered beyond PMUv3 for 8.1 are not
supported in KVM. Examples of this include support for the PMMIR
registers (added in PMUv3 for ARMv8.4) and 64-bit event counters
added in (PMUv3 for ARMv8.5).

Let's trap the Debug Feature Registers in order to limit
PMUVer/PerfMon in the Debug Feature Registers to PMUv3 for ARMv8.1
to avoid unexpected behaviour.

Both ID_AA64DFR0.PMUVer and ID_DFR0.PerfMon follow the "Alternative ID
scheme used for the Performance Monitors Extension version" where 0xF
means an IMPLEMENTATION DEFINED PMU is implemented, and values 0x0-0xE
are treated as with an unsigned field (with 0x0 meaning no PMU is
present). As we don't expect to expose an IMPLEMENTATION DEFINED PMU,
and our cap is below 0xF, we can treat these fields as unsigned when
applying the cap.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[Mark: make field names consistent, use perfmon cap]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/sysreg.h |    6 ++++++
 arch/arm64/kvm/sys_regs.c       |   10 ++++++++++
 2 files changed, 16 insertions(+)

--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -697,6 +697,12 @@
 #define ID_AA64DFR0_TRACEVER_SHIFT	4
 #define ID_AA64DFR0_DEBUGVER_SHIFT	0
 
+#define ID_AA64DFR0_PMUVER_8_1		0x4
+
+#define ID_DFR0_PERFMON_SHIFT		24
+
+#define ID_DFR0_PERFMON_8_1		0x4
+
 #define ID_ISAR5_RDM_SHIFT		24
 #define ID_ISAR5_CRC32_SHIFT		16
 #define ID_ISAR5_SHA2_SHIFT		12
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1089,6 +1089,16 @@ static u64 read_id_reg(const struct kvm_
 			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
 			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
 			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
+	} else if (id == SYS_ID_AA64DFR0_EL1) {
+		/* Limit guests to PMUv3 for ARMv8.1 */
+		val = cpuid_feature_cap_perfmon_field(val,
+						ID_AA64DFR0_PMUVER_SHIFT,
+						ID_AA64DFR0_PMUVER_8_1);
+	} else if (id == SYS_ID_DFR0_EL1) {
+		/* Limit guests to PMUv3 for ARMv8.1 */
+		val = cpuid_feature_cap_perfmon_field(val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_1);
 	}
 
 	return val;


Patches currently in stable-queue which might be from kroah.com@vger.kernel.org are

queue-5.4/arm64-cpufeature-extract-capped-perfmon-fields.patch
queue-5.4/kvm-arm64-limit-pmu-version-to-pmuv3-for-armv8.1.patch
