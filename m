Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59671D435F
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 02:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786071349; cv=none; b=iXtME13C26T6T4Midttbad/lzG4NgZL9WZ7oZXkRZ5111HUDSnpJ/dN1nzuLwfsff262JYhp8N2Hlf1zXjkfIS7mOtgiTXou4sCoxE8W/h0hkY1Zr9TWYapurgEOPTNzuO/zp/dcY3AhMAqGyqWHWYkH/cqYjn95wKHRRl+gBMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786071349; c=relaxed/simple;
	bh=ehfupAjiBlPbXzgN3KQshK2fO0ZqW1VYU2bmsKIMqxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dQaBEbmR0D4Igtq5hV8I4XDexUc6UUdsyrm7i3qjKNrEtqLKvyVy1HpHFnyVNyTTC6dp01Z9f8O6go90DvD/cUU6cd8VIPSbv1lPBy7XBtScYVrhXM5pQtzHAGIc9U/kbAqDsRr8M9oqd2s8o6aYXrKz+MWUVEcsymEuLHGAwCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kfRRlh2O; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kfRRlh2O"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-849f2f32facso419125b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Aug 2026 19:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786071348; x=1786676148; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pIGWzVgFBhi3QS++pGVJA0SUneFjy47jOKVOvjRMiOA=;
        b=kfRRlh2ObklQIZgQHM8qcxBOA12ovkEkjy2tpTy6eaRCfpxxwtQh3fOGj5CDrmwn30
         scTMqO2g+YwYlGIr5N3t0bDFZUWT5eSH0rcV4g56TuhgKr3DDMZFoBho3t75VL85ngf0
         lCSPvohFZfkJeav4khuYJJMxacnXoZhl15gqrJkVDQLctMWyMpD6AAOHZsVLqbpjE2xA
         se+hHtxHMKFwKhL1b5Cy+MTx3CtGOw6nUoLBepJxHZHcvkg9ZNXmPX2cugZmCqdEA244
         rlwaRFwagjXXBQYtU+P3G1UvQroYME9c1+RD1J6OkHYGK8qf9JZjj3vWiUGqFfkwMe+x
         SbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786071348; x=1786676148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pIGWzVgFBhi3QS++pGVJA0SUneFjy47jOKVOvjRMiOA=;
        b=gcXp/Dr/6DRe9mWqbETq6swR8IfuaR77TUM4ptZtMdr/rq/cx8oPb3aLkB7vdfl6Xa
         B3PuhB4MWzYr9Lg1xYiAJpre+iqDw8U8RirNtxaOGzlwFfqk/5aQbLoPdkdmHOGjENow
         xlSJz3neHwOwvAaiOx4xSRyWHhLsGIYmfr+9ht7GBLnRlhchsxPTHjSEzIYMURfjKCwj
         C0h1bwm8bC0pzBVy1O8V28JSJw0WrETBwZRZ/oYyOfygnx/tv7YALwGjZhTo356Z/YO4
         YjPAGdyZjtYymJVU2Vch4Czn6k+GbEXD2ugo6gO36WweTVe/UQprVG9YevbVBp8RNPCB
         dMRA==
X-Forwarded-Encrypted: i=1; AHgh+RoWHnAsdXL2q+qphol63h2yH80Cst82RPCXgODKfNAI/7x9eV7112pDl+suv49m3JIvj62ucBQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcMud0i/BC5lXoop0FX+xYGUVojkCHOKN4yuGPpfHuF40ZFLyW
	6BL8n1n43py6MSp1l3+MG6l6826XnRsj5PPTDijV5HYbPL6kxmCEzzwd
X-Gm-Gg: AR+sD12nu4jbYb92A9SB+wz1HbS5t17A0GVlE+YSZ9xLkGDRqKc/MS6QF0j2Ki+6sl2
	vM2YPvUQgPg7d+9coFor99C8wkZPSg8699OoXVWEQdpiPmdQh/JEaUzNmVSiS9viNnTfUp8OmRZ
	AdOpGJBWliedB7AS60pt58s8BQsSCzQDElv1HAjwKGscDHiA1wYn7jxBj86c14uNc7ZqkbiYysS
	RZa2Sx6/cYiW0ycAm5d63CTgAqkhzUJt+eueR/6Yj8GiXQrh44GaU6XOGjzvz8EapU0gW0nT5+Z
	hY/rWtNCMazlRA/v2aWaWzmVL85vySFRaMI9vTCpy0TLa5JSYWUB1NstGRKxkdtAhxn1SXYsliF
	l3tBEZ/vjF1xZnYcAaTt15LsB4ehFykqmhk+RsqcnsdMorWNLoMtNX0enCfpZ19C3JA/9xKwD4o
	DkJSEkbQn+dg0oBoBO7rd5htqzRdzHLvpkrhSWgGS35NGmdMc9AUC5virWR1QpfgUNYnChUOYpO
	ph/dT7GPush+Z4UDcMUuqlXpic4lZ1yAwIhj0c7KaDHh7kx5Oc=
