Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A55B47044B
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 09:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194164; cv=none; b=dyrjaVzKfZSH3gx0fHs4+gZfYYCbt5oUtYbjPi1ncIE57qWdLnqCWhaz4Qlu8hA5akcw1MOZ+EM+d4ZkxjacjxSPlh+kc2sgP2fd8kEq9hu0rPF8jjsbVR9g2YY+7/m2SnKxL4NWCPW851aLJCrQ2lOXtT7JeviBCyrO/67ySx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194164; c=relaxed/simple;
	bh=p24hefQPXKLoBJuYF5Z14UnQBi4wThoAzcE04iKrpy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewEpEfUX9cazIDexO193Nn9KyR27O0I+wFysLxoR/2UkbenhZW5m7zk2bjGZdn4tYQdK4vh576pbyjrKG4fpM5rzK0BDGl9gWeCG0msvy3xLGJgP7Ifp9qaNz/31TlvtNuiMnWT42uZjKzFly7bQtAPkiwQcrAHBcEgkuzZZ0K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pRO06g6L; arc=none smtp.client-ip=74.125.228.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pRO06g6L"
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6acb6b726b5so2356444a12.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 02:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791194157; x=1791798957; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eUFnmfD1HFrO7M7fDEPhPzh1SVWIHE0Jg9iipMSxbpU=;
        b=pRO06g6Lm1NvjJk0YO51BRJBhmKniXk16BX76Y3JX7aiz5rJOpU1ipVmKMnHIe7ke2
         ZYxqEPvH8fsF7TOJ0YZDzQWimNt3UlmT9r2wwuGyzKWBeFR9xfFmFxUbbqi2UcpHdSur
         Q0pekX0/4tDfTmuDEh9ReKfVHUS+IaQUxyZTBkQQtgdzeIeQmSO3kCk2D/37EukligIo
         PXoAHNOQy9K7/WLr5WfOPkdz40Y4crMWML8vQ/2mMHjks/rjLkDeMSYuT9cvnY84PYxU
         qa+s5pn854f2Rqv/dj9gwJYNEhoq8pW0wdZKBspVes98gg6jROAkKD25RZOqqM0P8me/
         o6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791194157; x=1791798957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eUFnmfD1HFrO7M7fDEPhPzh1SVWIHE0Jg9iipMSxbpU=;
        b=NVMzNnxb3PuRTD1CJkWzC7OOtPlCkQJ/lbXBks8NXDZzfnfvMX9Z8WN5gCCNInZgVo
         RRfX6TE54g7cv6T6yNUN2EEkYalm1u+LyTCQhw8NguFu0W7Tjq2mIlapVGCb9sBmGeE3
         wpyQS40cIWXTCEgN9SEcLD01kHgtGNAaKTr94HpKp7SBtswlvCXXXpDDhEufgvZj5a2X
         XDzjcBBibjuKlGinT+uvlxmYNCecjSdSiaFLOSjMzqB9CXnWLBgAMPWIbTx8LEcBia0t
         arB/KBaIcmD4yLtol3eTqRXhU4m/D/A29x1zSNsrCgeLYjUyiKeRiSdJ0jRuoCbqOkdr
         f4kA==
X-Forwarded-Encrypted: i=1; AKwUvByvyIlpn9s22PdcKllKJTxob1J3KaBliud1DklMU6KhsLllReEMu/OfMF0SLbkY/etTwl6G8GU=@lists.linux.dev
X-Gm-Message-State: AFuF++nejMX6mdLOi37ejuFwlEYstkGTLRL2Gqa5JgLY0ieqxap1gLNg
	O6wQYOS3Fu41zd1Fjyllo+HBjHnSh7ij4vCh7OI+V/w8pbFc6YT9ad2c
