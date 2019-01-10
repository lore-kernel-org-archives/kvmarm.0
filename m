From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 00/13] Implement reset of virtio devices
Date: Thu, 10 Jan 2019 14:12:37 +0000
Message-ID: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09B064A41C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:12:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Dzs7YPmjf7v for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:12:57 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6B4B4A3E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:12:57 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, kraxel@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This series was developped by Jean-Philippe and is needed for a series
I'll be posting shortly after to load firmwares on arm kvmtool.

Currently, when a guest tries to reset a device, a lot of ressources
aren't reset (threads keep running, virtio queue keep their state, etc).

When the guest only does the reset to initialize the device and there
were no previous users, there is no noticeable issue. But when a guest
has a firmare + Linux, if the firmware uses a virtio device, Linux will
fail to probe that device.

This series aim to properly reset the virtio resources when the guests
requests it.

Reset of net vhost is unsupported for now.

Patch 1 is a bug fix on ioeventfd
Patch 2-6 provide the core support so devices can implement their reset
Patch 7-13 implements the reset for the various virtio devices

Changes since v1[1]:
- Fix build issue by removing reference to VIRTIO_CONFIG_S_NEEDS_RESET

[1] https://marc.info/?l=kvm&m=154392208726108&w=2

Thanks,

Julien

-->

Jean-Philippe Brucker (13):
  ioeventfd: Fix removal of ioeventfd
  virtio: Implement notify_status
  virtio: Add get_vq_count() callback
  virtio: Add get_vq() callback
  virtio: Add exit_vq() callback
  virtio: Add reset() callback
  net/uip: Add exit function
  virtio/net: Clean virtqueue state
  virtio/net: Implement device and virtqueue reset
  virtio/blk: Reset virtqueue
  threadpool: Add cancel() function
  virtio/p9: Implement reset
  virtio/console: Implement reset

 include/kvm/threadpool.h  |   2 +
 include/kvm/uip.h         |   6 ++
 include/kvm/virtio-mmio.h |   1 +
 include/kvm/virtio-pci.h  |   1 +
 include/kvm/virtio.h      |  29 ++++++-
 ioeventfd.c               |   6 +-
 net/uip/core.c            |  17 ++++
 net/uip/dhcp.c            |   6 ++
 net/uip/tcp.c             |  54 ++++++++++---
 net/uip/udp.c             |  41 ++++++++--
 util/threadpool.c         |  25 +++++-
 virtio/9p.c               |  33 +++++++-
 virtio/balloon.c          |  17 +++-
 virtio/blk.c              |  84 ++++++++++++++------
 virtio/console.c          |  49 ++++++++----
 virtio/core.c             |  42 ++++++++++
 virtio/mmio.c             |  52 +++++++++----
 virtio/net.c              | 195 +++++++++++++++++++++++++++++++++-------------
 virtio/pci.c              |  49 ++++++++----
 virtio/rng.c              |  12 ++-
 virtio/scsi.c             |  17 +++-
 21 files changed, 581 insertions(+), 157 deletions(-)

--
1.9.1
