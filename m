Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0298F377553
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 20:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310201; cv=none; b=eHH3rHVG06R1VHIeFuDit5rnDAYoWFE6VcKC4+ZAsOBtctrhIhqGuSAcsfrhZvaYTWycW+3V3WXonxiWkGDZ70ZIHNNufvMef6pePM/AgroqTzlEDQX9vpIpuOwhCIpCrjWFAuaKE0tMPgTHQ+WXCWwNebyFQQegxfCb7Mapw+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310201; c=relaxed/simple;
	bh=tuPvZGzF0btmcEj/P7IKTetF6rM2heeP6hTxQ5GodVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mg/srPyBON2YqoO+wr2LCCfxWiWdaSHnZxGWv4Lr+unqx2YJluT/Z+RX6vSeRQAk/uNtMtccYpA6q4BWDNtEV79IctsOiKMbNo/l01MWajJEAy/P5u/jtqN8nEI5jyMKCIbv6WIr/ZlNCVe6H1ewHCZjNGOjEaV3PtO60eGi1Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m3J5IPbQ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m3J5IPbQ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48feb0298d7so42054235e9.1
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 13:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779310198; x=1779914998; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bdxg0o2btss9qMTZzYA98i+uvFmpv+cRF90VMWdHIeA=;
        b=m3J5IPbQo+ycSX2FMv/gfT4H93zNQejwBIDGHkDGBcWBUvPlhC6JtMUZBSy2dSnTBU
         JtYPZAdLyqeIvpDmnqZZLpdiF7cKh377Q3hRkbRavaie8BBX8emwD81+YsHTu0o6WLU8
         rRh2edNOhJYgxcVwoqdDYJ0hg6Cd8GTrvWDZ2G2ix+M17yU2jI6U/3wJMqSD8sK36DeH
         iKZDt0u55FTUimW7NK7tUYGNpPa8SicaFjMMNkv4i4tyHij14dpWGO8YNmWTiWPyxM41
         ANmyKZKGYo/1zCKFRU7dd4iRnaZfCe8JBgNJnmPrqWIQ0S7B3Zp/dzDdyJCq3gQHlXac
         rpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310198; x=1779914998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bdxg0o2btss9qMTZzYA98i+uvFmpv+cRF90VMWdHIeA=;
        b=s/Lp1x5fU4o0po4spju5beY6PFlKQG0eEhXB7EANjjgCmDSq1ad71YH6IIOINw4RgJ
         cZibWUybF7CDtBXm73sVnRREz3ku6zfprXoNo4GljhJy2swMSxAjyh2a+eo608C88I1C
         8W3e+h6DAcH6s0Xf7C8/WjvC2mbB1NoJEkxFhDnD41q94MAzdVKubWmL0tiINJzfH7SS
         xFUsRpb69ZWpZ0+VDyKkwWcUJ0H7tWZcvqJmALAXhePwBE7LxHRRoK/3xiRYzK8M59JZ
         Udsfud16obJ8DWV8DlyDSKx81ta1Y+FjUhxMMWEqdvhMQm/dJ2jMU/CiBL5GcFzx2tk3
         7okA==
X-Forwarded-Encrypted: i=1; AFNElJ+obUFn93s8AQEm4bXCa2R42/yJM4/wVtiDBIjBYZj2ROeLXmT3FmFAyS7klfDLSteYJTE3meU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBiUCx13A/ncTyg20VTN9ukXsNVm9aI3t8WEjjWYQ9LGHDnUYO
	3cocZFpaknhGZbJevpL5TjjpCQs+zIWDbpZK1ys1Mn/jYl0CCMvX+sJ9QRJuXnuvmzvlOqwSjWC
	361nJYJYGND+oLg==
X-Received: from wmxb16-n1.prod.google.com ([2002:a05:600d:8450:10b0:48f:e53a:e4bf])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e53:b0:490:1640:8269 with SMTP id 5b1f17b1804b1-490164089c7mr213656225e9.18.1779310198457;
 Wed, 20 May 2026 13:49:58 -0700 (PDT)
Date: Wed, 20 May 2026 20:49:48 +0000
In-Reply-To: <20260520204948.2440882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520204948.2440882-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
Message-ID: <20260520204948.2440882-6-smostafa@google.com>
Subject: [PATCH v4 5/5] KVM: arm64: Validate the offset to the mem access descriptor
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

[@Mostafa, Add missing call to ffa_rx_release() and use fraglen
 as the max buffer size as it is the only intialised part]

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index e6aa2bfa63b1..38f35887e846 100644
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
@@ -508,8 +508,13 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
-	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	if (em_mem_access_off + sizeof(struct ffa_mem_region_attributes) > fraglen) {
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
+	if (em_mem_access_off + sizeof(struct ffa_mem_region_attributes) > fraglen) {
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
2.54.0.669.g59709faab0-goog