X-Gm-Gg: AYBFou3JCmjrk4uebNI4PbAXsRC29PvmAWGf5FRHsdP0qnLlwLJGmMCKaGQtu2wgpHd
	embC2TBapPkFJITxyR0wW4ykng+kGoZOdMFP2wHmv4VjoIeQvQn0hsuHz4Ez6XnMivREHkueurX
	z5DoJSS9j7mYFWeHsXH2m1KS2K2kklfVgFgX9I+fY5h5MsYgaFAqA/QZo7TdyHdsznpHc19XdOO
	vupEbckz59R7DpILJmJ+u7JEptiGrcWZh7VJrTB5lPC7TQpBEeLxwmsYC1zJ1pBHKS5JzqlfGpz
	a5oI5Q1lVX3URZHdkBPjbPiEa4W/EMUNPSrIf7tvwiHLQXccwu+TmTaGIOgPgVyI93GiWf8NYZ6
	Uf09QILnMnfXFfv6BuvzQAsdBfUSjq6h+RoF02gwSqyEXsqPPnOliiJo1qZGCJ0rIR1nYIv9LJ4
	G3vOSAVo1Or7xqcxdwHYsWWCROXbmRNvbpd1C2+XvYtxm8caMouDcWq8hpG0w0rxfxQUsq+ufmm
	jE1iwhvjkKKkTon9++HjSur9xSZmIeFVqH8O7lJkx7OsyoBG4XqumefpzOSljdEgtd7YoUZqEy3
	oX7oJunFQr6Pu96T4wh3VayIMNsjNOd9sdM=
X-Received: by 2002:a17:907:9612:b0:c2b:7672:8e29 with SMTP id a640c23a62f3a-c2e4ad13e61mr823688566b.16.1791194156824;
        Mon, 05 Oct 2026 02:55:56 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31562aba16sm50753266b.23.2026.10.05.02.55.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2026 02:55:56 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>,
	Shuah Khan <shuah@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [RFC PATCH 2/6] dma-buf: Add get_phys() to describe a physical run
Date: Mon,  5 Oct 2026 09:55:48 +0000
Message-ID: <20261005095552.52748-3-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261005095552.52748-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261005095552.52748-1-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

iommufd and KVM write physical addresses into their own page tables.
To do so, they must ask the exporter which frames back an offset of a
dma-buf, whether that memory is RAM or MMIO, and whether it may be
written.

Add a get_phys() operation. The importer passes an offset and a maximum
length. The exporter reports one run: the frames that start at the
offset, are backed and physically contiguous, and share one attribute
word. The run never exceeds the length. The exporter may end it early,
so importers must not assume that it is the longest possible run.

get_phys() returns -ENOENT when the byte at the offset is not backed,
and -ENODEV when the buffer is revoked. The caller holds the
reservation, and either pins the attachment or handles revocation. A
reported frame stays valid until an invalidation that covers it
returns.

The attribute word holds the memory type and a READONLY flag. Zero
means writable RAM. Importers refuse unknown types, reserved bits and
unknown flags, so attributes added later fail safely. Two flag bits are
reserved: one for holes and one for confidential memory.

Convert vfio-pci, the iommufd selftest exporter and the KVM sample.
iommufd behaves as before: it maps a buffer only when one writable run
covers all of it.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/dma-buf/dma-buf.c               |  47 +++++++++++
 drivers/iommu/iommufd/iommufd_private.h |   8 --
 drivers/iommu/iommufd/iommufd_test.h    |  16 ++++
 drivers/iommu/iommufd/pages.c           |  74 ++++-------------
 drivers/iommu/iommufd/selftest.c        | 106 ++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_dmabuf.c      |  58 ++++++-------
 include/linux/dma-buf.h                 |  54 ++++++++++++
 include/linux/vfio_pci_core.h           |   3 -
 samples/kvm/gmem_provider.c             |  39 ++++-----
 9 files changed, 267 insertions(+), 138 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index d504c636dc29..66b85d53ed22 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1389,6 +1389,53 @@ void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings, "DMA_BUF");
 
