Received: from mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020E03BC69E
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 06:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792133224; cv=none; b=aRv4yklmhpMFfNDfWsDWev21q94DEA5vwthYYbhaAfu5pHpgdNhVHENas00DoJV8Tw5K0wsQn9y39TqnMmKcexD3XJVDI2Km5qt3TpfT1kBoijgRleLuTeGzfZyFSwyV1H7NMc+Eklufx2xy1RsYDUbZWcQlP6VX+gZafgAz9Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792133224; c=relaxed/simple;
	bh=Fq2kJAt2D35K+AljUwJE/9dkfpEho8mR0jX5LFexqKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pe9E2+e5wwS3jraoUiSpIAUdrab1CVIjWey0sVFIwKEXEc6Cdt6IlYQKk457FpJgY2RY+qu9E7HSIOV5is1cniv9w3oMEJO6TbTPwhH3dj2yInC5Mhn31TXqRt59aMhipJ5yl1paxl8kCJ75vZMRGm8F11EH7uu2DZg7auzfotg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BTYV6L6H; arc=none smtp.client-ip=91.218.175.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BTYV6L6H"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Fq2kJAt2D35K+AljUwJE/9dkfpEho8mR0jX5LFexqKI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792133203; v=1; x=1792738003;
 b=BTYV6L6Hvr0xPyhRSRaLHS7djWmdPS+1dUeDRUPlgnlCRKjk1y6cR/h2zNhHLryT9VWgLROw
 +fNK88S/Drwe8VLa9NoRHBvo5RSdqSq2MhYdxFPai79Sij53fPx4JZOfq2CrG8rrMOK8zi0RLjX
 SYK7DGao2OXUZooIS5ukEnds=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5fe6585d66fc361e;
	Fri, 16 Oct 2026 06:46:43 +0000
X-Mizu-Trace-ID: 5fe6585d66fc361e
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso2970e87.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 23:46:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwpqw3g/X49ciug5mKGPx/PKKkpIcIBnSlC2Sg9fE4BSyIVTtxFMZkj8Boyt3FxAOOP1XkLofg=@lists.linux.dev
X-Gm-Message-State: AFq9FYL5vzfM2AHa4G1iULPOSdlqm31ucmlLmEPpg/0Q9Akitr/0ENL4
	uMqJKbxMmKrb0DxQUOVrF0qK0ptySalJL4tqD1h/Up2A2x/q7bYltIQ8tuD2nrrVpsotJHTjVXy
	ye+fnBNmE8Ro7fVwBD0K6xpFCW5ENBwJWLjETCwI9
X-Received: by 2002:a05:6512:6816:b0:5bc:ed54:d5b1 with SMTP id
 2adb3069b0e04-5be403b66a5mr223821e87.14.1792133202280; Thu, 15 Oct 2026
 23:46:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261015153041.3770032-1-fuad.tabba@linux.dev> <86h5im29xv.wl-maz@kernel.org>
In-Reply-To: <86h5im29xv.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 16 Oct 2026 07:46:05 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwZCkfj8V4x-VJhB09x4V=R84Zky8fU=ffyWAJNrJYyCw@mail.gmail.com>
X-Gm-Features: AclHuK-Mh0opfYvOg-0ZXaKxljR9jjbWCLN44NxLHz-5KGKDM7ZO10cIFATr3tM
Message-ID: <CA+EHjTwZCkfj8V4x-VJhB09x4V=R84Zky8fU=ffyWAJNrJYyCw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Only enable S1PIE and S1POE for a guest with
 TCR2 and ATS1A
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 15 Oct 2026 17:41:16 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
[...]
> > +static bool feat_s1poe(struct kvm *kvm)
> > +{
> > +        return (kvm_has_feat(kvm, FEAT_S1POE) &&
> > +                kvm_has_feat(kvm, FEAT_TCR2) &&
> > +                kvm_has_feat(kvm, FEAT_ATS1A));
>
> Where's what the relevant bits of the JSON say:
>
> (FEAT_S1POE ==> FEAT_TCR2)
> (FEAT_S1POE ==> FEAT_ATS1A)
> (FEAT_S1POE ==> FEAT_HPDS)
>
> So this is missing an additional check on FEAT_HPDS, which is advertised
> as:
>
> (FEAT_AA64EL1 ==> (FEAT_HPDS <=> (UInt(ID_AA64MMFR1_EL1.HPDS) >= 1)))

Thanks, I'll add the FEAT_HPDS check to feat_s1poe() and respin.

Cheers,
/fuad
