Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B4729116C
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504064; cv=none; b=PDpAJKyjryiuDbHQ6y+VJ38g3aZOFrIbiSM/yyIkDkZqNjdPc9OPuS4vc1nQw7YrOKvXKy2MPpRrxXH8mhGb/VAWx99rNgKthC26FkUrQstUvPwDHBB79P2fSqEejeGdjkHoog6CH8B7jLHnKu109VXgX10BXZ8dCUyZIPelJh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504064; c=relaxed/simple;
	bh=l8MXGFGw31uuwPrLVCURxj+dBhiUP5Eq/JDGE+Ioyyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aTchR76HhnFxPEQVix0P4olVbiBY6+BI7eyruJd5ShmPt5Gq3a+SfVFL1gDBt3kYQU1ZQ8gYCTb5JSHhMdO7L5CouEgSKps8gpqacU7giDkXZEyFtDCrLg15WX9rThNJRk15h8e+X/DMwHV3Cz/afmp+TqdeFG5eudjdK6/q0a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AIQ3t8GK; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AIQ3t8GK"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a064a3e143so567535f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504060; x=1746108860; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULK/WgQrAoOKgv7yTbnqoplbgLc/ybTV2ol4z7wD4V8=;
        b=AIQ3t8GK783mNJe41oIXrgVn7b7p9NYRENOz3zdQchik0fmweEHKwdaikNQF352f5j
         /XF2LTHyMdl/iInz0y6Bhc/BA3xvxlbDufm01l/mbk1WgbukdQpsH5Yh+1tUH6ehYma3
         wAy+2+vEGaakQiR5pawjclnDUdLXSnZQH9wU1Md+S7wbEWT7nEdCnZ20gDb/8HOH+5qx
         tSxTYh42ZvKJ+Fa+I/G8mi493PuUgMtHa2TY2P/9NE0wWpymMPGKmLgh+ZwFMkiz5pBU
         sDYCL9kRbqOlqDxGTWqAUnsTbJ0JkSZtE82XXmrrBhvFpShZK55QFtRC8EC4Bsbi6WHL
         t/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504060; x=1746108860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULK/WgQrAoOKgv7yTbnqoplbgLc/ybTV2ol4z7wD4V8=;
        b=Htl2WSepUkL35DYMmonBS35IorJ/DHAUDSUdwKsncGVhLu+sa5igSmayK7k7zQG9H2
         6qiTwEkLm2ZPqTs9j17D83BishxwrpZbKM+J3ULw1QLuhNhT+ziOB1MJHTJgnGfdoe/1
         ck5C9VtBUkkU1mBBXmLkj4EBfRMzpOdNKVheM4HcNpvew+o9sN8i9fq+zVlJO+QOcyKw
         tcVi+xWlZnFIpdn4S9SJVYKbTGnr5bEScNv6AGxjhz47Z9F+OXutpPSIA5tC1dbrzzZc
         DD7eFlJJOnqFLQaaZJ983batp5rSgNi7WhttzCt+d2g1xWE9ezej1yTqN2v7jz6pLkAh
         c0AA==
X-Forwarded-Encrypted: i=1; AJvYcCUNx+32ZLvQ5m3dzqmh6k50wKZ7/+uufrptNGswizGRNTjWZQ+AKgUE3UHYrFwQHOxFJvsGO+w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwWrv9PXIihUqZIyX3fzGx37BN33uumtBBqcnRa3cjWdrmnKgO
	IEDxRsoK3Fi3xhCIFrlRdWFd0KenJ6OXqVbuMojZj+M5rwxX85CnxGA2nVJQ2V0=
X-Gm-Gg: ASbGncsc5ZaCbxM0I+JsTiwuEGLScJU9oDBl9sLPTeB8UGz2U8vA9I/nxBCF9YpuGfq
	1dxEl8soc7mK6cuz1gRiGYT44ajzda0HILtr4tcDZgWh5zUbyDV33qAnCg7y6Vvnd+Gsebrp0Ky
	J7mNy46R36am3cjlge/nh2dFtvpMt5lyxR9PjuepTMguUBShsoqDlePlU94/FzMpbV2AZIFRGVX
	ZVL9Ft+lytrTwnsHGYN7mWrtJlCQqEm6ZVS5spbP8DHFlK9fn0yV1rpiuPQfB0BjYQPUWcLvcqI
	x8VWZ+MZqrkPcQ8S3Zm5YwNLzL7fpc7nJl7S9dxJXJ3f/gXLJYhcwFbjf7Ixa60XhUsp7t8O7AR
	WX737v761XQw5S/3o
