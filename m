From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] KVM/arm: kernel low level debug support for ARM32 virtual
 platforms
Date: Wed, 4 Nov 2015 20:13:39 -0500
Message-ID: <563AAD43.5090907@hurleysoftware.com>
References: <1446508313-24404-1-git-send-email-m.smarduch@samsung.com>
 <5638E1CD.8090006@codeaurora.org> <5638F294.4060409@samsung.com>
 <20151103175522.GA24856@arm.com> <56390838.3000204@samsung.com>
 <CAL_JsqJJHGwcdTDMh3WujJW0rDPxocVLEUpw95aVFC4FDEdDgA@mail.gmail.com>
 <20151104133147.GB5819@cbox> <563A531C.8090003@codeaurora.org>
 <CAKv+Gu8GJgzv82fVfCU7VQB2_ckRkzUYcQOx51rT2WgnmO_fsw@mail.gmail.com>
 <563A94A2.3010307@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <563A94A2.3010307@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Christopher Covington <cov@codeaurora.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Rob Herring <robherring2@gmail.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Grant Likely <grant.likely@secretlab.ca>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/04/2015 06:28 PM, Mario Smarduch wrote:
> I spent time debugging 'earlycon' for pl011, ironically using DEBUG_LL, from the
> looks of it no mmio uart should work for armv7. It appears earlycon_map()
> requires a fixed mapping similar to arm64.

commit a5f4c561b3b1 ("ARM: 8415/1: early fixmap support for earlycon")
added ARM fixmap support for earlycon since 4.3-rc1. That was in it's 5th
revision; various versions have been on lkml since Dec 2014 or so.

Regards,
Peter Hurley
