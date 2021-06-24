Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AA1C49EA5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 08:57:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14B1361248
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 08:57:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14B1361248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA1F94B245;
	Thu, 24 Jun 2021 04:57:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tKxVtafSzW7f; Thu, 24 Jun 2021 04:57:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49BF94B22D;
	Thu, 24 Jun 2021 04:57:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E84174B1A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 04:52:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KqAn+0+zDuCi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 04:52:13 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93F874B226
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 04:52:13 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id
 x21-20020a17090aa395b029016e25313bfcso3052970pjp.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 01:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=9iS9TDXjHYeeO4p1tZR6e76NZxX4UTo0tHhJ02Bmyuc=;
 b=mEGHBnjuh74WaoNyT1eKb/VOfvVFvX3kwUneJ5AncMO10vay7V/YPF/SG5j7p8iYH1
 7gxNCDvNzDqb55aG0xXgAC1RA62Wj+bbizWaJDKEr0nn3qnuj2jXLdTdeiyFZgIkzbU6
 eUXYZQk6B3lHcCn/C7rK9Hfy2ewbGQ+QcUAXV5aikZlnmoVPOh+oFpMVHi12RR/PQruY
 Y7ojicHYDpa1rl6bybFrRzQg1WLQ4vvo9pySUIlXsW7HorWi3IZfqYmc1PUso5nJwGuX
 l372R3hUka0ng8Md0fedsRzdAZ1LxWh9MkI+AQUHTjtMJyFheflEYDzQL0UNZQwWosBs
 cQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=9iS9TDXjHYeeO4p1tZR6e76NZxX4UTo0tHhJ02Bmyuc=;
 b=FfwunJ3NSBhyqVdDH0gCCbZp/eBloXgLYhQdfWdZtnUdjjnTONl4wKVdHzkqOni1O+
 ZA/AfZA690ZXJd8X25JsqMB3CxOqDJJWuukj2KYrhBqRUCFq8wX6l9Wun7TWDgc/e8CD
 iA2qPoNCWaZRshdiA7eya7IVM+rkEPUFL/4Syl/jS3Vtp7HcmLZf7EtKIMwd1iJ1F7NF
 gobYruONv6Lgd4OtLsC3BkVRqIVtrbKwL1gUMPGlmcEve54Dl5zdwc8aGxbqUST1znW8
 XZkNSCy3UVRifTUpuNeSqXzEQQY6d43Qv3sQ3T6LdgWDUZmxzbw9FDxWWM9XLSJDhPKu
 QU3g==
X-Gm-Message-State: AOAM530HwgvWEIuzweEWI7ul3jruLxWeUz7OE2aHqew5WxPBU3S4jAne
 OdkUoLkc5cvZuMZSwv43f+o=
X-Google-Smtp-Source: ABdhPJxZDp/SyGeLqZPtuw/I81jZ765tjN1eiDWxfb5Gw8s0EqtrDghio6LIVydktk8tQn/Q5HNfVQ==
X-Received: by 2002:a17:90a:6fc1:: with SMTP id
 e59mr4396347pjk.37.1624524732566; 
 Thu, 24 Jun 2021 01:52:12 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id c5sm2109274pfv.47.2021.06.24.01.52.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 01:52:12 -0700 (PDT)
Date: Thu, 24 Jun 2021 18:52:06 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/6] KVM: mmu: also return page from gfn_to_pfn
To: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Huacai Chen
 <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>, Paul Mackerras
 <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>, David Stevens
 <stevensd@chromium.org>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang
 <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-3-stevensd@google.com>
In-Reply-To: <20210624035749.4054934-3-stevensd@google.com>
MIME-Version: 1.0
Message-Id: <1624524331.zsin3qejl9.astroid@bobo.none>
X-Mailman-Approved-At: Thu, 24 Jun 2021 04:57:25 -0400
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

Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
> From: David Stevens <stevensd@chromium.org>
> 
> Return a struct kvm_pfn_page containing both a pfn and an optional
> struct page from the gfn_to_pfn family of functions. This differentiates
> the gup and follow_fault_pfn cases, which allows callers that only need
> a pfn to avoid touching the page struct in the latter case. For callers
> that need a struct page, introduce a helper function that unwraps a
> struct kvm_pfn_page into a struct page. This helper makes the call to
> kvm_get_pfn which had previously been in hva_to_pfn_remapped.
> 
> For now, wrap all calls to gfn_to_pfn functions in the new helper
> function. Callers which don't need the page struct will be updated in
> follow-up patches.

Hmm. You mean callers that do need the page will be updated? Normally 
if there will be leftover users that don't need the struct page then
you would go the other way and keep the old call the same, and add a new
one (gfn_to_pfn_page) just for those that need it.

Most kernel code I look at passes back multiple values by updating 
pointers to struct or variables rather than returning a struct, I 
suppose that's not really a big deal and a matter of taste.

Thanks,
Nick

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
