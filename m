Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298F033EC
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681938322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K31e2CBPca9BkIHzLX3O1vK6DoPB0CPQFuuvj3uSzT4=;
	b=GwHqcxviUitIOHWW9lDGXwImCIEo21L86kuYPnkcPYizYUFXKtp5SA6jd+zwq3cpl71Nf4
	ysk8oG5DAxlWLfBJK2RPwcFFLpn7T5Yma0gkLRbCLuhF0m72YRmrlxSgx+artmiTUY3L9e
	sKRfxdSPGXd8QDJfNFpm8xq7w3a/90Y=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-VnlulHORM4SCmyEtfKxMKw-1; Wed, 19 Apr 2023 17:05:19 -0400
X-MC-Unique: VnlulHORM4SCmyEtfKxMKw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-74e23e33f80so2786285a.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 14:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681938318; x=1684530318;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K31e2CBPca9BkIHzLX3O1vK6DoPB0CPQFuuvj3uSzT4=;
        b=kmkIesRsdJaUd4lk8E0RCrtULzFCB4zdqlXa0vliNjwglIT2crFb4/OUbg1UXwg/Kn
         N6mtQoXwHcCypBW793MIPrtlmB//gsgUjaj1TnpalkRRV9UBiE5IzYrkhjZgajmty1DG
         95h2XYlEQ6oi5qEMRhUuGvKfHyV1zCZabQKrR+hs5PRg27Vojmm3EiS9wQB44QC6N5lk
         N3U8auLc9jSitlzngBDghyt5A765XLKB5adLXpJEF+dVcXuSHePi1nyCCDO9go2ILuqC
         gGaNu/cxaUYb3i4I6FaKiUEL0xiwtwUYY8xKan+8yi/p5OGRlG6u/NOc48K7RpU26Ili
         PZjQ==
X-Gm-Message-State: AAQBX9c6KtxbVjxkPnmmxvu7vU0K91xqYASjJZ8CNsV0DCj9PHvdyQWr
	64vrN35anoCNdz82ygA5t8Lj8be2v5PH+sDozf/bn85mn0JBi47smFa0FbUnV/3yn6FSCYKarTY
	gUUeJyPvuMKRdpfFs
X-Received: by 2002:ad4:5de6:0:b0:5f7:d2da:c69e with SMTP id jn6-20020ad45de6000000b005f7d2dac69emr949039qvb.4.1681938317851;
        Wed, 19 Apr 2023 14:05:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350YM9Mkg/RLtzzzQORTxhpWcA/r3GJ8wTX6W3rcfDA1Qi37vvCVchh5gS96u9BYfhzKt2Iqqhw==
X-Received: by 2002:ad4:5de6:0:b0:5f7:d2da:c69e with SMTP id jn6-20020ad45de6000000b005f7d2dac69emr948994qvb.4.1681938317497;
        Wed, 19 Apr 2023 14:05:17 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id y30-20020a05620a09de00b0074683c45f6csm4937152qky.1.2023.04.19.14.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 14:05:16 -0700 (PDT)
Date: Wed, 19 Apr 2023 17:05:15 -0400
From: Peter Xu <peterx@redhat.com>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
	maz@kernel.org, oliver.upton@linux.dev, seanjc@google.com,
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
	ricarkol@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZEBXi5tZZNxA+jRs@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Apr 19, 2023 at 01:15:44PM -0700, Axel Rasmussen wrote:
