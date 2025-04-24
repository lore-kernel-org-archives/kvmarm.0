Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4480D2918DD
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504065; cv=none; b=s3zBNlTz+Mb3TyuwkVvRyUcmRxQCt/NSnp4bVkejeurvh0UMY8unmqlwrZkPguKcsMC32XiZksGRwfL+FNNtQNoJCJF3rgjzqMeUVH4bUZirhEPUS/uEApxgb/oHTvAg7PqA4sq59vYGCY/kYLaN2qAANq+6NNK6ZW5LHp1jmyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504065; c=relaxed/simple;
	bh=Yi4ZtnxtwEwwcGq5Pu3T2/cALo63bY4y5tVWXmp+Y3c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PBoztBjFQBQHBl4eQ0HWD1/Qqj5sxe8aENvbor6JPAUZ4vZSOV6gMItxgwP9q4O0ZsGclzAb6c3K5/uIc80MvksUARhSyjVwwrmlVo4gn3gb3sgf0iZ+bDF01GvEnmpeAhYRdz+BfZa+LPj8P/m0r5BrYZmTyDz+IjvrJB5b2oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u+v1Th5S; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u+v1Th5S"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39c13fa05ebso735653f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504061; x=1746108861; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqI809F7wKcnGZMELURBH0WwNUVNARNAdRqZ1Gwku8c=;
        b=u+v1Th5SYZK9LEu6z1TstVNL5EpViyqCXgv6VSsR53LSWKSXeQAFj3iW6Yh0HxXd7j
         G9PhV/K/dmCMpSJS/q2V0G16bi+fYGgoN1ZjMYZ8c5J7Fv0URGtjvE/peLouHlmphaUq
         ooxv2su9IRqNhA0ySvmJYtuM6H94+5T81K25wuZMk/qc7IoloP1zt+DWoRYJs6EFhc3y
         E3eWULsgjjnLVPr+cKMFbVm8DnVFjR/aqrpyzpKOyjMp8NWbBaQYqW16mekLPlOkG8rY
         VME042LAAy5JQnC+c4ttfbfzI/33LcBl1YLobflSw3wYyi06JPGx29fuMKiq/Kh7fsPT
         oX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504061; x=1746108861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KqI809F7wKcnGZMELURBH0WwNUVNARNAdRqZ1Gwku8c=;
        b=b9Lp61LCbPLGmJo4+CpW7uq+y5ilAOXQSYfPzakPf/DkJmbcLZQC2VfpppFxctf26y
         l8Vp+La56HBJyzjDui/KPFtunLmv62oK0ZGsIkBTDqO2H8HDINDCIwLePL2fmhznKx8J
         EmCZGljQAe7/EHrPVm+RiyVqN67DtdRlflvWv7MtDs0lA6uqkfhQDgzqW+Mvw5PWSIs+
         l99QzipEvV10Et9CC4//YAiVWWeI4faH2XXyOvLVN8X7O0kpeQx6trTMCh9RXB1ITSV1
         Ja1rF9iqBGSHmc8HMEm6BmHMRjRNI/pTJOPcfR7kpjZGqumwRolw3ocbd/iaDApStev6
         FB7w==
X-Forwarded-Encrypted: i=1; AJvYcCUFefwoYAR0jSoiqXoCpKCe/9IaGLDc93QBMAxyBb4ADTvysnY2gwHIAtGnOTIelnE9+duEBxs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxH95be4eWwrZZY3c9WIYSWUKi23URQjAqosSDZP6AI0r1Qyfrh
	SNqSZgvG+Omp/YtJsnbI2nRo5dhrftut5mKzVtkOb3OatU/ysA3alpcF8H3YUhI=
X-Gm-Gg: ASbGnctX2bU4gdUgRFS0cc/0wKuEZibLHX0bI0StR95MTABHeTWfgLnBZg2FeOVCG7x
	XlNjVTF24NjwJp793gS3ftEFWDnNsxqWsH8kVsyRuogLmO5inpd7fHgDJChgBWdjU7h0cQmhsV6
	Ad+7f7lDLZNY11jBnicRGu5V9lnZ2Y5R2C4px4AqjMcPB7UUIpcFVCEU1wxWMaYI7I3sw3aWCQV
	3xU5E2LShTGFA2W9g0ha0RjTXHdz843Ue1Jf7dTvvMbrCSqB7XlU4TOOHd1B7twAcU3iZMMbopg
	HmTHXOhrVEn7Iy1BO5cTw/1eBUHfGCAMWp3JLNkV4cfrQYN2Sb2xZphsPREh37uAyX55X2R0XjK
	EKKLdJHJLs7ADysXN
X-Google-Smtp-Source: AGHT+IHu0xINB3AI0ORmGPEOw/RldxQp1Lf0CLnYLBWHSDl9/V/LyKw8BRQRYMCgyV0pnZHvllr1jA==
X-Received: by 2002:a5d:584e:0:b0:39a:c9ac:cd3a with SMTP id ffacd0b85a97d-3a06cfa9c91mr2435184f8f.51.1745504061234;
        Thu, 24 Apr 2025 07:14:21 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:20 -0700 (PDT)
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
Subject: [RFC PATCH 27/34] gunyah: Share guest VM dtb configuration to Gunyah
Date: Thu, 24 Apr 2025 15:13:34 +0100
Message-Id: <20250424141341.841734-28-karim.manaouil@linaro.org>
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

