From: <vkilari@codeaurora.org>
Subject: RE: [PATCH] KVM: arm64: vgic-its: Fix wrong return value check in
 vgic_its_restore_device_tables
Date: Sun, 17 Sep 2017 13:40:56 +0530
Message-ID: <000401d32f8c$828f4270$87adc750$@codeaurora.org>
References: <1504675565-13641-1-git-send-email-vkilari@codeaurora.org>
 <65a66715-4f22-07d4-879a-1181c8dad889@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9BB449C3A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Sep 2017 04:08:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6J90wcsM3myd for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Sep 2017 04:08:20 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC79D49C33
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Sep 2017 04:08:19 -0400 (EDT)
In-Reply-To: <65a66715-4f22-07d4-879a-1181c8dad889@redhat.com>
Content-Language: en-us
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Auger Eric' <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, andre.przywara@arm.com
Cc: vvenkat@codeaurora.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

 Sorry for delayed reply.

> -----Original Message-----
> From: Auger Eric [mailto:eric.auger@redhat.com]
> Sent: Wednesday, September 6, 2017 12:53 PM
> To: Vijaya Kumar K <vkilari@codeaurora.org>;
> kvmarm@lists.cs.columbia.edu; marc.zyngier@arm.com; cdall@linaro.org;
> andre.przywara@arm.com
> Cc: vvenkat@codeaurora.org; shankerd@codeaurora.org;
> kvm@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] KVM: arm64: vgic-its: Fix wrong return value check in
> vgic_its_restore_device_tables
> 
> Hi Vijaya,
> 
> On 06/09/2017 07:26, Vijaya Kumar K wrote:
> > scan_its_table() return 1 on success.
> 
> As mentioned in the kernel-doc comment of scan_its_table, this latter
> returns 1 if the last element is not found. Than can happen while scanning
an
> L2 table but shouldn't happen if we scan an L1 table.
> 
>  * Return: < 0 on error, 0 if last element was identified, 1 otherwise
>  * (the last element may not be found on second level tables)

OK. I will  fix this comment

> 
> 
>  In the function vgic_its_restore_device_tables()
> > the return value of scan_its_table() is checked against success value
> > and returns -EINVAL. Hence migration fails for VM with ITS.
> >
> > With this patch the failure return value is checked while returning
> > -EINVAL.
> >
> > Signed-off-by: Vijaya Kumar K <vkilari@codeaurora.org>
> >
> > diff --git a/virt/kvm/arm/vgic/vgic-its.c
> > b/virt/kvm/arm/vgic/vgic-its.c index aa6b68d..63f8ac3 100644
> > --- a/virt/kvm/arm/vgic/vgic-its.c
> > +++ b/virt/kvm/arm/vgic/vgic-its.c
> > @@ -2142,7 +2142,7 @@ static int vgic_its_restore_device_tables(struct
> vgic_its *its)
> >  				     vgic_its_restore_dte, NULL);
> >  	}
> >
> > -	if (ret > 0)
> > +	if (ret <= 0)
> >  		ret = -EINVAL;
> your modification would return -EINVAL for whatever error encountered
> during the scan table or if last element is found. I don't think this is
what we
> want.

IIUC, ret 0 indicates last entry of the table. So in this case return value
0 is also success.
with the assumption that table might be smaller than size.

So only check for < 0 and return -EINVAL. For all other return values 0 and
> 0  return 0.
as below. Please correct me if I wrong.

           If (ret < 0)
                          ret = -EINVAL;
           else
                          ret = 0;
