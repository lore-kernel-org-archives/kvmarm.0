From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v5 2/2] KVM: Make KVM_CAP_IRQFD dependent on
 KVM_CAP_IRQCHIP
Date: Mon, 30 Nov 2015 15:41:20 +0300
Message-ID: <017801d12b6c$6a7c2c00$3f748400$@samsung.com>
References: <cover.1448874023.git.p.fedin@samsung.com>
 <57888eef1c5c21337ddad384250bc5f55829ac67.1448874023.git.p.fedin@samsung.com>
 <20151130122627.12ceb244.cornelia.huck@de.ibm.com>
 <017101d12b66$2c8cf970$85a6ec50$@samsung.com>
 <20151130131331.78d98df5.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A9EE48535
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 07:40:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SjOqsj7apHjT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2015 07:40:03 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68C6E496EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 07:40:02 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYM00AWEOKX8Q90@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 30 Nov 2015 12:41:21 +0000 (GMT)
In-reply-to: <20151130131331.78d98df5.cornelia.huck@de.ibm.com>
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
To: 'Cornelia Huck' <cornelia.huck@de.ibm.com>
Cc: kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Gleb Natapov' <gleb@kernel.org>, 'Paolo Bonzini' <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >  Thank you for the note, i didn't know about irqchip-specific capability codes. There's the
> > same issue with PowerPC, now i
> > understand why there's no KVM_CAP_IRQCHIP for them. Because they have KVM_CAP_IRQ_MPIC and
> > KVM_CAP_IRQ_XICS, similar to S390.
> >  But isn't it just weird? I understand that perhaps we have some real need to distinguish
> > between different irqchip types, but
> > shouldn't the kernel also publish KVM_CAP_IRQCHIP, which stands just for "we support some
> > irqchip virtualization"?
> >  May be we should just add this for PowerPC and S390, to make things less ambiguous?
> 
> Note that we explicitly need to _enable_ the s390 cap (for
> compatibility). I'd need to recall the exact details but I came to the
> conclusion back than that I could not simply enable KVM_CAP_IRQCHIP for
> s390 (and current qemu would fail to enable the s390 cap if we started
> advertising KVM_CAP_IRQCHIP now).

 OMG... I've looked at the code, what a mess...
 If i was implementing this, i'd simply introduce kvm_vm_enable_cap(s, KVM_CAP_IRQCHIP, 0),
which would be allowed to fail with -ENOSYS, so that backwards compatibility is kept and an existing API is reused... But, well,
it's already impossible to unscramble an egg... :)
 Ok, i think in current situation we could choose one of these ways (both are based on the fact that it's obvious that irqfd require
IRQCHIP).
 a) I look for an alternate way to report KVM_CAP_IRQFD dynamically, and maybe PowerPC and S390 follow this way.
 b) I simply drop it as it is, because current qemu knows about the dependency and does not try to use irqfd without irqchip,
because there's simply no use for them. But, well, perhaps there would be an exception in vhost, i don't remember testing it.
 So what shall we do?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
