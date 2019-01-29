From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 10/25] ACPI / APEI: Tell firmware the estatus queue
 consumed the records
Date: Tue, 29 Jan 2019 18:48:33 +0000
Message-ID: <c17156e4-278b-7544-367e-50e928407a03@arm.com>
References: <20181203180613.228133-11-james.morse@arm.com>
 <20181211183634.GO27375@zn.tnic>
 <56cfa16b-ece4-76e0-3799-58201f8a4ff1@arm.com>
 <CABo9ajArdbYMOBGPRa185yo9MnKRb0pgS-pHqUNdNS9m+kKO-Q@mail.gmail.com>
 <20190111120322.GD4729@zn.tnic>
 <CABo9ajAk5XNBmNHRRfUb-dQzW7-UOs5826jPkrVz-8zrtMUYkg@mail.gmail.com>
 <20190111174532.GI4729@zn.tnic>
 <32025682-f85a-58ef-7386-7ee23296b944@arm.com>
 <20190111195800.GA11723@zn.tnic>
 <18138b57-51ba-c99c-5b8d-b263fb964714@arm.com>
 <20190129114952.GA30613@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14ED749E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:48:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jX4AC8+Q48dv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:48:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DBA54A399
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:48:53 -0500 (EST)
In-Reply-To: <20190129114952.GA30613@zn.tnic>
Content-Language: en-GB
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <baicar.tyler@gmail.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Boris,

On 29/01/2019 11:49, Borislav Petkov wrote:
> On Wed, Jan 23, 2019 at 06:36:38PM +0000, James Morse wrote:
>> Do you consider ENOENT an error? We don't ack in that case as the
>> memory wasn't in use.
> 
> So let's see:
> 
>         if (!*buf_paddr)
>                 return -ENOENT;
> 
> can happen when apei_read() has returned 0 but it has managed to do
> 
> 	*val = 0;

> Now, that function returns error values which we should be checking
> but we're checking the buf_paddr pointed to value for being 0. Are
> we fearing that even if acpi_os_read_memory() or acpi_os_read_port()
> succeed, *buf_paddr could still be 0 ?

That's what this code is doing, checking for a successful read, of zero.
The g->error_status_address has to point somewhere as its location is advertised
in the tables.

What is the value of g->error_status_address 'out of reset' or before any error
has occurred? This code expects it to be zero, or to point to a CPER block with
an empty block_status.

(the acpi spec is unclear on when *(g->error_status_address) is written)


> Because if not, we should be checking whether rc == -EINVAL and then
> convert it to -ENOENT.

EINVAL implies the reg->space_id wasn't one of the two "System IO or System
Memory". (I thought the spec required this, but it only says this for EINJ:
'This constraint is an attempt to ensure that the registers are accessible in
the presence of hardware error conditions'.)

apei_check_gar() checks for these two in apei_map_generic_address(), so if this
is the case we would have failed at ghes_new() time.


> But ghes_read_estatus() handles the error case first *and* *then* checks
> buf_paddr too, to make really really sure we won't be reading from
> address 0.

I think this is the distinction between 'failed to read', (because
g->error_status_address has bad alignment or an unsupported address-space
id/access-size), and successfully read 0, which is treated as ENOENT.


>> For the other cases its because the records are bogus, but we still
>> unconditionally tell firmware we're done with them.
> 
> ... to free the memory, yes, ok.
> 
>>>> I think it is. 18.3.2.8 of ACPI v6.2 (search for Generic Hardware Error Source
>>>> version 2", then below the table):
>>>> * OSPM detects error (via interrupt/exception or polling the block status)
>>>> * OSPM copies the error status block
>>>> * OSPM clears the block status field of the error status block
>>>> * OSPM acknowledges the error via Read Ack register
>>>>
>>>> The ENOENT case is excluded by 'polling the block status'.
>>>
>>> Ok, so we signal the absence of an error record with ENOENT.
>>>
>>>         if (!buf_paddr)
>>>                 return -ENOENT;
>>>
>>> Can that even happen?
>>
>> Yes, for NOTIFY_POLLED its the norm. For the IRQ flavours that walk a list of
>> GHES, all but one of them will return ENOENT.


> Lemme get this straight: when we do
> 
> 	apei_read(&buf_paddr, &g->error_status_address);
> 
> in the polled case, buf_paddr can be 0?

If firmware has never generated CPER records, so it has never written to void
*error_status_address, yes.

There seem to be two ways of doing this. This zero check implies an example
system could be:
| g->error_status_address == 0xf00d
| *(u64 *)0xf00d == 0
Firmware populates CPER records, then updates 0xf00d.
(0xf00d would have been pre-mapped by apei_map_generic_address() in ghes_new())
Reads of 0xf00d before CPER records are generated get 0.

Once an error occurs, this system now looks like this:
| g->error_status_address == 0xf00d
| *(u64 *)0xf00d == 0xbeef
| *(u64 *)0xbeef == 0

For new errors, firmware populates CPER records, then updates 0xf00d.
Alternatively firmware could re-use the memory at 0xbeef, generating the CPER
records backwards, so that once 0xbeef is updated, the rest of the record is
visible. (firmware knows not to race with another CPU right?)

Firmware could equally point 0xf00d at 0xbeef at startup, so it has one fewer
values to write when an error occurs. I have an arm64 system with a HEST that
does this. (I'm pretty sure its ACPI support is a copy-and-paste from x86, it
even describes NOTIFY_NMI, who knows what that means on arm!)

When linux processes an error, ghes_clear_estatus() NULLs the
estatus->block_status, (which in this example is at 0xbeef). This is the
documented sequence for GHESv2.
Elsewhere the spec talks of checking the block status which is part of the
records, (not the error_status_address, which is the pointer to the records).

Linux can't NULL 0xf00d, because it doesn't know if firmware will write it again
next time it updates the records.
I can't find where in the spec it says the error status address is written to.
Linux works with both 'at boot' and 'on each error'.
If it were know to have a static value, ghes_copy_tofrom_phys() would not have
been necessary, but its been there since d334a49113a4.

In the worst case, if there is a value at the error_status_address, we have to
map/unmap it every time we poll in case firmware wrote new records at that same
location.

I don't think we can change Linux's behaviour here, without interpreting zero as
CPER records or missing new errors.


>> We could try it and see. It depends if firmware shares ack locations between
>> multiple GHES. We could ack an empty GHES, and it removes the records of one we
>> haven't looked at yet.
> 
> Yeah, OTOH, we shouldn't be pushing our luck here, I guess.
> 
> So let's sum up: we'll ack the GHES error in all but the -ENOENT cases
> in order to free the memory occupied by the error record.

I agree.


> The slightly "pathological" -ENOENT case is I guess how the fw behaves
> when it is being polled and also for broken firmware which could report
> a 0 buf_paddr.
> 
> Btw, that last thing I'm assuming because
> 
>   d334a49113a4 ("ACPI, APEI, Generic Hardware Error Source memory error support")
> 
> doesn't say what that check was needed for.

Heh. I'd assume this was the out-of-reset value on the platform that was
developed for, which implicitly assumed we could never get CPER records at zero.


Thanks,

James
