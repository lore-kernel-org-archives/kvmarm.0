Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4C72AF17
	for <kvmarm@lists.linux.dev>; Sat, 17 Aug 2024 10:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723890712; cv=none; b=IMpsmgcwjSo92hun6JtmhWeWlTEJ7LmLHcG2/4b9xBE3zFYiSsULZRrYzAa5m6+9FzobOnBH6ZvjZDpwNw+UjMJTYLgJw4HdRiUAEcyuwMAFy3nSKwukY6YvUbYeufWnp4VTA9CxQb2k+qG8JsRbYsbCl2/QR/Qr+i/7s1oCE0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723890712; c=relaxed/simple;
	bh=/pWOmZyOB1xth285AS00au612Ad7oA8AgWD7Nxl2VJ8=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NveJazDBw4EEyx27wq085DUV8cZSACwyRUbMGQFKi7GHyE5eP7Wrj8tsECmTW+oUxqz8JUfijzQcl5MBUF5Hf1yA+8JKeg3b8JdTJFQy19hhUcIFVo3o3tJ8Cr/AHALNB7AzGYM7z+GrX4FGjQeY8omd0HIX0y9rNp+/KoDff6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WmFR23MCdz20lfl;
	Sat, 17 Aug 2024 18:27:10 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id B1A2A1400D2;
	Sat, 17 Aug 2024 18:31:47 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 17 Aug 2024 18:31:46 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-debug: Don't put unmarked LPIs
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>
References: <20240817101541.1664-1-yuzenghui@huawei.com>
 <86a5hbzbrt.wl-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <99900ad4-6b05-4bba-ec7a-f4f4d36ab71b@huawei.com>
Date: Sat, 17 Aug 2024 18:31:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86a5hbzbrt.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/8/17 18:25, Marc Zyngier wrote:
> On Sat, 17 Aug 2024 11:15:41 +0100,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> >
> > If there were LPIs being mapped behind our back (i.e., between .start() and
> > .stop()), we would put them at iter_unmark_lpis() without checking if they
> > were actually *marked*, which is obviously not good.
> >
> > Switch to use the xa_for_each_marked() iterator to fix it.
> >
> > Fixes: 85d3ccc8b75b ("KVM: arm64: vgic-debug: Use an xarray mark for debug iterator")
> > Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-debug.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
> > index bc74d06398ef..e1397ab2072a 100644
> > --- a/arch/arm64/kvm/vgic/vgic-debug.c
> > +++ b/arch/arm64/kvm/vgic/vgic-debug.c
> > @@ -85,7 +85,7 @@ static void iter_unmark_lpis(struct kvm *kvm)
> >  	struct vgic_irq *irq;
> >  	unsigned long intid;
> >  
> > -	xa_for_each(&dist->lpi_xa, intid, irq) {
> > +	xa_for_each_marked(&dist->lpi_xa, intid, irq, LPI_XA_MARK_DEBUG_ITER) {
> >  		xa_clear_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
> >  		vgic_put_irq(kvm, irq);
> >  	}
> 
> Ouch. Nicely caught. I think this deserves a
> 
> Cc: stable@vger.kernel.org # v6.10

Yup. I guess Oliver will help to add it when applying ;-)

> 
> With that,
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks!

Zenghui
