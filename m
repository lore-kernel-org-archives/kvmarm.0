Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85F31A08D1
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629793; cv=none; b=YTA7miJyuOHEH8JffzvYcVlxHztAtfTHbkewluDzCb6J8oQstWEt0eS0ywwfOLgobKOjh1UN4LNlpfxi3vFw13/ni6qv46zkVUS4kVempkTqCAEP8SV83pITgCJXPAGssJG6VpsBE6RLpVBPXdSxV7sEXqr16fqe1ggtYcnGJI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629793; c=relaxed/simple;
	bh=vXVCpNIHhh8sPsdymXXaKIvYSf2FwYaG6DsEdj3/nu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItRIntRXCY/kwbqbX8zFqV9AUJ1dqbP+dJ8Y2hlawXlOvKD9ThUl/29pO2PfAVpSqoDU1237+3PcsJWjqBZwsoVH13dYqdoBTlILVNUvbrbulT44znxv10153oujtDTPHDM192Yp7K5OeCXVvWQV5ZFE6BsF0B8k8M7bLzWDnMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Csc+vQ+W; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Csc+vQ+W"
Date: Thu, 19 Dec 2024 09:36:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734629788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ap48egQQYjTFlsWXbHaljCMT9L0YYN5hLo9udbi2yJE=;
	b=Csc+vQ+WRhHRGl7OlGJx22m1D4aOa0/LrTi+9UzU81TvkO0x8LP2EFgVOoV+/aJvDIr5Bx
	lzikpMxhvRNERHpxOgGQDhye/T8UhGy7Crt3bQagdyQGlb53vpJGxPaoWSWNjjWqwilWVC
	DlVPRbzgEoEaUrY0b/iu0jNpvJ/pDDQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
	sebott@redhat.com, yuzenghui@huawei.com, wangzhou1@hisilicon.com,
	jiangkunkun@huawei.com, jonathan.cameron@huawei.com,
	anthony.jebson@huawei.com, linux-arm-kernel@lists.infradead.org,
	linuxarm@huawei.com
Subject: Re: [PATCH v4 0/3] KVM: arm64: Errata management for VM Live
 migration
Message-ID: <Z2RZkP-v2nbmmzLV@linux.dev>
References: <20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com>
 <86a5csq93o.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a5csq93o.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 19, 2024 at 10:07:39AM +0000, Marc Zyngier wrote:
> Hi Shameer,
> 
> On Wed, 18 Dec 2024 10:53:42 +0000,
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> > 
> > Hi,
> > 
> > v3 --> v4(Minor updates)
> > https://lore.kernel.org/kvmarm/20241209115311.40496-1-shameerali.kolothum.thodi@huawei.com/
> > 
> >  -Changed MIDR/REVIDR to 64 bits based on feedback from Connie
> >   and Marc(Patch #3).
> >  -Added R-by tags from Sebastian (Thanks!).
> 
> Thanks again for putting this together.
> 
> I think it would be really good to have a sample userspace
> implementation of this extension so that we can play with it for real
> before fully committing to it.
> 
> I am also wondering is we should make it mandatory that a guest is
> presented with an MIDR_EL1.Implementer value set to 0, which denotes
> SW use, and would make it plain to the guest (and crucially, guest
> userspace) that we are going to play tricks.
> 
> Thoughts?

I see no issues with giving userspace the option of doing this, but I'd
rather not enforce this to use the PV interface.

At least in a cloud setting it seems highly likely that you'd be running
a mix of guests on the same VM definition, some aware of the PV
interface and others not. If we use a software MIDR, all old VMs will
lose errata mitigations and whatever else userspace might key off of MIDR.

Userspace can make the call whether or not a VM can be migrated onto a
different implementation based on whether or not the guest used the
hypercall interface. And maybe just terminate the VM if it didn't.

-- 
Thanks,
Oliver
