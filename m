From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 05/18] ACPI / APEI: Make estatus queue a Kconfig symbol
Date: Wed, 3 Oct 2018 18:50:36 +0100
Message-ID: <a562d7c4-2e74-3a18-7fb0-ba8f40d2dce4@arm.com>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-6-james.morse@arm.com> <20181001175956.GF7269@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D17EC4A214
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Oct 2018 13:50:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FW96ymBlqC0S for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Oct 2018 13:50:43 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A770849E3E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Oct 2018 13:50:43 -0400 (EDT)
In-Reply-To: <20181001175956.GF7269@zn.tnic>
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

On 01/10/18 18:59, Borislav Petkov wrote:
> On Fri, Sep 21, 2018 at 11:16:52PM +0100, James Morse wrote:
>> Now that there are two users of the estatus queue, and likely to be more,
>> make it a Kconfig symbol selected by the appropriate notification. We
>> can move the ARCH_HAVE_NMI_SAFE_CMPXCHG checks in here too.
> 
> Ok, question: why do we need to complicate things at all? I mean, why do
> we even need a Kconfig symbol?

Before patch 4, this was behind CONFIG_HAVE_ACPI_APEI_NMI, (so it made use of an
existing kconfig symbol), and there was only one user x86:NMI.

The ACPI spec has four ~NMI notifications, so far the support for these in Linux
has been selectable separately. If you build the kernel without any of them then
this code would be unused, and generate warnings because all those users are
behind #ifdef too.


> This code is being used by two arches now so why not simply build it in
> unconditionally and be done with it. The couple of KB saved are simply
> not worth the effort, especially if it is going to end up being enabled
> on 99% of the setups...

I'm all in favour of letting the compiler work it out, but the existing ghes
code has #ifdef/#else all over the place. This is 'keeping the style'.
I assumed it was done this way to support an older compiler on x86, (I see that
jumped from 3.2 to 4.6 with commit cafa0010cd51)

We could strip the lot away to a few IS_ENABLED() in ghes_probe() and the
memory_failure()/AER calls if you'd prefer.


Thanks,

James
