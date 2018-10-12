From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 05/18] ACPI / APEI: Make estatus queue a Kconfig symbol
Date: Fri, 12 Oct 2018 18:17:48 +0100
Message-ID: <52228145-f024-0ee1-01c7-da92023d53cc@arm.com>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-6-james.morse@arm.com> <20181001175956.GF7269@zn.tnic>
 <a562d7c4-2e74-3a18-7fb0-ba8f40d2dce4@arm.com>
 <20181004173416.GC5149@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F16674A20D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 13:17:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R3QaIdDpRhDa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Oct 2018 13:17:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2A7B49E3E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 13:17:53 -0400 (EDT)
In-Reply-To: <20181004173416.GC5149@zn.tnic>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Borislav Petkov <bp@alien8.de>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Boris,

On 04/10/2018 18:34, Borislav Petkov wrote:
> On Wed, Oct 03, 2018 at 06:50:36PM +0100, James Morse wrote:
>> I'm all in favour of letting the compiler work it out, but the existing ghes
>> code has #ifdef/#else all over the place. This is 'keeping the style'.
> 
> Yeah, but this "style" is not the optimal one and we should
> simplify/clean up and fix this thing.
> 
> Swapping the order of your statements here:
> 
>> The ACPI spec has four ~NMI notifications, so far the support for
>> these in Linux has been selectable separately.
> 
> Yes, but: distro kernels end up enabling all those options anyway and
> distro kernels are 90-ish% of the setups. Which means, this will get
> enabled anyway and this additional Kconfig symbol is simply going to be
> one automatic reply "Yes".
> 
> So let's build it in by default and if someone complains about it, we
> can always carve it out. But right now I don't see the need for the
> unnecessary separation...

Ripping out the existing #ifdefs and replacing them with IS_ENABLED() would let
the compiler work out the estatus stuff is unused, and saves us describing the
what-uses-it logic in Kconfig.

But this does expose the x86 nmi stuff on arm64, which doesn't build today.
Dragging NMI_HANDLED and friends up to the 'linux' header causes a fair amount
of noise under arch/x86 (include the new header in 22 files). Adding dummy
declarations to arm64 fixes this, and doesn't affect the other architectures
that have an asm/nmi.h

Alternatively we could leave {un,}register_nmi_handler() under
CONFIG_HAVE_ACPI_APEI_NMI. I think we need to keep the NOTIFY_NMI kconfig symbol
around, as its one of the two I can't work out how to fix without the TLBI-IPI.


Thanks,

James
