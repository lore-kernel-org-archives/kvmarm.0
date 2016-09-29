From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PULL 00/50] KVM/ARM Changes for v4.9
Date: Thu, 29 Sep 2016 16:46:07 +0200
Message-ID: <20160929144606.GA24662@potion>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

2016-09-27 20:05+0200, Christoffer Dall:
> Hi Paolo and Radim,
> 
> Here are the KVM/ARM Changes for v4.9. They include:
> 
>  - Various cleanups and removal of redundant code
>  - Two important fixes for not using an in-kernel irqchip
>  - A bit of optimizations
>  - Handle SError exceptions and present them to guests if appropriate
>  - Proxying of GICV access at EL2 if guest mappings are unsafe
>  - GICv3 on AArch32 on ARMv8
>  - Preparations for GICv3 save/restore, including ABI docs

Pulled to kvm/next, thanks.
