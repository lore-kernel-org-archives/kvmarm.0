From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v5 2/2] KVM: Make KVM_CAP_IRQFD dependent on
 KVM_CAP_IRQCHIP
Date: Mon, 30 Nov 2015 13:13:31 +0100
Message-ID: <20151130131331.78d98df5.cornelia.huck@de.ibm.com>
References: <cover.1448874023.git.p.fedin@samsung.com>
 <57888eef1c5c21337ddad384250bc5f55829ac67.1448874023.git.p.fedin@samsung.com>
 <20151130122627.12ceb244.cornelia.huck@de.ibm.com>
 <017101d12b66$2c8cf970$85a6ec50$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F5449680
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 07:12:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u9qWqvl81CVW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2015 07:12:16 -0500 (EST)
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6429B4852E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 07:12:16 -0500 (EST)
Received: from localhost
 by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <cornelia.huck@de.ibm.com>;
 Mon, 30 Nov 2015 12:13:35 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com
 (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
 by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0FC221B08075
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 12:13:59 +0000 (GMT)
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com
 [9.149.37.229])
 by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 tAUCDXxc6685002
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 12:13:33 GMT
Received: from d06av05.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av05.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 tAUCDWGg012823
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 05:13:33 -0700
In-Reply-To: <017101d12b66$2c8cf970$85a6ec50$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Gleb Natapov' <gleb@kernel.org>, 'Paolo Bonzini' <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 30 Nov 2015 14:56:38 +0300
Pavel Fedin <p.fedin@samsung.com> wrote:

>  Hello!
> 
> > >  	case KVM_CAP_INTERNAL_ERROR_DATA:
> > >  #ifdef CONFIG_HAVE_KVM_MSI
> > >  	case KVM_CAP_SIGNAL_MSI:
> > > +		/* Fallthrough */
> > >  #endif
> > > +	case KVM_CAP_CHECK_EXTENSION_VM:
> > > +		return 1;
> > >  #ifdef CONFIG_HAVE_KVM_IRQFD
> > >  	case KVM_CAP_IRQFD:
> > >  	case KVM_CAP_IRQFD_RESAMPLE:
> > > +		return kvm_vm_ioctl_check_extension(kvm, KVM_CAP_IRQCHIP);
> > 
> > This won't work for s390, as it doesn't have KVM_CAP_IRQCHIP but
> > KVM_CAP_S390_IRQCHIP (which needs to be enabled).
> 
>  Thank you for the note, i didn't know about irqchip-specific capability codes. There's the same issue with PowerPC, now i
> understand why there's no KVM_CAP_IRQCHIP for them. Because they have KVM_CAP_IRQ_MPIC and KVM_CAP_IRQ_XICS, similar to S390.
>  But isn't it just weird? I understand that perhaps we have some real need to distinguish between different irqchip types, but
> shouldn't the kernel also publish KVM_CAP_IRQCHIP, which stands just for "we support some irqchip virtualization"?
>  May be we should just add this for PowerPC and S390, to make things less ambiguous?

Note that we explicitly need to _enable_ the s390 cap (for
compatibility). I'd need to recall the exact details but I came to the
conclusion back than that I could not simply enable KVM_CAP_IRQCHIP for
s390 (and current qemu would fail to enable the s390 cap if we started
advertising KVM_CAP_IRQCHIP now).
