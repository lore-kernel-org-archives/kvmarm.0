Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1C238DE3
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2vvfOYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A64C433C8;
	Thu, 30 Nov 2023 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701351759;
	bh=GmNfrfag5HTnHJDaMh6QBM7YJ7eBEu8p6kXQxAbXhC8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=p2vvfOYNFweGnBbduJWQItJQ68bjM+f+9lzGyTNLZMaroWM26gI2+uXwwmZAdgq1l
	 7CrznVMSCbX54t0iifM7UN+xU4T5GwAtE/JHFnlirgZ76sW0ohDq+j6OoMbC3enXk/
	 omd7N8fkA9hyp6TSCLkATn4jRE6E22Nw23GEOaDE=
Subject: Patch "KVM: arm64: limit PMU version to PMUv3 for ARMv8.1" has been added to the 4.19-stable tree
To: andrew.murray@arm.com,gregkh@linuxfoundation.org,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,sashal@kernel.org,suzuki.poulose@arm.com,wanghaibin.wang@huawei.com,will@kernel.org,yuzenghui@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 30 Nov 2023 13:42:29 +0000
In-Reply-To: <20231128074633.646-3-yuzenghui@huawei.com>
Message-ID: <2023113029-pantyhose-angelic-f182@gregkh>
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

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-limit-pmu-version-to-pmuv3-for-armv8.1.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-2864-greg=kroah.com@vger.kernel.org Tue Nov 28 07:47:10 2023
From: Zenghui Yu <yuzenghui@huawei.com>
Date: Tue, 28 Nov 2023 15:46:33 +0800
Subject: KVM: arm64: limit PMU version to PMUv3 for ARMv8.1
To: <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>, <sashal@kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>, <andrew.murray@arm.com>, <mark.rutland@arm.com>, <suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>, <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <20231128074633.646-3-yuzenghui@huawei.com>

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
[yuzenghui@huawei.com: adjust the context in read_id_reg()]
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/sysreg.h |    6 ++++++
 arch/arm64/kvm/sys_regs.c       |   10 ++++++++++
 2 files changed, 16 insertions(+)

--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -622,6 +622,12 @@
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
@@ -1049,6 +1049,16 @@ static u64 read_id_reg(struct sys_reg_de
 			kvm_debug("LORegions unsupported for guests, suppressing\n");
 
 		val &= ~(0xfUL << ID_AA64MMFR1_LOR_SHIFT);
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

queue-4.19/arm64-cpufeature-extract-capped-perfmon-fields.patch
queue-4.19/kvm-arm64-limit-pmu-version-to-pmuv3-for-armv8.1.patch
