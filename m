From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 05/14] kvmtool: introduce pseek
Date: Thu, 30 Jul 2015 11:52:22 +0100
Message-ID: <1438253551-2378-6-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

pseek is a wrapper around lseek(2), which can cope with non-seekable
file descriptors. The limitation is of course that we only can seek
forward and only relative to the current position (hence the whence
parameter is missing). In this case pseek will do dummy reads to skip
over the requested amount of data.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/read-write.h |  2 ++
 util/read-write.c        | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/kvm/read-write.h b/include/kvm/read-write.h
index 67571f9..87eb167 100644
--- a/include/kvm/read-write.h
+++ b/include/kvm/read-write.h
@@ -40,4 +40,6 @@ int aio_pwritev(io_context_t ctx, struct iocb *iocb, int fd, const struct iovec
 		off_t offset, int ev, void *param);
 #endif
 
+int pseek(int fd, off_t offset);
+
 #endif /* KVM_READ_WRITE_H */
diff --git a/util/read-write.c b/util/read-write.c
index 44709df..401afd3 100644
--- a/util/read-write.c
+++ b/util/read-write.c
@@ -352,3 +352,43 @@ restart:
 	return ret;
 }
 #endif
+
+/*
+ * A wrapper around lseek(fd, offset, SEEK_CUR), which can cope with being
+ * used on non-seekable file descriptors like pipes or sockets. If offset
+ * is positive, it will skip over the requested number of bytes by reading
+ * them into a dummy buffer.
+ */
+#define BUF_SIZE 256
+int pseek(int fd, off_t offset)
+{
+	off_t ret;
+	int to_read;
+	char skip_buf[BUF_SIZE];
+
+	ret = lseek(fd, offset, SEEK_CUR);
+	if (ret != (off_t)-1)
+		return 0;
+
+	if (errno != ESPIPE)
+		return -1;
+
+	if (offset < 0) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	while (offset > 0) {
+		to_read = offset > BUF_SIZE ? BUF_SIZE : offset;
+		ret = read(fd, skip_buf, to_read);
+		if (ret == -1 && errno != EINTR)
+			return -1;
+		if (ret == 0) {
+			errno = EINVAL;
+			return -1;
+		}
+		offset -= ret;
+	}
+
+	return 0;
+}
-- 
2.3.5

