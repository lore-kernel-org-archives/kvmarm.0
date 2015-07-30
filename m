From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 10/14] provide generic read_file() implementation
Date: Thu, 30 Jul 2015 11:52:27 +0100
Message-ID: <1438253551-2378-11-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94892596C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FgPQ+vsVk04Y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2015 06:40:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B152B596FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:07 -0400 (EDT)
In-Reply-To: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

In various parts of kvmtool we simply try to read files into memory,
but fail to do so in a safe way. The read(2) syscall can return early
having only parts of the file read, or it may return -1 due to being
interrupted by a signal (in which case we should simply retry).
The ARM code seems to provide the only safe implementation, so take
that as an inspiration to provide a generic read_file() function
usable by every part of kvmtool.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/read-write.h |  2 ++
 util/read-write.c        | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/kvm/read-write.h b/include/kvm/read-write.h
index 87eb167..658a653 100644
--- a/include/kvm/read-write.h
+++ b/include/kvm/read-write.h
@@ -12,6 +12,8 @@
 ssize_t xread(int fd, void *buf, size_t count);
 ssize_t xwrite(int fd, const void *buf, size_t count);
 
+ssize_t read_file(int fd, char *buf, size_t max_size);
+
 ssize_t read_in_full(int fd, void *buf, size_t count);
 ssize_t write_in_full(int fd, const void *buf, size_t count);
 
diff --git a/util/read-write.c b/util/read-write.c
index 401afd3..32691a9 100644
--- a/util/read-write.c
+++ b/util/read-write.c
@@ -32,6 +32,27 @@ restart:
 	return nr;
 }
 
+/*
+ * Read in the whole file while not exceeding max_size bytes of the buffer.
+ * Returns -1 (with errno set) in case of an error (ENOMEM if buffer was
+ * too small) or the filesize if the whole file could be read.
+ */
+ssize_t read_file(int fd, char *buf, size_t max_size)
+{
+	ssize_t ret;
+	char dummy;
+
+	errno = 0;
+	ret = read_in_full(fd, buf, max_size);
+
+	/* Probe whether we reached EOF. */
+	if (xread(fd, &dummy, 1) == 0)
+		return ret;
+
+	errno = ENOMEM;
+	return -1;
+}
+
 ssize_t read_in_full(int fd, void *buf, size_t count)
 {
 	ssize_t total = 0;
-- 
2.3.5
