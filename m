Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A6328F518
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504059; cv=none; b=qKlJCB/kl7fd8jYULxdu8y9wB9+pwk2Z2LSsI38zFqqQeK7mXJBpTm22eYYTsgkIVqJvmX8afgzUXnNbk39MYR2UDCiQHgex1To6nbZIuWjdMYq2ph4POHAsQb7bzVx1fp4Lfva78IxkJffIEKpLOCLldPTJPPg7UhATzSlWzgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504059; c=relaxed/simple;
	bh=5x04Nc6aN+Qwp5pR10UBtd/47cBSvolTTTY6q9NX8X0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CRbweQY0btD1YawLJb/baVKNFrgcCiMcZarPqAzeZ3FQoyWNoR3kEpPCCILqC0Q+HVKJseJ59BwXv1ISNfTgap8bmHFTgRq5lBbm86BzZAGXyt1GIm1C22gSZJU10zIR4209H72mZIVOAESpI2b2h5x1vQtYC4I8dEQoznKnBBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MDIjYUK3; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MDIjYUK3"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39129fc51f8so893270f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504055; x=1746108855; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+5ILmQ9VnpjXFSHOfGNmys0dMzibsKAG6xUYDKquGI=;
        b=MDIjYUK3+4gUnuLsGxMhXEEZIz9Ck0p8rnEzZ9xJgdsFNI+UA4aLrv0+4soq7wTBoV
         ZLyfQEhF0tpx/VvlNANtIDWZSTNgVkQtdlzKtDbW4ApeOk3//pdov42uGUH5tHXTwSaP
         tGEgvV5jZo/NVH9zmavAJ8xk9cnZhlhKDZqvqgglMIgDqmZ0mA4NyF1Ga/SHNJb/xlcI
         E3ULD5B6b9uRt1ub62J/y2xJCsY7A7VpnvMtVDeLRPLUxuG8BCRbAtUr+p8IJSr3YfBt
         CnYqvvhKg5GdOWdNTdqQexGEpAe5m4D1nupjIu/BF4sFV6skxCzEuYdWvQPX9l/uF7Ya
         gXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504055; x=1746108855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2+5ILmQ9VnpjXFSHOfGNmys0dMzibsKAG6xUYDKquGI=;
        b=qWvHNB4wfuwqW0ikI9B9hIGZJ5bDUFgLlUdDyRg69eg0QqRSq6LRPZOhZRICtCMF+A
         JMj9lgEDDFjHzRviVuwxLeMcOffB7m8KRzTUvUhoOXhHKXw0OuKlwhNkH4848SSupmgY
         40e41744k9OFE8dr89ZV03iVv9Rw1sOWqQFly7l6z2Ta1qmqmvGyRDZV1/uQs3Bxpv/2
         XAjc2lNVenmRn5f7xSqcAmmr4rGRLf2z5aQr2KT5IhLLq09q5flEpMLJLj6WLP+0miXD
         WPkCBxWrg7cB30ZxRSYP0YESSvywqeqg7tU7SLLk19fw6mLwhfnZ7sc8RR0478X9hGYn
         pBZw==
X-Forwarded-Encrypted: i=1; AJvYcCXo9npCYj8kKVYSeRR8d1PBxq2M2gflUsnbLXI3PUt6+536yF/nGDGkwiccZZTsNml8oAcnRPU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yys/a/LS/2jtl45yEbGoB1XkWkilzLTJxhgGUWLGWwjoTVO2MNI
	6I2txcW3HsevIFHZ0Bunq6Zr8uFKoJLxQKuaiP6jZXMwNztLEbw64DrMmXo/AC8=
X-Gm-Gg: ASbGncu/xUv5JRGDAhYWJsxLMqTXtDNjtNvMOjh2FM+XNdqpArin36Mk+TRZghiCrE4
	P2CNG1gXDI7LcyenJE0lah9fxXnlW1IfNN3IGy/XdxieF0UHdSOH1+jjSxz6cGTHRkjdOgWkR6/
	CdSDNGNxZCJDgw5qX6RsgrE20YR4y/oq6lGEzEJFr5QvT1F+fou/Ixwi6dlaqSNZfwn/54FT8A4
	VwMIjWWVAzvCUk3jmmdf12kKkWMxpDrooQFIOgGuyAm14IipAompo1FKHDezX49AYP0EBsAsJdU
	l8fjqS2vGaX1PCCRw5KBNJ1ktzhSP+3lOUjSMY/Bnt9ArhiEUA4cHpxv9MMzYNK0ptEQSbtV5b5
	wpacC5cCycAyuww/3YxDZCAx4JCM=
