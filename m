Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7366C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:31:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5CCA620706
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TSe+Czhn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CCA620706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05BF34B0DB;
	Mon, 22 Jun 2020 06:31:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QJaCcUfym0iy; Mon, 22 Jun 2020 06:31:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A50004B0A3;
	Mon, 22 Jun 2020 06:31:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC68A4B07F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:31:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eD2boIo1Agoz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 06:31:54 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77D774B0D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:31:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1592821914;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zstoew6+y+ErDDpNlJitNVBDWEMg32PIYZVfYRB6WUo=;
 b=TSe+CzhnKU48Oow/37X64QBvmHfG9alkzQnFwS6TRMyg+86Qz0p6llei7MxU5R52H74c/q
 KbkzixuEa9e8vqNqmK3lk7hMMGa7MDAPxKcT3LR1AlLUJWjQT54FCCiEZi/dYRGgw8P/dd
 edt89N2PmJ3ja7jgHNLP5Q8rwu1fa6w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-ArnuUmN3M1uOaHHBKtftMQ-1; Mon, 22 Jun 2020 06:31:52 -0400
X-MC-Unique: ArnuUmN3M1uOaHHBKtftMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 416451B18BC3;
 Mon, 22 Jun 2020 10:31:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9112F60C05;
 Mon, 22 Jun 2020 10:31:49 +0000 (UTC)
Date: Mon, 22 Jun 2020 12:31:46 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/4] arm64/x86: KVM: Introduce steal time cap
Message-ID: <20200622103146.fwtr7z3l3mnq4foh@kamzik.brq.redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
 <20200619184629.58653-3-drjones@redhat.com>
 <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
 <20200622084110.uosiqx3oy22lremu@kamzik.brq.redhat.com>
 <5a52210e5f123d52459f15c594e77bad@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5a52210e5f123d52459f15c594e77bad@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 steven.price@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Jun 22, 2020 at 10:51:47AM +0100, Marc Zyngier wrote:
