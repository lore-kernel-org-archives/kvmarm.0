Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D30DC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 24 May 2022 15:06:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A674B20B;
	Tue, 24 May 2022 11:06:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SGAua20Ryyrt; Tue, 24 May 2022 11:06:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAAF74B1D1;
	Tue, 24 May 2022 11:06:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1A564B210
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2022 11:06:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wt6l0vOLewIZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2022 11:06:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C63534B20B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2022 11:06:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 692571042;
 Tue, 24 May 2022 08:06:21 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 047B23F70D;
 Tue, 24 May 2022 08:06:19 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool 2/4] util: include virtio UAPI headers in sync
Date: Tue, 24 May 2022 16:06:09 +0100
Message-Id: <20220524150611.523910-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524150611.523910-1-andre.przywara@arm.com>
References: <20220524150611.523910-1-andre.przywara@arm.com>
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

We already have an update_headers.sh sync script, where we occasionally
update the KVM interface UAPI kernel headers into our tree.
So far this covered only the generic kvm.h, plus each architecture's
version of that file.
Commit  bc77bf49df6e ("stat: Add descriptions for new virtio_balloon
stat types") used newer virtio symbols, which some older distros do not
include in their kernel headers package. To help fixing this and to
avoid similar problems in the future, add the virtio headers to our sync
script, so that we can get the same, up-to-date versions of the headers
easily.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 util/update_headers.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 5f9cd32d..789e2a42 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -9,6 +9,11 @@
 
 set -ue
 
+VIRTIO_LIST="virtio_9p.h virtio_balloon.h virtio_blk.h virtio_config.h \
+	     virtio_console.h virtio_ids.h virtio_mmio.h virtio_net.h \
+	     virtio_pci.h virtio_ring.h virtio_rng.h virtio_scsi.h \
+	     virtio_vsock.h"
+
 if [ "$#" -ge 1 ]
 then
 	LINUX_ROOT="$1"
@@ -25,6 +30,11 @@ fi
 
 cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
 
+for header in $VIRTIO_LIST
+do
+	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
+done
+
 unset KVMTOOL_PATH
 
 copy_optional_arch () {
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
