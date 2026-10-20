Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792492936;
	b=S11Fiip7tE3JYI0riNjhZHsrffEYv1xDQfQfEZ0+BykV15R6FvwlWYfetzui9iWr9HvH
	 /RmNp7m/VJ+FykBw590DzKgiNJyy7Gjtfp1lzFzaVTGfdUVc3f+8LNVpU+eRRsRxLvGH8
	 PjpCtGHjfGpG06p871dhLT35kQdvgNlLSbR6DVAXq/7+E4bJsQ/PWbkr7lxRbovcCqMcP
	 YYERCaG6J+ZCpzTIGsvr7x+lCKZx7dCQwPmRK4DlsUU29knI4rL4dR8Z0WILOMQTT6kCo
	 J1N4MFWBLpTHfoKGQesWx1ekSKfq6DLgSqt46QLgus1w1dZSFgaTXACf7Ea4/noldIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792492936;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Transfer-Encoding:content-type;
	bh=EHQMj0nDjE1NM5DAqsI61LFSXR1PvG5+yphDQ1lnzpc=;
	b=nz84ho0FAF53vJEFLUMRI9wzr8ZSnJq7aEs8VbiRlczbD1+1P6Wg7DA4NDlx7iN4R6de
	 BSdkbMhAY5cy7CBeplWrM+K+i5T/AZoaKvq7Ccy+BT0erOyFwPZ+AVyhQqZJ/Ui6rUmod
	 wnI5fEuH1+uBBcxTsR48y+77tdyn5jQo/t0hatmySMHpHzG1Ta3kiXX+senUfpw/zrCht
	 mLh2YOY/C66Qrjz23Rpj+x9wgIQI77MaZZDFehZEWdS1v0Hgp42TukXEENDeUyys2ZMVQ
	 96aDKraie3tDnRg0Rrxk38dHZJx9rffb43+cHjtE6Ou4guMw7yT/zKO4gL1rOmfNUnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DFyvOL+A;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5B5606A320
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 10:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF5B5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DFyvOL+A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792492934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EHQMj0nDjE1NM5DAqsI61LFSXR1PvG5+yphDQ1lnzpc=;
	b=DFyvOL+A8ad+Cy5UaenWeD5ORfGR+ad/NRY6fwY3XW4EH67scv1xTBEEUZpc2N1ptmzyPS
	h1N03ZjJ4uagfDAqxtxiETFG/iW/LC+olY78AQJZadJIP+kKl/dzsPDUs4sQs61yGNl0Wo
	NBOcAEamlCk1lvPvcQs8Y8zrhmZwvZ4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-G2mey3YVMnuAPkqKWkr4Rw-1; Tue, 20 Oct 2026 10:42:13 +0000
X-MC-Unique: G2mey3YVMnuAPkqKWkr4Rw-1
X-Mimecast-MFC-AGG-ID: G2mey3YVMnuAPkqKWkr4Rw_1792492932
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a1d7663a4dso29182315e9.2
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 03:42:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792492932; x=1793097732;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EHQMj0nDjE1NM5DAqsI61LFSXR1PvG5+yphDQ1lnzpc=;
        b=HDCijHceB/V+oHXTw3HI5OsiLS0zbtR+DlobzNu7554gxk2ShJTdzSyfNhyjEXk0ox
         DDXbFUKKS9hJv/pUee4Ndb0Aemi1xCT30y0KGcFOnuHUsbkKU+aCWVtxCqLVNvcSHUoj
         CnkEnVFXBfHsnuoJx4qWwUnQ3r/kxWP7SqM4EyCY85PyV4sbN6WjCKUU55hcffa3Af0t
         2wx5+KzdlmzFOGKw2/L3YZcdR9rS2ssETXEiZEQY81Q0+CEWKQu+W5B8QH5KEkvSWxTe
         +85q/xm34wp1/Tle8FsEyf0oY4hk/eZzjaRsBRGkL8BDNr6L9hEJ3HWKuQ7bvUR3MVdX
         EF4g==
X-Forwarded-Encrypted: i=1; AKwUvBySbPla3FO6CNGDxrymOcxPMC1d2EtzzndEFpB/I0w5IIjr9+JAt14NPn8+TYpaCk6e07eUqTs=@lists.linux.dev
X-Gm-Message-State: AFq9FYKgxbwDumTM1MGNERfwN69arbxJc4IrDTUZjmD5J4D5FDjN2MtR
	pqh+MWRvbRIrx4ndJ5Ut9k5zd3ODcoGe1fCUoPa+7LXR18kDAFFHjX8+XsL1Lp+/FPjLbZIupgq
	+fWV9GzpVST9g84ec9+oPqQA2VzULx8a1PiUYZrr23p3uETDy+VRV318CMQ==