+/**
+ * dma_buf_get_phys - describe the run that starts at an offset
+ * @attach: attachment to query
+ * @offset: first buffer byte to describe
+ * @len: maximum number of bytes to describe
+ * @phys: physical address and length of the run
+ * @attr: DMA_BUF_PHYS_ATTR_* word of the run
+ *
+ * A run is the longest stretch of backed bytes starting at @offset whose
+ * frames are physically contiguous and share one attribute word. On success
+ * *@phys starts at the byte at @offset and covers at most @len bytes; it may
+ * be shorter than the run.
+ *
+ * The dma-buf reservation must be held. The attachment must be pinned or have
+ * revocable importer operations. A frame remains valid until a covering
+ * invalidation callback returns; the exporter must invalidate a changed range
+ * before reusing its old frames.
+ *
+ * Returns:
+ *
+ * 0 on success, -ENOENT if the byte at @offset is not backed, -ENODEV if the
+ * buffer is revoked, -EOPNOTSUPP if the exporter cannot describe itself this
+ * way, or another negative error code.
+ */
+int dma_buf_get_phys(struct dma_buf_attachment *attach, u64 offset, u64 len,
+		     struct phys_vec *phys, u32 *attr)
+{
+	u64 end;
+	int ret;
+
+	if (WARN_ON_ONCE(!attach || !attach->dmabuf || !phys || !attr))
+		return -EINVAL;
+	if (!len || check_add_overflow(offset, len, &end) ||
+	    end > attach->dmabuf->size)
+		return -EINVAL;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+	if (!attach->dmabuf->ops->get_phys)
+		return -EOPNOTSUPP;
+
+	ret = attach->dmabuf->ops->get_phys(attach, offset, len, phys, attr);
+	if (!ret && WARN_ON_ONCE(!phys->len || phys->len > len))
+		return -EIO;
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_get_phys, "DMA_BUF");
+
 /**
  * DOC: cpu access
  *
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 43fbc5bed8de..5cded585c227 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -716,8 +716,6 @@ bool iommufd_should_fail(void);
 int __init iommufd_test_init(void);
 void iommufd_test_exit(void);
 bool iommufd_selftest_is_mock_dev(struct device *dev);
-int iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
-				     struct phys_vec *phys);
 #else
 static inline void iommufd_test_syz_conv_iova_id(struct iommufd_ucmd *ucmd,
 						 unsigned int ioas_id,
@@ -739,11 +737,5 @@ static inline bool iommufd_selftest_is_mock_dev(struct device *dev)
 {
 	return false;
 }
-static inline int
-iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
-				 struct phys_vec *phys)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 #endif
diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index 52b78cbcc920..28fd9c43edc4 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -31,6 +31,8 @@ enum {
 	IOMMU_TEST_OP_PASID_CHECK_HWPT,
 	IOMMU_TEST_OP_DMABUF_GET,
 	IOMMU_TEST_OP_DMABUF_REVOKE,
+	IOMMU_TEST_OP_MD_CHECK_MAPPED,
+	IOMMU_TEST_OP_MD_IOVA_TO_PHYS,
 };
 
 enum {
@@ -193,6 +195,20 @@ struct iommu_test_cmd {
 			__s32 dmabuf_fd;
 			__u32 revoked;
 		} dmabuf_revoke;
+		struct {
+			/*
+			 * 1: every page in [iova, iova+length) must be mapped;
+			 * 0: none of them may be. Mixed is an error.
+			 */
+			__u32 mapped;
+			__u32 __reserved;
+			__aligned_u64 iova;
+			__aligned_u64 length;
+		} check_mapped;
+		struct {
+			__aligned_u64 iova;
+			__aligned_u64 out_phys;	/* 0 if unmapped */
+		} iova_to_phys;
 	};
 	__u32 last;
 };
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index f9b2ae6d7e96..196d1bb330c2 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1463,68 +1463,12 @@ static const struct dma_buf_attach_ops iopt_dmabuf_attach_revoke_ops = {
 	.invalidate_mappings = iopt_revoke_notify,
 };
 
