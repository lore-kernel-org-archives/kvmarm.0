Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0141A47
	for <kvmarm@lists.linux.dev>; Fri,  4 Nov 2022 01:06:16 +0000 (UTC)
Date: Fri, 4 Nov 2022 01:06:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1667523974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bKxKhySc2WJqu4VmQGIMdexfpeONNbD4T7hOlSoxqCw=;
	b=iZspM8OSBuirndZgGJBhxe0XlxDxbKVfw5Bx17VFUn6k1gvXRo8iqyWd11HkHjyiKq5L9f
	5ATaB71ArQ6hwHM0SSZkTcpjQwbc+2PqTvxPTLIIVZybb/eTe55lEP4JPLuUh+JPZtik3Q
	/rhEG/4b7pJJ8jiai8XlShAcpV3jPMM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
	catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
	pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
	james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2RlfkyQMCtD6Rbh@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
 <Y2RPhwIUsGLQ2cz/@google.com>
 <d5b86a73-e030-7ce3-e5f3-301f4f505323@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5b86a73-e030-7ce3-e5f3-301f4f505323@redhat.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221104010606.L23mzb0YnYwwtyFlaepinjp20Rh8zk0_UGGijUv24Ac@z>

On Fri, Nov 04, 2022 at 08:12:21AM +0800, Gavin Shan wrote:
> Hi Oliver,
> 
> On 11/4/22 7:32 AM, Oliver Upton wrote:
> > On Mon, Oct 31, 2022 at 08:36:16AM +0800, Gavin Shan wrote:
> > > ARM64 needs to dirty memory outside of a VCPU context when VGIC/ITS is
> > > enabled. It's conflicting with that ring-based dirty page tracking always
> > > requires a running VCPU context.
> > > 
> > > Introduce a new flavor of dirty ring that requires the use of both VCPU
> > > dirty rings and a dirty bitmap. The expectation is that for non-VCPU
> > > sources of dirty memory (such as the VGIC/ITS on arm64), KVM writes to
> > > the dirty bitmap. Userspace should scan the dirty bitmap before migrating
> > > the VM to the target.
> > > 
> > > Use an additional capability to advertise this behavior. The newly added
> > > capability (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) can't be enabled before
> > > KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. In this way, the newly added
> > > capability is treated as an extension of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
> > 
> > Whatever ordering requirements we settle on between these capabilities
> > needs to be documented as well.
> > 
> > [...]
> > 
> 
> It's mentioned in 'Documentation/virt/kvm/api.rst' as below.
> 
>   After using the dirty rings, the userspace needs to detect the capability
>   of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP to see whether the ring structures
>   need to be backed by per-slot bitmaps. With this capability advertised
>   and supported, it means the architecture can dirty guest pages without
>   vcpu/ring context, so that some of the dirty information will still be
>   maintained in the bitmap structure.
> 
> The description may be not obvious about the ordering. For this, I can
> add the following sentence at end of the section.
> 
>   The capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP can't be enabled
>   until the capability of KVM_CAP_DIRTY_LOG_RING_ACQ_REL has been enabled.
> 
> > > @@ -4588,6 +4594,13 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> > >   			return -EINVAL;
> > >   		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> > > +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
> > > +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> > > +		    !kvm->dirty_ring_size)
> > 
> > I believe this ordering requirement is problematic, as it piles on top
> > of an existing problem w.r.t. KVM_CAP_DIRTY_LOG_RING v. memslot
> > creation.
> > 
> > Example:
> >   - Enable KVM_CAP_DIRTY_LOG_RING
> >   - Create some memslots w/ dirty logging enabled (note that the bitmap
> >     is _not_ allocated)
> >   - Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
> >   - Save ITS tables and get a NULL dereference in
> >     mark_page_dirty_in_slot():
> > 
> >                  if (vcpu && kvm->dirty_ring_size)
> >                          kvm_dirty_ring_push(&vcpu->dirty_ring,
> >                                              slot, rel_gfn);
> >                  else
> > ------->		set_bit_le(rel_gfn, memslot->dirty_bitmap);
> > 
> > Similarly, KVM may unnecessarily allocate bitmaps if dirty logging is
> > enabled on memslots before KVM_CAP_DIRTY_LOG_RING is enabled.
> > 
> > You could paper over this issue by disallowing DIRTY_RING_WITH_BITMAP if
> > DIRTY_LOG_RING has already been enabled, but the better approach would
> > be to explicitly check kvm_memslots_empty() such that the real
> > dependency is obvious. Peter, hadn't you mentioned something about
> > checking against memslots in an earlier revision?
> > 
> 
> The userspace (QEMU) needs to ensure that no dirty bitmap is created
> before the capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP is enabled.
> It's unknown by QEMU that vgic/its is used when KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> is enabled.

I'm not worried about what QEMU (or any particular VMM for that matter)
does with the UAPI. The problem is this patch provides a trivial way for
userspace to cause a NULL dereference in the kernel. Imposing ordering
between the cap and memslot creation avoids the problem altogether.

So, looking at your example:

>    kvm_initialization
>      enable_KVM_CAP_DIRTY_LOG_RING_ACQ_REL        // Where KVM_CAP_DIRTY_LOG_RING is enabled
>    board_initialization                           // Where QEMU knows if vgic/its is used

Is it possible that QEMU could hoist enabling RING_WITH_BITMAP here?
Based on your description QEMU has decided to use the vGIC ITS but
hasn't yet added any memslots.

>      add_memory_slots
>    kvm_post_initialization
>      enable_KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
>    :
>    start_migration
>      enable_dirty_page_tracking
>        create_dirty_bitmap                       // With KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP enabled

Just to make sure we're on the same page, there's two issues:

 (1) If DIRTY_LOG_RING is enabled before memslot creation and
     RING_WITH_BITMAP is enabled after memslots have been created w/
     dirty logging enabled, memslot->dirty_bitmap == NULL and the
     kernel will fault when attempting to save the ITS tables.

 (2) Not your code, but a similar issue. If DIRTY_LOG_RING[_ACQ_REL] is
     enabled after memslots have been created w/ dirty logging enabled,
     memslot->dirty_bitmap != NULL and that memory is wasted until the
     memslot is freed.

I don't expect you to fix #2, though I've mentioned it because using the
same approach to #1 and #2 would be nice.

--
Thanks,
Oliver
