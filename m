Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF76146F4BE
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 14:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791554982; cv=none; b=NhSyQurnS2fdkcf+bMau1xpV9CsEZw/FKUbEaxZORW0QKbzivb5geQG5gWZxvHah9WpmuuHHhy+fYyF2rbuwYWxiIoJcSqZAFqXE/MRlCPDuW8XM8Qpeex1YcM85rXlGj+/v1qP3c23clMvmljlj5Klfwmunk5QK7BSv0FJBpjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791554982; c=relaxed/simple;
	bh=YZrlqAq5CBGEXfb9cK1U8Y1OfFhaqEwDqLAmTfdBu9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BhvpRPjwdCpvYMwXrU5Xm02j3+dTL+9EMxZE77QuofutLA56jSIAbHwFNvePc26+MPUlCwWOrne8qCV4xkx/MISXtPat/bDLP/YPZ01wlJzHGGEcnGhbiYkYhQjRO6v10FM1gW0kYnCgYlyu80gJGObZBidqa9fu1CW2jmpc8Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mYE1sUAC; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mYE1sUAC"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=YZrlqAq5CBGEXfb9cK1U8Y1OfFhaqEwDqLAmTfdBu9s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791554977; v=1; x=1792159777;
 b=mYE1sUACvXrH32UhI31Sscq9BvnahxOemrWuKlrZy+O20WQejNfIMpxI2BQ/pvaa/8Hj9uI5
 7LcRpl4hhUH65MjpbP/L3PzlcN/e1plmIj479c4NIAvN1wKGGJDYpRZn/0tG0OppMLjXFf3WKN9
 Bg332uRpPqucbks/TQVGOUXk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c68494a6f8b3fc2a;
	Fri, 09 Oct 2026 14:09:37 +0000
X-Mizu-Trace-ID: c68494a6f8b3fc2a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so7698e87.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 07:09:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByYdUhW5xXluM09abHtiZnEDWZALAZLbK6ShcfKnzkK6rXFLyx6Ik0iiSFG+SoJ+ekh0bpNZDk=@lists.linux.dev
X-Gm-Message-State: AFq9FYLMzl51vHXBECdZRFtouUJ97NvKGfn2UxAKSFpcJ5pzxTLDb9o9
	bkoAdrZjIMoQsjNZsNx1+KT/ix+gA+LxaGTJSZoUOHLKjucee6mkrdLbN89EriCx4ep7tN6/diW
	DprwrIEFxPIPnvRQeWbIRiLUTtgT/Nn4s578HOyv1
X-Received: by 2002:a05:6512:68c:b0:5b8:c8f2:16c4 with SMTP id
 2adb3069b0e04-5bcdf951650mr89017e87.10.1791554976482; Fri, 09 Oct 2026
 07:09:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009084529.462577-1-vdonnefort@google.com>
 <20261009084529.462577-2-vdonnefort@google.com> <CA+EHjTwNTarWqSc_XVXGFT6mHUZD=QuTeVWrd087jUtexxCScg@mail.gmail.com>
 <asjl8czHAD017Bha@google.com>
In-Reply-To: <asjl8czHAD017Bha@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 9 Oct 2026 15:08:59 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyrw6OtSQzQW3=OMV4G=Kf_-ywzRsbfCfPyySp_x-30uw@mail.gmail.com>
X-Gm-Features: AclHuK9XmAq32Zjqn2GX9AXl1JyOiArTcR1iJ0Xv1uF-bqEh3Oi8UAMsFMJbAwE
Message-ID: <CA+EHjTyrw6OtSQzQW3=OMV4G=Kf_-ywzRsbfCfPyySp_x-30uw@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] KVM: arm64: Add ESR class to the hyp_enter hyp event
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 09 Oct 2026 14:02:41 +0100, Vincent Donnefort
<vdonnefort@google.com> wrote:

[...]
> > Aren't fixed trace points ABI? This changes the raw values of the
> > reason field (1 was hvc and is now WFx) and the strings it prints.
> > Keeping the old values and recording the EC in a new field would avoid
> > that.
>
> The event format is described precisely in events/hypervisor/hyp_enter/format.
> Any tooling should use that, so it doesn't seem like ABI to me. Also, this is
> behind NVHE_EL2_DEBUG. The only precedent I know is in kernel/sched/ where there
> are only tracepoints to avoid having trace events.
>
> Finally, we do not expose (yet :)) the raw interface. So this part is definitely
> not ABI.
>
> I tried to avoid having the EC separately to keep the event as small as
> possible.

Fair enough, with it behind NVHE_EL2_DEBUG and no raw interface yet.

[...]
> > This also replaces the PSCI, ERET_HOST and ERET_GUEST exit reasons
> > with a single ERET, which the commit message doesn't mention.
>
> ERET_HOST is now "to=host reason=eret" and ERET_GUEST "to=guest reason=ERET".
>
> This one here could be considered a bug fix and I could make it a separate
> patch?

A separate patch sounds good.

[...]
> > Could ESR_EL2 be read only when the event is enabled? The read happens
> > even when tracing is disabled or compiled out, so every non-IRQ guest
> > exit now does an extra one: with NVHE_EL2_DEBUG=n, __kvm_vcpu_run()
> > goes from two reads of ESR_EL2 to three.
>
> Hum, that's a good point. I was thinking about having a HYP_REASON_ESR that when
> sent actually read the ESR. But then handle_trap() would read it twice, unless
> this one still gives the esr directly.
>
> Alternatively, I thought of moving the esr_el2 = read_sysreg_el2(SYS_ESR) out of
> __fixup_guest_exit(). But it didn't look nice.
>
> WDYS?

HYP_REASON_ESR sounds good to me, with handle_trap() still passing the
EC it already has. HE_ASSIGN is only built at EL2 and runs after the
enabled check, so the read can go there.

[...]
> > Could this print the EC value when it isn't in the table?
> > kvm_arm_exception_class has no entry for ILL, BTI, SME or GCS among
> > others, so an ARM_EXCEPTION_IL exit (EC 0x0E) shows up as UNKNOWN_ESR.
>
> I can extend kvm_arm_exception_class. Having a dynamic format string is not
> possible here.

Sounds good, that also helps kvm_exit, which prints from the same table.

Cheers,
/fuad
