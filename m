Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3A21DF254
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 03:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762400083; cv=none; b=PcQOffo+TI5UnI+RmtvrvBCDtebnvQTeCwBaJoqx3/x6F203kuT9zBLV2Xqcy/cnXTkGYBIPBIBcJxyDVSAsGAHmQ8M2nCno+O21MYQdxxA3z3lTfSg0+b+WcBMmook1DHrv+sEQuhboBvCHhUotrhFf3obH01P04IHZVTLeWSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762400083; c=relaxed/simple;
	bh=bAZRPhU1iXTa3lQwGSUSUkrCFaF3/7v43wHmWO9Vq9Y=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZFUBVm2rvyA24NvWsTELYA/wCgb57qjj2VzH6x4aFVdWUiLPsViY1QQPagFkZbcaNakWt+SfRDNr5y23JdEuc8Muqj0CDg6NIf+wzSoRhnoYJQqsaxpvF7IlXB11kFNk5mzGSwFo7Jsawz44hpeAGks89U0nkrT/tEiO1NT+Aq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=jgA67hQg; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="jgA67hQg"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MYcjEvRxn22VC5rAvQRDvynCUtq7/E1hpeiG4EFyNfQ=;
	b=jgA67hQgiqIuINqhW2/NaicWZBtvlokfKG0ajEs0Yurc8hcot9tvQ3/quulNcIilw/v4JhzSN
	d0w26zztMyNctfPPNdvpy6HKmJ2Fh3iKDICTUA/tuSxAZO3sH53tiLzBge/5oDMF9eTq5TPk0jc
	uDPgeP2wqr1dOG3+KXy25ZU=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4d277M1bCgz12LDR;
	Thu,  6 Nov 2025 11:33:03 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 4CC0E140258;
	Thu,  6 Nov 2025 11:34:38 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 6 Nov 2025 11:34:37 +0800
Subject: Re: [PATCH v2 6/6] KVM: arm64: vgic-v3: Indicate vgic_put_irq() may
 take LPI xarray lock
To: Oliver Upton <oliver.upton@linux.dev>
CC: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.linux.dev>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Ben Horgan
	<ben.horgan@arm.com>
References: <20250905100531.282980-1-oliver.upton@linux.dev>
 <20250905100531.282980-7-oliver.upton@linux.dev>
 <b4d7cb0f-f007-0b81-46d1-998b15cc14bc@huawei.com>
 <86cy5wvknf.wl-maz@kernel.org> <aQvwA68yqbUV5Iiw@linux.dev>
 <aQvyuB4bJq-ulP8s@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <6d77fe7f-48bd-fb44-9573-ff2e44790dfd@huawei.com>
Date: Thu, 6 Nov 2025 11:34:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aQvyuB4bJq-ulP8s@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk200017.china.huawei.com (7.202.194.83)

On 2025/11/6 8:58, Oliver Upton wrote:
> On Wed, Nov 05, 2025 at 04:46:59PM -0800, Oliver Upton wrote:
> > Hey,
> >
> > On Wed, Nov 05, 2025 at 10:28:04AM +0000, Marc Zyngier wrote:
> > > On Wed, 05 Nov 2025 09:37:10 +0000,
> > > Zenghui Yu <yuzenghui@huawei.com> wrote:
> > > >  Call trace:
> > > >   show_stack+0x18/0x24 (C)
> > > >   dump_stack_lvl+0x90/0xd0
> > > >   dump_stack+0x18/0x24
> > > >   print_usage_bug.part.0+0x29c/0x358
> > > >   mark_lock+0x6c0/0x960
> > > >   __lock_acquire+0xd4c/0x20fc
> > > >   lock_acquire+0x1c8/0x354
> > > >   vgic_put_irq+0x54/0x110
> > > >   vgic_its_inject_cached_translation+0x178/0x25c
> > > >   kvm_arch_set_irq_inatomic+0xac/0x124
> > >
> > > Right. This might_lock() is gross, and clearly doesn't do the right
> > > thing outside of direct injection of LPIs.
> > >
> > > I think we should drop it, but we should ensure that lpi_xa.xa_lock is
> > > never taken in interrupt context.
> > >
> > > Oliver, what do you think?
> >
> > It is possible (albeit improbable) that the last reference to an LPI gets
> > dropped here after injecting a cached translation. When that is the
> > case, vgic_put_irq() will take the xa_lock from an irq context.

IMO this is possible (with a really small possibility though) to happen.

> > So
> > I'd say the might_lock() here is valid.
> >
> > Zenghui, does reverting 982f31bbb5b0 ("KVM: arm64: vgic-v3: Don't require
> > IRQs be disabled for LPI xarray lock") make this go away?
> 
> Well, a bit more than that. Revert and add the diff below. Like I said
> in the original changelog, finding bugs for rare release paths is
> annoying and having a reliable way of causing an explosion when the
> calling context isn't right is a property I'd like to preserve.

The warning disappears with that.

Thanks,
Zenghui
