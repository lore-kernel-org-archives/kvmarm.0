Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795605067;
	b=kaOKxyDGES6UOjnVSGudOLPYVilBHrdpwPpqCS57RTOg+NLxcR+4cVh1bnwl4eQQX5S8
	 slC7xuCJ8KMtmtUnAF4ykzTeigivibcdqsJpfnK61J6ajo5sEkBzyVjI1Olb5DH3k0qj5
	 TVeY9Xzkzje3VlpLpCpHMhSncf6a8YK9VkhQZ7m6XjZDPmIpd6b3Q+5eMUWm0n91SB1un
	 t9+ikGHjmH4b64qvzI/ywJkR4TvgiCkTw3UQ/ZYk/6nzH8WbWvmpSlGSebeDKpiSwAAr1
	 +7lnfAaAvp+/ujQYBNT1d6tyQGc08udCj7xFfctMUlX7eBKQi/KjYMIZEK+Z68SSLYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795605067;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=GwYSD6vLytxfk/SaYw157pRt5ax2r3pG88K3W/iLqQE=;
	b=DxvOzoV7DCIXuDX2xG3jlLD5LwRMrq3ssI/dyLs2EsjZsHeKXe7WKpDyOYgIVkc6Tkkg
	 zLRaxdwiZ/joB2r7UyCtm20TDamsif3d65S6bzCrt/Us+PBFUWX9WtRqP2dFx8cVY0Hbe
	 S7ksPsIpzCleJYnoQmjGprq6xeVA3i6kAXQChBgn1o5VPMhysD+Af05RDaEWADCYE96h3
	 paGcXFu88NDBvofxgEQwZKutxITX9UMydotbpBUBNfGl/liYUPMvdTQUuLqkJcmFZO3Mx
	 ZT1/a8TqwOVd+sVtOuHu8rAbEl3kAQSYD93fVAk5qgnokqGI+KZg5J/FXzcsWKm1IcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=MckuJdil;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDFF606A332
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 11:11:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EDFF606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=MckuJdil
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-492f0a1b685so3887566f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 03:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795605065; x=1796209865; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GwYSD6vLytxfk/SaYw157pRt5ax2r3pG88K3W/iLqQE=;
        b=MckuJdilZGl7PwzDuWSuGXt0stTgiCaUNhvpEr/C7Ps7DUB9KnAtvngWYmAbTXKNJB
         n+mhqgK9fc9nvLU/O6Zig4lhUX4OwAIOOo9/sJPnc/WHAHtOkvjcR9M6mYobGenmZ1/K
         8gG6/SRNfIXo5halpvtnluo3VPtGJsJJ7PjAhLdyOtYYUEC+Fn0c2xNVZ/kvrE+SYliA
         SBGvZTyNofpaJQvO6rQq934OPGh0gQ5Noha2H0TeilvPeeK0XmdU7yUT86JspIkv6KKe
         6puSR2o4XG57s4Y/fm2i8mu1L4jZ6xMRw4cJwnqxZ7qFvQakE7oeFUnHipr/cwlgBrnL
         pHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795605065; x=1796209865;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GwYSD6vLytxfk/SaYw157pRt5ax2r3pG88K3W/iLqQE=;
        b=W10QhPKriTwbyfXoCB4oiBBhVHUKU0ImrI+NZAv0G42Sucju8BumN+TBjxVESOo7tY
         zzxOm8IUuVW5rVkGBlIKf2uL+LJGmvVLz0z1wW8eKKVTQVfNXZ9o4B1ytibQU+q3a+VH
         quuuiDnxPYq5rPzGaZ+kZBDSE+SMnxhqNxb+AySuMHLXnAq8mrp5GFxToUg979s88JwQ
         iforkyxlaOhJDvRuuW60vFKxdOA1NbDAM8NiUgbC3qqi8LdCk/dlgmSywkDg7k1PpTyR
         MX8n5LmwYP3UQ+lt6twDj5QvunAAABwzDyPOiuaBFNLiVaZosMvjpcfhTwpl1uS8Kd6f
         jeLA==
X-Forwarded-Encrypted: i=1; AL+hErHp+CsPJfsz5MKWFuwbIwABYCzv/6U7ve9Y16WI0Z4Xwv+KiOLN5I5JyAQ7YzGhrRsy8XH/a68=@lists.linux.dev
X-Gm-Message-State: APuU4Z8w+HqsNVWhK7vtWldWm4LGX9iLPDT/z55dGB3uyJV3CAIW9kYV
	92MBwrgRoZpeuEQ1InImJnZqTp5rhE/lhqkOF4F5VK1qAJ/HRs9e99lyCfHx5M/Zj2g=
