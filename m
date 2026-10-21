Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792596333;
	b=LUvsqyTVF8W1cNvnwWi1JOo2/QgXNfCMk1QEIkkRPqMxvnMvz3XtnrMFxExXUVaEZzlF
	 Jq4kKRQKFqNCWx81zEgZ0VKHm8ZkMuu7BeqDWjmaioS7WkJCd+0jOnLWhDeRh0fF5QVl+
	 8SHJrRkbJZ594icmqHhin9/RQ/mAAAPHw8SPMyGZ6vKkwl01BCR5tGEQesq/Nuug0ffst
	 l5otlsu8o0bGyErdw99/10PfWbsjtxcOi9J2CkOWFW3XkNuGUua6x/Ry+4XlSTOs2FD6A
	 AylZnndDE9cJgx6jk6sNjZInc/19Z7oqzdJvpNETdlJ46qPL6X7oys1bn/8INWKayfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792596333;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=evsxKYLWVnsBxKnCJoE/eH45ZtCqn3stqq5QGm4PbsE=;
	b=dh4tkmA9zbq4+bXab3j6+aU7gkjjFBHHZffZutQSvEC+vyDpXqjTlQD24VwJAgr103Wi
	 30FlW1kuifkMQyJyfntq9DdIXqnlse+eazenoocr0BDyPCiILS9tIcONHv1SUDK0ZjnBa
	 +3A/woW521IJpFzlvQyTqC/JYDotmR/xM2ETlm/SQgtOMmUnFx2ZDAFdpY5R4bJjHBjpq
	 olOhrQV+neP20JmrFCoXnGKH/Zi5R+A8xY9z/lGz9lERAqMe9A0y6lLnPE3+cx8hPQvms
	 iglAxWzdgOWWnZ4ws9u/d6DB+hR3f5nLp59N8hpVzTKIlRcWLz4+wG2EtByZpHghThg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=KC5OpTHw;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EDC60A2601
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 15:25:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32EDC60A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=KC5OpTHw
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c3f04e0e481so82139166b.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 08:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792596330; x=1793201130; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=evsxKYLWVnsBxKnCJoE/eH45ZtCqn3stqq5QGm4PbsE=;
        b=KC5OpTHwtJyQdtNoCxY4+1l7bJMAdKDR24YLVOFkOYes+eHih5pMBHfuZGlkGeWu6y
         7fnvvsjURuAfqERFJ+QzEFeyHyoeuciTUr0FJCJn3LEq5CD0mxblfuOybyi5F77Ffzzf
         SitC3mdXmssFrkUv3Dh9Y/ravuY3Ci2kYFxO2lJ023Lip5nsr/sjaa4S5FESobvk2kZe
         aiZ+QoQ0gE3bXDIzE7t/QIKkeIKCbclErGxv4Vsal3+94Czbv//LJHT1l7R7IzmBnZQl
         7BHQzjsM8bbS/SYft4G+4GZwKXGZrnBn5qivRNsuASOHWCaqSLcXTRqydLJEkgSmAdv0
         jVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792596330; x=1793201130;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=evsxKYLWVnsBxKnCJoE/eH45ZtCqn3stqq5QGm4PbsE=;
        b=ZZGGkMRXGzpaJ8xWzkBBmzqcFoIDYXXwnfVPEBqFNfX6Apg7YlS/odt5DQNIHfO+y2
         jy3m5GMAyaEbKgTahSnyLCrpihuFsxFSIHIDFBEp3YFeB6/L6/hB3T8VebUbg8zx1NuD
         H9Qemqrs8hPYxHOu3WiFpMEsohAy6dXMAiIYMNi5CqsdpVpATUD0k4IlK9nOShxZbt6+
         D3yq2KqmIfCCIUrPBcxBFYv/ZIQb8CJWMw74MA9BMwisDze/xu/8ZD0OXfiHAMGAN/Da
         BKROpLfddjebZyWKunbdEGAO5KQtahaCjHw8DZC2rDNdEIe8ErVMu3E/k3ruMIAk5kUm
         KIOg==
