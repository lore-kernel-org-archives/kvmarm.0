Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EA8C49EA5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:03:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF742613FB
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF742613FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0774B1D5;
	Thu, 24 Jun 2021 10:03:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wt3b8WKmBxH9; Thu, 24 Jun 2021 10:03:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 242324B198;
	Thu, 24 Jun 2021 10:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BA0F4B265
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 05:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4lq1RTBe01OV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 05:58:04 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 385684B264
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 05:58:04 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id t32so4723994pfg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 02:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=2/FXkDvvz78LZzi8vEuw9P0gxvIPqn8+9Qh994D56qo=;
 b=EhX2h/EGnTWqdqRQbpZlpJcgT0oJJ6o7Nef8q7EtPvI99smF5fr4TIG1Xp5CmTthMl
 XHQzIJWggbxJUXpq8OIPTnYOso57K6OBKZR9lvcFT5+8SBJA9849ahv3W1ndrCYtoccT
 yygIYTNJlnGOy5EhAkMecjcGkX/PpQmk6jKwKuAM0vg6/CjPiKQtp4B/woWoN5Oxyu7M
 ua8ZUETzbjTOqOpCOLZ+ZXZ4cbXcI88NdWfpPkU+Dnz/3z1CLTZvVnhoG0DpsDAi9bV1
 nK9pW2bxw2DMCvsnbAXlJB/lKwAPvP15NgJgI5cnQ6vQYvzhGuulMUnoZMx6s+4VaanO
 Eqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=2/FXkDvvz78LZzi8vEuw9P0gxvIPqn8+9Qh994D56qo=;
 b=DxevGnUzUMzcORd/Rzo0c3QUa3FXMoHBdZT+ms17CUBC02AB9HSPmUyBIsDaCyLEtk
 OIXBdeHMZRjtNOLEPDig1cNwtUoWe4keUvJ+nMUIQ8IHAs1z2HOEg7PWL4o052qY8uiP
 GbMB/GjdPqOHavA0Uvk9tgQSyk9/jhrRSw/tCxheNXLzDiBV12utcnB7aMIcwY+AOwMa
 hmiADL5EY+kd/A13Z9Ndc+YBgtrsqt6dCjb3wQeIriFb9N/zLzTyo1o7NrrlBKxvVIiZ
 2+uqblzuwbf4+cwrA0B35dV7LkAhnAumCnRl+Shz/13uZ60txzLdG4++iGxiA4RBHeZx
 rCeA==
X-Gm-Message-State: AOAM530vStrgg/GHaKZ+3T+aiVYMaVmQq5pt+E+AWbJ5+bjpm+DlC+08
 Qg9YBasrTCsBGLeIJkeogiM=
X-Google-Smtp-Source: ABdhPJzzKwhLHCAEARj7N7XbHWSLsSDNrl/BU7M36fXftqZpKf9BHg/7Rmx6MuG9ZeVpPhgC2xWSpQ==
X-Received: by 2002:a62:1857:0:b029:302:fb56:df52 with SMTP id
 84-20020a6218570000b0290302fb56df52mr4317733pfy.3.1624528683047; 
 Thu, 24 Jun 2021 02:58:03 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id y20sm2759510pfb.207.2021.06.24.02.58.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 02:58:02 -0700 (PDT)
Date: Thu, 24 Jun 2021 19:57:57 +1000
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
In-Reply-To: <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
MIME-Version: 1.0
Message-Id: <1624528342.s2ezcyp90x.astroid@bobo.none>
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

Excerpts from Paolo Bonzini's message of June 24, 2021 7:42 pm:
> On 24/06/21 10:52, Nicholas Piggin wrote:
>>> For now, wrap all calls to gfn_to_pfn functions in the new helper
>>> function. Callers which don't need the page struct will be updated in
>>> follow-up patches.
>> Hmm. You mean callers that do need the page will be updated? Normally
>> if there will be leftover users that don't need the struct page then
>> you would go the other way and keep the old call the same, and add a new
>> one (gfn_to_pfn_page) just for those that need it.
> 
> Needing kvm_pfn_page_unwrap is a sign that something might be buggy, so 
> it's a good idea to move the short name to the common case and the ugly 
> kvm_pfn_page_unwrap(gfn_to_pfn(...)) for the weird one.  In fact I'm not 
> sure there should be any kvm_pfn_page_unwrap in the end.

If all callers were updated that is one thing, but from the changelog
it sounds like that would not happen and there would be some gfn_to_pfn
users left over.

But yes in the end you would either need to make gfn_to_pfn never return
a page found via follow_pte, or change all callers to the new way. If 
the plan is for the latter then I guess that's fine.

Thanks,
Nick
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
