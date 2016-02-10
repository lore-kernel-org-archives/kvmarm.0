From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 22/28] ARM: KVM: Switch to C-based stage2 init
Date: Wed, 10 Feb 2016 07:42:47 +0000
Message-ID: <20160210074247.589db14b@arm.com>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
	<1454583645-10144-23-git-send-email-marc.zyngier@arm.com>
	<20160209184513.GX5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160209184513.GX5171@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 9 Feb 2016 19:45:13 +0100
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> Mising (sarcastic) commit message?

Ah! I'll try to think of something along the lines of:

"Let's now retire the code that bravely served us for three
years, and enjoy a brand new set of bugs. At least, we can blame the
compiler this time."

> On Thu, Feb 04, 2016 at 11:00:39AM +0000, Marc Zyngier wrote:
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
