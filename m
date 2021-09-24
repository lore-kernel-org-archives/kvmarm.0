Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44027C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5BA16140F
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B5BA16140F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C3704B163;
	Fri, 24 Sep 2021 08:54:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iB+n9WcXxQLK; Fri, 24 Sep 2021 08:54:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF59A4B165;
	Fri, 24 Sep 2021 08:54:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73ACE4B12C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z3R8VSC9vEeS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:03 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0FE64B11E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:02 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 x2-20020a5d54c2000000b0015dfd2b4e34so7997361wrv.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=OK6zX7a7Qmpm9rcrKEHoYPqhV/r9BP9zx58SZZJogJ0=;
 b=GNrClkroJVv0xqGduCn431JjZYAgBcefo+GE2TtYTnpcG56X7HcTUhuRaLKJwneHtE
 eSL4iKbTDAxftMm+g7YkiMcfTB5GLfW11rOgyvSI/bXARk1QentPTxUFSjZ3nZDWgtJN
 FRMfEPmokHDXnbzKTDL10PC9zZ71dVwOLJIOGRjlnKvUOmU1MzuIHy2ZeGdR7tHderJS
 nqkwYljbsEaTvhdirFplNdFPitdYKaHLa85GXk++V/vBi4FyFZlBGbMi1JehX4vJixKB
 MhVKCofHHsmuf9wwcd8UHhQPyfR32ofqDqOySXA1+3kmeeQbQAZo62i8fUQi0pYU/mTX
 vIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=OK6zX7a7Qmpm9rcrKEHoYPqhV/r9BP9zx58SZZJogJ0=;
 b=0QJV/DBbIp0Mu6qFe95GVffMNAFofZ9v8uFrSkDckMJc2cJjqqfMR4NnCC13Yq1Dof
 DDKbOGHYtSlc4pmMfxJlqH/5pwR1cwavIyFV3sNhjWkDMMeYt9Bi8lrdtQhv+rUSyoJs
 Jb8Q6wB/U5lEBMN+Qfim+5OOadMscW6I2SJS5W+Yx+z/cH83LhsopjkZDxqJAu104K8Y
 FaihO4X/BD1Zds4jdoFwni54Bbv0Hd9/J04Fo7oHPm8IgHwFGCuuT/VLH90B23sTURPJ
 FqsZ7teeBsXGwaB0WKRaIKyE/Dq2PSEmXq1kiG0bbZmQAVqsq+CnZ7eph0KPkgw6dbeT
 t5ng==
X-Gm-Message-State: AOAM531O9ZtrZDOxbmyRnvSQ6cVrSTGvg/O22ipg3FkR8HnK5r8pUHAB
 dQ5MobKlE3DgdtogUYT049p94R3nmfNtEeL/8XlJJj+PHuhTrAcEfIVYnungf3RXm3fcXTPFoMM
 EWkhcYrOg7+x/tXavlNhrATf5VqAublP1IZFRI5uNbxHLaSfAw6nXGnwO8u6Q++fwQ4A=
X-Google-Smtp-Source: ABdhPJwbJMTUwuBvfVMKqt+69OKDT6aY4QYIvI5Vf0wA9E0WLxB6W8XSl5oavUA13H1PTMaEnRHHfEPidg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:22d6:: with SMTP id
 22mr2005356wmg.17.1632488041842; Fri, 24 Sep 2021 05:54:01 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:29 +0100
Message-Id: <20210924125359.2587041-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 00/30] Reduce scope of vcpu state at hyp by refactoring
 out state hyp needs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Hi,

This is a prolog to a series where we try to maintain virtual machine and vcpu
state for protected VMs at the hypervisor [1].

The main issue is that in KVM, the VM state (struct kvm) and the vcpu state
(struct kvm_vcpu) are created by the host and are always accessible by it. For
protected VMs (pKVM [2]), only the hypervisor should have access to their state
and not trust the host to access it. Therefore, the hypervisor should maintain
a copy of VM state for all protected VMs to use that is not accessible by the
host.

The problem with using and with maintaining a copy of the existing kvm_vcpu
struct at the hypervisor is that it's big. Depending on the configuration, it
is in the order of 10kB (ymmv) per vcpu. Whereas most of what it needs to run a
VM is the kvm_cpu_ctxt and some hyp-related registers and flags, which amount
to less than 2kB. Many of the functions use the vcpu struct when all they
access is kvm_cpu_ctxt. Other functions only need that as well as a few
hypervisor state variables. Moreover, we would like to use the existing code,
rather than write new code for protected VMs that use new or special
structures.

This patch series reduces the scope of the functions that only need
kvm_cpu_ctxt to just that. It also takes out the few elements that are relevant
to the hypervisor from kvm_vcpu_arch into a new structure, vcpu_hyp_state. This
allows the remainder of the series to reduce the scope of everything accessed
by the hypervisor, at least for protected VMs, to kvm_cpu_ctxt and
vcpu_hyp_state (and maybe vgic if supported for protected VMs).

This series uses coccinelle semantic patches [3] as much as possible when
changes are made repetitively across many files. All patches that use
coccinelle are prefixed with COCCI.

Based on Linux 5.13-rc6.

