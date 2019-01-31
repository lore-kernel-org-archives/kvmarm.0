From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 10/25] ACPI / APEI: Tell firmware the estatus queue
 consumed the records
Date: Thu, 31 Jan 2019 14:29:58 +0100
Message-ID: <20190131132958.GJ6749@zn.tnic>
References: <56cfa16b-ece4-76e0-3799-58201f8a4ff1@arm.com>
 <CABo9ajArdbYMOBGPRa185yo9MnKRb0pgS-pHqUNdNS9m+kKO-Q@mail.gmail.com>
 <20190111120322.GD4729@zn.tnic>
 <CABo9ajAk5XNBmNHRRfUb-dQzW7-UOs5826jPkrVz-8zrtMUYkg@mail.gmail.com>
 <20190111174532.GI4729@zn.tnic>
 <32025682-f85a-58ef-7386-7ee23296b944@arm.com>
 <20190111195800.GA11723@zn.tnic>
 <18138b57-51ba-c99c-5b8d-b263fb964714@arm.com>
 <20190129114952.GA30613@zn.tnic>
 <c17156e4-278b-7544-367e-50e928407a03@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <c17156e4-278b-7544-367e-50e928407a03@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, Xie XiuQi <xiexiuqi@huawei.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <baicar.tyler@gmail.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 29, 2019 at 06:48:33PM +0000, James Morse wrote:
> If firmware has never generated CPER records, so it has never written to void
> *error_status_address, yes.

I guess this is the bit of information I was missing.

> There seem to be two ways of doing this. This zero check implies an example
> system could be:
> | g->error_status_address == 0xf00d
> | *(u64 *)0xf00d == 0
> Firmware populates CPER records, then updates 0xf00d.
> (0xf00d would have been pre-mapped by apei_map_generic_address() in ghes_new())
> Reads of 0xf00d before CPER records are generated get 0.

Ok, this sounds like the polled case. FW better have a record ready
before raising the NMI.

> Once an error occurs, this system now looks like this:
> | g->error_status_address == 0xf00d
> | *(u64 *)0xf00d == 0xbeef
> | *(u64 *)0xbeef == 0
> 
> For new errors, firmware populates CPER records, then updates 0xf00d.
> Alternatively firmware could re-use the memory at 0xbeef, generating the CPER
> records backwards, so that once 0xbeef is updated, the rest of the record is
> visible. (firmware knows not to race with another CPU right?)

Thanks for the comic relief. :-P

> Firmware could equally point 0xf00d at 0xbeef at startup, so it has one fewer
> values to write when an error occurs. I have an arm64 system with a HEST that
> does this. (I'm pretty sure its ACPI support is a copy-and-paste from x86, it
> even describes NOTIFY_NMI, who knows what that means on arm!)

Oh the fun.

> When linux processes an error, ghes_clear_estatus() NULLs the
> estatus->block_status, (which in this example is at 0xbeef). This is the
> documented sequence for GHESv2.
> Elsewhere the spec talks of checking the block status which is part of the
> records, (not the error_status_address, which is the pointer to the records).
>
> Linux can't NULL 0xf00d, because it doesn't know if firmware will write it again
> next time it updates the records.
> I can't find where in the spec it says the error status address is written to.
> Linux works with both 'at boot' and 'on each error'.
> If it were know to have a static value, ghes_copy_tofrom_phys() would not have
> been necessary, but its been there since d334a49113a4.
>
> In the worst case, if there is a value at the error_status_address, we have to
> map/unmap it every time we poll in case firmware wrote new records at that same
> location.
> 
> I don't think we can change Linux's behaviour here, without interpreting zero as
> CPER records or missing new errors.

Nah, I was simply trying to figure out why we do that buf_paddr check.
Thanks for the extensive clarification.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
