Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0380116C853
	for <kvmarm@lists.linux.dev>; Fri, 12 Jul 2024 11:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720782235; cv=none; b=pcjQoZ5pAQsqfm60TNUtWG2CEJHPKk1cX4RLhAGZH986aT1JzTRi4/GxX5QxThBrTHRhDXeZAa3agbztEHBK3uKSKnQOxRN+CCPIm4viKhf78rPULaXlhu0a1kLU3TC49R5AYyM9fLUf1CUfRrHr0KbTf05abQ8UVuBYWyV3Sj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720782235; c=relaxed/simple;
	bh=PzMJUqkQiNB6ha824+KU67DXfXi9Wu+ZYqT0X9x+bOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ieKco+AbwBmGThGko83F92JsYCGCuf7TphYA78ABAb5kcHKMbrk1xhIxB/ljS5hpaJ/udCje+ltVXu3230c5ICeWAcV42EWH4E0HgE13fLwk+QpS3LJL3vZiQbrSWHz3VM6CnwbYb8RLFLvKVBpsf1bstbhcL9Z5HB2vdwTQ7Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ScdPTR/J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ScdPTR/J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720782231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MsvQ75fAXsh3PNmutFTZ+oUFOtcjE1xAsn2yQswaCk8=;
	b=ScdPTR/J7kigBiNYnTWoXB455gumAuz8pVGeMeOLCqjolzED/QSUTIwSJFVMsULKNEuIrm
	8PN/xpuXquVSaPpYdHZwggBrSHslKIasuc+bJGQZ9wY6XTpy4s+nw0eS2LwYRLeGQv+Z2T
	RFx3M8EstPYQRDnro4OBuY1Pk//zXOc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-TVLLC77xNS-K5dpMTv1wmQ-1; Fri, 12 Jul 2024 07:03:49 -0400
X-MC-Unique: TVLLC77xNS-K5dpMTv1wmQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-79efca8478bso195888385a.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jul 2024 04:03:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720782228; x=1721387028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MsvQ75fAXsh3PNmutFTZ+oUFOtcjE1xAsn2yQswaCk8=;
        b=bmO80g6n9upQPwfvNQm88TZxHB/Xi8Zcs6cLYJJtQRvUWExa+/mIJ6v8IcHjj6Mxs8
         xyzDENEFiQy4flblElMpyolqXdLOMFcQIEXlCkpIRQN5WaZ5nW3HopYc7/+iAN5FLeaz
         Ml9VnuGTQoyKn7VseCt62QP3YxZ7dQhHZg9f9Hw/y+WMB+1OFlqZtqPTE1fXgt0hdsT7
         x3ctnxmQkBAOICcNVkA9xRp2FlchVjteJl3I1DSoQ4Ice2nusGKFg+YcJ8m5L4vgXlCG
         1BmfPYNudovVADMTkQU8B2q2FsgXjSS3HXcdwAVQ0zI6iT1d7S+6OiAe42+8FOppwp7X
         QsmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrA0m38iSrF2/0ep3Y0ngy7acZZ4thDt2buBzs2RgvHtLaTd0BQdZHGq7RcFLZ85C8oKA7DM0Vm+MO3r5a0zZuUElREh31
X-Gm-Message-State: AOJu0YzIXUlNRqntV6B9oy5CynYJ70SfBwStoLZYDOkuLQteaeyw0dAO
	IMR/j7AX1bo6PCv/1lCjnnSBLJtKk4FWOH+Hg+e0dBrj0lfd61Khu6xg1w+wGrHGHkrCv+vRGu0
	hUrcz44qJ1LazmCtwDF9eHRFwT7ANDg7v18bu9tHG7AHlkY5FokDCCw==
X-Received: by 2002:a05:620a:2186:b0:79c:119e:2b44 with SMTP id af79cd13be357-79f19a51d7fmr1225834085a.3.1720782228655;
        Fri, 12 Jul 2024 04:03:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/x1W3ipOkWAMomp0zXTQ02Ix+7KNx4A712Y6gcZalpd9XUggvSO3hVJNYViAZWFdOQfl+eg==
X-Received: by 2002:a05:620a:2186:b0:79c:119e:2b44 with SMTP id af79cd13be357-79f19a51d7fmr1225831585a.3.1720782228362;
        Fri, 12 Jul 2024 04:03:48 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f18ff834csm390498685a.5.2024.07.12.04.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 04:03:48 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/3] KVM: arm64: vgic: fix unexpected unlock sparse warnings
Date: Fri, 12 Jul 2024 13:03:32 +0200
Message-ID: <20240712110332.10970-4-sebott@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712110332.10970-1-sebott@redhat.com>
References: <20240712110332.10970-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Get rid of unexpected unlock sparse warnings in vgic code
by adding an annotation to vgic_queue_irq_unlock().

arch/arm64/kvm/vgic/vgic.c:334:17: warning: context imbalance in 'vgic_queue_irq_unlock' - unexpected unlock
arch/arm64/kvm/vgic/vgic.c:419:5: warning: context imbalance in 'kvm_vgic_inject_irq' - different lock contexts for basic block

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/kvm/vgic/vgic.c | 2 +-
 arch/arm64/kvm/vgic/vgic.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index f07b3ddff7d4..974849ea7101 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -313,7 +313,7 @@ static bool vgic_validate_injection(struct vgic_irq *irq, bool level, void *owne
  * with all locks dropped.
  */
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
-			   unsigned long flags)
+			   unsigned long flags) __releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 6106ebd5ba42..480b5c7e2031 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -186,7 +186,7 @@ bool vgic_get_phys_line_level(struct vgic_irq *irq);
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
 void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
-			   unsigned long flags);
+			   unsigned long flags) __releases(&irq->irq_lock);
 void vgic_kick_vcpus(struct kvm *kvm);
 void vgic_irq_handle_resampling(struct vgic_irq *irq,
 				bool lr_deactivated, bool lr_pending);
-- 
2.42.0

