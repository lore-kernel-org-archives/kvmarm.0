Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7C1206E63
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584801; cv=none; b=rjaJ3J+9YIojRKDtrovOiV/U/8EBQm8A8RCpBiF/IrXFrUBtLWS3AQ/26DK1uKVtdYMorH1Ytlp8mO9AkjYRtb7dAGu8hIQn3yQSkwxYPcHl1PG8PvBh0prnF7tJ7QsGhZ+iXvIkwCXn1MmefZ7OY7wjctEjdataECnpb1/DoNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584801; c=relaxed/simple;
	bh=saU0+rag3xXF2/z4L9d0pyohkblMwsyLsKfPnspMwVQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aDpVRWd31IrG9cLUMqdZNu62Qdq3s8ClxiELrO0TN/z+o3mQZEFmBLowsF2X/dwKNFM9WBejWF2AxCeWrjKcg6BsQ2Cn8AARp7vPJmWITsNvq/T+6p/chddbTS06Z4MqNn/G5cydIVY8CGzy6yuoSc+psm3uASw++ZBpCG5Cjwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L5KIvfnt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L5KIvfnt"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e1346983c8so1278269a91.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584800; x=1729189600; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iay4RI/uPKTQE0By5qqA//dP+sG5w7++36T/RHxbCNM=;
        b=L5KIvfntXXbkyCJ7PZgNX+0mcDKkxi/20xZ2TMRQP7xpQJWu+yY7b300paM+UOLo6u
         npCtw00z2EOj67WDAIXSGtmewUz82yvmgSgn6RQ/CRltmQSvWRrxoF/qnpHPi1FAuOBq
         kPjxIeMSXQRIE3N3NcQ7pr1pVZidAFptiE3i49Ec2He4uASjpJ8bjaW5uywWpvtChTVl
         IU3aQvH7cngGzOeTrrV9Ix6bZpniG2cAzNnOQlowpJuaO1+GA5bNy+qfkQ9/BeXiVVZQ
         O4fQv22gt3FZIlBMzBYHioE0KcX8/WgnP5Krr0DYV7PIKBwTIs+mxzxZ3HU55pAtD4aT
         QnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584800; x=1729189600;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iay4RI/uPKTQE0By5qqA//dP+sG5w7++36T/RHxbCNM=;
        b=wFWM573RttuoitnE0zWJwdhfDfTw1VsSZ4/PWQM1m8b7lLKkvN3QREPbzSvrzajNxb
         cQWc4vmRspdCd+kDsFdje0Q9ZQOla0KjBLbk26ACFKcizL3A6bQRdOT41nK19Ezpptr8
         KyN4Kojn9qo4StPqLYUGJfmtNkybx7TCeooC0kj2ktyHBhTvUj85RADPYdMX5+lHPHeI
         T7DfSgxOQnV0HYek0qadw2Hk0/nENaqb6ZpgZ5pWvTwYyW5GUsw0v+y9qRLp99P1/nLT
         BvZs2guqWjZN4ZfG4teEZwP6qlWI0WIzBB9waKMIKZHqJcVPOt11BoV/kg9U76uFUs7c
         WAPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQt64zePry5fBlZu08Qii1dRJJXxK0aL4fjr5wVGONEuIMj4Qo2iYqqG6nsTgURtnjlY3GoDQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8P2IgsQ8FwF0kwmAbUT6laIthaPDu/qO2grIqqkm3UryECXnS
	ERviSpJsp4D8kYbIQSIRJlhGh/PgC59BRVtwhVvdEoNUsZ+xmbKvLXWUc8oQ6mmWGFJH/OhQ2Fo
	Pvw==
X-Google-Smtp-Source: AGHT+IEd4uxjZrUyEQQM0MU+jkiJqh3LQboji5/ZXtrCgOTVgrRv0yMO5ln1NKE0y5PwnoqkXxjnsp8xFDc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fe86:b0:2da:872e:9ea4 with SMTP id
 98e67ed59e1d1-2e2f0d7e9d7mr54a91.3.1728584798284; Thu, 10 Oct 2024 11:26:38
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:52 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-51-seanjc@google.com>
Subject: [PATCH v13 50/85] KVM: VMX: Hold mmu_lock until page is released when
 updating APIC access page
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

Hold mmu_lock across kvm_release_pfn_clean() when refreshing the APIC
access page address to ensure that KVM doesn't mark a page/folio as
accessed after it has been unmapped.  Practically speaking marking a folio
accesses is benign in this scenario, as KVM does hold a reference (it's
really just marking folios dirty that is problematic), but there's no
reason not to be paranoid (moving the APIC access page isn't a hot path),
and no reason to be different from other mmu_notifier-protected flows in
KVM.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a4438358c5e..851be0820e04 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6832,25 +6832,22 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu =
*vcpu)
 		return;
=20
 	read_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
+	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
 		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
-		read_unlock(&vcpu->kvm->mmu_lock);
-		goto out;
-	}
+	else
+		vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
=20
-	vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
-	read_unlock(&vcpu->kvm->mmu_lock);
-
-	/*
-	 * No need for a manual TLB flush at this point, KVM has already done a
-	 * flush if there were SPTEs pointing at the previous page.
-	 */
-out:
 	/*
 	 * Do not pin apic access page in memory, the MMU notifier
 	 * will call us again if it is migrated or swapped out.
 	 */
 	kvm_release_pfn_clean(pfn);
+
+	/*
+	 * No need for a manual TLB flush at this point, KVM has already done a
+	 * flush if there were SPTEs pointing at the previous page.
+	 */
+	read_unlock(&vcpu->kvm->mmu_lock);
 }
=20
 void vmx_hwapic_isr_update(int max_isr)
--=20
2.47.0.rc1.288.g06298d1525-goog

