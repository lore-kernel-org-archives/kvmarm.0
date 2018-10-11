From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v3 0/2] rename function name and enable 32bit vcpu events
Date: Thu, 11 Oct 2018 15:07:33 -0400
Message-ID: <1539284855-4035-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@arm.com, marc.zyngier@arm.com, suzuki.poulose@arm.com, peter.maydell@linaro.org, drjones@redhat.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Rename the kvm_arch_dev_ioctl_check_extension() to 
kvm_arch_vm_ioctl_check_extension, because the name
is not reasonable; 

Enable the 32 bit vcpu events support.

Change since v2:
1. Address Suzuki's comments to update the patch commit messages

change since v1:
1. Update patch commit messages.

Dongjiu Geng (2):
  arm/arm64: KVM: rename function kvm_arch_dev_ioctl_check_extension()
  arm/arm64: KVM: enable 32 bits kvm vcpu events support

 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 5 ++---
 virt/kvm/arm/arm.c                | 3 ++-
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
1.9.1
