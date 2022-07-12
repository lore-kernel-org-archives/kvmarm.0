Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B2FCCA47F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jul 2022 23:06:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 283E94BF3C;
	Tue, 12 Jul 2022 19:06:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rP3nM0F4ffkG; Tue, 12 Jul 2022 19:06:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07F974BEDD;
	Tue, 12 Jul 2022 19:06:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66A4A4BF0B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 19:05:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5mJUn06Tobzc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 19:05:58 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47C414BE33
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 19:05:58 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id
 o5-20020a17090a3d4500b001ef76490983so723382pjf.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 16:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xf3o/FVcDrWTjqM4SU9OE71B6I+xuW/GFj0iZmpmQbg=;
 b=Z6IZzY9s3jOmwMJHCnOHfcd/X/fC5gga+f0/GnThBBONKEbR0I2NH1Ty6iOIdsZmZK
 aNZ+3HOLhzAiz/Mid2qzpPjGI4JFUuI7nGA4w+vhGU8t1Ok9afcoe/Jc3y3eYW+ViOab
 rveEgyZkqCy1hZZW8DMIBAUqyENo2A5JOeC+C7DZWne1sV1Bng0215Kup44rqee7ljzP
 3+jP61rUQdp8Ls05woP3XU1jDYEQHcMan6eZ/rjuZCWJI/jS6HIryjgTfUh27QyF+0Qr
 HwRYJrJFek+4g2OqMsbQb+YRG+J8VOZMzWxz6CtFgnDzWRb8c+R5L/pvuutOzNOqXTJT
 5rDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xf3o/FVcDrWTjqM4SU9OE71B6I+xuW/GFj0iZmpmQbg=;
 b=75na78z5dxvgDRnwxiPO4lgnHyyEE1JNWri7Q24JHnx6oZDL4sNZoMOOJi04a0ocTU
 h054kC9QdNRd6rqdTYtjMaWXRd69dk4SxYmlqq8jFj4JlgoRkixSvGAwwjzCcyN7tamH
 xR9hHGk5+m9WTcg2DKBfymRsDewebPqWAoIf/Ss8ApBxh3uU7yAjWAa1x/IOFIHOYsTm
 i67pyJEmDRui//zcrmtb1JtNmsnAoJeJpvVRjb6qaXDZ8zHE+4uoWEKIYhUEAwspk7vC
 EfyiLUXt1c8YyRYlTeinzRkJWMSruHoXLWmMWoURy5drAFnG4+7/Zgu8QudF0yiPNcBa
 Bh6g==
X-Gm-Message-State: AJIora80U4cBhsrSCn5fSl6uNnGhl7cJHqEzCO6TCIbmQcnYpgV556ZO
 HlQcLL2nk6NU7+tVYBBoYPSJhA==
X-Google-Smtp-Source: AGRyM1vgSDMytGaDjecq2tqtXq4s3MkrfSl0jPwry11NPVDZdGzL7EkgDGCSpo3Mk+AMiarqH+bA+Q==
X-Received: by 2002:a17:903:2cb:b0:14f:4fb6:2fb0 with SMTP id
 s11-20020a17090302cb00b0014f4fb62fb0mr555392plk.172.1657667157162; 
 Tue, 12 Jul 2022 16:05:57 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 x4-20020a17090ad68400b001f069352d73sm121393pju.25.2022.07.12.16.05.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Jul 2022 16:05:56 -0700 (PDT)
Date: Tue, 12 Jul 2022 23:05:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Ys3+UTTC4Qgbm7pQ@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
 <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> Thanks for taking another look at this!
> 
> On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > index aab70355d64f3..13190d298c986 100644
> > > --- a/include/linux/mmzone.h
> > > +++ b/include/linux/mmzone.h
> > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > >  #endif
> > >       NR_PAGETABLE,           /* used for pagetables */
> > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> >
> > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > and potentially confusing.
> >
> > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > stats the depend on a single feature seems to be the status quo for this code.
> >
> 
> I will #ifdef the stat, but I will emphasize in the docs that is
> currently *only* used for KVM so that it makes sense if users without
> KVM don't see the stat at all. I will also remove the stat from
> show_free_areas() in mm/page_alloc.c as it seems like none of the
> #ifdefed stats show up there.

It's might be worth getting someone from mm/ to weigh in before going through the
trouble, my suggestion/question is based purely on the existing code.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
