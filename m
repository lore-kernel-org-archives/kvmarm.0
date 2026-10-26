Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.166
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793034633;
	b=QaSNaJ2NXacNLyGRtuuYbw6PogOBMHB0miYqFXaYfR7C03ZkPqgaEM23PRYwY2H/8dbb
	 CFVDfbIDa96bWabFVh2TbTNwMldzbVR4R104BRql8njs7uQzmrdJgTqtPhLFf7/v6i/Us
	 bDD5LaHLz2a7zVW1clgAiFwUA4YoodBwgDu/vMLrDwgTjs4k1Dj5VpfuuHwdocXQdG26W
	 f++zMJX0VrVp0gw+ShGm4aPuGj5tPA1LyUp2zk+mgfbYx4HI3reMRWdK4v96wNouB7XXl
	 FBp/K53sytDz7eKKoXiDq3EcflTb4wCQZ1Tw+UVNjGs8UqjqTp5iQuHbq7yF9FrtkZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793034633;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=PYgl4/AlR9E7qD/6t01/AqAhjtHt2uKRS8XnGrG05+A=;
	b=J9trbNytyaXceJWSk1kOL+MSfuKgFuXjFLanJS2gNTKriUxzE58mFyMxdviSxL5Ue1YM
	 HV/8bWR0AIu4WRPMJ3fk4wWpUZjss2rnTHqB3268NccFdPQtJd5IwEEALdvhTUu9I8a2N
	 DgtdsN6D+VLqSMtwWWPIpxP2T0Kx+ObhtwxclHv6MSOeoI2Zf1zJ0gzOS9mm+ppR+Luf2
	 38oYb3iy3JgJ2gUuAoY1thVjoNd2WGgnsn+wJYNlCHBefomUunfgq1LcrndXsg5g6Ffy3
	 EoOj6uRbeDvaWG1GqE7wYuxyb65hPF5+2d6H/fBJRkJ7THDDKUm22UPVBrMQUQLk9Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IvwcoIFU;
	arc=none smtp.remote-ip=91.218.175.166
Received: from mta0.migadu.com (out-166.mta0.migadu.com [91.218.175.166])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D7C606A31E
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 17:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42D7C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IvwcoIFU
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=pcthy6ORiWzW3EmGLV8zsnkU+qv48Vriy9rB5HlVHlU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793034629; v=1; x=1793639429;
 b=IvwcoIFUwnmW6X8wZFE90I/ZGEzZdt3lwnKHTcY0+9LG9Mtcg7nt7cEoqLCdMBmRRfD0LhWM
 JVLhwl5jKMKRCSYivSEJwdUT/jyAuzwbyolm8peKQwGdCOLlGRjVz+wcQUY1x8mEmWJ/B+cRdG6
 H2w+V2lRGYQSeRzRfQNIHgbk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9244c89ac0858588;
	Mon, 26 Oct 2026 17:10:28 +0000
X-Mizu-Trace-ID: 9244c89ac0858588
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so221e87.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 10:10:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzPqCUI26tt84qECGQO2UImjdpaHCPa6pS1uZduA2J25jrHHLww6/XcnTHbXk2ADU70GwXgsQM=@lists.linux.dev
X-Gm-Message-State: AFq9FYIb3tDxxA+7L69pEwztoQ/u/sXPrmjJK6sMNMROCIi+xWL6eASn
	6TVHW27nXF1F4N2a/K5Fu/L5aJRgvFARQrehqd4QGkOmn0nVB4w8cYriLxYDEKgWHqJ3Ii79kOn
	mwC8TWbrHuxdS4uJT6wxauLUakvXvmR85axJdkjSG
X-Received: by 2002:a05:6512:130c:b0:5bf:c1d8:b44b with SMTP id
 2adb3069b0e04-5bfc1d8b53amr122078e87.14.1793034623586; Mon, 26 Oct 2026
 10:10:23 -0700 (PDT)
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
 <20261025075138.2919734-4-fuad.tabba@linux.dev> <a86348e5-a55a-4a99-a3c6-24b3213ed3d1@arm.com>
In-Reply-To: <a86348e5-a55a-4a99-a3c6-24b3213ed3d1@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 26 Oct 2026 17:09:47 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxyenZzByhAckimWUSgG5fMFVBwyB8bsC15xaoaU1RPVQ@mail.gmail.com>
X-Gm-Features: AclHuK-pKf8gC2S2-5qJFUs5PfEVBnKKd1_HAZS3RuQB33ufSZ6ApBNWFpRYh6w
Message-ID: <CA+EHjTxyenZzByhAckimWUSgG5fMFVBwyB8bsC15xaoaU1RPVQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] KVM: arm64: Add context-switch of ACCDATA_EL1
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Yicong Yang <yangyicong@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>, 
	Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Oct 2026 at 15:41, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
[...]
> > +static inline bool ctxt_has_accdata(struct kvm_cpu_context *ctxt)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     /* The host never uses ACCDATA_EL1 */
> > +     if (!cpus_have_final_cap(ARM64_HAS_LS64_ACCDATA) || !ctxt_is_guest(ctxt))
> > +             return false;
> > +
> > +     vcpu = ctxt_to_vcpu(ctxt);
> > +     return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA);
>
> minor nit: Aligning with the other kvm_has_feat() usecsaes, should we
> wrap this under kvm_has_accdata() (with moving the cpus_have_final_cap()
> to the wrapper ?)

Thanks Suzuki. I'll do this change if I respin.

Cheers,
/fuad
