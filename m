Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEF4294A02
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504069; cv=none; b=JWb+5gBNmiQnloGsgn5lalDEY07bymZ7F124Eyp9VDZ5uJEboHFG2sFCPBXIvzqGlmAd6SEynXOwGrXZKHmlqk9EnFjQw+LJnM7tqgoZwOuoige2Uc1VjLquO9GgkogI7L8kvNu9QffWZUrUpJONEqIytscCtTx+QB2DA6Sq54g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504069; c=relaxed/simple;
	bh=KiBOPw2VoeUP9jPtQen3QJ8+JIhOTaUQt1mQ67vK+Wk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GGL9LHXg9+HR5h6753XVg+drvr3VT4BYcKujWGdg8GzV2oNY+fe3H2ak+U/ED0hnsD2cD3e/snvMOOyCmBBX3sXqPJ36Tfn8bmF5OfLPW6jLE+UI4+5BvIZtZ+OEzcZalCAklZnUVdUrnNQAKHeqU5h3UnTf1iHbCGkzdj5Tn50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p9A1VO2q; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p9A1VO2q"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3914bc3e01aso682904f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504065; x=1746108865; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fkw6jo/oeFh6qnWXDp6jlBdNEq901uF/wqE5/ZMg0xQ=;
        b=p9A1VO2qDyvpAcI+LMnWz6TZV/UFWQsjHfyhL3KkyjH4jsUdr3xGSLXYgkpClz48gj
         0zxOJeUhjaoMSDUDX6ThMtC3cTzYSkIo4dJj8YmbqyEuA4MC6Dj7bC3JtkXHXDvcm+3f
         RkZoW+s2Ib5Fwyuy3NKJcIxOq45P5bdkX5CMmOSVRQIdKmVvPhsa4khfpm5itykWeXu1
         auAvXclGEJx1PoZv81G1UuyVa/atV742XJjgk3Qc9vJSvlV6CD/+daGeDPvxsjk4PYrm
         YIbt6BHDAqUK9caT4skn97vCnFzoXGgnJxL5kv1O4ksdBvA1iA8p3ESZQorr0T1hZfup
         djgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504065; x=1746108865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fkw6jo/oeFh6qnWXDp6jlBdNEq901uF/wqE5/ZMg0xQ=;
        b=OordNrGf5KIDe5lqT7s6R73GO7ERQ1/b1unYVCx7ZVrcw1Yezxtz5Q3TepfLu1Ejm1
         Rnxh6lHyEVayxUlcVGA43rsj4mEaZBXjeMVLwDBXZF0r5SDBwkdHhK/Tou+xtEMNfqHU
         xbX/oWR8zqT3sv5ypdsRfr2lNaw2rdrnE+bQRrqTRkLlmTddf1G6WFWMV8KABpUPLPl1
         qjFW+Ab/8TpohuiB73cKN1vJGK+rt/uQNNyu2nc9VtRuPfPPuWJGPuhgIChAsLdxnCWp
         YWPF2XmwPFSLp2ABn5/eNtMTSXe4QhhutMJ1aVV1uchRFcHD8yCPm4ZC/BxrLONz+jnZ
         1X0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUYw0qP8CWxpRkh6GUi943mjeuIE9+VGu+Dhu0S6RKNv4BdWUmdDe73P+obpHRtEDDT/SKdFC0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1c6z+dQgmREHARi1Ztmdug4+6jS7MvuyoznldzRKBMmB3ij1U
	yYQy+PAXLCMyqyLGgVDsXi/y5GzPTn0c9TIgnjrFoyHUhOivt0R6PkIA1a2qxGU=
X-Gm-Gg: ASbGncsqCmxH09ixPw1aT+c2H4O5v6eyOCt2xwhJ8pAwhsn+ry4uhl5nSIYMwjKIwUU
	Snrr3iuMHKJq8t+IACtVNBB0sGvKBjJHWdch0idsHhCQxs8nwrcHfc8J0xPTuzt7UC2q+hbxb+9
	mb8Xwheb83p73ElpeRVnp5YqTQdWT9zHbhBvjFYyWEDCbGV8yu9MXBXMYWBUxBmTGyB9Bx4muhE
	D4sOYGma0I3+PzAiVXJRHrEHhGMDLzFXyO2LLiAnUL2DHinXeG7RIfg6wmyWCAXyAGj9JWb+nhy
	rL2LqysDPil+Q4lXmP3/EOxF9kltyAE1SvwHRIsEU4CHU7Z2v39/bbOnoRnzWiWXmFPmFKuh6fv
	XL3EEiaTEKyJZsB5U
