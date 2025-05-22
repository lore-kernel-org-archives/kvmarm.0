Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846BB286425
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747912339; cv=none; b=UDtUUeWYdnWy+eX24QjtDo0OSbWAgU+uMtEmOJiKn6F+FZ3uC9QDf6xa+gQ2PMFzr9aXVmUpK8vhUnMF7pu+kEkKNyW96d1ugRE9xBxkukXsDegsvX7RGC6pXS/FVgWj9I9finlDu+WvBI9Cz8jIgl9TkWYahLgJTI9mkDfyNPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747912339; c=relaxed/simple;
	bh=75I/OW5q8OM58GIc6q02iQepqOY7feV5LCtaTaQtmtw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H8lNVY3/7QLo5BNX+XQP2EBNMaSDXk3MlCqNREilHaqSV2td6dSpZUoMn+FSOn7dY4/4SHewRhQuUiHzKHhNPPEpUm7BHVeL0cCgXPrh2tkVKb0c5x+EW1X1P3w26Q4vaMkN3DZKWaIp69TcfjMtu+bHE6iAzOZEbUVJyk4GvrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4b35Fj0bH7z1f1gs;
	Thu, 22 May 2025 19:11:21 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 775FF1800B3;
	Thu, 22 May 2025 19:12:15 +0800 (CST)
Received: from kwepemq200011.china.huawei.com (7.202.195.155) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 22 May 2025 19:11:58 +0800
Received: from huawei.com (10.67.174.28) by kwepemq200011.china.huawei.com
 (7.202.195.155) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 May
 2025 19:11:56 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <mark.rutland@arm.com>, <broonie@kernel.org>,
	<liaochang1@huawei.com>, <puranjay@kernel.org>, <sgsu.park@samsung.com>,
	<frederic@kernel.org>, <gshan@redhat.com>, <sudeep.holla@arm.com>,
	<guohanjun@huawei.com>, <ryan.roberts@arm.com>,
	<Jonathan.Cameron@huawei.com>, <liuwei09@cestc.cn>,
	<shameerali.kolothum.thodi@huawei.com>, <james.morse@arm.com>,
	<hardevsinh.palaniya@siliconsignals.io>, <ptosi@google.com>,
	<kristina.martsenko@arm.com>, <vschneid@redhat.com>,
	<thiago.bauermann@linaro.org>, <yang@os.amperecomputing.com>,
	<david@redhat.com>, <minhuadotchen@gmail.com>, <tglx@linutronix.de>,
	<farbere@amazon.com>, <arnd@arndb.de>, <rppt@kernel.org>,
	<mcgrof@kernel.org>, <guoweikang.kernel@gmail.com>, <robh@kernel.org>,
	<andreyknvl@gmail.com>, <usamaarif642@gmail.com>,
	<samuel.holland@sifive.com>, <kevin.brodsky@arm.com>, <Dave.Martin@arm.com>,
	<rmk+kernel@armlinux.org.uk>, <jean-philippe@linaro.org>,
	<ruanjinjie@huawei.com>, <dianders@chromium.org>, <pcc@google.com>,
	<bigeasy@linutronix.de>, <jintack@cs.columbia.edu>,
	<christoffer.dall@arm.com>, <tabba@google.com>, <robin.murphy@arm.com>,
	<ziy@nvidia.com>, <wangkefeng.wang@huawei.com>, <quic_zhenhuah@quicinc.com>,
	<anshuman.khandual@arm.com>, <yangyicong@hisilicon.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v5 0/2] Rework Arm64 exception mask helpers
Date: Thu, 22 May 2025 10:56:56 +0000
Message-ID: <20250522105658.1338331-1-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200011.china.huawei.com (7.202.195.155)

This patch series is a significant rework of the exception mask helpers,
building upon the discussions from a year ago [1]. The need for this
reworking has become increasingly apparent with the emerging platform
and virtualization support for FEAT_NMI [2], and Mark Brown's FEAT_NMI
patch series [3] really highlighted the existing "hacking style"
approach to DAIF management that needed addressing before NMI
functionality could be properly integrated.

Furthermore, with Jonathan has platform that now support FEAT_NMI,
there's a strong desire to see Mark Brown's FEAT_NMI patchset merged
soon. All of these factors emphasize the importance of a robust and
clean exception mask rework. Therefore, I'm pushing this patchset again
and would greatly appreciate your review.

This series broadly follows the suggestions made by Mark Rutland in
response [4] to Mark Brown's FEAT_NMI patchset. To summarize his
thoughts on DAIF + PMR + ALLINT management:

(a) Adding entry-specific helpers to manipulate abstract exception masks
    covering DAIF + PMR + ALLINT. Those need unmask-at-entry and
    mask-at-exit behaviour, and today only need to manage DAIF + PMR.

    It should be possible to do this ahead of ALLINT / NMI support.

(b) Adding new "logical exception mask" helpers that treat DAIF + PMR +
    ALLINT as separate elements. 

