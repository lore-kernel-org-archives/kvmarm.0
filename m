From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/2] KVM: Synchronize KVM devices list access and create ops
Date: Tue,  9 Aug 2016 14:20:33 +0200
Message-ID: <20160809122035.16196-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org
Cc: Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Alexander Graf <agraf@suse.de>, borntraeger@de.ibm.com, paulus@ozlabs.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Currently accesses the kvm->devices list is not synchronized by any
mechanism which can potentially lead to data corruption.  Further, a
number of the create operations on the individual devices are racy and
would allow creation of multiple devices, opposite to the intention.

Factor out portions of the XICS create operation into a separate init
operation and protect the remaining list accesses and create operations
with the kvm->lock.

Tested on arm/arm64 and compile-tested on powerpc for the xics changes.
Tested-by on other archs would be appreciated.

Christoffer Dall (2):
  KVM: PPC: Move xics_debugfs_init out of create
  KVM: Protect device ops->create and list_add with kvm->lock

 arch/arm/kvm/arm.c             |  6 +++++-
 arch/powerpc/kvm/book3s_xics.c | 12 ++++++++----
 include/linux/kvm_host.h       |  6 ++++++
 virt/kvm/arm/vgic/vgic-init.c  | 17 ++++-------------
 virt/kvm/kvm_main.c            | 16 +++++++++++++++-
 5 files changed, 38 insertions(+), 19 deletions(-)

-- 
2.9.0

