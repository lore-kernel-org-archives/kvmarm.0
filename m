Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDA7C8E5
	for <kvmarm@lists.linux.dev>; Mon, 15 May 2023 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684163150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mMiRcXgp4xTERmW4ger84CCwzwpKxTdK8sNyJO+9QFs=;
	b=f9hPw32nJL+W1LaKBK3CouLG9tVgYFeP4qRo/xd5OKc59mMb5GUnawx2ozMfN0DRY1m/ui
	fDRssxYgU9P7snMNw9ZTFW27qgX75LtyETzCZJeMAsQVsJ23kkqylh79eZLCz4DVyQLesS
	y+SodaXQj2puBtevaDlkUSoH3GXAQF4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-aVMlq2NTM8mQ2fDTeeUkrA-1; Mon, 15 May 2023 11:05:49 -0400
X-MC-Unique: aVMlq2NTM8mQ2fDTeeUkrA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3f386bb966cso7073671cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 May 2023 08:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684163149; x=1686755149;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mMiRcXgp4xTERmW4ger84CCwzwpKxTdK8sNyJO+9QFs=;
        b=FhiWct1icF0KrHvyONG51wH6yppy9ymPwElGvlpStZ8t0aYmxCGNN0/yPZN/AqxS7H
         7/GeMc6h/TXd00d7Gh/lCyENMBZaDAQC3jraFEymDQ/Ke8PjdMKWYhibkKBQx86LwRpF
         e2ZRRwtehMX/gAxaauz2mj46fQFL7r2rnxYL6qgRrOM0pAjNVsZzdQONBIyS09QS3qRU
         zW45aOvE74/SPq/9CbfSKOEzAbSy2g5vNjjEwmKVzBcJDVfIG6wzxNnyHIvhhWzd7fSK
         Ov29VyMFFOx9HfmLDpa89+SDnTpSHrP1ochuMQMfPbUs9uPLNwAwk04nO/WXwWcZr1iy
         iU+Q==
X-Gm-Message-State: AC+VfDwW4CE5t0fOWXQ3evr4nNjRzxzZDm57/qsKv7qBmNgoKG1vFeZL
	+4N97yNvZIyIoCRGeD3Nv02+YNRtREre7VCHMJP8Bzdu5R0WGUzGlImUwg9O0niSXODnPPiAx6t
	drLrnTRC3d3GTbl2g
X-Received: by 2002:a05:622a:14ce:b0:3ef:5587:723b with SMTP id u14-20020a05622a14ce00b003ef5587723bmr15837181qtx.3.1684163148743;
        Mon, 15 May 2023 08:05:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6fuKFZn8nWKO+IpreRY5odGmJjJSvH/yDsUT1zPfllrG5zSJxbS/qVgIBwFcdhWdqsqk3Pdw==
X-Received: by 2002:a05:622a:14ce:b0:3ef:5587:723b with SMTP id u14-20020a05622a14ce00b003ef5587723bmr15837145qtx.3.1684163148295;
        Mon, 15 May 2023 08:05:48 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-62-70-24-86-62.dsl.bell.ca. [70.24.86.62])
        by smtp.gmail.com with ESMTPSA id ay24-20020a05622a229800b003ee4b5a2dd3sm4386360qtb.21.2023.05.15.08.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 08:05:47 -0700 (PDT)
Date: Mon, 15 May 2023 11:05:46 -0400
From: Peter Xu <peterx@redhat.com>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Matlack <dmatlack@google.com>,
	Anish Moorthy <amoorthy@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
	bgardon@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZGJKSl7mb5t30zwN@x1n>
References: <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
 <ZFQC5TZ9tVSvxFWt@x1n>
 <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n>
 <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n>
 <CALzav=e29rRw4TTRGpTkazgJpU1zPML3zQGoyeHj9Zbkq+yAdQ@mail.gmail.com>
 <CAJHvVci4VuQ_vdpRKczg4ic6x7eZRXE4+ZUvzO-xU_9VJ1Vqvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAJHvVci4VuQ_vdpRKczg4ic6x7eZRXE4+ZUvzO-xU_9VJ1Vqvg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, May 11, 2023 at 10:33:24AM -0700, Axel Rasmussen wrote:
