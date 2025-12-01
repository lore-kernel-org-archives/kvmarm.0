Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4F424A049
	for <kvmarm@lists.linux.dev>; Mon,  1 Dec 2025 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764619100; cv=none; b=XPtgqne8JrnfJEHjkX2AWkllm/tkUWAYFjtRl/WK0eOW8uCsgkDdKJSCxu/wiMh4pFwFQMT33/O77U9d1wg8+pdcUf1D1lk84PbJHjDhiyDnzwwZb1QFKcaPO6wbA9UeWc4j0VK/YKinKE1TnDBd0JgTVIPxoNFrCyhwBmHcAKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764619100; c=relaxed/simple;
	bh=RvhQJ/RxnP8LMHIO2HlRZ/Evc3IhzrJOD7HOCowMNBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fn4uoWOKoUctyPTuiGLD7m+YjIJvrdOVHxEW63qmVzAuCWW/qrYj3bnxyqDqDIIsPrxawEcgD5YeUVXTUiLPmqm4vi/FN3/QoEDHQEeQtCq5GUd6pI4zVTHEV++fJcofMkYhFU5FfMXo+WEEgM33NpkjHepnCo/AFoMt24h9OQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WDl+0owB; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WDl+0owB"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b734fcbf1e3so590293566b.3
        for <kvmarm@lists.linux.dev>; Mon, 01 Dec 2025 11:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764619097; x=1765223897; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9NAUitM+MSWweUnE61BNoObWF/ar0jw0l8Av+72afE4=;
        b=WDl+0owBcL9PnFwDHEcc7Jb3Kf2Exqm/rquL2Fzr2dk/ggeo3mJZtBHOrP4b1hlUqk
         1W+2LFog7c2ADmU8HXzyd2zB0FnomWNJsacOFBw+m07FvcnZx8PcpKXQ6t5gdCDoZGmr
         d+RAJ7x0XUGzA+Wch0Sx9CrxxqS5rDUwg4+3sa3FIrQsunwhBYko8SrM6U7mukGIobUo
         r+cQUpXPKHX0EGsNrAl771gAq1UlJV48UZB/ICHBjfvdTpvvLEZAUkioGjwkmeWNxnBI
         BrTw7fkVYwZ7WC7Dd/J9rSLs9nAjA1aK9uJWKXjbF1Wc63y+Y4+71AXI9S2mZbrcf/Tw
         /wyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764619097; x=1765223897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9NAUitM+MSWweUnE61BNoObWF/ar0jw0l8Av+72afE4=;
        b=Zd0qUWB7bexx4JKbC79dU1/Mo68SJkEFjp5CjFfZ8Da9MLHaGpxljMf5zJaP5T9aJQ
         GhvFhjzc2tOninfuVDbaiGHnZcejoklrXJpHBxW4yBLnqFWxq0zmPqkvBsYKprqFFlAD
         8CHTSY8+eVi93SZVaw2U9q5CrLxxkoPw/Z1TOvHp4REusVp9pile5Bgs5TyPdVpVUnJq
         2iXNVFPB9YfIuys/7pXNaPuuGIWBMWapnF+xuudNWAv6EuwH3msLHg7V2FlD0PAIhGtF
         zEYf0fZdIEcrFJa18iC8CNwjEgTBxIFTn8e+EiN7k1zJJzZPLSVkg4IVtcYUTNGOLY2i
         rFAg==
X-Forwarded-Encrypted: i=1; AJvYcCVCuzs0/UNnJL4/9AMs1KpC+L0KSZObcBd1EZ0gD6pXQPhP7VVZ8EzWR1nJYMOaXjRzrN9q5jA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4YGMB5T0EnY/MsnnLW15q5NH0jFaMXhL42PX4ugaFhI1349ae
	y96bt/eSKghiDrucwUCCZEsYUTskQ2mub/P18QUXQSa13z+muYOcSUL442acfIzPsw==
X-Gm-Gg: ASbGncuKTACS/Nn9fv4HvGf/wzkCff6KQdroKR3wtX8vlFLnvddPj51GVj90kAlOJZn
	caVfnehY26SvGjnso2D+MHI77YxENGQOETPuQZCvdoiitbusnslQXpRnDiW3kjPMYze2FGd+vuC
	9CX+I3Cw4ocNHgmo/CjfAlQEULH0ElpJBuxbgl5KijMr9dZt/Uz93KZ5CZLLwZkMkkVGQjbCUqE
	Hz+LnvurFGxc5ifOY+qRtkQ6hrCEZzISTuR4xd/A9Pitqz02bpw4ZxJLgogkhnMuln+EoVKA1xe
	ssEzuQZCYqXXs+tg7qV8Q1xGDv7g+LAemChZR/ir3WogNcC4go9zE+ziWaDvEE3OIPG5RFlHXK7
	frWqtB4/SFUtvzuAX3NmoQRjYyOpTkSlVGfZu142akgWC+dYb6pupeysMAMFLdbwb2boQnfjTIB
	9CdcOb8JC3hOZXg4mgah3wuuZVqnvkB9yteKhBMQy/FpO2OJyJJNxzqQ==
