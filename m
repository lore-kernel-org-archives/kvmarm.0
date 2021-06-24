Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D44FC49EA5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 06:57:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5DA1613CC
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 06:57:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5DA1613CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 679D34B0CD;
	Thu, 24 Jun 2021 02:57:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fH976fqJteBZ; Thu, 24 Jun 2021 02:57:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF414B13A;
	Thu, 24 Jun 2021 02:57:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EDF14B11A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 02:57:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hrQ9sJBPxq4E for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 02:57:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56A074B0CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 02:57:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624517863;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=igFDOV6BxGJ7IfsozRxLlI1SBnI7ilQNQtLZk9DKzFQ=;
 b=NfMKvr8Ax1E1LpAoe9jSBidAQj+ol3buwQmpYHGZG+kDQY+eCVgPPndbFH8AmRYtuUGdd6
 73Dbvk1gl3N6WMgE0j2Ge8KPXEThGtYmYzN2ufR5BXrPwwfcYj9hfimVKweuRvymgVyEEw
 vdbW6duZZOGeWQm/vjJkitKFrUcOawo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-DYSdtq6CN7ynbywlIVezOg-1; Thu, 24 Jun 2021 02:57:41 -0400
X-MC-Unique: DYSdtq6CN7ynbywlIVezOg-1
Received: by mail-wr1-f71.google.com with SMTP id
 l6-20020a0560000226b029011a80413b4fso1813631wrz.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 23:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=igFDOV6BxGJ7IfsozRxLlI1SBnI7ilQNQtLZk9DKzFQ=;
 b=PzY6IqqydYbxqX959iVA6JS0KmVK8knqoU4licvJ3/rX1MEuMDA+s/EZOPxDQROWoi
 fjfnWMrnSvYsUyLpySf4P25Ung/SVPRlPa4piLIub4tSqJzORq//0pyWpM0A5vkee8fE
 eaEBDddHsMFOsxBcZnG+eeO84hSy9JmDOU6DUXHRqKxVd2PRgMS2NCFHrK+OY/yz+ZYJ
 VyGFMf37wOE0Ey4STWwn0zrBWJpDldqsxCli6PgySB5sMVYBnL7KEZfYI6YjwIYcf5N4
 iVShFz2pt0aKBKa3XbMciBMV3lfLDosPqsepKQuG8wk7bCGgkLbuj6TjtoAsBtgH8WRZ
 LNIA==
X-Gm-Message-State: AOAM531hwUqbOMAUMhTymluZNZhL7oArJNEibfMGKJQekar3PxELVouf
 em8FFfb5Elp7un0ttSsPniKwY9uUdPRizx63/V8Y6o8pzKVFgeJFIADuQ3JTOtF9JawMuUFxnvq
 XIZaPLEsDAzfVW9Vmyf12qdov
X-Received: by 2002:a05:6000:1889:: with SMTP id
 a9mr85624wri.141.1624517860519; 
 Wed, 23 Jun 2021 23:57:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdqChWxI2TqFhdGI9pdTdW0OY2cpxOML9ILwZzD3plJUW6I8N3vbOFGhbVC127GRhm0xAu2w==
X-Received: by 2002:a05:6000:1889:: with SMTP id
 a9mr85587wri.141.1624517860347; 
 Wed, 23 Jun 2021 23:57:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id o26sm1900491wmr.29.2021.06.23.23.57.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 23 Jun 2021 23:57:39 -0700 (PDT)
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64 MMU
To: David Stevens <stevensd@chromium.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhi Wang <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20baae77-785c-5d46-e00c-41d86c2fbc56@redhat.com>
Date: Thu, 24 Jun 2021 08:57:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210624035749.4054934-1-stevensd@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: David Stevens <stevensd@google.com>, intel-gvt-dev@lists.freedesktop.org,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Joerg Roedel <joro@8bytes.org>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On 24/06/21 05:57, David Stevens wrote:
> KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by using
> follow_pte in gfn_to_pfn. However, the resolved pfns may not have
> assoicated struct pages, so they should not be passed to pfn_to_page.
> This series removes such calls from the x86 and arm64 secondary MMU. To
> do this, this series modifies gfn_to_pfn to return a struct page in
> addition to a pfn, if the hva was resolved by gup. This allows the
> caller to call put_page only when necessated by gup.
> 
> This series provides a helper function that unwraps the new return type
> of gfn_to_pfn to provide behavior identical to the old behavior. As I
> have no hardware to test powerpc/mips changes, the function is used
> there for minimally invasive changes. Additionally, as gfn_to_page and
> gfn_to_pfn_cache are not integrated with mmu notifier, they cannot be
> easily changed over to only use pfns.
> 
> This addresses CVE-2021-22543 on x86 and arm64.

Thank you very much for this.  I agree that it makes sense to have a 
minimal change; I had similar changes almost ready, but was stuck with 
deadlocks in the gfn_to_pfn_cache case.  In retrospect I should have 
posted something similar to your patches.

I have started reviewing the patches, and they look good.  I will try to 
include them in 5.13.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
