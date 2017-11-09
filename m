From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PULL 00/26] KVM/ARM Changes for v4.15
Date: Thu, 9 Nov 2017 19:04:37 +0100
Message-ID: <20171109180436.GB15561@flask>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

2017-11-07 11:47+0100, Christoffer Dall:
> Hi Paolo and Radim,
> 
> Here is the first round of KVM/ARM Changes for v4.15.  I will follow up
> with a second pull request based on tip:irq/core containing the KVM/ARM
> side of the GICv4 support.
> 
> Changes in this pull requestinclude:
>  - Optimized arch timer handling for KVM/ARM
>  - Improvements to the VGIC ITS code and introduction of an ITS reset
>    ioctl
>  - Unification of the 32-bit fault injection logic
>  - More exact external abort matching logic

Pulled, thanks.