-/*
- * iommufd and vfio have a circular dependency. Future work for a phys
- * based private interconnect will remove this.
- */
-/*
- * Look up the exporter's phys accessor for iommufd's private-interconnect
- * path.  Also fills *is_cpu_ram: true if the exporter's memory is normal
- * cache-coherent RAM (needs BATCH_CPU_MEMORY / IOMMU_CACHE), false for MMIO
- * (needs BATCH_MMIO / IOMMU_MMIO).  This will be replaced by a formal
- * exporter op that returns phys + memory type together.
- */
-static int
-sym_vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
-				 struct phys_vec *phys, bool *is_cpu_ram)
-{
-	typeof(&vfio_pci_dma_buf_iommufd_map) fn;
-	int rc;
-
-	rc = iommufd_test_dma_buf_iommufd_map(attachment, phys);
-	if (rc != -EOPNOTSUPP) {
-		*is_cpu_ram = false;	/* test hook mimics VFIO MMIO */
-		return rc;
-	}
-
-	/*
-	 * Prototype: try the sample gmem provider's dma-buf exporter.  This
-	 * mirrors the vfio-pci private-interconnect hook, and (like it) is
-	 * meant to be replaced by a formal negotiated exporter op returning
-	 * phys + memory type.  The provider serves RAM, so mark it CPU_RAM.
-	 */
-	{
-		extern int gmem_provider_dma_buf_iommufd_map(
-			struct dma_buf_attachment *, struct phys_vec *);
-		typeof(&gmem_provider_dma_buf_iommufd_map) gfn;
-
-		gfn = symbol_get(gmem_provider_dma_buf_iommufd_map);
-		if (gfn) {
-			rc = gfn(attachment, phys);
-			symbol_put(gmem_provider_dma_buf_iommufd_map);
-			if (rc != -EOPNOTSUPP) {
-				*is_cpu_ram = true;
-				return rc;
-			}
-		}
-	}
-
-	if (!IS_ENABLED(CONFIG_VFIO_PCI_DMABUF))
-		return -EOPNOTSUPP;
-
-	fn = symbol_get(vfio_pci_dma_buf_iommufd_map);
-	if (!fn)
-		return -EOPNOTSUPP;
-	rc = fn(attachment, phys);
-	symbol_put(vfio_pci_dma_buf_iommufd_map);
-	*is_cpu_ram = false;	/* VFIO PCI dma-buf carries BAR (MMIO) memory */
-	return rc;
-}
-
 static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
 			   struct dma_buf *dmabuf)
 {
 	struct dma_buf_attachment *attach;
+	struct phys_vec pv;
+	u32 attr;
 	int rc;
 
 	attach = dma_buf_dynamic_attach(dmabuf, iommufd_global_device(),
@@ -1546,10 +1490,20 @@ static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
 	if (rc)
 		goto err_detach;
 
-	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys,
-					      &pages->dmabuf.is_cpu_ram);
+	/* One backed, writable run covering the buffer: refuse the rest. */
+	rc = dma_buf_get_phys(attach, 0, dmabuf->size, &pv, &attr);
+	if (rc == -ENOENT)
+		rc = -EOPNOTSUPP;
 	if (rc)
 		goto err_unpin;
+	if (pv.len != dmabuf->size || !dma_buf_phys_attr_known(attr) ||
+	    (attr & DMA_BUF_PHYS_ATTR_FLAGS_MASK)) {
+		rc = -EOPNOTSUPP;
+		goto err_unpin;
+	}
+	pages->dmabuf.phys = pv;
+	pages->dmabuf.is_cpu_ram =
+		dma_buf_phys_attr_type(attr) == DMA_BUF_PHYS_ATTR_RAM;
 
 	dma_resv_unlock(dmabuf->resv);
 
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index af07c642a526..0899272d1e66 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1962,32 +1962,31 @@ static void iommufd_test_dma_buf_release(struct dma_buf *dmabuf)
 	kfree(priv);
 }
 
-static const struct dma_buf_ops iommufd_test_dmabuf_ops = {
-	.attach = iommufd_test_dma_buf_attach,
-	.detach = iommufd_test_dma_buf_detach,
-	.map_dma_buf = iommufd_test_dma_buf_map,
-	.release = iommufd_test_dma_buf_release,
-	.unmap_dma_buf = iommufd_test_dma_buf_unmap,
-};
-
-int iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
-				     struct phys_vec *phys)
+static int iommufd_test_dma_buf_get_phys(struct dma_buf_attachment *attachment,
+					 u64 offset, u64 len,
+					 struct phys_vec *phys, u32 *attr)
 {
 	struct iommufd_test_dma_buf *priv = attachment->dmabuf->priv;
 
 	dma_resv_assert_held(attachment->dmabuf->resv);
-
-	if (attachment->dmabuf->ops != &iommufd_test_dmabuf_ops)
-		return -EOPNOTSUPP;
-
 	if (priv->revoked)
 		return -ENODEV;
 
-	phys->paddr = virt_to_phys(priv->memory);
-	phys->len = priv->length;
+	phys->paddr = virt_to_phys(priv->memory) + offset;
+	phys->len = len;
+	*attr = DMA_BUF_PHYS_ATTR_MMIO;
 	return 0;
 }
 
+static const struct dma_buf_ops iommufd_test_dmabuf_ops = {
+	.attach = iommufd_test_dma_buf_attach,
+	.detach = iommufd_test_dma_buf_detach,
+	.map_dma_buf = iommufd_test_dma_buf_map,
+	.release = iommufd_test_dma_buf_release,
+	.unmap_dma_buf = iommufd_test_dma_buf_unmap,
+	.get_phys = iommufd_test_dma_buf_get_phys,
+};
+
 static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
 				   unsigned int open_flags,
 				   size_t len)
