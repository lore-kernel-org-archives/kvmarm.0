Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E86020E713
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 23:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441354; cv=none; b=s6OJYc1hNdvjHKbrpHFu9U3V2L3+22aHZd04DWxuNZeYpK1RP1B+1Fnq5IHRUl1xxoKjHLMHunkhkwOEYIfd+tFhbnRC16FvMZ1WNibJsk/ku3HVVxinL0SqMIAmWeaKJgUdqUZIBdWDYFtcgl5s316x6U/gSwuBv8WXJTYwm0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441354; c=relaxed/simple;
	bh=xi1QaJ351EOkGaXqg6ZlisugvTQJp9S68DQPIs/E4wk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VW7RnAk0Myp6ic4DEAshxmiH6t3FLqPo3xtQaS3E+RFtx7LwXA1O09uCTqb4gf9v2tdQL6/Kf0DXCedjMPEXN1NcRrojHH9kP6/ugHqn6+rbbmq05MmiE436LOswZXiKklpVMrlw5LXDuKawErwhHmTDtcdkhb49fa24V5SN+Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o+GQqDw4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o+GQqDw4"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fbff6426f5so10342805a91.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 15:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441352; x=1741046152; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3T0ArXtBue+4jQS8m14aDT4hO1iQN7UONJOY2Dznj0I=;
        b=o+GQqDw4LRZ9FuUFffw9L7TwnvV1/uvk3A7DH1bDgcB7iQgLpo2KAb11J3nswzpYeI
         lSHlcOgdLLqvZ12VNPFmVqHF+6yYu1ugLxekFcM+tirGOEYYWLT/URrB74F5mI18vDBl
         LhFwt6UbOkfDSouMYGtkiOUQNDfZV2Od9PA1v/SJswgL0e8U7zLQZ3CEN2kCFZbA9oW+
         8TCdhWrO4skK1l5OR9pyJ8zC+P0CeEAwryuIIR0fi330FdyNCeo/6W5rWews78KuYQET
         aisaL30SvqqW1TtPBUhqBB/Uwcljasj5TEqwlumPrZ1MJnQEtiJdbVw8ikOnoKtH+2Pt
         +mxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441352; x=1741046152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3T0ArXtBue+4jQS8m14aDT4hO1iQN7UONJOY2Dznj0I=;
        b=i6FlteXCXxauExVEJJ2giOOuJICsMs16SJafa41TBddQwN7SWxviz6cGXpAvIR4f9c
         uqow4Z+DjFqs7kaEI7z85rQOHvWI63kveWVP00riBF1HcoKCZfcRxaACe0TINHFhDHNp
         mtX4G1aIVMBLJa0pDcc/HtvZd3ycWELDLp+HdjgGxAUKiMbKC2jDFSWJBYvEgLAg5T/F
         0sfBrUPry+4PIQ5PkYvQwWdDyYZmWHN7Pt7RmikkW8rx7B18wL/YsdozyXXXzeOlqhbD
         omqHhjQV/CfyDcy5wyAmfJBHf0KEdkaswSzyc8K10hadR/VLAwAFGtA6AMPEeeKKLXj9
         q6+A==
X-Forwarded-Encrypted: i=1; AJvYcCVckUp9o6B08Dk4nP1MBp4/BBCdCwGMcM9KTvxm1dWZ6+1Eo3ESdx+vjJjrEEubVqv8ujKpyNw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFZyk732EXuYFGpCk+Rk3aU2gMR5bt1kNW8csMMI6IfWpKUK98
	Dnaz1pGX414qGWC++OUM8SSEc19tis2ZiBT44+QEKL2I6bFX/wClwbKh4CLAWEPzdo45OZP5cjm
	XMA==
X-Google-Smtp-Source: AGHT+IGLhJjtwIM7JWkK50LEGpVa5IYsMEMrJLtXcv45TfVI0Bcew2BvOmcJCUf4CWX8wuCtTe3G30kBi3Q=
X-Received: from pfbhd3.prod.google.com ([2002:a05:6a00:6583:b0:734:cc8:a107])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:695:b0:1ee:bb7f:9b39
 with SMTP id adf61e73a8af0-1f0fbff6aebmr1778237637.1.1740441352385; Mon, 24
 Feb 2025 15:55:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:39 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-5-seanjc@google.com>
Subject: [PATCH 4/7] KVM: x86: Don't load/put vCPU when unloading its MMU
 during teardown
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

Don't load (and then put) a vCPU when unloading its MMU during VM
destruction, as nothing in kvm_mmu_unload() accesses vCPU state beyond the
root page/address of each MMU, i.e. can't possible need to run with the
vCPU loaded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 045c61cc7e54..9978ed4c0917 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12767,13 +12767,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
-{
-	vcpu_load(vcpu);
-	kvm_mmu_unload(vcpu);
-	vcpu_put(vcpu);
-}
-
 static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 {
 	unsigned long i;
@@ -12781,7 +12774,7 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_unload_vcpu_mmu(vcpu);
+		kvm_mmu_unload(vcpu);
 	}
 }
 
-- 
2.48.1.658.g4767266eb4-goog

