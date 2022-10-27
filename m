Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816F4FA3742
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 19:09:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D82CD40E00;
	Thu, 27 Oct 2022 15:09:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OHGwvyTsd9Rh; Thu, 27 Oct 2022 15:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4E040712;
	Thu, 27 Oct 2022 15:09:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49ADD40712
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 15:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pYbVTfCgzVtf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 15:09:32 -0400 (EDT)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C7DA402C4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 15:09:31 -0400 (EDT)
Received: by mail-pl1-f171.google.com with SMTP id g24so2551686plq.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 12:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=aaYbf6ZRUOtC2fK7Ngw8qa++wcdIIzPtDRWW6k3wZnaPnQF74hSsq1JLmwe0SrG4Lz
 8AstTomQQ8ZBrnFWTfKWqwQLZO/+pwssrX6lALEaJsCm1MY8KaRM1fImYlIQFLfUumEn
 00UxNNzu7i5CQckudscMWMI8qRJioP3c5+SRBZTHy76yOUQSsacHHvZOFDboB+6T3S6/
 uRl7G8Bpd2uIOV23SK0lS4te+KF+7lK2i+GVZlBtGF8hBiwibKd5VVCYL7H15Yx+a/dI
 6qJziDVuc2UTP3WLNCC1rfIU6iuNDCTjNS+5SILIPHEjll8tzn7dq1pAHDAsAZ5D7T+g
 WEFA==
X-Gm-Message-State: ACrzQf0dsmbaZZyuSfUPJ+6XqyevFbgoR72lPlaMHf4Lr2jWs8EAOAB7
 95W08MXhXNqjqadT/9m94nABOQ==
X-Google-Smtp-Source: AMsMyM68Ggi+CLlU0LelIxfDVS4J21qnnT+diZNuQGCktyMfBzQNILLH68pVNB2niDUECUSeKxAxhQ==
X-Received: by 2002:a17:90b:4b09:b0:213:655c:158b with SMTP id
 lx9-20020a17090b4b0900b00213655c158bmr8134972pjb.119.1666897770908; 
 Thu, 27 Oct 2022 12:09:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 p19-20020a170902c71300b00186b758c9fasm1513521plp.33.2022.10.27.12.09.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 27 Oct 2022 12:09:30 -0700 (PDT)
Date: Thu, 27 Oct 2022 19:09:26 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1rXZshBbXGjPpTa@google.com>
References: <8635bhfvnh.wl-maz@kernel.org> <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org> <Y1ckxYst3tc0LCqb@google.com>
 <Y1css8k0gtFkVwFQ@google.com> <878rl4gxzx.wl-maz@kernel.org>
 <Y1ghIKrAsRFwSFsO@google.com> <877d0lhdo9.wl-maz@kernel.org>
 <Y1rDkz6q8+ZgYFWW@google.com> <875yg5glvk.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <875yg5glvk.wl-maz@kernel.org>
Cc: shuah@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 bgardon@google.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
