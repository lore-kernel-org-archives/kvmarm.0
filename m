Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794286931;
	b=l9ga4xo+QwxuvrgdGh/0EoPO0F7T2UWQ6Nj6FOypX3/Pt0Mn8EV/Febs7h08SKMBBZeV
	 AgsNWCMBComRH7dwvvH/xfnz542Sv1jkq70925edtnFUveXskEpURHu8nOtMfJLfK8Kvl
	 LYFWtI1PlF3WZcdApukIRbdLfoLyqIbqXB31w6x7w2QfuQTJu7/SwDFVyQbYvXXPCLJFn
	 neuHSKXVy8zY7Ohk/OHRdElOTmYP+Gb+r+fG2cHvJstP/suF3P3SU0pny/lUYPmMvHDEI
	 tX8+LCjDX+HenmVvIzVONlqhcxlLHe8aYTyUNh6/osBzACxBecKcAzYyrplfNgYrnyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794286931;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=daK/IkDIXVqnfjYl8/M+M9VjkzPIwCe5yl4tay+gSqg=;
	b=pdv7JvAGVZsqd32i5auFtU0CLhuWTvCTueMGxIbGc0XGuIIJ+FZUG1i6zm10oRqhJZAc
	 XbERNJoZEIgrW2nPkXHEdH2+/wi3awIM5UpIbqs2RgcDANegH6ylfwhv4/k318gZ8qHaR
	 09wOzTUuI9nl8FICREjUgRXoTZaOnaaeFDO9159GFhhHgh/fTXqfE/+3w2gYoiKc2dRsW
	 C/sm8XES/2Fsfe+JQQXz9wTddfabHvdz0UWCpMvztINmDH1jmUnyle34aGhCNs4w+IcVU
	 TEmGBFf/8assYXyeHeLMZrysOKFc7/GC0bIgXJMOClVeofnTnyQxmEy/GK1WNuFl+8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hKjqS1Tv;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561E260A3824
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 05:02:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 561E260A3824
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hKjqS1Tv
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b499549f64so1410034a12.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 21:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286930; x=1794891730; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=daK/IkDIXVqnfjYl8/M+M9VjkzPIwCe5yl4tay+gSqg=;
        b=hKjqS1TvrSltdhk3usdMmixZ8kOH6Qhx2yooLUCvoEsbiaR2KdCgmB6h6uIhLNp7Z3
         sdd8R54I3k8YAnoV26BBMvWMXdDiFC0YuyJeKT4c1kfSqsM8yvUrYXU7XSCXrc8RkuH5
         DUrog7Z2SCPfExVUgz8LNHxJIIf+0+o3rvw+aJyCwupScHCSm8wVf7vCnWvZOh12VOoB
         yrxnTC8HuIm/zUF4Ds3sDkbKIVti2Mzqhjo4rYY1T7ggaIXQJ7q7gz2+xp96qavqyf40
         6CPuKorXOAngLmO3NpvFnPVNRPCwKWwFvjHv/CRfH+RYZK8SAmSC+kFEQ+0Pa63U6Neb
         UofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286930; x=1794891730;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=daK/IkDIXVqnfjYl8/M+M9VjkzPIwCe5yl4tay+gSqg=;
        b=KkJtfTbPo5UPCbusGv4FmQZJTwxWQfkDxfF89jTpsphMcMaS/rXcLVIMW8RXDjbj85
         P5T8iP4kc1t95EI/giDiBchZ7KZzCZnuR4wB84CvQv3EeW5V9EqZXBdQXY828ihMoAUQ
         3Lq+ct4hBqC8x78nwSMc2blcOJbRlvCnHAl5HGU6R2Moi2XLucLm8JnumbYCUK0XvJmv
         C2W7PoCrWP2zZKDXfzn/LmPWzh2zHVO+y6tHy6hz1ilj3X5qpzkCodvYpqzXrWANaZFM
         b/4SMml/z9o+yBRkdtaxpHNovSJ0RaNqlJOAYTEscszWoAWom1yAgjKr8E0LaTyfIlix
         y7aw==
X-Gm-Message-State: APuU4Z9J8IMRHpnYBZmnNqoqfdBas6/ZFD2S8BDFuZFYq5VLIsBr3Ujw
	RxFyAtQoORlIIp48GJxwoC7TbkgAOr0SrfrmX97R21NgBY2VxJlDewKdTAqOv8kZOwiTlW6d1J/
	kpkUvHD+ylUaITk+PTA==
X-Received: from edwl2.prod.google.com ([2002:a05:6402:1242:b0:6b3:bbb1:9405])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a6c3:10b0:6b4:8ba2:83ba with SMTP id 4fb4d7f45d1cf-6b756addabfmr786498a12.43.1794286929585;
 Mon, 09 Nov 2026 21:02:09 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:47 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-5-tarunsahu@google.com>
Subject: [PATCH v4 04/19] liveupdate: Reference struct luo_file_set_ser via
 serialized pointer
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