X-Google-Smtp-Source: AGHT+IELqmSvaP6OfocDnjzMS7mUki3w51itbTq+w393mXtO1Vl290MnI9dSMs1K0cj071gNYf3OVQ==
X-Received: by 2002:a5d:6da2:0:b0:39e:cc0c:9789 with SMTP id ffacd0b85a97d-3a06cf4f2f6mr2251923f8f.11.1745504065280;
        Thu, 24 Apr 2025 07:14:25 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:24 -0700 (PDT)
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
Subject: [RFC PATCH 30/34] gunyah: Add RPC to set VM boot context
Date: Thu, 24 Apr 2025 15:13:37 +0100
Message-Id: <20250424141341.841734-31-karim.manaouil@linaro.org>
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

The initial context of a the primary vCPU can be initialized by
performing RM RPC calls.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 drivers/virt/gunyah/rsc_mgr_rpc.c | 32 +++++++++++++++++++++++++++++++
 include/linux/gunyah_rsc_mgr.h    |  2 ++
 2 files changed, 34 insertions(+)

diff --git a/drivers/virt/gunyah/rsc_mgr_rpc.c b/drivers/virt/gunyah/rsc_mgr_rpc.c
index 7fccd871cc0b..78c4d1d5d42a 100644
--- a/drivers/virt/gunyah/rsc_mgr_rpc.c
+++ b/drivers/virt/gunyah/rsc_mgr_rpc.c
@@ -106,6 +106,15 @@ struct gunyah_rm_vm_config_image_req {
 	__le64 dtb_size;
 } __packed;
 
+/* Call: VM_SET_BOOT_CONTEXT */
+struct gunyah_rm_vm_set_boot_context_req {
+	__le16 vmid;
+	u8 reg_set;
+	u8 reg_index;
+	__le32 _padding;
+	__le64 value;
+} __packed;
+
 /* Call: VM_SET_DEMAND_PAGING */
 struct gunyah_rm_vm_set_demand_paging_req {
 	__le16 vmid;
@@ -447,6 +456,29 @@ int gunyah_rm_vm_init(struct gunyah_rm *rm, u16 vmid)
 }
 ALLOW_ERROR_INJECTION(gunyah_rm_vm_init, ERRNO);
 
+/**
+ * gunyah_rm_vm_set_boot_context() - set the initial boot context of the primary vCPU
+ * @rm: Handle to a Gunyah resource manager
+ * @vmid: VM identifier
+ * @reg_set: See &enum gunyah_vm_boot_context_reg
+ * @reg_index: Which register to set; must be 0 for REG_SET_PC
+ * @value: Value to set in the register
+ */
+int gunyah_rm_vm_set_boot_context(struct gunyah_rm *rm, u16 vmid, u8 reg_set,
+				  u8 reg_index, u64 value)
+{
+	struct gunyah_rm_vm_set_boot_context_req req_payload = {
+		.vmid = cpu_to_le16(vmid),
+		.reg_set = reg_set,
+		.reg_index = reg_index,
+		.value = cpu_to_le64(value),
+	};
+
+	return gunyah_rm_call(rm, GUNYAH_RM_RPC_VM_SET_BOOT_CONTEXT,
+			      &req_payload, sizeof(req_payload), NULL, NULL);
+}
+ALLOW_ERROR_INJECTION(gunyah_rm_vm_set_boot_context, ERRNO);
+
 /**
  * gunyah_rm_get_hyp_resources() - Retrieve hypervisor resources (capabilities) associated with a VM
  * @rm: Handle to a Gunyah resource manager
diff --git a/include/linux/gunyah_rsc_mgr.h b/include/linux/gunyah_rsc_mgr.h
index f16e64af9273..6a07fe25b0ba 100644
--- a/include/linux/gunyah_rsc_mgr.h
+++ b/include/linux/gunyah_rsc_mgr.h
@@ -126,6 +126,8 @@ int gunyah_rm_vm_configure(struct gunyah_rm *rm, u16 vmid,
 			   u32 mem_handle, u64 image_offset, u64 image_size,
 			   u64 dtb_offset, u64 dtb_size);
 int gunyah_rm_vm_init(struct gunyah_rm *rm, u16 vmid);
+int gunyah_rm_vm_set_boot_context(struct gunyah_rm *rm, u16 vmid, u8 reg_set,
+				  u8 reg_index, u64 value);
 
 struct gunyah_rm_hyp_resource {
 	u8 type;
-- 
2.39.5

