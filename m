From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 02/11] ACPI / APEI: Generalise the estatus queue's
 add/remove and notify code
Date: Thu, 8 Mar 2018 11:44:08 +0100
Message-ID: <20180308104408.GB21166@pd.tnic>
References: <20180215185606.26736-1-james.morse@arm.com>
 <20180215185606.26736-3-james.morse@arm.com>
 <20180301150144.GA4215@pd.tnic>
 <87sh9jbrgc.fsf@e105922-lin.cambridge.arm.com>
 <20180301223529.GA28811@pd.tnic> <5AA02C26.10803@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <5AA02C26.10803@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 07, 2018 at 06:15:02PM +0000, James Morse wrote:
> Today its just x86 and arm64. arm64 doesn't have a hook to do this. I'm happy to
> add an empty declaration or leave it under an ifdef until someone complains
> about any behaviour I missed!

So I did some more staring at the code and I think oops_begin() is
needed mainly, as you point out, to prevent two oops messages from
interleaving. And yap, the other stuff with printk() is not true anymore
because the commit which added oops_begin():

  81e88fdc432a ("ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI notification type support")

still saw an NMI-unsafe printk. Which is long taken care of now.

So only the interleaving issue remains.

Which begs the question: how are you guys preventing the interleaving on
arm64? Because arch/arm64/kernel/traps.c:200 grabs the die_lock too, so
interleaving can happen on arm64 too, AFAICT.

And by that logic, you should technically grab that lock here too in
_in_nmi_notify_one().

Or?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
