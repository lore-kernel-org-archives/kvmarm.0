From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 21/21] arm64: KVM: Remove weak attributes
Date: Wed, 02 Dec 2015 15:21:49 +0000
Message-ID: <565F0C8D.9010505@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com> <1448650215-15218-22-git-send-email-marc.zyngier@arm.com> <20151202114732.GA18376@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151202114732.GA18376@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 02/12/15 11:47, Christoffer Dall wrote:
> On Fri, Nov 27, 2015 at 06:50:15PM +0000, Marc Zyngier wrote:
>> As we've now switched to the new world switch implementation,
>> remove the weak attributes, as nobody is supposed to override
>> it anymore.
> 
> Why not remove the aliases and change the callers?

This is likely to be a bigger patch, and it would affect the 32bit as
well. So far, I'm choosing to keep things the same. Another solution
would be to completely drop the aliases, and just rename the new
function to have the old names.

I don't mind either way.

	M.
-- 
Jazz is not dead. It just smells funny...