X-Gm-Gg: AZFdTZeLb619DX3IJMsY3KkU95FJaYgCVm0f/iQVQmcakpfot4tGi0AlTGIPh6xqDOP
	+ujC+/4zEpd02AkOEHbY2K7e0uejBamVWbPk5PsyPZ0aFdHzSKEAO36KJs7dZ1AjdN2CRJ0g7DD
	olNGezHDI8EEJUktH8bvY+xX90dl1TtvhSHQcAhANiwE17KQVDExSRU0JXSQenO+khtS5XPu1P0
	4bZXrUN4Mr02VP4KdUuHC7frqJfZbpE5v+ytat8G7Vxb/4qU9fL6csvCb/l4nquucm9gg8EwX0G
	wlU5+kG+O+7yKS6VVpvX3z12lZOzDcQXY5Vybo3HH6abeHGvcGbVOyjoBQP1jttE6nMBbPrFA93
	ZGSfSm/9AlxFO/bSoGp8o4cBZE2XDDdxj0lRSyKJniGjH67kwM9QsjsMWmBcjTwWFfxhvQ9HS0c
	8ZvAfCoZuFnq9aw85yITj9SOImt5tuvTvFRJ6mhE7EXPIvbvc98YXKKVwxv+e8cx08MXnrXtUp1
	qj2Jv7xm4Op5fKJ0LSLU9CbPpAYsie/VPzRSZo+DWfbUUn9Kr0ICIHi3Fr0zXf/lkquaqSOO8Ks
	oYQN7PQ3mfpVfJ5Pqe0=
X-Received: by 2002:a05:600c:3b88:b0:4a1:e672:5721 with SMTP id 5b1f17b1804b1-4bb8880789dmr402949245e9.13.1795605065419;
        Wed, 25 Nov 2026 03:11:05 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bb989e3sm33509812f8f.52.2026.11.25.03.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 03:11:04 -0800 (PST)
Date: Wed, 25 Nov 2026 14:11:01 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Oliver Upton <oupton@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 6/8] KVM: arm64: nv: Don't deliver a pending SError to
 the wrong guest
Message-ID: <awbCRenrEfnRszC_@stanley.mountain>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-6-224689d8a764@pereq.eu>
 <sashiko-outbox-232776@kernel.org>
 <awaWhy3IywYrP2JZ@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awaWhy3IywYrP2JZ@kernel.org>

On Wed, Nov 25, 2026 at 12:04:23AM -0800, Oliver Upton wrote:
> > 
> > [Severity: High]
> > Can stashing NESTED_SERROR_PENDING here cause sleeping in atomic context
> > on the next guest entry when a virtual PMU counter is active?
> > 
> > When L1 has a masked pending SError in HCR_EL2_VSE with HCR_EL2.AMO set
> > and executes ERET into L2, setting NESTED_SERROR_PENDING causes the next
> > iteration of kvm_arch_vcpu_ioctl_run() to re-inject the SError back to
> > vEL2 while preemption is disabled:
> > 
> >   kvm_arch_vcpu_ioctl_run()
> >     preempt_disable()
> >     kvm_nested_flush_hwstate()
> >       kvm_inject_serror_esr()
> >         kvm_inject_nested_serror()
> >           kvm_inject_nested()
> >             preempt_disable()
> >             ...
> >             preempt_enable()
> >             kvm_pmu_nested_transition()
> >               kvm_pmu_create_perf_event()
> 
> The PMU crap should probably go in a vCPU request to avoid this.

Claude is happy to write a commit to do that...  I can add that to
v3.

regards,
dan carpenter

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0614c3b3a40d..6a22156c9107 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -62,6 +62,7 @@
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
 #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
 #define KVM_REQ_RELOAD_GICv5		KVM_ARCH_REQ(12)
+#define KVM_REQ_NESTED_PMU_TRANSITION	KVM_ARCH_REQ(13)
 
 /* Bit indices for kvm_arch::flags */
 enum {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a148e80d0aef..fe5e4e47b935 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1310,6 +1310,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 			return 0;
 
 		check_nested_vcpu_requests(vcpu);
+
+		if (kvm_check_request(KVM_REQ_NESTED_PMU_TRANSITION, vcpu))
+			kvm_pmu_nested_transition(vcpu);
 	}
 
 	return 1;
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 39136a89d74b..ee71dfc4b861 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2837,7 +2837,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	preempt_enable();
 
 	if (kvm_vcpu_has_pmu(vcpu))
-		kvm_pmu_nested_transition(vcpu);
+		kvm_make_request(KVM_REQ_NESTED_PMU_TRANSITION, vcpu);
 }
 
 static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
@@ -2929,7 +2929,7 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	preempt_enable();
 
 	if (kvm_vcpu_has_pmu(vcpu))
-		kvm_pmu_nested_transition(vcpu);
+		kvm_make_request(KVM_REQ_NESTED_PMU_TRANSITION, vcpu);
 
 	return 1;
 }

