Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794286940;
	b=4UEgjJC/uaNKAPl5iqZb/PTZkbKr33jZGgdwoE3vUTRoKX25CP9gArpaXKsUWhJnwdRp
	 C2TzOVU4ErKKzW1TWVbNEB0CpVR55P4ysZz9oftyywazbSH3/I+hZvNf+V7tolCAWInk3
	 8cgLYqUm2pzaUKZDSQttcfle+LbtHzT4UpzQXf1B9ZVA+TqfMs7TOzP/eMTFUp3wN6RLA
	 SPMXtbS1nSjQAQ1D9mGtv5j+bE2VzpH7t8R2SeA/GISCTkeiRU3x3VJJyUdHqWa+dQ48B
	 nHZNTxl2sft9Nanh3pPY/+mE5ohJctA8stE62qgcoqQVw798G9PPKVEczOE5ELaVXBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794286940;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Jomqh3EBPc599hlxv7mE3jDDZh0m6vOE0Julqd7EtAs=;
	b=U6gMb83bX6itzIjM1smDwFYN/RkQUpNl8uwLO+iAsJ55aQKKW8IFs0j8qyyudZy/Fhnt
	 miDrt/T5oMejI9Mi0Wa6W+MMHXGnGwz2YlkYeP2JN8AMjrrGU6YD8B4VfDOwsSBO463zC
	 EcEBZr6sxD3Jjk4R+/CfZsSR4DUFthQxvwaSktZcCr756XXRwpxMQOgrgW5hedDNFpljU
	 NwKrqVbnoH8AEjEZRwmVd4nBcE0HeW46LwvV+hWWorDhwn4qq472gABbDKqs2dr9NnxCN
	 kKIlCa1wl6hVpznu7Sk1YJfCa+bus2f58bmaliuwCoMGFMDEVp7XDTenoifcGHq3pjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZDJS2N9t;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115F0606B8AC
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 05:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 115F0606B8AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZDJS2N9t
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c40bbd26f74so139686566b.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 21:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286938; x=1794891738; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jomqh3EBPc599hlxv7mE3jDDZh0m6vOE0Julqd7EtAs=;
        b=ZDJS2N9tCVZpKK2SKSgKSpqbTXVP+uK8XTLCZ0ZngTEaiRiKg6nQx5TcBQhZwFEPpj
         veFxskVvPD5pq7kcLvsAi3XwUc9r3ErunQiaVmMLhOnr+hdAD7THiD4YIXELk9dcgGAR
         /HjJfqyjos345ogtKbMbnJtiBB6qjzWPLhZM6dMLeBmcXDTMK0222nzIyAk7B7arvqDT
         VaE9dvQYRD11B1GF5WmJSqdr5eaJWhba1SxkjWD8iKTx0aEuHDoBLiFqSpdxwFa2Ykuz
         VU/lHB9FZO2OMMAGWjzqs/ol3I3DZMqQIjkNu0Y2SnnKG3sH7p1fRrsLxNG1aj2n3/Wa
         oA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286938; x=1794891738;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jomqh3EBPc599hlxv7mE3jDDZh0m6vOE0Julqd7EtAs=;
        b=JFjbPatPa5QCQu/NpqSqMWXAemCqs0fzPWSPmrXL9dbe8gIVjrXX2Y0HLU9eyE1MKN
         tOkLQsDJqdttuWo3N14CV4DedSSaf5wiq7PCR8ii/adOI77D6o0LOIQk4U7aM1X2CFwY
         zr+A1NrAaJDGN6fIGvMcn4XUBWXBttbf+RVqG0/bnuKLPQBahgzhMm5IyE0OHdZiauvm
         xfOV0dLOpLwZ5ptUJMbA1cylx3ypbiMCATwwr9lB1WXPHn5Ux4cuSeqm4SSq5rm7i8Ol
         Z2AsGhY0B2br/iYs1K3tXXbO+kwPvldjiLimuSvLfDhh9TCgv5xqBLvRqEQP9rFq+v9m
         nj3Q==
X-Gm-Message-State: APuU4Z+FXCqNFD5x2HlSZzXhkgVjCy/+AqvE4SY9OGdAaETcKVXqOq/7
	10+ceAAKKJBiEIhogBbGyBNiSSv0Zq+r3YjuQgU9reQwgTdzGxkJAs4YJyFqramegqPyzZXH81K
	mQuQjF5ec2h/rPLQCFw==
X-Received: from edzg2.prod.google.com ([2002:a05:6402:902:b0:6b5:8540:2bf])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d8f:b0:c48:a838:c16d with SMTP id a640c23a62f3a-c5049629dbbmr100182566b.30.1794286938072;
 Mon, 09 Nov 2026 21:02:18 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:55 +0000
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
Message-ID: <20261110050202.529473-13-tarunsahu@google.com>
Subject: [PATCH v4 12/19] liveupdate: Add feature header to struct luo_file_ser
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

