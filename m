Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65884680
	for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 21:37:39 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id q1so5386413pgl.11
        for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 14:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZ0cdI79ADlanekkYUSD9fAGVZvM6bIrF+Eq4A7Ygd0=;
        b=koXuqSvky1riggc/IjIcBJ5QKS2r76UwNF0+m1YmtoN6x5TLzY40OyFxikqY09ee+d
         IWauiMTz1Uitfu3NbLRMgzzx2z50RtgVV/3czdNQkQ+VM1MvdWcrkAlrIVbbqRcn0fDb
         PwjvqrFQooRxEcUEpHH+d/XgavD1URG0v7hE3UyLPIjdYo1E+0nBkhHzvNBWTB20/5ws
         D/Z/CbMFtTLggU44MEzsvVbzh9AK7ugtr7wZgHSxwy1WZPmiPJ1lWT5whqPctMZ5nRJ5
         sPO62x9KQr4V/lLMM8AqrcJC2uaMw8dQMgUlwAKzsim2YjmaOC29XqKsNG95dG7+4X7l
         FHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZ0cdI79ADlanekkYUSD9fAGVZvM6bIrF+Eq4A7Ygd0=;
        b=xMbipbRgV/dxXxF/7XIghZ2zoARzm8CwCFmgGcIXNL5SJ1Hx2Bm2syf83VXf+LJCDa
         O76e0tpdQuJqt2/KdJJiEzOxaZGS9GTz9gCRwLwbjMC7VDM+vg6fA+RvoSapHWcWfyEr
         sWH0plcLeuI03OE1WGmPNwgHBm7MXOiO3RxXzBqIoo4aBxNrQvk4JhOBsB1J/tUdeA9c
         Easf50r4u3X8HJ5aOruqB9LyKNfo5BBN7YxmP6Y5HQbEsaVH+JciGgTEX4zJEz93fUZe
         McYcfL3+JPpy3N7/7Nz4MjmCtPCHRreEJxsE5A+cxbLVmJrEfeWHKTbB1p6Xzv0qCnRJ
         mOSw==
X-Gm-Message-State: ACrzQf2/3Ueg0W30VE7+n4AK+706U1gfmIehgn1spSOFDH1GF8CDdQjf
	z7kCv9WtQ6idXl56ZHNfTT7j2g==
X-Google-Smtp-Source: AMsMyM41AXX3Xp6kESIBHSUm21LCu3v/fFVnruKqRqDloxK7fMPiUbElSAmaa5TqV5mp/qM93oOECQ==
X-Received: by 2002:a65:6a12:0:b0:445:84f6:676a with SMTP id m18-20020a656a12000000b0044584f6676amr6173417pgu.40.1665783459080;
        Fri, 14 Oct 2022 14:37:39 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id a6-20020a1709027e4600b0017a0f40fa19sm2122355pln.191.2022.10.14.14.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:37:38 -0700 (PDT)
Date: Fri, 14 Oct 2022 14:37:34 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, dmatlack@google.com,
	axelrasmussen@google.com
Subject: Re: [PATCH v9 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y0nWnr7GaPbBfLtf@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <Y0nU4vIIyjfQuQGV@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0nU4vIIyjfQuQGV@google.com>
Message-ID: <20221014213734.RNT-8LXDefwMRZ_U-K3jq9qqY2wb2CP7v1v1ydLJyhU@z>

On Fri, Oct 14, 2022 at 09:30:10PM +0000, Sean Christopherson wrote:
> On Tue, Oct 11, 2022, Ricardo Koller wrote:
> > Ricardo Koller (14):
> >   KVM: selftests: Add a userfaultfd library
> >   KVM: selftests: aarch64: Add virt_get_pte_hva() library function
> >   KVM: selftests: Add missing close and munmap in
> >     __vm_mem_region_delete()
> >   KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
> >     macros
> >   tools: Copy bitfield.h from the kernel sources
> >   KVM: selftests: Stash backing_src_type in struct userspace_mem_region
> >   KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
> >   KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and
> >     vm_vaddr_alloc()
> >   KVM: selftests: Use the right memslot for code, page-tables, and data
> >     allocations
> >   KVM: selftests: aarch64: Add aarch64/page_fault_test
> >   KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
> >   KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
> >   KVM: selftests: aarch64: Add readonly memslot tests into
> >     page_fault_test
> >   KVM: selftests: aarch64: Add mix of tests into page_fault_test
> 
> A bunch of nits, mostly about alignment/indentation, but otherwise no more whining
> on my end.  A v10 would probably be nice to avoid churn?  But I'm also ok if y'all
> want to merge this asap and do the cleanup on top.

No prob, will send a v10 (most likely on Monday).

Thanks!
Ricardo
