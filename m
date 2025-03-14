Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD11BC3C
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741961217; cv=none; b=bIf0Rbzn9dhFL4poSupiRFQYAPGhvLBxiAYPcSFp8/G21aSwaqdqJTnWz9/nmP1+7TJr/bHmYFFQ3ymzQgwBD/pl0cqQZ085/N4o2pzbnswTfXC0fTPZuN/rQ8jQHzKX0Gf6DDLJ4cDZeyxtXMMHquPcFQ8O9UJeiaDLWVOh4Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741961217; c=relaxed/simple;
	bh=8RpETn+FdL6begYD7ajY/6rjV7NaSs7qLxer9fBw2+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kz39bRBXCnOiKPSc93bmfxzkf0A4893gUNMdcE87IYnCNFJCtT4BcULgMcHXXMWJeBCqlqqY9+J3ADIMW/GqqbDOV2Be9bVN0t/tGNGXNlLveozGNFnLU59FAF/5+HkV+FIQOvyoGP46kAHBiLMk8HVPmu60nirCZWqK4A+mkWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZzwkLaZ7; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZzwkLaZ7"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-abf3d64849dso352783066b.3
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 07:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741961214; x=1742566014; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQ30pCMhWZJ/vu1HO8OFsVgK23FsiB3oCPyd4i49RYc=;
        b=ZzwkLaZ7VoAj1K9fbOvFk7LwZbYbTD542/nGsrlnYeCf6/ei/xEQPNFOCVLx6wvxlx
         OJMrqjEW6+3DszwreAkCqElVa1yT4Y2XE6ZHyvkjxn3MFw4FLDeb156Sc4ItSwpcxX6s
         UzJFkYBsnIHP+lxrrij4cs5GHThSNZCsd2ncMN8p7BHy9f+ixAtx+N51hz3ToSlRPT5k
         vTbA4clbc9Y5twH3xS7jLXsFkya7qRS/hRNB0Xmk12JNCZnj1IUsZM7w2TUMmKf4LlXt
         QvVjxo7LjppMCNtG5fGGEo0anJFPUhLhDUvBLKm8TRG7JNGOrRgpoDwd3JbVs+5WQJjE
         jC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741961214; x=1742566014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQ30pCMhWZJ/vu1HO8OFsVgK23FsiB3oCPyd4i49RYc=;
        b=qxCj6u1qe6qLqE6rHPWo8GTO5Gxt3raqyeYcCEVLC9zrxM8cYufMQgCBLBef33DGJr
         ZnzCVLZ1Uk24UfmM3QlxVdonZre1CpHkLIu8XOkODB431gfTjuieWiwoJDmRkR05Q6ke
         e1yEiVfPuIrI6e/fq4ipcdk6geWPRaNLDIuU5bJkkGCJWfKNm6zhS76qsxNhCMpcXnxE
         kt9QDf1PjD0qJp9U+4VHQik7N4QCHLwsQpyoggbNHivFiu0BoaY9TR0uodRpWTV+GxxT
         ypoz3KvxgJiUfjLStyy/F++U9lo7Nm/r0kYFdME9bToNg5kG4VX3rQO9t6y4cQsxLLkd
         qtiA==
X-Forwarded-Encrypted: i=1; AJvYcCXEGhdTIrn5iE+dU0YM+0KIPXBTbI+oqcpDZiI7DLyLZ3SCNidpbqrs6YNenzE+Rq4ZbVhm2Xk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9tqkUlsGhN5LNwsWanCO8xvf82NOcx6EzA+LhgEIV1EZ9zvJE
	x4OT+cj1oKVFkjo5rw0SspMX8ss+XUvc16U4mLk6OaPSEvhh9B16rU0KElvJdg==
X-Gm-Gg: ASbGncv0O3CDj7jRa3Bvoz/PIyc6BNIX6Eif6itGwsZXsaJD11zklfxcKOmg/OEVnPV
	qZSsEY0a79VMGL+vkomRxHN9qVReiDO/SyyiQ67dSNA5lXhlpRqNj5XwcxjujYyXpzEl6GGL/xG
	Kk5IaDXJN+VfiIW54s/1Yjku5b2W/iX/Id11fLDbnoTo0mV1qQN7dLmuhdjkJNKQLwnJtzgter/
	BkTDwbBxFsMGkelM3XfSaRnNiL70pT6PLr2zWqdwhbKAZuKkj15x604x1VfkDF1l/OTBU/S4mZp
	KTKZKN0PNbnVXcicu55pA5IWUJkM7KNQdaBbxN89Ctakm9cTJWcKipygvtZCxWFw4pinFZ3Htlj
	9vllSi9wwUjjgRQ==
X-Google-Smtp-Source: AGHT+IHghq3sPYug54WmaGy7pWa7JmjzZxIJe+VrPTG+PJgUO8Og3FjVLxNejtkRIYczh769vo0fOw==
X-Received: by 2002:a17:907:94c7:b0:ac2:9b34:89f4 with SMTP id a640c23a62f3a-ac330272cf7mr234942366b.23.1741961213314;
        Fri, 14 Mar 2025 07:06:53 -0700 (PDT)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac314a49c37sm228471866b.158.2025.03.14.07.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 07:06:52 -0700 (PDT)
Date: Fri, 14 Mar 2025 14:06:48 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: arm64: Move hyp state to hyp_vmemmap
Message-ID: <Z9Q3-FM-QwiIn9gh@google.com>
References: <20250227003310.367350-1-qperret@google.com>
 <20250227003310.367350-5-qperret@google.com>
 <86bju3onl3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bju3onl3.wl-maz@kernel.org>

On Friday 14 Mar 2025 at 11:31:36 (+0000), Marc Zyngier wrote:
> On Thu, 27 Feb 2025 00:33:08 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > @@ -698,13 +697,13 @@ int __pkvm_host_share_hyp(u64 pfn)
> >  	if (ret)
> >  		goto unlock;
> >  	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
> > -		ret = __hyp_check_page_state_range((u64)virt, size, PKVM_NOPAGE);
> > +		ret = __hyp_check_page_state_range(phys, size, PKVM_NOPAGE);
> 
> OK, I think I finally clicked here. Does it mean that all the tracking
> is now done in terms of PAs instead of VAs?

Yep, that's exactly that. The hyp_vmemmap is indexed by pfn, so I felt
that the conversion to a PA-based tracking made sense. That also make it
clear that the 'hyp state' is not a property of a mapping, but really of
the underlying physical page.

> >  		if (ret)
> >  			goto unlock;
> >  	}
> >  
> > -	prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_BORROWED);
> > -	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, prot));
> > +	__hyp_set_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED);
> > +	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
> 
> And this is the split between the state now being kept in the on a PA
> base and the actual mapping that is now only takes the page attributes
> and no SW bits?

Precisely, and the next patch in this series takes advantage of the
fact that we're now de-correlating the hyp state from the presence of a
hyp s1 mapping in the linear map range. In the future there'll be more
use-cases for this I think (e.g. the hyp allocator where we'll have
pages owned by the hypervisor but only mapped in the 'private' range,
things like that).

Thanks,
Quentin