@@ -2031,6 +2030,73 @@ static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
 	return rc;
 }
 
+/*
+ * Report the physical address the mock domain resolves @iova to, or 0 if
+ * it is unmapped.  Lets a test check that two IOVAs share one frame (a
+ * scratch substitution) without knowing the frame in advance.
+ */
+static int iommufd_test_md_iova_to_phys(struct iommufd_ucmd *ucmd,
+					unsigned int mockpt_id,
+					unsigned long iova)
+{
+	struct iommu_test_cmd *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	unsigned int page_size;
+	int rc;
+
+	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	page_size = 1 << __ffs(mock->domain.pgsize_bitmap);
+	if (iova % page_size) {
+		rc = -EINVAL;
+		goto out_put;
+	}
+	cmd->iova_to_phys.out_phys =
+		mock->domain.ops->iova_to_phys(&mock->domain, iova);
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put:
+	iommufd_put_object(ucmd->ictx, &hwpt->obj);
+	return rc;
+}
+
+static int iommufd_test_md_check_mapped(struct iommufd_ucmd *ucmd,
+					unsigned int mockpt_id,
+					unsigned long iova, size_t length,
+					bool mapped)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	unsigned int page_size;
+	int rc = 0;
+
+	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	page_size = 1 << __ffs(mock->domain.pgsize_bitmap);
+	if (iova % page_size || length % page_size || !length) {
+		rc = -EINVAL;
+		goto out_put;
+	}
+
+	for (; length; length -= page_size, iova += page_size) {
+		bool is_mapped =
+			mock->domain.ops->iova_to_phys(&mock->domain, iova) != 0;
+
+		if (is_mapped != mapped) {
+			rc = -ENOENT;
+			goto out_put;
+		}
+	}
+
+out_put:
+	iommufd_put_object(ucmd->ictx, &hwpt->obj);
+	return rc;
+}
+
 static int iommufd_test_dmabuf_revoke(struct iommufd_ucmd *ucmd, int fd,
 				      bool revoked)
 {
@@ -2143,6 +2209,14 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
 		return iommufd_test_dmabuf_revoke(ucmd,
 						  cmd->dmabuf_revoke.dmabuf_fd,
 						  cmd->dmabuf_revoke.revoked);
+	case IOMMU_TEST_OP_MD_CHECK_MAPPED:
+		return iommufd_test_md_check_mapped(ucmd, cmd->id,
+						    cmd->check_mapped.iova,
+						    cmd->check_mapped.length,
+						    cmd->check_mapped.mapped);
+	case IOMMU_TEST_OP_MD_IOVA_TO_PHYS:
+		return iommufd_test_md_iova_to_phys(ucmd, cmd->id,
+						    cmd->iova_to_phys.iova);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..381c3d338e8c 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -99,46 +99,46 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
 	kfree(priv);
 }
 
-static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
-	.attach = vfio_pci_dma_buf_attach,
-	.map_dma_buf = vfio_pci_dma_buf_map,
-	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
-	.release = vfio_pci_dma_buf_release,
-};
-
 /*
- * This is a temporary "private interconnect" between VFIO DMABUF and iommufd.
- * It allows the two co-operating drivers to exchange the physical address of
- * the BAR. This is to be replaced with a formal DMABUF system for negotiated
- * interconnect types.
+ * Report the BAR's physical range for importers which program it into their own
+ * translation tables, such as iommufd. A BAR is MMIO, never cache-coherent RAM.
  *
- * If this function succeeds the following are true:
- *  - There is one physical range and it is pointing to MMIO
- *  - When move_notify is called it means revoke, not move, vfio_dma_buf_map
- *    will fail if it is currently revoked
+ * When move_notify is called it means revoke, not move, so this fails while
+ * revoked and vfio_dma_buf_map() does the same.
  */
