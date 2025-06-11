Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0FE24BBF0
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682021; cv=none; b=bvTH2HOiJfvRapNm5dV6kUOw6SHvbHKy+8g8THM+3yasnXy1TqQDnj5BVSi5xNTG+2Ffh/ydqugWp+09tpwMN0JJOMTtGNK3a5pAfBIgdawkGAlWGOrZIo+xVJJVr3MS5e0nBsrUrVYG1c2I/VxR2H/r8P//dmvmwyk4zfMKO1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682021; c=relaxed/simple;
	bh=982YzkJSuPJzcUJ59rC3v9vip8VboXzMkqDEQ2GpPws=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uDmPutRb0/V/yYrfcGGz7ok+yljhYLAk1XiAK0E0KVRq2DFe3LLp2SPiBo+Dv52Cg+f7XSd7KERC3me+jhSu2s+aXD0R+WtQLyREj9Qy3nA/MLVeb2sIf5PHVCf/1SvMmHRNlKAY/qS82Ily82KAShdieX8XkpzNex7wFWu2FPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q77XT4C5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q77XT4C5"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311ef4fb5eeso213754a91.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682017; x=1750286817; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xCMHUlDguheMk1DR0iSlAWm0OxNkDe+tjgoSc4700VQ=;
        b=Q77XT4C5Giejqii5JyAoBi+sQgF2XX2BJ5sd6mRg+lIUXUgV4+oFsvZzWRHmy8sFGl
         DF5IC6JzOBoaic5tKllH48Jx2rv627/PIcleI5QVOwb9HsH7kiLcrUg+fH7Z+Fu8BZc8
         kz7ND2VJK4rY0xNy9jdhTdFfQGv/D/CESnfHl230z8Tq0lvhFDGnNWn1fhPcioSuDb6l
         qqG65q7TYFQ6DcW/rtJ4i+GyWowdcKRoldEMSYeyEAfEZwa8oXYnq0Jb5Rfuzd+5Fj8w
         ViLr5d5wxNtEEwdXmL7crT4LtZ9IQ6SJRDSt26VZCOR2FzCRbqQMheyGttAdd9q2mDN/
         yUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682017; x=1750286817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xCMHUlDguheMk1DR0iSlAWm0OxNkDe+tjgoSc4700VQ=;
        b=tbsns/ltnKHFtQgbMr8IwZXOuwLDvrxGtNUupDQmtFwxQ2Qj5Tj6oOFVgIHgnNaFre
         mdE9XP6ok3kRIUYKmh8e0nnFMfOiHNdoWJ1Vx3NF2LSHHhbCh2gd4SS2fHkcs+lJeCcF
         e1RfWZXBQoqEfFABntwFrBZdZtvvJgi94SAyys5e1DRgXme2lyRfmROM1er3FmakL6M7
         0TqHr5SmYVOx6fhFaIBFQfruJCWjwlEYnRdrQeznh+HTPcUHScj50RJWyZb56XUOBd1w
         OT/PMdSr/goQ3+xgppqzCZCSyURIPe3RH1gMxLx+DxDIxES8ORtTXBUo1EGcYbUf4M1y
         cyEQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5B79tR/45k8qNhAYZXcTs+TbHYGPBsPSYVgVwH8I8lB3EgRpahuO/2erSlV7hTl3vkKkB7Tk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzE3r/M3ET5iJdXpBhqoTaZEcfuCADFEUnAkep/KKmsLluPbgV+
	lLfBlut/3WokCVD7myd4m5xdSNGWxZtDrUQ5hg+euKj6N/W18j4EpnIb7GyZPkokKqoUMO11idQ
	u/m6pBw==
X-Google-Smtp-Source: AGHT+IF9lRdjIaJMGffmVpoig7dkM1EZi9TG7goqvwtOE+A6AKDHS0ehZiZ8FiJ1CPYjTylPsun8hRe7S+Y=
X-Received: from pjbpv3.prod.google.com ([2002:a17:90b:3c83:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d406:b0:2fa:1e56:5d82
 with SMTP id 98e67ed59e1d1-313bfdcc12emr1459552a91.17.1749682017517; Wed, 11
 Jun 2025 15:46:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:04 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-3-seanjc@google.com>
Subject: [PATCH v3 01/62] KVM: arm64: Explicitly treat routing entry type
 changes as changes
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

Explicitly treat type differences as GSI routing changes, as comparing MSI
data between two entries could get a false negative, e.g. if userspace
changed the type but left the type-specific data as-

Note, the same bug was fixed in x86 by commit bcda70c56f3e ("KVM: x86:
Explicitly treat routing entry type changes as changes").

Fixes: 4bf3693d36af ("KVM: arm64: Unmap vLPIs affected by changes to GSI routing information")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index de2b4e9c9f9f..38a91bb5d4c7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2764,7 +2764,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
 				  struct kvm_kernel_irq_routing_entry *new)
 {
-	if (new->type != KVM_IRQ_ROUTING_MSI)
+	if (old->type != KVM_IRQ_ROUTING_MSI ||
+	    new->type != KVM_IRQ_ROUTING_MSI)
 		return true;
 
 	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
-- 
2.50.0.rc1.591.g9c95f17f64-goog

