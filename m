Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794286941;
	b=KKFIBwvoDKq1V52qrzxcxeZNAwWoznd+X8a+Hg0ibfSli7QfOls2Sx1iknUARyDY/w4f
	 4z1o6y4+72xE2xarZPr/TzjKyPobOIZHdEwIZySvKXvB8wU9Z3ybZPMnKZadrBTZS2sRi
	 aEQT6IqfVIb98vGAXoKedjW3WwvdGwHw2ti9Vcgk5nvR/JmGaqDeQN76eOxz6rDHCSRQg
	 AYjcaU8no6APi8bNvSkWuN+S6u4x3yMjoi2uJlByeyrGsCs87F2B2h0VzhvXPlnIoN6So
	 f6SWeXBxtxs6COmkUzNb8IOprRUIeyHGf3Iv9jKL5gbuqMehzTbvCtOoigy7oAkL5ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794286941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=hqbeun0C1/XgWjYnTEG1QqOg75mMAInimMPRhrMj/I8=;
	b=nXcfxVhQmxOpdX4XiWG3C76WQVXF661kRUIh30Rx2/UdIKrPARouZ5C6Tifk4RkoiafM
	 g9koCc3b0L/sUsUfZt8nfNPR73Q1iSAZemEOLMWJBFJWR9pupKEUp81esVMNf0HjsVMpF
	 bkIMsQmy4SLO3xiEATywKiZgmImnSMqs5jrp0Psz9L9FJWgGvbS4hvjLE5L1o/HgUdGMl
	 cZcfiK2BFauRwoHY6voEavFpWZwvSDTo7E78VRCuMzcq3ZDd7q6IadFV/uVe2UE8zLahf
	 P9JrPyVgv33twfuJXUxy3NLZULEA7EyBcubXzixTb9ofKV3r7nzQZW+zOYVaUOpV4kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=H436baV0;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DD760A2617
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 05:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15DD760A2617
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=H436baV0
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b5e0ce4132so1260227a12.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 21:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286940; x=1794891740; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hqbeun0C1/XgWjYnTEG1QqOg75mMAInimMPRhrMj/I8=;
        b=H436baV0+aKrs5ahyhsUseWLuGyF27Jy6PSs85KAm6Du3WGatIvwwNOcNytwtkZVon
         DvNdItBBd0d2qPMMINLWqfL4xUvc6EQEfaX4tckjq+csubXF/VnEP6mZvaH2aOhOh3ji
         Io53HmzDK4wvXqT3y3rXQQOtMk1yMgtZeBwdm93N+0zx0eT3LP44Sl/37VretK9KtAY6
         TR6ZypCJL9WZfqIWyZ4a0OqDgzAIfx8BWPuGxf/b/kr0G18QwbGWPXXdbV30oJlpQtrq
         meIwr4iwOrp+JtY2oJbxpT6Ke8pd/9ddDlgjDyqCusj/DIzvof6qx26o0dH6q1mmWnsP
         frbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286940; x=1794891740;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hqbeun0C1/XgWjYnTEG1QqOg75mMAInimMPRhrMj/I8=;
        b=yQXUXJ6hXnyKMrnlbtnbKmneDIacAOKK9qb61nj2KKrP/WL1LtmEiX58p49S1Hbd4L
         N23Xeorrw0vOSeyn9l/LnrTvTUpEmG2WxDG+fp2kRXQYhIo1R4pMPRBUfUz3yhmcN7+B
         11qh/O2VMV6slxGSgtV1as79aV6GX4yfHOA9YEu8ngCmblfGQq3m7ev89Eo5ra0a1AtB
         zWlAKoDRuXvMrSs01a2VYkCSPViORMSnAGbNcdWNyJGyt9cYKkce05la9xuVi7lSENGZ
         XfidBwEkokuKJy6PYeUPBzxlkgR98RFnrrJorcFCZTrlfdJxOz3Ei/RELyeyIc4tt0i0
         eMbA==
X-Gm-Message-State: APuU4Z+TAkSuo6ADWncC99L3n098pPAQiOwoxMtP9Ig3XG3XXCCmGgKx
	GM4cGhIdv0W2z1K4smSbqOaf9hwRiwl9KseEgc+ug+nW963XaUPBmXcbKVlmvJLsbxKv68Iqd2R
	8s2/gcKlW5YsoCIpicA==
