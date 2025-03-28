Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7129219E93
	for <kvmarm@lists.linux.dev>; Fri, 28 Mar 2025 11:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743161993; cv=none; b=HIt+EQh2aEztT4MGxF6MqZB/nN4ytRLwCutsHBdWLkrbJfsn4lEudDbt05PqRKujx1Lkya3074EoW8J4StteBrnRzekQes9YTgE6dVDA9fbo47soaF25+gxMfoqE4n8bya3zq9hbNA/tuVJ3fqugdiUh5reRJMkOAY0r6Rvsm5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743161993; c=relaxed/simple;
	bh=xXtCiqDkKVzPlrRtPr8GSLtwyVRSEyvpBCAqqFCIdaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlGSQ349suz9RMEmmyCVwL7Fm9yqLbKALmshLB8Vib+adZQMIm9DEXp0oLZU67w+OU1bwqf7DK68qNIErcdtWLNIH7jTskCquUMD2oehHzAjaBEfiYTm/KByS5sEKJGDJfl23p8g9cLUZg5Emmq/arZ+ubuTfE1zFY761DIysfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TH2zR6rW; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TH2zR6rW"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e677f59438so3195870a12.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Mar 2025 04:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743161990; x=1743766790; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KQBUB18mwX4A4xTotkHj/u2lOJW8/CY/92F1uJiGKg4=;
        b=TH2zR6rW8dB3ReH5xDOPFYaBSX9KSUkUSfpkNw3i7CsKqIkWOiWeDEJrn29nzQm7AX
         cGTyHE3jUeL1NcfXWQuMu+MTFYJhrGuZ4vvKEYKyVpINLrIVtR0tklwD2DmKVnHHw2Bw
         0T819m3XQN5q9l/ora32gJun253fhmygHZ4qJXR2ygfJARJbYhXCoBhIml35A9DW44w2
         4C35iw8Z5S8OQTFd95LUXRf6zq9DVr0M9NgQewVZmDZ0yuQDWm3U70yGskVSrqBx4WSn
         JNLMecLIUhY/mQt3LMIvD2cGtEDSglS5zOyv5P0VKuzzP/DroRsGay+17gT1A4/Dulss
         7yag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743161990; x=1743766790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQBUB18mwX4A4xTotkHj/u2lOJW8/CY/92F1uJiGKg4=;
        b=pwl9hzLwJhqpGzPVPIMtxpaUffi7k551U3qYL7pz2pbvBgTJ/20f0NqLsue7SEHt/L
         kgk2iHarOtm7g70fXMRMmUsPAnHfRYhs7Hy3yZIpZ/aozNHlAnfZvXMxdlk6jW01w7EE
         DxDfpx7ngKVxqKz5W4PgO6k9EsKpd2S+EX9MOEVjFe2p9bC3ThwyEDeK352JyPwUmSzj
         RVb0yY8J9PvP5NzdgknW2gG0bWw75hUVYLrBswZE057FikwruM7hcAkD0jRA9BAhVfmP
         3ofLw+spWlwyZ9R7h17/joqiqQPcz9eptzH965y5viWURO/Cwn0omV8jMLg32c6ifqm/
         Stgg==
X-Forwarded-Encrypted: i=1; AJvYcCXP301b/Mj1Ib3mMX9nNsJgboJJdgsDxuwMO+ZOC3fUGR1Qa89AWt70j29lqBfFEBPOXSfewNs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBVcPzNJiJj9j5Cz6JdtcaKvQtlvk+rHZEsRPEU/3DXNJK8keD
	vuVGALaOANalot4C5arLWF+Lx0YUEYzNhEgWEJs9chVdwo7MxQP46fEg7YkaOw==
X-Gm-Gg: ASbGnctBp8VFmlNPt8nw/HN4A9zsi4KWo7Jq97oerh0SK9XHdGezBWqFRJUGoxi9FGq
	1kQqBKXgmo0e9zPNYTlBEsKOZQ1PhLWENW5alIJB44eBlHVFsUx1DJpfjGsH8CWFiCi2u/HSTiB
	b6bdHnMr5RD80eOij+zMOGedvzV59Awimcb9AmoX9NpAJ1da/cEVcXUoUX7f7dmTpmbCSm1Zk8X
	XEGBffJys+niSQWVneNhorrCTakpxnkJTFg8w5D7l2Jwe8pyXF1xCrszv7Zge+npCPsFnIE+Ptm
	UvXIN9/eXS/z7FtRLjS+m9W9I8NIORtC7MoV64ro4fQSIwIHjM0AotRnQQFjmivNv8omKPT5asR
	aN3s=
X-Google-Smtp-Source: AGHT+IGeYnm3vDHFpDSraEUf3HzDe65CWmKu1pd5dHmjPuvRy1baA8IV5n1Oel5kP1U7FdthFEYd6A==
X-Received: by 2002:a17:906:6a09:b0:abf:6f87:c720 with SMTP id a640c23a62f3a-ac6faf0959fmr756376266b.29.1743161989773;
        Fri, 28 Mar 2025 04:39:49 -0700 (PDT)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac719621b73sm145729266b.120.2025.03.28.04.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 04:39:49 -0700 (PDT)
