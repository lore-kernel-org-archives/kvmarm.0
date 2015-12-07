From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v4 0/4] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Mon, 07 Dec 2015 12:48:12 +0300
Message-ID: <013501d130d4$635722f0$2a0568d0$@samsung.com>
References: <cover.1449230499.git.p.fedin@samsung.com>
 <20151205003334.GB3117@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151205003334.GB3117@hawk.localdomain>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andrew Jones' <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> FYI, I tried writing test cases for this issue with kvm-unit-tests. The
> issue didn't reproduce for me. It's quite possible my test cases are
> flawed

 Indeed they are, a very little thing fell through again... :)
 It's not just SP, it's SP_EL0. And you never initialize it to anything because your code always runs in kernel mode, so it's just
zero, so you get your zero.
 But if you add a little thing in the beginning of your main():

asm volatile("msr sp_el0, %0" : : "r" (0xDEADC0DE0BADC0DE));

 then you have it:
--- cut ---
[root@thunderx-2 kvm-unit-tests]# ./arm-run arm/xzr-test.flat -smp 2
qemu-system-aarch64 -machine virt,accel=kvm:tcg,gic-version=host -cpu host -device virtio-serial-device -device
virtconsole,chardev=ctd -chardev testdev,id=ctd -display none -serial stdio -kernel arm/xzr-test.flat -smp 2
PASS: mmio: sanity check: read 0x55555555
FAIL: mmio: 'str wzr' check: read 0x0badc0de
vm_setup_vq: virtqueue 0 already setup! base=0xa003e00
chr_testdev_init: chr-testdev: can't init virtqueues
--- cut ---

 Here i run only MMIO test, because i could not compile sysreg one, so i simply commented it out.

 P.S. Could you also apply something like the following to arm/run:
--- cut ---
arm/run | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arm/run b/arm/run
index 662a856..3890c8c 100755
--- a/arm/run
+++ b/arm/run
@@ -33,7 +33,11 @@ if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
 	exit 2
 fi
 
-M='-machine virt,accel=kvm:tcg'
+if $qemu $M,? 2>&1 | grep gic-version > /dev/null; then
+	GIC='gic-version=host,'
+fi
+
+M="-machine virt,${GIC}accel=kvm:tcg"
 chr_testdev='-device virtio-serial-device'
 chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
--- cut ---

 Without it qemu does not work on GICv3-only hardware, like my board, because it defaults to gic-version=2. I don't post the patch
on the mailing lists, because in order to be able to post this 5-liner i'll need to go through the formal approval procedure at my
company, and i just don't want to bother for a single small fix. :) Will do as a "Reported-by:".

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


