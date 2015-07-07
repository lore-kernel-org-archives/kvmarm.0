From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 12/13] KVM: arm64: implement MSI injection in ITS
 emulation
Date: Tue, 7 Jul 2015 10:13:08 +0200
Message-ID: <20150707081308.GB13530@cbox>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-13-git-send-email-andre.przywara@arm.com>
 <5579C8AA.8010903@linaro.org>
 <559AB0ED.1090405@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559AB0ED.1090405@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 05:46:37PM +0100, Andre Przywara wrote:

[...]

> 
> >> +	inject = itte->enabled;
> >> +
> >> +out_unlock:
> >> +	spin_unlock(&its->lock);
> >> +
> >> +	if (inject) {
> >> +		spin_lock(&dist->lock);
> >> +		set_bit(cpuid, dist->irq_pending_on_cpu);
> > isn't it atomic op?
> 
> It is, but that's not what the lock protects. It's there to avoid
> stepping on someone else's toes, who might deal with the ITS data
> structures at the same time and would not expect a value to change in
> the middle (think about code iterating over dist->irq_pending_on_cpu).
> 
then should it be __set_bit ?

-Christoffer