Gunyah Resource Manager sets up a virtual machine based on a device tree
which lives in guest memory. Resource manager requires this memory to be
provided as a memory parcel for it to read and manipulate. Construct a
memory parcel, lend it to the virtual machine, and inform resource
manager about the device tree location (the memory parcel ID and offset
into the memory parcel).

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 27 ++++++++++++++++++++++++---
 include/linux/gunyah.h  | 10 ++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index ef0971146b56..687f2beea4e7 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -699,8 +699,7 @@ static int gunyah_reclaim_memory_parcel(struct gunyah_vm *ghvm,
 	if (parcel->mem_handle != GUNYAH_MEM_HANDLE_INVAL) {
 		ret = gunyah_rm_mem_reclaim(ghvm->rm, parcel);
 		if (ret) {
-			dev_err(ghvm->parent, "Failed to reclaim parcel: %d\n",
-				ret);
+			pr_err("Failed to reclaim parcel: %d\n", ret);
 			/* We can't reclaim the pages -- hold onto the pages
 			 * forever because we don't know what state the memory
 			 * is in
@@ -1574,6 +1573,7 @@ static void gunyah_vm_stop(struct gunyah_vm *ghvm)
 
 static int gunyah_vm_start(struct gunyah_vm *ghvm)
 {
+	struct kvm *kvm = &ghvm->kvm;
 	struct gunyah_rm_hyp_resources *resources;
 	struct gunyah_resource *ghrsc;
 	int i, n, ret;
@@ -1597,7 +1597,18 @@ static int gunyah_vm_start(struct gunyah_vm *ghvm)
 	ghvm->vmid = ret;
 	ghvm->vm_status = GUNYAH_RM_VM_STATUS_LOAD;
 
-	ret = gunyah_rm_vm_configure(ghvm->rm, ghvm->vmid, ghvm->auth, 0, 0, 0, 0, 0);
+	ghvm->dtb.parcel_start = gpa_to_gfn(kvm->dtb.guest_phys_addr);
+	ghvm->dtb.parcel_pages = gpa_to_gfn(kvm->dtb.size);
+	ret = gunyah_share_memory_parcel(ghvm, &ghvm->dtb.parcel,
+					 ghvm->dtb.parcel_start,
+					 ghvm->dtb.parcel_pages);
+	if (ret) {
+		pr_warn("Failed to allocate parcel for DTB: %d\n", ret);
+		goto err;
+	}
+
+	ret = gunyah_rm_vm_configure(ghvm->rm, ghvm->vmid, ghvm->auth,
+			ghvm->dtb.parcel.mem_handle, 0, 0, 0, kvm->dtb.size);
 	if (ret) {
 		pr_warn("Failed to configure VM: %d\n", ret);
 		goto err;
@@ -1698,6 +1709,16 @@ static void gunyah_destroy_vm(struct gunyah_vm *ghvm)
 	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_RUNNING)
 		gunyah_vm_stop(ghvm);
 
+	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_LOAD ||
+	    ghvm->vm_status == GUNYAH_RM_VM_STATUS_READY ||
+	    ghvm->vm_status == GUNYAH_RM_VM_STATUS_INIT_FAILED) {
+		ret = gunyah_reclaim_memory_parcel(ghvm, &ghvm->dtb.parcel,
+						 ghvm->dtb.parcel_start,
+						 ghvm->dtb.parcel_pages);
+		if (ret)
+			pr_err("Failed to reclaim DTB parcel: %d\n", ret);
+	}
+
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->addrspace_ticket);
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_shared_extent_ticket);
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_private_extent_ticket);
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 1d363ab8967a..72aafc813664 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -94,6 +94,12 @@ struct gunyah_vm_resource_ticket {
  * @resource_tickets: List of &struct gunyah_vm_resource_ticket
  * @auth: Authentication mechanism to be used by resource manager when
  *        launching the VM
+ * @dtb: For tracking dtb configuration when launching the VM
+ * @dtb.parcel_start: Guest frame number where the memory parcel that we lent to
+ *                    VM (DTB could start in middle of folio; we lend entire
+ *                    folio; parcel_start is start of the folio)
+ * @dtb.parcel_pages: Number of pages lent for the memory parcel
+ * @dtb.parcel: Data for resource manager to lend the parcel
  */
 struct gunyah_vm {
 	u16 vmid;
@@ -113,6 +119,10 @@ struct gunyah_vm {
 	struct gunyah_vm_resource_ticket host_shared_extent_ticket;
 	struct gunyah_vm_resource_ticket guest_private_extent_ticket;
 	struct gunyah_vm_resource_ticket guest_shared_extent_ticket;
+	struct {
+		gfn_t parcel_start, parcel_pages;
+		struct gunyah_rm_mem_parcel parcel;
+	} dtb;
 };
 
 /**
-- 
2.39.5

