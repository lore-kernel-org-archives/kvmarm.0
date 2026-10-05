Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA17E47255F
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194164; cv=none; b=DWedTTkh03G/iSeFBZ9isghU/Vxutm2QPSThF3YKDAZnmBMMKbute5V2Qnciehnv1AkbVHc/Xeqc0xCyUWsQGoo9JgcZR52dsJWlgy9KXXxyQ3zVSv9dQI6XvCjq3OSVYMzF8xyLiJrAQNwnTqkv74HEA4EvV/GNulmvzclp3mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194164; c=relaxed/simple;
	bh=W+faagf9X6giuP7Jvxi6Qt0uOgcW4oIP8+vZrnvBrKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xose+mfqFsxzMfUe6FCc0cmtQjGiWmoSlEqs6implZBAsrPWU/exJQ11u8v3NHvagxCh1CF4CYPN3ZEJDpuD1NUGyS+hJSnHF67Fz4IhC/IVJBlF1LQk5Sb1207ZuXrUxKFS28xUSneM4sajNHioHc9P40ziZ3zKI7TuuttRrgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R4boc6Wm; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R4boc6Wm"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb470so266547066b.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 02:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791194158; x=1791798958; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lD6pTqRDMSfKXNqb4UUFNdsEKglv/1NbFFOX0KLFSbY=;
        b=R4boc6WmXoOAcU08VrXFZ0meOdcCTFkRq5SxerArgCeiozC47cY089LLcDzhol20Ch
         7gL8IHouyBAVV0Kbsu55Df3e5gmT+Pmm/bjjIAmvPB+zF8WG3uQ0EYAavig6Y01QJH/G
         vTzw3rXEYMZiB3YLI2AbsFo8wzQK5bxUBKMB5tlnGxHvOU5E0cpa138GaHtdJJjIohSc
         ueGoeg9I9WZI50bldWwelbEE+NQkZpVxlCyPlefmNKUa9YhrhNa4PKFozJg2E5fl8JBG
         JVijrLKLszaSsXSi0hN1yeXqTi4STr44vdpkmb7eJC2e7fKh8Bl59YlbZKPvsMy+LC34
         u4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791194158; x=1791798958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lD6pTqRDMSfKXNqb4UUFNdsEKglv/1NbFFOX0KLFSbY=;
        b=jTI4lMdAGP4pZr/7pySCIvWJIq1/BfaBpEa+6wrLPN1irIxQaaCKIW+do3gijf3iZI
         FAEwr9iSJSZi2hUEqaJuFUIMPhvBCdIhnEFwptLeH4NpEPUQcGQX83bhXFCCwHTsa3SD
         yIsASV4pXy1Jnn+XmJV4gAg/o3p63UjatW8Ok9d+2OVRzqlbDePiKm/AMFv0SZGrN2pV
         3eJt+EXwtNZJP4yCgh3I9fax73BkDDcEq5UzSCJAXUN5PT8E+R4RZr+OzOymflgkQPGs
         nwUiOkEvF/C6896y0JnZEHs1Ey8F5DZf1s0Kc1KaYUpoQokpAAAKZCIBACVAt3ZgVuA0
         r9aA==
X-Forwarded-Encrypted: i=1; AKwUvBzplcVj+QRzRnOS9XDOpQ/Fw3Of1CfFyRKOsBz+xxnYJ0zPMrhWRIjVXByjRlsDBoHTvT6HYvI=@lists.linux.dev
X-Gm-Message-State: AFq9FYKceaXTSmsLKKexER7l8c2S7e3eWMmRpP47UB7moYg1yeqe1S5c
	YDXfDUjbPtdfxUr3pp1sGtWyU1kCYe1nF7Mt5XMRmITYJ0AneL/pNWP4
X-Gm-Gg: AYBFou3kLbLFa57PCO/zkJ4RSwGj/DTgbbCCYiCeo9KpsHeEr4so4WbJ+BRgh/YjjJS
	5gTodKRD7yu8UfW+GspzCQV7km7EsFpWFY/2ohTLhhg4m7jzKnQkFhPhmcOQWq2LlDI+BwTPrFs
	naDF9uuKFUauL9m7Itga3wRMYee5O4370YQMCs+mx1zcNZvW3JMo9OAdCV9IBwUsPG8ObRa2bLQ
	I9GQ3uDgSjVdrwOPv8gznYfnf4kG/OE/zVGRzWvxZCkXaChTLoeaDY5jEBfgzGTmNv3omBlHXAr
	ZP5VP5iQxSitfvbAfWtBm9hs2t7cnJQVTekVShgro7o7lHVdqjszl49eX+oJhNIDv/70oRg30LB
	hTJ42W4KIJO4xIAoNPRm8lvozPt0O4fhge9cRU17QVZ8yDs98sp+mMpk24TUtZoLo+600wqqYDx
	jcpk4pmJnWSZN4lmmToP9QfGx/Gy8WOvWOCkfgnEF+v0UT+g/I5ckmQSeFQiyZ5COOrc6TfZeDc
	z6z6qLvfrzmk4yioov0Ij7PjIK4Tj/A+liiz29cVf5y5rxalC+IQ9K8jLam/7vjYuxI7RULkqfy
	8xY4e+aoIIXDF7oRFkUkITtdw8paPaty3j8=
