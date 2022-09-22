Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DCCC54EE9
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 18:33:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C678D4B0F4;
	Thu, 22 Sep 2022 14:33:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mcVGW+gMiLQx; Thu, 22 Sep 2022 14:33:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71BB549ED7;
	Thu, 22 Sep 2022 14:33:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E1EA413E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 14:33:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PbpOCf9fXRBD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 14:33:37 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C1A440B75
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 14:33:37 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id
 i15-20020a17090a4b8f00b0020073b4ac27so3051539pjh.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 11:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=JHw5orBQa9fjHWtiq5m7r5MDZM4jOrepTGAAQD/BpUI=;
 b=jCvcrIGB9qkCnasJ2L0iYh0pidSSCsNLKD8wCDLDy0S4OnYbRCnE+WqGvQFicSmk3H
 XG3W+6noNZbVNwgwLJ/jzRprNcfo8huoc4EEqDj5pag7AHnR8+klwdZ21DwdlZjLt8zh
 QYX+/kmz2tm28Xgbj2pWFI8wIpk4B7DdrLn7OXBfspA73uQ/L9Btg5SXH4WsI0lRk2kP
 NAhE+SY/9ZTN6cTVTf1PEeWwnqRMIEjDba3mRIgYk9eSp67Vl2dKum/AjOkOy6jQ5Jqi
 vaJ48e+LoyxrhMi72kTnzibFQlagCaDmLR85mXyFDoa25JDQQUBzdvC90adu6kw/QOaw
 +ADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=JHw5orBQa9fjHWtiq5m7r5MDZM4jOrepTGAAQD/BpUI=;
 b=PUuqB6jBUqWwO49RR61omkCkRHlAEuhGlonIFFFD2jC/dOAbKX4W8wwxoKi5lPYoGW
 QqYQYx2Zi9rgqxoY03zxQdvk98CkmiFU1PHBUA0re8eHgA6i7lX4A1C3ebc+s/qqeI4/
 x/VKRnd2ytvju3VhN2LICH3x70L88EkeuXiJ4besxQ5xZl0/QwG1ilzo9HoXEqZXBawW
 wXP0kfbH3nuh0ndCp+CMvtKtRceNq3pZia78J8fW5f8hbSY25dsNqrKsqJxA1+8lexz9
 T+rOCzgBvcCHW5TThRiaBEiaET6mzuBb1to5b27ZtaNbSRV7EmvL24YPrGISDdMTQmBn
 VB7A==
X-Gm-Message-State: ACrzQf2TiwmoTnBnJyqFH7IcKRo321d8abNfJdvc4a4NgbXh89qRB8zL
 sU806Seumz/2heaJEXIK81Ywkg==
X-Google-Smtp-Source: AMsMyM5mStuYZC5EKDjaUUVbyd5f7qTAfMX0b1EB0qsMWoehhrmpSYCKMFqWipvzb/5lmLe2C1KDQA==
X-Received: by 2002:a17:90b:1e47:b0:200:b9b4:ba0f with SMTP id
 pi7-20020a17090b1e4700b00200b9b4ba0fmr16718929pjb.245.1663871616008; 
 Thu, 22 Sep 2022 11:33:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 g13-20020a170902e38d00b00174a4bcefc7sm4356621ple.217.2022.09.22.11.33.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Sep 2022 11:33:35 -0700 (PDT)
Date: Thu, 22 Sep 2022 18:33:32 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v8 07/14] KVM: selftests: Add vm->memslots[] and enum
 kvm_mem_region_type
Message-ID: <YyyqfG8RkS4G8x+p@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220922031857.2588688-8-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 22, 2022, Ricardo Koller wrote:
> The vm_create() helpers are hardcoded to place most page types (code,
> page-tables, stacks, etc) in the same memslot #0, and always backed with
> anonymous 4K.  There are a couple of issues with that.  First, tests
> willing to differ a bit, like placing page-tables in a different backing
> source type must replicate much of what's already done by the vm_create()
> functions.  Second, the hardcoded assumption of memslot #0 holding most
> things is spread everywhere; this makes it very hard to change.
> 
> Fix the above issues by having selftests specify how they want memory to be
> laid out. Start by changing ____vm_create() to not create memslot #0; a
> test (to come) will specify all memslots used by the VM.  Then, add the
> vm->memslots[] array to specify the right memslot for different memory
> allocators, e.g.,: lib/elf should use the vm->[MEM_REGION_CODE] memslot.
> This will be used as a way to specify the page-tables memslots (to be
> backed by huge pages for example).
> 
> There is no functional change intended. The current commit lays out memory
> exactly as before. A future commit will change the allocators to get the
> region they should be using, e.g.,: like the page table allocators using
> the pt memslot.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
