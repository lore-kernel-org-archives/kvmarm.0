Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621E3C49EA7
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:04:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 002D6613FB
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 002D6613FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A68704B174;
	Thu, 24 Jun 2021 10:04:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3RqYiqmi+bsk; Thu, 24 Jun 2021 10:03:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 919714B1AF;
	Thu, 24 Jun 2021 10:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 701D84B0A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:43:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zd+fR2B69brv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 06:43:36 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84B954B087
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:43:36 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id
 t19-20020a17090ae513b029016f66a73701so5631114pjy.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 03:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=Ntmvbr4Rsn/lopxAADIIDgcNErNmU/zbadQcByBiYK4=;
 b=Uzc43caEhY2Ti31+lpHHW0AZ5sLCVj6W+n4t/ez5IgVzQkVZOibK2DIWQ0+CAuzt9U
 PpuIA4kDsyK3chDvHhxE+YawXhAPb2eWGecCvYilJeif5bW1AWaPBDm7W4vYjxTYq4eX
 vsAbVyUYfQJDK46zRrnjfoRU3RdSuUfndWfij+20vPjPzE9a8Ky+gzwBiWuGHYujrH97
 b1g8G9j+MqQ6oKRgvSqRRvZdf9oww+7IytooiBQtjKLAdCQfMAXpO/dc/FMWyHkr12JS
 ZqabhMCopqc94H8G+WPpptqvIqeO4Wfi2qlPKFQXomh5RWpLJ4WGRgIbJ4SL7OebaZ9b
 Cu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=Ntmvbr4Rsn/lopxAADIIDgcNErNmU/zbadQcByBiYK4=;
 b=KWuSVIlyqYt8eb6aDPRLCOZMeMpWDpsFm332dd0GLqm/2tjYpXbakk0opU62uqwaIF
 0LYuP7F9z+Q5kZ/cbretw4JqEdqHOGgTUMMmdQrgTGjnlZnT2wJA6nwpoIMdTsZieuCQ
 t0q9Fvz9rR4iq5Sb4dZGC62LXGV+kU1JkWEId7+ypPCwtAEdTdeoLNtiPIIvRDqReQ53
 4yNRijtgnpqP5UJr+h0Jk9dhoyYrqrEzw5FnJfnzyA84ftLATThWDSdUCBxkKdHBoCCq
 uidWS5pr71OQAfoDitYGuzcQD2cnhy+RsmlCFBMx4zYBozv2bf+VTmOiiBLGU94PkO5t
 EzaA==
X-Gm-Message-State: AOAM530Yw3M4/oCRii9OcV3ehTKMaPukUjANS8lsgnvcN9/J8ScNo0Ww
 VEfx9OueDSlFasMXl2vP/2Q=
X-Google-Smtp-Source: ABdhPJwSbcPeLeFEknq5SPs1K9/7wAZ9//Y8XUJsBm0HOgxDXNJ+d8W1kIX2/TWCimMS0wf9W28w6Q==
X-Received: by 2002:a17:90a:ce87:: with SMTP id
 g7mr14492750pju.189.1624531415692; 
 Thu, 24 Jun 2021 03:43:35 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id n12sm2540624pfu.5.2021.06.24.03.43.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 03:43:35 -0700 (PDT)
Date: Thu, 24 Jun 2021 20:43:29 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 3/6] KVM: x86/mmu: avoid struct page in MMU
To: Marc Zyngier <maz@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-4-stevensd@google.com>
 <1624524744.2sr7o7ix86.astroid@bobo.none> <87mtrfinks.wl-maz@kernel.org>
In-Reply-To: <87mtrfinks.wl-maz@kernel.org>
MIME-Version: 1.0
Message-Id: <1624531381.4bht02wxsj.astroid@bobo.none>
X-Mailman-Approved-At: Thu, 24 Jun 2021 10:03:53 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, intel-gvt-dev@lists.freedesktop.org,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Zhi Wang <zhi.a.wang@intel.com>, intel-gfx@lists.freedesktop.org,
 kvm-ppc@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 David Stevens <stevensd@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

Excerpts from Marc Zyngier's message of June 24, 2021 8:06 pm:
> On Thu, 24 Jun 2021 09:58:00 +0100,
> Nicholas Piggin <npiggin@gmail.com> wrote:
>> 
>> Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
>> > From: David Stevens <stevensd@chromium.org>
>> >  out_unlock:
>> >  	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
>> >  		read_unlock(&vcpu->kvm->mmu_lock);
>> >  	else
>> >  		write_unlock(&vcpu->kvm->mmu_lock);
>> > -	kvm_release_pfn_clean(pfn);
>> > +	if (pfnpg.page)
>> > +		put_page(pfnpg.page);
>> >  	return r;
>> >  }
>> 
>> How about
>> 
>>   kvm_release_pfn_page_clean(pfnpg);
> 
> I'm not sure. I always found kvm_release_pfn_clean() ugly, because it
> doesn't mark the page 'clean'. I find put_page() more correct.
> 
> Something like 'kvm_put_pfn_page()' would make more sense, but I'm so
> bad at naming things that I could just as well call it 'bob()'.

That seems like a fine name to me. A little better than bob.

Thanks,
Nick
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