X-Received: by 2002:a17:907:3da3:b0:c2e:7fe7:288e with SMTP id a640c23a62f3a-c2e7fe736eamr411177566b.32.1791194158114;
        Mon, 05 Oct 2026 02:55:58 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31562aba16sm50753266b.23.2026.10.05.02.55.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2026 02:55:57 -0700 (PDT)
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
Subject: [RFC PATCH 3/6] dma-buf: Add ranged mapping invalidation
Date: Mon,  5 Oct 2026 09:55:49 +0000
Message-ID: <20261005095552.52748-4-griffoul@gmail.com>
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

dma_buf_invalidate_mappings() tells every importer that the whole
buffer changed. An exporter that changes one part of its memory cannot
say which bytes changed, so importers throw away mappings that are
still valid.

Add an exporter helper that invalidates a byte range, and an importer
callback that receives it. The callback means that the address, the
attributes or the backing of the range changed. If part of the range is
no longer backed, get_phys() returns -ENOENT for it. Importers must stop
using their old answer before the callback returns. Importers that do
not implement the callback still receive a whole-buffer invalidation.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/dma-buf/dma-buf.c | 30 ++++++++++++++++++++++++++++++
 include/linux/dma-buf.h   | 16 ++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 66b85d53ed22..e7010163eb2f 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1389,6 +1389,36 @@ void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings, "DMA_BUF");
 
+/**
+ * dma_buf_invalidate_mappings_range - notify attachments that a range changed
+ * @dmabuf: buffer whose layout changed
+ * @offset: first changed byte
+ * @length: number of changed bytes
+ *
+ * Importers with a ranged callback stop using their old mappings of the range
+ * before returning. Other importers receive the existing whole-buffer
+ * callback, which is correct but coarser. The reservation lock must be held.
+ */
+void dma_buf_invalidate_mappings_range(struct dma_buf *dmabuf,
+				       unsigned long offset,
+				       unsigned long length)
+{
+	struct dma_buf_attachment *attach;
+
+	dma_resv_assert_held(dmabuf->resv);
+	list_for_each_entry(attach, &dmabuf->attachments, node) {
+		const struct dma_buf_attach_ops *ops = attach->importer_ops;
+
+		if (!ops)
+			continue;
+		if (ops->invalidate_mappings_range)
+			ops->invalidate_mappings_range(attach, offset, length);
+		else if (ops->invalidate_mappings)
+			ops->invalidate_mappings(attach);
+	}
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings_range, "DMA_BUF");
+
 /**
  * dma_buf_get_phys - describe the run that starts at an offset
  * @attach: attachment to query
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index b223962e20c2..55c3fe60a0ba 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -485,6 +485,19 @@ struct dma_buf_attach_ops {
 	 * required behavior.
 	 */
 	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
+
+	/**
+	 * @invalidate_mappings_range: [optional] a byte range changed
+	 *
+	 * The exporter changed the address, attributes or backing of
+	 * [@offset, @offset + @length). The importer must stop using its old
+	 * answer for that range before returning.
+	 * Importers without this callback receive @invalidate_mappings for
+	 * the whole buffer instead.
+	 */
+	void (*invalidate_mappings_range)(struct dma_buf_attachment *attach,
+					  unsigned long offset,
+					  unsigned long length);
 };
 
 /**
@@ -600,6 +613,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
 void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
+void dma_buf_invalidate_mappings_range(struct dma_buf *dma_buf,
+				       unsigned long offset,
+				       unsigned long length);
 bool dma_buf_attach_revocable(struct dma_buf_attachment *attach);
 /* bits 0-7: memory type (a value, not flags) */
 #define DMA_BUF_PHYS_ATTR_TYPE_MASK	GENMASK(7, 0)
-- 
2.47.3

