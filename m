Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D8346C846
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 09:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194165; cv=none; b=UDfufaf7jDsiJR9dmXneQd4ri3SmlUusTCjHOaQG2i9xNrH/vvY5U/wjhTip1lq2+nTsTellB8hJGfyGUJ2nhykczojNnx8LzU6NzLqnnq2VB3WhUIu2JxT7E/dD1nMSveSCXvCIcPzyYadd/tWZZRfWGlVkWPu9VIy2XpN2qCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194165; c=relaxed/simple;
	bh=ARYO8oRzysyDjWqkNeWzqMaVQP/6D2sRYtg4hlwDrxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqY4G1XNPysO4q7fMCeR+UCsfZMDAkIJl/65/9aaBQZ5WSK6A+6NNOsD3/VVaSaNVmzXoGR2IjXBIAb3C10vkX22q4lofNjrhPpDirv2fMThJeRFh1f/Iwxz2/066Egm2wUjXgfn0ZElwMwR9NdVlif7P6oPsodgDy6cNUZk5qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IC3ERM05; arc=none smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IC3ERM05"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2a4fbc5586so273127266b.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 02:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791194160; x=1791798960; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JwlAWAAy7BYUoB7+a9T937QVUxmXXORCOGD20YZnv/k=;
        b=IC3ERM05EbDjOzW+1J0QQsiE8B0RMBt3ne7K09xmsyaOF7V/rCZncJoPUdsnfeFpNn
         x0SVLCNZTbd+q3sGiSzVrTECqyc//UsyuS3t6a4GxP0Z/lgGRjaFKi1pdjDyz04JBbUQ
         KqhgPYG55wGPY7Fi3QDJTvkq2Evx7zwBqFk0AdOlyY2aHOrn0NhrzHW6U6iebfPYz0qs
         xLQJGXxWpBpHVu+8MS05vuydDylqX2LwTRTc9Zjqv1kVeF/CXIPb0wBzO9YnOziVWIpo
         vLRlBYh35aHwMLMkv1zIGmumXjbsrbClm/opo4+JK2rBA17UmrIQ9RdpqKN/CbzUfc2O
         YvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791194160; x=1791798960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JwlAWAAy7BYUoB7+a9T937QVUxmXXORCOGD20YZnv/k=;
        b=KprPD63KsKGk5w0tR8AjOLlBw979omxdS4dGLWCFqKHmjEBrWUjBHNkX8DyVwj+xIo
         S1qHcLmtfbWFrp5/Bytac/pZWXerc0JwU5PmXd+NINebb2hq0I7CyTZ4v++mNuEEz3Fw
         p2jzL8mkAu5sZKmiWpmhpCX+MosjeUbvNH9F0+vQPcAQhhVnSVxqgbb9M30pxPvdASP1
         SBLVx2yXFr0/9p7U6lXexuuT/I2F8d9a8M9zlIOvAT2mYcRSE90bFbBBo4/s3hSd8ETa
         wfPLapzfFgY8MwgEL1CQJLd7yinwnu/cyywwQMZ7Npxlzo+gx5VSttzi77UzBySdJj8L
         +JOg==
X-Forwarded-Encrypted: i=1; AKwUvByX/2L0h4FK7KvEfiowAs8qwqVreI43xB1+fN0RlgWPQWki5jcuB2/Vi1PorvNuR+i6OBtpV1c=@lists.linux.dev
X-Gm-Message-State: AFuF++k+H+ZVW5Inmj1kRNya9jDfWMo8ZFehYEAZn3kPrPFu3nssaRCJ
	RqjcCwPPaHlPaQJdoM/4FlIObvf9CWAevZCSN3Xastz8Gkbf/rVR2Rqy
X-Gm-Gg: AYBFou22TPbtqARk7fum+Z/PDn5M4nKx3+VCFgGcD8qGf/FjpMcki5VBScC5ZGmHe1A
	VWqW1zjKPg+GqqbRMsj05l0wYLlHUrn8c7Ze9pGtX/L/DLxKmUc9lsOhwJTPo4oTFCoagvDAUQ9
	s2BaUMbdhqMZGEvxjPmfeXvEF2Wyd1ESycpNv0NcubtJYcrRRMBdjRO6HCnc23+nzV8JegO5D0p
	ArS6H9ALGPe2Fs3f4S4oJaxQ7x4HSUPD+VAATppu1BAEHfvXwPxOhiZRtM2piXkKZKmKfD+2eXL
	rxkiNMge61q55srmyCX/qqCxiab7IljPmhZGRYMfabugVqrdux6w/aQgNacK91TERRJpjl5dPhg
	y1ye63WTtbzdwQlTn/P3MSwG/zhqbIO+qmraO4JJSBuAIOiajWqUZq/a1cS8zy42kagx/KN7DoF
	vpSqvAu52TEfgF5+3qx0W7gNT+FvIyB82ZOk41kgGVnyrZzgQky/GhueuxCOnDFP7J7+A0iFcE4
	Uxym/bQ7BSAwxr5uIxryT0NhfpjSiW4YCrWu8BsJasGleUt79jgp7NrxSfR+Ql7PsET8nmWdjI7
	XtWX+pV9vv5Fftv2MEz5uuy6CwBuR9O3p+X34REdPfyXkg==