X-Forwarded-Encrypted: i=1; AKwUvBw+35UfcxO20xKSuyNiswva+F5vHZRKEae5FjKIDmWw2nhbTKdI/hF2NjN2ViKo5hd+qQOComQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYK3fBvRxV+ncw6sGPn2wjyfoNIoRJYiebZalQomxmhfNb+nZucd
	m2bqd0M8CD329ewcIexQ0+RCKfxJZjYKpC3cWOjdAzi2UCOormJxsjkUer0W71pNZBACsE5yrIQ
	F+9AkO7ankFt0Uloe6g==
X-Received: from ejbot5.prod.google.com ([2002:a17:906:ccc5:b0:c3f:be70:c556])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:96a0:b0:c2a:fcb7:62f2 with SMTP id a640c23a62f3a-c46795d8b8amr219231866b.19.1792596330193;
 Wed, 21 Oct 2026 08:25:30 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:25:24 +0000
In-Reply-To: <20261021152527.375070-1-tarunsahu@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021152527.375070-2-tarunsahu@google.com>
Subject: [RFC PATCH v2 1/4] liveupdate: Rename handler compatible to name
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

File handler and File-Lifecycle-Bound (FLB) identifiers name the
registered handler or FLB rather than a monolithic compatibility version.
Rename compatible to name across LUO headers, structures, and consumers:
- struct liveupdate_file_handler and struct luo_file_ser name field
- LIVEUPDATE_HNDL_NAME_LENGTH (in include/uapi/linux/liveupdate.h) and
  MEMFD_LUO_FH_NAME
- struct liveupdate_flb name field, LIVEUPDATE_FLB_NAME_LENGTH,
  PCI_LUO_FLB_NAME, and LIVEUPDATE_TEST_FLB_NAME

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 drivers/pci/liveupdate.c        | 10 ++++----
 include/linux/kho/abi/luo.h     | 26 +++++++++----------
 include/linux/kho/abi/memfd.h   |  4 +--
 include/linux/kho/abi/pci.h     |  2 +-
 include/linux/liveupdate.h      | 18 +++++--------
 include/uapi/linux/liveupdate.h |  3 +++
 kernel/liveupdate/luo_file.c    | 45 +++++++++++++++++----------------
 kernel/liveupdate/luo_flb.c     | 16 ++++++------
 lib/tests/liveupdate.c          | 22 ++++++++--------
 mm/memfd_luo.c                  |  2 +-
 10 files changed, 73 insertions(+), 75 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 51695782ed42..3cf01d7d615c 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -424,7 +424,7 @@ static struct liveupdate_flb_ops pci_liveupdate_flb_ops=
 =3D {
=20
 static struct liveupdate_flb pci_liveupdate_flb =3D {
 	.ops =3D &pci_liveupdate_flb_ops,
-	.compatible =3D PCI_LUO_FLB_COMPATIBLE,
+	.name =3D PCI_LUO_FLB_NAME,
 };
=20
 static void pci_liveupdate_flb_put_outgoing(void)
@@ -667,13 +667,13 @@ static struct pci_flb_incoming *pci_liveupdate_flb_ge=
t_incoming(void)
=20
 	/*
 	 * Live Update is enabled and there is incoming FLB data, but none of it
-	 * matches pci_liveupdate_flb.compatible.
+	 * matches pci_liveupdate_flb.name.
 	 */
 	if (ret =3D=3D -ENOENT)
 		return NULL;
=20
 	/*
-	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
+	 * There is incoming FLB data that matches pci_liveupdate_flb.name
 	 * but retrieve failed (pci_flb_retrieve() returned an error or LUO
 	 * failed to acquire a reference to pci_liveupdate_flb_ops.owner).
 	 */
@@ -998,7 +998,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_is_incoming);
  */
 int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
-	pr_debug("Registering file handler \"%s\"\n", fh->compatible);
+	pr_debug("Registering file handler \"%s\"\n", fh->name);
 	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
