Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607D231327F
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808795; cv=none; b=Oq2gwOAsOVDP5DOThhFpwhh6uTmeK7d2AFC7uj3URK90APwsDVv12k5HC8+rPPpsjDyQ2TpGCNUfZIeemLpTlkJB6eEgDq0ZI/n+UTJkp99VWjd+JBrUrkhRAfwvGFKZdr+fr2MqFIszNGyVVa9Mnfx8nom9QRe4JYEpl3BBNKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808795; c=relaxed/simple;
	bh=cWAWGazl9y0NCQE6boUFtmipRD653SY/f3mBGb2AlJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BS7Zrdrc1lyDDX3lswRiHWItineEBCgmPc+tpQtzhx0dZxyKeTrIrfYXcY3JZgyvyk5m4l4uR2WBKP7/+4kQt7CpMkL+z1KYZX1mAUWKQ26A2xM8TOYm2vPjWiaGGevtyY1x7wdWzDULDcv3T06pMy3tVM+3le2TVPOAUllewr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fKnvs3t+; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKnvs3t+"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fdad6cce4so51864695e9.1
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 08:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779808792; x=1780413592; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e46ed4u5Cv0I3gq+GXl599KXwFIbkYlwQRCW4+ScRKU=;
        b=fKnvs3t+NcJo4kfeTCw+2Xzd4pIpVdQNvVZgWpLX33WszQsIOD1DrxOpLdKsaoEAkM
         y41775mjIoiqhaz7kXgfYBghmZhkv0SWMvfT6W7bEo+679rlcLVKbQjUIx2gUX93AHBs
         FUuMvHEkoyBOxW9CIJ17ASQvRDoBtRlK4JIsX3CjiUiFMcggddyPOzfD/ss9JLRjHpj6
         XQ1Lg6/wAyhl8vIZPUDZoHrs+i3lMVYa1ZekKQAYmhbbU+1eYL/Q3YuAjEJtYDhN2VTD
         MTEwULjeUaQevRiYtapZ5ObjTUfS5eFphqCKOfoM8bl704Xjlb7T0/OtPnOFlWbK3JxH
         8KjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808792; x=1780413592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e46ed4u5Cv0I3gq+GXl599KXwFIbkYlwQRCW4+ScRKU=;
        b=Gf6sulrn87N4O9OYbXhr15E1UDzuohEjjBMDc6eYHckie7d3cbZnnqnBelmpEPL5Sg
         AnjAq1M697zwB59DTvrT3XZ+kv+kgKSCq7g4qmNP2J/qEvXc5TWWCUKfOR2ntc/QyP7A
         jn43RI+qtRUu22iOH5TI2T2mtOSgXgUn4Ei/ESYFrvzojoGHg3ZjPMDgiZacJp87cWZK
         UfMEkGpeSLIoiIg4RxahopBF9RZWiaAJCLEywKVK2eMU3I+cyRddYxUYnuK3vZnMRJs6
         nu3ylEP9DRQSvth4Iwh6q9jlMOmvn2IcZqrYjgJeViwYXKvWRTeXT0F6Y95J0OZsFYS7
         jvmg==
X-Forwarded-Encrypted: i=1; AFNElJ8pSzKSHjIII1i0ZLZBAhGAcDD6TJ8n0zw0pP8br/M5DDg/A1UPdatn1esGTvFVqVIT9IJpCeA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqlAC5vxrxoyPd/0dnELkorlKZuhW25+UGrUc3iGqszwXWZjf0
	LmyCFUB7ILdYwAk5xtzZOdTQ1RThCLJMRHIN5rLiXXonEARj2zcWr+ok9kh89D66EbNt5nCuueo
	s03EhxedA1IxCgA==
X-Received: from wrpj7.prod.google.com ([2002:adf:f547:0:b0:45e:75ad:a480])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5681:b0:486:fcc7:6811 with SMTP id 5b1f17b1804b1-49035f53c64mr252846105e9.10.1779808791592;
 Tue, 26 May 2026 08:19:51 -0700 (PDT)
Date: Tue, 26 May 2026 15:19:33 +0000
In-Reply-To: <20260526151934.3783707-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260526151934.3783707-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260526151934.3783707-6-smostafa@google.com>
Subject: [PATCH v5 5/6] KVM: arm64: Validate the offset to the mem access descriptor
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Sebastian Ene <sebastianene@google.com>

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

[@Mostafa, Add missing call to ffa_rx_release() and use fraglen
 as the max buffer size as it is the only intialised part]

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index b6cf9ad82e12..79de358333e4 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -479,7 +479,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges, checked_offset;
+	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
 	int ret = 0;
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
@@ -489,7 +489,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	}
 
 	if (fraglen < sizeof(struct ffa_mem_region) +
-		      sizeof(struct ffa_mem_region_attributes)) {
+		      ffa_emad_size_get(hyp_ffa_version)) {
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
@@ -576,7 +581,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, flags, ctxt, 3);
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
-	u32 offset, len, fraglen, fragoff;
+	u32 offset, len, fraglen, fragoff, em_mem_access_off;
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
-- 
2.54.0.746.g67dd491aae-goog