X-Received: by 2002:a17:907:6d11:b0:c25:2688:8212 with SMTP id a640c23a62f3a-c2e4a6a273emr858285166b.0.1791194159542;
        Mon, 05 Oct 2026 02:55:59 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31562aba16sm50753266b.23.2026.10.05.02.55.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2026 02:55:59 -0700 (PDT)
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
Subject: [RFC PATCH 4/6] dma-buf: Allow dynamic attach without a device
Date: Mon,  5 Oct 2026 09:55:50 +0000
Message-ID: <20261005095552.52748-5-griffoul@gmail.com>
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

dma_buf_dynamic_attach() requires a struct device: the device for which
the buffer is mapped for DMA. Exporters may also check it before they
accept the attachment. An importer that does not perform DMA has no
such device. iommufd already attaches with a global placeholder device
for this reason. KVM would need one too, although it only needs to know
where the memory is so that it can map it into a guest.

Allow @dev to be NULL for a dynamic importer. Such an importer learns
where the memory is from get_phys() and builds its own mappings. It
must not map the attachment for DMA, and dma_buf_map_attachment()
refuses an attachment without a device. An exporter that needs a device
to answer can refuse the attachment in its attach op, as it can for any
other reason.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/dma-buf/dma-buf.c      | 15 +++++++++++++--
 include/trace/events/dma_buf.h |  2 +-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index e7010163eb2f..3d43b529a523 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1007,6 +1007,13 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  * Note that this can fail if the backing storage of @dmabuf is in a place not
  * accessible to @dev, and cannot be moved to a more suitable place. This is
  * indicated with the error code -EBUSY.
+ *
+ * @dev may be NULL for a dynamic importer that is not a DMA master: one that
+ * only asks the exporter where the memory is, through &dma_buf_ops.get_phys,
+ * and builds its own mappings from the answer.  Such an importer must never
+ * call dma_buf_map_attachment(), and an exporter that needs a device to
+ * answer (a peer-to-peer check, say) refuses the attachment in its
+ * &dma_buf_ops.attach.
  */
 struct dma_buf_attachment *
 dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
@@ -1016,7 +1023,7 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	struct dma_buf_attachment *attach;
 	int ret;
 
-	if (WARN_ON(!dmabuf || !dev))
+	if (WARN_ON(!dmabuf || (!dev && !importer_ops)))
 		return ERR_PTR(-EINVAL);
 
 	attach = kzalloc_obj(*attach);
@@ -1175,6 +1182,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 
 	if (WARN_ON(!attach || !attach->dmabuf))
 		return ERR_PTR(-EINVAL);
+	/* An importer without a device cannot be a DMA master. */
+	if (WARN_ON(!attach->dev))
+		return ERR_PTR(-EINVAL);
 
 	dma_resv_assert_held(attach->dmabuf->resv);
 
@@ -1847,7 +1857,8 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 		attach_count = 0;
 
 		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
-			seq_printf(s, "\t%s\n", dev_name(attach_obj->dev));
+			seq_printf(s, "\t%s\n", attach_obj->dev ?
+				   dev_name(attach_obj->dev) : "none");
 			attach_count++;
 		}
 		dma_resv_unlock(buf_obj->resv);
diff --git a/include/trace/events/dma_buf.h b/include/trace/events/dma_buf.h
index 3bb88d05bcc8..7cabca53b798 100644
--- a/include/trace/events/dma_buf.h
+++ b/include/trace/events/dma_buf.h
@@ -40,7 +40,7 @@ DECLARE_EVENT_CLASS(dma_buf_attach_dev,
 	TP_ARGS(dmabuf, attach, is_dynamic, dev),
 
 	TP_STRUCT__entry(
-		__string(	dev_name,			dev_name(dev))
+		__string(dev_name, dev ? dev_name(dev) : "none")
 		__string(	exp_name,			dmabuf->exp_name)
 		__field(	size_t,				size)
 		__field(	ino_t,				ino)
-- 
2.47.3