@@ -1009,7 +1009,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
  */
 void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
 {
-	pr_debug("Unregistering file handler \"%s\"\n", fh->compatible);
+	pr_debug("Unregistering file handler \"%s\"\n", fh->name);
 	liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 288076de6d4a..5fb2f46425d7 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -39,9 +39,9 @@
  *     Multiple blocks are linked via the `next` field in the header.
  *
  *   - struct luo_file_ser:
- *     Metadata for a single preserved file. Contains the `compatible` str=
ing to
- *     find the correct handler in the new kernel, a user-provided `token`=
 for
- *     identification, and an opaque `data` handle for the handler to use.
+ *     Metadata for a single preserved file. Contains the handler `name` s=
tring
+ *     to find the correct handler in the new kernel, a user-provided `tok=
en`
+ *     for identification, and an opaque `data` handle for the handler to =
use.
  *
  *   - struct luo_flb_header_ser:
  *     Header for the FLB array. Contains the total page count of the
@@ -49,9 +49,9 @@
  *     that follow.
  *
  *   - struct luo_flb_ser:
- *     Metadata for a single preserved global object. Contains its `name`
- *     (compatible string), an opaque `data` handle, and the `count`
- *     number of files depending on it.
+ *     Metadata for a single preserved global object. Contains its FLB `na=
me`
+ *     string, an opaque `data` handle, and the `count` number of files
+ *     depending on it.
  */
=20
 #ifndef _LINUX_KHO_ABI_LUO_H
@@ -84,18 +84,16 @@ struct luo_ser {
 	u64 flbs_pa;
 } __packed;
=20
-#define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
-
 /**
  * struct luo_file_ser - Represents the serialized preserves files.
- * @compatible:  File handler compatible string.
+ * @name:        File handler name string.
  * @data:        Private data
  * @token:       User provided token for this file
  *
  * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_file_ser {
-	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
+	char name[LIVEUPDATE_HNDL_NAME_LENGTH];
 	u64 data;
 	u64 token;
 } __packed;
@@ -134,7 +132,7 @@ struct luo_session_ser {
 } __packed;
=20
 /* The max size is set so it can be reliably used during in serialization =
*/
-#define LIVEUPDATE_FLB_COMPAT_LENGTH	48
+#define LIVEUPDATE_FLB_NAME_LENGTH	48
=20
 /**
  * struct luo_flb_header_ser - Header for the serialized FLB data block.
@@ -156,7 +154,7 @@ struct luo_flb_header_ser {
=20
 /**
  * struct luo_flb_ser - Represents the serialized state of a single FLB ob=
ject.
- * @name:    The unique compatibility string of the FLB object, used to fi=
nd the
+ * @name:    The unique name string of the FLB object, used to find the
  *           corresponding &struct liveupdate_flb handler in the new kerne=
l.
  * @data:    The opaque u64 handle returned by the FLB's .preserve() opera=
tion
  *           in the old kernel. This handle encapsulates the entire state =
needed
@@ -172,14 +170,14 @@ struct luo_flb_header_ser {
  * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_flb_ser {
-	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
+	char name[LIVEUPDATE_FLB_NAME_LENGTH];
 	u64 data;
 	u64 count;
 } __packed;
=20
 /* Kernel Live Update Test ABI */
 #ifdef CONFIG_LIVEUPDATE_TEST
-#define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
+#define LIVEUPDATE_TEST_FLB_NAME(i)	"liveupdate-test-flb-v" #i
 #endif
=20
 #endif /* _LINUX_KHO_ABI_LUO_H */
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 08b10fea2afc..371ffd108a79 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -87,7 +87,7 @@ struct memfd_luo_ser {
 	struct kho_vmalloc folios;
 } __packed;
=20
-/* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
+/* The name string for memfd file handler */
+#define MEMFD_LUO_FH_NAME	"memfd-v2"
=20
 #endif /* _LINUX_KHO_ABI_MEMFD_H */
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index 9485ed73c351..973ca5b26dbd 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -23,7 +23,7 @@
  * incrementing the version number in the PCI_LUO_FLB_VERSION number.
  */
=20
-#define PCI_LUO_FLB_COMPATIBLE "pci"
+#define PCI_LUO_FLB_NAME "pci"
 #define PCI_LUO_FLB_VERSION 2
=20
 /**
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612c..475da5fc22ee 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -90,10 +90,8 @@ struct liveupdate_file_ops {
 /**
  * struct liveupdate_file_handler - Represents a handler for a live-updata=
ble file type.
  * @ops:                Callback functions
- * @compatible:         The compatibility string (e.g., "memfd-v1", "vfiof=
d-v1")
- *                      that uniquely identifies the file type this handle=
r
- *                      supports. This is matched against the compatible s=
tring
- *                      associated with individual &struct file instances.
+ * @name:               Unique handler name string (e.g., "memfd-v2"), mat=
ched
+ *                      against &struct luo_file_ser.name in the target ke=
rnel.
  *
  * Modules that want to support live update for specific file types should
  * register an instance of this structure. LUO uses this registration to
@@ -102,7 +100,7 @@ struct liveupdate_file_ops {
  */
 struct liveupdate_file_handler {
 	const struct liveupdate_file_ops *ops;
-	const char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
+	const char name[LIVEUPDATE_HNDL_NAME_LENGTH];
=20
 	/* private: */
=20
@@ -209,11 +207,9 @@ struct luo_flb_private {
 /**
  * struct liveupdate_flb - A global definition for a shared data object.
  * @ops:         Callback functions
- * @compatible:  The compatibility string (e.g., "iommu-core-v1"
- *               that uniquely identifies the FLB type this handler
- *               supports. This is matched against the compatible string
- *               associated with individual &struct liveupdate_flb
- *               instances.
+ * @name:        The FLB name string (e.g., "iommu-core-v1") that uniquely
+ *               identifies this FLB type. In the target kernel, it is
+ *               matched against the name stored in &struct luo_flb_ser.
  *
  * This struct is the "template" that a driver registers to define a share=
d,
  * file-lifecycle-bound object. The actual runtime state (the live object,
@@ -221,7 +217,7 @@ struct luo_flb_private {
  */
 struct liveupdate_flb {
 	const struct liveupdate_flb_ops *ops;
-	const char compatible[LIVEUPDATE_FLB_COMPAT_LENGTH];
+	const char name[LIVEUPDATE_FLB_NAME_LENGTH];
=20
 	/* private: */
 	struct luo_flb_private __private private;
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdat=
e.h
index 4043d4038712..509c6236720d 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -46,6 +46,9 @@
 /* The maximum length of session name including null termination */
 #define LIVEUPDATE_SESSION_NAME_LENGTH 64
=20
+/* The maximum length of file handler name including null termination */
+#define LIVEUPDATE_HNDL_NAME_LENGTH 48
+
 /* The /dev/liveupdate ioctl commands */
 enum {
 	LIVEUPDATE_CMD_BASE =3D 0x00,
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..fb81239bedf3 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -50,7 +50,7 @@
  *
  * 2. Freeze (Pre-Reboot): Just before the kexec, luo_file_freeze() is cal=
led.
  *    It iterates through all preserved files, calls their respective .fre=
eze()
- *    operation, and serializes their final metadata (compatible string, t=
oken,
+ *    operation, and serializes their final metadata (handler name, token,
  *    and data handle) into a contiguous memory block for KHO.
  *
  * 3. Deserialize: After kexec, luo_file_deserialize() runs when session g=
ets
@@ -220,7 +220,7 @@ static bool luo_token_is_used(struct luo_file_set *file=
_set, u64 token)
  * 1. Validates that the @token is not already in use within the file_set.
  * 2. Ensures the file_set's memory for files serialization is allocated
  *    (allocates if needed).
- * 3. Iterates through registered handlers, calling can_preserve() to find=
 one
+ * 3. Iterates through registered handlers, calling .can_preserve() to fin=
d one
  *    compatible with the given @fd.
  * 4. Calls the handler's .preserve() operation, which saves the file's st=
ate
  *    and returns an opaque private data handle.
@@ -238,7 +238,7 @@ static bool luo_token_is_used(struct luo_file_set *file=
_set, u64 token)
  *         -EBUSY if the file descriptor is already preserved by another s=
ession.
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
- *         -ENOENT if no compatible handler is found.
+ *         -ENOENT if no compatible handler is found for the file type.
  *         -ENOMEM on memory allocation failure.
  *         Other erros might be returned by .preserve().
  */
@@ -456,9 +456,10 @@ static void __luo_file_unfreeze(struct luo_file_set *f=
ile_set,
  *    private data handle during this step.
  *
  * 2. Serializes Metadata: After a successful freeze, it copies the final =
file
- *    metadata=E2=80=94the handler's compatible string, the user token, an=
d the final
- *    private data handle=E2=80=94into the pre-allocated contiguous memory=
 buffer
- *    (file_set->files) that will be handed over to the next kernel via KH=
O.
+ *    metadata - the handler's name string, the user token, and the final
+ *    private data handle - into the pre-allocated contiguous memory buffe=
r
+ *    (file_set->files) that will be handed over to the target kernel via
+ *    KHO.
  *
  * Error Handling (Rollback):
  * This function is atomic. If any handler's .freeze() operation fails, th=
e
@@ -495,13 +496,13 @@ int luo_file_freeze(struct luo_file_set *file_set,
 		err =3D luo_file_freeze_one(file_set, luo_file);
 		if (err < 0) {
 			pr_warn("Freeze failed for token[%#0llx] handler[%s] err[%pe]\n",
-				luo_file->token, luo_file->fh->compatible,
+				luo_file->token, luo_file->fh->name,
 				ERR_PTR(err));
 			goto err_unfreeze;
 		}
=20
-		strscpy(file_ser->compatible, luo_file->fh->compatible,
-			sizeof(file_ser->compatible));
+		strscpy(file_ser->name, luo_file->fh->name,
+			sizeof(file_ser->name));
 		file_ser->data =3D luo_file->serialized_data;
 		file_ser->token =3D luo_file->token;
 	}
@@ -747,7 +748,7 @@ static int luo_file_deserialize_one(struct luo_file_set=
 *file_set,
=20
 	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-		if (!strcmp(fh->compatible, ser->compatible)) {
+		if (!strcmp(fh->name, ser->name)) {
 			if (try_module_get(fh->ops->owner))
 				handler_found =3D true;
 			break;
@@ -756,9 +757,9 @@ static int luo_file_deserialize_one(struct luo_file_set=
 *file_set,
 	up_read(&luo_register_rwlock);
=20
 	if (!handler_found) {
-		pr_warn("No registered handler for compatible '%.*s'\n",
-			(int)sizeof(ser->compatible),
-			ser->compatible);
+		pr_warn("No registered handler for name '%.*s'\n",
+			(int)sizeof(ser->name),
+			ser->name);
 		return -ENOENT;
 	}
=20
@@ -789,9 +790,9 @@ static int luo_file_deserialize_one(struct luo_file_set=
 *file_set,
  * in-memory linked list of 'struct luo_file' instances.
  *
  * For each serialized entry, it performs the following steps:
- *   1. Reads the 'compatible' string.
+ *   1. Reads the handler 'name' string.
  *   2. Searches the global list of registered file handlers for one that
- *      matches the compatible string.
+ *      matches the handler name.
  *   3. Allocates a new 'struct luo_file'.
  *   4. Populates the new structure with the deserialized data (token, pri=
vate
  *      data handle) and links it to the found handler. The 'file' pointer=
 is
@@ -884,9 +885,9 @@ void luo_file_set_destroy(struct luo_file_set *file_set=
)
 /**
  * liveupdate_register_file_handler - Register a file handler with LUO.
  * @fh: Pointer to a caller-allocated &struct liveupdate_file_handler.
- * The caller must initialize this structure, including a unique
- * 'compatible' string and a valid 'fh' callbacks. This function adds the
- * handler to the global list of supported file handlers.
+ * The caller must initialize this structure, including a unique 'name'
+ * string and valid 'fh' callbacks. This function adds the handler to the
+ * global list of supported file handlers.
  *
  * Context: Typically called during module initialization for file types t=
hat
  * support live update preservation.
@@ -908,11 +909,11 @@ int liveupdate_register_file_handler(struct liveupdat=
e_file_handler *fh)
 	}
=20
 	down_write(&luo_register_rwlock);
-	/* Check for duplicate compatible strings */
+	/* Check for duplicate handler names */
 	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
-		if (!strcmp(fh_iter->compatible, fh->compatible)) {
-			pr_err("File handler registration failed: Compatible string '%s' alread=
y registered.\n",
-			       fh->compatible);
+		if (!strcmp(fh_iter->name, fh->name)) {
+			pr_err("File handler registration failed: Handler name '%s' already reg=
istered.\n",
+			       fh->name);
 			err =3D -EEXIST;
 			goto err_unlock;
 		}
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index cd715a7c1d99..222c6d7f821e 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -178,7 +178,7 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *=
flb)
 		return -ENODATA;
=20
 	for (int i =3D 0; i < fh->header_ser->count; i++) {
-		if (!strcmp(fh->ser[i].name, flb->compatible)) {
+		if (!strcmp(fh->ser[i].name, flb->name)) {
 			private->incoming.data =3D fh->ser[i].data;
 			refcount_set(&private->incoming.count, fh->ser[i].count);
 			found =3D true;
@@ -337,7 +337,7 @@ static void luo_flb_unregister_one(struct liveupdate_fi=
le_handler *fh,
=20
 	if (!found) {
 		pr_warn("Failed to unregister FLB '%s': not found in file handler '%s'\n=
",
-			flb->compatible, fh->compatible);
+			flb->name, fh->name);
 		return;
 	}
=20
@@ -442,9 +442,9 @@ int liveupdate_register_flb(struct liveupdate_file_hand=
ler *fh,
 		if (luo_flb_global.count =3D=3D LUO_FLB_MAX)
 			return -ENOSPC;
=20
-		/* Check that compatible string is unique in global list */
+		/* Check that FLB name is unique in global list */
 		list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
-			if (!strcmp(gflb->compatible, flb->compatible))
+			if (!strcmp(gflb->name, flb->name))
 				return -EEXIST;
 		}
=20
@@ -596,9 +596,9 @@ void __init luo_flb_setup_incoming(u64 flbs_pa)
  * preserved (i.e., its reference count is greater than zero), it writes i=
ts
  * metadata into the memory region designated for Kexec Handover.
  *
- * The serialized data includes the FLB's compatibility string, its opaque
- * data handle, and the final reference count. This allows the new kernel =
to
- * find the appropriate handler and reconstruct the FLB's state.
+ * The serialized data includes the FLB's name string, its opaque
+ * data handle, and the final reference count. This allows the target
+ * kernel to find the appropriate FLB and reconstruct its state.
  *
  * Context: Called from liveupdate_reboot() just before kho_finalize().
  */
@@ -614,7 +614,7 @@ void luo_flb_serialize(void)
 		long count =3D refcount_read(&private->outgoing.count);
=20
 		if (count > 0) {
-			strscpy(fh->ser[i].name, gflb->compatible,
+			strscpy(fh->ser[i].name, gflb->name,
 				sizeof(fh->ser[i].name));
 			fh->ser[i].data =3D private->outgoing.data;
 			fh->ser[i].count =3D count;
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
index 4c08a7c6fb78..e4df09eed1f3 100644
--- a/lib/tests/liveupdate.c
+++ b/lib/tests/liveupdate.c
@@ -17,7 +17,7 @@
 static const struct liveupdate_flb_ops test_flb_ops;
 #define DEFINE_TEST_FLB(i) {						\
 	.ops =3D &test_flb_ops,						\
-	.compatible =3D LIVEUPDATE_TEST_FLB_COMPATIBLE(i),		\
+	.name =3D LIVEUPDATE_TEST_FLB_NAME(i),				\
 }
=20
 /* Number of Test FLBs to register with every file handler */
@@ -34,7 +34,7 @@ static int test_flb_preserve(struct liveupdate_flb_op_arg=
s *argp)
 {
 	ptrdiff_t index =3D argp->flb - test_flbs;
=20
-	pr_info("%s: preserve was triggered\n", argp->flb->compatible);
+	pr_info("%s: preserve was triggered\n", argp->flb->name);
 	argp->data =3D TEST_FLB_MAGIC_BASE + index;
=20
 	return 0;
@@ -42,7 +42,7 @@ static int test_flb_preserve(struct liveupdate_flb_op_arg=
s *argp)
=20
 static void test_flb_unpreserve(struct liveupdate_flb_op_args *argp)
 {
-	pr_info("%s: unpreserve was triggered\n", argp->flb->compatible);
+	pr_info("%s: unpreserve was triggered\n", argp->flb->name);
 }
=20
 static int test_flb_retrieve(struct liveupdate_flb_op_args *argp)
@@ -52,11 +52,11 @@ static int test_flb_retrieve(struct liveupdate_flb_op_a=
rgs *argp)
=20
 	if (argp->data =3D=3D expected_data) {
 		pr_info("%s: found flb data from the previous boot\n",
-			argp->flb->compatible);
+			argp->flb->name);
 		argp->obj =3D (void *)argp->data;
 	} else {
 		pr_err("%s: ERROR - incorrect data handle: %llx, expected %llx\n",
-		       argp->flb->compatible, argp->data, expected_data);
+		       argp->flb->name, argp->data, expected_data);
 		return -EINVAL;
 	}
=20
@@ -69,10 +69,10 @@ static void test_flb_finish(struct liveupdate_flb_op_ar=
gs *argp)
 	void *expected_obj =3D (void *)(TEST_FLB_MAGIC_BASE + index);
=20
 	if (argp->obj =3D=3D expected_obj) {
-		pr_info("%s: finish was triggered\n", argp->flb->compatible);
+		pr_info("%s: finish was triggered\n", argp->flb->name);
 	} else {
 		pr_err("%s: ERROR - finish called with invalid object\n",
-		       argp->flb->compatible);
+		       argp->flb->name);
 	}
 }
=20
@@ -103,7 +103,7 @@ static void liveupdate_test_init(void)
 		err =3D liveupdate_flb_get_incoming(flb, &obj);
 		if (err && err !=3D -ENODATA && err !=3D -ENOENT) {
 			pr_err("liveupdate_flb_get_incoming for %s failed: %pe\n",
-			       flb->compatible, ERR_PTR(err));
+			       flb->name, ERR_PTR(err));
 		}
=20
 		if (!err)
@@ -124,18 +124,18 @@ void liveupdate_test_register(struct liveupdate_file_=
handler *fh)
 		err =3D liveupdate_register_flb(fh, flb);
 		if (err) {
 			pr_err("Failed to register %s %pe\n",
-			       flb->compatible, ERR_PTR(err));
+			       flb->name, ERR_PTR(err));
 		}
 	}
=20
 	err =3D liveupdate_register_flb(fh, &test_flbs[0]);
 	if (!err || err !=3D -EEXIST) {
 		pr_err("Failed: %s should be already registered, but got err: %pe\n",
-		       test_flbs[0].compatible, ERR_PTR(err));
+		       test_flbs[0].name, ERR_PTR(err));
 	}
=20
 	pr_info("Registered %d FLBs with file handler: [%s]\n",
-		TEST_NFLBS, fh->compatible);
+		TEST_NFLBS, fh->name);
 }
=20
 MODULE_LICENSE("GPL");
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 6b68220275eb..64f8b8cb75bd 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -602,7 +602,7 @@ static const struct liveupdate_file_ops memfd_luo_file_=
ops =3D {
=20
 static struct liveupdate_file_handler memfd_luo_handler =3D {
 	.ops =3D &memfd_luo_file_ops,
-	.compatible =3D MEMFD_LUO_FH_COMPATIBLE,
+	.name =3D MEMFD_LUO_FH_NAME,
 };
=20
 static int __init memfd_luo_init(void)
--=20
2.56.0.212.g129ede20d9-goog

