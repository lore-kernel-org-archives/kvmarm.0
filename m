Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EEDC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 08:52:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26FF349EEA;
	Tue, 18 Jan 2022 03:52:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 23afjePGeJ5N; Tue, 18 Jan 2022 03:52:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BA7149EBC;
	Tue, 18 Jan 2022 03:52:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54AD04141D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 01:49:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XIbSRSZsol77 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 01:49:41 -0500 (EST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58FB740BCF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 01:49:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1642488581; x=1674024581;
 h=from:to:cc:subject:date:message-id:mime-version:
 content-transfer-encoding;
 bh=Qle7iYX0bWtMWgGrX9XT60FWnCJkJa+OHVP1jvUZDP4=;
 b=NfJdI1sG9aByRorDiFE5YJdj5aXQ6U9pUrJ7dCfL82d18Bhi2wp3cMTm
 inGBYdpZywu4m5CqatbpiLt4ZHPfY9iZhZS2DyebskjwKmb7Yx/34V8Y3
 sxfJcd3Lo4BqUwIQBuMo/Jd7t1m/e0QMNcC6O3Nx7iezADCZVpCXG6NeE
 pNO46UDTb3zR5IOeT1A8ffIi7lb3OBXL0JTx27cCHYb5Rq3Xzil008sPo
 0a+c0DgRHqHIVR2PoXzDyqkHrLTzu5w+hwfPcNZMVFgvPd+FtY1J8V+wv
 hpq23xOtjvEEnCu7KJkqNSeoZ/0LEnRhR3tSXAWFloAmFlUhIIjoHhHTp w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="244710349"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; d="scan'208";a="244710349"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 17 Jan 2022 22:49:29 -0800
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; d="scan'208";a="531648541"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
 by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 17 Jan 2022 22:49:17 -0800
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
 kevin.tian@intel.com, tglx@linutronix.de
Subject: [PATCH v2 0/4] Improve KVM's interaction with CPU hotplug
Date: Tue, 18 Jan 2022 14:44:23 +0800
Message-Id: <20220118064430.3882337-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 18 Jan 2022 03:52:33 -0500
Cc: Thomas Richter <tmricht@linux.ibm.com>, Wanpeng Li <wanpengli@tencent.com>,
 David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
 Michael Ellerman <mpe@ellerman.id.au>, "H. Peter Anvin" <hpa@zytor.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-riscv@lists.infradead.org,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, John Garry <john.garry@huawei.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Shaokun Zhang <zhangshaokun@hisilicon.com>, Borislav Petkov <bp@alien8.de>,
 =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Atish Patra <atishp@atishpatra.org>,
 Sumanth Korikkar <sumanthk@linux.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Fabiano Rosas <farosas@linux.ibm.com>, Hector Martin <marcan@marcan.st>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Bharata B Rao <bharata@linux.ibm.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Changes from v1->v2: (all comments/suggestions on v1 are from Sean, thanks)
 - Merged v1's patch 2 into patch 1, and v1's patch 5 into patch 6.
 - Use static_call for check_processor_compatibility().
 - Generate patch 2 with "git revert" and do manual changes based on that.
 - Loosen the WARN_ON() in kvm_arch_check_processor_compat() instead of
   removing it.
 - KVM always prevent incompatible CPUs from being brought up regardless of
   running VMs.
 - Use pr_warn instead of pr_info to emit logs when KVM finds offending
   CPUs.

KVM registers its CPU hotplug callback to CPU starting section. And in the
callback, KVM enables hardware virtualization on hotplugged CPUs if any VM
is running on existing CPUs.

There are two problems in the process:
1. KVM doesn't do compatibility checks before enabling hardware
virtualization on hotplugged CPUs. This may cause #GP if VMX isn't
supported or vmentry failure if some in-use VMX features are missing on
hotplugged CPUs. Both break running VMs.
2. Callbacks in CPU STARTING section cannot fail. So, even if KVM finds
some incompatible CPUs, its callback cannot block CPU hotplug.

This series improves KVM's interaction with CPU hotplug to avoid
incompatible CPUs breaking running VMs. Following changes are made:

1. move KVM's CPU hotplug callback to ONLINE section (suggested by Thomas)
2. do compatibility checks on hotplugged CPUs.
3. abort onlining incompatible CPUs

This series is a follow-up to the discussion about KVM and CPU hotplug
https://lore.kernel.org/lkml/3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com/T/

Note: this series is tested only on Intel systems.

Chao Gao (4):
  KVM: x86: Move check_processor_compatibility from init ops to runtime
    ops
  Partially revert "KVM: Pass kvm_init()'s opaque param to additional
    arch funcs"
  KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
  KVM: Do compatibility checks on hotplugged CPUs

 arch/arm64/kvm/arm.c               |  2 +-
 arch/mips/kvm/mips.c               |  2 +-
 arch/powerpc/kvm/powerpc.c         |  2 +-
 arch/riscv/kvm/main.c              |  2 +-
 arch/s390/kvm/kvm-s390.c           |  2 +-
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/svm/svm.c             |  4 +-
 arch/x86/kvm/vmx/evmcs.c           |  2 +-
 arch/x86/kvm/vmx/evmcs.h           |  2 +-
 arch/x86/kvm/vmx/vmx.c             | 12 +++---
 arch/x86/kvm/x86.c                 | 16 +++++---
 include/linux/cpuhotplug.h         |  2 +-
 include/linux/kvm_host.h           |  2 +-
 virt/kvm/kvm_main.c                | 62 ++++++++++++++++++++----------
 15 files changed, 71 insertions(+), 44 deletions(-)

-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