X-Google-Smtp-Source: AGHT+IFKyLoVojvk9QX3IrdV6JaO3B9fcEr46gjxxC0HMPFKU10zHQ1xzS7LtC4gCESH366Qprg02w==
X-Received: by 2002:a5d:64e6:0:b0:39c:dfa:ca71 with SMTP id ffacd0b85a97d-3a06cfab61dmr2330540f8f.49.1745504054653;
        Thu, 24 Apr 2025 07:14:14 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:14 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 22/34] gunyah: Add memory parcel RPC
Date: Thu, 24 Apr 2025 15:13:29 +0100
Message-Id: <20250424141341.841734-23-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

In a Gunyah hypervisor system using the Gunyah Resource Manager, the
"standard" unit of donating, lending and sharing memory is called a
memory parcel (memparcel).  A memparcel is an abstraction used by the
resource manager for securely managing donating, lending and sharing
memory, which may be physically and virtually fragmented, without
dealing directly with physical memory addresses.

Memparcels are created and managed through the RM RPC functions for
lending, sharing and reclaiming memory from VMs.

When creating a new VM the initial VM memory containing the VM image and
the VM's device tree blob must be provided as a memparcel. The memparcel
must be created using the RM RPC for lending and mapping the memory to
the VM.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 drivers/virt/gunyah/rsc_mgr_rpc.c | 204 ++++++++++++++++++++++++++++++
 include/linux/gunyah_rsc_mgr.h    |  50 ++++++++
 2 files changed, 254 insertions(+)

diff --git a/drivers/virt/gunyah/rsc_mgr_rpc.c b/drivers/virt/gunyah/rsc_mgr_rpc.c
index 936592177ddb..0266c2a8d583 100644
--- a/drivers/virt/gunyah/rsc_mgr_rpc.c
+++ b/drivers/virt/gunyah/rsc_mgr_rpc.c
@@ -7,6 +7,12 @@
 #include <linux/error-injection.h>
 #include <linux/gunyah_rsc_mgr.h>
 
+/* Message IDs: Memory Management */
+#define GUNYAH_RM_RPC_MEM_LEND 0x51000012
+#define GUNYAH_RM_RPC_MEM_SHARE 0x51000013
+#define GUNYAH_RM_RPC_MEM_RECLAIM 0x51000015
+#define GUNYAH_RM_RPC_MEM_APPEND 0x51000018
+
 /* Message IDs: VM Management */
 /* clang-format off */
 #define GUNYAH_RM_RPC_VM_ALLOC_VMID		0x56000001
@@ -23,6 +29,49 @@
 #define GUNYAH_RM_RPC_VM_SET_ADDRESS_LAYOUT	0x56000034
 /* clang-format on */
 
+/* Call: MEM_LEND, MEM_SHARE */
+#define GUNYAH_RM_MAX_MEM_ENTRIES 512
+
+#define GUNYAH_MEM_SHARE_REQ_FLAGS_APPEND BIT(1)
+
+struct gunyah_rm_mem_share_req_header {
+	u8 mem_type;
+	u8 _padding0;
+	u8 flags;
+	u8 _padding1;
+	__le32 label;
+} __packed;
+
+struct gunyah_rm_mem_share_req_acl_section {
+	__le16 n_entries;
+	__le16 _padding;
+	struct gunyah_rm_mem_acl_entry entries[];
+} __packed;
+
+struct gunyah_rm_mem_share_req_mem_section {
+	__le16 n_entries;
+	__le16 _padding;
+	struct gunyah_rm_mem_entry entries[];
+} __packed;
+
+/* Call: MEM_RELEASE */
+struct gunyah_rm_mem_release_req {
+	__le32 mem_handle;
+	u8 flags; /* currently not used */
+	u8 _padding0;
+	__le16 _padding1;
+} __packed;
+
+/* Call: MEM_APPEND */
+#define GUNYAH_MEM_APPEND_REQ_FLAGS_END BIT(0)
+
+struct gunyah_rm_mem_append_req_header {
+	__le32 mem_handle;
+	u8 flags;
+	u8 _padding0;
+	__le16 _padding1;
+} __packed;
+
 struct gunyah_rm_vm_common_vmid_req {
 	__le16 vmid;
 	__le16 _padding;
@@ -72,6 +121,161 @@ static int gunyah_rm_common_vmid_call(struct gunyah_rm *rm, u32 message_id,
 			      NULL, NULL);
 }
 
