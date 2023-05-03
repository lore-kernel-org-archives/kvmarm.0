Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199CADF71
	for <kvmarm@lists.linux.dev>; Wed,  3 May 2023 21:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683149228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zRYrSNgpiPMEPps9ye4BB/zP/sPgUUxNWzkYkCFCxII=;
	b=KO9Z8A+8TeF9gzqpzci8OtfrmlzDmKEKgIoqqqTMOuJ1QI4G9sz0E5umzWZEyA8tl+98mE
	Ut9XSJ+zFjD1asHK4gmAsUN+4vwat+zHsP/EY83GvDHEMHzvL9pHHSTmKPK+yCAQhzQLKZ
	DtTw9lzmJJyxx56voxnNSfoiMTty33o=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-Zlq2lm5MNgm0Eb6WsrSy8g-1; Wed, 03 May 2023 17:27:05 -0400
X-MC-Unique: Zlq2lm5MNgm0Eb6WsrSy8g-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-61b636b5f90so3249726d6.1
        for <kvmarm@lists.linux.dev>; Wed, 03 May 2023 14:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683149225; x=1685741225;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zRYrSNgpiPMEPps9ye4BB/zP/sPgUUxNWzkYkCFCxII=;
        b=UI5rVrRgwTFijAfHyfmLdMtkwdCr5OHUJesLF3dpHjXeOsX9sJDODnHDe6aDTRtScO
         JoAwhpef8IsaszvmcNpD3VT6aiA4ZyLImI0oRxPgjsfC+iB+Jn14vZR6IMJPhAYp3Tpj
         sl5OpOT9+aSCqNoCegsBkbFJGqSqjNqAMxSkOtTijisq3JpbsAfILuXLWzqus/pymPZl
         BrUCd6HQXUtFAZTsQvsLvKqC8gpev3LmXio9p6umflS7c90de79yQbx0IUTmnObFql3S
         V8FXe/WQYbX7QZKo6+CkYwQvGNc5JhH5yx1RbMN/AbJJyYjfNpQy9h9+DFvaBL8pJIKI
         y1ZA==
X-Gm-Message-State: AC+VfDzZK5rw574zUmmoGwP1fRFN3GmM8gWyzJaUY6R9K4AKVTJCAfGx
	+/dpN5tPWJsL2jctZGr2uZiwq1KpJ3V5MvMkfQ9qSkexYGz409rFY+1Ookauuh5GbdRhohHEbe2
	V6u3F848eHC2N1qy7
X-Received: by 2002:a05:6214:518e:b0:5f1:31eb:1f0e with SMTP id kl14-20020a056214518e00b005f131eb1f0emr10702946qvb.4.1683149225087;
        Wed, 03 May 2023 14:27:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6VUszU2qmNVmjgb3iB/r4TqNmXOCMS3jwnE85/9bghI4vJMO7j2bpn5Ctu6Cbn3rd9JqWgag==
X-Received: by 2002:a05:6214:518e:b0:5f1:31eb:1f0e with SMTP id kl14-20020a056214518e00b005f131eb1f0emr10702920qvb.4.1683149224741;
        Wed, 03 May 2023 14:27:04 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id az12-20020a05620a170c00b0074fb15e2319sm8267844qkb.122.2023.05.03.14.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 14:27:03 -0700 (PDT)
Date: Wed, 3 May 2023 17:27:00 -0400
From: Peter Xu <peterx@redhat.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
	oliver.upton@linux.dev, Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>, bgardon@google.com,
	dmatlack@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFLRpEV09lrpJqua@x1n>
References: <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n>
 <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZFLPlRReglM/Vgfu@x1n>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Oops, bounced back from the list..

Forward with no attachment this time - I assume the information is still
enough in the paragraphs even without the flamegraphs.  Sorry for the
noise.

