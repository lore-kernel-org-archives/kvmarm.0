Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9777C00140
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 15:17:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CEB74DCD1;
	Mon, 15 Aug 2022 11:17:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@cmpxchg-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HdJt4u+a6uci; Mon, 15 Aug 2022 11:17:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9CC24DD00;
	Mon, 15 Aug 2022 11:17:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98C3A4C9CF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 11:13:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XbW4lXhadfga for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 11:13:54 -0400 (EDT)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
 [209.85.219.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 106424C8B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 11:13:54 -0400 (EDT)
Received: by mail-qv1-f41.google.com with SMTP id d1so5567521qvs.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 08:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=SVpUVzPm5W0Voyj60yN9H262DjM/0dmmT6CafgD5LQQ=;
 b=gOOWpTPZwiM17WF4f5gKOhDCSLU9Xa7Ddw5htxLmCf1V9e6337lrTGD7E89v0QfRVJ
 UKtYdBjRPV+SoEPNaViOMhRD3539K1N9epXUdaYog0Ghqr9Hz/q4svAJMLG3UwT6sWxo
 +VuEzH2WqgtjnVrw0RSEk1ZZzuVg1Iu9u/y7a/XQdVWZSk6nHZ6e0lHT1onclU+0r7hJ
 Q5W7083KTKmB0O6AdzaftKfJMa8rGq92lENKSy6Nq4zRtkJGrMxpmyvJ4DecH3ziV2yY
 aiceCwnsy9e7wohTT0MQGWEDNlpX9jUl/3N9hIGAEaDitMSoD3owjEMqWgSnWOXKWzKG
 oZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=SVpUVzPm5W0Voyj60yN9H262DjM/0dmmT6CafgD5LQQ=;
 b=uxEc3QIbQGdcBfFSmkhKrlpx+vArI/JOANT4JvPGAzeTmg4CirOlKmKefFW5uul4gu
 ssFnkm82s/l16OQfbly954XNXXtPwW6EZfs1YrogyeaGKx7QGIgj0xatMage7xHeLZrp
 r+wJkBaPS2//fMvW1jagO6oADXzuvBFXN2fGDBPiGQz3GGYltLjpKYhkUhcu8qPekido
 HU7/7Jppo5cNQ1ohq4Q+87CXy8jLNLx+GEOMO7AHe82Zk3HcC6w5KV8sw2tO/bP+OlbM
 6rVlo7IFcIhSzO0nXEPx7RffgUMs5AYWNKMqFS6vyAOtLTIF94BXdyFLpiAK8eky2W+o
 OD2g==
X-Gm-Message-State: ACgBeo3xBvlM8tR8wNgC9YvTlJGsDdolbin+pPagSc6ePCcRhOVhmwOk
 Hz0zZwpXz5ynJH8aZoNxU+U8YQ==
X-Google-Smtp-Source: AA6agR5vrCQlXB1uSwNPvBPyKCFf9sAWMWRn04guCYRZ/JGYECdgQAzs4QjOMDL0tMgKmgpjwr5NJQ==
X-Received: by 2002:a0c:b2c5:0:b0:47e:4f8e:f0ae with SMTP id
 d5-20020a0cb2c5000000b0047e4f8ef0aemr13992515qvf.9.1660576433584; 
 Mon, 15 Aug 2022 08:13:53 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::a23e])
 by smtp.gmail.com with ESMTPSA id
 r5-20020ac87945000000b0031f0485aee0sm2014653qtt.88.2022.08.15.08.13.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 15 Aug 2022 08:13:52 -0700 (PDT)
Date: Mon, 15 Aug 2022 11:13:51 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Yvpir0nWuTsXz322@cmpxchg.org>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
 <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
 <Ys3+UTTC4Qgbm7pQ@google.com>
 <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
 <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
X-Mailman-Approved-At: Mon, 15 Aug 2022 11:16:59 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Aug 08, 2022 at 01:06:15PM -0700, Yosry Ahmed wrote:
> On Mon, Jul 18, 2022 at 11:26 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > > > Thanks for taking another look at this!
> > > >
> > > > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > > index aab70355d64f3..13190d298c986 100644
> > > > > > --- a/include/linux/mmzone.h
> > > > > > +++ b/include/linux/mmzone.h
> > > > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > > > >  #endif
> > > > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > > > >
> > > > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > > > and potentially confusing.
> > > > >
> > > > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > > > stats the depend on a single feature seems to be the status quo for this code.
> > > > >
> > > >
> > > > I will #ifdef the stat, but I will emphasize in the docs that is
> > > > currently *only* used for KVM so that it makes sense if users without
> > > > KVM don't see the stat at all. I will also remove the stat from
> > > > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > > > #ifdefed stats show up there.
> > >
> > > It's might be worth getting someone from mm/ to weigh in before going through the
> > > trouble, my suggestion/question is based purely on the existing code.
> >
> > Any mm folks with an opinion about this?
> >
> > Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
> > with #ifdef CONFIG_KVM for now as it is currently the only source for
> > this stat?
> 
> Any input here?
> 
> Johannes, you have been involved in discussions in earlier versions of
> this series, any thoughts here?

No super strong feelings here. Most major distros have CONFIG_KVM=y/n,
so it'll be a common fixture anyway, and the ifdef is proooobably not
worth it for hiding it from people. OTOH, the ifdef is useful for
documenting the code.

If you've already ifdeffed it now, I'd say go ahead with
it. Otherwise, don't :) My 2c.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