> On Wed, Apr 19, 2023 at 12:56 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > Hi, Anish,
> >
> > On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> > > KVM's demand paging self test is extended to demonstrate the performance
> > > benefits of using the two new capabilities to bypass the userfaultfd
> > > wait queue. The performance samples below (rates in thousands of
> > > pages/s, n = 5), were generated using [2] on an x86 machine with 256
> > > cores.
> > >
> > > vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new caps)
> > > 1       150     340
> > > 2       191     477
> > > 4       210     809
> > > 8       155     1239
> > > 16      130     1595
> > > 32      108     2299
> > > 64      86      3482
> > > 128     62      4134
> > > 256     36      4012
> >
> > The number looks very promising.  Though..
> >
> > >
> > > [1] https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
> > > [2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
> > >     A quick rundown of the new flags (also detailed in later commits)
> > >         -a registers all of guest memory to a single uffd.
> >
> > ... this is the worst case scenario.  I'd say it's slightly unfair to
> > compare by first introducing a bottleneck then compare with it. :)
> >
> > Jokes aside: I'd think it'll make more sense if such a performance solution
> > will be measured on real systems showing real benefits, because so far it's
> > still not convincing enough if it's only with the test especially with only
> > one uffd.
> >
> > I don't remember whether I used to discuss this with James before, but..
> >
> > I know that having multiple uffds in productions also means scattered guest
> > memory and scattered VMAs all over the place.  However split the guest
> > large mem into at least a few (or even tens of) VMAs may still be something
> > worth trying?  Do you think that'll already solve some of the contentions
> > on userfaultfd, either on the queue or else?
> 
> We considered sharding into several UFFDs. I do think it helps, but
> also I think there are two main problems with it:
> 
> - One is, I think there's a limit to how much you'd want to do that.
> E.g. splitting guest memory in 1/2, or in 1/10, could be reasonable,
> but 1/100 or 1/1000 might become ridiculous in terms of the
> "scattering" of VMAs and so on like you mentioned. Especially for very
> large VMs (e.g. consider Google offers VMs with ~11T of RAM [1]) I'm
> not sure splitting just "slightly" is enough to get good performance.
> 
> - Another is, sharding UFFDs sort of assumes accesses are randomly
> distributed across the guest physical address space. I'm not sure this
> is guaranteed for all possible VMs / customer workloads. In other
> words, even if we shard across several UFFDs, we may end up with a
> small number of them being "hot".

I never tried to monitor this, but I had a feeling that it's actually
harder to maintain physical continuity of pages being used and accessed at
least on Linux.

The more possible case to me is the system pages goes very scattered easily
after boot a few hours unless special care is taken, e.g., on using hugetlb
pages or reservations for specific purpose.

I also think that's normally optimal to the system, e.g., numa balancing
will help nodes / cpus using local memory which helps spread the memory
consumptions, hence each core can access different pages that is local to
it.

But I agree I can never justify that it'll always work.  If you or Anish
could provide some data points to further support this issue that would be
very interesting and helpful, IMHO, not required though.

> 
> A benefit to Anish's series is that it solves the problem more
> fundamentally, and allows demand paging with no "global" locking. So,
> it will scale better regardless of VM size, or access pattern.
> 
> [1]: https://cloud.google.com/compute/docs/memory-optimized-machines
> 
> >
> > With a bunch of VMAs and userfaultfds (paired with uffd fault handler
> > threads, totally separate uffd queues), I'd expect to some extend other
> > things can pop up already, e.g., the network bandwidth, without teaching
> > each vcpu thread to report uffd faults themselves.
> >
> > These are my pure imaginations though, I think that's also why it'll be
> > great if such a solution can be tested more or less on a real migration
> > scenario to show its real benefits.
> 
> I wonder, is there an existing open source QEMU/KVM based live
> migration stress test?

I am not aware of any.

> 
> I think we could share numbers from some of our internal benchmarks,
> or at the very least give relative numbers (e.g. +50% increase), but
> since a lot of the software stack is proprietary (e.g. we don't use
> QEMU), it may not be that useful or reproducible for folks.

Those numbers can still be helpful.  I was not asking for reproduceability,
but some test to better justify this feature.

IMHO the demand paging test (at least the current one) may or may not be a
good test to show the value of this specific feature.  When with 1-uffd, it
obviously bottlenecks on the single uffd, so it doesn't explain whether
scaling num of uffds could help.

But it's not friendly to multi-uffd either, because it'll be the other
extreme case where all mem accesses are spread the cores, so probably the
feature won't show a result proving its worthwhile.

From another aspect, if a kernel feature is proposed it'll be always nice
(and sometimes mandatory) to have at least one user of it (besides the unit
tests).  I think that should also include proprietary softwares.  It
doesn't need to be used already in production, but some POC would
definitely be very helpful to move a feature forward towards community
acceptance.

Thanks,

-- 
Peter Xu

