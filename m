Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CD0C49EA6
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:04:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02DC9613FB
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02DC9613FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAA8D4B1A5;
	Thu, 24 Jun 2021 10:03:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BgNydUJhtlG9; Thu, 24 Jun 2021 10:03:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79B734B1AB;
	Thu, 24 Jun 2021 10:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7756A4B0A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:42:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rm-zVPM3XA+g for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 06:42:15 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E89F4B087
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:42:15 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id c8so4806806pfp.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 03:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=NfjdhOW72m4TGpvzWGEQF11KzSsneVbaVBvFK0bGPzo=;
 b=Kt+9hz5Z8hf17MTaP2NEbCNsixEB/2vtcneDIWMxInZE3wFpBTCY4arVW85yk4tRHF
 qWXnzq5TbY8JfmQrKqxmZnou8HmT8i1seCjd1BlC3DaEQNjDAwV+HQjRqrh2wSC5wL59
 gRrb2rxjfZldQEn+6eMb0tmL7unUZmTBjbxFxwf6fUug4isZHK1CcpQ0getq8GAd87FC
 3RcDqKD/Mv0yWnn2UAF2jMZ1K/PXC5Gqwy+wDcve3LXPzWTqm+dcHR3tVukvmCrbGHtj
 N0va4eRcYEBOnrKc/XVLBME0xL1myho/N5KENcJl2Jx0DUZHv582U2/2wqKp+nzNi87p
 llKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=NfjdhOW72m4TGpvzWGEQF11KzSsneVbaVBvFK0bGPzo=;
 b=PRqnpaVkcxASO+K4/zOyqa3NhHzV00xwETi6DXTL7BLZX5Qbpyye7cUC9JuNmH4ttf
 u9SW97SwjS7W/KW0z79K7e9d881Ir4QQsktXlH+lCkiAXhnZ4aGwb60cx6L1lauGS6fs
 iLCLu/W/e/5/HF9LASLE7bu114/czDHb3KUKH0Nk8xmxHoe+zhfbXZJTW8u/qzoo5WNz
 Cp7SrgNYPM/1EL02YMnG9hHD+SAj2ncjsTemi+40or1r9Jy8X3WgCAqihpm1IWuvk+aR
 JKvGD9wdRSQVolimADjPi34Fz4oc0qYvg0ubpBu91Z/JZxPOcccsV3su0jp2hEqMEGYe
 RNlA==
X-Gm-Message-State: AOAM531e4KdJLKsRTWWmBu6gr1bqPq9YmeqPCIq/zs5ETPWPgkHmVBKR
 kICD1O9ZywMOPNhmzdr7OU4=
X-Google-Smtp-Source: ABdhPJx+bbBfj2pzk/mB2ERG+jW9T31gVCsxpF6k7D325eLHwjfeRucb+BobnHJ3y5XGrFTWG6Ebcw==
X-Received: by 2002:a63:586:: with SMTP id 128mr4140080pgf.366.1624531334522; 
 Thu, 24 Jun 2021 03:42:14 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id i8sm2522609pfq.165.2021.06.24.03.42.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 03:42:14 -0700 (PDT)
Date: Thu, 24 Jun 2021 20:42:08 +1000
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
 <1624529635.75a1ann91v.astroid@bobo.none>
 <fc2a88ed-6a98-857d-bb1f-73260b01ac30@redhat.com>
In-Reply-To: <fc2a88ed-6a98-857d-bb1f-73260b01ac30@redhat.com>
MIME-Version: 1.0
Message-Id: <1624531085.fax3fcqpgc.astroid@bobo.none>
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

Excerpts from Paolo Bonzini's message of June 24, 2021 8:21 pm:
> On 24/06/21 12:17, Nicholas Piggin wrote:
>>> If all callers were updated that is one thing, but from the changelog
>>> it sounds like that would not happen and there would be some gfn_to_pfn
>>> users left over.
>>>
>>> But yes in the end you would either need to make gfn_to_pfn never return
>>> a page found via follow_pte, or change all callers to the new way. If
>>> the plan is for the latter then I guess that's fine.
>>
>> Actually in that case anyway I don't see the need -- the existence of
>> gfn_to_pfn is enough to know it might be buggy. It can just as easily
>> be grepped for as kvm_pfn_page_unwrap.
> 
> Sure, but that would leave us with longer function names 
> (gfn_to_pfn_page* instead of gfn_to_pfn*).  So the "safe" use is the one 
> that looks worse and the unsafe use is the one that looks safe.

The churn isn't justified because of function name length. Choose g2pp() 
if you want a non-descriptive but short name.

The existing name isn't good anyway because it not only looks up a pfn 
but also a page, and more importantly it gets a ref on the page. The
name should be changed if you introduce a new API.

>> And are gfn_to_page cases also
>> vulernable to the same issue?
> 
> No, they're just broken for the VM_IO|VM_PFNMAP case.

No they aren't vulnerable, or they are vunlerable but also broken in 
other cases?

Thanks,
Nick
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
