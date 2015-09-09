From: Tushar Jagad <tushar.jagad@linaro.org>
Subject: [PATCH RFC 0/3] arm64: cross cpu support
Date: Wed,  9 Sep 2015 08:42:09 +0000
Message-ID: <1441788132-6286-1-git-send-email-tushar.jagad@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18C7B41145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 04:41:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dgwo2lVfyRLC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2015 04:41:46 -0400 (EDT)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
 [209.85.220.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 467B4412D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 04:41:46 -0400 (EDT)
Received: by pacex6 with SMTP id ex6so4003867pac.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2015 01:42:25 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: marc.zyngier@arm.com, patches@apm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently, it is not possible to run guests in a cross cpu configuration
(for example: running of cortex-a57 guests on X-Gene or vice versa) on
arm platforms. 

This patchset adds support of passing implementation specific hardware
capabilites to vcpu for arm platforms for running guest in cross cpu
configuration. As of now passing of number of hardware breakpoints and
number of hardware watchpoints is supported. This is done by adding
properties to -cpu parameter on the command line.

Example:
cortex-a57 guest with 2 hardware breakpoints and 2 hardware watchpoints can
be started on X-Gene host using

qemu-system-aarch64 -M virt -cpu cortex-a57,bpts=2,wpts=2 \
    -smp cpus=1 -m 1024 -enable-kvm -nographic \
    -drive file=ubuntu-core-14.04.1-core-arm64.img,if=none,id=drive0,format=raw,media=disk  \
    -kernel Image -append "console=ttyAMA0 root=/dev/vda rootwait rw"

Please note that the supporting patches for KVM have not been merged
into the mainline tree yet.

These patches are on top of qemu tag v2.4.0.

Tushar Jagad (3):
  linux-headers: sync'd kernel headers for arm/arm64
  arm: cross cpu: add new properties for arm cpu
  arm64: pass breakpoint/watchpoint info for target cpu

 hw/arm/virt.c                 | 23 ++++++++++++++++++++++-
 linux-headers/asm-arm64/kvm.h |  9 +++++++++
 target-arm/cpu-qom.h          |  6 ++++++
 target-arm/cpu.c              |  2 ++
 target-arm/kvm64.c            |  8 ++++++++
 5 files changed, 47 insertions(+), 1 deletion(-)

-- 
2.4.3