X-Google-Smtp-Source: AGHT+IH2zdDJmxuV1Kx70hy1xujwpWhYPpBA15ctZSpVUkxE7sUPJ7uI1HDSh04+fVoYPr2+q+18ZA==
X-Received: by 2002:a17:907:6d13:b0:b77:18a0:3c8b with SMTP id a640c23a62f3a-b7718a03cd2mr1349980566b.1.1764619096714;
        Mon, 01 Dec 2025 11:58:16 -0800 (PST)
Received: from google.com (214.44.34.34.bc.googleusercontent.com. [34.34.44.214])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f519d883sm1298814466b.17.2025.12.01.11.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 11:58:16 -0800 (PST)
Date: Mon, 1 Dec 2025 19:58:13 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Prevent FWD_TO_USER of SMCCC to pKVM
Message-ID: <oim4q3obyy7jh2juw2qngl4xti6hjg6pavfnm3u3fppa4ao6dq@x7sanj32ttsi>
References: <20251201-smccc-filter-v1-1-b4831416f8a3@google.com>
 <86ms42ox67.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ms42ox67.wl-maz@kernel.org>

Hi Marc,

Thanks for your quick review!

On Mon, Dec 01, 2025 at 06:48:48PM +0000, Marc Zyngier wrote:
> On Mon, 01 Dec 2025 18:19:52 +0000,
> "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com> wrote:
> > 
> > With protected VMs, forwarding guest HVC/SMCs happens at two interfaces:
> > 
> >      pKVM [EL2] <--> KVM [EL1] <--> VMM [EL0]
> > 
> > so it might be possible for EL0 to successfully register with EL1 to
> > handle guest SMCCC calls but never see the KVM_EXIT_HYPERCALL, even if
> > the calls are properly issued by the guest, due to EL2 handling them so
> > that (host) EL1 never gets a chance to exit to EL0.
> > 
> > Instead, avoid that confusing situation and make userspace fail early by
> > disallowing KVM_ARM_VM_SMCCC_FILTER-ing calls from protected guests in
> > the KVM FID range (which pKVM re-uses).
> > 
> > DEN0028 defines 65536 "Vendor Specific Hypervisor Service Calls":
> > 
> > - the first ARM_SMCCC_KVM_NUM_FUNCS (128) can be custom-defined
> > - the following 3 are currently standardized
> > - the rest is "reserved for future expansion"
> > 
> > so reserve them all, like commit 821d935c87bc ("KVM: arm64: Introduce
> > support for userspace SMCCC filtering") with the Arm Architecture Calls.
> 
> I don't think preventing all hypercalls from reaching userspace is
> acceptable from an API perspective. For example, it is highly expected
> that the hypercall that exposes the various MIDR/REVIDR/AIDR that the
> guest can be expected to run on is handled in userspace.
> 
> Given that this hypercall is critical to the correct behaviour of a
> guest in an asymmetric system, you can't really forbid it. If you
> don't want it, that's fine -- don't implement it in your VMM.
> 
> But I fully expect pKVM to inherit the existing APIs by virtue of
> being a KVM backend.
> 
> > Alternatively, we could have only reserved the ARM_SMCCC_KVM_NUM_FUNCS
> > (or even a subset of it) and the "Call UID Query" but that would have
> > risked future conflicts between that uAPI and an extension of the SMCCC
> > or of the pKVM ABI.
> 
> I disagree. The only ones you can legitimately block are the ones that
> are earmarked for pKVM itself (2-63), and only these. Everything else
> should make it to userspace if the guest and the VMM agree to do so.

Sounds good, I'll limit v2 to these FIDs and the "Call UID Query" (unavoidable).

> 
> This is part of the KVM ABI, and pKVM should be fixed.

I agree. In particular on not restricting {S,G}ET_ONE_REG to a point where the
KVM uAPI for SMCCC filtering can't be supported, as some experimental Linux
forks might [1] have done! I couldn't find the corresponding patches on LKML to
contribute this feedback to, so something to keep in mind when they come in :)

[1]: https://r.android.com/q/I1c7bc93ebe0bfb597cca5c4284ceb7fd53e4713c

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks!

-- 
Pierre