-int vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
-				 struct phys_vec *phys)
+static int vfio_pci_dma_buf_get_phys(struct dma_buf_attachment *attachment,
+				     u64 offset, u64 len,
+				     struct phys_vec *phys, u32 *attr)
 {
-	struct vfio_pci_dma_buf *priv;
+	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
+	u32 i;
 
 	dma_resv_assert_held(attachment->dmabuf->resv);
-
-	if (attachment->dmabuf->ops != &vfio_pci_dmabuf_ops)
-		return -EOPNOTSUPP;
-
-	priv = attachment->dmabuf->priv;
 	if (priv->revoked)
 		return -ENODEV;
 
-	/* More than one range to iommufd will require proper DMABUF support */
-	if (priv->nr_ranges != 1)
-		return -EOPNOTSUPP;
-
-	*phys = priv->phys_vec[0];
+	/* Report from @offset to the end of the BAR range containing it. */
+	for (i = 0; i < priv->nr_ranges; i++) {
+		if (offset < priv->phys_vec[i].len)
+			break;
+		offset -= priv->phys_vec[i].len;
+	}
+	if (i == priv->nr_ranges)
+		return -EINVAL;
+	phys->paddr = priv->phys_vec[i].paddr + offset;
+	phys->len = min_t(u64, priv->phys_vec[i].len - offset, len);
+	*attr = DMA_BUF_PHYS_ATTR_MMIO;
 	return 0;
 }
-EXPORT_SYMBOL_FOR_MODULES(vfio_pci_dma_buf_iommufd_map, "iommufd");
+
+static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
+	.attach = vfio_pci_dma_buf_attach,
+	.map_dma_buf = vfio_pci_dma_buf_map,
+	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
+	.release = vfio_pci_dma_buf_release,
+	.get_phys = vfio_pci_dma_buf_get_phys,
+};
+
 
 int vfio_pci_core_fill_phys_vec(struct phys_vec *phys_vec,
 				struct vfio_region_dma_range *dma_ranges,
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d1203da56fc5..b223962e20c2 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -13,6 +13,7 @@
 #ifndef __DMA_BUF_H__
 #define __DMA_BUF_H__
 
+#include <linux/bitfield.h>
 #include <linux/iosys-map.h>
 #include <linux/file.h>
 #include <linux/err.h>
@@ -23,6 +24,7 @@
 #include <linux/dma-fence.h>
 #include <linux/wait.h>
 #include <linux/pci-p2pdma.h>
+#include <linux/types.h>
 
 struct device;
 struct dma_buf;
@@ -182,6 +184,29 @@ struct dma_buf_ops {
 			      struct sg_table *,
 			      enum dma_data_direction);
 
+	/**
+	 * @get_phys:
+	 *
+	 * Describe the run that starts at @offset, for an importer that
+	 * programs its own translation tables. A run is the longest stretch
+	 * of backed bytes whose frames are physically contiguous and share
+	 * one attribute word. Report it in *@phys, starting at the byte at
+	 * @offset and clipped at @offset + @len, with its DMA_BUF_PHYS_ATTR_*
+	 * word in *@attr. The exporter may stop before the end of the run;
+	 * importers must not assume the reported run is maximal.
+	 *
+	 * Return 0 on success, -ENOENT if the byte at @offset is not backed,
+	 * -ENODEV if the buffer is revoked, or another negative error. Do not
+	 * wait for memory to become available.
+	 *
+	 * The dma-buf reservation is held. The attachment must be pinned or
+	 * have revocable importer operations. A reported frame remains valid
+	 * until a covering invalidation callback returns; an exporter must
+	 * invalidate every change before reusing an old frame.
+	 */
+	int (*get_phys)(struct dma_buf_attachment *attach, u64 offset, u64 len,
+			struct phys_vec *phys, u32 *attr);
+
 	/* TODO: Add try_map_dma_buf version, to return immed with -EBUSY
 	 * if the call would block.
 	 */
@@ -576,6 +601,35 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
 void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
 bool dma_buf_attach_revocable(struct dma_buf_attachment *attach);
+/* bits 0-7: memory type (a value, not flags) */
+#define DMA_BUF_PHYS_ATTR_TYPE_MASK	GENMASK(7, 0)
+#define DMA_BUF_PHYS_ATTR_RAM		0x00	/* cache-coherent system RAM */
+#define DMA_BUF_PHYS_ATTR_MMIO		0x01	/* device MMIO, uncached */
+/* bits 8-15: reserved for a second value field; must be zero */
+#define DMA_BUF_PHYS_ATTR_RSVD_MASK	GENMASK(15, 8)
+/* bits 16-31: flags; undefined bits must be zero */
+#define DMA_BUF_PHYS_ATTR_READONLY	BIT(16)
+/* BIT(17): reserved (hole, for importers that walk across gaps) */
+/* BIT(18): reserved (private, for confidential computing) */
+#define DMA_BUF_PHYS_ATTR_FLAGS_MASK	(DMA_BUF_PHYS_ATTR_READONLY)
+
+static inline u32 dma_buf_phys_attr_type(u32 attrs)
+{
+	return FIELD_GET(DMA_BUF_PHYS_ATTR_TYPE_MASK, attrs);
+}
+
+static inline bool dma_buf_phys_attr_known(u32 attrs)
+{
+	return dma_buf_phys_attr_type(attrs) <= DMA_BUF_PHYS_ATTR_MMIO &&
+	       !(attrs & DMA_BUF_PHYS_ATTR_RSVD_MASK) &&
+	       !(attrs & ~(DMA_BUF_PHYS_ATTR_TYPE_MASK |
+			  DMA_BUF_PHYS_ATTR_RSVD_MASK |
+			  DMA_BUF_PHYS_ATTR_FLAGS_MASK));
+}
+
+int dma_buf_get_phys(struct dma_buf_attachment *attach, u64 offset, u64 len,
+		     struct phys_vec *phys, u32 *attr);
+
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 9a1674c152aa..2a1d13abdb0c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -257,7 +257,4 @@ vfio_pci_core_get_iomap(struct vfio_pci_core_device *vdev, unsigned int bar)
 	return vdev->barmap[bar];
 }
 