X-Gm-Gg: AYBFou2b+EJNTK9Tw+V+tVvdZFzivY8VzFZRBsRQ2ivmrzabmAUAMLLFnk3dsjrrTpr
	CUU/oZDv3tEPtaC+Br4otPt/lyjLuK2fDKXetFz/23WWLjFoHJPVJXw/X2YuXTP8CXYpG4g9Uqn
	tgaZnLnPj6gGII5Pf9OrOhn0u97gkD49cQ5soir8y16Hz2De2b+QcJcS245K0q2dvLAZN4TadbX
	kX2pVXqsZ4VM9n+8cq45ivSbU2Lef1CTGAnkQ3dl9wKbMn5UmvlI5AxAj4oM7YfdqEVjyzL7fIE
	cvVG1swYYiiqY9wVYo+m/hRpW2KeDomgO7Ke2/bKJqSd9mYg2SdelHHw0pQzcLRuzSj3dVdNRPg
	=
X-Received: by 2002:a7b:ce19:0:b0:4a1:f91a:732e with SMTP id 5b1f17b1804b1-4a1f91a73d8mr10947975e9.12.1792492932085;
        Tue, 20 Oct 2026 03:42:12 -0700 (PDT)
X-Received: by 2002:a7b:ce19:0:b0:4a1:f91a:732e with SMTP id 5b1f17b1804b1-4a1f91a73d8mr10947595e9.12.1792492931578;
        Tue, 20 Oct 2026 03:42:11 -0700 (PDT)
Received: from x1.redhat.com ([151.41.153.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2d699dasm66908685e9.12.2026.10.20.03.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 03:42:11 -0700 (PDT)
From: Gustavo Romero <gromero@redhat.com>
To: gromero@redhat.com,
	kvmarm@lists.linux.dev,
	fuad.tabba@linux.dev,
	Sascha.Bischoff@arm.com
Cc: maz@kernel.org,
	oupton@kernel.org,
	eric.auger@redhat.com,
	seott@redhat.com
Subject: [PATCH] KVM: arm64: Decouple computation of the GICv5 trap registers from FEAT_FGT
Date: Tue, 20 Oct 2026 12:41:38 +0200
Message-ID: <20261020104138.2641586-1-gromero@redhat.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v5t00vpG4eGzzBr9-1mdr2_LAM9524M2iUepJ82jNLo_1792492932
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Currently, kvm_vcpu_load_fgt() returns early when the CPU lacks FEAT_FGT,
so the per-vCPU ICH_HFGRTR_EL2, ICH_HFGWTR_EL2 and ICH_HFGITR_EL2 values
are never computed and stay 0, meaning any access to several GICv5
registers will trap, like an access to ICC_PPI_PRIORITYR0_EL1.

On the other hand, __activate_traps_ich_hfgxtr() is gated only on the
GICv5 CPU interface and writes them on every guest entry, which is
correct.

Returning early when the CPU lacks FEAT_FGT and leaving the GICv5 traps
enabled can lead to a KVM "Unsupported guest access at" error when a
GICv5 register access by the guest traps to KVM, because the register
has no emulation handler.

A real machine with no FEAT_FGT and with GICv5 support enabled is
unlikely to exist, but such a setup can happen on some simulators, like
FVP with the following flags:

-C cluster0.has_arm_v8-5=1
-C bp.is_gicv5_used=1

Hence, because the ICH trap registers are part of FEAT_GCIE, not part of
FEAT_FGT, compute them before the FGT check, making this computation
independent of FEAT_FGT.

Fixes: 9d6d9514c08f ("KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs")
Signed-off-by: Gustavo Romero <gromero@redhat.com>
---
 arch/arm64/kvm/config.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 1053676551af..8a526704af59 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1744,6 +1744,12 @@ static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
 
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
+	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+		__compute_ich_hfgrtr(vcpu);
+		__compute_ich_hfgwtr(vcpu);
+		__compute_fgt(vcpu, ICH_HFGITR_EL2);
+	}
+
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
 
@@ -1761,10 +1767,4 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 		__compute_fgt(vcpu, HDFGRTR2_EL2);
 		__compute_fgt(vcpu, HDFGWTR2_EL2);
 	}
-
-	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
-		__compute_ich_hfgrtr(vcpu);
-		__compute_ich_hfgwtr(vcpu);
-		__compute_fgt(vcpu, ICH_HFGITR_EL2);
-	}
 }
-- 
2.47.3

