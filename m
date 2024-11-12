Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAA91BF58
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 07:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731396136; cv=none; b=OMzxWabn1KDpraO59KhEj9BYUit1PpHgc11EI6J5fa9Oyw0ZQ9OTtHI0WXThzHkzCvYWEcPkMMNo6xSSAjo8vGzvWOXzaL7v0GJ4aKlNeE0fH0bbi/oTi0dv1F18EwSzs5tH831UTKVRz+cxS+SO9nWKfzKvuwxvioR99L/LFMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731396136; c=relaxed/simple;
	bh=yq9hqoEcXrVSJXwF1A9y61Rtiqu1n9W7Izw6dLfVBZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g51FMguNpy2MWcu3ZPSQ2BIdRZaIDFv97CyVX5kYSMSnUH3QkTciiuXcJ5xYmrVFWmyu79GrvNcFPDuz/6NJAN6shjiS69oejqGJAYP8zVLzGKyJLLsmcCg3/GfDxLOf0+D4ijNF95WIoWJHLuBntyFjkh+dS1844Q1w0HMD/Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r6STmOh3; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r6STmOh3"
Date: Mon, 11 Nov 2024 23:22:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731396131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mLQburG1kRS4AzMdaa+yEP0C+6MBGNJdimrkcoTW0G8=;
	b=r6STmOh3QNzYnCncLYvNeOi6GungavJy3u4wdN4yWaUavCvTypQq7uvk6AaifyiqF29S5/
	LBOBu+lDNsdNUezDc0tDlhvTAtTcMLN09h3FxRMdNHdP8ktn70HCg6RcAC/+3p+GTinjah
	syuZAuYTRvWP7ElTetR+yAKYi7r7qwI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 02/15] KVM: arm64: Get rid of __kvm_get_mdcr_el2() and
 related warts
Message-ID: <ZzMCGae4WjupjCGe@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
 <20241108222418.1677420-3-oliver.upton@linux.dev>
 <5e7c19e2-e932-4664-9a9a-232623464a9b@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7c19e2-e932-4664-9a9a-232623464a9b@arm.com>
X-Migadu-Flow: FLOW_OUT

Hey Suzuki,

On Mon, Nov 11, 2024 at 11:00:11AM +0000, Suzuki K Poulose wrote:
> >   /**
> >    * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
> >    *
> > @@ -94,7 +77,8 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
> >   	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
> >   	 * to disable guest access to the profiling and trace buffers
> >   	 */
> > -	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
> > +	vcpu->arch.mdcr_el2 = FIELD_PREP(ARMV8_PMU_PMCR_N,
> 
> Shouldn't this be : MDCR_EL2_HPMN_MASK ?

Yep, I got a few wires crossed in this patch clearly. Thanks for
spotting them!

-- 
Thanks,
Oliver
