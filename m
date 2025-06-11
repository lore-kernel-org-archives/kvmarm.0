Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49898277C9A
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682096; cv=none; b=ckcgPSujKAnJQX7kQmL/4D8vJ4V0quSZs5cZgMx8qoXWIgPM4/Zwnvi4tBd6bi2WXbPFA22PNktgakHAeDh6wrKBxmG5JBCTy0PKLA5hnVTZGrhlm7XdZV/+Jxu1SLHHsEf6bus51e6IlxzxBbR4lIPjr9K+HOQDledQqy2iXgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682096; c=relaxed/simple;
	bh=5uhQSLawC2qU5tV2gH8Qd+5+MUnVHTVb+tyLOzTBT7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YLOpm3mZdBWmqEIss/TtT7vPBzUDiW1sHwLbkB+NVuWtDYigVo8aYE+VYT+VKhqfjvTGYlTnGvj9+Kk1qaFp+hWxDy6vOw8KusI/ge34pO6QO4qJ8n6rIscDUHVxojrhKYcFfryoOZ9f6/+O9KyIgn+OWhHaegkC3TJq4vscjLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cItv5r2c; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cItv5r2c"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311b6d25278so341954a91.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682093; x=1750286893; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xaTt4Giap+1J1lFwTOaDaJBf68Rv5IWBO561HkZo+gI=;
        b=cItv5r2cqPJAdXZiP8mcRgJ+apVAmbEb+mThKNMNWTYd8GFFZSpHhahHDNWHJS1Dbv
         +DgriHfWCmaFNw8ZvyX9nUzP7M6kLbckJj/ogb1SvgWDhFWqZZgeB/eQhCMGujy8/ZXT
         4eZG4gTiFsqy27wfSKBmaWAqisXlaPy7wXFrLpq5J+Xlc4okCo3i7Dr9gOAKn7aKxWhH
         Wb4DG6AR7Iv+GxBXO4F1pvjUnP4zU5x2qcd84AirJluh5dcuU1mWq4bSVjksA2AYqXoP
         tlXYulQ1ZGfKOw5qXBKLIF0p/cL1QYN81qWEZo3YarfAWp+1AsKIWDDfK2Q36HgTYoXz
         ve/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682093; x=1750286893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xaTt4Giap+1J1lFwTOaDaJBf68Rv5IWBO561HkZo+gI=;
        b=corhbRuqu68yoGwMAvzmx273JZvXO662Xbq2gYNT4l3J+8x4sF51kcjsLZKebjNgwc
         LfM/8aWx/i46KZKW5PCACMdNBHIk1aQcS5uVctlEDXECVm1n4yqgXxc3Tut/4M/jWt9P
         kKbWQV4CeEp75GbLcfKIus2dnd70RdXcPBmYWg7puhw6GeKmptCDUdJhq/vIY5GblwtQ
         tuL4gpeKodw4EzAeS6e8+UZPMHgvWm0tCGlgMRzi2FVpQwa2q9JXOFa6HxQirtUsslrM
         w4H3vle+IC3m085igFdcphafMMdOyk/1X3QYbhM+eZMYrSXxcEDL4+ZKVL9eAeH6Miyl
         wc5g==
X-Forwarded-Encrypted: i=1; AJvYcCUPsErCeSLIgaU/A9RsJ6QaTHTgUb83obebarzOW+Yn6FvpmYeyawueicxOR0rgr9IPFUIs6oc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1O4EeBmh17gwYNKLISzbSpvTO9FRk831798YfL1GCCmxg+Ssn
	Q+U6lRo7asQwyZqAcENFrgfHbZbeaFEQJYLHJ478DJFMJ2sx/4ZAhuL789/Wmpam72ceFJdNTzN
	wTzVx1A==
X-Google-Smtp-Source: AGHT+IGf03w35WpWXu537xHWr4U/N7R14xnxNpvZmT8HfbsZ9X3mUH7UkRwX/TiEroCP15FbAA6qEaYzrj4=
X-Received: from pjtd16.prod.google.com ([2002:a17:90b:50:b0:312:dbc:f731])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5408:b0:311:9c9a:58ca
 with SMTP id 98e67ed59e1d1-313c0688525mr1173665a91.8.1749682093424; Wed, 11
 Jun 2025 15:48:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:48 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-47-seanjc@google.com>
Subject: [PATCH v3 45/62] KVM: SVM: Don't check for assigned device(s) when
 activating AVIC
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

Don't short-circuit IRTE updating when (de)activating AVIC based on the
VM having assigned devices, as nothing prevents AVIC (de)activation from
racing with device (de)assignment.  And from a performance perspective,
bailing early when there is no assigned device doesn't add much, as
ir_list_lock will never be contended if there's no assigned device.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index dadd982b03c0..ab7fb8950cc0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -732,9 +732,6 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm))
-		return 0;
-
 	/*
 	 * Here, we go through the per-vcpu ir_list to update all existing
 	 * interrupt remapping table entry targeting this vcpu.
-- 
2.50.0.rc1.591.g9c95f17f64-goog

