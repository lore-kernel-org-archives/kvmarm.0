From: Christoffer Dall <christoffer.dall@arm.com>
Subject: GICv3 stride issue with many VCPUs
Date: Mon, 3 Sep 2018 13:11:30 +0200
Message-ID: <20180903111130.GG4029@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AD224A1DD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 07:11:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0PKkLZZMJrZB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 07:11:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D5514A0C9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 07:11:34 -0400 (EDT)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I recently ran kvm-unit-tests on TX2, and I got an error from gicv3-ipi,
with this in the log:

  % cat logs/gicv3-ipi.log
  timeout -k 1s --foreground 90s ../src/qemu/build/aarch64-softmmu/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 224 -machine gic-version=3 -append ipi # -initrd /tmp/tmp.Xy3T5zjn9n
  lib/arm/gic-v3.c:25: assert failed: 0
          STACK:


Which is an assert in gicv3_set_redist_base().

I suspect this is related to the number of vcpus (112) and our GICv3 configuration.

Reporting it here in case anyone else is seeing this and wondering what's going on.


Thanks,

    Christoffer
