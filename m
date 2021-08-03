Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19D0C4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:23:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36F6460F58
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:23:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 36F6460F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3B39406AD;
	Tue,  3 Aug 2021 06:23:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zOzzgk08FtVA; Tue,  3 Aug 2021 06:23:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B70407F1;
	Tue,  3 Aug 2021 06:23:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59359406AD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:23:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JeX8DCizX-7w for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 06:23:52 -0400 (EDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A01E40629
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:23:52 -0400 (EDT)
Received: by mail-wr1-f51.google.com with SMTP id h13so11268451wrp.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 03:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4nP9D6D93L6qc5wew7Nn46YCj/dOgm/CGIsmnHV7G9M=;
 b=Ho4RQEFtqmvBySDaWHiw1aTqR3SvwRCIavU7WYhFyFZhuNLD+JoxHFCrzhAGnlwv45
 nGcmz5APzAtb38Smfo7PXQOSiH9KG+hvvvDyezbbCsXufg9MGoEC2R5Hdso09fGEMt6q
 SvkrB1zNZe8acO7dxYIUmRnRXfp6O3KpfKQrqXJdOX8R+4/+K1zFHXDlzjLJ/HOYxZtH
 FYAc+DfRi8FWVr0tTLlKp54se6JvxmOaP/V4ia6YKhaHu5fhhzBDNVmUGB2ktw/ZXwSx
 R1cpS1W9iOhYU6OAgDBOYDoRukjsvsNjbWcfyU9AmBb67uctkwKkttxb7JCAhkUatIxC
 Yv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4nP9D6D93L6qc5wew7Nn46YCj/dOgm/CGIsmnHV7G9M=;
 b=aQZWeH3guN1nlGcop8tOPK7HDTx8RE4ps5SesBjL7DZbZ2ddRbVDSGkdMGOjYd86dv
 uFQxfnd9swbmR1VFjmLB2UsIuFT+NQVkVaqCJSUbtWY6QDtIJZgjzn7zX17ogfgX+Cuc
 po1gs2Ja0qbHG9jOvcDtmt4+D0ejq8nyZzdqC8eQQO8yGj5yPSSn0H4YZoyWifbtOzt4
 jbogX32ad4GsM1fkXh22GrRznLTFaeqQ8BNe4eIx1CohmvsQqNtLEJOCKrQfxO63jpfc
 EDZE/GEpAsUO3OH8gGvNdHx/ZXuRQEDQSZDhQwhj/Z54AcZgKaLCtMiddqjas7LIlibK
 LHpw==
X-Gm-Message-State: AOAM533kONonQ8WwqeOiTL+zvqRbtouchqfhEoUbCMGC88qqaoTF+UeL
 AggR9RJ/JFPLKAI93nrjBjWWug==
X-Google-Smtp-Source: ABdhPJw6dFoHt9c3udAF7oPNiz9FzEP1I0FGJKO5RGfwj7M7cAIND+fyusk+0UJkJ+0JmosBwI1pOw==
X-Received: by 2002:adf:fd90:: with SMTP id d16mr23463332wrr.105.1627986231087; 
 Tue, 03 Aug 2021 03:23:51 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:754:7d1b:7303:129a])
 by smtp.gmail.com with ESMTPSA id n5sm12842687wme.47.2021.08.03.03.23.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 Aug 2021 03:23:50 -0700 (PDT)
Date: Tue, 3 Aug 2021 11:23:47 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 15/21] KVM: arm64: Introduce addr_is_memory()
Message-ID: <YQkZMyyqgqb8+Uqq@google.com>
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-16-qperret@google.com>
 <CA+EHjTxrdA3wVsBe7zwvvGUGgoWuaGwuWCBL0k2+FcAdTGB=Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTxrdA3wVsBe7zwvvGUGgoWuaGwuWCBL0k2+FcAdTGB=Qw@mail.gmail.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Monday 02 Aug 2021 at 16:52:31 (+0200), Fuad Tabba wrote:
> Hi Quentin.
> 
> On Thu, Jul 29, 2021 at 3:28 PM Quentin Perret <qperret@google.com> wrote:
> >
> > Introduce a helper usable in nVHE protected mode to check whether a
> > physical address is in a RAM region or not.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 +
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 7 +++++++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index cc86598654b9..5968fbbb3514 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -51,6 +51,7 @@ extern const u8 pkvm_hyp_id;
> >  int __pkvm_prot_finalize(void);
> >  int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
> >
> > +bool addr_is_memory(phys_addr_t phys);
> 
> I'm just wondering about the naming of the function. I understand what
> you're trying to achieve with it, but an address without a unit that
> conveys size or type seems to be missing something. Would

Well it does have a type no? I was hopping this would make it clear what
it actually does.

> memregion_addr_is_memory or something like that be a better
> description, since it is what find_mem_range finds?

I think the callers shouldn't need to care about the implementation
details though. This just replies to the question 'is this physical
address in RAM range or not?'. And I could actually imagine that we
would change the implementation some day to avoid the binary search, but
the users probably don't need to care.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
