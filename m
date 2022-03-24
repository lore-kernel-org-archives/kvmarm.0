Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C40C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 09:04:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B77C49ED1;
	Thu, 24 Mar 2022 05:04:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gbkfnNVLISDC; Thu, 24 Mar 2022 05:04:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 388A149F0A;
	Thu, 24 Mar 2022 05:04:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6745F49ED1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 05:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cC26myccbVq1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 05:04:45 -0400 (EDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
 [209.85.166.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1088149EBB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 05:04:44 -0400 (EDT)
Received: by mail-io1-f44.google.com with SMTP id e22so4609206ioe.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 02:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hLMKV9xpskYCVwglq78GATmb0tIIibhlp1DIF9X1vs4=;
 b=M3lv1AuPL0bisoKr/J5KZ1FwUPCvwXbvAdzS/hiR5rP244r3TgkDcow2eDyuuEGDDk
 c+o7pktkIbCOubIuKY//azUU3n3YZptU38aBU2aBOnCJc2ubkDny33EkQ7NTXmR/o0ll
 GM1Ij/CWFNFkd5ucVKDI7wHASjpbDf1r0PWQslsdP0QiCHzfD3zYGVN3LkRjYnifBrDc
 Rq4nypvBxisQf7lVWW3s394AXXfIZhqmEAJOvxObl2qZUzpbyvutVBPq2WsD4ofBWJfT
 khfLN1696wse01rBubQKvjAbYq1UDLd2og8pI292HKgkwdFyi6zd/u8gHhPCvaNAwnKb
 YgTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hLMKV9xpskYCVwglq78GATmb0tIIibhlp1DIF9X1vs4=;
 b=FX4LWTMnSLmXQALsss0GEQyN9VMCWAxO3vvuYutyELiDvlMH4c/tD4YGDOsmeLiKNo
 9XRVkUJPqepRy6r1iEqCxM8YGaRamteDDH3ywa9uVx88QE0MVYA62hHibi173hlb8TYo
 X8Hzvg28UrlMxfz6OUiIqfxDekGzLAtctUd+VXOh/7lF4bVDqtEfFyfReLLcLGAoR6Qs
 rqUN9l9xO9iJ32KqrMJTAfXE6jHRLS4xQ4vnjA8CUxjHW6MpsXF9WIC2ub1ONxKL52Or
 2Gkqm3CXBadubg/eWE7LA9MFrm4NvR4jA7qvLCVsmLS3wCaLigGjMTtgajpuhHRH4Z3b
 5Daw==
X-Gm-Message-State: AOAM532IJkNgMWqcZian+8L2lox/sDAVuTuvq8yfVFfsZxdIYsveBBls
 LG2j9+NV1kyMfD5Z1nYDhjQEmA==
X-Google-Smtp-Source: ABdhPJy2wQnPDXYvg4eqx/57EAShdK7goC7DKCpVmFwW7MpIDLqBzkUr18ydysDB5iUU99AzRq2VJg==
X-Received: by 2002:a05:6638:b25:b0:317:3c79:d625 with SMTP id
 c5-20020a0566380b2500b003173c79d625mr2223397jab.63.1648112684101; 
 Thu, 24 Mar 2022 02:04:44 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 b1-20020a92a041000000b002c8214b2f65sm1235267ilm.61.2022.03.24.02.04.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 02:04:43 -0700 (PDT)
Date: Thu, 24 Mar 2022 09:04:40 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 02/22] KVM: arm64: Add SDEI virtualization
 infrastructure
Message-ID: <Yjw0KFZ+DG0A1KxK@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-3-gshan@redhat.com>
 <YjtUufdsWYxqdGa+@google.com>
 <4d4e5645-4443-c233-6d25-97e68d804512@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4d4e5645-4443-c233-6d25-97e68d804512@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Mar 24, 2022 at 02:54:00PM +0800, Gavin Shan wrote:
> > > +#define KVM_SDEI_DEFAULT_EVENT	0
> > > +
> > > +#define KVM_SDEI_MAX_VCPUS	512	/* Aligned to 64 */
> > > +#define KVM_SDEI_MAX_EVENTS	128
> > 
> > I would *strongly* recommend against having these limits. I find the
> > vCPU limit especially concerning, because we're making KVM_MAX_VCPUS
> > ABI, which it definitely is not. Anything that deals with a vCPU should
> > be accessed through a vCPU FD (and thus agnostic to the maximum number
> > of vCPUs) to avoid such a complication.
> > 
> 
> For KVM_SDEI_DEFAULT_EVENT, which corresponds to the software signaled
> event. As you suggested on PATCH[15/22], we can't assume its usage.
> I will define it with SDEI_SW_SIGNALED_EVENT in uapi/linux/arm_sdei.h
> 
> For KVM_SDEI_MAX_EVENTS, it will be moved from this header file to
> kvm_sdei.h after static arrays to hold the data structures or their
> pointers are used, as you suggested early for this patch (PATCH[02/22]).
> 
> There are two types of (SDEI) events: shared and private. For the private
> event, it can be registered independently from the vcpus. It also means
> the address and argument for the entry points, corresponding to @ep_address
> and @ep_arg in struct kvm_sdei_registered_event, can be different on
> the individual vcpus. However, all the registered/enabled states and
> the entry point address and argument are same on all vcpus for the shared
> event. KVM_SDEI_MAX_VCPUS was introduced to use same data structure to
> represent both shared and private event.

You're providing a great deal of abstraction around the SDEI
specification, but I really am unconvinced that KVM needs that. This
series needs to add support for a single SDEI event (event 0) and async
PF to follow. Since we are going to support a static set of events under
KVM I believe a lot of the complexity in this design should fade away.

> > > +struct kvm_sdei_exposed_event_state {
> > > +	__u64	num;
> > > +
> > > +	__u8	type;
> > > +	__u8	signaled;
> > > +	__u8	priority;
> > > +	__u8	padding[5];
> > > +	__u64	notifier;
> > 
> > Wait, isn't this a kernel function pointer!?
> > 
> 
> Yeah, it is a kernel function pointer, used by Async PF to know if
> the corresponding event has been handled or not. Async PF can cancel
> the previously injected event for performance concerns. Either Async PF
> or SDEI needs to migrate it. To keep SDEI transparent enough to Async PF,
> SDEI is responsible for its migration.

But this is a UAPI header, why would we even consider giving userspace a
window into the kernel like this? Couldn't userspace crash the kernel by
writing whatever it wants to this field, knowing that it will call it as
a function pointer?

Security aside, there's no guarantee that a function winds up at the
same address between compiler versions or kernel versions.

Overall, I don't think that userspace should have the ability to add
arbitrary SDEI events. KVM takes ownership of its own vendor-specific
ABI in patch 3/22 by declaring its vendor identifier, so any new events
we support must remain within KVM. There is going to be some state that
will need to be migrated for KVM's SDEI events, that ought to be
surfaced to userspace through the KVM_{GET,SET}_ONE_REG ioctls.

Given that there isn't much userspace involvement to make SDEI
work, do you think it would be possible to drop the proposed UAPI from
your series and work on enabling software-signaled SDEI events within
KVM first? By this I mean a VM running under KVM shouldn't require any
ioctls to make it work.

In so doing, we can discover exactly what the mechanics look like in KVM
and only then talk about the necessary UAPI to migrate state. One piece
of the mechanics that is top of mind which I'd like to see addressed is
the use of linked lists and the preallocations that have been made in
structures. KVM will know how many events exist at compile time, so we
can represent these statically.

> > > +};
> > > +
> > > +struct kvm_sdei_registered_event_state {
> > 
> > You should fold these fields together with kvm_sdei_exposed_event_state
> > into a single 'kvm_sdei_event' structure:
> > 
> 
> @route_mode and @route_affinity can't be configured or modified until
> the event is registered. Besides, they're only valid to the shared
> events. For private events, they don't have the routing needs. It means
> those two fields would be part of struct kvm_sdei_registered_event instead
> of kvm_sdei_exposed_event.
> 
> 
> > > +	__u64	num;
> > > +
> > > +	__u8	route_mode;
> > > +	__u8	padding[3];
> > > +	__u64	route_affinity;
> > 
> > And these shouldn't be UAPI at the VM scope. Each of these properties
> > could be accessed via a synthetic/'pseudo-firmware' register on a vCPU FD:
> > 
> 
> They're accessed through vcpu or kvm fd depending on what type the event
> is. For the VM-owned shared event, they're accessed through KVM fd. For the
> vcpu-owned private event, they're accessed through vcpu fd.

Some of the state that you represent in struct kvm_sdei_registered_event_state
is really per-vCPU state. Any time that there's data available at a vCPU
granularity userspace should access it with a vCPU FD.

> I'm not sure if I catch the idea to have a synthetic register and I'm to
> confirm. If I'm correct, you're talking about the "IMPLEMENTATION DEFINED"
> system register, whose OP0 and CRn are 0B11 and 0B1x11. If two implementation
> defined registers can be adopted, I don't think we need to expose anything
> through ABI. All the operations and the needed data can be passed through
> the system registers.

No, I'm not talking about the guest-facing interface. I'm talking about
what gets exposed to userspace to migrate the VM's state. For parts of
the guest that do not map to an architectural construct, we've defined
the concept of a firmware pseudo-register. What that really means is we
expose a register to userspace that is inaccessible from the guest which
migrates KVM's nonarchitected state. We are abusing the fact that VMMs
will save/restore whatever registers are reported on KVM_GET_REG_LIST to
trick it into migrating KVM state, and it has worked quite nicely to
avoid adding new ioctls for new features. It also means that older VMMs
are capable of utilizing new KVM features, so long as they obey the
prescribed rules.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
