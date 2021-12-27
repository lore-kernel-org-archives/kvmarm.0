Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6382AC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Dec 2021 09:57:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0767411BD;
	Mon, 27 Dec 2021 04:57:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vU3gxb9IYqPh; Mon, 27 Dec 2021 04:57:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AAA64120D;
	Mon, 27 Dec 2021 04:57:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D795E40BDC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 03:17:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KtSDD0BbFkYx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Dec 2021 03:17:14 -0500 (EST)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D06BD40C80
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 03:17:13 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1640593033; x=1672129033;
 h=from:to:cc:subject:date:message-id:mime-version:
 content-transfer-encoding;
 bh=tCJzGvAoR9V3Cf25Th6SaPQVLQdtAnnLPINob5E2Vys=;
 b=RXV3TFHXVyh2oG96Erac847w+s9TXkyX91FRqj7Tp+KUucvNPu9/NABs
 pyNxLdhJcYbp2cbkmzH+CLAon3MIGyhwxZhxCsIO1d0D/D8j2GXh0RSyz
 rzp1Z4s4f81gLgoR35Edj8R+aha9uHq4PLQdvqROTM8G9YDLHB3bcHHQW
 KZ/b+Jk3oABmAI1nCWCImIKg2R2+eSt1tU8b6GXSDUq6eeUj2hG981Sol
 SpWES6K8p+u8VN7RkC3LHsJb5ntKbx6NyZP+GFV9zMg4OcVqaNzKo6Awy
 1p2ctmy4nc8cpWnI+mvCcgxPvsHaH7uRToLiRdimWyN0WZ1+zQmO1teGz A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10209"; a="241396750"
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; d="scan'208";a="241396750"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 27 Dec 2021 00:17:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; d="scan'208";a="523207964"
Received: from unknown (HELO hyperv-sh4.sh.intel.com) ([10.239.48.22])
 by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 27 Dec 2021 00:16:56 -0800
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
 tglx@linutronix.de
Subject: [PATCH 0/6] Improve KVM's interaction with CPU hotplug
Date: Mon, 27 Dec 2021 16:15:06 +0800
Message-Id: <20211227081515.2088920-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailman-Approved-At: Mon, 27 Dec 2021 04:57:09 -0500
Cc: Guo Ren <guoren@linux.alibaba.com>, Wanpeng Li <wanpengli@tencent.com>,
 David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 linux-mips@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
 Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 linux-riscv@lists.infradead.org,
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
 Paul Walmsley <paul.walmsley@sifive.com>,
 Sumanth Korikkar <sumanthk@linux.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Fabiano Rosas <farosas@linux.ibm.com>,
 Mel Gorman <mgorman@techsingularity.net>, Anup Patel <anup.patel@wdc.com>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Bharata B Rao <bharata@linux.ibm.com>, kvm-riscv@lists.infradead.org,
 Michael Ellerman <mpe@ellerman.id.au>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, Thomas Richter <tmricht@linux.ibm.com>
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
3. abort onlining incompatible CPUs if there is a running VM.

This series is a follow-up to the discussion about KVM and CPU hotplug
https://lore.kernel.org/lkml/3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com/T/

Note: this series is tested only on Intel systems.

Chao Gao (6):
  KVM: x86: Move check_processor_compatibility from init ops to runtime
    ops
  KVM: x86: Use kvm_x86_ops in kvm_arch_check_processor_compat
  KVM: Remove opaque from kvm_arch_check_processor_compat
  KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
  KVM: x86: Remove WARN_ON in kvm_arch_check_processor_compat
  KVM: Do compatibility checks on hotplugged CPUs

 arch/arm64/kvm/arm.c            |  2 +-
 arch/mips/kvm/mips.c            |  2 +-
 arch/powerpc/kvm/powerpc.c      |  2 +-
 arch/riscv/kvm/main.c           |  2 +-
 arch/s390/kvm/kvm-s390.c        |  2 +-
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          |  4 +-
 arch/x86/kvm/vmx/evmcs.c        |  2 +-
 arch/x86/kvm/vmx/evmcs.h        |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 12 +++---
 arch/x86/kvm/x86.c              |  7 +---
 include/linux/cpuhotplug.h      |  2 +-
 include/linux/kvm_host.h        |  2 +-
 virt/kvm/kvm_main.c             | 74 ++++++++++++++++++++++++---------
 14 files changed, 74 insertions(+), 43 deletions(-)

-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
