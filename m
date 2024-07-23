Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C281214F11C
	for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 10:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721729544; cv=none; b=PmB1vWWc/A5sq4xMCvyyMoZTreOAi+6elOUC7lsK8mob+seToMfSGiddUnUlG3FuFT3HL2jOmfLNVx/zHfoDWAvO/kOJ4C+NPoEEYu7D6iruSMLFqGteNyz4ZrvE4ylal/kI8wib2xy3L0EETjW3DquLwWfjG4jTs8EMDgGaomA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721729544; c=relaxed/simple;
	bh=rTkj/gLNEoKH1Qi6UhwNBuSC4NJP/u445SQy5IWYwE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S9r07j7IxP1wyujQSKN7BHaXUKsa7li8Pt89D/wE6M28siYijHpiu619snNcpzIJPksVzHYkfqAs0clw6UWzrC3weAg/rnxaMCIPn2N6KonyavQ2dTvKjMtT7le2iHidVdXXvPwv0oLyLeyt8PyWSelGlvR6Md9RxLEhbKcLpDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gdVi975J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdVi975J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721729541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QS7Q6moReX0ytgpoj7OMDTRK1GZLav9EGBrr2p1MFoI=;
	b=gdVi975JW0gftFiFUVDjvNWq9WPPkhnDUkocixHD+6e1f8/RLV/6LYKY0l+nS8Qixqhkz5
	vquuvYzcDsr1lP3u7tLoN2zIfaYH44+AwNghsJH0tiwxY8WUjzgEPGUWc7wDVuPIUxxayq
	bxaBd4reWVuI7lR3JbiQdIuYR+yjNh4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-W1zjPlEfPb2OTNMNfgUSHg-1; Tue, 23 Jul 2024 06:12:20 -0400
X-MC-Unique: W1zjPlEfPb2OTNMNfgUSHg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-79efd11a9faso615168585a.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 03:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721729540; x=1722334340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QS7Q6moReX0ytgpoj7OMDTRK1GZLav9EGBrr2p1MFoI=;
        b=nxSvKVeK//0hDQ0nbNmmdPbTxMyigo8i86Sic4GnWvbDf9M7AyVbhkYdc4TSAAB6rp
         dPqDpG5Y7FdRvUS0YFJHHyHUdbdr2fOKTZpFkwiP2FpyZOyu+bTYaIt+5D2DEATXX8GI
         A0x7kvNx8GCR3IBGGgX41NngXEnXpTmGn8c04Y5LdxlNTlKoExJcTwGzqlGZkWYhu/ee
         rO7N7CCTZRWWzi04lQGu7/YBFg5wlhxVgjdDo8TZEpkCwc88ojjS9WAn+u9QWXci6Yrv
         HYtEZc4vkXWZ7sxcb04B2NXw6DglB/uDZzUYCn3m7PPtHO69If2ZJFQE6hvqiZHjVxlT
         JJLw==
X-Forwarded-Encrypted: i=1; AJvYcCUhhIpsXJfxUGGEkXX/jrWNaxFNCWoM41G4/7c3yjMEgdBV08BgLrgVXPwcseREH9WhyExdmCZO/MnbQOKzwzs7ydqX2//T
X-Gm-Message-State: AOJu0Yw/VeWaVcIvCWV7n/Ng4HejzsJSGm23a2z5rL/IQOr5DTIwww3B
	Rb3JbJUqDCZtaBt38dovoyFEkH/xMBnGewmo4/8N5gtMC1T0CZSSE00uiAk4LSrEgFWf0hzW/3Z
	pys7bexgLW3yWGGlbw2eI61E/TOzDfiqBACII2D+UEhCFpdeLfr9qlQ==
X-Received: by 2002:a05:620a:244d:b0:79d:569a:699f with SMTP id af79cd13be357-7a1a654db8cmr1283855085a.39.1721729539868;
        Tue, 23 Jul 2024 03:12:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2wFZtBagU/E46pV0uxTwzvChsAR2Dj7XVxuoFQCCKIFbTAHgkyz2V/BD0RPFoS8SnlRhwYw==
X-Received: by 2002:a05:620a:244d:b0:79d:569a:699f with SMTP id af79cd13be357-7a1a654db8cmr1283853185a.39.1721729539500;
        Tue, 23 Jul 2024 03:12:19 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1990063f2sm463780085a.64.2024.07.23.03.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 03:12:19 -0700 (PDT)
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
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 3/3] KVM: arm64: vgic: fix unexpected unlock sparse warnings
Date: Tue, 23 Jul 2024 12:12:04 +0200
Message-ID: <20240723101204.7356-4-sebott@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723101204.7356-1-sebott@redhat.com>
References: <20240723101204.7356-1-sebott@redhat.com>
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
index 03d356a12377..ba8f790431bd 100644
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

