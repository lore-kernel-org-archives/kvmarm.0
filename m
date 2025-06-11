Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBEC2EAD1F
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682104; cv=none; b=CY+vPGNRRptUOMF218XzQ3cIdjO1kOkJL84WW2xwGRsfgrSWICi7lQg7zmF4KrtZY7ajqdHYyPh7GAtPHhmexQR5UuhBCcAT/3H0+4hmJcF5hI/AZOSuhbHBDukjk4xDTnt4eoH/NiA/yc/iWpMR/MVl+mayVOgT4XgwthF8mJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682104; c=relaxed/simple;
	bh=NAxK4l2+eFBLeYnDW4awSCXzYKBMMUzoga23UMMP12s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CTDGeoTmBgNfjYMNv/s6mHnrp7iG+IwdiwHmk2aEvanXKWvbBZy/UR5boYydZzmui6AQeZedMgoQVgtUS9MJk3Sdp5i3+/5cD75kvTRFTQeCIVsPhBtlT/5zdJXPn6wKC5U8vO790X4zPN/zGrsfRLx8YSGk8RCSNNJf5nN7DPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eueUOpry; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eueUOpry"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74880a02689so84416b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682100; x=1750286900; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4mZdmaSdm4nN9o3kcSmnCQqm8oVomLbyxtnfKwvcz+Y=;
        b=eueUOpryV8JRlGTSaE/NxdNHhNz6r8kFwtREL1SRVetXlhMIX+LQYUtgFpeUpmkUop
         OlaMBlLe048DqBwri0Io2g+XQFkgohE/kxipQ+vlk4yM0oQxbzaaxIvO0ba1yzYvpA0c
         4z1oXKvLvPi/mdja37/DXziXzoZD7ajBwN6acO+nXN+I5WEbQDAp193sQY6HFlE+rLFb
         m2X9Zq4fDc9Lnt+fk41PcFWTfSBZmNuwyjDz41WZcunILVHsZI9ApDQ/19o7m4IEBrNb
         Yz9JxxIIiyxwBR9i+sUCbkggSE+1Ba8LSOiwOHk78UCY6Q96MRNjO1DUPmz7SNMwN2fx
         VMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682100; x=1750286900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4mZdmaSdm4nN9o3kcSmnCQqm8oVomLbyxtnfKwvcz+Y=;
        b=fbcYBsF8Yc8zMGQu7B6+3RzaK6Rcm9ohvVE3ZK8vh2ta8W2qAXgBsCPOE7NnTI5C4o
         8OHRbFzHMLqfFaU0GlROQIon83nGJqX5ii1JuUN0c8+yQTKt1lhwGsGmbF8s61HKOlLc
         vnVPwrCrUZKHRynQpZcRojPIWA0JLMEgGBxi3aZ1QqSr+zfxZ8DxqTKZLzFBWhieWTyP
         cyoivq2wsYlZ/Z80zeChziyY9scxJNC/jtbCHOMThUQpzvZVRzpJ8W57Wvu7PE+q8vIQ
         ZlOjqhwYBrc6cAZJO0g4MVv5HlW2wxdtaD456+lSPVdm4yBxGchbg/nn+EuryltPfTc3
         qcgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVItEXF0BaiSFSr5E3Oo7pAP6MYNyHr1F/fH9Tm1ILJIhUNqyL0b7eEwO+N7ckNSg/eVF0e9q8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0ANpkFGYOTHvqwCzZWQMgwrH+pOzCtbBBfR1GDLzxQ9GqYNT2
	eKNi791UZDEpUAjDGTE5pc4MaTKZowc3T8vasQqBg0zHVPwXB2aanJNCTooJabUn6KaIu/nDhzB
	XH15cpw==
X-Google-Smtp-Source: AGHT+IEg+AS8QoF49j7jfT3TPcNYHFW9Ujm+mi8oTh+WHeby3lk+SesimVareIU6PzlpR4BED7xC7oESYEc=
X-Received: from pgn7.prod.google.com ([2002:a63:d47:0:b0:b2c:4d7e:b626])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2d43:b0:1f5:56fe:b437
 with SMTP id adf61e73a8af0-21f86727b69mr7698366637.32.1749682100654; Wed, 11
 Jun 2025 15:48:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:52 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-51-seanjc@google.com>
Subject: [PATCH v3 49/62] KVM: x86: Drop superfluous "has assigned device"
 check in kvm_pi_update_irte()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother checking if the VM has an assigned device when updating
IRTE entries.  kvm_arch_irq_bypass_add_producer() explicitly increments
the assigned device count, kvm_arch_irq_bypass_del_producer() explicitly
decrements the count before invoking kvm_pi_update_irte(), and
kvm_irq_routing_update() only updates IRTE entries if there's an active
IRQ bypass producer.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 4119c1e880e7..45cb9f1ee618 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -517,9 +517,7 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 	struct kvm_lapic_irq irq;
 	int r;
 
-	if (!irqchip_in_kernel(kvm) ||
-	    !kvm_arch_has_irq_bypass() ||
-	    !kvm_arch_has_assigned_device(kvm))
+	if (!irqchip_in_kernel(kvm) || !kvm_arch_has_irq_bypass())
 		return 0;
 
 	if (entry && entry->type == KVM_IRQ_ROUTING_MSI) {
-- 
2.50.0.rc1.591.g9c95f17f64-goog

