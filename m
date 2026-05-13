Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B5D39C635;
	Wed, 13 May 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778692785; cv=none; b=RIbJPN8US5lE7c/iF4X9p8OQZYTeGkJW9hx303pCGE9hkBLq80fFGmVZcWb74f7VWdRe7SKO3MTYcmwdOITR0vxX5Kw2eSFj0NGT34Bpzz0TAPKcHTAJ0IFeBY91NVtXH6XfBTQwaLZiBsuhi+HS/3LqV8mpfiWn6kNImQFh0tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778692785; c=relaxed/simple;
	bh=wdwmWQvVhbMJShU+Cq/ZBzAiBrqBEgIBK4QCLxQP7nE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTmgO0PRxrxfLQ8qxcrWadF38CY6+y84DEXK8xyO/GzFvwRQ5vDy5CQTAM3dUrn4z3vqTTraGVJUJ6iT4X/qVONviuP4wWp757ZyCPH7MLq3GtxiGfFWLCKZv6GUa2bBhpcIpSdONJ4X3dlgarLWWG4HjDGUne4oraixcp+lYVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XG8b+yZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XG8b+yZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12FCC19425;
	Wed, 13 May 2026 17:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778692784;
	bh=wdwmWQvVhbMJShU+Cq/ZBzAiBrqBEgIBK4QCLxQP7nE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XG8b+yZprlhiDyP4N8PEd0JhlPNIBpirJzna7WY6Flqur6vQsjA/gU5DwKN4W2sF+
	 E3RKHEG5BKTuj9Phwr7hHxW5wdXGmSDxDu09uNWCqBapj7pFqNzrbj1x0w4zLSDXMD
	 dp/C9RR2HwsB9ouhXUUfcXqEBSxfupSTjbUBcIGCrm+9BYkEoT4ImaQC5cdHXsRnWz
	 DOoTHmZrKaGfHNS/pptGvO0Dnb36Zw3IMhn5NEWaFTGlDETppUHAxiV/oCiPjL8TkW
	 jrbWZT3nJjjwPxotDoTBUhqB86256m43zBEP7un3o7Cd/PlzAi3w649OaY9MjHI6P5
	 p6VZmOG6n0DZg==
Date: Wed, 13 May 2026 18:19:39 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: Sebastian Ene <sebastianene@google.com>, catalin.marinas@arm.com,
	Sudeep Holla <sudeep.holla@kernel.org>, maz@kernel.org,
	oupton@kernel.org, will@kernel.org, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 1/2] firmware: arm_ffa: Fix Endpoint Memory Access
 Descriptor offset calculation
Message-ID: <20260513-prodigious-cobra-of-cleaning-094a72@sudeepholla>
References: <20260512124442.1899107-1-sebastianene@google.com>
 <20260512124442.1899107-2-sebastianene@google.com>
 <agR98uWCHQBHuGNg@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agR98uWCHQBHuGNg@google.com>

On Wed, May 13, 2026 at 01:34:42PM +0000, Mostafa Saleh wrote:
> On Tue, May 12, 2026 at 12:44:41PM +0000, Sebastian Ene wrote:
> > Use the descriptor's `ep_mem_offset` to calculate the start of the endpoint
> > memory access array and to comply with the FF-A spec instead of defaulting
> > to `sizeof(struct ffa_mem_region)`.
> > This requires moving `ffa_mem_region_additional_setup()` earlier in the setup
> > flow.
> > Also, add sanity checks to ensure the calculated descriptor offsets do not
> > exceed `max_fragsize`.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  drivers/firmware/arm_ffa/driver.c | 14 ++++++++++----
> >  include/linux/arm_ffa.h           |  2 +-
> >  2 files changed, 11 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> > index eb2782848283..56b166290b24 100644
> > --- a/drivers/firmware/arm_ffa/driver.c
> > +++ b/drivers/firmware/arm_ffa/driver.c
> > @@ -685,18 +685,25 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
> >  	struct ffa_composite_mem_region *composite;
> >  	struct ffa_mem_region_addr_range *constituents;
> >  	struct ffa_mem_region_attributes *ep_mem_access;
> > -	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg);
> > +	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg), ep_offset;
> >  
> >  	mem_region->tag = args->tag;
> >  	mem_region->flags = args->flags;
> >  	mem_region->sender_id = drv_info->vm_id;
> >  	mem_region->attributes = ffa_memory_attributes_get(func_id);
> > +
> > +	ffa_mem_region_additional_setup(drv_info->version, mem_region);
> >  	composite_offset = ffa_mem_desc_offset(buffer, args->nattrs,
> >  					       drv_info->version);
> > +	if (composite_offset > max_fragsize - sizeof(struct ffa_composite_mem_region))
> > +		return -ENXIO;
> 
> nit: This driver seems to use sizeof() with variable name rather than
> type (except for one place) so it may be good to keep that.
> 

Agreed, +1.

> >  
> >  	for (idx = 0; idx < args->nattrs; idx++) {
> > -		ep_mem_access = buffer +
> > -			ffa_mem_desc_offset(buffer, idx, drv_info->version);
> > +		ep_offset = ffa_mem_desc_offset(buffer, idx, drv_info->version);
> > +		if (ep_offset > max_fragsize - sizeof(struct ffa_mem_region_attributes))
> > +			return -ENXIO;
> > +
> > +		ep_mem_access = buffer + ep_offset;
> >  		ep_mem_access->receiver = args->attrs[idx].receiver;
> >  		ep_mem_access->attrs = args->attrs[idx].attrs;
> >  		ep_mem_access->composite_off = composite_offset;
> > @@ -708,7 +715,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
> >  	}
> >  	mem_region->handle = 0;
> >  	mem_region->ep_count = args->nattrs;
> > -	ffa_mem_region_additional_setup(drv_info->version, mem_region);
> >  
> >  	composite = buffer + composite_offset;
> >  	composite->total_pg_cnt = ffa_get_num_pages_sg(args->sg);
> > diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> > index 81e603839c4a..62d67dae8b70 100644
> > --- a/include/linux/arm_ffa.h
> > +++ b/include/linux/arm_ffa.h
> > @@ -445,7 +445,7 @@ ffa_mem_desc_offset(struct ffa_mem_region *buf, int count, u32 ffa_version)
> >  	if (!FFA_MEM_REGION_HAS_EP_MEM_OFFSET(ffa_version))
> >  		offset += offsetof(struct ffa_mem_region, ep_mem_offset);
> >  	else
> > -		offset += sizeof(struct ffa_mem_region);
> > +		offset += buf->ep_mem_offset;
> 
> Does it make sense to also set buf->ep_mem_offset for the other
> case in ffa_mem_region_additional_setup() and then add this
> unconditionally here?
> 

I need to cross-check the spec, but if I vaguely recall as the name
FFA_MEM_REGION_HAS_EP_MEM_OFFSET suggests, older versions don't have that
field to use it.

-- 
Regards,
Sudeep
