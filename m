Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2E7C977
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 19:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681934165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3ee2UOmXmTnns8+N/DwF+uPlnF+rDLjncVrgdCTyGQ=;
	b=gVV83Xxg50S/sgFdlYHRklJgyE+ixl6vv/Yga3GCFTq1D0VwZ7gjUepzhOb9ng+r2uUDM2
	+2GjzKuITuAa/aZYGDacHLrtNLFmdWAuf4DTGsBKP9QuAEGq7OmH7P/Fvxd1gt27SFdHi3
	FR29iRu90OjgcRiW0O/BTPEshu7dtas=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-7QHL3m6IMLqirgmfr0jZoA-1; Wed, 19 Apr 2023 15:56:02 -0400
X-MC-Unique: 7QHL3m6IMLqirgmfr0jZoA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-74deffa28efso4318485a.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681934162; x=1684526162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o3ee2UOmXmTnns8+N/DwF+uPlnF+rDLjncVrgdCTyGQ=;
        b=YIvOWWIbAs5dxYQtsbuqt0BzLfHpr8xe+XecsuvWxKuzD86t3UnP+I/4LDMbmmhUIs
         pfwBS01vh6V2CDUdqILr7ibkMLIOvxs7Hn/0D3zFbxfz6ju79Kou5l1Mg47YS39rZAps
         2/jha/UA5ADx60c6rEeS8pLjX4Cm4V37y2Vo57IHhyBehzkDEqjlWgoMxqTKpW6jIFCe
         rUDndlWICcN7//B6GDGQqLn+fv6h8IH/GeE0IP3URH2I+NFHrm2RUfZO6fSBeTPSsA/L
         zARxw8kMufa5/3VDS8vmFHV0jjVqd5bUGMErCWp2dVUihJLR2zEoXEobSeQQxvhPy6ae
         rSmQ==
X-Gm-Message-State: AAQBX9f9Tz8mLmig2gHopYw3tNsgcwFvBDVu1p6JYFhobPOxYCXf0K+F
	oiRk0cnr0XOVcniNWZbMkc3IUitNAmyd9jPjiJagghba9M62jjWplb1q+JrFtuG8jI/02T3cjfZ
	ID8H2Ni5XyqmdpnpE
X-Received: by 2002:a05:622a:1a9b:b0:3ea:ef5:5b8c with SMTP id s27-20020a05622a1a9b00b003ea0ef55b8cmr31879226qtc.3.1681934161883;
        Wed, 19 Apr 2023 12:56:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350bm8Jhe6jHZDmUB9HAUPG210Lksz3mgG4SE50D2FR1z8lHa8fCITv7WyHX4P5OzneuRCtvbjQ==
X-Received: by 2002:a05:622a:1a9b:b0:3ea:ef5:5b8c with SMTP id s27-20020a05622a1a9b00b003ea0ef55b8cmr31879193qtc.3.1681934161528;
        Wed, 19 Apr 2023 12:56:01 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id e7-20020ac84e47000000b003e3860f12f7sm822636qtw.56.2023.04.19.12.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 12:56:00 -0700 (PDT)
Date: Wed, 19 Apr 2023 15:55:59 -0400
From: Peter Xu <peterx@redhat.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
	seanjc@google.com, jthoughton@google.com, bgardon@google.com,
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZEBHTw3+DcAnPc37@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi, Anish,

On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> KVM's demand paging self test is extended to demonstrate the performance
> benefits of using the two new capabilities to bypass the userfaultfd
> wait queue. The performance samples below (rates in thousands of
> pages/s, n = 5), were generated using [2] on an x86 machine with 256
> cores.
> 
> vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new caps)
> 1       150     340
> 2       191     477
> 4       210     809
> 8       155     1239
> 16      130     1595
> 32      108     2299
> 64      86      3482
> 128     62      4134
> 256     36      4012

The number looks very promising.  Though..

> 
> [1] https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
> [2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
>     A quick rundown of the new flags (also detailed in later commits)
>         -a registers all of guest memory to a single uffd.

... this is the worst case scenario.  I'd say it's slightly unfair to
compare by first introducing a bottleneck then compare with it. :)

Jokes aside: I'd think it'll make more sense if such a performance solution
will be measured on real systems showing real benefits, because so far it's
still not convincing enough if it's only with the test especially with only
one uffd.

I don't remember whether I used to discuss this with James before, but..

I know that having multiple uffds in productions also means scattered guest
memory and scattered VMAs all over the place.  However split the guest
large mem into at least a few (or even tens of) VMAs may still be something
worth trying?  Do you think that'll already solve some of the contentions
on userfaultfd, either on the queue or else?

With a bunch of VMAs and userfaultfds (paired with uffd fault handler
threads, totally separate uffd queues), I'd expect to some extend other
things can pop up already, e.g., the network bandwidth, without teaching
each vcpu thread to report uffd faults themselves.

These are my pure imaginations though, I think that's also why it'll be
great if such a solution can be tested more or less on a real migration
scenario to show its real benefits.

Thanks,

-- 
Peter Xu

