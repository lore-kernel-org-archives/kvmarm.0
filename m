From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 00/15] KVM: arm64: GICv3 ITS emulation
Date: Thu, 24 Sep 2015 12:35:05 +0100
Message-ID: <5603DFE9.2090106@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <168d01d0f6ba$b83a1ab0$28ae5010$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <168d01d0f6ba$b83a1ab0$28ae5010$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On 24/09/15 12:18, Pavel Fedin wrote:
>  Hello Andre and others!
> 
>  How are things going? I see the last message in thread something like 1 month old, then silence...
>  Our project relies on this feature, any assistance needed?

I am about to make it work on top of Christoffer's latest arch timer
rework patches, which means I need to rewrite most of patch 1. Currently
that boots, but hangs as soon as I put some load on it. Finding the
reason for this is a bit tedious at the moment.
I have addressed the comments from the list on the other patches, so
ideally I can send a new revision as soon as I fixed that bug in the
first patch.

Cheers,
Andre.
