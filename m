Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1963EFD37
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814891; cv=none; b=gYnb88TU36jz46HBoF1S8hMkASiRDl34OrMSY7CFnGu3/KEsCSdhGXaLQRUFOvXvA+zDn0jfiFFFiqivZpXN5N6tGvoP9OcfkGJzC62sWmAsmjUPA0lwvpzMk7nWH9qhEJ59cP+/hMKNEWttj7Sw94vW1kryQLm3PIc243qNb8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814891; c=relaxed/simple;
	bh=gSAanya4JdlbcJVPzlLFyt71ySjRkBo8hJyqogn8+Oo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k3H3/H/O49M9XzG3MSdUsXY3QDFCSZT93iPgJtgWfbuyQr6jwB0eqYUud0YWlH9THpzpycQZvjyLNVx1Txfl9OAc8iQplv8MhiDcyaxo6K5zDjN8QyVCFxY2watA2uyQ6VIQJM5rcXMY/7zdu86hDZa292lk3Y66Xfja8hyI+gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GFaPu+Lj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GFaPu+Lj"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49243626f15so44797755e9.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 03:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782814887; x=1783419687; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S2U/VeegX6zkq+FfETCymx32V7rN5pCpIXqjl6Jjj74=;
        b=GFaPu+Ljo/50wTe+e/WF5jOx03idJRDONKJIO11ZsIdtpmBlI/wDBz5RpVlNuIl4nG
         p875B16g/eF5VjDugisxE6pb24CgVxRkSbSd9+DniERxQ14RrzeqOOKhX/7CejZrf2PY
         myAhW99Kg/+bPT991mQFAxVFbBPlqJh+JD4aQxsifddoutOIwdMP/ixEN2FBGfi8j4Sl
         OB/EN0sGvKqdYYUlK+wb3D9PtPaRTybduKI09oy+W5YaZfnZvhRs7qQBGtTvfzsnfLgr
         RoyNhjWu/aKYWyHfAjlcUO+sms1BY3nGTnJ9E1RVLG+0H2BMBvyP0I/XOz2qJ48eItWo
         rqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782814887; x=1783419687;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S2U/VeegX6zkq+FfETCymx32V7rN5pCpIXqjl6Jjj74=;
        b=V5c7rVMP2DIhrw/53bWzKuSX2rwY3BkXUnHBnqr4VdDLImylQvKhJbRZ28Ojd4WGqF
         QiJuy0zr6dzPpWqe9ZD7T057Srallk7LmQtSHhKZf7BNKKOtQ9f4xO3F63r75MqxnHV8
         SFb25ukrsAThyHanCKU1TYljFcs0/kRJynynPllDRPlqA/rmDg0bji22QULGjWOCoHDI
         H3fRH3JBUgBDJgXvvwWVYc0Q/F2t02M615esq5jAn/Ch5ajdWvStTRl7B1yb31uGEzyH
         aPHZVMyYJZ10rJLYKqH9u76NnmBglGJ/WWv6Ya7mEjukn4NUadv6dJh8GsGxTbYAy0my
         blgQ==
X-Forwarded-Encrypted: i=1; AFNElJ/TneZDm4aG+P3H+duCAKxL6h4YO7FT5Ma8h0XLGl9lC1oerC6+1bdeswo3krM8izDN7BzIsDw=@lists.linux.dev
X-Gm-Message-State: AOJu0YywbcvJ74XQx8X9KHg57ruz54X6YrfyZeCp+7zwLOJOfP1YbEUo
	KT5CO4fO6yohMaE54dZFk7pRULN8U3b0DN/lsHUcQLWWI6FF0hEhsefT5mWq8jB0IYBpm6DImWX
	R1ZKM+dzUFw08YMJsfm36cQ4cd8yHdQ==
X-Received: from wmrc3.prod.google.com ([2002:a05:600c:ac3:b0:492:4e77:8950])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:b96:b0:490:acb8:1490 with SMTP id 5b1f17b1804b1-493b827fd1emr41693135e9.4.1782814887055;
 Tue, 30 Jun 2026 03:21:27 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:20:57 +0000