> On Thu, May 11, 2023 at 10:18 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, May 10, 2023 at 2:50 PM Peter Xu <peterx@redhat.com> wrote:
> > > On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> > > > On Sun, May 7, 2023 at 6:23 PM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > What I wanted to do is to understand whether there's still chance to
> > > provide a generic solution.  I don't know why you have had a bunch of pmu
> > > stack showing in the graph, perhaps you forgot to disable some of the perf
> > > events when doing the test?  Let me know if you figure out why it happened
> > > like that (so far I didn't see), but I feel guilty to keep overloading you
> > > with such questions.
> > >
> > > The major problem I had with this series is it's definitely not a clean
> > > approach.  Say, even if you'll all rely on userapp you'll still need to
> > > rely on userfaultfd for kernel traps on corner cases or it just won't work.
> > > IIUC that's also the concern from Nadav.
> >
> > This is a long thread, so apologies if the following has already been discussed.
> >
> > Would per-tid userfaultfd support be a generic solution? i.e. Allow
> > userspace to create a userfaultfd that is tied to a specific task. Any
> > userfaults encountered by that task use that fd, rather than the
> > process-wide fd. I'm making the assumption here that each of these fds
> > would have independent signaling mechanisms/queues and so this would
> > solve the scaling problem.
> >
> > A VMM could use this to create 1 userfaultfd per vCPU and 1 thread per
> > vCPU for handling userfault requests. This seems like it'd have
> > roughly the same scalability characteristics as the KVM -EFAULT
> > approach.
> 
> I think this would work in principle, but it's significantly different
> from what exists today.
> 
> The splitting of userfaultfds Peter is describing is splitting up the
> HVA address space, not splitting per-thread.

[sorry mostly travel last week]

No, my idea was actually split per-thread, but since currently there's no
way to split per thread I was thinking we should start testing with split
per vma so it "emulates" the best we can have out of a split per thread.

> 
> I think for this design, we'd need to change UFFD registration so
> multiple UFFDs can register the same VMA, but can be filtered so they
> only receive fault events caused by some particular tid(s).

Having multiple real uffds per vma is challenging, as you mentioned
enqueuing may be more of an effort, meanwhile it's hard to know what's the
attribute of the uffd over this vma because each uffd has one feature list.

Here what we may need is only the "logical queue" of the uffd.  So I was
considering supporting multi-queue for a _single_ userfaultfd.

I actually mentioned some of it in the very initial reply to Anish:

https://lore.kernel.org/all/ZEGuogfbtxPNUq7t@x1n/

        If the real problem relies in a bunch of threads queuing, is it
        possible that we can provide just more queues for the events?  The
        readers will just need to go over all the queues.

        Way to decide "which thread uses which queue" can be another
        problem, what comes ups quickly to me is a "hash(tid) % n_queues"
        but maybe it can be better.  Each vcpu thread will have different
        tids, then they can hopefully scale on the queues.

The queues may need to be created also as sub-uffds, each only support
partial of the uffd interfaces (read/poll, COPY/CONTINUE/ZEROPAGE) but not
all (e.g. UFFDIO_API shouldn't be supported there).

> This might also incur some (small?) overhead, because in the fault path
> we now need to maintain some data structure so we can lookup which UFFD
> to notify based on a combination of the address and our tid. Today, since
> VMAs and UFFDs are 1:1 this lookup is trivial.  I think it's worth
> keeping in mind that a selling point of Anish's approach is that it's a
> very small change. It's plausible we can come up with some alternative
> way to scale, but it seems to me everything suggested so far is likely to
> require a lot more code, complexity, and effort vs. Anish's approach.

Yes, I think that's also the reason why I thought I overloaded too much on
this work.  If Anish eagerly wants that and make it useful, then I'm
totally fine because maintaining the 2nd cap seems trivial assuming the
maintainer already would accept the 1st cap.

I just hope it'll be thoroughly tested with even Google's private userspace
hypervisor, so the kernel interface is (even if not straightforward enough
to a new user seeing this) solid so it will service the goal for the
problem Anish is tackling with.

Thanks,

-- 
Peter Xu

