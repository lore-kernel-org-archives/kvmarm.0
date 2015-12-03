From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: Revert to old way of checking for device
 mapping in stage2_flush_ptes().
Date: Thu, 03 Dec 2015 11:14:26 +0300
Message-ID: <008401d12da2$a093d5d0$e1bb8170$@samsung.com>
References: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
 <CAKv+Gu-WhtTZoPEmRSa8Ypcc9SZ-d6NABDSfZ6tTx14Tyt+AdQ@mail.gmail.com>
 <007c01d12d9a$36dd6eb0$a4984c10$@samsung.com>
 <CAKv+Gu8qBy_aBC2ZUB5D3ZNMdkdy-Q+XTD2bOXfnM_g1239e7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-reply-to: <CAKv+Gu8qBy_aBC2ZUB5D3ZNMdkdy-Q+XTD2bOXfnM_g1239e7A@mail.gmail.com>
Content-language: ru
Sender: stable-owner@vger.kernel.org
To: 'Ard Biesheuvel' <ard.biesheuvel@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, 'KVM devel mailing list' <kvm@vger.kernel.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >> I think your analysis is correct, but does that not apply to both instances?
> >
> >  No no, another one is correct, since it operates on real PFN (at least looks like so). I
> have verified my fix against the original problem (crash on Exynos5410 without generic timer),
> and it still works fine there.
> >
> 
> I don't think so. Regardless of whether you are manipulating HYP
> mappings or stage-2 mappings, the physical address is always the
> output, not the input of the translation, so addr is always either a
> virtual address or a intermediate physical address, whereas
> pfn_valid() operates on host physical addresses.

 Yes, you are right. I have reviewed this more carefully, and indeed, unmap_range() is also called by unmap_stage2_range(), so it can be both IPA and real PA.

> OK. I will follow up with a patch, as Christoffer requested. I'd
> appreciate it if you could test to see if it also fixes the current
> issue, and the original arch timer issue.

 I have just made the same patch, and currently testing it on all my boards. Also i'll test it on my ARM64 too, just in case. I was about to finish the testing and send the patch in maybe one or two hours.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
