From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCHv4 00/10] ARMv8.3 pointer authentication userspace support
Date: Wed, 4 Jul 2018 17:12:12 +0100
Message-ID: <20180704161212.GS4828@arm.com>
References: <20180503132031.25705-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180503132031.25705-1-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, christoffer.dall@arm.com, drjones@redhat.com, marc.zyngier@arm.com, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, awallis@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

HI Mark,

On Thu, May 03, 2018 at 02:20:21PM +0100, Mark Rutland wrote:
> This series adds support for the ARMv8.3 pointer authentication extension,
> enabling userspace return address protection with recent versions of GCC.

As discussed off-list, I'd really like to get a feel for how we might use
this to protect the kernel before we commit to a userspace ABI, especially
given that there is some level of resource sharing with the keys.

So ideally, we'd merge this along with the support for the kernel side.
In the meantime, is it worth taking any of the ID register sanity checks
now?

Will