> On 2020-06-22 09:41, Andrew Jones wrote:
> > On Mon, Jun 22, 2020 at 09:20:02AM +0100, Marc Zyngier wrote:
> > > Hi Andrew,
> > > 
> > > On 2020-06-19 19:46, Andrew Jones wrote:
> > > > arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
> > > > support for steal time. However this is unnecessary and complicates
> > > > userspace (userspace may prefer delaying vcpu creation until after
> > > > feature probing). Since probing steal time only requires a KVM fd,
> > > > we introduce a cap that can be checked.
> > > 
> > > So this is purely an API convenience, right? You want a way to
> > > identify the presence of steal time accounting without having to
> > > create a vcpu? It would have been nice to have this requirement
> > > before we merged this code :-(.
> > 
> > Yes. I wish I had considered it more closely when I was reviewing the
> > patches. And, I believe we have yet another user interface issue that
> > I'm looking at now. Without the VCPU feature bit I'm not sure how easy
> > it will be for a migration to fail when attempting to migrate from a
> > host
> > with steal-time enabled to one that does not support steal-time. So it's
> > starting to look like steal-time should have followed the pmu pattern
> > completely, not just the vcpu device ioctl part.
> 
> Should we consider disabling steal time altogether until this is worked out?

I think we can leave it alone and just try to resolve it before merging
QEMU patches (which I'm working on now). It doesn't look like kvmtool or
rust-vmm (the only other two KVM userspaces I'm paying some attention to)
do anything with steal-time yet, so they won't notice. And, I'm not sure
disabling steal-time for any other userspaces is better than just trying
to keep them working the best we can while improving the uapi.

> 
> > > 
> > > > Additionally, when probing
> > > > steal time we should check delayacct_on, because even though
> > > > CONFIG_KVM selects TASK_DELAY_ACCT, it's possible for the host
> > > > kernel to have delay accounting disabled with the 'nodelayacct'
> > > > command line option. x86 already determines support for steal time
> > > > by checking delayacct_on and can already probe steal time support
> > > > with a kvm fd (KVM_GET_SUPPORTED_CPUID), but we add the cap there
> > > > too for consistency.
> > > >
> > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > ---
> > > >  Documentation/virt/kvm/api.rst | 11 +++++++++++
> > > >  arch/arm64/kvm/arm.c           |  3 +++
> > > >  arch/x86/kvm/x86.c             |  3 +++
> > > >  include/uapi/linux/kvm.h       |  1 +
> > > >  4 files changed, 18 insertions(+)
> > > >
> > > > diff --git a/Documentation/virt/kvm/api.rst
> > > > b/Documentation/virt/kvm/api.rst
> > > > index 9a12ea498dbb..05b1fdb88383 100644
> > > > --- a/Documentation/virt/kvm/api.rst
> > > > +++ b/Documentation/virt/kvm/api.rst
> > > > @@ -6151,3 +6151,14 @@ KVM can therefore start protected VMs.
> > > >  This capability governs the KVM_S390_PV_COMMAND ioctl and the
> > > >  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
> > > >  guests when the state change is invalid.
> > > > +
> > > > +8.24 KVM_CAP_STEAL_TIME
> > > > +-----------------------
> > > > +
> > > > +:Architectures: arm64, x86
> > > > +
> > > > +This capability indicates that KVM supports steal time accounting.
> > > > +When steal time accounting is supported it may be enabled with
> > > > +architecture-specific interfaces.  For x86 see
> > > > +Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".  For arm64 see
> > > > +Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL"
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index 90cb90561446..f6dca6d09952 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -222,6 +222,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
> > > > long ext)
> > > >  		 */
> > > >  		r = 1;
> > > >  		break;
> > > > +	case KVM_CAP_STEAL_TIME:
> > > > +		r = sched_info_on();
> > > > +		break;
> > > >  	default:
> > > >  		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
> > > >  		break;
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 00c88c2f34e4..ced6335e403e 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -3533,6 +3533,9 @@ int kvm_vm_ioctl_check_extension(struct kvm
> > > > *kvm, long ext)
> > > >  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
> > > >  		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
> > > >  		break;
> > > > +	case KVM_CAP_STEAL_TIME:
> > > > +		r = sched_info_on();
> > > > +		break;
> > > >  	default:
> > > >  		break;
> > > >  	}
> > > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > > index 4fdf30316582..121fb29ac004 100644
> > > > --- a/include/uapi/linux/kvm.h
> > > > +++ b/include/uapi/linux/kvm.h
> > > > @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
> > > >  #define KVM_CAP_PPC_SECURE_GUEST 181
> > > >  #define KVM_CAP_HALT_POLL 182
> > > >  #define KVM_CAP_ASYNC_PF_INT 183
> > > > +#define KVM_CAP_STEAL_TIME 184
> > > >
> > > >  #ifdef KVM_CAP_IRQ_ROUTING
> > > 
> > > Shouldn't you also add the same check of sched_info_on() to
> > > the various pvtime attribute handling functions? It feels odd
> > > that the capability can say "no", and yet we'd accept userspace
> > > messing with the steal time parameters...
> > 
> > I considered that, but the 'has attr' interface is really only asking
> > if the interface exists, not if it should be used. I'm not sure what
> > we should do about it other than document that the cap needs to say
> > it's usable, rather than just the attr presence. But, since we've had
> > the attr merged quite a while without the cap, then maybe we can't
> > rely on a doc change alone?
> 
> Accepting the pvtime attributes (setting up the per-vcpu area) has two
> effects: we promise both the guest and userspace that we will provide
> the guest with steal time. By not checking sched_info_on(), we lie to
> both, with potential consequences. It really feels like a bug.

Yes, I agree now. Again, following the pmu pattern looks best here. The
pmu will report that it doesn't have the attr support when its underlying
kernel support (perf counters) doesn't exist. That's a direct analogy with
steal-time relying on sched_info_on().

I'll work up another version of this series doing that, but before posting
I'll look at the migration issue a bit more and likely post something for
that as well.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
