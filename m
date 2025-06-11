Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC1A2D878B
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682111; cv=none; b=YORtrw08LfCjXWRJcnVHL+Dv6I3vV+eAQcBlBySYPC8EyOyfsjm3xfuNF6qcfb3YvcV4H+cEwWSZ83tZK9iuNdwis3YzLw28lNobxDzFCOIzvc8RHYL/wpBmfhjPQPOmEXnhTwaQgwFA4MIY3SglEVBzt84vBB7G3bNvfHHmNxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682111; c=relaxed/simple;
	bh=SRc1h3FwDFlhAZX/NxnbRZt+oZFY+JZk+gHWHS2GeKI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QotzZbjmZjUacFGxrfyRcdwXfiwc+N6p/3Y3kzFnV27BKfbRR0PR949NVplVM1hqKVBsOJ7+IJeE5HEkcZkfJkjVVEtRtVK7sO5d79rMFVPJPlF0mseETuxnan70KrrGtA57MweAlJdK+9SnlWNet4g43alBd/uslSt9jgxtxzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uRQ5e2wy; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uRQ5e2wy"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2f5cb0c101so158273a12.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682109; x=1750286909; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DHIf+c90E7y3SFrSqtGUpe0CRM2cdrMuvDnBkk7f4PY=;
        b=uRQ5e2wyQzyAX0UfXIGhijl1CaHyYYY/XewXlCc48BzdfMdvVkKNikunALZmYL0frg
         abuid/aW/2dfQD9HOp27+2OX8aHgQ/IpHmAEAitM1F8fBXgEFEOvwuwKhlY514fhQqwz
         5KFm371BpLWp9mNHZqqV5JgVGaUJbI71PehgqAwsCEZLtK23A+ifZ7ls+XV5uPQPzu2F
         UiNzNT9pwAHMcl0N6RPbyyyMcpd6LAOjdx0fRHGjFtEDYkQ3sROTGlHebmDWuNxxYAMP
         Glvytq3K7dkPjZpUtBV2fCEIrVUzJrJTp4X4yTC7Tdh6aLGCIGrtFmLqr+pWg4LpvkhV
         jw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682109; x=1750286909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DHIf+c90E7y3SFrSqtGUpe0CRM2cdrMuvDnBkk7f4PY=;
        b=fRLveUAOMQEuNkbqvyEq19kkUl72xjZjZZMWGzhS0fpajq9auSF82iC4jFvAuDY942
         byiTeFpEMaFfRHK9dm1tC07SzZMQN07i6+V7PGAAxLJQbmnyBr/cFheD2JhX98YI189G
         m9QZBW5t1IPh6Uc8XZTvYQTB24Qb+hHSKuGKxQmmmSgBp97NMGXTVhjBVDY69W0bpHkM
         cZfNN0Oozv6JdULLlxBAs7Vme+SZTv+vzdkJe0SC+gdWsQqvcNEJUmareiEQRZ4/teom
         0hZL4DKQo+UHZoD90rSaJIqBwL7G7Mi5YiU3I/IladJUcRwNSrobKsjj0YmJloOyqyv6
         ZTsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsI2s+zQaQfdZCFV2Dvaax0HYT9nCZd8dfbbShgD/9rLuVt7ktgooS5fd4IEqpUO1HXwlvom0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqCbHAiJD1/25shFQJ1RbhbXyqs4LM7gW3CU0wOCnggKQdnrpH
	4QcackKQ7octn+9Flh5o8tR+ruRgUpu8rLlKWy6oDs/lzH6ptMY0ok2JmcQ5Uc040sg1TbZCjXU
	BmCsRUw==
X-Google-Smtp-Source: AGHT+IFtBQrCrRoK6BL9Dz+IQ2aeYDyw9D2RNz8zXlEmSFnG0/dQfadG1s0WIBiR2YE1o9tnTCGC7rDXtkk=
X-Received: from pjbpq18.prod.google.com ([2002:a17:90b:3d92:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c08:b0:312:db8:dbd1
 with SMTP id 98e67ed59e1d1-313c0667c29mr974887a91.5.1749682109408; Wed, 11
 Jun 2025 15:48:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:57 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-56-seanjc@google.com>
Subject: [PATCH v3 54/62] KVM: VMX: WARN if VT-d Posted IRQs aren't possible
 when starting IRQ bypass
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

WARN if KVM attempts to "start" IRQ bypass when VT-d Posted IRQs are
disabled, to make it obvious that the logic is a sanity check, and so that
a bug related to nr_possible_bypass_irqs is more like to cause noisy
failures, e.g. so that KVM doesn't silently fail to wake blocking vCPUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5671d59a6b6d..4a6d9a17da23 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -296,7 +296,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
  */
 void vmx_pi_start_bypass(struct kvm *kvm)
 {
-	if (!kvm_arch_has_irq_bypass())
+	if (WARN_ON_ONCE(!vmx_can_use_vtd_pi(kvm)))
 		return;
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
-- 
2.50.0.rc1.591.g9c95f17f64-goog

