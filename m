Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CEB216A1D
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 20:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729800904; cv=none; b=KUxTBL8fYRehHMKiH2cNLGu3xL8UouhgbewKTlphmGIeYZgXKLvXbLV7Hd++V5F+kh9/78WzbqhIGwl1SgerxqsgFY53MvGvzQAVVAca2vY34kZYxU1vJEjopzuuOOR0nlib1upM+ry/Djf70GX4aZCn+3K0smbi+7IV7zPsrEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729800904; c=relaxed/simple;
	bh=6fj/q8BQSOINphdKPPLUDq7M+GfsWT/xgsFdcpeWwHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCkrUNZAms6FZJIcNGXarX6LQDf9dxFrsuq0HTo1Md/TV3w67f63y0vwdKQy1tYFT77blDeFJMUhSYLoB0rfQWmJJ5S2Q5OPFX6aYVbp5k6+XoVmtcNXIXjdIHy6m3e7hRaRJRE4pWtfKKfSmmxKLXiHbuGQu7WlZorTS1OQSr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YfMBqlEu; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YfMBqlEu"
Date: Thu, 24 Oct 2024 13:14:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729800899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UtFndtJcIL3zsSxbBk4RRQ6rdE2RirToZ3JUO30TCHs=;
	b=YfMBqlEuY3d4sssErtWX/tyOE6MwT9DGBdAkTCuk3A3qClaZ1jgVMh94ystYpCwzOS3XQ0
	kA6nAgW6nZsGBkOEUHBGkUp3x8C8S2QFSMgI7b/odoVduDw6c6fJO90OQ6BOTifEgTsS7k
	fKQmtIPOjE09rsN97IuRq5Y3IxznMxw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Zhiqiang Ni <nizhiqiang1@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	wanghaibin.wang@huawei.com, tangnianyao@huawei.com,
	wangzhou1@hisilicon.com, yuzenghui@huawei.com,
	wangyanan55@huawei.com, jiangkunkun@huawei.com,
	jiaqingtong@huawei.com
Subject: Re: [bug report] KVM: arm64: vgic-its: Performance degradation on
 GICv3 LPI injection
Message-ID: <ZxqqvcaGFkK4_QHW@linux.dev>
References: <bb4aeb68-c77b-4071-bca5-d129a1c5f6f3@huawei.com>
 <86y12e2amf.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y12e2amf.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 24, 2024 at 09:00:56AM +0100, Marc Zyngier wrote:
> On Thu, 24 Oct 2024 06:06:58 +0100,
> Zhiqiang Ni <nizhiqiang1@huawei.com> wrote:
> > 
> > Hi all,
> > 
> > I found a performance degradation on GICv3 LPI injection after this
> > commit ad362fe07fecf0aba839ff2cc59a3617bd42c33f(KVM: arm64: vgic-its:
> > Avoid potential UAF in LPI translation cache).
> >
> > In my testcase, the vm's configuration is 60 VCPU 120G RAM with a
> > 32-queue NIC and the kernel version is 5.10. The number of new TCP
> > connections per second changed from 150,000 to 50,000 after this
> > patch, with the %sys of cpu changed from 15% to 85%.
> 
> What is the VM running? How is the traffic generated? Without a
> reproducer, I struggle to see how we are going to analyse this issue.
> 
> We can't go back to the previous situation anyway, as it has been
> shown that what we had before was simply unsafe (the commit message
> explains why).
> 
> > From the ftrace, I found that the duration of vgic_put_irq() is
> > 13.320 us, which may be the reason for the performance degradation.
> >
> > The call stack looks like below:
> >     kvm_arch_set_irq_inatomic()
> >       vgic_has_its();
> >       vgic_its_inject_cached_translation()
> >         vgic_its_check_cache()
> >         vgic_queue_irq_unlock()
> >         vgic_put_irq()
> 
> Are you suggesting that it is the combination of vgic_get_irq_kref() +
> vgic_irq_put() that leads to excessive latency? Both are essentially
> atomic operations, which should be pretty cheap on a modern CPU
> (anything with FEAT_LSE).

Looks like the bug report is for a 5.10 kernel, and at that point in
ancient history KVM takes the lpi_list_lock for every vgic_irq_get() / vgic_irq_put()

The series below that we took upstream has the necessary improvements to
alleviate lock contention, Zhiqiang you may want to consider backporting
this into your kernel.

https://lore.kernel.org/all/20240221054253.3848076-1-oliver.upton@linux.dev/

-- 
Thanks,
Oliver