-int vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
-				 struct phys_vec *phys);
-
 #endif /* VFIO_PCI_CORE_H */
diff --git a/samples/kvm/gmem_provider.c b/samples/kvm/gmem_provider.c
index 75197c088762..b6824fe5d228 100644
--- a/samples/kvm/gmem_provider.c
+++ b/samples/kvm/gmem_provider.c
@@ -487,35 +487,30 @@ static void gmem_dma_buf_release(struct dma_buf *dmabuf)
 	kfree(priv);
 }
 
-static const struct dma_buf_ops gmem_dma_buf_ops = {
-	.attach		= gmem_dma_buf_attach,
-	.map_dma_buf	= gmem_dma_buf_map,
-	.unmap_dma_buf	= gmem_dma_buf_unmap,
-	.release	= gmem_dma_buf_release,
-};
-
-/*
- * Private interconnect for iommufd (mirrors vfio_pci_dma_buf_iommufd_map).
- * Returns the single contiguous phys range for the exported region so iommufd
- * can program the IOMMU directly, bypassing the DMA API.
- */
-int gmem_provider_dma_buf_iommufd_map(struct dma_buf_attachment *attach,
-				      struct phys_vec *phys);
-int gmem_provider_dma_buf_iommufd_map(struct dma_buf_attachment *attach,
-				      struct phys_vec *phys)
+/* Report this flat sample region through the generic dma-buf operation. */
+static int gmem_dma_buf_get_phys(struct dma_buf_attachment *attach,
+				 u64 offset, u64 len,
+				 struct phys_vec *phys, u32 *attr)
 {
-	struct gmem_dmabuf *priv;
+	struct gmem_dmabuf *priv = attach->dmabuf->priv;
 
 	dma_resv_assert_held(attach->dmabuf->resv);
-	if (attach->dmabuf->ops != &gmem_dma_buf_ops)
-		return -EOPNOTSUPP;
-	priv = attach->dmabuf->priv;
 	if (priv->revoked)
 		return -ENODEV;
-	*phys = priv->phys;
+
+	phys->paddr = priv->phys.paddr + offset;
+	phys->len = len;
+	*attr = DMA_BUF_PHYS_ATTR_RAM;
 	return 0;
 }
-EXPORT_SYMBOL_FOR_MODULES(gmem_provider_dma_buf_iommufd_map, "iommufd");
+
+static const struct dma_buf_ops gmem_dma_buf_ops = {
+	.attach		= gmem_dma_buf_attach,
+	.map_dma_buf	= gmem_dma_buf_map,
+	.unmap_dma_buf	= gmem_dma_buf_unmap,
+	.release	= gmem_dma_buf_release,
+	.get_phys	= gmem_dma_buf_get_phys,
+};
 
 /* Called with info->dmabufs_lock held on the revoke path. */
 static void gmem_dma_buf_revoke_all(struct gmem_info *info)
-- 
2.47.3

