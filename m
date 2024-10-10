Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7E81E0087
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584769; cv=none; b=nO/Br8CcesE1KE0apeTdgK4VwlsLqHcW/Xoa3i0Zghpjf+3kUo0VppHI5RTbivql1uwS0zd0HsV2u8SnNpYzIqV/CxNidD8gIUzx4OTizzhC92cO4oZBxeDVrtfqz3mlFlvOnwA5FrYPblNLEannXPimElo/t98GfOBWw/lTrQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584769; c=relaxed/simple;
	bh=HP41e6SfsC4ul+oSDEyzHZ0hlt7iv8seYpnKNCv0jUQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aBINEimqQXBwx/RPQFM+xOb1Zi0PeECYJgUyf42SbHBU+YVp3KSwPpz1U6bA5Fmr5Xt7XVCPmfJu80gxGI08jrCKE1fOpbbR0a29aeyCsFCpGhH0pcnqpnbwg0LJHNotEw10oG0Z/Mjy3bs0WzUTpvbXgwchSUVmHI5s4Xfnn6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iUBAFKSc; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iUBAFKSc"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71df07ac9faso1221366b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584767; x=1729189567; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=n3l8C52m2RjpLTXcY6dq+UIBo01A1fTC4GBMzDz1kHI=;
        b=iUBAFKScB1g4F9+HONuYZhIOHZ0xKxAqeT32/q4eX77ZvTYdqNLw9v4FYAcOMwW1bL
         JK+YqMg64s1kknByBxKgNfnxSuCd6NsjsdX2o393QYwJIGimyk5TK9XpfT2gxrUX08bL
         iMrpKMA+eohFbtQSMtg/zQfzahtpT4qeS855obTqdUjXor0fcKxjlFIyhFCmFn8lAiMr
         80K6iHn+/G/4my3rXVtdBe9bAGm2dIEMRSlPxYtmlu9cH2xgWzuiUiKVP6kyyPu6qL60
         3tlUfiWJEC/zz3ymWyMVWKp45yJ6gzxA6iMWmfbrQNn+OL/6R6UreiHQVgqWoOJXOmyp
         KmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584767; x=1729189567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n3l8C52m2RjpLTXcY6dq+UIBo01A1fTC4GBMzDz1kHI=;
        b=FwJrAsPIRuPd9UZl55KvxrwM0ZOeFbtBLq/DGJznZZ7WXYm+WroNq5GHdnytrTwbaN
         oXTFOIfRWyWPp906uXpJCtPwMbrg/Ktan8jb9Xcs1vzCiF4OwP/lSSv4XGlE/HpYaTri
         xF3buOOZEf3RjkKc+z2gXcJxwe9urhfaZuwZlR+oY5a3XgHd5FedjVj9eO2Ldln3BQtd
         gaMAd8SRr0dcWeM0IVZwCY8qtzJeR3bFyt5bFJ/gZZ8eQWkr/tyzX0Jd1l0TsrpM+XQS
         PRloQ+ZefVYo9hTVPNX2wih0374XwP0d67rM19LZq4Kxq/3T4VuTC1vRIL9Gp4pjfD+e
         7TYg==
X-Forwarded-Encrypted: i=1; AJvYcCWPib/bIqUAXdjCm27G4G8kvUIor+0p+2V+jZAX6iG0lAaIxzkthdLmxrgODVDiosxf34+Qox4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZm9FS98DsYo+CgnJDJ4C+BfT65PzHys/bRX+f5ITklp1yo2Tr
	HPeyJDHT0S1BLSztGb/j+yDxUaLon5PTBHfkUWi03kHVXF2CS+U0310QZUn2xCFMkGWBRywJneM
	1Xw==
X-Google-Smtp-Source: AGHT+IH5y4h19aQ8D3UFZNHEjFs0l+IkJ/F+GwDOdY5CLNZ6WKY+eP+zfpO4DiXt2PfVXCIgSRJOtCb+AeE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f44:b0:71e:268b:845e with SMTP id
 d2e1a72fcca58-71e26e53c16mr11733b3a.1.1728584766802; Thu, 10 Oct 2024
 11:26:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:38 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-37-seanjc@google.com>
Subject: [PATCH v13 36/85] KVM: x86: Don't fault-in APIC access page during
 initial allocation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Drop the gfn_to_page() lookup when installing KVM's internal memslot for
the APIC access page, as KVM doesn't need to immediately fault-in the page
now that the page isn't pinned.  In the extremely unlikely event the
kernel can't allocate a 4KiB page, KVM can just as easily return -EFAULT
on the future page fault.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 20526e4d6c62..65412640cfc7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2647,7 +2647,6 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 
 int kvm_alloc_apic_access_page(struct kvm *kvm)
 {
-	struct page *page;
 	void __user *hva;
 	int ret = 0;
 
@@ -2663,17 +2662,6 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 		goto out;
 	}
 
-	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (!page) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	/*
-	 * Do not pin the page in memory, so that memory hot-unplug
-	 * is able to migrate it.
-	 */
-	put_page(page);
 	kvm->arch.apic_access_memslot_enabled = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
-- 
2.47.0.rc1.288.g06298d1525-goog

