Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C482C1FBCBF
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584761; cv=none; b=Ue8XeG8Oulu1Qk87n2uqJ4aVMQkdTa4YYXiVVCxlTmg+rPDhcAXUS77Ruy0LhNk6OsY10PXf2hXDp5sVeuqqC1krsM01ZSLFHppWXGT58Zpi0KqO7VZd2hvFpBBswU1FpEOC0432tFLUzImH6xiYqh4UXYx2akK1WyF+yHhptIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584761; c=relaxed/simple;
	bh=6AchJ9iF2qZs5ZSAOBrdf0urgGqdHLpa0Cd8lTPRDhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=slUSN9EGvSi1eCLm47B+7jsOYQapCV2KcqZDbm6GJFpHgCvf6c3Lk0afoeAVTCU0ONdIiv/hQc+EUwKXmrs5vMm5/CMvYX7iipeYMMTugjdRdIemfdPJw5tbVYF9xtxbGUgeaCDYMXv+SpiwC+ix2nnCzQQcSJVkuerFzWBUgu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ho5DCQp6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ho5DCQp6"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ea05b8ea21so1335565a12.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584759; x=1729189559; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VITkHk6wYCk30qmAXnWfpQxFdItqbxje0xl/TrLgm28=;
        b=Ho5DCQp6zR2LiCA0OdAck8y8zz8LdtqusOglA4Vs8EZiuvp22Sz2YzahaxPqQOzPgQ
         r17+tl4KcLWFJOqXJAPElOqQkZFRvgfVral07cyrgH7TdSxojGPNHIrQDlPvaUV70xx2
         hc5KGEirFfODCLycxGO4BRFwo5JOSoikJRr+Ql2d3q3kMMg19+1sx6rvJCLTy//gw59M
         gPsGhKjs6DSOCkkVQFYFR0xzj656Uov3LAdRnzfpvf0fksBamjc+ATTj6NSxWkXKp7bY
         nfb1IW81R7VL+jHazSHwjiPQHlnDAhD5t32QtSoO2osU6EcXffxq0QOCratUDMNkDuwp
         IRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584759; x=1729189559;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VITkHk6wYCk30qmAXnWfpQxFdItqbxje0xl/TrLgm28=;
        b=BteEtxLLkb27Ph+jqVXnhYBJj5OZmY+1K8JV07l9NbVFlAEgREg1qN77PXbFuylFqG
         UrpVLqvMpXbq7pj9+6et13uSSW5BWtbpkF/18zQF4oE5VRTwlwxcUZvq4bobr1HrCEba
         nCcHNk8MfK59sVTSg2VGUESA8gacek6Ap0RIvO8XbCK/8EL4ljsKob2EVb9TdFbVFYnx
         6LLCbiya4dj0wsInLbH9EAR1QZuDverVRZPy5wIrXQ6MXBW5bQ/IbA3b/w+IXTFyi4sl
         AG7u2JkFTwnMIdvV+UNX++2tSssyYnXwA9g+VMCMQ4b74DdQLdIW3+/uxYRPDnz+Je1K
         xgxg==
X-Forwarded-Encrypted: i=1; AJvYcCVW8uRHzdnjqw+Klo1XH9LD8kDIq/ArlBiDvL529Ae77RG5s17fPqFuJHWdqyG2MU4MF47VIOQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSqn8+bGtDZ4hlFmQVYoBM+EED8BdrXZFZlk8RGiMBq2KyZm4t
	r5D1Yz2ERAAvLY2a/MW8PEIAmnVJaufIP2Xc7PfCprJV0ppZ9ys1fuygoRZa2mDV0fO4ti5QDGR
	Ziw==
X-Google-Smtp-Source: AGHT+IEekecUM0XVWoBmNjTczqp1a2/ixTMw1fOAmBrSm/Dp9XgHLEkyd54mJG+SlDPSB0szYk/zKOq5dxU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a65:678f:0:b0:7e9:f98c:e9f7 with SMTP id
 41be03b00d2f7-7ea5359ed14mr32a12.10.1728584759044; Thu, 10 Oct 2024 11:25:59
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:34 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-33-seanjc@google.com>
Subject: [PATCH v13 32/85] KVM: nVMX: Mark vmcs12's APIC access page dirty
 when unmapping
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
Content-Transfer-Encoding: quoted-printable

Mark the APIC access page as dirty when unmapping it from KVM.  The fact
that the page _shouldn't_ be written doesn't guarantee the page _won't_ be
written.  And while the contents are likely irrelevant, the values _are_
visible to the guest, i.e. dropping writes would be visible to the guest
(though obviously highly unlikely to be problematic in practice).

Marking the map dirty will allow specifying the write vs. read-only when
*mapping* the memory, which in turn will allow creating read-only maps.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 81865db18e12..ff83b56fe2fa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -318,12 +318,7 @@ static void nested_put_vmcs12_pages(struct kvm_vcpu *v=
cpu)
 {
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
=20
-	/*
-	 * Unpin physical memory we referred to in the vmcs02.  The APIC access
-	 * page's backing page (yeah, confusing) shouldn't actually be accessed,
-	 * and if it is written, the contents are irrelevant.
-	 */
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, true);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
 	vmx->nested.pi_desc =3D NULL;
--=20
2.47.0.rc1.288.g06298d1525-goog

