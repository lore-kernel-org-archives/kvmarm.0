Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CCC8821
	for <kvmarm@lists.linux.dev>; Thu, 27 Apr 2023 20:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682627209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXYRHEqpsXervQOffemoFcDYMS9fKv62JnpEB8Yl5zQ=;
	b=huWXa5AYvJ5BTLlSt7OrVLNtBrVPcF9AfFopTNgB4ZAR45Xac6qAPzMhCJHx/AicZvnlDf
	+tDJtBbWQN8aVWa13je8f/kfLF5grtPcd9ZfJOoD0RSyd8/Kp7YXmY5K5UznYHFphZcVCc
	9UjVpQWe6b0EK2RkUSKOXWfa10bdWgA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-MzPp8QoJOj6PaPtkMl1b1A-1; Thu, 27 Apr 2023 16:26:47 -0400
X-MC-Unique: MzPp8QoJOj6PaPtkMl1b1A-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-74deffa28efso73153585a.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Apr 2023 13:26:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682627207; x=1685219207;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sXYRHEqpsXervQOffemoFcDYMS9fKv62JnpEB8Yl5zQ=;
        b=I8mo7MckjmFvEGp2c/assb2ALQDCMYAM6i30c5dFfhgw1CY9LI6Sburhg34TkGPQjB
         aqrl4GAEeweuSF+n3lP358Eq3991cySeHX+ebpcSuAw21IhOoQJcGLJMth/bWtUg7bFS
         meilBSUdkdbhmr7K374dH0kb4paoSdWN2mKpBaL3h75kJfUHo/j7b8DrHfmGwDwmGt3e
         SKCtOK9JNoGmN37Al4T5H9GYBjSkPv0J3jNtdhm85S4RUGkydq6GM8I3k9IdRS/CBdr5
         7z6oLsqPwNiI7In2WL9sH1ynskeh1LdRl9Qb6/BnuEi0KsZe1p70fPKfz1B1wd7pTbHg
         FmqA==
X-Gm-Message-State: AC+VfDxhgrL6deg6OrIum49SW8uI8mC7hIHKyQzFdzfYHyBKVNQpS076
	MebeSPcTY1FW8EMTtuoUysm/7SExb1Hweb8hUXK/dDEYs/enx01vwzixwc/NQcFY5p/7AGnML7E
	UdEap1pCmDcsIuIrO
X-Received: by 2002:ac8:574c:0:b0:3f1:fdc3:1c34 with SMTP id 12-20020ac8574c000000b003f1fdc31c34mr3980310qtx.5.1682627207004;
        Thu, 27 Apr 2023 13:26:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ71aAD+A9H07MKf/xnE7ljf+f7zYn5h9Th4ZXffSsHzzF+MxPtCESt/xfcjgxPd2cLPDDS/aA==
X-Received: by 2002:ac8:574c:0:b0:3f1:fdc3:1c34 with SMTP id 12-20020ac8574c000000b003f1fdc31c34mr3980277qtx.5.1682627206757;
        Thu, 27 Apr 2023 13:26:46 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id l11-20020a05620a210b00b0074df8eefe2dsm6175293qkl.98.2023.04.27.13.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 13:26:45 -0700 (PDT)
Date: Thu, 27 Apr 2023 16:26:44 -0400
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
Message-ID: <ZErahL/7DKimG+46@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n>
 <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi, Anish,

On Mon, Apr 24, 2023 at 05:15:49PM -0700, Anish Moorthy wrote:
> On Mon, Apr 24, 2023 at 12:44 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> >
> >
> >
> > > On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> wrote:
> > >
> > > On Fri, Apr 21, 2023 at 10:40 AM Nadav Amit <nadav.amit@gmail.com> wrote:
> > >>
> > >> If I understand the problem correctly, it sounds as if the proper solution
> > >> should be some kind of a range-locks. If it is too heavy or the interface can
> > >> be changed/extended to wake a single address (instead of a range),
> > >> simpler hashed-locks can be used.
> > >
> > > Some sort of range-based locking system does seem relevant, although I
> > > don't see how that would necessarily speed up the delivery of faults
> > > to UFFD readers: I'll have to think about it more.
> >
> > Perhaps I misread your issue. Based on the scalability issues you raised,
> > I assumed that the problem you encountered is related to lock contention.
> > I do not know whether your profiled it, but some information would be
> > useful.
> 
> No, you had it right: the issue at hand is contention on the uffd wait
> queues. I'm just not sure what the range-based locking would really be
> doing. Events would still have to be delivered to userspace in an
> ordered manner, so it seems to me that each uffd would still need to
> maintain a queue (and the associated contention).
> 
> With respect to the "sharding" idea, I collected some more runs of the
> self test (full command in [1]). This time I omitted the "-a" flag, so
> that every vCPU accesses a different range of guest memory with its
> own UFFD, and set the number of reader threads per UFFD to 1.
> 
> vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new caps)
> 1      180     307
> 2       85      220
> 4       80      206
> 8       39     163
> 16     18     104
> 32      8      73
> 64      4      57
> 128    1      37
> 256    1      16
> 
> I'm reporting paging rate on a per-vcpu rather than total basis, which
> is why the numbers look so different than the ones in the cover
> letter. I'm actually not sure why the demand paging rate falls off
> with the number of vCPUs (maybe a prioritization issue on my side?),
> but even when UFFDs aren't being contended for it's clear that demand
> paging via memory fault exits is significantly faster.
> 
> I'll try to get some perf traces as well: that will take a little bit
> of time though, as to do it for cycler will involve patching our VMM
> first.
> 
> [1] ./demand_paging_test -b 64M -u MINOR -s shmem -v <n> -r 1 [-w]

Thanks (for doing this test, and also to Nadav for all his inputs), and
sorry for a late response.

These numbers caught my eye, and I'm very curious why even 2 vcpus can
scale that bad.

I gave it a shot on a test machine and I got something slightly different:

  Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz (20 cores, 40 threads)
  $ ./demand_paging_test -b 512M -u MINOR -s shmem -v N
  |-------+----------+--------|
  | n_thr | per-vcpu | total  |
  |-------+----------+--------|
  |     1 | 39.5K    | 39.5K  |
  |     2 | 33.8K    | 67.6K  |
  |     4 | 31.8K    | 127.2K |
  |     8 | 30.8K    | 246.1K |
  |    16 | 21.9K    | 351.0K |
  |-------+----------+--------|

I used larger ram due to less cores.  I didn't try 32+ vcpus to make sure I
don't have two threads content on a core/thread already since I only got 40
hardware threads there, but still we can compare with your lower half.

When I was testing I noticed bad numbers and another bug on not using
NSEC_PER_SEC properly, so I did this before the test:

https://lore.kernel.org/all/20230427201112.2164776-1-peterx@redhat.com/

I think it means it still doesn't scale that good, however not so bad
either - no obvious 1/2 drop on using 2vcpus.  There're still a bunch of
paths triggered in the test so I also don't expect it to fully scale
linearly.  From my numbers I just didn't see as drastic as yours. I'm not
sure whether it's simply broken test number, parameter differences
(e.g. you used 64M only per-vcpu), or hardware differences.

-- 
Peter Xu

