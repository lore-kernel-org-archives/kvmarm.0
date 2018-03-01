From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH 02/11] ACPI / APEI: Generalise the estatus queue's
 add/remove and notify code
Date: Thu, 01 Mar 2018 18:06:59 +0000
Message-ID: <87sh9jbrgc.fsf@e105922-lin.cambridge.arm.com>
References: <20180215185606.26736-1-james.morse@arm.com>
 <20180215185606.26736-3-james.morse@arm.com>
 <20180301150144.GA4215@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180301150144.GA4215@pd.tnic> (Borislav Petkov's message of
 "Thu, 1 Mar 2018 16:01:44 +0100")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Borislav Petkov <bp@alien8.de>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Borislav,

Borislav Petkov <bp@alien8.de> writes:

> On Thu, Feb 15, 2018 at 06:55:57PM +0000, James Morse wrote:
>> Keep the oops_begin() call for x86,
>
> That oops_begin() in generic code is such a layering violation, grrr.
>
>> arm64 doesn't have one of these,
>> and APEI is the only thing outside arch code calling this..
>
> So looking at:
>
> arch/arm/kernel/traps.c:die()
>
> it does call oops_begin() ... oops_end() just like the x86 version of
> die().

You're looking at support for the 32-bit ARM systems. The 64-bit support
lives in arch/arm64 and the die() there doesn't contain an
oops_begin()/oops_end(). But the lack of oops_begin() on arm64 doesn't
really matter here.

>
> I'm wondering if we could move the code to do die() in a prepatch? My
> assumption is that all the arches should have die()... A quick grep does
> show a bunch of other arches having die()...

One issue I see with calling die() is that it is defined in different
includes across various architectures, (e.g., include/asm/kdebug.h for
x86, include/asm/system_misc.h in arm64, etc.)