X-Google-Smtp-Source: AGHT+IFE5/vk9/X0Lu9aLCAdTyRnF+oi4a9Eo+hij9nbvfLjJtzlSBwWD4MqvNxQh/Fi8Qjri674AQ==
X-Received: by 2002:a05:6000:220c:b0:3a0:65bc:3543 with SMTP id ffacd0b85a97d-3a06cf65a2bmr2283431f8f.35.1745504059899;
        Thu, 24 Apr 2025 07:14:19 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:19 -0700 (PDT)
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
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 26/34] gunyah: Share memory parcels
Date: Thu, 24 Apr 2025 15:13:33 +0100
Message-Id: <20250424141341.841734-27-karim.manaouil@linaro.org>
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

Gunyah Resource Manager sets up a virtual machine based on a device
tree which lives in guest memory. Resource manager requires this memory
to be provided as a memory parcel for it to read and manipulate.
Implement a function to construct a memory parcel from the guest's
pinned memory pages.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 80 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 7216db642174..ef0971146b56 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -634,6 +634,86 @@ static int gunyah_memory_reclaim_folio(struct gunyah_vm *ghvm,
 	return ret;
 }
 
+static int gunyah_share_memory_parcel(struct gunyah_vm *ghvm,
+		struct gunyah_rm_mem_parcel *parcel, gfn_t gfn, u64 nr)
+{
+	struct kvm *kvm = &ghvm->kvm;
+	struct kvm_memory_slot *memslot;
+	struct page **pages;
+	int ret;
+	u64 i;
+
+	if (!nr)
+		return -EINVAL;
+
+	memslot = gfn_to_memslot(kvm, gfn);
+	if (!memslot)
+		return -ENOENT;
+
+	parcel->mem_entries = kcalloc(nr, sizeof(*parcel->mem_entries), GFP_KERNEL);
+	if (!parcel->mem_entries)
+		return -ENOMEM;
+	parcel->n_mem_entries = nr;
+
+	pages = memslot->arch.pages + (gfn - memslot->base_gfn);
+
+	for (i = 0; i < nr; i++) {
+		parcel->mem_entries[i].size = cpu_to_le64(PAGE_SIZE);
+		parcel->mem_entries[i].phys_addr = cpu_to_le64(page_to_phys(pages[i]));
+	}
+
+	parcel->n_acl_entries = 1;
+	parcel->acl_entries = kcalloc(parcel->n_acl_entries,
+				      sizeof(*parcel->acl_entries), GFP_KERNEL);
+	if (!parcel->n_acl_entries) {
+		ret = -ENOMEM;
+		goto free_entries;
+	}
+	parcel->acl_entries[0].vmid = cpu_to_le16(ghvm->vmid);
+	parcel->acl_entries[0].perms |= GUNYAH_RM_ACL_R;
+	parcel->acl_entries[0].perms |= GUNYAH_RM_ACL_W;
+	parcel->acl_entries[0].perms |= GUNYAH_RM_ACL_X;
+	parcel->mem_handle = GUNYAH_MEM_HANDLE_INVAL;
+
+	ret = gunyah_rm_mem_share(ghvm->rm, parcel);
+	if (ret)
+		goto free_acl;
+
+	return ret;
+free_acl:
+	kfree(parcel->acl_entries);
+	parcel->acl_entries = NULL;
+free_entries:
+	kfree(parcel->mem_entries);
+	parcel->mem_entries = NULL;
+	parcel->n_mem_entries = 0;
+
+	return ret;
+}
+
+static int gunyah_reclaim_memory_parcel(struct gunyah_vm *ghvm,
+		struct gunyah_rm_mem_parcel *parcel, gfn_t gfn, u64 nr)
+{
+	int ret;
+
+	if (parcel->mem_handle != GUNYAH_MEM_HANDLE_INVAL) {
+		ret = gunyah_rm_mem_reclaim(ghvm->rm, parcel);
+		if (ret) {
+			dev_err(ghvm->parent, "Failed to reclaim parcel: %d\n",
+				ret);
+			/* We can't reclaim the pages -- hold onto the pages
+			 * forever because we don't know what state the memory
+			 * is in
+			 */
+			return ret;
+		}
+		parcel->mem_handle = GUNYAH_MEM_HANDLE_INVAL;
+		kfree(parcel->mem_entries);
+		kfree(parcel->acl_entries);
+	}
+	return 0;
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
-- 
2.39.5

