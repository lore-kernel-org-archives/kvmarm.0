Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9677F1C13
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 19:09:31 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id y4so2563543plb.2
        for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 12:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jcsG6Lpz86NDdXCXxaPnNHQBPM6Izrd1LxxhOme0rdg=;
        b=RpAv17GfbyizrETcKPzbPLSPEuqfINiMIe/xj9cCq6vRXjwf0nYzMNPSc4bqvkVBJl
         XwWqeSP4stXmFHJL94dcnmsw1gTk+oAOJOKMt0woiDHXSyFK0EgjgV+l9Pvqzk0GPCB5
         VDTb3IDOKZ8Oo9u6D7BnXim5Mww2EPS6WNa76ndfvQC6CFPkO+zJBs+sXw+DsNTQrj6c
         rFLckgEV1rDUzkEJ7bPe7Cfxk+1m6UddG9A1tv0OPSnZ8qleLTbJlVdm1YTYqvi8krNF
         3VxUfwWHAA1A0/HT3mnDZReVLS7FacP/aS8dULbCZfp0v1MMHM6T4v9lYUgbshzj/CL2
         hz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcsG6Lpz86NDdXCXxaPnNHQBPM6Izrd1LxxhOme0rdg=;
        b=tBkI5cx5bvCgXee73mW9Xd1PXY24UNk1OBV+E8Xd5DeGmXkddIESFAPAK1WuFV1IaL
         wz7lyeKH4wCOaQsyOk9FGf1jH3g0C5uLCC+zoBQ1T0uoDyyU0ovLt2nmC18Z0XKPEgb+
         W/50F+ZuxNMvTz1VkFeBTUC4TPDQgd+orEbt/EPHT1CGq1009M91DFr3MXE7K+gMjKzk
         K/FdoGlRaN9qlhJUWTuGIP4xYNjh21uhn6qWuMWsKmUZ6PdDf8WRtg9P+GKdRhgwlE7J
         7S08UbnMzbdYQQgsj1klXHBTvAy9Q2Sn598qXqh1TSnvq4FhNp4w1TpQDrKPIhU7xkBU
         +6YA==
X-Gm-Message-State: ACrzQf3G2Pc2pCntF6yJxEaTPsN4qIKexn0btlCJe6uBZsZieqagkG6H
	wxoFVjpFkwVtj/no1Qp/aESs2w==
X-Google-Smtp-Source: AMsMyM68Ggi+CLlU0LelIxfDVS4J21qnnT+diZNuQGCktyMfBzQNILLH68pVNB2niDUECUSeKxAxhQ==
X-Received: by 2002:a17:90b:4b09:b0:213:655c:158b with SMTP id lx9-20020a17090b4b0900b00213655c158bmr8134972pjb.119.1666897770908;
        Thu, 27 Oct 2022 12:09:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p19-20020a170902c71300b00186b758c9fasm1513521plp.33.2022.10.27.12.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 12:09:30 -0700 (PDT)
Date: Thu, 27 Oct 2022 19:09:26 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Gavin Shan <gshan@redhat.com>,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, peterx@redhat.com, will@kernel.org,
	catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
	andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
	zhenyzha@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1rXZshBbXGjPpTa@google.com>
References: <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
 <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org>
 <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org>
 <Y1rDkz6q8+ZgYFWW@google.com>
 <875yg5glvk.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yg5glvk.wl-maz@kernel.org>
Message-ID: <20221027190926.nZOm3C6GIX_Gk5LsfZk58iPM5FxZl-EBVaM3llYMq3U@z>

On Thu, Oct 27, 2022, Marc Zyngier wrote:
> On Thu, 27 Oct 2022 18:44:51 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Thu, Oct 27, 2022, Marc Zyngier wrote:
> > > But in the long run, with dirty bits being collected from the IOMMU
> > > page tables or directly from devices, we will need a way to reconcile
> > > the dirty tracking. The above doesn't quite cut it, unfortunately.
> > 
> > Oooh, are you referring to IOMMU page tables and devices _in the
> > guest_?  E.g. if KVM itself were to emulate a vIOMMU, then KVM would
> > be responsible for updating dirty bits in the vIOMMU page tables.
> 
> No. I'm talking about the *physical* IOMMU, which is (with the correct
> architecture revision and feature set) capable of providing its own
> set of dirty bits, on a per-device, per-PTE basis. Once we enable
> that, we'll need to be able to sink these bits into the bitmap and
> provide a unified view of the dirty state to userspace.

Isn't that already handled by VFIO, e.g. via VFIO_IOMMU_DIRTY_PAGES?  There may
be "duplicate" information if a page is dirty in both the IOMMU page tables and
the CPU page tables, but that's ok in that the worst case scenario is that the
VMM performs a redundant unnecessary transfer.

A unified dirty bitmap would potentially reduce the memory footprint needed for
dirty logging, but presumably IOMMU-mapped memory is a small subset of CPU-mapped
memory in most use cases.
