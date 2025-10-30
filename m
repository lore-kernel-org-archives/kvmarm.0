Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D977937FC58
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855018; cv=none; b=IhJlevU38wAAHJYXhix8WWmojlaQa2QHM/Dnvv26Mdg1VoonW7xGOGKnbQ7v8HQiO/I05AF/d1qIsK7jFFTbMfIDDkKk/CDKXE1x+g/4qxdvpk4b3MEpVBfU1SI39zrMlKCOx/bsdnboGo4HdYhRzlWOPtHh5R+AvWOgEVEpY1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855018; c=relaxed/simple;
	bh=e3/F56xOZTqFFfm6ytjXqIzmHI1q3N3bM68KHJZJdHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=akcqLQAXmSln6lXAwtUCNjs8d1kYR7Mkfg+i7pNvA5FK06Sw57jAFHFC+WTpL1PL+3aa1TVbz4Js+K1+5ufB0UYHnWGu8//h+B0kXxj9u+QdqgTcAPWCfxJieP2ySZpQPW9jqdevpetaPZgIZzb3VJj44ikQEc7JXA9s8CryjJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VbfLxHTu; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VbfLxHTu"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b57cf8dba28so1198200a12.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855016; x=1762459816; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JLmVjM6Rep3/JgP/0z+P5jqrWiynYk4juTN/f68hSuo=;
        b=VbfLxHTu1CY68ITnu+/0vGhcEC3m8XNaDt3BZSIfSf1AeGrhK+1HWG2hMtFzNeMInH
         vzjkixx9RXCDcLZcLxe1eOITjpteNxJ2zE8WYPsVM0BA87VbFulFtAJy9R3Vy8ycfjIZ
         jPtTvYioNSx7WZiVWAc3ZM7KvjyDw3I53BTMUHD4maA/wwgJaTH6c5yPS2BUlLr3uoFd
         U4LiPC87e0bWPWURvJLfaROn6KyCrVwOp2aIrta+Wu7elQn8RmGTxTa97H92Ey0SCR19
         SD5e9ARGSHfLYWbjVOjZPZ8k85+sKPLQwWbR9Awg6w36CTUg5A9x/OOLEs0x66v3qLPv
         TeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855016; x=1762459816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JLmVjM6Rep3/JgP/0z+P5jqrWiynYk4juTN/f68hSuo=;
        b=nKjrDCuRTxp9fcm7ZSfNFraTy5QlfeskHC1snACaDtvibgHrawoKTFtumGxOoGj5dO
         xcd0qPmyq9HrGyMSXyMNesqqfS+OIZ+o3RZaIyiBKMe/7NTbOcKCpgoid/13Dzpl5S8S
         OCPOtumfX0MiHjODKzolLlu7IPtiKYCyGZamleSvxbwiD5xNWxjyx8EWzrSRglB1MSXD
         /kJuaLA/qwI5ezIBahPXq4aT/YdHhLv5KkntIugFGk6/w78ZD0mW8VrNLAcIimWyDTQW
         2/cwrYCEea3OLBBeBO68Q+9Q+2IzrD+uFGmsm8CNtloWflwiAYgkr25hDl+rKKPwreD3
         JdEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUitXipg607leXbgUmQChJ2Z1LyhgkJ0uwUnDK37yaleiPQbW+wscydQXoL6jSjW/l+aD8oBN8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxP/47DzwgriRonWjFbhIIqZBuDpl43e7HjyVBFASuzWRwEzTmU
	zuZnHptdertsqkYrSLj6qkf+ar+3hWg5Y78PjXRwabihNciuAHpQH0rjGE+lioMIIMeVj6wb7oe
	HbGE9HA==
X-Google-Smtp-Source: AGHT+IH1/xZVzpdLpqTCV5R9sgqM94QaK+KvWTLge6Sarj+nuvNBhb5+D5DYqWRmVcfvrQhQkF7/dm0shPg=
X-Received: from plnx8.prod.google.com ([2002:a17:902:8208:b0:290:bd15:24ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e88e:b0:28e:7fd3:57f2
 with SMTP id d9443c01a7336-2951a491f2dmr14399305ad.49.1761855016072; Thu, 30
 Oct 2025 13:10:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:30 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-8-seanjc@google.com>
Subject: [PATCH v4 07/28] KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_tdp_map_page() to kvm_tdp_page_prefault() now that it's used
only by kvm_arch_vcpu_pre_fault_memory().

No functional change intended.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3a5104e4127a..10e579f8fa8e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4924,8 +4924,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
-			    u8 *level)
+static int kvm_tdp_page_prefault(struct kvm_vcpu *vcpu, gpa_t gpa,
+				 u64 error_code, u8 *level)
 {
 	int r;
 
@@ -5002,7 +5002,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	 * Shadow paging uses GVA for kvm page fault, so restrict to
 	 * two-dimensional paging.
 	 */
-	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
+	r = kvm_tdp_page_prefault(vcpu, range->gpa | direct_bits, error_code, &level);
 	if (r < 0)
 		return r;
 
-- 
2.51.1.930.gacf6e81ea2-goog

