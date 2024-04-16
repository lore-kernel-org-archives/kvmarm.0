Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ED91339B5
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713291072; cv=none; b=VxMYcJocZm/2cH1H/FjOfXCBjIEyKNLUqxLZwuOM+EvP0pUOFkJmJDB677UzaHrEO41xuIEEB9j9+6fIYLqt9nbB1CFsOtaBq7YhNOWTmVngrIhUl7IO1OI0Z1nn9uzj9RUICBp8uTzFeFwZYZYX7gCikxDtjDV/Xm3o1O5MPMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713291072; c=relaxed/simple;
	bh=r6bExeDEREIarxpn+rkCfC3119Kv+RO71AvO/AGYfr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLxV+ID53rvvZ9ICTpDx51HUONsFxN9XGJbBOfV3J1wqZYpXnRj+/B0heCUuGcm4zIkIU7CKmd3JoavOmm37IYxfSGrPc1LxV4ybm+SL4hhwK9PfAjxuPp4LPXniuTVOINxzVajds+/TTZ3vO3fOSWaxF4u8ATnWe+uB2q7TmeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rgjtGfuG; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rgjtGfuG"
Date: Tue, 16 Apr 2024 18:10:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713291067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Is9v+FLEWOyN4TlHUfe+9ZhLef1pk1pDaX51iTMvv0A=;
	b=rgjtGfuG6YhgFdQtEeMO8PcQLbxnjjaT4WkQMi95qaQtRSQM//RLQtlJQ6OjUxJhVDXytG
	FANVwvI9D00L8DXYErRdYvYEOaFYSN5D6wN3BwseixQVHj3KAK2N7afUQPurW6bJhFRgnj
	vDkWpxBS+snd5SuOOox7dptObVQekXQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v2 13/47] KVM: arm64: Introduce predicates to check for
 protected state
Message-ID: <Zh6_MoLeS4goC9xx@linux.dev>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-14-tabba@google.com>
 <Zh6y9osWthu-gPtN@linux.dev>
 <CA+EHjTx5A7Kcyv6U1b-rpz7xyKDmObnLVBQfZmCNKgcsTVVQfw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EHjTx5A7Kcyv6U1b-rpz7xyKDmObnLVBQfZmCNKgcsTVVQfw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 16, 2024 at 07:07:36PM +0100, Fuad Tabba wrote:
> Hi,
> 
> On Tue, Apr 16, 2024 at 6:18 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Tue, Apr 16, 2024 at 10:56:04AM +0100, Fuad Tabba wrote:
> > > -static inline bool kvm_vm_is_protected(struct kvm *kvm)
> > > -{
> > > -     return false;
> > > -}
> > > +#define kvm_vm_is_protected(kvm)     ((kvm)->arch.pkvm.enabled)
> >
> > Shouldn't this predicate check the static key (i.e.
> > is_protected_kvm_enabled()) first? In fact, you could hoist that check
> > here and just have vcpu_is_protected() call this. Unless I've missed
> > something obvious...
> 
> This check is for whether this particular VM is protected, not whether
> we're running in protected mode.

I get that, but pVMs don't exist outside of protected mode.

What I'm suggesting is:

#define kvm_vm_is_protected(kvm) (is_protected_kvm_enabled() && (kvm)->arch.pkvm.enabled)

-- 
Thanks,
Oliver
