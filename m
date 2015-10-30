From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 2/7] provide generic read_file() implementation
Date: Fri, 30 Oct 2015 18:26:55 +0000
Message-ID: <1446229620-28088-3-git-send-email-andre.przywara@arm.com>
References: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm-ppc@vger.kernel.org
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
index 67571f9..acbd6f0 100644
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
index 44709df..bf6fb2f 100644
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
2.5.1

