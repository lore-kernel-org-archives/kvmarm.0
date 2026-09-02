Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F139493632
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 13:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355375; cv=none; b=m21AlZlnjlPoOZ32KXBo6a7/m5Hr/EUZLAplFJP6qxht1tohTOBXOKHCH6RSGKiHBtTSTSLAvXV2ZIZ1Dh3WvDdSn1LAoscE64d7bttY+IuwnNFVrzg9r5zEw+29qWoBb+PDUFhr+16sDZ05uE0EH33qRTThePlIm3jGVhqdao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355375; c=relaxed/simple;
	bh=ykvs7KzDcNds52UpSQNLo8DYDxovyJzyt1OUd/vPhK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXprykOHJzXdWmqFVKwcHC5uFPrPDp77ARjmRiIwbAg6/8l7dwMVCSEMrk2c6OCkG27gnyZATsUT1S8hFuezJT+AhYFmtyRIeW9Q0j7enLHl5kBAQ2Z+6+u0rK5zoNUvWx82tXCwR1E3LF5zfFVM4xs8J9AcFPpkP0c+U+t0f5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cNvGX83x; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cNvGX83x"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c252c7270faso147715066b.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 06:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788355372; x=1788960172; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UpZHhDtMEGc3JLMXKQwgWRW08IpO1s/vNjepdgWkdhs=;
        b=cNvGX83x9SkVR1cFAB4G5CIJceFGwjGUBCclnq75eA1T07ALgZnS7IKNHvYOsLY6Au
         WhGPUR9x3LOnrhBqbsjXmO/RUg7IDVWRcB/6odQsdLygQS+jEHXS2uL12bpReK1flL5E
         XcloTIT15+RHoC9Ry1PG3Rw4vmROKifBkVH971wfHoF5BLrpT4OP04IZ7INA64erAqbx
         hQZpxOY8TikYy8PSjo0WRjzc0IJzYxNoJYk5juNbJinAYabOKOTghhC3FZqCGbxe5fxS
         G/7emkZonjTfmF2UazKdjEgJ99xsLvCGt+4XN8EA6PAAHMkdeYvPVpjcKFbuZDEsL23c
         S4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788355372; x=1788960172;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UpZHhDtMEGc3JLMXKQwgWRW08IpO1s/vNjepdgWkdhs=;
        b=DUDZLRu9JIdVG0IOweBqVPdEFbtP8U0MuMYqpxFuhOgyEVxSHrW4PMAH2g+Z4G4Qzi
         G9ZecIebhzHSnOGG7Pj6ynrWFDbuJK3EqikZUh5RQUaLR2mup37b1oxEYljMpHVEW7rb
         IM9BHFtGlmAwQkndAqsofhPt0OLyLS8C+xNL2xjEnYhNPydIudsKK4VcZjSKM6S2U/B3
         F08FIkz7E1Tw1NcHaIC9HwjyvVrBYHZa66zGW7I9EL/rQm85egY5f1ItQH1g0uJgI9pb
         u5sSylJX/UfOnxEyUKVtFGvLC8c2DTWaxwrCM4VpG++vOWzsBL+LrUsS8D8uTbzqbHoa
         1bAg==
X-Forwarded-Encrypted: i=1; AKwUvBzVy7irzaT4t1CFZ8AqixBWYu9mx2CMOtNsKk2BbY7cjO8YFS5kaqKT+dUtALgJazTIMyaLlSc=@lists.linux.dev
X-Gm-Message-State: AFuF++kRrau29djrHr2LL1Oex2bZrdxKw/BcbVt6IcT42J4gTrQQEQxA
	vn67pCVS2x/tr29zF8LNRy3QdMcwDQAFwBr25k3CyA25agqIrsZJVmwOnokc9KvJ4/EOuFDlya1
	Ygp/zog==
X-Gm-Gg: AYBFou0zttVcHwtX8JUuvWAyVFfHj6lnBiwwU0mTl+POqEwR5MDbNLwqMYoW2euD+FQ
	zyyfPFlGALHvy28XC9xcbGkU7AKUqLjY31dxtX28ZfJU28BLUZ1WEXO5rUiSuvN25nHeEC4WNxz
	k0nSxxT7E3IKrYmwCNAKBO+tG5rWBhFhggamdozPdaemSRhme1MlCgefjSPQ8eW1gZPM0kqMVG4
	y6EogwWgccmYx6z0b5TjDFwDUOIcbOJoMRSSWeLaP41Z/GTCY8PIyFU8SQhxui4TTdNSICxcT18
	G4qII3c4KLz6v80szbEAhU4cB2KZ5fqhr0NL61t5JEd8th00752706NyCDEwuXxws+oH/jKPSKw
	KXHLCQJBi6peyCyRtUu5olYpLppG+cgv2/8sBhd/yiCWyp1rpRYhb5GAbo6U5OYv2wM2MWWoRUq
	vud/9EJH0xnYXFSBDpl1Y0jjKUfG7ZBWYtF3mCTRfm2QgYY3Te2DTN6r7MExKgokySAbzYtlO/L
	Cs/mS9RPD3lHH/q+/YeltqjcHJqQFBs
X-Received: by 2002:a17:906:ba8b:b0:c25:c14d:1c4d with SMTP id a640c23a62f3a-c25d52b2913mr236962466b.7.1788355370944;
        Wed, 02 Sep 2026 06:22:50 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c25d042efa4sm131923066b.56.2026.09.02.06.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 06:22:49 -0700 (PDT)
Date: Wed, 2 Sep 2026 14:22:45 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 02/17] KVM: arm64: Advertise the capabilities that
 protected VMs support
Message-ID: <apgjJVg0PmS3OudU@google.com>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163421.272420-3-fuad.tabba@linux.dev>

On Mon, Aug 31, 2026 at 05:34:06PM +0100, Fuad Tabba wrote:
> kvm_pkvm_ext_allowed() denies every capability it does not name, so a
> protected VM reports 0 for interfaces it implements: KVM_CHECK_EXTENSION
> denies KVM_CAP_ONE_REG while KVM_{GET,SET}_ONE_REG stage the guest's
> boot state.
> 
> Allow the capabilities that work for a protected guest, the vGIC and
> the I/O bus being host-managed, subject to the restrictions the rest of
> this series adds.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pkvm.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index beea00e693a0a..c4c834d55e503 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -42,6 +42,15 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_VM_IPA_SIZE:
>  	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> +	case KVM_CAP_ONE_REG:

Shouldn't we bring the VCPU_PKVM_FINALIZED restriction in kvm_arch_vcpu_ioctl()
first before we allow SET_ONE_REG/GET_ONE_REG?

> +	case KVM_CAP_MP_STATE:
> +	case KVM_CAP_VCPU_EVENTS:
> +	case KVM_CAP_VCPU_ATTRIBUTES:
> +	case KVM_CAP_IMMEDIATE_EXIT:
> +	case KVM_CAP_IOEVENTFD:
> +	case KVM_CAP_IRQFD_RESAMPLE:
> +	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
> +	case KVM_CAP_ARM_INJECT_SERROR_ESR:
>  		return true;
>  	case KVM_CAP_ARM_MTE:
>  		return false;
> -- 
> 2.39.5
> 