+static int gunyah_rm_mem_append(struct gunyah_rm *rm, u32 mem_handle,
+				struct gunyah_rm_mem_entry *entries,
+				size_t n_entries)
+{
+	struct gunyah_rm_mem_append_req_header *req __free(kfree) = NULL;
+	struct gunyah_rm_mem_share_req_mem_section *mem;
+	int ret = 0;
+	size_t n;
+
+	req = kzalloc(sizeof(*req) + struct_size(mem, entries, GUNYAH_RM_MAX_MEM_ENTRIES),
+		      GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->mem_handle = cpu_to_le32(mem_handle);
+	mem = (void *)(req + 1);
+
+	while (n_entries) {
+		req->flags = 0;
+		if (n_entries > GUNYAH_RM_MAX_MEM_ENTRIES) {
+			n = GUNYAH_RM_MAX_MEM_ENTRIES;
+		} else {
+			req->flags |= GUNYAH_MEM_APPEND_REQ_FLAGS_END;
+			n = n_entries;
+		}
+
+		mem->n_entries = cpu_to_le16(n);
+		memcpy(mem->entries, entries, sizeof(*entries) * n);
+
+		ret = gunyah_rm_call(rm, GUNYAH_RM_RPC_MEM_APPEND, req,
+				     sizeof(*req) + struct_size(mem, entries, n),
+				     NULL, NULL);
+		if (ret)
+			break;
+
+		entries += n;
+		n_entries -= n;
+	}
+
+	return ret;
+}
+
+/**
+ * gunyah_rm_mem_share() - Share memory with other virtual machines.
+ * @rm: Handle to a Gunyah resource manager
+ * @p: Information about the memory to be shared.
+ *
+ * Sharing keeps Linux's access to the memory while the memory parcel is shared.
+ */
+int gunyah_rm_mem_share(struct gunyah_rm *rm, struct gunyah_rm_mem_parcel *p)
+{
+	u32 message_id = p->n_acl_entries == 1 ? GUNYAH_RM_RPC_MEM_LEND :
+						 GUNYAH_RM_RPC_MEM_SHARE;
+	size_t msg_size, initial_mem_entries = p->n_mem_entries, resp_size;
+	struct gunyah_rm_mem_share_req_acl_section *acl;
+	struct gunyah_rm_mem_share_req_mem_section *mem;
+	struct gunyah_rm_mem_share_req_header *req_header;
+	size_t acl_size, mem_size;
+	u32 *attr_section;
+	bool need_append = false;
+	__le32 *resp;
+	void *msg;
+	int ret;
+
+	if (!p->acl_entries || !p->n_acl_entries || !p->mem_entries ||
+	    !p->n_mem_entries || p->n_acl_entries > U8_MAX ||
+	    p->mem_handle != GUNYAH_MEM_HANDLE_INVAL)
+		return -EINVAL;
+
+	if (initial_mem_entries > GUNYAH_RM_MAX_MEM_ENTRIES) {
+		initial_mem_entries = GUNYAH_RM_MAX_MEM_ENTRIES;
+		need_append = true;
+	}
+
+	acl_size = struct_size(acl, entries, p->n_acl_entries);
+	mem_size = struct_size(mem, entries, initial_mem_entries);
+
+	/* The format of the message goes:
+	 * request header
+	 * ACL entries (which VMs get what kind of access to this memory parcel)
+	 * Memory entries (list of memory regions to share)
+	 * Memory attributes (currently unused, we'll hard-code the size to 0)
+	 */
+	msg_size = sizeof(struct gunyah_rm_mem_share_req_header) + acl_size +
+		   mem_size +
+		   sizeof(u32); /* for memory attributes, currently unused */
+
+	msg = kzalloc(msg_size, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	req_header = msg;
+	acl = (void *)req_header + sizeof(*req_header);
+	mem = (void *)acl + acl_size;
+	attr_section = (void *)mem + mem_size;
+
+	req_header->mem_type = p->mem_type;
+	if (need_append)
+		req_header->flags |= GUNYAH_MEM_SHARE_REQ_FLAGS_APPEND;
+	req_header->label = cpu_to_le32(p->label);
+
+	acl->n_entries = cpu_to_le32(p->n_acl_entries);
+	memcpy(acl->entries, p->acl_entries,
+	       flex_array_size(acl, entries, p->n_acl_entries));
+
+	mem->n_entries = cpu_to_le16(initial_mem_entries);
+	memcpy(mem->entries, p->mem_entries,
+	       flex_array_size(mem, entries, initial_mem_entries));
+
+	/* Set n_entries for memory attribute section to 0 */
+	*attr_section = 0;
+
+	ret = gunyah_rm_call(rm, message_id, msg, msg_size, (void **)&resp,
+			     &resp_size);
+	kfree(msg);
+
+	if (ret)
+		return ret;
+
+	p->mem_handle = le32_to_cpu(*resp);
+	kfree(resp);
+
+	if (need_append) {
+		ret = gunyah_rm_mem_append(
+			rm, p->mem_handle, &p->mem_entries[initial_mem_entries],
+			p->n_mem_entries - initial_mem_entries);
+		if (ret) {
+			gunyah_rm_mem_reclaim(rm, p);
+			p->mem_handle = GUNYAH_MEM_HANDLE_INVAL;
+		}
+	}
+
+	return ret;
+}
+ALLOW_ERROR_INJECTION(gunyah_rm_mem_share, ERRNO);
+
+/**
+ * gunyah_rm_mem_reclaim() - Reclaim a memory parcel
+ * @rm: Handle to a Gunyah resource manager
+ * @parcel: Information about the memory to be reclaimed.
+ *
+ * RM maps the associated memory back into the stage-2 page tables of the owner VM.
+ */
+int gunyah_rm_mem_reclaim(struct gunyah_rm *rm,
+			  struct gunyah_rm_mem_parcel *parcel)
+{
+	struct gunyah_rm_mem_release_req req = {
+		.mem_handle = cpu_to_le32(parcel->mem_handle),
+	};
+
+	 return gunyah_rm_call(rm, GUNYAH_RM_RPC_MEM_RECLAIM, &req, sizeof(req),
+			     NULL, NULL);
+}
+ALLOW_ERROR_INJECTION(gunyah_rm_mem_reclaim, ERRNO);
+
 /**
  * gunyah_rm_alloc_vmid() - Allocate a new VM in Gunyah. Returns the VM identifier.
  * @rm: Handle to a Gunyah resource manager
diff --git a/include/linux/gunyah_rsc_mgr.h b/include/linux/gunyah_rsc_mgr.h
index c0fe516d54a8..c42a0cb42ba6 100644
--- a/include/linux/gunyah_rsc_mgr.h
+++ b/include/linux/gunyah_rsc_mgr.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 
 #define GUNYAH_VMID_INVAL U16_MAX
+#define GUNYAH_MEM_HANDLE_INVAL U32_MAX
 
 struct gunyah_rm;
 
@@ -57,6 +58,55 @@ struct gunyah_rm_vm_status_payload {
 	__le16 app_status;
 } __packed;
 
+#define GUNYAH_RM_ACL_X BIT(0)
+#define GUNYAH_RM_ACL_W BIT(1)
+#define GUNYAH_RM_ACL_R BIT(2)
+
+struct gunyah_rm_mem_acl_entry {
+	__le16 vmid;
+	u8 perms;
+	u8 reserved;
+} __packed;
+
+struct gunyah_rm_mem_entry {
+	__le64 phys_addr;
+	__le64 size;
+} __packed;
+
+enum gunyah_rm_mem_type {
+	GUNYAH_RM_MEM_TYPE_NORMAL = 0,
+	GUNYAH_RM_MEM_TYPE_IO = 1,
+};
+
+/*
+ * struct gunyah_rm_mem_parcel - Info about memory to be lent/shared/donated/reclaimed
+ * @mem_type: The type of memory: normal (DDR) or IO
+ * @label: An client-specified identifier which can be used by the other VMs to identify the purpose
+ *         of the memory parcel.
+ * @n_acl_entries: Count of the number of entries in the @acl_entries array.
+ * @acl_entries: An array of access control entries. Each entry specifies a VM and what access
+ *               is allowed for the memory parcel.
+ * @n_mem_entries: Count of the number of entries in the @mem_entries array.
+ * @mem_entries: An array of regions to be associated with the memory parcel. Addresses should be
+ *               (intermediate) physical addresses from Linux's perspective.
+ * @mem_handle: On success, filled with memory handle that RM allocates for this memory parcel
+ */
+struct gunyah_rm_mem_parcel {
+	enum gunyah_rm_mem_type mem_type;
+	u32 label;
+	size_t n_acl_entries;
+	struct gunyah_rm_mem_acl_entry *acl_entries;
+	size_t n_mem_entries;
+	struct gunyah_rm_mem_entry *mem_entries;
+	u32 mem_handle;
+};
+
+/* RPC Calls */
+int gunyah_rm_mem_share(struct gunyah_rm *rm,
+			struct gunyah_rm_mem_parcel *parcel);
+int gunyah_rm_mem_reclaim(struct gunyah_rm *rm,
+			  struct gunyah_rm_mem_parcel *parcel);
+
 int gunyah_rm_alloc_vmid(struct gunyah_rm *rm, u16 vmid);
 int gunyah_rm_dealloc_vmid(struct gunyah_rm *rm, u16 vmid);
 int gunyah_rm_vm_reset(struct gunyah_rm *rm, u16 vmid);
-- 
2.39.5

