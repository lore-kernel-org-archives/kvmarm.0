From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 22/25] ACPI / APEI: Kick the memory_failure() queue for
 synchronous errors
Date: Wed, 23 Jan 2019 18:37:32 +0000
Message-ID: <ae892690-fdf7-b326-1c76-5bf39c2c9bb5@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-23-james.morse@arm.com>
 <9d153a07-aa7a-6e0c-3bd3-994a66f9639a@huawei.com>
 <5c775aa9-ea57-dea7-6083-c1e3fc160b29@arm.com>
 <20190122105143.GB26587@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190122105143.GB26587@zn.tnic>
Content-Language: en-GB
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-acpi@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Boris,

On 22/01/2019 10:51, Borislav Petkov wrote:
> On Mon, Dec 10, 2018 at 07:15:13PM +0000, James Morse wrote:
>> What happens if we miss MF_ACTION_REQUIRED?
> 
> AFAICU, the logic is to force-send a signal to the user process, i.e.,
> force_sig_info() which cannot be ignored. IOW, an "enlightened" process
> would know how to do recovery action from a memory error.
> 
> VS the action optional thing which you can handle at your leisure.

> So the question boils down to what kind of severity do the errors
> reported through SEA have? I mean, if the hw would go the trouble to do
> the synchronous reporting, then something important must've happened and
> it wants us to know about it and handle it.

Before v8.2 we assumed these were fatal for the thread, it couldn't make progress.
Since v8.2 we get a value from the CPU, the severity values are, (the flippant
summary is obviously mine!):
* Recoverable: "You're about to step in it, fix it or die"
* Uncontainable: "It was here, but it escaped, we dont know where it went, panic!"
* Restartable/Corrected: "its fine, pretend this didn't happen"

Firmware should duplicate these values into the CPER severity fields.


>> Surely the page still gets unmapped as its PG_Poisoned, an AO signal
>> may be pending, but if user-space touches the page it will get an AR
>> signal. Is this just about removing an extra AO signal to user-space?

If we miss MF_ACTION_REQUIRED, the page still gets unmapped from user-space, and
user-space gets an AO signal. With this patch it takes that signal before it
continues. If it ignores it, the access gets a translation-fault->EHWPOISON->AR
signal from the arch code.

... so missing the flag gives us an extra signal. I'm not convinced this results
in any observable difference.


>> If we do need this, I'd like to pick it up from the CPER records, as x86's
>> NOTIFY_NMI looks like it covers both AO/AR cases. (as does NOTIFY_SDEI). The
>> Master/Target abort or Invalid-address types in the memory-error-section CPER
>> records look like the best bet.
> 
> Right, and we do all kinds of severity mapping there aka ghes_severity()
> so that'll be a good start, methinks.

The options are those 'aborts' in the memory error. These must have been a
result of some request. If we get a CPU error structure as part of the same
block, it may have a cache/bus error structure, which has a precise bit that
tells us whether this is a co-incidence. (but linux doesn't support any of those
structures today)



Thanks,

James
