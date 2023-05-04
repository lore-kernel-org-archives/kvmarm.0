Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5397E7
	for <kvmarm@lists.linux.dev>; Thu,  4 May 2023 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683227373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eu4smx04I1AOShAcSlKxzRKnKb94GOmquYwLELDKb4c=;
	b=Xf8c2xu0+iCHHm+Ab1ZPz93eNs8VW6OCxBy4+4OBOhupCVhJvxZiAe6qCL4CLIGl0rt+0E
	DM7bUP71BXk9a0m3XAuQZ1PCJInwfbD4SA+OGZmP/5xwORCINig/1K3AcYFHn5xikLb3vD
	v4VrXhTKU5/I0k+wOLi0cFN0FyJx6QU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-NZS8uY16Pn295k9ntLwIAw-1; Thu, 04 May 2023 15:09:33 -0400
X-MC-Unique: NZS8uY16Pn295k9ntLwIAw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3ed767b30easo1342001cf.1
        for <kvmarm@lists.linux.dev>; Thu, 04 May 2023 12:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683227367; x=1685819367;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eu4smx04I1AOShAcSlKxzRKnKb94GOmquYwLELDKb4c=;
        b=VbjJqTUueij+UhG+Egt7Q+X3M2og3V97Gi/m9kqSyp8ym0AHqWYDyxDk8q3+7j1/Po
         ahbHzn7vjeyW9p7mAwrBu7XDoM25jDAf1sXNvJJHBU3+NKUukso7zLBAVJI8tUNIVP7z
         3tK+Fwfr+V6DY6xXarADL/2O6IHYgr+VK+PuZz6nkJGPAvqL0o+1wh5Ev0qMBk4USIQj
         c+A1huRnZ1DQlo+u+zf07SxNPiiYC7UhMS+8wdhnc/kXU3FYM0PDpLicYtcovcgRA6ej
         S1Lc/qoJJNVjadkq4HIMRIzJCqNWUL8l5CXpmj6D2K4sEOxjTAPGHXj7D1zA/y8eFt4K
         ZS+A==
X-Gm-Message-State: AC+VfDypMClYr9p0Px4nHqYH4bXpH/Vl3WVY3Mx3KHQqbbam69QFXsvo
	bfaK7HUuG208z+Gf4r+YPm4BtABIO/FLy/kMMqQaRYQQsGwPY0LOlH1NoChlWKnIL+vpuLEjcP9
	2HChXE+6r2GpgDUGV
X-Received: by 2002:a05:622a:1999:b0:3ef:3204:5148 with SMTP id u25-20020a05622a199900b003ef32045148mr16092998qtc.1.1683227367526;
        Thu, 04 May 2023 12:09:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6QNqm7XccS4dHnALMbPxn5A0zXinogoQpNb6AmeNNL6KcjUqhZFOjqDRxXi8Tuj51+zuEF2Q==
X-Received: by 2002:a05:622a:1999:b0:3ef:3204:5148 with SMTP id u25-20020a05622a199900b003ef32045148mr16092953qtc.1.1683227367219;
        Thu, 04 May 2023 12:09:27 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id i3-20020a37c203000000b0074e0e6aae1csm12050qkm.36.2023.05.04.12.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 12:09:26 -0700 (PDT)
Date: Thu, 4 May 2023 15:09:25 -0400
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, Nadav Amit <nadav.amit@gmail.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
	bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
	kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFQC5TZ9tVSvxFWt@x1n>
References: <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
 <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZFLyGDoXHQrN1CCD@x1n>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, May 03, 2023 at 07:45:28PM -0400, Peter Xu wrote:
> On Wed, May 03, 2023 at 02:42:35PM -0700, Sean Christopherson wrote:
> > On Wed, May 03, 2023, Peter Xu wrote:
> > > Oops, bounced back from the list..
> > > 
> > > Forward with no attachment this time - I assume the information is still
> > > enough in the paragraphs even without the flamegraphs.
> > 
> > The flamegraphs are definitely useful beyond what is captured here.  Not sure
> > how to get them accepted on the list though.
> 
> Trying again with google drive:
> 
> single uffd:
> https://drive.google.com/file/d/1bYVYefIRRkW8oViRbYv_HyX5Zf81p3Jl/view
> 
> 32 uffds:
> https://drive.google.com/file/d/1T19yTEKKhbjU9G2FpANIvArSC61mqqtp/view
> 
> > 
> > > > From what I got there, vmx_vcpu_load() gets more highlights than the
> > > > spinlocks. I think that's the tlb flush broadcast.
> > 
> > No, it's KVM dealing with the vCPU being migrated to a different pCPU.  The
> > smp_call_function_single() that shows up is from loaded_vmcs_clear() and is
> > triggered when KVM needs to VMCLEAR the VMCS on the _previous_ pCPU (yay for the
> > VMCS caches not being coherent).
> > 
> > Task migration can also trigger IBPB (if mitigations are enabled), and also does
> > an "all contexts" INVEPT, i.e. flushes all TLB entries for KVM's MMU.
> > 
> > Can you trying 1:1 pinning of vCPUs to pCPUs?  That _should_ eliminate the
> > vmx_vcpu_load_vmcs() hotspot, and for large VMs is likely represenative of a real
> > world configuration.
> 
> Yes it does went away:
> 
> https://drive.google.com/file/d/1ZFhWnWjoU33Lxy43jTYnKFuluo4zZArm/view
> 
> With pinning vcpu threads only (again, over 40 hard cores/threads):
> 
> ./demand_paging_test -b 512M -u MINOR -s shmem -v 32 -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
> 
> It seems to me for some reason the scheduler ate more than I expected..
> Maybe tomorrow I can try two more things:
> 
>   - Do cpu isolations, and
>   - pin reader threads too (or just leave the readers on housekeeping cores)

I gave it a shot by isolating 32 cores and split into two groups, 16 for
uffd threads and 16 for vcpu threads.  I got similiar results and I don't
see much changed.

I think it's possible it's just reaching the limit of my host since it only
got 40 cores anyway.  Throughput never hits over 350K faults/sec overall.

I assume this might not be the case for Anish if he has a much larger host.
So we can have similar test carried out and see how that goes.  I think the
idea is making sure vcpu load overhead during sched-in is ruled out, then
see whether it can keep scaling with more cores.

-- 
Peter Xu

