From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 10/25] ACPI / APEI: Tell firmware the estatus queue
 consumed the records
Date: Fri, 11 Jan 2019 18:25:21 +0000
Message-ID: <32025682-f85a-58ef-7386-7ee23296b944@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-11-james.morse@arm.com>
 <20181211183634.GO27375@zn.tnic>
 <56cfa16b-ece4-76e0-3799-58201f8a4ff1@arm.com>
 <CABo9ajArdbYMOBGPRa185yo9MnKRb0pgS-pHqUNdNS9m+kKO-Q@mail.gmail.com>
 <20190111120322.GD4729@zn.tnic>
 <CABo9ajAk5XNBmNHRRfUb-dQzW7-UOs5826jPkrVz-8zrtMUYkg@mail.gmail.com>
 <20190111174532.GI4729@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190111174532.GI4729@zn.tnic>
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
To: Borislav Petkov <bp@alien8.de>, Tyler Baicar <baicar.tyler@gmail.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Boris,

On 11/01/2019 17:45, Borislav Petkov wrote:
> On Fri, Jan 11, 2019 at 10:32:23AM -0500, Tyler Baicar wrote:
>> The kernel would have no way of knowing what to do here.
> 
> What do you mean, there's no way of knowing what to do? It needs to
> clear registers so that the next error can get reported properly.
> 
> Or of the status read failed and it doesn't need to do anything, then it
> shouldn't.

I think we're speaking at cross-purposes. If the error-detecting-hardware has
some state, that's firmware's problem to deal with.
What we're dealing with here is the memory we read the error records from.


> Whatever it is, the kernel either needs to do something in the error
> case to clean up, or nothing if the firmware doesn't need anything done
> in the error case; *or* ack the error in the success case.

We ack it in the corrupt-record case too, because we are done with the memory.


> This should all be written down somewhere in that GHES v2
> spec/doc/writeup whatever, explaining what the OS is supposed to do to
> signal the error has been read by the OS.

I think it is. 18.3.2.8 of ACPI v6.2 (search for Generic Hardware Error Source
version 2", then below the table):
* OSPM detects error (via interrupt/exception or polling the block status)
* OSPM copies the error status block
* OSPM clears the block status field of the error status block
* OSPM acknowledges the error via Read Ack register

The ENOENT case is excluded by 'polling the block status'.
Unsurprisingly the spec doesn't consider the case that firmware generates
corrupt records!


Thanks,

James
