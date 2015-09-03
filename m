From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/9] Rework architected timer and fix UEFI reset
Date: Thu, 03 Sep 2015 18:10:56 +0100
Message-ID: <55E87F20.40900@arm.com>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 30/08/15 14:54, Christoffer Dall wrote:
> The architected timer integration with the vgic had some shortcomings in
> that certain guests (one being UEFI) weren't fully supported.
> 
> In fixing this I also found that we are scheduling the hrtimer for the
> virtual timer way too often, with a potential performance overhead.
> 
> This series tries to address these problems in proviging level-triggered
> semantics for the arch timer and vgic intergration and seeks to clarify
> the behavior when setting/clearing the active state on the physical
> distributor.
> 
> Series based on kvmarm/next and also available at:
> https://git.linaro.org/people/christoffer.dall/linux-kvm-arm.git timer-rework

I'm quite pleased with the overall look of this series. It fixes a
number of issues that have been around for a while, plus some others
I've recently introduced...

Now, I fear this is probably too big a series to be shipped as a fix for
4.3. Can you come up with a minimal series that we could merge quickly
(I'm thinking patches 7 and 9), and leave the rest for the following
merge window?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
