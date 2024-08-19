Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A8882D94
	for <kvmarm@lists.linux.dev>; Mon, 19 Aug 2024 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724084820; cv=none; b=VfdW96nroi/K2qLqXkl7kNAzClSgmrRjPAW+UANkvlvtDBS8bET6jwHVlrPchsCxiNd4L8dIWLqD1OkLgoyWc5rTMWL8c6uPYY+vXB3KtSxlFI6yF4qk/SJX1givLqV82AFfPCJ9J+BuWwcXhec7sqELWSjL8mR3+pE7WF8WGBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724084820; c=relaxed/simple;
	bh=BeG96sLKNi1TFbn65BaLHfUheDtSwpLdRfYAZIQofHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/VTT6SOI7XTOij8Z4GKLbScJdD28ASZUxR+50/WZzulCDYtJMgOtnQpGAf/grIQj+7grI/cI2q2e9GyqdyYcPfUO04329JMtexPMheY/yyVm3H98E+WrX5eOziV+tmnvqbevz0eS/1aKfE2EAs1VvxYLT8mWltbSzNWUtJ1kc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DA0zKqhF; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DA0zKqhF"
Date: Mon, 19 Aug 2024 09:26:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724084815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AsK28yHmfsApUch3ci6Pzhi4GLlWPP29RXZc1Ds3IyI=;
	b=DA0zKqhFxpybDfL5Z45D02TvTiKVCUI402G2mvw/UFkpdus/5RUA3xXm49eeD6u5hgTB5T
	fSKKMN+3XF8UjAKwuHlhVUX5VebqC9G4N7SxgHzVuJ74sZuSyaEekMpS47+mbwp8KlUd7k
	cGZhnieInUL6orETKfgOhJKVPMHVqzc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	james.morse@arm.com, suzuki.poulose@arm.com,
	wanghaibin.wang@huawei.com
Subject: Re: [PATCH] KVM: arm64: vgic-debug: Don't put unmarked LPIs
Message-ID: <ZsNySeySMxxcpUTS@linux.dev>
References: <20240817101541.1664-1-yuzenghui@huawei.com>
 <86a5hbzbrt.wl-maz@kernel.org>
 <99900ad4-6b05-4bba-ec7a-f4f4d36ab71b@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99900ad4-6b05-4bba-ec7a-f4f4d36ab71b@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 17, 2024 at 06:31:45PM +0800, Zenghui Yu wrote:
> On 2024/8/17 18:25, Marc Zyngier wrote:
> > On Sat, 17 Aug 2024 11:15:41 +0100,
> > Zenghui Yu <yuzenghui@huawei.com> wrote:
> > >
> > > If there were LPIs being mapped behind our back (i.e., between .start() and
> > > .stop()), we would put them at iter_unmark_lpis() without checking if they
> > > were actually *marked*, which is obviously not good.
> > >
> > > Switch to use the xa_for_each_marked() iterator to fix it.

Urgh, that's what I'd meant to do. Thanks for catching this Zenghui.

> > > Fixes: 85d3ccc8b75b ("KVM: arm64: vgic-debug: Use an xarray mark for debug iterator")
> > > Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-debug.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
> > > index bc74d06398ef..e1397ab2072a 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-debug.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-debug.c
> > > @@ -85,7 +85,7 @@ static void iter_unmark_lpis(struct kvm *kvm)
> > >  	struct vgic_irq *irq;
> > >  	unsigned long intid;
> > >  
> > > -	xa_for_each(&dist->lpi_xa, intid, irq) {
> > > +	xa_for_each_marked(&dist->lpi_xa, intid, irq, LPI_XA_MARK_DEBUG_ITER) {
> > >  		xa_clear_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
> > >  		vgic_put_irq(kvm, irq);
> > >  	}
> > 
> > Ouch. Nicely caught. I think this deserves a
> > 
> > Cc: stable@vger.kernel.org # v6.10
> 
> Yup. I guess Oliver will help to add it when applying ;-)

Indeed, I'll grab it here in a moment.

> > 
> > With that,
> > 
> > Reviewed-by: Marc Zyngier <maz@kernel.org>
> 

Thanks both!

-- 
Best,
Oliver
