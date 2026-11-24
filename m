Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795513152;
	b=ZrQDkj+35eu8tv7A7f0nNYIg6GPtv1J++Ox41sBk6HFYMi2U/ufMXb8MAv7Shd/hN8U3
	 T/yaSvM4RXrNL36fflbnN2XPF3cMqWkpawewmionp+yMfpZDB1dItLC8N4ZD5wkQXvUJy
	 1e6kM0i0FTI7Rtqi+FpE0dEmc13PeKXPijmoLtuB5CagOEuN4m2eYuJlkOhW/gDPIqw0/
	 wSay9sOGaD7f90TItAHyRFYPUVoII5STWU7dQUv1kamY8FLTCnHNwWln6NIWdOXJteO/i
	 Jw6IR1Tae7FDiccXhD5mmEn1aGnyD/qE1dvxDX2ruNg1A+60AG7gWkFYLQ3m87YRBdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795513152;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=XD3y0uRelfjcM8wuzE5PStYzhtdNUf4TcgUCbGZyLAw=;
	b=ohqLDZBSreW6/38wAfe2M50cOg1KT0k8FBXpeFYIzaS3bmQ3PoCTrt1lanWjSl13Cbhm
	 1sFSg3WfUbmTV6ByteDVKu+HbEgMhbN1aSRU9cR4jvKt9nVLvflAUMR6n4HU7vnAYTJ6n
	 mATwAbCiosaqI0ZAUYObXahm1uGLE2RzXWF7IEWsJocAvASi+dGFjGlLQfpgMImtD49zF
	 kS6hNb+dNU4+wIvb+QAz9Xw7NwVP8Lg1BdGhDsWsOECwA3LYKqWLF93OI4otGW3DMlwD/
	 xmIdLQ/3eInsIdyg1tcXncQmWdmF3DREzi1Zrovb0t2vHU1r+1+pA8bRw1vRYLhmGBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TTLC1Ts4;
	arc=none smtp.remote-ip=91.218.175.43
Received: from mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A22606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 09:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2A22606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TTLC1Ts4
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ilOuyRk+MAIQHiCii2Y/pLuL3MbXC2Pov4MVI4OLeCc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795513149; v=1; x=1796117949;
 b=TTLC1Ts4ajbOG7aZmJd5Vf12BcBQr/n3ehlfk49QoZODCl8YReEuw3L4orRQEniAqBtUJjqo
 YwsWBiRG5Bcj8iJTXmEVfQ0VVC3nQUb5Wli4vUyfMlrWdZY749RzT6pSMeS2RfPIn3A/mlXZ+1z
 nmIBnVuuK8cf51XgvL6+sMjs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1d46e53aaf91c1c3;
	Tue, 24 Nov 2026 09:39:09 +0000
X-Mizu-Trace-ID: 1d46e53aaf91c1c3
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5be58ad9600so22013e87.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 01:39:08 -0800 (PST)
X-Gm-Message-State: APuU4Z8vnAS9SSKOJrOWLpyQkFMp6waxFYeSJWXrO7T4jUNZcvzU6ZRD
	7maFSI5QN/QaZGklj0PxeFSeVaN11FF/Yih6UBWvs1xgNO4Qf6moKkEd1Grcl/kEVLzb0UFdkyT
	DkPCbaTl0380fWndpsuWzW1fKO2vsQOWkwj//DXJm
X-Received: by 2002:a05:6512:3502:b0:5c1:488e:a067 with SMTP id
 2adb3069b0e04-5c200ba538amr329242e87.16.1795513147393; Tue, 24 Nov 2026
 01:39:07 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261123192457.8700-1-maz@kernel.org> <20261123192457.8700-4-maz@kernel.org>
In-Reply-To: <20261123192457.8700-4-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 24 Nov 2026 09:38:00 +0000
X-Gmail-Original-Message-ID: <CA+EHjTynhBzhjrFzd514Sycib=1rmh7JqYp0xSPVBvurk6Sm-A@mail.gmail.com>
X-Gm-Features: Aa3M54oJsiX7PUIr0O3Es9w-Trkkm26FAlvtAIKuj1DU-Bg32tEzMiolqN2nYfU
Message-ID: <CA+EHjTynhBzhjrFzd514Sycib=1rmh7JqYp0xSPVBvurk6Sm-A@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Drop open-coded GIC idreg sanitisation
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 23 Nov 2026 19:24:57 +0000, Marc Zyngier <maz@kernel.org> wrote:
[...]
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
[...]
> @@ -5874,51 +5874,6 @@ static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
[...]
> -                 * On GICv5 hardware that supports FEAT_GCIE_LEGACY we can run
> -                 * both GICv3- and GICv5-based guests. Therefore, we initially
> -                 * present both ID_AA64PFR0.GIC and ID_AA64PFR2.GCIE as IMP to
> -                 * reflect that userspace can create EITHER a vGICv3 or a
> -                 * vGICv5. This is an architecturally invalid combination, of
> -                 * course. Once an in-kernel GIC is created, the sysreg state is
> -                 * updated to reflect the actual, valid configuration.

nit: This comment is the only place that explains why, on a
FEAT_GCIE_LEGACY host, a VM's ID registers can show both GIC and GCIE
as IMP before the VM first runs. sanitise_id_aa64pfr0_el1() and
sanitise_id_aa64pfr2_el1() still set both at reset. Is it worth having
a short version of it next to the tables patch 2 adds?

[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
[...]
> @@ -180,7 +180,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>           * We've now created the GIC. Update the system register state
>           * to accurately reflect what we've created.
>           */
> -        kvm_vgic_finalize_idregs(kvm);
> +        kvm_idregs_enforce_dependencies(kvm);

This now also applies the S1P[IO]E dependencies when the vGIC is
created, at a point where userspace can still write the ID registers.
Was that intended? If this clears S1PIE or S1POE, the first KVM_RUN
doesn't restore it, so the final ID_AA64MMFR3_EL1 can change with the
order in which userspace writes the ID registers and creates the vGIC.
If that's the intent, should it say so in the commit message?

Cheers,
/fuad
