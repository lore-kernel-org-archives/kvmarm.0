Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795614817;
	b=L1KCv617Sils+ZT3ji044RivgnBRMtR0B26EO0Tue+TwjUrzzKjGnUhxyyAQZx9JTMWT
	 xoyEMKqNHLJ78h/zw1AUHj3H3Oya67TKYduBQNxOVNkQuFil2hmVagmw15r9xWmjT6zhf
	 TjtYpmIWjUAM0t2ZZW2CU/sgHLz7NPPJ+6+WaP9sVHtD3LioUGvEYaRn1a8RgOsnVZMO0
	 kFW0TySsbLtlkDimr66FicwFtyLBTp8593rDKT+RNowpiPQQCF4URtfy/lNTOy2dTe9CQ
	 iQBCBrtGlK/6hjhIPyVQmA1I8cT0w4ca/PiRhSv1Y0CzuFKBg+VK/OjX/EzC6MLzwOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795614817;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=aH55NiX2a/SA+oD0Oeq4Y47QPgIDSKWhq0w/WbtTOI0=;
	b=tbdYE6NopW4Sa4XOLt9WgB8ZefCfNBVf59/La2o0CMvYg/TV5mkositRqSPapS65x1B7
	 y5v7GR56oo/Ohkmx2hOVEIMwCtgWu/dW0kSeyMEXkKEBGHCwoDIgCPpIAdD9XmMZV704V
	 P/RWMoaTlS2wVDKBpouLrS8Tsif1BghQTiKuxE15Zzx55wdwBshOJXFYZN8NjbH6xbeZl
	 bJ5mHe2yfQ+LZc52/db8O1inhPJlSUP2wZpsOxXYQtooSfLDRXgp83VoMiEXtEz3+mqVd
	 ivuHP6yhEpzImwNa4ijlcwLk70Ulr3wrafxLMv7lIRPxweroGKtBC2/8jEUuCiwpufg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NrShdBVu;
	arc=none smtp.remote-ip=91.218.175.9
Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C28606A323
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 13:53:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2C28606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NrShdBVu
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9WYcE6svL1h2f7ShCzoNWwa4kf1l8t+7Q66Xq3PWLZ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795614814; v=1; x=1796219614;
 b=NrShdBVu24E/2G1gCMd1Zh2KLdL6fUiH206ihe1KdFHrZGU5vN3Qh3lOVi6CQ2D/2ox4BQH3
 bvniF+96M2A0+srwI9yIzzyP4sf042hLkgCoduo8Pmc8JH97F+74F+HgUlzX9rAsvBXrev6Fgoj
 z1PwSmGrRD9h3gTkYsPgoFIA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 73254bc1500febb3;
	Wed, 25 Nov 2026 13:53:34 +0000
X-Mizu-Trace-ID: 73254bc1500febb3
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so35552e87.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 05:53:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGDcc9T9m+avkgMDguGne5NWWXRVNcFK7lNNiHrfanVFQ5X2YGhCEFGL/4RyX+/Q0IhGLrQu4Y=@lists.linux.dev
X-Gm-Message-State: APuU4Z+PvF9dOJCg9FCwc2QG0jbqoMKH/fVpd3w0pLpiW/L+vd8pcYMj
	cZ57eK2h640H57c5qlJ/uuXR9hNCrVjH+t+CSaBAAb9iViatR3VrVwwurybfMtZ/sL8UqEwzTAw
	rmMagY1w5HIX03nx/SZMDOhmI1+eGXomhxA55PPQM
X-Received: by 2002:a05:6512:32c8:b0:5bf:b994:6598 with SMTP id
 2adb3069b0e04-5c21a1ebb99mr621844e87.6.1795614809420; Wed, 25 Nov 2026
 05:53:29 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261125-serror-drop-mmio-v1-1-48076f59608c@pereq.eu>
In-Reply-To: <20261125-serror-drop-mmio-v1-1-48076f59608c@pereq.eu>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 25 Nov 2026 13:52:53 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwi=nFyBKKT_beb60DHU8N98yGQsNHcFRSdc3Vcu7D24w@mail.gmail.com>
X-Gm-Features: Aa3M54oa45Yf8ZzkxiwBUpIGq4vzhnviD6_znnFluRk0qwP1-ULSP3dGz3j6rgc
Message-ID: <CA+EHjTwi=nFyBKKT_beb60DHU8N98yGQsNHcFRSdc3Vcu7D24w@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Drop a pending MMIO access when injecting an
 unmasked SError
To: Dan Carpenter <dan@pereq.eu>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Karthik Bhargavan <karthik@pereq.eu>, =?UTF-8?Q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Dan,

On Wed, 25 Nov 2026 12:26:47 +0000, Dan Carpenter <dan@pereq.eu> wrote:
[...]
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 1d5dfd4b9e00..91b835bc939b 100644
[...]
> @@ -396,6 +396,14 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
>                  return 1;
>          }
>
> +        /*
> +         * Like the emulated entry above, an unmasked SError cancels the MMIO
> +         * access the vcpu exited on.  The host's copy of a protected vcpu's
> +         * PSTATE is stale so checking serror_is_masked() doesn't make sense.
> +         */
> +        if (!vcpu_is_protected(vcpu) && !serror_is_masked(vcpu))
> +                vcpu->mmio_needed = false;

Could you check PSTATE.A directly instead of calling
serror_is_masked()? That helper treats SCTLR2_EL1.NMEA=1 as unmasked,
but NMEA doesn't affect a virtual SError. With NMEA and PSTATE.A both
set, the patch would drop the access while the SError stays pending.

Checking PSTATE.A also covers protected vCPUs, since EL2 always sets A
in the host's copy of a protected vCPU's PSTATE (pvm_host_pstate()).
You can then drop the vcpu_is_protected() check. Something like:

        if (!(*vcpu_cpsr(vcpu) & PSR_A_BIT))
                vcpu->mmio_needed = false;

Cheers,
/fuad