Cheers,
/fuad

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2-state-cocci-out

[2] Once complete, protected KVM adds the ability to create protected VMs.
These protected VMs are protected from the host Linux kernel (and from other
VMs), where the host does not have access to guest memory,even if compromised.
Normal (nVHE) guests can still be created and run in parallel with protected
VMs. Their functionality should not be affected.

For protected VMs, the host should not even have access to a protected guest's
state or anything that would enable it to manipulate it (e.g., vcpu register
context and el2 system registers); only hyp would have that access. If the host
could access that state, then it might be able to get around the protection
provided.  Therefore, anything that is sensitive and that would require such
access needs to happen at hyp, hence the code in nvhe running only at hyp.

For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/slides/kvmforum-2020-edited.pdf
https://www.youtube.com/watch?v=edqJSzsDRxk

[3] https://coccinelle.gitlabpages.inria.fr/website/

Fuad Tabba (30):
  KVM: arm64: placeholder to check if VM is protected
  [DONOTMERGE] Temporarily disable unused variable warning
  [DONOTMERGE] Coccinelle scripts for refactoring
  KVM: arm64: remove unused parameters and asm offsets
  KVM: arm64: add accessors for kvm_cpu_context
  KVM: arm64: COCCI: use_ctxt_access.cocci: use kvm_cpu_context
    accessors
  KVM: arm64: COCCI: add_ctxt.cocci use_ctxt.cocci: reduce scope of
    functions to kvm_cpu_ctxt
  KVM: arm64: add hypervisor state accessors
  KVM: arm64: COCCI: vcpu_hyp_accessors.cocci: use accessors for
    hypervisor state vcpu variables
  KVM: arm64: Add accessors for hypervisor state in kvm_vcpu_arch
  KVM: arm64: create and use a new vcpu_hyp_state struct
  KVM: arm64: COCCI: add_hypstate.cocci use_hypstate.cocci: Reduce scope
    of functions to hyp_state
  KVM: arm64: change function parameters to use kvm_cpu_ctxt and
    hyp_state
  KVM: arm64: reduce scope of vgic v2
  KVM: arm64: COCCI: vgic3_cpu.cocci: reduce scope of vgic v3
  KVM: arm64: reduce scope of vgic_v3 access parameters
  KVM: arm64: access __hyp_running_vcpu via accessors only
  KVM: arm64: reduce scope of __guest_exit to only depend on
    kvm_cpu_context
  KVM: arm64: change calls of get_loaded_vcpu to get_loaded_vcpu_ctxt
  KVM: arm64: add __hyp_running_ctxt and __hyp_running_hyps
  KVM: arm64: transition code to __hyp_running_ctxt and
    __hyp_running_hyps
  KVM: arm64: reduce scope of __guest_enter to depend only on
    kvm_cpu_ctxt
  KVM: arm64: COCCI: remove_unused.cocci: remove unused ctxt and
    hypstate variables
  KVM: arm64: remove unused functions
  KVM: arm64: separate kvm_run() for protected VMs
  KVM: arm64: pVM activate_traps to use vcpu_ctxt and vcpu_hyp_state
  KVM: arm64: remove unsupported pVM features
  KVM: arm64: reduce scope of pVM fixup_guest_exit to hyp_state and
    kvm_cpu_ctxt
  [DONOTMERGE] Remove Coccinelle scripts added for refactoring
  [DONOTMERGE] Re-enable warnings

 arch/arm64/include/asm/kvm_asm.h           |  33 ++-
 arch/arm64/include/asm/kvm_emulate.h       | 292 ++++++++++++++++-----
 arch/arm64/include/asm/kvm_host.h          | 110 ++++++--
 arch/arm64/include/asm/kvm_hyp.h           |  14 +-
 arch/arm64/kernel/asm-offsets.c            |   7 +-
 arch/arm64/kvm/arm.c                       |   2 +-
 arch/arm64/kvm/debug.c                     |  28 +-
 arch/arm64/kvm/fpsimd.c                    |  22 +-
 arch/arm64/kvm/guest.c                     |  30 +--
 arch/arm64/kvm/handle_exit.c               |   8 +-
 arch/arm64/kvm/hyp/aarch32.c               |  26 +-
 arch/arm64/kvm/hyp/entry.S                 |  23 +-
 arch/arm64/kvm/hyp/exception.c             | 113 ++++----
 arch/arm64/kvm/hyp/hyp-entry.S             |   8 +-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  26 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 101 ++++---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  43 +--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/host.S             |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           | 155 ++++++++---
 arch/arm64/kvm/hyp/nvhe/timer-sr.c         |   4 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   |  32 ++-
 arch/arm64/kvm/hyp/vgic-v3-sr.c            | 242 +++++++++++------
 arch/arm64/kvm/hyp/vhe/switch.c            |  40 +--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         |   3 +-
 arch/arm64/kvm/inject_fault.c              |  10 +-
 arch/arm64/kvm/reset.c                     |  16 +-
 arch/arm64/kvm/sys_regs.c                  |   4 +-
 29 files changed, 951 insertions(+), 459 deletions(-)


base-commit: 6d53b3be3b9be497fbe054f35154f508deac729c
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
