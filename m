Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628403CCFCA
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 10:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776853559; cv=none; b=K9q1+rNriH9e8wH25nLcQKUgECaZoh7oY92gVlAvno6fmm6ccW4dUG1VsvVMSvL+Q173Zb7ouWP9cuy6hOM9dgXZBQTndMU4As/UmahLQpbdZ41V5EnH/OIcda/FElnTYK79P5xhsTCBEtNdD9Gb/qZJ6W/b5e51zmmD8YLJew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776853559; c=relaxed/simple;
	bh=4e9RR3Fkt5ZYKdTIbJ3Mu4JFWKC86taawCJaNBynDdI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dYdto0oDcexG1RguiDdGSejaX0Cm9NSvXKTJOahTN0MRjyLyIm9fv8APRh/XuW0tQphYbBRXcH6PgSayDcWlOIY9DvuQp3kS1wykZVZpe2mEm4UDzZoLJctE32uK8zG6I9JEXnK67MAwTKs9oYjWDoPi7OKt6vfOMjDcJwhKXyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhzuDhAA; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhzuDhAA"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d780757eeso3094251f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 03:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776853556; x=1777458356; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5zVG8CK37G2H3h+/vsooWmb/JX2s+XnozBdTiycqzLw=;
        b=dhzuDhAAlBB8UtwJZm4VZ1ql6tX4GFbneuM0umkrpOzbQCm6NiF+XBBy1fXARGs+fE
         miu/3Ca3USlfaZmWXCSYCjktsjw3I81GwYOn7Dn6GHlPo7A24LN34ZSSn1/No4rDP8ON
         u9pMG4MCOcyameF1qqbvX/bttxxzhdBhuMsItaYdzQ+UsRmvaYT27ja55kQjr/oMUGuy
         2jEfSo+s8hP7RT6xX3ibshi2yvaQnHF1xGcFqQ9KqgmnvoZJWOpd/rq9+DdJ9t9/Rwao
         PGNBTZYJBMrBRf1rOJ7sevMcbLWHf0AuovWhA/VsKf9KJAA3Pq65KWOc1gnW5tIv2Xsg
         fWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776853556; x=1777458356;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5zVG8CK37G2H3h+/vsooWmb/JX2s+XnozBdTiycqzLw=;
        b=nyxEoitUEmQbSoJnALnt5XU1ikBbg1h6RrmEoMpaqTuusycai8AjqSSjxbKRNsedMW
         rsmJiswuYeIxLG0lGwumeV9yesqPe3nx/+uwGQJMgd24rvbOALb1wcWctI6AtB1WW3hI
         x069kYNqs2rKFka22bn3dtbY+DZBbbi+NeM4ysn0Dmdms+MOzRXfi37zZud/VwMvKeRG
         W90pdNHy7TQ1erija0RVE+rB8yfn8hQxoqDXWP+I6vPp7jiUXU8Inu6jANG8NB/MEymz
         Qq6h3PlAO3TA/t9h/iG4tdk2dOYEXvy0/5mWBGQo8MX8qI79tIs0lkCqYARAYmCqHfja
         Gf3A==
X-Forwarded-Encrypted: i=1; AFNElJ+KhBSe2jYwda/UDblAW+9qtgGC8XQ1XHUIx8uPb8+aewSAaL/Q0Kr6R4q8VGYEsNybaPt+uBA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz14vBPcazatPVcM3trEm8GeoWbFs/rqRId5qlnpXuSybpWqTB8
	vw/JVbUKHUxHC/JKjXa0PPzaj83icXx4t+PQetrsbKzKJbA92PKVxk3yNJ6/GYGvDMIqmI9UAFQ
	wJH2QGrMuSBHZEqpWDLqcBS6WfZDXBQ==
X-Received: from wrnl17.prod.google.com ([2002:adf:e9d1:0:b0:43c:ff2f:44d7])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2812:b0:43d:7192:2ca6 with SMTP id ffacd0b85a97d-43fe407e0eemr21607407f8f.16.1776853555738;
 Wed, 22 Apr 2026 03:25:55 -0700 (PDT)
Date: Wed, 22 Apr 2026 10:25:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260422102540.1433704-1-sebastianene@google.com>
Subject: [PATCH] KVM: arm64: Validate the FF-A memory access descriptor placement
From: Sebastian Ene <sebastianene@google.com>
To: maz@kernel.org, oupton@kernel.org, will@kernel.org
Cc: ayrton@google.com, catalin.marinas@arm.com, joey.gouly@arm.com, 
	korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Prevent the pKVM hypervisor from making assumptions that the
endpoint memory access descriptor (EMAD) comes right after the
FF-A memory region header and enforce a strict placement for it
when validating an FF-A memory lend/share transaction.

Prior to FF-A version 1.1 the header of the memory region
didn't contain an offset to the endpoint memory access descriptor.
The layout of a memory transaction looks like this:

  Field name				| Offset
					 -- 0
[ Header (ffa_mem_region)               |__ ep_mem_offset
  EMAD 1 (ffa_mem_region_attributes)	|
]

Reject the host from specifying a memory access descriptor offset
that is different than the size of the memory region header.

Cc: stable@vger.kernel.org
Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 94161ea1cd60..0703c0ad8dff 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -508,6 +508,12 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
+	if (FFA_MEM_REGION_HAS_EP_MEM_OFFSET(hyp_ffa_version) &&
+	    buf->ep_mem_offset != sizeof(struct ffa_mem_region)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
 	ep_mem_access = (void *)buf +
 			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
 	offset = ep_mem_access->composite_off;
-- 
2.54.0.rc1.555.g9c883467ad-goog

