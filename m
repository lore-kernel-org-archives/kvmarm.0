Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6405A3D9DB9
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 17:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785088168; cv=none; b=KsENoPTfggGmN/iUmoZUn1HuGFEy/J33EllV5uF9XwIiL1uTjUxOTDbKPaxlUSRjqdUsLrpdePdKgE0UxHLEul4lpbNpVqgRV7evQbrdgucOKDq77M7jzSj7ahNWnrUmh6M/082JcoKYu4ck7sKLKhYfVxDSsrdo6BwjvYwf+RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785088168; c=relaxed/simple;
	bh=3bvh8ELBkw+UtIqX8TEGE5T9LfzIa8fNtzANvVlDEnw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=atxcpDUh7QzQNbR8J0phAsOomnD39kkPHLG1+bSm2OtX+cPAb6/V86J/XjAvUt7Ie/RpIpSlHNED2Atd5jEk89o5qpFtEu5elNylPQmfYG4/HnQazGRZnjgu8iseeLL/e7uOYzejdme9UFUMPr9v16+0hl8L+FfNjCJytpIQXbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D2ZsVADo; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2ZsVADo"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so5109665e9.2
        for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 10:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785088164; x=1785692964; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OG3fQOQ/VuZuHcKcajMtkmekIa5X8h+Q4MAhuhrOcMM=;
        b=D2ZsVADoz0OocRS3H78Y/U+fVD/VUBUa8OzvKkEJ2CrplJZiRTj9coZuOEu9hxXXFC
         at9peDjxgt45tCJYJmmukqfT/m+a5n6EnJ+OkgEA8w4M5/XWG/7v/i0WfE+4Jb8375Xp
         +H3hRKy1VUgZ3HORooHTM8L7NUyTMqx4T6ew3Ft15gK781j1Ce0DXoPN6MtbzegMkrOG
         VYxn1qPfijinUpe75iAf9lGB4yA4wTFtnsp9nZYLiG+x9mK9zQTYhUhO7sCmUrFdlxz5
         9pA4wXuM39DJJ4fIwotxyODmwfE+0pfZ8cb07I9s6XJsCBf2wsSO/uCi5qTBUXo3i1jM
         okhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785088164; x=1785692964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OG3fQOQ/VuZuHcKcajMtkmekIa5X8h+Q4MAhuhrOcMM=;
        b=kPwMhg18hiWJzaAg3mmuRvpU1Y9vNueYDCjRzUQcf5qcMHpTnOkOsNl7rPJH+ML983
         PwNwiwjVG7pF2d1YHdvFSQShEWsPJc+txOU3hUDoqhdLNHKXVkkZX++XGJBRomlGJJcU
         dt/NaDUQ5ith9wKYeuC+GfLyXNnHoOrQVBA/uBDbaHfwwB6qPea2FcSB0m4lpzONfj1L
         6aafXYUAK+H1mZfffYz/AD/R+N2s4alzCOvCBogOJK+tNMZR2HNaJaHRYmtD9MCkOOYt
         s8KRY0F6GSVJTMUbkqL6X/hXExHyDEEEaubt7LKhbGCI2hWx0nkkrys6W6svyOoz+YlJ
         CL4Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro3DKLPxZHtZUXTJK2fvIzgh7+hZ3ndfhbJ5ez07WGg2apgK9YLgcPnZDfivOA3d1qPa92eg0E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+NLEmXi0Ize6/ADSGxjLfboA+LA75Y7lWxInX7wK0eEXlXWEP
	3NWQndXQUl2o6HtPt/XnCwKPHY/AnJJxI/BFXAGJy0V4qTSzqVpXtd9S
X-Gm-Gg: AR+sD12kf4hCi1H8v4OTE4RCn0cC+NBF0UYHOG95KEAFZhiZaQCFIwWw7ahT0f2kiVb
	48PIvJD+f9d5i5pdSzb14WN/NjCQbyVcTOwlL3L5dJGXxFthaD7qelDyWsBslqLY5G3G78CafBH
	Nw3fX1rygkNdJZ2run11WLezCpv47GBEteXwYb9SW6hkvNTaYNm1orTWn6pya49f1u7Hkb22dD4
	FGQ5S/I5sbMIOBv1nvpQF7Xi/84d50++wP725gNbtIbG7/TjxyoTVQnnp4xYQTfvdhnNyXwtZwh
	dEYGsMkOapWZGRfgMK7H6rKKJDu+ZahT7C65h4iMIKqXjqBhNt6wJawhKvFybSa2+6DW6edYwnJ
	GHF31BgeNjt5ue1lsNuN9uduU1V8DpW70qKCycGVGyKCOUPVroLA5Sr0kOTGC5JCQJMTxl1AXe7
	OX2LAyVF/ORLSSu2BIzugtSVEsBaBZGC8Ka82kyIZCmEGpnNrYGAcWz53T/H/d5DyK4CPqughVz
	i4sewV7LYPcdmj/bDCOui1im1wcUu39jAdg4EeCjbq6v1AcAaM=
X-Received: by 2002:a05:600c:3113:b0:495:4fd4:619b with SMTP id 5b1f17b1804b1-496b56bbc22mr70116885e9.1.1785088164322;
        Sun, 26 Jul 2026 10:49:24 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-114-116-215.95.114.pool.telefonica.de. [95.114.116.215])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm45288820f8f.1.2026.07.26.10.49.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Jul 2026 10:49:23 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: GICv2: Don't WARN on out-of-range GICV_DIR INTID
Date: Sun, 26 Jul 2026 19:48:03 +0200
Message-Id: <20260726174803.5880-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_v2_deactivate() passes the INTID a guest wrote to GICV_DIR straight
to vgic_get_vcpu_irq(), and treats a failed lookup as a "can't happen"
condition with WARN_ON_ONCE().

The guest can make it happen at will, though: for any INTID outside of
the implemented SGI, PPI and SPI ranges the lookup returns NULL, since
GICv2 has no LPIs. A guest running with EOImode==1 writing such an INTID
to GICV_DIR triggers the WARN, and panics hosts running with
panic_on_warn.

Drop the WARN and ignore failed lookups.

Fixes: 255de897e7fb ("KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps")
Cc: stable@vger.kernel.org
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
v2:
 - Drop the WARN_ON_ONCE() instead of bounding the INTID before the
   lookup, which duplicated the range check vgic_get_irq() already
   performs (Marc)
 - Retitled; was "KVM: arm64: GICv2: Bound the INTID in
   vgic_v2_deactivate()"

Link to v1: https://lore.kernel.org/r/20260725154020.37305-1-kmehltretter@gmail.com

 arch/arm64/kvm/vgic/vgic-v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index cafa3cb32bda..7182f63fc938 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -170,8 +170,9 @@ void vgic_v2_deactivate(struct kvm_vcpu *vcpu, u32 val)
 	/* Make sure we're in the same context as LR handling */
 	local_irq_save(flags);
 
+	/* Guest-supplied INTID: out of range yields no irq, so ignore it */
 	irq = vgic_get_vcpu_irq(vcpu, val);
-	if (WARN_ON_ONCE(!irq))
+	if (!irq)
 		goto out;
 
 	/* See the corresponding v3 code for the rationale */
-- 
2.51.0
