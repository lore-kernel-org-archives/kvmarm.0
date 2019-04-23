Return-Path: <SRS0=x1Dw=SZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78651C282DD
	for <kvmarm@archiver.kernel.org>; Tue, 23 Apr 2019 04:42:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ECA6B20843
	for <kvmarm@archiver.kernel.org>; Tue, 23 Apr 2019 04:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECA6B20843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4590C4A389;
	Tue, 23 Apr 2019 00:42:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZixsZsfHkG2g; Tue, 23 Apr 2019 00:42:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CA294A417;
	Tue, 23 Apr 2019 00:42:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC064A417
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 00:42:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id klKtwvEXWAOO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Apr 2019 00:42:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4A94A389
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 00:42:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00938A78;
 Mon, 22 Apr 2019 21:42:53 -0700 (PDT)
Received: from a075553-lin.blr.arm.com (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BB7CC3F557;
 Mon, 22 Apr 2019 21:42:48 -0700 (PDT)
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v10 0/5] Add ARMv8.3 pointer authentication for kvm guest
Date: Tue, 23 Apr 2019 10:12:33 +0530
Message-Id: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
X-Mailer: git-send-email 2.7.4
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 linux-kernel@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190423044233.oeQ01vf3SIwima1ngWlJx7jz0PJnF5k5rNZl1lXSUZE@z>

Hi,

This patch series adds pointer authentication support for KVM guest and
is based on top of Linux kvmarm/next repo. The basic patches in this series was
originally posted by Mark Rutland earlier[1,2] and contains some history
of this work.

Extension Overview:
=============================================

The ARMv8.3 pointer authentication extension adds functionality to detect
modification of pointer values, mitigating certain classes of attack such as
stack smashing, and making return oriented programming attacks harder.

The extension introduces the concept of a pointer authentication code (PAC),
which is stored in some upper bits of pointers. Each PAC is derived from the
original pointer, another 64-bit value (e.g. the stack pointer), and a secret
128-bit key.

New instructions are added which can be used to:

* Insert a PAC into a pointer
* Strip a PAC from a pointer
* Authenticate and strip a PAC from a pointer

The detailed description of ARMv8.3 pointer authentication support in
userspace/kernel and can be found in Kristina's generic pointer authentication
patch series[3].

KVM guest work:
==============================================

If pointer authentication is enabled for KVM guests then the new PAC instructions
will not trap to EL2. If not then they may be ignored if in HINT region or trapped
in EL2 as illegal instruction. Since KVM guest vcpu runs as a thread so they have
a key initialized which will be used by PAC. When world switch happens between
host and guest then this key is exchanged.

The current v10 patch series contains review comments and suggestions by
Dave Martin and Mark Zyngier.

Major changes since v9 [11]:

* Move ptrauth enable, disable and setup_lazy function from C file to H file with
  static inline attribute.
* Add cpufeature static checks at many places to optimize for non-ptrauth systems.

Changes since v8 [10]: Major changes are listed below and detail changes are in
		      each patch.
* Added a new vcpu specific arch flag to control enabling/disabling ptrauth.
* Patches restructured as 3 patches related to hcr_el2, mdcr_el2 and
  hyp_symbol_addr cleanup and optimization dropped. They will be posted separately.

Changes since v7 [9]: Major changes are listed below and detail changes are in
		      each patch.
 * Comments and Documentation updated to reflect using address/generic
   features flag together.
 * Dropped the documentation patch and added those details in the relevant
   patches.
 * Rebased the patch series on 2 patches of Dave Martin v6 SVE series. 
 * Small bug fixes.

Changes since v6 [8]: Major changes are listed below.

* Pointer authentication key switch entirely in assembly now.
* isb instruction added after Key switched to host.
* Use __hyp_this_cpu_ptr for both VHE and nVHE mode.
* 2 separate flags for address and generic authentication.
* kvm_arm_vcpu_ptrauth_allowed renamed to has_vcpu_ptrauth.
* kvm_arm_vcpu_ptrauth_reset renamed to kvm_arm_vcpu_ptrauth_setup_lazy.
* Save of host Key registers now done in ptrauth instruction trap.
* A fix to add kern_hyp_va to get correct host_ctxt pointer in nVHE mode.
* Patches re-structured to better reflect ABI change.

Changes since v5 [7]: Major changes are listed below.

* Split hcr_el2 and mdcr_el2 save/restore in two patches.
* Reverted back save/restore of sys-reg keys as done in V4 [5]. There was
  suggestion by James Morse to use ptrauth utilities in a single place
  in arm core and use them from kvm. However this change deviates from the
  existing sys-reg implementations and is not scalable.
* Invoked the key switch C functions from __guest_enter/__guest_exit assembly.
* Host key save is now done inside vcpu_load.
* Reverted back masking of cpufeature ID registers for ptrauth when disabled
  from userpace.
