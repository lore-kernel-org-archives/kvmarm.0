Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1B02CA4
	for <kvmarm@lists.linux.dev>; Sun,  6 Nov 2022 16:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667751756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H20v1cqeTFlHUSZvF7zpeNTQPp+u9jgZyQm6uqb6iO8=;
	b=PSXB1IPQjK2IR34FzvZglDGvk87jTZZarlyLTjm7OYf1xW3hjG+bOVYX1JYFm0MG2tRHf0
	tDRBdjCl15SAEMFXyJMocqATFS/yaIpsShLTTykvaiUB6Jand2Otq1gVg4mB8+ND46wlXy
	rJJ+gO9bu31SmWdsyuWLX4eyB5yM4K4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-439-ohFRw4gMPISFAyitbXK7Nw-1; Sun, 06 Nov 2022 11:22:32 -0500
X-MC-Unique: ohFRw4gMPISFAyitbXK7Nw-1
Received: by mail-qv1-f72.google.com with SMTP id q16-20020a0ce210000000b004ba8976d3aaso6181633qvl.5
        for <kvmarm@lists.linux.dev>; Sun, 06 Nov 2022 08:22:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H20v1cqeTFlHUSZvF7zpeNTQPp+u9jgZyQm6uqb6iO8=;
        b=ZlFZY6kE+YlR7enOALQiWkPq6rneECyZUcbqGKerINdPR/S1KAxusk6q8LsMPlXvz8
         7lBSjFUi9kzStiV1NDQrG04WTq7zzroIvNIQEEiswY4eNSsc9MHU+c6DIV00zg3bX/8q
         vLq+AOfsowri+uawywrr5bb+2Ib86fu5TkYflf3R2iaSo+QCulms8AFK/sdmoHJMYRc4
         HBhhHxDf6LkYUJ/FhosYB+5MBeoFHH9QlcyGX7/Y2eqmVGExESOyl0F9GC4KaHPGUIbu
         iuwGi3WMpruAl51rbo24DBGrJreCqu9YU9p9wc+Ouk43mwdEKjEZz+ubbmEzRD4YQSPA
         WqEg==
X-Gm-Message-State: ACrzQf31qCU7sV+n2pGHOtb774uBJyCI+9cVLYV2D/H75IiRAY+gzTRM
	NdCOo6wXYOKKzhnnYdjIBcsbQ/txtkTgP7g0cRX3c6GUGm0VZD694q+4JwCmZ3tkIoLQXsBOrC2
	SKDclK8j4L/Qm85en
X-Received: by 2002:ad4:5be4:0:b0:4bb:e947:c664 with SMTP id k4-20020ad45be4000000b004bbe947c664mr35673912qvc.122.1667751752346;
        Sun, 06 Nov 2022 08:22:32 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4qXfWU3rRVYOMwffAULeycyo0cR3quhzthJX0gEGzox/PFp3S4akUblLJhi8FVLsZsWmuQug==
X-Received: by 2002:ad4:5be4:0:b0:4bb:e947:c664 with SMTP id k4-20020ad45be4000000b004bbe947c664mr35673894qvc.122.1667751752071;
        Sun, 06 Nov 2022 08:22:32 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id x18-20020a05620a259200b006e42a8e9f9bsm4650486qko.121.2022.11.06.08.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 08:22:31 -0800 (PST)
Date: Sun, 6 Nov 2022 11:22:29 -0500
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shuah@kernel.org,
	catalin.marinas@arm.com, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
	will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	pbonzini@redhat.com, seanjc@google.com, oliver.upton@linux.dev,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2ffRYoqlQOxgVtk@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <87o7tkf5re.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221106162229.VUYhAkvAPc8DxTgNu7of1U7l5k-ZTGMUE6yazBMI6ek@z>

Hi, Marc,

On Sun, Nov 06, 2022 at 03:43:17PM +0000, Marc Zyngier wrote:
> > +Note that the bitmap here is only a backup of the ring structure, and
> > +normally should only contain a very small amount of dirty pages, which
> 
> I don't think we can claim this. It is whatever amount of memory is
> dirtied outside of a vcpu context, and we shouldn't make any claim
> regarding the number of dirty pages.

The thing is the current with-bitmap design assumes that the two logs are
collected in different windows of migration, while the dirty log is only
collected after the VM is stopped.  So collecting dirty bitmap and sending
the dirty pages within the bitmap will be part of the VM downtime.

It will stop to make sense if the dirty bitmap can contain a large portion
of the guest memory, because then it'll be simpler to just stop the VM,
transfer pages, and restart on dest node without any tracking mechanism.

[1]

> 
> > +needs to be transferred during VM downtime. Collecting the dirty bitmap
> > +should be the very last thing that the VMM does before transmitting state
> > +to the target VM. VMM needs to ensure that the dirty state is final and
> > +avoid missing dirty pages from another ioctl ordered after the bitmap
> > +collection.
> > +
> > +To collect dirty bits in the backup bitmap, the userspace can use the
> > +same KVM_GET_DIRTY_LOG ioctl. KVM_CLEAR_DIRTY_LOG shouldn't be needed
> > +and its behavior is undefined since collecting the dirty bitmap always
> > +happens in the last phase of VM's migration.
> 
> It isn't clear to me why KVM_CLEAR_DIRTY_LOG should be called out. If
> you have multiple devices that dirty the memory, such as multiple
> ITSs, why shouldn't userspace be allowed to snapshot the dirty state
> multiple time? This doesn't seem like a reasonable restriction, and I
> really dislike the idea of undefined behaviour here.

I suggested the paragraph because it's very natural to ask whether we'd
need to CLEAR_LOG for this special GET_LOG phase, so I thought this could
be helpful as a reference to answer that.

I wanted to make it clear that we don't need CLEAR_LOG at all in this case,
as fundamentally clear log is about re-protect the guest pages, but if
we're with the restriction of above (having the dirty bmap the last to
collect and once and for all) then it'll make no sense to protect the guest
page at all at this stage since src host shouldn't run after the GET_LOG
then the CLEAR_LOG will be a vain effort.

I used "undefined" here just to be loose on the interface, also a hint that
we should never do that for this specific GET_LOG.  If we want, we can
ignore CLEAR_LOG in the future with ALLOW_BITMAP, and the undefined also
provides the flexibility, but that's not really that important.

The wording could definitely be improved, or maybe even avoid mentioning
the CLEAR_LOG might help, but IIUC the major thing to reach the consensus
is not CLEAR_LOG itself but on whether we can have that assumption [1] and
whether such a design of using dirty bmap is acceptable in general.

Thanks,

-- 
Peter Xu

