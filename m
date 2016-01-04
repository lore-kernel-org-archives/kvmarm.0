From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 0/2] arm: configs: improve KVM support
Date: Mon,  4 Jan 2016 14:50:32 +0000
Message-ID: <1451919034-12846-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D174498D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 09:47:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qprj56yWaFyJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2016 09:47:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36A6F497BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 09:47:28 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@arm.linux.org.uk>, arnd@arndb.de
Cc: alison.wang@freescale.com, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

there doesn't seem to be a good generic defconfig which includes
KVM support, so this config tends to get less testing.
This mini-series addresses this with a two-fold approach:

Patch 1/2 introduces VIRTIO drivers to the existing multi_v7_defconfig,
so those kernels can be easily used as guest kernels in KVM.
This goes with the arm64 defconfig, which has those drivers compiled
in as well.

Patch 2/2 adds a new kvm_defconfig, which includes LPAE and KVM host
capability on top of the said multi_v7_defconfig. This should help to
find compatibility issues with LPAE configs on the way.
I didn't bother to deselect platforms that are not LPAE capable, as:
a) some platforms may include LPAE capable cores in the future
b) compile testing drivers is part of this exercise.
I guess with LPAE capable machines adding some KBytes to the
kernel image is not really an issue, so let's just keep those
platforms in. Also that makes the diff to multi_v7_defconfig pretty
small.

Alison, the last patch comes pretty close to your:
"[RFC PATCH] ARM: add v7 LPAE multi-platform defconfig" from early
November, though with a slightly different focus. If you have a new
version of your patch in the queue, I am happy to withdraw mine and
rather help to get yours merged, possibly with the KVM options added.
What is your take on this?

Cheers,
Andre.

Andre Przywara (2):
  arm: multi_v7_defconfig: Add virtio drivers
  arm: configs: add kvm_defconfig

 arch/arm/configs/{multi_v7_defconfig => kvm_defconfig} | 14 ++++++++++++++
 arch/arm/configs/multi_v7_defconfig                    |  8 ++++++++
 2 files changed, 22 insertions(+)
 copy arch/arm/configs/{multi_v7_defconfig => kvm_defconfig} (98%)

-- 
2.6.4