Precede each serialized file entry in a LUO file set KHO block set with
struct kho_ser_hdr via DECLARE_KHO_SER so future per-file metadata
features can append fields to struct luo_file_ser without breaking
compatibility between adjacent kernels.

Initialize file set block sets with kho_ser_size(luo_file_ser), initialize
each entry feature header in luo_file_freeze(), and validate the incoming
feature header in luo_file_deserialize_one() before accessing the struct
luo_file_ser payload.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h  |  6 +++---
 kernel/liveupdate/luo_file.c | 26 +++++++++++++++++++-------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index bd19211c64e1..38b4658183a2 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -92,6 +92,8 @@ DECLARE_KHO_SER(luo_ser, 24, 0, 0);
  * @compatible:  File handler compatible string.
  * @data:        Private data
  * @token:       User provided token for this file
+ *
+ * Preceded by &struct kho_ser_hdr.
  */
 struct luo_file_ser {
 	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
@@ -99,9 +101,7 @@ struct luo_file_ser {
 	u64 token;
 };
 
-static_assert(sizeof(struct luo_file_ser) == 64);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct luo_file_ser) == 8);
+DECLARE_KHO_SER(luo_file_ser, 64, 0, 0);
 
 /**
  * struct luo_file_set_ser - Represents the serialized metadata for file set
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 02d09a80d785..2da327f8bdae 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -486,10 +486,12 @@ int luo_file_freeze(struct luo_file_set *file_set,
 	kho_block_set_it_init(&it, &file_set->block_set);
 
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
-		struct luo_file_ser *file_ser = kho_block_set_it_reserve_entry(&it);
+		DECLARE_KHO_SER_HDR(luo_file_ser, *fhdr) =
+			kho_block_set_it_reserve_entry(&it);
+		struct luo_file_ser *file_ser;
 
 		/* This should not fail normally as blocks were pre-allocated */
-		if (WARN_ON_ONCE(!file_ser)) {
+		if (WARN_ON_ONCE(!fhdr)) {
 			err = -ENOSPC;
 			goto err_unfreeze;
 		}
@@ -502,6 +504,8 @@ int luo_file_freeze(struct luo_file_set *file_set,
 			goto err_unfreeze;
 		}
 
+		kho_ser_init(fhdr, luo_file_ser);
+		file_ser = kho_ser_payload(fhdr, luo_file_ser);
 		strscpy(file_ser->compatible, luo_file->fh->compatible,
 			sizeof(file_ser->compatible));
 		file_ser->data = luo_file->serialized_data;
@@ -742,11 +746,19 @@ int luo_file_finish(struct luo_file_set *file_set)
 }
 
 static int luo_file_deserialize_one(struct luo_file_set *file_set,
-				    struct luo_file_ser *ser)
+				    DECLARE_KHO_SER_HDR(luo_file_ser, *fhdr))
 {
 	struct liveupdate_file_handler *fh;
 	bool handler_found = false;
+	struct luo_file_ser *ser;
 	struct luo_file *luo_file;
+	int err;
+
+	err = kho_ser_validate(fhdr, luo_file_ser);
+	if (err)
+		return err;
+
+	ser = kho_ser_payload(fhdr, luo_file_ser);
 
 	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
@@ -810,7 +822,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 			 DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr))
 {
 	struct luo_file_set_ser *file_set_ser;
-	struct luo_file_ser *file_ser;
+	DECLARE_KHO_SER_HDR(luo_file_ser, *fhdr);
 	struct kho_block_set_it it;
 	int err;
 
@@ -848,8 +860,8 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	 * reliably reset devices and reclaim memory.
 	 */
 	kho_block_set_it_init(&it, &file_set->block_set);
-	while ((file_ser = kho_block_set_it_read_entry(&it))) {
-		err = luo_file_deserialize_one(file_set, file_ser);
+	while ((fhdr = kho_block_set_it_read_entry(&it))) {
+		err = luo_file_deserialize_one(file_set, fhdr);
 		if (err)
 			goto err_destroy_blocks;
 		file_set->count++;
@@ -883,7 +895,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 void luo_file_set_init(struct luo_file_set *file_set)
 {
 	INIT_LIST_HEAD(&file_set->files_list);
-	kho_block_set_init(&file_set->block_set, sizeof(struct luo_file_ser));
+	kho_block_set_init(&file_set->block_set, kho_ser_size(luo_file_ser));
 }
 
 void luo_file_set_destroy(struct luo_file_set *file_set)
-- 
2.56.0.506.g506a7eabc5-goog

