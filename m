From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 3/7] lib: chr-testdev: Make chr_testdev_init()
 return status
Date: Thu, 24 Jan 2019 11:16:30 +0000
Message-ID: <20190124111634.4727-4-alexandru.elisei@arm.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE074A3A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 06:17:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rpfk5QbFy4rG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 06:17:03 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C8834A3E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 06:17:03 -0500 (EST)
In-Reply-To: <20190124111634.4727-1-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Make chr_testdev_init() return 0 (success) if the virtio console was
initialized properly, otherwise return -1 (failure).

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/chr-testdev.h | 2 +-
 lib/chr-testdev.c | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
index ffd9a851aa9b..fdd0582e2da1 100644
--- a/lib/chr-testdev.h
+++ b/lib/chr-testdev.h
@@ -9,6 +9,6 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-extern void chr_testdev_init(void);
+extern int chr_testdev_init(void);
 extern void chr_testdev_exit(int code);
 #endif
diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
index 6890f63c8b29..26e14301e3db 100644
--- a/lib/chr-testdev.c
+++ b/lib/chr-testdev.c
@@ -47,7 +47,7 @@ out:
 	spin_unlock(&lock);
 }
 
-void chr_testdev_init(void)
+int chr_testdev_init(void)
 {
 	const char *io_names[] = { "input", "output" };
 	struct virtqueue *vqs[2];
@@ -57,7 +57,7 @@ void chr_testdev_init(void)
 	if (vcon == NULL) {
 		printf("%s: %s: can't find a virtio-console\n",
 				__func__, TESTDEV_NAME);
-		return;
+		return -1;
 	}
 
 	ret = vcon->config->find_vqs(vcon, 2, vqs, NULL, io_names);
@@ -65,9 +65,11 @@ void chr_testdev_init(void)
 		printf("%s: %s: can't init virtqueues\n",
 				__func__, TESTDEV_NAME);
 		vcon = NULL;
-		return;
+		return -1;
 	}
 
 	in_vq = vqs[0];
 	out_vq = vqs[1];
+
+	return 0;
 }
-- 
2.17.0
