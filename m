Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D10C49EA5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 15:35:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75B55613ED
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 15:35:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75B55613ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBFBA4B111;
	Thu, 24 Jun 2021 11:35:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FDhhxAeIq4Qv; Thu, 24 Jun 2021 11:35:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA14E4B150;
	Thu, 24 Jun 2021 11:35:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0BFC4B111
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 11:35:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UOM-tna+fPiR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 11:35:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A5604AEE2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 11:35:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624548933;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=f6k4ykVaPXFxqKCeveqsqgjZTsHJh+2Hx0FU9Hu8Shk=;
 b=RL0B0qZZrMcU1C7Fo5MlhkAR7MRpxPlyswabh29iDojqBOsLHUA3iBzvy/gI0AakxyTacx
 rBckOKBPtHtz5oaYLldVfQ2iI8icraMcxazmARf1YSm6K2b/Nt4gXfXQDsbotCR8EQwT+Z
 3eV9VNUNXfhFI6BAVmY7Ue5+mFkco+Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-brwcVe0JMdCiJzCfowlotQ-1; Thu, 24 Jun 2021 11:35:32 -0400
X-MC-Unique: brwcVe0JMdCiJzCfowlotQ-1
Received: by mail-wr1-f71.google.com with SMTP id
 f9-20020a5d64c90000b029011a3c2a0337so2364402wri.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 08:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=f6k4ykVaPXFxqKCeveqsqgjZTsHJh+2Hx0FU9Hu8Shk=;
 b=WgTWStZoZ3AwmKoICC2r/Q0DxwpiR154z9ei4rHCykZG7Mj2C56WK0rA1gEdGnWcTb
 sPif51LWslK66ZAxq43RnZSl6LpnQ7B0MmXPcltmQkqiACvKTYptNfD9eWBZhzAc8dfH
 yWrHsCgylIiP6s09beX8JVmt5+uRulQ8m3DXY7bufjagaIT5gQ+GkNDwLwq76cU3bq6S
 AjsBcWPX4uq1xcOEmcSOcdqEQFi1qYcSJwReU+DYiD0Inu24kX3zQJ0WnVievlf1uhVX
 uDj+c4+Cn4QGogMDVorwbckoFdei6216a96EGcNq/XOHDNwEhAeBnw1FQ/77h7c/IDxG
 f3Pg==
X-Gm-Message-State: AOAM531LDlO1zQuG6O698fxcmyrT/uBDIEbSJVSPwQUAngoTmFctJ73u
 3zl702560aJZ7XUlmu0h7Do9oV67dIJzzSoHQeCWgYNGMWEFH+Q4PEC0yF4FufczL0fw7w1e7Gg
 fXSUR8kD+Pu/JrLuPbOW4qdvm
X-Received: by 2002:a05:6000:1251:: with SMTP id
 j17mr5373909wrx.122.1624548927965; 
 Thu, 24 Jun 2021 08:35:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBnDqu4vf3bAIylFJkD7JiEEmgRW9T3VoP4swdNx5pmdzHboAZtCJNJi7bVPTY8V2i+hs/AQ==
X-Received: by 2002:a05:6000:1251:: with SMTP id
 j17mr5373864wrx.122.1624548927675; 
 Thu, 24 Jun 2021 08:35:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id v18sm4013288wrv.24.2021.06.24.08.35.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 24 Jun 2021 08:35:27 -0700 (PDT)
To: Nicholas Piggin <npiggin@gmail.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, David Stevens <stevensd@chromium.org>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <1624530624.8jff1f4u11.astroid@bobo.none>
 <1624534759.nj0ylor2eh.astroid@bobo.none>
 <0d3a699a-15eb-9f1b-0735-79d14736f38c@redhat.com>
 <1624539354.6zggpdrdbw.astroid@bobo.none>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64 MMU
Message-ID: <81d99029-ec40-19c5-5647-20607d78dab0@redhat.com>
Date: Thu, 24 Jun 2021 17:35:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624539354.6zggpdrdbw.astroid@bobo.none>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Stevens <stevensd@google.com>, intel-gfx@lists.freedesktop.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, kvm-ppc@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 24/06/21 14:57, Nicholas Piggin wrote:
> KVM: Fix page ref underflow for regions with valid but non-refcounted pages

It doesn't really fix the underflow, it disallows mapping them in the 
first place.  Since in principle things can break, I'd rather be 
explicit, so let's go with "KVM: do not allow mapping valid but 
non-reference-counted pages".

> It's possible to create a region which maps valid but non-refcounted
> pages (e.g., tail pages of non-compound higher order allocations). These
> host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
> of APIs, which take a reference to the page, which takes it from 0 to 1.
> When the reference is dropped, this will free the page incorrectly.
> 
> Fix this by only taking a reference on the page if it was non-zero,

s/on the page/on valid pages/ (makes clear that invalid pages are fine 
without refcounting).

Thank you *so* much, I'm awful at Linux mm.

Paolo

> which indicates it is participating in normal refcounting (and can be
> released with put_page).
> 
> Signed-off-by: Nicholas Piggin<npiggin@gmail.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
