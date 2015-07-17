From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 11/12] avoid using predefined PAGE_SIZE
Date: Fri, 17 Jul 2015 17:02:17 +0100
Message-ID: <1437148938-5394-12-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The musl-libc comes with a predefined PAGE_SIZE macro, which may be
wrong on systems which support multiple smallest page sizes.
Make sure we use our own (runtime evaluated) definition of PAGE_SIZE.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/kvm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 9818046..8b12cd6 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -19,6 +19,10 @@
 #define HOME_DIR		getenv("HOME")
 #define KVM_BINARY_NAME		"lkvm"
 
+/* Let's determine the actual page size at runtime. */
+#ifdef PAGE_SIZE
+#undef PAGE_SIZE
+#endif
 #define PAGE_SIZE (sysconf(_SC_PAGE_SIZE))
 
 #define DEFINE_KVM_EXT(ext)		\
-- 
2.3.5

