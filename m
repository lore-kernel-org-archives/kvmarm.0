Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975E021CC1
	for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 21:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683755458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bhfyLDZL2Wy4NLwhyKEfa0N1V5Lq+EA3KLNXjKgrsmI=;
	b=W+j3B8rVNhZVOSGdVTT4eVGOlcOO52pn+oSNO8qpp7FYP+V7NdIrLQHkoxqsIJVpz052Kr
	pIwSB1+rkFpRuJdnPjlDb4BAvx/7dhtSb5bPbTLpRM9Bc4UA+zKld0JJu9suC4zwm+lTZX
	E+FXOqrJiyd5DZQ74J/2ZpqL52Zprm8=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-AF6ImZnoOPuEeCSud_s0Pw-1; Wed, 10 May 2023 17:50:57 -0400
X-MC-Unique: AF6ImZnoOPuEeCSud_s0Pw-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-524f4aec154so757364a12.1
        for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 14:50:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683755451; x=1686347451;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bhfyLDZL2Wy4NLwhyKEfa0N1V5Lq+EA3KLNXjKgrsmI=;
        b=NTw5nUgprS7VDd9m6kXQ9MceRtQwf26M1q/534qVtoI/QirCjq2J3bCdZUYYDW0kwe
         /P5DcMNHV8iKS9Jzg7tQnzyzEGMPKvjGdw6RLk7pgailDqrTlPn5m6F42TA7jy/HlLBW
         7TcoOg+KRC/5Kh3NB0Fn/gEYVvyDkV/Jb40jXyg6Q3cyiw6830Cr9o5T9iSKmt4Un09H
         sQ6T+43c1m96V/G5eXPNX8AqP/9MT5n4Ft8eAPVUzGhHaG0dg8BygENDxlEyaxTDPmxH
         YKvtWxEa3V5ls6LR+v3gmhye98YOBkvCDwPrzKOXl+BPBfQIxxt69D/+ax/p3eHsTXBe
         8ETA==
X-Gm-Message-State: AC+VfDyLYaP/KZT6h4Th/t54Y2/fn/fa6A7hT0AwaqsdGrwhimywtQew
	Jj94aW49hcBWCLBOqze9MBIRL8ojBi0YbasZE1eIMV85QUa9FOgHbfi88rPmZs2uwfc8lWIZkfp
	BobK7nBHwZUdatSx5
X-Received: by 2002:a17:90b:1b0c:b0:250:d8e1:d326 with SMTP id nu12-20020a17090b1b0c00b00250d8e1d326mr2953771pjb.0.1683755451117;
        Wed, 10 May 2023 14:50:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4vELi5N4iVjVE7aGE9xoE0xspdoTHNdsD0TLrBv982RL4blARiCA+cRxw/XcIAKdEaDuo4yw==
X-Received: by 2002:a17:90b:1b0c:b0:250:d8e1:d326 with SMTP id nu12-20020a17090b1b0c00b00250d8e1d326mr2953745pjb.0.1683755450617;
        Wed, 10 May 2023 14:50:50 -0700 (PDT)
Received: from x1n ([2001:4958:15a0:30:ea6e:cae6:2dab:2897])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090a9f0c00b0024e05b7ba8bsm17611209pjp.25.2023.05.10.14.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 14:50:49 -0700 (PDT)
Date: Wed, 10 May 2023 14:50:48 -0700
From: Peter Xu <peterx@redhat.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
	bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
	kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFwRuCuYYMtuUFFA@x1n>
References: <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
 <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
 <ZFQC5TZ9tVSvxFWt@x1n>
 <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n>
 <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi, Anish,

On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> On Sun, May 7, 2023 at 6:23 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > I explained why I think it could be useful to test this in my reply to
> > Nadav, do you think it makes sense to you?
> 
> Ah, I actually missed your reply to Nadav: didn't realize you had sent
> *two* emails.
> 
> > While OTOH if multi-uffd can scale well, then there's a chance of
> > general solution as long as we can remove the single-queue
> > contention over the whole guest mem.
> 
> I don't quite understand your statement here: if we pursue multi-uffd,
> then it seems to me that by definition we've removed the single
> queue(s) for all of guest memory, and thus the associated contention.
> And we'd still have the issue of multiple vCPUs contending for a
> single UFFD.

Yes as I mentioned it's purely what I was curious and it also shows the
best result we can have if we go a more generic solution; it doesn't really
solve the issue immediately.

> 
> But I do share some of your curiosity about multi-uffd performance,
> especially since some of my earlier numbers indicated that multi-uffd
> doesn't scale linearly, even when each vCPU corresponds to a single
> UFFD.
> 
> So, I grabbed some more profiles for 32 and 64 vcpus using the following command
> ./demand_paging_test -b 512M -u MINOR -s shmem -v <n> -r 1 -c <1,...,n>
> 
> The 32-vcpu config achieves a per-vcpu paging rate of 8.8k. That rate
> goes down to 3.9k (!) with 64 vCPUs. I don't immediately see the issue
> from the traces, but safe to say it's definitely not scaling. Since I
> applied your fixes from earlier, the prefaulting isn't being counted
> against the demand paging rate either.
> 
> 32-vcpu profile:
> https://drive.google.com/file/d/19ZZDxZArhSsbW_5u5VcmLT48osHlO9TG/view?usp=drivesdk
> 64-vcpu profile:
> https://drive.google.com/file/d/1dyLOLVHRNdkUoFFr7gxqtoSZGn1_GqmS/view?usp=drivesdk
> 
> Do let me know if you need svg files instead and I'll try and figure that out.

Thanks for trying all these out, and sorry if I caused confusion in my
reply.

What I wanted to do is to understand whether there's still chance to
provide a generic solution.  I don't know why you have had a bunch of pmu
stack showing in the graph, perhaps you forgot to disable some of the perf
events when doing the test?  Let me know if you figure out why it happened
like that (so far I didn't see), but I feel guilty to keep overloading you
with such questions.

The major problem I had with this series is it's definitely not a clean
approach.  Say, even if you'll all rely on userapp you'll still need to
rely on userfaultfd for kernel traps on corner cases or it just won't work.
IIUC that's also the concern from Nadav.

But I also agree it seems to resolve every bottleneck in the kernel no
matter whether it's in scheduler or vcpu loading. After all you throw
everything into userspace.. :)

Considering that most of the changes are for -EFAULT traps and the 2nd part
change is very self contained and maintainable, no objection here to have
it.  I'll leave that to the maintainers to decide.

Thanks,

-- 
Peter Xu

