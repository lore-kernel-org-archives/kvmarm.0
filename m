Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CC61649A8
	for <kvmarm@lists.linux.dev>; Mon, 19 Aug 2024 12:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724070729; cv=none; b=rl6l0TwJI19EZ9JOfO9F5mRvGvTmkAYSNoKiWMlMOHH/UXekudb459nWsg317agUUwruADEnMwDm+JCJkeDsab1AwOs828GjOE5sVDA13ZmgBM7ZTfKI4nfm6lgkvl9ENueIJXZBWo0a1b7EtpwJ2AtB4gy74xqdC9kM+xLZdsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724070729; c=relaxed/simple;
	bh=UuK3R21pMLnxcqgcC2kcg68rWiX8ItH6ti3h1KLV/pg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CB4gtbXAr0hfEBP+4h9ogLxfRwUQqAQs7Ms49fYStTIWFWji5q8cQj9M1fAuY+h9N68vms+ZmBPmGRBnSnyQKaFW+0lJ2EpbCWjCBO5b8SRqt2Zxf65C5qH1R1UJ100aTI3C61j/BKxKfQcIAQA+qsws2y0jLKNUfCIIcaguX3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WnX0Q2wJ3z1S8Cg;
	Mon, 19 Aug 2024 20:27:02 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 420B814022E;
	Mon, 19 Aug 2024 20:32:01 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 19 Aug 2024 20:32:00 +0800
Subject: Re: [PATCH] KVM: arm64: vgic: Hold config_lock while tearing down a
 CPU interface
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>, James
 Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>, Alexander Potapenko
	<glider@google.com>
References: <20240808091546.3262111-1-maz@kernel.org>
 <c8f4602a-c3af-958f-6c8e-a4226d613a6b@huawei.com>
 <8634n0zsu0.wl-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <40d0a14b-b501-aef6-a168-1c1acd5448e7@huawei.com>
Date: Mon, 19 Aug 2024 20:31:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8634n0zsu0.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/8/19 18:53, Marc Zyngier wrote:
> On Mon, 19 Aug 2024 10:39:50 +0100,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> >
> > Hi Marc,
> >
> > On 2024/8/8 17:15, Marc Zyngier wrote:
> > > Tearing down a vcpu CPU interface involves freeing the private interrupt
> > > array. If we don't hold the lock, we may race against another thread
> > > trying to configure it. Yeah, fuzzers do wonderful things...
> > >
> > > Taking the lock early solves this particular problem.
> > >
> > > Fixes: 03b3d00a70b5 ("KVM: arm64: vgic: Allocate private interrupts on demand")
> > > Reported-by: Alexander Potapenko <glider@google.com>
> > > Tested-by: Alexander Potapenko <glider@google.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-init.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > index 7f68cf58b978..41feb858ff9a 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > @@ -438,14 +438,13 @@ void kvm_vgic_destroy(struct kvm *kvm)
> > >  	unsigned long i;
> > >  
> > >  	mutex_lock(&kvm->slots_lock);
> > > +	mutex_lock(&kvm->arch.config_lock);
> > >  
> > >  	vgic_debug_destroy(kvm);
> > >  
> > >  	kvm_for_each_vcpu(i, vcpu, kvm)
> > >  		__kvm_vgic_vcpu_destroy(vcpu);
> > >  
> > > -	mutex_lock(&kvm->arch.config_lock);
> > > -
> > >  	kvm_vgic_dist_destroy(kvm);
> > >  
> > >  	mutex_unlock(&kvm->arch.config_lock);
> >
> > The following splat was triggered when running the vgic_init selftest on
> > a lockdep kernel (I use rc4, with defconfig + PROVE_LOCKING).
> >
> > I'm not entirely sure that the splat is related to this change. Just
> > haven't got time to dig further so post it out early for record.
> 
> Arghh. Thanks for reporting this. Can you try the following patch? It
> does the trick for me, but I don't trust myself anymore...

I tested it with defconfig+PROVE_LOCKING and my own config, both worked
for me (the WARNING disappeared). I think the locking order should be
correct now.

Thanks,
Zenghui
