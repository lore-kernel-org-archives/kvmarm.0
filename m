Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B312BE7BA
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682052; cv=none; b=CA0sX63cq5Irhr1ZtwkGXwjpwYNgKJcFpUsb05O7KUDwQIIbr0rok2P8GJhWysx0oBifh/MjmXBaH2kWSpr3Yuykv+JhFxFOK/U0x4C2biuOU3RhBCtGANohMQxPRwF7fAN9vA9ZLpk/VM4R9+bnCr2hid+ypQ6u9hnaODAxivA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682052; c=relaxed/simple;
	bh=hFP3peTM4c0R7Joyj2jqYQfH1PZW6FXsWdmWLA4bm3o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R58U6+isEQQLuTAELO7lAKF69JBvA8EIF8oNa05RCX5E9q1pXTJL3Jaf0LdOcB7gj3W2y/SQq2AtwXFe/TQYKe6IujAYI4lcbX1Xwq2x64R43dZW5djJs/fOx+EOjUPQRMk5UVdMfQWR0RX/DERMWqhOnw67z7Wn7cCV7U1rEMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lx9C9RLQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lx9C9RLQ"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235196dfc50so2389885ad.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682050; x=1750286850; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c8wf3RrDwwapSfuoerOV8MPC7AS9NZOZvn4WILk0Yi4=;
        b=lx9C9RLQslLIPh8+Bd7e9LFyClFfHkci2tz3qE7sZ3UsBL7POiKMfgnmeDdzDtFzRp
         NEVRjAviykPirDc9VkE3i30WT4DrMYSAr1H8yv1VzN3148VyWjXdlrp6z2CPiOS+Rla+
         fx3LnPcZM7wKhvuRQY8mv1OeMaXjrRknzbMUvYSt2kKCHi910ToC1A85idcdieLr0ox0
         ornf2yy7d95kuhvkemjNWVtDDx4nRl92cFJOERIRxhySVVCue2DmC3n4u31ndrQieBdH
         eyafb9YSf4fqGVgqxetYzCScvQHIbeepBvRRugLQpsYSfCTadB8f8uuEWfOz6l0EpqMD
         CBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682050; x=1750286850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c8wf3RrDwwapSfuoerOV8MPC7AS9NZOZvn4WILk0Yi4=;
        b=TTuPRHPXGmDyu/hYp8JuaRgJ9ofsuCZvIk75pDlvBuJ0F/MLkIJhfbJmHkU9j33bAI
         kWx0W5A1d0rc/PLyMT4Mg6fiJ0pGtxmyZKG6pW8fpbctI2IUmk5oxZE306B5JUmMSccB
         ChIJMIMY4Ksbzca0orLdHixWzEU0+5+Zxrl6vvbiRk89Wl18oUXHhwmnHtRtcBrsUl73
         4WPbWcU2QwG/Iua9Dgvr4tr9CE8ZCUu3kcByaP8xKe1gGVqXdYZjAcaUtqLutgaKRg73
         XPvQU8CjkmUsg8iD/b+C/FwAfnfI5dILgzWuoSStph2aPF4PkVzsSM863qK12oc5LT7Z
         ahBw==
X-Forwarded-Encrypted: i=1; AJvYcCX8zlZWYh5BvtSIJqeNzVsSYPEr6LzGToxCIsdbG5jZ+N2UDefeMdN0npYs5ueUQgbMGFgefbU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBPP73qWBBQTMn9FB3iTOnna15NkhOWFucyTGzj7ZyMzoiNn44
	SN9zNP2INSeuwv3bF6onCu9ikTst4jtnyeHPdK4xerHAuIaXmpdqxcxIkcRCKiGDhr4vRqDNOwM
	wi+dYZw==
X-Google-Smtp-Source: AGHT+IGJNCuXT10P6Ldic0CILM5/98q+VXrxvc0wPM5pd5dn7xv2Zsl8s09cXT8aND58IoPHTgLj9jyuzCc=
X-Received: from plk17.prod.google.com ([2002:a17:902:e9d1:b0:220:d81a:8975])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d54d:b0:236:10b1:50cb
 with SMTP id d9443c01a7336-2364cf689c9mr14160455ad.26.1749682050046; Wed, 11
 Jun 2025 15:47:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:23 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-22-seanjc@google.com>
Subject: [PATCH v3 20/62] KVM: SVM: Add a comment to explain why
 avic_vcpu_blocking() ignores IRQ blocking
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

Add a comment to explain why KVM clears IsRunning when putting a vCPU,
even though leaving IsRunning=1 would be ok from a functional perspective.
Per Maxim's experiments, a misbehaving VM could spam the AVIC doorbell so
fast as to induce a 50%+ loss in performance.

Link: https://lore.kernel.org/all/8d7e0d0391df4efc7cb28557297eb2ec9904f1e5.camel@redhat.com
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bf8b59556373..3cf929ac117f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1121,19 +1121,24 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
-       /*
-        * Unload the AVIC when the vCPU is about to block, _before_
-        * the vCPU actually blocks.
-        *
-        * Any IRQs that arrive before IsRunning=0 will not cause an
-        * incomplete IPI vmexit on the source, therefore vIRR will also
-        * be checked by kvm_vcpu_check_block() before blocking.  The
-        * memory barrier implicit in set_current_state orders writing
-        * IsRunning=0 before reading the vIRR.  The processor needs a
-        * matching memory barrier on interrupt delivery between writing
-        * IRR and reading IsRunning; the lack of this barrier might be
-        * the cause of errata #1235).
-        */
+	/*
+	 * Unload the AVIC when the vCPU is about to block, _before_ the vCPU
+	 * actually blocks.
+	 *
+	 * Note, any IRQs that arrive before IsRunning=0 will not cause an
+	 * incomplete IPI vmexit on the source; kvm_vcpu_check_block() handles
+	 * this by checking vIRR one last time before blocking.  The memory
+	 * barrier implicit in set_current_state orders writing IsRunning=0
+	 * before reading the vIRR.  The processor needs a matching memory
+	 * barrier on interrupt delivery between writing IRR and reading
+	 * IsRunning; the lack of this barrier might be the cause of errata #1235).
+	 *
+	 * Clear IsRunning=0 even if guest IRQs are disabled, i.e. even if KVM
+	 * doesn't need to detect events for scheduling purposes.  The doorbell
+	 * used to signal running vCPUs cannot be blocked, i.e. will perturb the
+	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
+	 * to the vCPU while it's scheduled out.
+	 */
 	avic_vcpu_put(vcpu);
 }
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog

