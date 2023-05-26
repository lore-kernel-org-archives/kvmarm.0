Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F7C2A9F6
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 22:17:25 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685139443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OlbJvusYmkmO20ad97kpBo7krR3hJYWNzOkeakE8S4Y=;
	b=h2wuDuMa+d/+4dgqq0+7e0fbErG//k2FNZt+IcwoERsGZcGaoVcMQMzKGeg4T/mgCcsp7s
	5O66foxLO7k3HN0Cgw7PMmEP+2YatMeVPe3rVuS3Uj4vI1KJlS4zJskw2ZIkdHFL3F0A2w
	vKM0vjSJSaRuIE0G4/9DcMGTz7JzDP4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 01/21] update_headers: Use a list for arch-generic headers
Date: Fri, 26 May 2023 22:16:52 +0000
Message-ID: <20230526221712.317287-2-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Until now, all of the virtio header names are stuffed in a list and
iteratively copied from the kernel directory. Repurpose this as a list
of arch-generic headers, adding kvm.h to the bunch.

While at it, spread out the definition to have a single element per
line, making it easier to insert elements alphabetically in the future.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 util/update_headers.sh | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 789e2a42b280..4c1be7e84a95 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -9,10 +9,20 @@
 
 set -ue
 
-VIRTIO_LIST="virtio_9p.h virtio_balloon.h virtio_blk.h virtio_config.h \
-	     virtio_console.h virtio_ids.h virtio_mmio.h virtio_net.h \
-	     virtio_pci.h virtio_ring.h virtio_rng.h virtio_scsi.h \
-	     virtio_vsock.h"
+GENERIC_LIST="kvm.h \
+	      virtio_9p.h \
+	      virtio_balloon.h \
+	      virtio_blk.h \
+	      virtio_config.h \
+	      virtio_console.h \
+	      virtio_ids.h \
+	      virtio_mmio.h \
+	      virtio_net.h \
+	      virtio_pci.h \
+	      virtio_ring.h \
+	      virtio_rng.h \
+	      virtio_scsi.h \
+	      virtio_vsock.h"
 
 if [ "$#" -ge 1 ]
 then
@@ -28,9 +38,7 @@ then
 	exit 1
 fi
 
-cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
-
-for header in $VIRTIO_LIST
+for header in $GENERIC_LIST
 do
 	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
 done
-- 
2.41.0.rc0.172.g3f132b7071-goog

