Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1149C2566F5
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682021; cv=none; b=RgXLUlbhftdRxR0/ULw6kzSIZCTVVlwLCDnouIIRWM28CW90tWb5Oqik68wymYpnpehEBU/sVzfDmFepmapu7EbRzkqbVHz61KVCciOHjE+LAtD8n42uXL3ATquqdY7Nxng9g8XXPvmlqnJsedPb+ZXVM+VqXOEE0JnH6w7L4iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682021; c=relaxed/simple;
	bh=3RinVstCvuPOndpP2qbzIU1WkDpDfa7DXhIJNaW07EI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iQtpFUYpaC3eOUhrsbDmbGWtNtgu9s8EOfDOaE4YkJmH9C7CuoJ7uauiHIefYCy6OrRkTk8IZX6t1MiFQK05M5gw2+ZRocRXluYpCNAYXvOFlWmHIzHkoYgoRUMGwZIuOJyirgQNn981abqYOFP4FOHWtnQ9mIBVgtyRsb7eXvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Eonm80cB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Eonm80cB"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31327b2f8e4so291572a91.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682019; x=1750286819; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J8/39YMW2TnSu0vcgq5sLc/aWRKEr8Y6tOCzdbkWep0=;
        b=Eonm80cBIWPCL2RSpvStf9nNuoSUoCjKVGSsiCQVRM/lQFDXctf3mdQRq698dT4PES
         6Kuo9UVn8OjACkXWCk0mIMk2lWhuqBl59zyfDcSLpvzolfHZMjx3adw7Y3uTktAQ9TRP
         T0hQ/DlApbHn+asoqQVUsOdYbstGdXOeGvUWQiozYCyOeZDjq8rSprxuxSGzTzPPXyEn
         yJBKJmMn2xKt5EFldBFW/MbZYkXOC3XJsOnbnqfq1miashrE9Fyqr8OFVZofytjNle0A
         WT1dtnOL0KTQ9IZ8iUTrNcOBzWs49cIpy3KBgnF9s35cgTquLuFQ65xjhG5J50eEqmX5
         G/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682019; x=1750286819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J8/39YMW2TnSu0vcgq5sLc/aWRKEr8Y6tOCzdbkWep0=;
        b=P/4t9LDhHcx7jgcv76JOhc8GZOZJ8Qh6YljKTP5UzRFqpsGQtDdh1uGup9TD+z7FDf
         oirrvgToMBVLmqRvkNdylTDBIp5UcSIdPpGNizoB/e0jHAJkhn+4pzMXvbVbfPvGW+8H
         9S++UdKdm0r7VDitUu8Wg0lkQrwPhzXKHH1TTII+uUvG5wRiX2GL146QuwdsetBMXPU4
         iZZD+/INwyxD3F9qAipMUIugBKxEy8aT4nDUryxLLjh0Uhjze0u/TNC4Q8ilR8rcP1HD
         kA/xQ1cx1eMiNFCaVvhto4z1uk9ceo59bGX9/PLAuFKCwFnxReuRuZlI9bACEmve50SC
         jK/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUljqJQh4AYyLNZ5YKHBUCnTA0Cfo/Pi8FRWVqjc/k/lQlX33rvMTiWRecWjlF//sj7LGyujrA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw159G+bWKiQhQUUSS7pTP0yWbp3yz5+IVHTy5AyFqEN5ql16ER
	IcSgDg1V0/bN3V0DcGXf297MGYEGW3u1pIwINCLRpLI8R8NktTZVVyEpr1Jm3zP68odIwP8dl+Y
	wjvSc8Q==
X-Google-Smtp-Source: AGHT+IE4n+pz35x0pb/YvabbWEbD1z+qTn+f+8VFoLc/qnaff30Vgk2g7VglikeaFDWzSwKhNVkNo49sz8M=
X-Received: from pjbpa3.prod.google.com ([2002:a17:90b:2643:b0:311:46e:8c26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3902:b0:311:abba:53c9
 with SMTP id 98e67ed59e1d1-313bfba1132mr1720309a91.7.1749682019303; Wed, 11
 Jun 2025 15:46:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:05 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-4-seanjc@google.com>
Subject: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
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

WARN if unmapping a vLPI in kvm_vgic_v4_unset_forwarding() fails, as
failure means an IRTE has likely been left in a bad state, i.e. IRQs
won't go where they should.  WARNing in arch code will eventually allow
dropping all the plumbing a similar WARN in kvm_irq_routing_update(),
and thus avoid having to plumb back a return code just to WARN.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 193946108192..86e54cefc237 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -546,6 +546,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
 		atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
 		irq->hw = false;
 		ret = its_unmap_vlpi(host_irq);
+		WARN_ON_ONCE(ret);
 	}
 
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-- 
2.50.0.rc1.591.g9c95f17f64-goog