In-Reply-To: <20260630102058.3219867-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260630102058.3219867-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260630102058.3219867-6-sebastianene@google.com>
Subject: [PATCH v8 4/6] KVM: arm64: Validate the offset to the mem access descriptor
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, 
	will@kernel.org
Cc: jens.wiklander@linaro.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com, 
	op-tee@lists.trustedfirmware.org, perlarsen@google.com, 
	sebastianene@google.com, seiden@linux.ibm.com, smostafa@google.com, 
	sumit.garg@kernel.org, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Prevent the pKVM hypervisor from making assumptions that the
endpoint memory access descriptor (EMAD) comes right after the
FF-A memory region header.
Prior to FF-A version 1.1 the header of the memory region
didn't contain an offset to the endpoint memory access descriptor.
The layout of a memory transaction looks like this from 1.1 onward:
Type | Field name | Offset
[ Header | ffa_mem_region  | 0
  EMAD 1 | ffa_mem_region_attributes) | ffa_mem_region.ep_mem_offset
]
Verify that the offset to the first endpoint memory access descriptor
is within the mailbox buffer bounds.

Also, fix one hardcoded sizeof(struct ffa_mem_region_attributes) that
should be replaced ffa_emad_size_get() for compatibility with FFA v1.0.

Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 27 +++++++++++++++++++--------
 include/linux/arm_ffa.h       |  7 +++++++
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 2d211661952e..14aa37846059 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -476,11 +476,12 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	DECLARE_REG(u32, fraglen, ctxt, 2);
 	DECLARE_REG(u64, addr_mbz, ctxt, 3);
 	DECLARE_REG(u32, npages_mbz, ctxt, 4);
+	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges, checked_offset;
 	int ret = 0;
+	size_t mem_region_len = FFA_MEM_REGION_SZ(hyp_ffa_version);
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
@@ -488,8 +489,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 		goto out;
 	}
 
-	if (fraglen < sizeof(struct ffa_mem_region) +
-		      sizeof(struct ffa_mem_region_attributes)) {
+	if (fraglen < mem_region_len + ffa_emad_size_get(hyp_ffa_version)) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out;
 	}
@@ -508,8 +508,13 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
-	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	ep_mem_access = (void *)buf + em_mem_access_off;
 	offset = ep_mem_access->composite_off;
 	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -574,9 +579,9 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, handle_lo, ctxt, 1);
 	DECLARE_REG(u32, handle_hi, ctxt, 2);
 	DECLARE_REG(u32, flags, ctxt, 3);
+	u32 offset, len, fraglen, fragoff, em_mem_access_off;
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
-	u32 offset, len, fraglen, fragoff;
 	struct ffa_mem_region *buf;
 	int ret = 0;
 	u64 handle;
@@ -599,8 +604,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	len = res->a1;
 	fraglen = res->a2;
 
-	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		ffa_rx_release(res);
+		goto out_unlock;
+	}
+
+	ep_mem_access = (void *)buf + em_mem_access_off;
 	offset = ep_mem_access->composite_off;
 	/*
 	 * We can trust the SPMD to get this right, but let's at least
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 033c630b271b..e71d83ee0aef 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -421,6 +421,13 @@ struct ffa_mem_region {
 #define FFA_EMAD_HAS_IMPDEF_FIELD(version)	((version) >= FFA_VERSION_1_2)
 #define FFA_MEM_REGION_HAS_EP_MEM_OFFSET(version) ((version) > FFA_VERSION_1_0)
 
+/* The layout changed from FFA_VERSION_1_0 and the region includes an
+ * ep_mem_offset.
+ */
+#define FFA_MEM_REGION_SZ(version)		(!FFA_MEM_REGION_HAS_EP_MEM_OFFSET((version)) ?\
+						 offsetof(struct ffa_mem_region, ep_mem_offset) :\
+						 sizeof(struct ffa_mem_region))
+
 static inline u32 ffa_emad_size_get(u32 ffa_version)
 {
 	u32 sz;
-- 
2.55.0.rc0.799.gd6f94ed593-goog

