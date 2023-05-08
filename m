Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C72415A7
	for <kvmarm@lists.linux.dev>; Mon,  8 May 2023 01:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683508986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JWXgJrOi0veApt3CCm2dj5ggLRr24/6U5GIiI/IKSf8=;
	b=jJ4Nc4QEKCCdyYB34h0WBYYei3H4r7+8r/hKn8cUIxo6A5tzpcyqFj427u2Om21lTBHUUc
	O01x+R4i8i+I9N+n3j47U2XLRjcKmZVmZtPf/0cOtViBL88EA1lDC4qB07EarS7SKZSq5/
	rSHydf3vBc7WiwIQKwIC1PB7wG6QIqc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-cZWtHgCTMr--tZ22ZEoMHw-1; Sun, 07 May 2023 21:23:05 -0400
X-MC-Unique: cZWtHgCTMr--tZ22ZEoMHw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1ab1b24c7c9so5250125ad.0
        for <kvmarm@lists.linux.dev>; Sun, 07 May 2023 18:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683508983; x=1686100983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWXgJrOi0veApt3CCm2dj5ggLRr24/6U5GIiI/IKSf8=;
        b=ZYl1f8qAWvMYYcv0/t7UGkPkcNM9Jvp9QdNrh+jkVxInB3OX7sn77qMhwQBJcbGLIW
         KIA+LJFYP0x9uSvvkuYReE7suPbl9NWbduB9g8UliKhU60jifuehdyglsVxiGIWuVdRW
         IspnxB8efqoBK5udxgTWF9xunnCCQXyzEy/vuZGR3/Ksr+j7g73pGWebvMfkuQcs+u0p
         FbC30LXsAdFMTceYgpuEvVW4rkf54CqpZKuz0CChkKUi9w3h7m4MPwKhYU+rqX0HNJVg
         aheJh1AsgiYDDICOdPcZY2K0S6aSGf2q0NhOmn/Q4r8Bk+JoTZoKKgr4JHdPW5o6v67m
         S0KQ==
X-Gm-Message-State: AC+VfDxq66WoC4TN9LzXGr0daK3oQ5AEisRnlzqpaaZT8OQkRGSXAlTi
	9fq+q8rtXa+Lx8qtup65UqEJyBh4sp/Upjt/0SH3R72vLic9tru3Ug6I+mGMLqFDVVaLeWmbJB4
	DFWOa9LE3TBUIwdcW
X-Received: by 2002:a17:903:2284:b0:1a9:4b42:a5a2 with SMTP id b4-20020a170903228400b001a94b42a5a2mr10671613plh.0.1683508983339;
        Sun, 07 May 2023 18:23:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4hHg5Eq2zP00CeLtDM4c3X7G5A0Ae2cCvdNjGap9qMh5qpRSIbSyIM/KwyakcW4TZE8f5Q/A==
X-Received: by 2002:a17:903:2284:b0:1a9:4b42:a5a2 with SMTP id b4-20020a170903228400b001a94b42a5a2mr10671588plh.0.1683508982912;
        Sun, 07 May 2023 18:23:02 -0700 (PDT)
Received: from x1n ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id n19-20020a170902969300b001aae625e422sm5796728plp.37.2023.05.07.18.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 18:23:02 -0700 (PDT)
Date: Sun, 7 May 2023 21:23:01 -0400
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
Message-ID: <ZFhO9dlaFQRwaPFa@x1n>
References: <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
 <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
 <ZFQC5TZ9tVSvxFWt@x1n>
 <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, May 05, 2023 at 11:32:11AM -0700, Anish Moorthy wrote:
> Peter, I'm afraid that isolating cores and splitting them into groups
> is new to me. Do you mind explaining exactly what you did here?

So far I think the most important pinning is the vcpu thread pinning, we
should test always with that in this case to avoid the vcpu load overhead
not scaling with cores/vcpus.

What I did was (1) isolate cores (using isolcpus=xxx), then (2) manually
pinning the userfault threads to some other isolated cores.  But maybe this
is not needed.

> 
> Also, I finally got some of my own perf traces for the self test: [1]
> shows what happens with 32 vCPUs faulting on a single uffd with 32
> reader threads, with the contention clearly being a huge issue, and
> [2] shows the effect of demand paging through memory faults on that
> configuration. Unfortunately the export-to-svg functionality on our
> internal tool seems broken, so I could only grab pngs :(
> 
> [1] https://drive.google.com/file/d/1YWiZTjb2FPmqj0tkbk4cuH0Oq8l65nsU/view?usp=drivesdk
> [2] https://drive.google.com/file/d/1P76_6SSAHpLxNgDAErSwRmXBLkuDeFoA/view?usp=drivesdk

Understood.  What I tested was without -a so it's using >1 uffds.

I explained why I think it could be useful to test this in my reply to
Nadav, do you think it makes sense to you?  e.g. compare (1) 32 vcpus + 32
uffd threads and (2) 64 vcpus + 64 uffd threads, again we need to make sure
vcpu threads are pinned using -c this time.  It'll be nice to pin the uffd
threads too but I'm not sure whether it'll make a huge difference.

Thanks,

-- 
Peter Xu

