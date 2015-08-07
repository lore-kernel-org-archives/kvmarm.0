From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 0/4] KVM: arm/arm64: guest synchronous halt/resume
Date: Fri,  7 Aug 2015 18:08:29 +0200
Message-ID: <1438963713-10460-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AE725A4C5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:56:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vn3EOdaxck+W for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Aug 2015 11:56:28 -0400 (EDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
 [209.85.212.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15F555A4C3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:56:27 -0400 (EDT)
Received: by wibxm9 with SMTP id xm9so67294538wib.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Aug 2015 09:09:20 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series introduces the capability to synchronously exit the guest
and prevent it from being re-entered. This modality will be used by
IRQ forwarding series when changing the state of the IRQ.

Former pause flag used when starting the vcpu in KVM_ARM_VCPU_POWER_OFF
state, in PSCI calls and in KVM_SET_MP_STATE ioctl is renamed into
power_off. A new pause flag is introduced. Both now are checked in
kvm_arch_vcpu_runnable and in the VCPU_RUN critical section, before
entering the vcpu.

Best Regards

Eric

History:

v1 -> v2:
- check pause, power_off and in kvm_arch_vcpu_runnable
- check power_off in vcpu_run critcal section before guest entry
- correct compil issue in first patch reported by Andrew
- rename vcpu_pause into vcpu_sleep

RFC -> PATCH v1:
- originally part of [RFC 00/17] ARM IRQ forward control based on IRQ
  bypass manager (https://lkml.org/lkml/2015/7/2/268) and isolated in
  this series.
- added __maybe_unused following Marc's advice


Eric Auger (4):
  KVM: arm/arm64: rename pause into power_off
  KVM: arm/arm64: check power_off in kvm_arch_vcpu_runnable
  KVM: arm/arm64: check power_off in critical section before VCPU run
  KVM: arm/arm64: implement kvm_arm_[halt,resume]_guest

 arch/arm/include/asm/kvm_host.h   |  5 +++-
 arch/arm/kvm/arm.c                | 53 ++++++++++++++++++++++++++++++---------
 arch/arm/kvm/psci.c               | 10 ++++----
 arch/arm64/include/asm/kvm_host.h |  3 +++
 4 files changed, 53 insertions(+), 18 deletions(-)

-- 
1.9.1
