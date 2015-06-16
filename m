From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 01/11] KVM: arm: plug guest debug exploit
Date: Tue, 16 Jun 2015 17:49:15 +0100
Message-ID: <20150616164914.GM30522@arm.com>
References: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org>
 <1433046432-1824-2-git-send-email-zhichao.huang@linaro.org>
 <556C3A68.8050903@arm.com>
 <557449EA.7040003@linaro.org>
 <5576BFF7.3070706@arm.com>
 <557DA6E4.7090609@linaro.org>
 <557DA811.8090705@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <557DA811.8090705@linaro.org>
Sender: stable-owner@vger.kernel.org
To: zichao <zhichao.huang@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "alex.bennee@linaro.org" <alex.bennee@linaro.org>, "huangzhichao@huawei.com" <huangzhichao@huawei.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Jun 14, 2015 at 05:13:05PM +0100, zichao wrote:
> I and marc are talking about how to plug the guest debug exploit in an
> easier way.
> 
> I remembered that you mentioned disabling monitor mode had proven to be
> extremely fragile in practice on 32-bit ARM SoCs, what if I save/restore
> the debug monitor mode on each switch between the guest and the host,
> would it be acceptable?

If you're just referring to DBGDSCRext, then you could give it a go, but
you'll certainly want to predicate any writes to that register on whether
or not hw_breakpoint managed to reset the debug regs on the host.

Like I said, accessing these registers always worries me, so I'd really
avoid it in KVM if you can. If not, you'll need to do extensive testing
on a bunch of platforms with and without the presence of external debug.

Will
