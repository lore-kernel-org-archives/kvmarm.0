From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 2/3] KVM: arm64: Correctly handle zero register in system
 register accesses
Date: Thu, 03 Dec 2015 14:08:29 +0300
Message-ID: <00cd01d12dba$f14ac070$d3e04150$@samsung.com>
References: <cover.1449136209.git.p.fedin@samsung.com>
 <fff7d3cedc4d6ac0c81b089a4b2d7a992c83fb80.1449136209.git.p.fedin@samsung.com>
 <56601E36.5070700@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EC1849932
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 06:07:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7CWAqkasJ9jT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 06:07:03 -0500 (EST)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60D14498EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 06:07:02 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYS009E94A6KN20@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 03 Dec 2015 11:08:30 +0000 (GMT)
In-reply-to: <56601E36.5070700@arm.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 87a64e8..a667228 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -102,7 +102,7 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
> >
> >  	BUG_ON(!p->is_write);
> >
> > -	val = *vcpu_reg(vcpu, p->Rt);
> > +	val = *p->val;
> 
> Why does it have to be a pointer? You could just have "val = p->val" if
> you carried the actual value instead of a pointer to the stack variable
> holding that value.

 There's only one concern for pointer approach. Actually, this refactor is based on my vGICv3 live migration API patch set:
http://www.spinics.net/lists/kvm/msg124205.html
http://www.spinics.net/lists/kvm/msg124202.html

 It's simply more convenient to use a pointer for exchange with userspace, see vgic_v3_cpu_regs_access() and callers. I wouldn't
like to refactor the code again. What's your opinion on this?
 And of course i'll fix up the rest.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
