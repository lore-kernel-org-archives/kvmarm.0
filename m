From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH/RFC 0/2] KVM: micro-optimization and interrupt disabling
Date: Tue, 28 Apr 2015 12:32:46 +0200
Message-ID: <1430217168-25504-1-git-send-email-borntraeger@de.ibm.com>
Return-path: <kvm-ppc-owner@vger.kernel.org>
Sender: kvm-ppc-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>
List-Id: kvmarm@lists.cs.columbia.edu

I was able to get rid of some nanoseconds for a guest exit loop
on s390. I did my best to not break other architectures but
review and comments on the general approach is welcome.
Downside is that the existing irq_save things will just work
no matter what the callers have done, the new code must do
the right thing in the callers.

Is that approach acceptible? Does anybody else see some measurable
difference for guest exits?


Christian Borntraeger (2):
  KVM: Push down irq_save to architectures before kvm_guest_enter
  KVM: push down irq_save from kvm_guest_exit

 arch/powerpc/kvm/book3s_hv.c |  4 ++++
 arch/powerpc/kvm/book3s_pr.c |  2 ++
 arch/powerpc/kvm/booke.c     |  4 ++--
 arch/s390/kvm/kvm-s390.c     |  6 ++++--
 arch/x86/kvm/x86.c           |  2 ++
 include/linux/kvm_host.h     | 18 ++++++++----------
 6 files changed, 22 insertions(+), 14 deletions(-)

-- 
2.3.0
