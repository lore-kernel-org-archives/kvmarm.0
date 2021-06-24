Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E092C49EA7
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:03:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 142866140A
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 142866140A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3DC04B1D4;
	Thu, 24 Jun 2021 10:03:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8hH9mEt6xKYJ; Thu, 24 Jun 2021 10:03:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 403A14B154;
	Thu, 24 Jun 2021 10:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3EEA4B26E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:17:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FdxqEcpWByKH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 06:17:49 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F02C4B26D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:17:49 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id
 bb10-20020a17090b008ab029016eef083425so5582874pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 03:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=ufPcep0sp8fFam4s8EQWkn+673yXecgGkFHNTHQONWw=;
 b=sFF5ZYvJivSW9geCDpAWHQIXJqy0TaWKJDeCWyf+SN8sC0zvAWOqxE0kDzVGrlqH0T
 tmnXDqy/vMEUI/QT1fg3tuAhH6y/WaFDv0bhKrmNY65hIUEPGulyXJKnytExJVEwigXZ
 EEgjb92CecGE/1ZNSefvvxGTeh5Bu3j4pd19HStH0J6gJv+4gmTPMVXvpU/FEf57f6Z1
 yZZLHMoK9YK0EH+XiEgmNblrEYdl95qc0I5aDyKhqYAvytW6+/07zmQXw9lEc1D57uv2
 sPH/vR/v0oM7LuQHI7hajV/RDoziumHUY8ZgFdgAAJLR7DiFovRTgo8M2LsLunQ7LnIe
 UNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=ufPcep0sp8fFam4s8EQWkn+673yXecgGkFHNTHQONWw=;
 b=fildmnEdS+NTjspY11XTgi+gVlpnZ9fDE93U21hCCCiviGoKOBQP1tCtlcDmY+cz6l
 amQ5Atsbn/iAH9t5E5Ss6Tn/8JjM/sara0HLl73YeB9eMj6bjonyTwWykrTPZ/OHBVlB
 YNlsWcL4ajYp9OA7r+YmFFe22APzC9EsmaFKDUnoeqP3ohmAaawiQ0m8NYt7UNJsvtr8
 29tmjQmvRkXrHtoD/yAofBhJPumKOTky5AdRmJmwzBW9d8ms7dsptfy7SBFiC2/1H6Sj
 v/bcuFP5bzVtfWwMTexvYM9pL9EQ8E/46+xwc+V2hk01a1ur+yZSD452Y8aJUx5eIS1b
 2iaw==
X-Gm-Message-State: AOAM531W9/ejJubYNM1JTGOv5W9quEr6NLG2ND9AYLTQsuhxY9sd7p9B
 jZnHTHq3/UYn0Cfx9sMKI6c=
X-Google-Smtp-Source: ABdhPJzBDdHKwzOfU1IGTH+/PPCRK2jVsTxYoY95EuRzqDADJIdiFOBloV8Ki52/MFkR99nX/DL1Xg==
X-Received: by 2002:a17:90a:7401:: with SMTP id
 a1mr14554343pjg.57.1624529868549; 
 Thu, 24 Jun 2021 03:17:48 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id o20sm2094410pjq.57.2021.06.24.03.17.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 03:17:48 -0700 (PDT)
Date: Thu, 24 Jun 2021 20:17:42 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/6] KVM: mmu: also return page from gfn_to_pfn
To: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Huacai Chen
 <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>, Paul Mackerras
 <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>, David Stevens
 <stevensd@chromium.org>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang
 <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-3-stevensd@google.com>
 <1624524331.zsin3qejl9.astroid@bobo.none>
 <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
 <1624528342.s2ezcyp90x.astroid@bobo.none>
In-Reply-To: <1624528342.s2ezcyp90x.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1624529635.75a1ann91v.astroid@bobo.none>
X-Mailman-Approved-At: Thu, 24 Jun 2021 10:03:53 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 kvm-ppc@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mips@vger.kernel.org,
 intel-gvt-dev@lists.freedesktop.org, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Excerpts from Nicholas Piggin's message of June 24, 2021 7:57 pm:
> Excerpts from Paolo Bonzini's message of June 24, 2021 7:42 pm:
>> On 24/06/21 10:52, Nicholas Piggin wrote:
>>>> For now, wrap all calls to gfn_to_pfn functions in the new helper
>>>> function. Callers which don't need the page struct will be updated in
>>>> follow-up patches.
>>> Hmm. You mean callers that do need the page will be updated? Normally
>>> if there will be leftover users that don't need the struct page then
>>> you would go the other way and keep the old call the same, and add a new
>>> one (gfn_to_pfn_page) just for those that need it.
>> 
>> Needing kvm_pfn_page_unwrap is a sign that something might be buggy, so 
>> it's a good idea to move the short name to the common case and the ugly 
>> kvm_pfn_page_unwrap(gfn_to_pfn(...)) for the weird one.  In fact I'm not 
>> sure there should be any kvm_pfn_page_unwrap in the end.
> 
> If all callers were updated that is one thing, but from the changelog
> it sounds like that would not happen and there would be some gfn_to_pfn
> users left over.
> 
> But yes in the end you would either need to make gfn_to_pfn never return
> a page found via follow_pte, or change all callers to the new way. If 
> the plan is for the latter then I guess that's fine.

Actually in that case anyway I don't see the need -- the existence of
gfn_to_pfn is enough to know it might be buggy. It can just as easily
be grepped for as kvm_pfn_page_unwrap. And are gfn_to_page cases also
vulernable to the same issue?

So I think it could be marked deprecated or something if not everything 
will be converted in the one series, and don't need to touch all that 
arch code with this patch.

Thanks,
Nick
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