Date: Fri, 28 Mar 2025 11:39:45 +0000
From: Quentin Perret <qperret@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	will@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com, Andrei Homescu <ahomescu@google.com>
Subject: Re: [PATCH v4 3/3] KVM: arm64: Release the ownership of the hyp rx
 buffer to Trustzone
Message-ID: <Z-aKgXVjp4nNJcLd@google.com>
References: <20250326113901.3308804-1-sebastianene@google.com>
 <20250326113901.3308804-4-sebastianene@google.com>
 <Z-Qv4b0vgVql2yOb@google.com>
 <Z-UcW32Hk6f_cuxc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-UcW32Hk6f_cuxc@google.com>

On Thursday 27 Mar 2025 at 09:37:31 (+0000), Sebastian Ene wrote:
> On Wed, Mar 26, 2025 at 04:48:33PM +0000, Quentin Perret wrote:
> > On Wednesday 26 Mar 2025 at 11:39:01 (+0000), Sebastian Ene wrote:
> > > Introduce the release FF-A call to notify Trustzone that the hypervisor
> > > has finished copying the data from the buffer shared with Trustzone to
> > > the non-secure partition.
> > >
> > > Reported-by: Andrei Homescu <ahomescu@google.com>
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > index 6df6131f1107..ac898ea6274a 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -749,6 +749,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > >  	DECLARE_REG(u32, uuid3, ctxt, 4);
> > >  	DECLARE_REG(u32, flags, ctxt, 5);
> > >  	u32 count, partition_sz, copy_sz;
> > > +	struct arm_smccc_res _res;
> > >  
> > >  	hyp_spin_lock(&host_buffers.lock);
> > >  	if (!host_buffers.rx) {
> > > @@ -765,11 +766,11 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > >  
> > >  	count = res->a2;
> > >  	if (!count)
> > > -		goto out_unlock;
> > > +		goto release_rx;
> > >  
> > >  	if (hyp_ffa_version > FFA_VERSION_1_0) {
> > >  		/* Get the number of partitions deployed in the system */
> > > -		if (flags & 0x1)
> > > +		if (flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY)
> > >  			goto out_unlock;
> > >  
> > >  		partition_sz  = res->a3;
> > > @@ -781,10 +782,12 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > >  	copy_sz = partition_sz * count;
> > >  	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> > >  		ffa_to_smccc_res(res, FFA_RET_ABORTED);
> > > -		goto out_unlock;
> > > +		goto release_rx;
> > >  	}
> > >  
> > >  	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
> > > +release_rx:
> > > +	ffa_rx_release(&_res);
> 
> Hi,
> 
> > 
> > I'm a bit confused about this release call here. In the pKVM FF-A proxy
> > model, the hypervisor is essentially 'transparent', so do we not expect
> > EL1 to issue that instead?
> 
> I think the EL1 should also issue this call irrespective of what the
> hypervisor is doing. Sudeep can correct me here if I am wrong, but this
> is my take on this.

Agreed, but with the code as it is implemented in this patch, I think
that from the host perspective there is a difference in semantic for
the release call. W/o pKVM the buffer is essentially 'locked' until
the host issues the release call. With pKVM, the buffer is effectively
unlocked immediately upon return from the PARTITION_INFO_GET call
because the hypervisor happened to have issued the release call
behind our back. And there is no way the host to know the difference.

I understand that we can argue the hypervisor-issued call is for the
EL2-TZ buffers while the EL1-issued call is for the EL1-EL2 buffers,
but that's not quite working that way since pKVM just blindly forwards
the release calls coming from EL1 w/o implementing the expected
semantic.

> I am looking at this as a way of signaling the availability of the rx
> buffer across partitions. There are some calls that when invoked, they
> place the buffer in a 'locked state'.
> 
> 
> > How is EL1 supposed to know that the
> > hypervisor has already sent the release call?
> 
> It doesn't need to know, it issues the call as there is no hypervisor
> in-between, why would it need to know ?

As per the comment above, there is a host-visible difference in semantic
with or without pKVM which IMO is problematic.

For example, if the host issues two PARTITION_INFO_GET calls back to
back w/o a release call in between, IIUC the expectation from the
FF-A spec is for the second one to fail. With this patch applied, the
second call would succeed thanks to the implicit release-call issued by
pKVM. But it would fail as it is supposed to do w/o pKVM.

I'm not entirely sure if that's gonna cause real-world problem, but it
does feel unecessary at best. Are we trying to fix an EL1 bug in the
hypervisor here?

> > And isn't EL1 going to be
> > confused if the content of the buffer is overridden before is has issued
> > the release call itself?
> 
> The hypervisor should prevent changes to the buffer mapped between the
> host and itself until the release_rx call is issued from the host.
> If another call that wants to make use of the rx buffer sneaks in, we
> would have to revoke it with BUSY until rx_release is sent.

Right, exactly, but that's not implemented at the moment. IMO it is much
simpler to rely on the host to issue the release call and just not do it
from the PARTITION_INFO_GET path in pKVM. And if we're scared about a
release call racing with PARTITION_INFO_GET at pKVM level, all we should
need to do is forward the release call with the host_buffers.lock held I
think. Wdyt?

Thanks,
Quentin
