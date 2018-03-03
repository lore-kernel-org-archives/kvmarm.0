From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v10 0/5] set VSESR_EL2 by user space and support NOTIFY_SEI notification
Date: Sun, 4 Mar 2018 00:09:35 +0800
Message-ID: <1520093380-42577-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, james.morse@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: gengdongjiu@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

1. Detect whether KVM can set set guest SError syndrome
2. Support to Set VSESR_EL2 and inject SError by user space.
3. Support live migration to keep SError pending state and VSESR_EL2 value.
4. ACPI 6.1 adds support for NOTIFY_SEI as a GHES notification mechanism, so support this
   notification in software, KVM or kernel ARCH code call handle_guest_sei() to let ACP driver
   to handle this notification.

Dongjiu Geng (5):
  arm64: KVM: Prepare set virtual SEI syndrome value
  arm64: KVM: export the capability to set guest SError syndrome
  arm/arm64: KVM: Introduce set and get per-vcpu event
  ACPI / APEI: Add SEI notification type support for ARMv8
  arm64: handle NOTIFY_SEI notification by the APEI driver

 Documentation/virtual/kvm/api.txt    | 37 +++++++++++++++++++++++--
 arch/arm/include/asm/kvm_host.h      |  6 ++++
 arch/arm/kvm/guest.c                 | 12 ++++++++
 arch/arm64/include/asm/kvm_emulate.h |  5 ++++
 arch/arm64/include/asm/kvm_host.h    |  7 +++++
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/include/uapi/asm/kvm.h    | 10 +++++++
 arch/arm64/kernel/traps.c            |  4 +++
 arch/arm64/kvm/guest.c               | 26 ++++++++++++++++++
 arch/arm64/kvm/inject_fault.c        |  5 ++++
 arch/arm64/kvm/reset.c               |  4 +++
 arch/arm64/mm/fault.c                | 10 +++++++
 drivers/acpi/apei/Kconfig            | 15 ++++++++++
 drivers/acpi/apei/ghes.c             | 53 ++++++++++++++++++++++++++++++++++++
 include/acpi/ghes.h                  |  1 +
 include/uapi/linux/kvm.h             |  1 +
 virt/kvm/arm/arm.c                   | 18 ++++++++++++
 17 files changed, 213 insertions(+), 2 deletions(-)

-- 
1.9.1