X-Received: by 2002:a05:6300:648f:b0:3c6:61b9:9162 with SMTP id adf61e73a8af0-3cb863e0633mr15912712637.3.1786071347910;
        Thu, 06 Aug 2026 19:55:47 -0700 (PDT)
Received: from localhost.localdomain ([139.159.170.90])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe8bbfc330sm143385a12.27.2026.08.06.19.55.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Aug 2026 19:55:47 -0700 (PDT)
From: Qihang <q.h.hack.winter@gmail.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Qihang <q.h.hack.winter@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: vgic-v3: take an LPI reference in vgic_v3_save_pending_tables
Date: Fri,  7 Aug 2026 10:55:34 +0800
Message-ID: <20260807025534.34125-1-q.h.hack.winter@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_v3_save_pending_tables() iterates dist->lpi_xa using xa_for_each()
and dereferences the returned struct vgic_irq in the loop body without
holding a reference on the LPI.

The xarray iterator only provides temporary RCU coverage while looking up
the current entry. That is not sufficient for this loop body, which reads
fields from struct vgic_irq and performs guest memory accesses before the
iteration completes.

A concurrent path can trigger this race: the irqfd cached injection path
(vgic_its_inject_cached_translation) obtains a transient LPI reference
via vgic_its_check_cache() without holding kvm->lock, vcpu->mutex,
config_lock, or its_lock. If guest ITS DISCARD then drops the cache and
ITE references under its_lock, the transient inject reference may become
the final one. When vgic_put_irq() drops it, the LPI is erased from
lpi_xa and freed via kfree_rcu(). Meanwhile, vgic_v3_save_pending_tables()
may still hold a stale pointer obtained from the xarray iterator and
dereference it after the RCU grace period completes.

Fix this by re-fetching each iterated LPI via vgic_get_irq(), which takes
a stable reference, and dropping it with vgic_put_irq() on all paths.
This matches the pattern already used by other lpi_xa iterators in the
vgic ITS code.

Cc: stable@vger.kernel.org
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

v2:
- Add Cc: stable@vger.kernel.org as requested by Marc Zyngier

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9e841e7afd4a..c3a5e2f1d09a 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -605,47 +605,53 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	}
 
 	xa_for_each(&dist->lpi_xa, index, irq) {
 		int byte_offset, bit_nr;
 		struct kvm_vcpu *vcpu;
 		gpa_t pendbase, ptr;
 		bool is_pending;
 		bool stored;
 
+		irq = vgic_get_irq(kvm, index);
+		if (!irq)
+			continue;
+
 		vcpu = irq->target_vcpu;
 		if (!vcpu)
-			continue;
+			goto put_irq;
 
 		pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
 
 		byte_offset = irq->intid / BITS_PER_BYTE;
 		bit_nr = irq->intid % BITS_PER_BYTE;
 		ptr = pendbase + byte_offset;
 
 		if (ptr != last_ptr) {
 			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
 			if (ret)
-				goto out;
+				goto put_irq;
 			last_ptr = ptr;
 		}
 
 		stored = val & (1U << bit_nr);
 
 		is_pending = irq->pending_latch;
 
 		if (irq->hw && vlpi_avail)
 			vgic_v4_get_vlpi_state(irq, &is_pending);
 
 		if (stored == is_pending)
-			continue;
+			goto put_irq;
 
 		if (is_pending)
 			val |= 1 << bit_nr;
 		else
 			val &= ~(1 << bit_nr);
 
 		ret = vgic_write_guest_lock(kvm, ptr, &val, 1);
+put_irq:
+		vgic_put_irq(kvm, irq);
 		if (ret)
 			goto out;
 	}
 
 out:
-- 
2.50.1 (Apple Git-155)
