Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9B2219498
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 21:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015712; cv=none; b=CYaa4uUIayi+Q/q8kOoE1Q1LOCuuML/vzAAHf947Z7Zb7VcLe+bKKDrbfD/cD/jfQpSVhUe8vv573Lck53CB6GpvQ3vqqGUUIh1jRIMeu6ND3CKrPyXtrA53IhsOl2TW8KR1tFxF7zZPeR3UD7vID1bkf7VK0ONlipMWGsHjPR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015712; c=relaxed/simple;
	bh=jOOlJLiPiEa5ClNb9LHsnzMeOqeBRTZ/5JpT4ENcDZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NndPs5SvFcqPcYL1Zzq0gEcgxjmgRLuQGMz0PWtkq3oBxbkdT/go550tAUpnhCYl5Rrrp7S+rAxBCT29s9pt8zC6zqyVfmZcLxLzhnEmBKAxfqKZ2iq0XVS+LS2QdRvklMBouNHA3ZM+e3Xn1O53P5MUzQINh7s1UaMvnFiaCBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lcOSWggT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lcOSWggT"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2ebab7abfso2090479a91.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 13:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015710; x=1731620510; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fS4eYbDYlT6ZjxYCs7YFPGo/Zn24dUoWIUuzZbUwo90=;
        b=lcOSWggTWfEjLaeXt1lSGuDyrFaWuyx+RW2N4f82BDNHwZFYIU6mC4Cv4cpfPP1Oj5
         3uGd/PIEFiF49Ne75g+9lAXU1tYdprfRy2C2exOmkhVSzK3R5wRzqZsE1Tr+bjrhipUb
         CN4QR6XShSpI+FmtzDdAcoFYhVmOQB/e9qXxafPeVsuzVLTd2wwLeCDlgd4qk426aKpN
         47lRIzu2jbHnqUMTXT8cYqJRvI72T90tGcvmaLPq271ij6atRi8X0qlOJCdD8SEYHpUx
         MvtFi5AjT5AF7Kzp7RBXun03N80AO5teS8FRCt30clIEbipb97Ubgbo/cRqgt3TmtzwT
         IPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015710; x=1731620510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fS4eYbDYlT6ZjxYCs7YFPGo/Zn24dUoWIUuzZbUwo90=;
        b=kghoLrGSReml+YJLK+9myecUzZJtiB9YCiM9a/GI6oA1z51SYhKg08KeARucVw4zir
         IrpPrLjEjfJN/9Ny46EqXdXljFv1X4wsNwzmf9VX7Nsd02Dp/+WR3F9cjDSIxvO3Ln0d
         HurqqiGCDozGV89v2K7EaXbUilNnTONwVrmUy3yyOso44s2RMlhyco8mTOvFkeSdyeCb
         RfCNlSso9eZNXc/bDGKeGzfOTn3BC1XmEO+EG/60kvppzC7bF0BTobqsx8sluCo6lCTi
         dHdy4rdJNEOfKoFNk31om3YsvYaCPl7F3SOl0zIm2+vyrq5eS9TPy9asMqPdpDOX6N68
         nQgQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9YIASDP9ODRxly/1AnB8ss5KiB/tMlq2inqanLIGtkQ2TuoN3IBec8gyRpBMoonWbrvlSW1A=@lists.linux.dev
X-Gm-Message-State: AOJu0YzD918VYscyrPK6+RkXzoNf9CN2/uMyBMQg98BllXY3LuCCSdXJ
	Qse9w6IxCPcYPiTp9Ukow2Oz2V7jt3M2w4nJlGhrl/BJVKOH0jdOstSoFOus7y4CWxobzqlbnnU
	8RvmrfGcfkLxX1Lvxz3g7bw==
X-Google-Smtp-Source: AGHT+IHZvcyra0ifDWGBgFJCy/j+FkQf7fYD/6K0phYB7aIm7PHY7A4aDCP/RnuVnWME187Wgbt6jqNTLj0tZimfxw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:b018:b0:2e2:b41b:8549 with
 SMTP id 98e67ed59e1d1-2e9b20ab802mr988a91.4.1731015708623; Thu, 07 Nov 2024
 13:41:48 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:37 -0800
In-Reply-To: <20241107214137.428439-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241107214137.428439-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-6-jingzhangos@google.com>
Subject: [PATCH v4 5/5] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kunkun Jiang <jiangkunkun@huawei.com>

When DISCARD frees an ITE, it does not invalidate the
corresponding ITE. In the scenario of continuous saves and
restores, there may be a situation where an ITE is not saved
but is restored. This is unreasonable and may cause restore
to fail. This patch clears the corresponding ITE when DISCARD
frees an ITE.

Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[Jing: Update with entry write helper]
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7f931e33a425..5d5104af8768 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -782,6 +782,9 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 
 	ite = find_ite(its, device_id, event_id);
 	if (ite && its_is_collection_mapped(ite->collection)) {
+		struct its_device *device = find_its_device(its, device_id);
+		int ite_esz = vgic_its_get_abi(its)->ite_esz;
+		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
 		/*
 		 * Though the spec talks about removing the pending state, we
 		 * don't bother here since we clear the ITTE anyway and the
@@ -790,7 +793,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		vgic_its_invalidate_cache(its);
 
 		its_free_ite(kvm, ite);
-		return 0;
+
+		return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
 	}
 
 	return E_ITS_DISCARD_UNMAPPED_INTERRUPT;
-- 
2.47.0.277.g8800431eea-goog