* Reset of ptrauth key registers not done conditionally.
* Code and Documentation cleanup.

Changes since v4 [6]: Several suggestions from James Morse
* Move host registers to be saved/restored inside struct kvm_cpu_context.
* Similar to hcr_el2, save/restore mdcr_el2 register also.
* Added save routines for ptrauth keys in generic arm core and
  use them during KVM context switch.
* Defined a GCC attribute __no_ptrauth which discards generating
  ptrauth instructions in a function. This is taken from Kristina's
  earlier kernel pointer authentication support patches [4].
* Dropped a patch to mask cpufeature when not enabled from userspace and
  now only key registers are masked from register list.

Changes since v3 [5]:
* Use pointer authentication only when VHE is present as ARM8.3 implies ARM8.1
  features to be present.
* Added lazy context handling of ptrauth instructions from V2 version again. 
* Added more details in Documentation.

Changes since v2 [1,2]:
* Allow host and guest to have different HCR_EL2 settings and not just constant
  value HCR_HOST_VHE_FLAGS or HCR_HOST_NVHE_FLAGS.
* Optimise the reading of HCR_EL2 in host/guest switch by fetching it once
  during KVM initialisation state and using it later.
* Context switch pointer authentication keys when switching between guest
  and host. Pointer authentication was enabled in a lazy context earlier[2] and
  is removed now to make it simple. However it can be revisited later if there
  is significant performance issue.
* Added a userspace option to choose pointer authentication.
* Based on the userspace option, ptrauth cpufeature will be visible.
* Based on the userspace option, ptrauth key registers will be accessible.
* A small document is added on how to enable pointer authentication from
  userspace KVM API.

Looking for feedback and comments.

Thanks,
Amit

[1]: https://lore.kernel.org/lkml/20171127163806.31435-11-mark.rutland@arm.com/
[2]: https://lore.kernel.org/lkml/20171127163806.31435-10-mark.rutland@arm.com/
[3]: https://lkml.org/lkml/2018/12/7/666
[4]: https://lore.kernel.org/lkml/20181005084754.20950-1-kristina.martsenko@arm.com/
[5]: https://lkml.org/lkml/2018/10/17/594
[6]: https://lkml.org/lkml/2018/12/18/80
[7]: https://lkml.org/lkml/2019/1/28/49
[8]: https://lkml.org/lkml/2019/2/19/190 
[9]: https://lkml.org/lkml/2019/3/19/125 
[10]: https://lkml.org/lkml/2019/4/1/1595
[11]: https://lkml.org/lkml/2019/4/11/1072 

Linux (5.1-rc2 based kvmarm/next repo):

Amit Daniel Kachhap (3):
  KVM: arm64: Add a vcpu flag to control ptrauth for guest
  KVM: arm64: Add userspace flag to enable pointer authentication
  KVM: arm64: Add capability to advertise ptrauth for guest

Mark Rutland (1):
  KVM: arm/arm64: context-switch ptrauth registers

 Documentation/arm64/pointer-authentication.txt |  22 ++++-
 Documentation/virtual/kvm/api.txt              |  16 ++++
 arch/arm/include/asm/kvm_emulate.h             |   2 +
 arch/arm64/Kconfig                             |   5 +-
 arch/arm64/include/asm/kvm_emulate.h           |  16 ++++
 arch/arm64/include/asm/kvm_host.h              |  21 ++++-
 arch/arm64/include/asm/kvm_ptrauth.h           | 108 +++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h              |   2 +
 arch/arm64/kernel/asm-offsets.c                |   6 ++
 arch/arm64/kvm/handle_exit.c                   |  36 +++++++--
 arch/arm64/kvm/hyp/entry.S                     |  15 ++++
 arch/arm64/kvm/reset.c                         |  32 ++++++++
 arch/arm64/kvm/sys_regs.c                      |  43 +++++++++-
 include/uapi/linux/kvm.h                       |   2 +
 virt/kvm/arm/arm.c                             |   2 +
 15 files changed, 310 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_ptrauth.h

kvmtool:

Repo: git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git
Amit Daniel Kachhap (1):
  KVM: arm/arm64: Add a vcpu feature for pointer authentication

 arm/aarch32/include/kvm/kvm-cpu-arch.h    |  1 +
 arm/aarch64/include/asm/kvm.h             |  2 ++
 arm/aarch64/include/kvm/kvm-config-arch.h |  6 +++++-
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |  2 ++
 arm/include/arm-common/kvm-config-arch.h  |  2 ++
 arm/kvm-cpu.c                             | 20 ++++++++++++++++++--
 include/linux/kvm.h                       |  2 ++
 7 files changed, 32 insertions(+), 3 deletions(-)

-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
