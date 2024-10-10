Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5D11F8936
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584743; cv=none; b=cMTigw9jDOvXrEfcOFYQkO6hAL3xQ1xEbl4b1RBR+uSm3S03i5PzsLlJC0NIqsPJlGm6o49NaPmV/L6C6U0cu50lgOcdTlEf9ily79qdepFCKuEkscDFWcWjSg945bvO0LdF/ikBZ69JcGZcHcqm59XQAYFvpq+oDoJJE9QFJDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584743; c=relaxed/simple;
	bh=Z6RyJQ8NNQkeYyg1tN/wL4j+YrBUDlf6269dIZP90as=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tnrhrVgK4PTm358XA32p3uarhE3UFhOhnsfbx9AslYrYgwyouk9hb/C75fv/ZfIL6zP5+FBTNwJO86Sr2ADL+DnPggarUqJCvtLp6G/gIkohLSfDabLVYwmyroOza9Wb46Y3MlbGzXkHA/WAwGKwMDRrzKXPQ/mvzWfEMwmK1rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aKCGIJGw; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aKCGIJGw"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20b8bf5d09aso15596585ad.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584741; x=1729189541; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxQVf2h1B1ZgTBX9bfQB+O4u0WEdBy2E8BNaXtNQtEc=;
        b=aKCGIJGwvkt5WA6tCNnU7B4+zsDbHrbH9HssYx1Zj6NRv2ldBhWTpS6ZauqQ8Cr6ca
         jPdz/pNzUfzYsxXu44TmFk/9z0dLYcMpUjInIRd8yCtJwkUdprxC2iL67NPCGx4WP4en
         0hZCgBPCmt3spTB/Um7D5zCt9bX5Q4g7fAu/Fy2s5ucazixORy6jP+ap19i5qEpwmSEP
         Gc5mjgL203FoKTC6ainWV1ExSplEweG+6egOe/f2ZcPAMXK6d/TPn9/f2KJK/UjK3JH0
         e3z7lpIh3gnofmBdn5fUtvcNa2fX7kQWrdkTsKG09OeSgGuYF86/K3/xXeih/L9BXPa1
         eiDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584741; x=1729189541;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UxQVf2h1B1ZgTBX9bfQB+O4u0WEdBy2E8BNaXtNQtEc=;
        b=Y50kuBl2+fnEOFrIhL+OVs+0V3ILPlEJX5yJXtEiVQUV7+tKsdyhkr4nibDb/Ugohl
         hSSfU6eOVEJrKMsc2dMlpXVXhRDkiycxo329+jxpPxFhMaNORn7CAKFy9GFdjux1JVhb
         m1c5Eg/QspEFzVg1G/4FxinZW/9yzMGZzKqo3DbkL6Dac7atBDQlrrDPlCsr8+yiO9Yo
         781x+x0kRdlsrGUxH3d+1OJAUMGzlojSrYkhChiVq6gfCnVF06d760Lq4fZ8MM+3Wngz
         2Nte/6eTFHwetDESc7Mld85BBk2ZkM4hugLXhxLKy0YtZk51jktQmmfzu1ra0HBQlwz3
         D1TA==
X-Forwarded-Encrypted: i=1; AJvYcCWK4/41pXtVQnirc6J8QCISi0eSTwMBpYLd5KS0jHkgloRor+LeQivLxgsU6gxHk7zPrHrBnwA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxgKtJAHMX0TiE6EEOgZN6N40hFp1j3GALHG7xgjQH2V60hiZ54
	tHttzlCdpGHxgvCKtSd7ckoHCyaGTej3PJvrcb91VtrUMFSrvPKKxhAs4faNqQnPSN1S9bdiR4G
	F+Q==
X-Google-Smtp-Source: AGHT+IFSsaj7YGs0xXvL7KvHpo4OHZS23TfW901WnGn1dNBw4UEq8HUBbyPz7tDSJuBwPv672jv+MkN6+4M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:2349:b0:20b:9365:e6e4 with SMTP id
 d9443c01a7336-20c63782bdcmr1094885ad.9.1728584740809; Thu, 10 Oct 2024
 11:25:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:25 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-24-seanjc@google.com>
Subject: [PATCH v13 23/85] KVM: nVMX: Rely on kvm_vcpu_unmap() to track
 validity of eVMCS mapping
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

Remove the explicit evmptr12 validity check when deciding whether or not
to unmap the eVMCS pointer, and instead rely on kvm_vcpu_unmap() to play
nice with a NULL map->hva, i.e. to do nothing if the map is invalid.

Note, vmx->nested.hv_evmcs_map is zero-allocated along with the rest of
vcpu_vmx, i.e. the map starts out invalid/NULL.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a8e7bc04d9bf..e94a25373a59 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -231,11 +231,8 @@ static inline void nested_release_evmcs(struct kvm_vcp=
u *vcpu)
 	struct kvm_vcpu_hv *hv_vcpu =3D to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
=20
-	if (nested_vmx_is_evmptr12_valid(vmx)) {
-		kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
-		vmx->nested.hv_evmcs =3D NULL;
-	}
-
+	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
+	vmx->nested.hv_evmcs =3D NULL;
 	vmx->nested.hv_evmcs_vmptr =3D EVMPTR_INVALID;
=20
 	if (hv_vcpu) {
--=20
2.47.0.rc1.288.g06298d1525-goog

