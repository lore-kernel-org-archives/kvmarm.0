Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D15C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 24 May 2022 15:06:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 860EA4B10A;
	Tue, 24 May 2022 11:06:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bj4K2VIKDC9Y; Tue, 24 May 2022 11:06:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 667524A10E;
	Tue, 24 May 2022 11:06:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A5749EED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2022 11:06:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1B6j5wy6uGEJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2022 11:06:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C601A49EDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2022 11:06:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E064223A;
 Tue, 24 May 2022 08:06:17 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65AEC3F70D;
 Tue, 24 May 2022 08:06:16 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool 0/4] Update virtio headers (to fix build)
Date: Tue, 24 May 2022 16:06:07 +0100
Message-Id: <20220524150611.523910-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Since we implement some virtio devices in kvmtool, we were including
older copies of some virtio UAPI header files in our tree, but were
relying on some other headers to be provided by the distribution.
This leads to problems when we need to use newer virtio features (like
the recent virtio_balloon stat update), which breaks compilation on some
(older) distros.

To fix this and avoid similar problems in the future, just copy in the
virtio UAPI headers from the kernel tree, as we do already for the
actual KVM interface headers. To simplify future syncs, also update our
update_headers.sh script on the way.

Please have a look!

Cheers,
Andre

Andre Przywara (4):
  update virtio_mmio.h
  util: include virtio UAPI headers in sync
  include: update virtio UAPI headers
  include: add new virtio uapi header files

 include/linux/virtio_9p.h      |  44 ++++++
 include/linux/virtio_balloon.h | 119 ++++++++++++++++
 include/linux/virtio_blk.h     | 203 +++++++++++++++++++++++++++
 include/linux/virtio_config.h  | 101 ++++++++++++++
 include/linux/virtio_console.h |  78 +++++++++++
 include/linux/virtio_ids.h     |  63 +++++++--
 include/linux/virtio_mmio.h    |  55 +++++++-
 include/linux/virtio_net.h     | 200 +++++++++++++++++++++++----
 include/linux/virtio_pci.h     | 208 ++++++++++++++++++++++++++++
 include/linux/virtio_ring.h    | 244 +++++++++++++++++++++++++++++++++
 include/linux/virtio_rng.h     |   8 ++
 include/linux/virtio_scsi.h    | 118 ++++++++--------
 include/linux/virtio_vsock.h   |  16 ++-
 util/update_headers.sh         |  10 ++
 virtio/mmio.c                  |   8 +-
 15 files changed, 1372 insertions(+), 103 deletions(-)
 create mode 100644 include/linux/virtio_9p.h
 create mode 100644 include/linux/virtio_balloon.h
 create mode 100644 include/linux/virtio_blk.h
 create mode 100644 include/linux/virtio_config.h
 create mode 100644 include/linux/virtio_console.h
 create mode 100644 include/linux/virtio_pci.h
 create mode 100644 include/linux/virtio_ring.h
 create mode 100644 include/linux/virtio_rng.h

-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
