Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795861441;
	b=q2vYhD/FsMF2+0q0lqWb5jh7kjr32RAJ4pueXZwSLLlaIOyp+ASjDYcRMkYyqAsaFl1G
	 53nYn0P3a5XFDWwunMxWdGmQCOhsdlL/Sia7sRxwfuN8oY+9lLvY3+8tcDqU/elLoDlBs
	 P+EIdk8b0DDCcVBMBKceIaboa/PJY5Ugvb1izV7Y3ypMKEKoOeO7aw2ay+MRYMxzbdkM0
	 erqHkqgMbcvngDI+g7edtRcx4pfChKLVEF5rLahAuQUtehFhbXx/9SDz3vn+QlWjbewtM
	 pr4uuJO1eeOP7NVnyzgYc3+fUcX/cQdsjuIQcBJlQKL0md4vR15ham4DDvTwD6HmTpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795861441;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=8q0lR6QsKstdpDF4gJX9VbdnKsOKt9hZucknTnB2NSs=;
	b=D88A9kOKRp2mqi4v3dkqHOevbwxHzpiQe/7otRRuPndkN9gXXt/TnVjIGQ23zUk95AvO
	 YJWaiS65iFoOuBChILiDDUJY6ODWXsRqdNa3ZzstqBvrX6keUVBZ89tL+mli97lw/ZzZD
	 3iledUdhADVwnR8Yq9138tTBQSCe/NXS39VesDEoR2pH0AQj15CuzeAv9g+mGJwBen/6/
	 nbv2fBthsMG4lbAF8ZoTHQQByArbT7Zq5XdAGRt4VylKQbFMR27Y/lxV+O4Iggp3pRN5Z
	 m7IyaZTqZJ151Klp/d3wzfwKug/CmU2nvHVEI+FZat3zeiEQU4LTKE08qte1ApC8JCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Mi3UhtNu;
	arc=none smtp.remote-ip=95.215.58.184
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03983606A326
	for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 10:24:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03983606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Mi3UhtNu
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8q0lR6QsKstdpDF4gJX9VbdnKsOKt9hZucknTnB2NSs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795861439; v=1; x=1796466239;
 b=Mi3UhtNuTTf7N4V+S9P+nLOMu0jB7HCGPb4JqpAXaZnIV63abR4M2MIc/LnI7RCU5KVs32VS
 +wXgzMWwPvEST43wxZR/xBwDRUOxMsVN9MJFmJWIfokpq8RRvRIVRUFBwikU7I4/J+RQ9lj8mEA
 jaS4ftD/zMiRniT5wdKjUVuA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 31c04bc271fb9e7c;
	Sat, 28 Nov 2026 10:23:58 +0000
X-Mizu-Trace-ID: 31c04bc271fb9e7c
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so48826e87.1
        for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 02:23:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHcpKypnKdfD6s8CAU/saEDIVtjyqyW4j9MNJsxXRiRnQQGRMvKt+R8wn8q2H4LwoHc1UQMUys=@lists.linux.dev
X-Gm-Message-State: APuU4Z9A9A/opGIZOD3NfkRbndeLwNjXI+vefbdjCBFtza4Bvzsw8CGM
	nfVBtyM4TSg4bdn1nO3SCwzNtfp10vPl2fNv8Zo9lju0prDRtztiOzs+36AK7pr5vGN+I5CiWQr
	qYpUTTXSftUvIcGlCzoS8IYiYICOpbbkI2184qWhu
X-Received: by 2002:a05:6512:a84:b0:5c1:5bc5:f373 with SMTP id
 2adb3069b0e04-5c222dc93ccmr890373e87.15.1795861436887; Sat, 28 Nov 2026
 02:23:56 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261127212743.1139739-1-vdonnefort@google.com> <86se0lxpti.wl-maz@kernel.org>
In-Reply-To: <86se0lxpti.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sat, 28 Nov 2026 10:23:20 +0000
X-Gmail-Original-Message-ID: <CA+EHjTy15GC3=c7MvQu7eKON1g-v8KFzYXruoTfWvoSdBOnMCA@mail.gmail.com>
X-Gm-Features: Aa3M54rBUeM9GDr14iZtDQNqhNurSw8bWhfxNqaGvkRf8d9q6kTODFktkvbCXtk
Message-ID: <CA+EHjTy15GC3=c7MvQu7eKON1g-v8KFzYXruoTfWvoSdBOnMCA@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: Use CNTPCT_EL0 for hyp trace clock
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sat, 28 Nov 2026 09:34:01 +0000, Marc Zyngier <maz@kernel.org> wrote:
> On Fri, 27 Nov 2026 21:27:43 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > trace_hyp_clock() reads the virtual counter (CNTVCT_EL0). Under nVHE
> > (and pKVM without hVHE), loading a guest with a non-zero offset applies
> > that offset to CNTVCT_EL0, corrupting the trace timestamps. Use
> > CNTPCT_EL0 instead.
>
> pKVM mandates CNTVOFF_EL2 being 0. Has that changed?

Not for non-protected VMs. flush_hyp_timer_state() zeroes CNTVOFF_EL2
only for a protected vCPU, and a non-protected VM in pKVM uses the
offset the host sets. Without hVHE, the hypervisor's CNTVCT_EL0 reads
then include that offset. I saw the trace timestamps jump on QEMU with
pKVM on a cortex-a57, running a non-protected guest.

Cheers,
/fuad
