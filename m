Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793040901;
	b=rhOM/nyF23XH1Tfgf1aKeLVPavcFAdofL9y2B0T0POU5bSoOYWsdC11kLwu1EwTOdn2G
	 7JahcPxHMjJagRDJWnsPGQXwvu8o263kl705KATbRqnIHU3JiJq6mF4OTvksZvMBqJEFl
	 zJa/bL+ZRcRCzOfoS0AkSGrJ4zkiti+EYL1twbdrJ0Bjn3WsXHvZgDLlLVe5P5nu0bTag
	 N6jA94wZbhy7JO3E5K2LNfBHNdzEoH1a5I4qMyWL0ICljzmKwlfxu8rPVpNQF2efOZuip
	 6Q0d34bAKFBKWZRB7KV77dMxz/51RQ2DM0gfz+EhePrJQTWprBPa3KmteKHVmw7ouzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793040901;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=tmyLomRU3odEzGMBEnqER8cvULIdSR4sKslKh+g3oUA=;
	b=yFjiO86zUKkttadDBfFnPDyb9Y93dQH/7h0kMUOrG8JsxbXsbgI6EWQW94bGxorngnkp
	 MB6Ff5vhjzKRMLIjP4Y9RDm7GzN37sg/tYJ2XPzoCce8C121YkapTzboPlIe8hf+i4bI3
	 lWhJlOaRiaRgXqNNpfp7ftRwJwiuLaucbrp9lXs7z5QSV789v2MTqZUq+u96Q6HbrboSr
	 dXgOzNCVC1/QkjGuKFbxaP6+Fxa2p8ljkcJ8TFhENodgge+YaTx1AyEf1nVi/hzIfRv1P
	 Rddpi5/ZwQt7sd82qtB6X0Ls//q8WZE1FqapjXEeIy26dMnZjUrDxqrfrkHw4fovnFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MKxOxvJU;
	arc=none smtp.remote-ip=91.218.175.119
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B952E606A31E
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 18:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B952E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MKxOxvJU
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=MoHfFpJAFkB5Xy3qYToV+bmZRv6HdYN4+v8GE4amOTE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793040898; v=1; x=1793645698;
 b=MKxOxvJUymBaoICRBVHE8CkSTyiws//AePVONplPZC7gGJsRbZa1fJKisl4NAkL2duqW7bY7
 KYeCoaok5Lcm4B2AvsPjHAWTa5fKjTRDdwdb6+GxC7XzFRM8ezYawDPQVXKSmO755TCfWtGCVU+
 mShkrBkW9N8bL98z5WSfw9Y0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e74aae6e57de7d3b;
	Mon, 26 Oct 2026 18:54:58 +0000
X-Mizu-Trace-ID: e74aae6e57de7d3b
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso1578e87.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 11:54:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwHFjDgCtaxOGNI0eTNXKK+zIEmg6yfak/DTRfcvFUYfeZ61YvBPpsi/Yu2bkX/J5Cjy9OISro=@lists.linux.dev
X-Gm-Message-State: AFq9FYLeoYv2K7j56oiU+ghnCvZqH225YTz5Ao/hZGwYb7MKcSlxAz0+
	QzlB+vmBCZV3+lx2OPsDzKc4uZxwR9QiEj+vKjzxCK2DoxJpSx/Y1cvDM9cQjkwJgX6Z4sOr0/f
	hwvbZqILlfEaSgTFLBqO8wYTrxDesy7sj6+wIn5vw
X-Received: by 2002:a05:6512:691:b0:5bf:a5c1:d20 with SMTP id
 2adb3069b0e04-5bfb7a0c36bmr234023e87.16.1793040892816; Mon, 26 Oct 2026
 11:54:52 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261025075138.2919734-1-fuad.tabba@linux.dev>
 <20261025075138.2919734-4-fuad.tabba@linux.dev> <4066f726-310c-4168-bc06-1502740703db@app.fastmail.com>
In-Reply-To: <4066f726-310c-4168-bc06-1502740703db@app.fastmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 26 Oct 2026 18:54:16 +0000
X-Gmail-Original-Message-ID: <CA+EHjTx8Yy0eYQauYX7CYR1TFbJXLFJBssNfWtr72s=azLFY0g@mail.gmail.com>
X-Gm-Features: AclHuK__ZiaYmPESVb1fdiC9S92LDB2sGT2vZe3GOgGEAspZkMFDfe1sVpLPpQk
Message-ID: <CA+EHjTx8Yy0eYQauYX7CYR1TFbJXLFJBssNfWtr72s=azLFY0g@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] KVM: arm64: Add context-switch of ACCDATA_EL1
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Zhou Wang <wangzhou1@hisilicon.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Oct 2026 at 17:33, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sun, Oct 25, 2026, at 08:51, Fuad Tabba wrote:
> >       return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
> >  }
> >
> > +static inline bool ctxt_has_accdata(struct kvm_cpu_context *ctxt)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     /* The host never uses ACCDATA_EL1 */
> > +     if (!cpus_have_final_cap(ARM64_HAS_LS64_ACCDATA) ||
> > !ctxt_is_guest(ctxt))
> > +             return false;
>
> Maybe add a wrapper for this as we have for other features?

Thanks Arnd. Makes sense, I'll do this if I respin.

Cheers,
/fuad
