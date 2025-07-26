Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5244B9460
	for <kvmarm@lists.linux.dev>; Sat, 26 Jul 2025 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753544742; cv=none; b=IW1yxakbSByIECJvzAQ7zOaYbhqoxctf5oqmWOuJy2IguhCWjLHizwH9ys+TZ4Rf9cshEHPc86L1Si+rkaHVsv6wpmJj4dUB3CLF09JDcQZfd/4LjUhJO2MV0Nhs9dtfEbBnfHZI4spJp/UmBpdGyy0FrYCsnorOcm2J3dhfG8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753544742; c=relaxed/simple;
	bh=2ZezxNf/ACEep1W7xV579Nt7sMMYBbyBFBlLoRMWdCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hx1/WLCvJ2oTlnqo0OFNT8V8E0q80PjwQxUglxKvzKiPxalJhliEviZ66175+iFhQ6HaMKaTKzacSyXTJhgtoqg9y0nY6yX+deg66k6spD+0NYkS/0aUvyxKcg/S/O0mSyxEdjjLMuzNlRhNy7eoZ5dS5mzULKl/SsV/prHIUnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uS2JpY/4; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uS2JpY/4"
Date: Sat, 26 Jul 2025 08:45:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753544733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8BO+S3QnhY8a+UuXqlAG5cu72jUDR/q2m/Q+0iSC3y0=;
	b=uS2JpY/4QNqZ9Ahl2+aNTVty2IQiWwXqV/2LWD9r0yGz5F5Z+RhDpBd3lUbN07Vtwba38c
	tn2Q77Bsvj/wpvTcCWmxULkB7Ckg0L0VrXqz92w7eMf+qtDTVaanPQdaqhh97z+vQroF3a
	0M85kFOvq2bddXeuhKHZ5jr+dTxTfyc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eauger@redhat.com>,
	Ben Horgan <ben.horgan@arm.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v5 4/6] KVM: arm64: vgic-v3: Allow userspace to write
 GICD_TYPER2.nASSGIcap
Message-ID: <aIT4Ek_DqdioF0u1@linux.dev>
References: <20250724062805.2658919-1-oliver.upton@linux.dev>
 <20250724062805.2658919-5-oliver.upton@linux.dev>
 <CAJHc60wXquZzFNP+ekWZeVKAYkrB8eG+16c-LWLYX75NpYd03g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60wXquZzFNP+ekWZeVKAYkrB8eG+16c-LWLYX75NpYd03g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 25, 2025 at 03:53:23PM -0700, Raghavendra Rao Ananta wrote:
> Hi Oliver,
> 
> On Wed, Jul 23, 2025 at 11:28 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > From: Raghavendra Rao Ananta <rananta@google.com>
> >
> > KVM unconditionally advertises GICD_TYPER2.nASSGIcap (which internally
> > implies vSGIs) on GICv4.1 systems. Allow userspace to change whether a
> > VM supports the feature. Only allow changes prior to VGIC initialization
> > as at that point vPEs need to be allocated for the VM.
> >
> > For convenience, bundle support for vLPIs and vSGIs behind this feature,
> > allowing userspace to control vPE allocation for VMs in environments
> > that may be constrained on vPE IDs.
> >
> Is the "bundling vLPI and vSGI" part missing from this series? Unless
> I'm using a wrong base, we call vgic_v4_init() if
> vgic_supports_direct_irqs(), which will be true even if userspace
> turned off GICD_TYPER2.nASSGIcap. Am I missing something?

Nope, squashing this into the patch:

diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 96048ec59d0d..fb6d7c098ae6 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -375,7 +375,15 @@ bool vgic_supports_direct_sgis(struct kvm *kvm);
 
 static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
 {
-	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+	/*
+	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
+	 * indirectly allowing userspace to control whether or not vPEs are
+	 * allocated for the VM.
+	 */
+	if (system_supports_direct_sgis())
+		return vgic_supports_direct_sgis(kvm);
+
+	return vgic_supports_direct_msis(kvm);
 }
 
 int vgic_v4_init(struct kvm *kvm);
