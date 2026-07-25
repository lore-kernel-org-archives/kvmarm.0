Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B013290B8
	for <kvmarm@lists.linux.dev>; Sat, 25 Jul 2026 15:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784994031; cv=none; b=HwpBb0qQ5FgQXc+wS4UQg4Wc5VXiQ7ld5Rm68OIqR9ezGHHrGZhRQzyqTScV26ql8uZ0sFWK6c/Td9uwhueYuT/yGjW8nIxDE6VDSVzgvxkJ8Px7rx46c0NYFxDwkvxhpttQUg9X4qxCLwhjiCTViEL6lBMsls03xz4LHJNFnTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784994031; c=relaxed/simple;
	bh=RSNSQ0hf/1ip6FWJhT1UeiihfSgLDoIxgXqaDzmOAho=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cJCeRdrwwCmsebVN9YgMFUolH6nA38zveZ0rgPfxwoiWCXwPx3MOxx700QuvHCtJWx8hJAKXV/R1EAHFXJeGWvmo4zG4iNN9hHBQNnsjrVX6PeENNtSuYAV4hYQDa+vWBpHF8U6pwYU86NPc/+lzgacBY3HXtdEN+1mF9H3HfOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b2smAKMR; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2smAKMR"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f59f25ec4so495696f8f.2
        for <kvmarm@lists.linux.dev>; Sat, 25 Jul 2026 08:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784994029; x=1785598829; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KkXToa/E/TO7BNSgNTLBSgT6W89C2l7j03X9R0LWBpE=;
        b=b2smAKMR4Sfp5Ts7xY2hM+aJ8LJA98u84ahevKzJxm0fb02t+hgqsKzxSStnVE6tjv
         h4PZJRh713669IeMfc7sd/idN4yabKRjqx+iFo4jaJX1ObyQKUt0VR4tf8DcaiD6M8bB
         IqqTkJF5tzKCKFThse1H4W2hQuJYdVR5TP3b/v+Y4OLox1X4IGZhU37igVLj6rA9GMyv
         AJN7c/SA4afRdCXK5YGsw8QhZewZmW93KLpB2KNn5lamkvn8akcR8PzeBPKdVAvKCpiF
         bbvM1t75RWPSAc4Im1XbMMiJ2ui1LFi36R52d5BlrRFVX3vupMd+QyhUOL9hTf/pDHgl
         ldfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784994029; x=1785598829;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KkXToa/E/TO7BNSgNTLBSgT6W89C2l7j03X9R0LWBpE=;
        b=f/2a/bxHVVcaZAvROWbUhynAb7FTl+K+WO/BfwkpuATkzl/tkrbyXRoTzeAitbzXk4
         tL+MQZU9gEHbHm0xGmUnZOSrtcwX7SR18fx6E0hRv/1lc7LvQ0P/58FdP69X4ZBRe5/q
         pwAvZ0yKahCbUWgPWoS1OVPUhV0vCRKEfteJ5OjEypbz3gIh9P55gPUNIyKvHPl6hGAM
         FQ9qxsRyyfv1rDa2KsaJyF+6mKNefxFANFayue5NguKNKCUPfHqZjKei64n7hYqap+/n
         YFdmkb+Jy51TsXi4eeFkHI9hRt+VjIEh2tPDFbBT2ASE15exX0qJGrgiqHfUV9u+jFrG
         /rLA==
X-Forwarded-Encrypted: i=1; AHgh+Ro+adl6cJlRPEh/0TIjStDPwA29wkr9wP/tPfRCiQCBJd34R2U7a/NR670yb7HvxhTchM3MoZ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEowHrFf2TML5U3wZ/YZWqPRXGlVqeOjU/pZST2Vr2yuqVXF+S
	tECfq7mvkt8APy+0gwSkYP61gu92+/H9Kq4Za4wVxzRokgCXE0kOyCqg
X-Gm-Gg: AR+sD13T3D42Ii6xTdh8w7x8hQB/VMfvXtovAkcKUCMq0MnPtGwJoszKwmjjUyVWA4E
	Cwf1a3rynDoqM+Kb4dM0DV1d7MdwrWxtMOU+hLSFo1b/rHFqa8USz8Ha1nAQg1KJrMXmumI0sfA
	3aORsv84/UEyF5wHqC40pI22yVtZEhdQXo43WnTrPIsDhp/xTXN9ZTFshwIQaCE6d3958MZkCe4
	5/OYOqwPwrSxs6RppYlpRUvLt7vo6/Z99E7yDlSfhT/fp8Dg4s5Fs/prfWsCegniptEk360KecG
	KLjbw9pMkw2Lqi94ptFLx0kpSM5EKaoli5dTmSsE2Qi/qJpst8zty/fPI9njPl8bHQ3Y8jszhMk
	Y8uU/5ybWcO1Gl7yS1oT8QK3ZL6UV23u/SuY+7JPIF28+v9E69i/M02dYObRZsSz8mpLkCs04WZ
	9pzyC/Y7c6vnecsACMDXL0d2V6AQQ7WPcKuWHbgqY8Uip/IByv5Syj/9a5dyIkaoFLSkjV7OXFD
	Q+uLabb9tXPX2ZN5KNfdXub/JCzsHuA6hGiUTPeNYxZOQxEsInzuwffKG1prvrsXgLmKsA0T2QM
	RxYZgYV9i7xskXoHs9+h
X-Received: by 2002:a05:6000:1ac6:b0:47f:9557:8d77 with SMTP id ffacd0b85a97d-47f9fc82ceamr3194678f8f.10.1784994028285;
        Sat, 25 Jul 2026 08:40:28 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b344-be01-c902-8e3f-9491-60c2.310.pool.telefonica.de. [2a02:3100:b344:be01:c902:8e3f:9491:60c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85a2573csm32832468f8f.0.2026.07.25.08.40.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jul 2026 08:40:27 -0700 (PDT)
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
Subject: [PATCH] KVM: arm64: GICv2: Bound the INTID in vgic_v2_deactivate()
Date: Sat, 25 Jul 2026 17:40:20 +0200
Message-Id: <20260725154020.37305-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_v2_deactivate() passes the INTID from a trapped GICV_DIR write to
vgic_get_vcpu_irq() without checking it against the number of
implemented interrupts. An out-of-range INTID makes the lookup return
NULL and triggers WARN_ON_ONCE(!irq).

A guest using EOImode=1 can therefore raise a host warning, or panic a
host with panic_on_warn=1.

The GICv3 counterpart rejects INTIDs outside the configured SGI, PPI and
SPI range before performing the lookup. Add the same check to the GICv2
path.

Fixes: 255de897e7fb ("KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index cafa3cb32bda..42430c0fee07 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -163,8 +163,12 @@ void vgic_v2_deactivate(struct kvm_vcpu *vcpu, u32 val)
 	cpuid = FIELD_GET(GENMASK_ULL(12, 10), val);
 	val &= ~GENMASK_ULL(12, 10);
 
-	/* We only deal with DIR when EOIMode==1 */
-	if (!(cpuif->vgic_vmcr & GICH_VMCR_EOI_MODE_MASK))
+	/*
+	 * We only deal with DIR when EOIMode==1, and only for SGI,
+	 * PPI or SPI.
+	 */
+	if (!(cpuif->vgic_vmcr & GICH_VMCR_EOI_MODE_MASK) ||
+	    val >= vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)
 		return;
 
 	/* Make sure we're in the same context as LR handling */
-- 
2.39.5 (Apple Git-154)

