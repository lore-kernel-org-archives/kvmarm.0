Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B0DDDDA
	for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 17:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716224909; cv=none; b=GmW1MZMLUcrP8PAQxMLyb0jkRkTd+/i8N7zritQj9nsulDJKxpV3427f4Hn7x2BHnPBvDLIW/S2aEhs0E+cyBSceUpo59SV9qTXzX/s44M/Hg6Y5c0g34hSu8zXPeJxLcuGs4gxygKN72bOnm0MnY+fZHUiMMQtVG7Vbr3ZhVuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716224909; c=relaxed/simple;
	bh=d93WTo0LpqbgFt1JZXtS5WhRHlkUDxRhTRVjR/JhEYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdpp5o+D4tnDaNXAujOKLKES6CyilBO2+LpNPpOfbbmJcxf7jP9t3fEwAG+kTl4CS/76P+ettyaj3fpU9xlu7DliwBGDIuWMyrulagio/L6uZ3xpMcY10a489CMbLSxcaZtf6sUWCgDMhonEfalVU+W2HS18uYgqHZIoO36wW+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KRaXmd5g; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KRaXmd5g"
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716224906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZxPc1HKEzT5D8SyGOQxoDo+gvVi7ggagC7NtfT2yuw=;
	b=KRaXmd5giN5F1fquf8EDIkEJBDECWsqnyEHOIMKOLIqPtEuyTS0uyAG5ZYhRGvxkg1VQEG
	vInwFKnuZEXzqO9qH3FQSskBxMp8PhOslGwTjq3hwwPDEIK/WSOwkIQNOU7kMGz+IBY7L6
	6tRxyn5f1yONKBeLDEGHgOpRGZPJUgg=
X-Envelope-To: tabba@google.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: will@kernel.org
X-Envelope-To: qperret@google.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: philmd@linaro.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: broonie@kernel.org
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: rananta@google.com
X-Envelope-To: yuzenghui@huawei.com
Date: Mon, 20 May 2024 17:08:19 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Subject: Re: [PATCH v1 6/7] KVM: arm64: Eagerly restore host fpsimd/sve state
 in pKVM
Message-ID: <ZkuDg4p3o5vL9kUm@linux.dev>
References: <20240517131814.719933-1-tabba@google.com>
 <20240517131814.719933-7-tabba@google.com>
 <ZkePS5jU6yEv6Nhp@linux.dev>
 <CA+EHjTzFkNiPzH47Y52cEPd+LzNSAmGHD45C0o8p2ejB6LKHKQ@mail.gmail.com>
 <87r0dw3o35.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r0dw3o35.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, May 20, 2024 at 09:05:34AM +0100, Marc Zyngier wrote:
> On Mon, 20 May 2024 08:37:22 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> > 
> > Hi Oliver,
> > 
> > On Fri, May 17, 2024 at 6:09 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > Hi Fuad,
> > >
> > > On Fri, May 17, 2024 at 02:18:13PM +0100, Fuad Tabba wrote:
> > > >  static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
> > > >  {
> > > > -     __fpsimd_save_state(*host_data_ptr(fpsimd_state));
> > > > +     /*
> > > > +      * Non-protected kvm relies on the host restoring its sve state.
> > > > +      * Protected kvm restores the host's sve state as not to reveal that
> > > > +      * fpsimd was used by a guest nor leak upper sve bits.
> > > > +      */
> > > > +     if (unlikely(is_protected_kvm_enabled() && system_supports_sve())) {
> > > > +             __hyp_sve_save_host();
> > > > +
> > > > +             /* Re-enable SVE traps for guests that do not support it. */
> > > > +             if (!vcpu_has_sve(vcpu))
> > > > +                     sysreg_clear_set(cptr_el2, 0, CPTR_EL2_TZ);
> > >
> > > This doesn't account for hVHE. I wonder we'd be better off abstracting
> > > CPTR_EL2 behind a helper wherever it gets used in nVHE and translate
> > > into the VHE-format behind the scenes:
> > 
> > Right! Too many modes to keep track of :)
> > 
> > Abstracting cptr_el2 would make things clearer and less error-prone.
> > I'll do that on the respin.
> 
> If we're going with the conversion game, then I'd suggest you use the
> VHE format as the reference, and convert it to nVHE on the flight.
> That's for a few reasons:

Agreed, I was thinking of hVHE as this 'thing on the side', but really
it is the direction of the architecture :) So yeah, prefer your
suggestion.

-- 
Thanks,
Oliver
