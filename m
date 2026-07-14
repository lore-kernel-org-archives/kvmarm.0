Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A367218AB9
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 15:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784043229; cv=none; b=GHecGMjIJKUd58jmh4/pJSHWPiCiDmIovV7eeuzA/sbBSpls9quy6mCyZi+Sd1+Pw8djv5PX/Lcsfo4ePN0JvQ2fl7uvT10Q9KqnC/LumPlpcdJhQYkRxABsyDuT7s+soiPAE2v9vLk7N1lPvrRogYeLlkBwqZEnWnTtt5/U24Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784043229; c=relaxed/simple;
	bh=eG91+bv2vyh2Hnc4hWF4ZskZXcHMjf14hBLUqmDDn9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kgs+gIVZ6IS3S9kyk1LJT2etIy3lSMN62UU7hJj/M1dzED9cUW5Aecl4C6X7kC1lXCjiI/+85L/AYEpamwn0T7/fU/RTS7hZXyZTYsVvlY6a3ERcPSGnIw1ILjbgsX5/lxq0zgwK1lCdqFZWiO6BmDqy+9lrIDk+t3/3rGDMSMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xR+BsxDX; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xR+BsxDX"
X-Forwarded-Encrypted: i=1; AHgh+RrBHIAuK0A7FruTsZ0wXpNk1GOwuIHvqsUAjS0R3Fluz9GElU/2pp03NHR2IsMtKgdKMnwqIfc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784043224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BZdDvcbVUY0wf06jzcxyJ90I8hA4T+lqgVYKj078dgw=;
	b=xR+BsxDXKVFDbHc3tGXZI/x2eqyp5YMbIY+3O+1i9+15M0eDOJmxLUDVLRQAIAmGiTB9zb
	+uFGjiaTOwQI5dyStkS1Zs6iH3hgrUFbN7ymNIlmm5w4yp2qSzWu4ZUArIQ35Og+vzTYTo
	JakoVqMIRQ/HsnrJIwfwSJQAk64y+nc=
X-Gm-Message-State: AOJu0YyqwdlKSzIS8QiwkaIIt6u1Woj4ZUW/cPJnL5HBPkGSnoUuLuho
	KX5NxsUQmT7jUrJPCDztwoKKEYz4bHT0ueWGukyPNli05mCZ0GzMm0vwyt/M+rM4pkl9/rzsy5r
	qLfxRgL4JasqyBwqTK+KJWRbQWIIn+A224XEH4MiI
X-Received: by 2002:a05:622a:4d:b0:51c:ba4f:9d19 with SMTP id
 d75a77b69052e-51d7bd752e0mr15356061cf.19.1784043211209; Tue, 14 Jul 2026
 08:33:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-3-fuad.tabba@linux.dev> <86ik6hoayl.wl-maz@kernel.org>
In-Reply-To: <86ik6hoayl.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 16:32:54 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxtOhC=f0K=j-ka5A0nPtU0S_5vbnZcVhTOViHX6WMi=Q@mail.gmail.com>
X-Gm-Features: AUfX_mwAx_QJ703w6ns4jZBt5m8oNM38s2iIEmAgXjvj9wCMZI3UVlbYVuuMlt4
Message-ID: <CA+EHjTxtOhC=f0K=j-ka5A0nPtU0S_5vbnZcVhTOViHX6WMi=Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 14 Jul 2026 at 16:19, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 14 Jul 2026 11:15:55 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > The vcpu_{read,write}_sys_reg() accessors are only valid on a VHE host,
> > so helpers built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be()
> > cannot be shared with hyp code. exception.c already wraps them in local
> > helpers that pick the host- or hyp-side accessor via has_vhe().
> >
> > Rename the host-only implementations to __vcpu_{read,write}_sysreg_vhe()
>
> I'm a bit puzzled by this. There is nothing that makes these functions
> VHE-specific. Look at where they are called from: plenty of non-VHE
> uses. These helpers are the canonical accessors for any system
> register, and they don't cater for any particular mode.

I might have misunderstood what Oliver asked me to do here [1]:
> Can you instead name the wrappers vcpu_{read,write}_sys_reg() and rename
> the current implementations, like __vcpu_{read,write}_sysreg_vhe()?

Since they're only used and gated by has_vhe(), they're vhe-specific?

Cheers,
/fuad

[1] https://lore.kernel.org/all/alWDI7uj9YFedXET@kernel.org/


>
>         m.
>
> --
> Without deviation from the norm, progress is not possible.