X-Received: from ejqs13.prod.google.com ([2002:a17:906:454d:b0:c3f:2fd1:c5c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6d0d:b0:c41:e0c0:e6b7 with SMTP id a640c23a62f3a-c504951cddfmr104842866b.12.1794286939400;
 Mon, 09 Nov 2026 21:02:19 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:56 +0000
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
Message-ID: <20261110050202.529473-14-tarunsahu@google.com>
Subject: [PATCH v4 13/19] liveupdate: Add feature header to struct luo_flb_header_ser
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

Precede struct luo_flb_header_ser with struct kho_ser_hdr via
DECLARE_KHO_SER so future File-Lifecycle-Bound (FLB) header features can
append fields to struct luo_flb_header_ser without breaking compatibility
between adjacent kernels.

Initialize the header in luo_flb_setup_outgoing() and place the outgoing
entry array immediately after kho_ser_size(luo_flb_header_ser). On the
incoming path in luo_flb_setup_incoming(), validate the feature header
with kho_ser_validate() and locate the incoming entry array at
fhdr->size so entries remain properly aligned even if the source kernel
serialized a different header layout.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h      |  6 ++----
 kernel/liveupdate/luo_core.c     |  4 +---
 kernel/liveupdate/luo_flb.c      | 36 +++++++++++++++++++++-----------
 kernel/liveupdate/luo_internal.h |  2 +-
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 38b4658183a2..4913707ba0d3 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -157,16 +157,14 @@ DECLARE_KHO_SER(luo_session_ser, 72, 0, 0);
  * This structure is located at the physical address specified by the
  * flbs_pa in luo_ser.
  *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
+ * Preceded by &struct kho_ser_hdr.
  */
 struct luo_flb_header_ser {
 	u64 pgcnt;
 	u64 count;
 };
 
-static_assert(sizeof(struct luo_flb_header_ser) == 16);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct luo_flb_header_ser) == 8);
+DECLARE_KHO_SER(luo_flb_header_ser, 16, 0, 0);
 
 /**
  * struct luo_flb_ser - Represents the serialized state of a single FLB object.
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index d0f72f27001d..79bb5f64bfac 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -131,9 +131,7 @@ static int __init luo_early_startup(void)
 	if (err)
 		goto out_free_ser;
 
-	luo_flb_setup_incoming(luo_ser->flbs_pa);
-
-	err = 0;
+	err = luo_flb_setup_incoming(luo_ser->flbs_pa);
 
 out_free_ser:
 	kho_restore_free(fhdr);
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index cd715a7c1d99..a8dcdb8456fd 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -53,7 +53,7 @@
 
 #define LUO_FLB_PGCNT		1ul
 #define LUO_FLB_MAX		(((LUO_FLB_PGCNT << PAGE_SHIFT) -	\
-		sizeof(struct luo_flb_header_ser)) / sizeof(struct luo_flb_ser))
+		kho_ser_size(luo_flb_header_ser)) / sizeof(struct luo_flb_ser))
 
 struct luo_flb_header {
 	struct luo_flb_header_ser *header_ser;
@@ -559,33 +559,45 @@ int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp)
 
 int __init luo_flb_setup_outgoing(u64 *flbs_pa)
 {
+	DECLARE_KHO_SER_HDR(luo_flb_header_ser, *fhdr);
 	struct luo_flb_header_ser *header_ser;
 
-	header_ser = kho_alloc_preserve(LUO_FLB_PGCNT << PAGE_SHIFT);
-	if (IS_ERR(header_ser))
-		return PTR_ERR(header_ser);
+	fhdr = kho_alloc_preserve(LUO_FLB_PGCNT << PAGE_SHIFT);
+	if (IS_ERR(fhdr))
+		return PTR_ERR(fhdr);
 
-	*flbs_pa = virt_to_phys(header_ser);
+	kho_ser_init(fhdr, luo_flb_header_ser);
+	header_ser = kho_ser_payload(fhdr, luo_flb_header_ser);
+
+	*flbs_pa = virt_to_phys(fhdr);
 
 	header_ser->pgcnt = LUO_FLB_PGCNT;
 	luo_flb_global.outgoing.header_ser = header_ser;
-	luo_flb_global.outgoing.ser = (void *)(header_ser + 1);
+	luo_flb_global.outgoing.ser = (void *)fhdr + kho_ser_size(luo_flb_header_ser);
 	luo_flb_global.outgoing.active = true;
 
 	return 0;
 }
 
-void __init luo_flb_setup_incoming(u64 flbs_pa)
+int __init luo_flb_setup_incoming(u64 flbs_pa)
 {
-	struct luo_flb_header_ser *header_ser;
+	DECLARE_KHO_SER_HDR(luo_flb_header_ser, *fhdr);
+	int err;
 
 	if (!flbs_pa)
-		return;
+		return 0;
 
-	header_ser = phys_to_virt(flbs_pa);
-	luo_flb_global.incoming.header_ser = header_ser;
-	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
+	fhdr = phys_to_virt(flbs_pa);
+	err = kho_ser_validate(fhdr, luo_flb_header_ser);
+	if (err)
+		return err;
+
+	luo_flb_global.incoming.header_ser =
+		kho_ser_payload(fhdr, luo_flb_header_ser);
+	luo_flb_global.incoming.ser = (void *)fhdr + fhdr->size;
 	luo_flb_global.incoming.active = true;
+
+	return 0;
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index e22a8cf39d91..df8306d73768 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -121,7 +121,7 @@ void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
 void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
 int __init luo_flb_setup_outgoing(u64 *flbs_pa);
-void __init luo_flb_setup_incoming(u64 flbs_pa);
+int __init luo_flb_setup_incoming(u64 flbs_pa);
 void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
-- 
2.56.0.506.g506a7eabc5-goog

