Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA432166F19
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 04:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992586; cv=none; b=fL2qd8vw/Yl+phKVDbeGFLL13WKBvApuEYk0GUTz6XWWJBQQkcPZcjINKUs2DEHIDDHTuHcBnXEZ0iDGuCD63LFpBsH50xSqUeWLwIEeevtOokIE0sZx9cjL796Fl2660BI0TiHTcenAj6J+s1/upzK5WoONSPdJ7Od2C6pzeqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992586; c=relaxed/simple;
	bh=91b6MHuQTYrC/IH7LI/hDXxUWGMJ9NnNXDEb5najA1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e6o2EHi2uQ1YigK/2V3kN8FLw+95Ru++s3e4aNudsGCOhjKA3/VM/OMfcLYDn7NAJsgxkb10SPzBoMpwlaqLr3LPhP19c3ZZ3nsCSYVRnloeHPgsDqv+9ldcByt5mXjYlgLtEx+QC72L6eiqmQsBW+gmFFHYruUvC0iWNWGnvAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SQn1sRRX; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SQn1sRRX"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d2c2cf7473so27069127b3.0
        for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 21:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992583; x=1725597383; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TE+5gi+Y5s2UjnUAG5iU9KHZtarmS/zpW8eo5VQ9zdI=;
        b=SQn1sRRX4x4IJWqj0sM8ScfOnXdRRRN+UOHyRpEbM17M1SagHTY0b/JE1NPtnhtb/S
         gGGMb1pG1clQltAXtJbObdLktIks3TmVf/T2P+FvgiatowA2OKVg6H9t/INxC7G1MqSm
         UlSLvZN/yNbdaYqc7SgQ/YbsOm+AkI+4maqlNCdG9oJHF3kn2UgWPdauEGj8EOPEymkO
         0IcQuFY4/Svd/O/ILQyA6ejbnc+5mtu2EPpp4TRmJEJcl1cY6ZCoaWpRBwjGV0TMxJe8
         0gatieOzQK7e9hv+p3od8HBtW/Q9wx9//aZ7n93+DhOE7PuDaiMSNGLInu1stnYLGfSa
         /6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992583; x=1725597383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TE+5gi+Y5s2UjnUAG5iU9KHZtarmS/zpW8eo5VQ9zdI=;
        b=jj6v/FR6tZv9+Pl8SwU8mQyztNaHRGwG2YUSNiay5I1QNyygjyfenSNx9mzXoziYV/
         bsB/pO6MazwoBFqi0RzkJIJSAzYyn6ZdtrERF3elJOLbgZWcMZiy3JKLV8o6kZ5kXBN1
         b59Af5qBtZyPme0vIB5C1JxACxUBSfY0eSt/8XKVGtWj9z1BUeQUH5cCdSQ25jIHEkp6
         GH1jgdSVrAfzk0lC8vev91kiCNsPIcp7W8TLOLvvYJiNQtVg4QLHblwva+rOP01CZHSr
         SqlkCq+4F5WXippfY8U9riWWjvXLaUPI+pDH+6BTmvLhrqaoGIJuiKzkYxx7TfR1q4eV
         lmxg==
X-Forwarded-Encrypted: i=1; AJvYcCX0c7h8jSfg6NvuGpXUKhUyj7uuxLgdjg29a38TIrn38I56bvh+13YPxuo0rIMLiD7VBHjMvHY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXwA/CFFDLtphet7/A/5rgrwKqlwIX1DT58vgW9nrsEqCsK2jY
	s7fMuxYE0JieVsLE445W2x3pZji8p6qCLSobcdJsU6Oq8cHr366MhHdRJzVuZLt9T0uSuRk+mvV
	HKw==
X-Google-Smtp-Source: AGHT+IEXYjrPpdSD9GCwnZ0KjOxH9R7+gkyemXpF0saWXSC27VIOQKo5mk3or2G4Gxywo/W1sZdwv4+QKmY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:dce:b0:6d4:30f0:3a74 with SMTP id
 00721157ae682-6d430f03e05mr846777b3.6.1724992582796; Thu, 29 Aug 2024
 21:36:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:59 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-10-seanjc@google.com>
Subject: [PATCH v4 09/10] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"

Define cpu_emergency_virt_cb even if the kernel is being built without KVM
support so that KVM can reference the typedef in asm/kvm_host.h without
needing yet more #ifdefs.

No functional change intended.

Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 6536873f8fc0..d0ef2a678d66 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,8 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 typedef void (cpu_emergency_virt_cb)(void);
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
-- 
2.46.0.469.g59c65b2a67-goog