On Wed, May 03, 2023 at 05:18:13PM -0400, Peter Xu wrote:
> On Wed, May 03, 2023 at 12:45:07PM -0700, Anish Moorthy wrote:
> > On Thu, Apr 27, 2023 at 1:26 PM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > Thanks (for doing this test, and also to Nadav for all his inputs), and
> > > sorry for a late response.
> > 
> > No need to apologize: anyways, I've got you comfortably beat on being
> > late at this point :)
> > 
> > > These numbers caught my eye, and I'm very curious why even 2 vcpus can
> > > scale that bad.
> > >
> > > I gave it a shot on a test machine and I got something slightly different:
> > >
> > >   Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz (20 cores, 40 threads)
> > >   $ ./demand_paging_test -b 512M -u MINOR -s shmem -v N
> > >   |-------+----------+--------|
> > >   | n_thr | per-vcpu | total  |
> > >   |-------+----------+--------|
> > >   |     1 | 39.5K    | 39.5K  |
> > >   |     2 | 33.8K    | 67.6K  |
> > >   |     4 | 31.8K    | 127.2K |
> > >   |     8 | 30.8K    | 246.1K |
> > >   |    16 | 21.9K    | 351.0K |
> > >   |-------+----------+--------|
> > >
> > > I used larger ram due to less cores.  I didn't try 32+ vcpus to make sure I
> > > don't have two threads content on a core/thread already since I only got 40
> > > hardware threads there, but still we can compare with your lower half.
> > >
> > > When I was testing I noticed bad numbers and another bug on not using
> > > NSEC_PER_SEC properly, so I did this before the test:
> > >
> > > https://lore.kernel.org/all/20230427201112.2164776-1-peterx@redhat.com/
> > >
> > > I think it means it still doesn't scale that good, however not so bad
> > > either - no obvious 1/2 drop on using 2vcpus.  There're still a bunch of
> > > paths triggered in the test so I also don't expect it to fully scale
> > > linearly.  From my numbers I just didn't see as drastic as yours. I'm not
> > > sure whether it's simply broken test number, parameter differences
> > > (e.g. you used 64M only per-vcpu), or hardware differences.
> > 
> > Hmm, I suspect we're dealing with  hardware differences here. I
> > rebased my changes onto those two patches you sent up, taking care not
> > to clobber them, but even with the repro command you provided my
> > results look very different than yours (at least on 1-4 vcpus) on the
> > machine I've been testing on (4x AMD EPYC 7B13 64-Core, 2.2GHz).
> > 
> > (n=20)
> > n_thr      per_vcpu       total
> > 1            154K              154K
> > 2             92k                184K
> > 4             71K                285K
> > 8             36K                291K
> > 16           19K                310K
> > 
> > Out of interested I tested on another machine (Intel(R) Xeon(R)
> > Platinum 8273CL CPU @ 2.20GHz) as well, and results are a bit
> > different again
> > 
> > (n=20)
> > n_thr      per_vcpu       total
> > 1            115K              115K
> > 2             103k              206K
> > 4             65K                262K
> > 8             39K                319K
> > 16           19K                398K
> 
> Interesting.
> 
> > 
> > It is interesting how all three sets of numbers start off different
> > but seem to converge around 16 vCPUs. I did check to make sure the
> > memory fault exits sped things up in all cases, and that at least
> > stays true.
> > 
> > By the way, I've got a little helper script that I've been using to
> > run/average the selftest results (which can vary quite a bit). I've
> > attached it below- hopefully it doesn't bounce from the mailing list.
> > Just for reference, the invocation to test the command you provided is
> > 
> > > python dp_runner.py --num_runs 20 --max_cores 16 --percpu_mem 512M
> 
> I found that indeed I shouldn't have stopped at 16 vcpus since that's
> exactly where it starts to bottleneck. :)
> 
> So out of my curiosity I tried to profile 32 vcpus case on my system with
> this test case, meanwhile I tried it both with:
> 
>   - 1 uffd + 8 readers
>   - 32 uffds (so 32 readers)
> 
> I've got the flamegraphs attached for both.
> 
> It seems that when using >1 uffds the bottleneck is not the spinlock
> anymore but something else.
> 
> From what I got there, vmx_vcpu_load() gets more highlights than the
> spinlocks. I think that's the tlb flush broadcast.
> 
> While OTOH indeed when using 1 uffd we can see obviously the overhead of
> spinlock contention on either the fault() path or read()/poll() as you and
> James rightfully pointed out.
> 
> I'm not sure whether my number is caused by special setup, though. After
> all I only had 40 threads and I started 32 vcpus + 8 readers and there'll
> be contention already between the workloads.
> 
> IMHO this means that there's still chance to provide a more generic
> userfaultfd scaling solution as long as we can remove the single spinlock
> contention on the fault/fault_pending queues.  I'll see whether I can still
> explore a bit on the possibility of this and keep you guys updated.  The
> general idea here to me is still to make multi-queue out of 1 uffd.
> 
> I _think_ this might also be a positive result to your work, because if the
> bottleneck is not userfaultfd (as we scale it with creating multiple;
> ignoring the split vma effect), then it cannot be resolved by scaling
> userfaultfd alone anyway, anymore.  So a general solution, even if existed,
> may not work here for kvm, because we'll get stuck somewhere else already.
> 
> -- 
> Peter Xu




-- 
Peter Xu