While attempting to follow Mark Rutland's guidance, I may have initially
misunderstood some nuances, leading to a complete redesign and recoding
of this patchset. As a result, it looks rather different from the previous
revision.

In short summary, to reduce the complexity of a single, monolithic
function trying to handle every scenario, this patchset now introduces
two distinct series of logical exception mask helpers. Each series is
tailored for a specific kernel configuration and use case. I believe
this policy makes the behavior of each exception mask helper much more
explicit for any given situation, and simplifies the future integration
of FEAT_NMI support without introducing further complexity.

Thanks,

[1] https://lore.kernel.org/all/20240614034433.602622-1-liaochang1@huawei.com/
[2] https://lore.kernel.org/all/20240407081733.3231820-1-ruanjinjie@huawei.com/
[3] https://lore.kernel.org/linux-arm-kernel/20221112151708.175147-1-broonie@kernel.org/
[4] https://lore.kernel.org/linux-arm-kernel/Y5c9SLeJacLYHmP7@FVFF77S0Q05N/

v5->v4:
1. The rework has been fully redesigned, you'll find all the details in
   the first patch.
2. The rework focus on replacing the helpers defined in daifflags.h, so
   less patches in this series, it will be easier to review and discuss.

v4->v3:
General Enhancements
--------------------
Commit messages of [PATCH 04/05/06] have been enriched to outline the
implementation details, motivations and potential effects. This might
improve develper understanding and review efficiency.

Specific Changes
----------------
1. [PATCH 01] new utilize the existing helper maco in sysregs.h to
   generate the "MSR ALLLINT, #Imm1" instruction. Additionally, helper
   names have been renamed to start with msr_pstate_ for better
   discoverability (as suggested by Mark Brown).

2. For [PATCH 04], due to the barrier side-effect of writing to PSTATE
   fields, it is unnecessary to call pmr_sync() in
   __pmr_local_allint_restore(). Add a table in comments to depict the
   relationship between the type of interrupt masking and hardware
   register configuration.

3. For [PATCH 05/06], function names have been revised to better reflect
   their purpose:

   local_errint_enable()       -> local_irq_serror_enable()
   local_errint_disable()      -> local_nmi_serror_disable()
   local_allint_mark_enabled() -> local_irq_mark_enabled()
   local_allint_disable()      -> local_nmi_disable()
   local_errnmi_enable()       -> local_nmi_serror_enable()

4. For [PATCH 07], A bug in local_nmi_enable() has been fixed. The v3
   version is overly complex and included an unnecessary write operation
   to PSTATE.DAIF.

5. [PATCH 09] introduce a slight optimization for NMI handling. Since
   the intermediate step of marking IRQ TO-BE enabled is no longer
   required, dropping PMR before acknowledge PSEUDO_NMI is also
   unnecessary.

6. [PATCH 10] migrates CPU idle contex save/restore operation to the
   newly introduced logical interrupt masking helper functions.

v3->v2:
1. Squash two commits that address two minor issues into Mark Brown's
   origin patch for detecting FEAT_NMI.
2. Add one patch resolves the kprobe reenter panic while testing
   FEAT_NMI on QEMU.

v2->v1:
Add SoB tags following the origin author's SoBs.

---

Liao Chang (2):
  arm64: New exception mask helpers to manage DAIF, PMR and ALLINT
  arm64: Deprecate the old daifflags helpers

 arch/arm64/include/asm/daifflags.h      | 144 -------------------
 arch/arm64/include/asm/exception_mask.h | 137 ++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h       |   2 +-
 arch/arm64/include/asm/mmu_context.h    |   2 +-
 arch/arm64/kernel/Makefile              |   2 +-
 arch/arm64/kernel/acpi.c                |  10 +-
 arch/arm64/kernel/cpufeature.c          |   3 +
 arch/arm64/kernel/debug-monitors.c      |   6 +-
 arch/arm64/kernel/entry-common.c        |  81 +++++------
 arch/arm64/kernel/exception_mask.c      | 177 ++++++++++++++++++++++++
 arch/arm64/kernel/hibernate.c           |   6 +-
 arch/arm64/kernel/irq.c                 |   4 +-
 arch/arm64/kernel/machine_kexec.c       |   4 +-
 arch/arm64/kernel/probes/kprobes.c      |   2 +-
 arch/arm64/kernel/setup.c               |   4 +-
 arch/arm64/kernel/signal.c              |   2 +-
 arch/arm64/kernel/smp.c                 |  10 +-
 arch/arm64/kernel/suspend.c             |   6 +-
 arch/arm64/kernel/traps.c               |   2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c         |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |   4 +-
 arch/arm64/mm/fault.c                   |   2 +-
 arch/arm64/mm/mmu.c                     |   6 +-
 23 files changed, 397 insertions(+), 223 deletions(-)
 delete mode 100644 arch/arm64/include/asm/daifflags.h
 create mode 100644 arch/arm64/include/asm/exception_mask.h
 create mode 100644 arch/arm64/kernel/exception_mask.c

-- 
2.34.1