struct luo_session_ser currently embeds struct luo_file_set_ser directly
by value. Embedding struct luo_file_set_ser couples the session layout's
size and field offsets to struct luo_file_set_ser, preventing either
structure from appending fields independently across kexec.

Convert struct luo_session_ser to hold a DECLARE_KHOSER_PTR pointer to
struct luo_file_set_ser instead of embedding it by value. Reserve space
for both structures in each session block-set entry, placing struct
luo_file_set_ser immediately after struct luo_session_ser, and bump
LUO_ABI_COMPATIBLE from luo-v5 to luo-v6.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h     |  9 +++++----
 kernel/liveupdate/luo_session.c | 27 ++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 721949374fa1..f1152470f71a 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -61,13 +61,14 @@
 #include <linux/build_bug.h>
 #include <linux/kconfig.h>
 #include <linux/kho/abi/block.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include <uapi/linux/liveupdate.h>
 
 /*
  * The LUO state is registered under this KHO entry name.
  */
 #define LUO_KHO_ENTRY_NAME	"LUO"
-#define LUO_ABI_COMPATIBLE	"luo-v5"
+#define LUO_ABI_COMPATIBLE	"luo-v6"
 #define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
 
 /**
@@ -133,7 +134,7 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  * struct luo_session_ser - Represents the serialized metadata for a LUO session.
  * @name:         The unique name of the session, provided by the userspace at
  *                the time of session creation.
- * @file_set_ser: Serialized files belonging to this session,
+ * @file_set_ser: Serialized pointer to the files belonging to this session.
  *
  * This structure is used to package session-specific metadata for transfer
  * between kernels via Kexec Handover. An array of these structures (one per
@@ -144,10 +145,10 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  */
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
-	struct luo_file_set_ser file_set_ser;
+	DECLARE_KHOSER_PTR(file_set_ser, struct luo_file_set_ser *);
 };
 
-static_assert(sizeof(struct luo_session_ser) == 80);
+static_assert(sizeof(struct luo_session_ser) == 72);
 static_assert(!IS_ENABLED(CONFIG_64BIT) ||
 	      __alignof__(struct luo_session_ser) == 8);
 
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 74bc66929f4b..df667fe15fb2 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -131,18 +131,21 @@ struct luo_session_global {
 	struct luo_session_header outgoing;
 };
 
+#define LUO_SESSION_SER_SIZE (sizeof(struct luo_session_ser) + \
+			      sizeof(struct luo_file_set_ser))
+
 static struct luo_session_global luo_session_global = {
 	.incoming = {
 		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
 		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.incoming.block_set,
-						sizeof(struct luo_session_ser)),
+						LUO_SESSION_SER_SIZE),
 	},
 	.outgoing = {
 		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
 		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.outgoing.block_set,
-						sizeof(struct luo_session_ser)),
+						LUO_SESSION_SER_SIZE),
 	},
 };
 
@@ -223,14 +226,16 @@ static void luo_session_unfreeze_one(struct luo_session *session,
 				     struct luo_session_ser *ser)
 {
 	guard(mutex)(&session->mutex);
-	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
+	luo_file_unfreeze(&session->file_set,
+			  KHOSER_LOAD_PTR(ser->file_set_ser));
 }
 
 static int luo_session_freeze_one(struct luo_session *session,
 				  struct luo_session_ser *ser)
 {
 	guard(mutex)(&session->mutex);
-	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
+	return luo_file_freeze(&session->file_set,
+			       KHOSER_LOAD_PTR(ser->file_set_ser));
 }
 
 static int luo_session_release(struct inode *inodep, struct file *filep)
@@ -552,6 +557,17 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
 	return 0;
 }
 
+static struct luo_session_ser *luo_session_ser_init(void *mem)
+{
+	struct luo_file_set_ser *file_set_ser;
+	struct luo_session_ser *ser = mem;
+
+	file_set_ser = mem + sizeof(struct luo_session_ser);
+	KHOSER_STORE_PTR(ser->file_set_ser, file_set_ser);
+
+	return ser;
+}
+
 static int luo_session_deserialize_one(struct luo_session_header *sh,
 				       struct luo_session_ser *ser)
 {
@@ -575,7 +591,7 @@ static int luo_session_deserialize_one(struct luo_session_header *sh,
 
 	scoped_guard(mutex, &session->mutex) {
 		err = luo_file_deserialize(&session->file_set,
-					   &ser->file_set_ser);
+					   KHOSER_LOAD_PTR(ser->file_set_ser));
 	}
 	if (err) {
 		pr_warn("Failed to deserialize files for session [%s] %pe\n",
@@ -657,6 +673,7 @@ int luo_session_serialize(void)
 			goto err_undo;
 		}
 
+		ser = luo_session_ser_init(ser);
 		err = luo_session_freeze_one(session, ser);
 		if (err) {
 			kho_block_set_it_prev(&it);
-- 
2.56.0.506.g506a7eabc5-goog

