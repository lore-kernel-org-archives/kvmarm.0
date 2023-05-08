Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB6815A7
	for <kvmarm@lists.linux.dev>; Mon,  8 May 2023 01:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683508341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=crOvUhwjWMe5ldALZcK+bWVRsIvTigamFdYJnvRCc+k=;
	b=aRk/WZUiE5H4wcfwsnFjLEJcZXCejW2pW+fyf1Yhb2NYukb2H5bWtNkghZ0DYHwDNXAL8g
	/mEqnGHXWXgVsQZ6KhHdXq+IZNzNtuTp7kEZsUDL54p5oy7IM97LfA6m3sj0gz2sPEVNke
	Yyw1+QMGxmn3waHnIkQQR0oZP4vziDY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-Fx4Sl4DZMwWAIRYj_6cjDQ-1; Sun, 07 May 2023 21:12:20 -0400
X-MC-Unique: Fx4Sl4DZMwWAIRYj_6cjDQ-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-517f0c08dfaso383711a12.0
        for <kvmarm@lists.linux.dev>; Sun, 07 May 2023 18:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683508339; x=1686100339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crOvUhwjWMe5ldALZcK+bWVRsIvTigamFdYJnvRCc+k=;
        b=fP0VK2CO9dLy35YBHd4f8R98zvtzI2LOZSAFCzoAZmTHNKvVM6TTYtKd3j9THE29bV
         fO25H+TzcmTPDIF2RUfynxuUNh77GOgYBRCJ+9L51gOnwC1/QGzIoG2GFrefd0ArKxSY
         UzPZhrhr+9dnsPZq6pUdK1tF9GDg4nOeTsIIsej+NnJu7jsIW6egZ2x3l4wmU5RNsLSX
         Xv/KA3x35AiZpSoDU5XxkRKGzmkk/MvmXZ26ABcbLpBRKQjNoeIRqmS/AVpeK9fo0Vjf
         TC9+MtfJrktZgL7ba8Pz3b+/9rYGzUVt0q3Q2Nhj7PU1H7PVtj2jrv/0Zrg4aybyGtgO
         4U+Q==
X-Gm-Message-State: AC+VfDyBDxm7QbcpvuciIEhXYn82YNlol7oedsc5C+cs9IEGUl1cVG7u
	YoZ4xEXyXJzTmXwYOcq8/I0G27bj5LC+iOxJvKIVJNDKhO+FnNtDPF9E6g2r1iIvP2CLX1SinWe
	miUdg+mo78DVRWhT2
X-Received: by 2002:a17:902:f547:b0:1a6:cf4b:4d7d with SMTP id h7-20020a170902f54700b001a6cf4b4d7dmr10938691plf.2.1683508339142;
        Sun, 07 May 2023 18:12:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4OMuP9/L3QvkgPezFjxbEVSdfVj4hTA3JWpTR4p0g9C8dPFEy31LGZPHS04LcqDo5xOhUGsA==
X-Received: by 2002:a17:902:f547:b0:1a6:cf4b:4d7d with SMTP id h7-20020a170902f54700b001a6cf4b4d7dmr10938674plf.2.1683508338774;
        Sun, 07 May 2023 18:12:18 -0700 (PDT)
Received: from x1n ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902904400b001aaed82b824sm5740946plz.144.2023.05.07.18.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 18:12:18 -0700 (PDT)
Date: Sun, 7 May 2023 21:12:17 -0400
From: Peter Xu <peterx@redhat.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Anish Moorthy <amoorthy@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
	bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
	kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFhMcS/bLnpW/R4+@x1n>
References: <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
 <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
 <8ED96522-B4A5-4106-B30B-8BE635B5DA7A@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8ED96522-B4A5-4106-B30B-8BE635B5DA7A@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi, Nadav,

On Fri, May 05, 2023 at 01:05:02PM -0700, Nadav Amit wrote:
> > ./demand_paging_test -b 512M -u MINOR -s shmem -v 32 -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
> > 
> > It seems to me for some reason the scheduler ate more than I expected..
> > Maybe tomorrow I can try two more things:
> > 
> >  - Do cpu isolations, and
> >  - pin reader threads too (or just leave the readers on housekeeping cores)
> 
> For the record (and I hope I do not repeat myself): these scheduler overheads
> is something that I have encountered before.
> 
> The two main solutions I tried were:
> 
> 1. Optional polling on the faulting thread to avoid context switch on the
>    faulting thread.
> 
> (something like https://lore.kernel.org/linux-mm/20201129004548.1619714-6-namit@vmware.com/ )
> 
> and 
> 
> 2. IO-uring to avoid context switch on the handler thread.
> 
> In addition, as I mentioned before, the queue locks is something that can be
> simplified.

Right, thanks for double checking on that.  Though do you think these are
two separate issues to be looked into?

One thing on reducing context switch overhead with a static configuration,
which I think is what can be resolved by what you mentioned above, and the
iouring series.

One thing on the possibility of scaling userfaultfd over splitting guest
memory into a few chunks (literally demand paging test with no -a).
Logically I think it should scale if with pcpu pinning on vcpu threads to
avoid kvm bottlenecks around.

Side note: IIUC none of above will resolve the problem right now if we
assume we can only have 1 uffd to register to the guest mem.

However I'm curious on testing multi-uffd because I wanted to make sure
there's no other thing stops the whole system from scaling with threads,
hence I'd expect to get higher fault/sec overall if we increase the cores
we use in the test.

If it already cannot scale for whatever reason then it means a generic
solution may not be possible at least for kvm use case.  While OTOH if
multi-uffd can scale well, then there's a chance of general solution as
long as we can remove the single-queue contention over the whole guest mem.

PS: Nadav, I think you mentioned twice on avoiding taking two locks for the
fault queue, which sounds reasonable.  Do you have plan to post a patch?

Thanks,

-- 
Peter Xu

