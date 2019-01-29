From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 10/25] ACPI / APEI: Tell firmware the estatus queue
 consumed the records
Date: Tue, 29 Jan 2019 12:49:52 +0100
Message-ID: <20190129114952.GA30613@zn.tnic>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F194A330
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 06:50:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ly582EzvHA-l for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 06:50:06 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61F194A380
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 06:50:06 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <18138b57-51ba-c99c-5b8d-b263fb964714@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <baicar.tyler@gmail.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 23, 2019 at 06:36:38PM +0000, James Morse wrote:
> Do you consider ENOENT an error? We don't ack in that case as the
> memory wasn't in use.

So let's see:

        if (!*buf_paddr)
                return -ENOENT;

can happen when apei_read() has returned 0 but it has managed to do

	*val = 0;

Now, that function returns error values which we should be checking
but we're checking the buf_paddr pointed to value for being 0. Are
we fearing that even if acpi_os_read_memory() or acpi_os_read_port()
succeed, *buf_paddr could still be 0 ?

Because if not, we should be checking whether rc == -EINVAL and then
convert it to -ENOENT.

But ghes_read_estatus() handles the error case first *and* *then* checks
buf_paddr too, to make really really sure we won't be reading from
address 0.

> For the other cases its because the records are bogus, but we still
> unconditionally tell firmware we're done with them.

... to free the memory, yes, ok.

> >> I think it is. 18.3.2.8 of ACPI v6.2 (search for Generic Hardware Error Source
> >> version 2", then below the table):
> >> * OSPM detects error (via interrupt/exception or polling the block status)
> >> * OSPM copies the error status block
> >> * OSPM clears the block status field of the error status block
> >> * OSPM acknowledges the error via Read Ack register
> >>
> >> The ENOENT case is excluded by 'polling the block status'.
> > 
> > Ok, so we signal the absence of an error record with ENOENT.
> > 
> >         if (!buf_paddr)
> >                 return -ENOENT;
> > 
> > Can that even happen?
> 
> Yes, for NOTIFY_POLLED its the norm. For the IRQ flavours that walk a list of
> GHES, all but one of them will return ENOENT.

Lemme get this straight: when we do

	apei_read(&buf_paddr, &g->error_status_address);

in the polled case, buf_paddr can be 0?

> We could try it and see. It depends if firmware shares ack locations between
> multiple GHES. We could ack an empty GHES, and it removes the records of one we
> haven't looked at yet.

Yeah, OTOH, we shouldn't be pushing our luck here, I guess.

So let's sum up: we'll ack the GHES error in all but the -ENOENT cases
in order to free the memory occupied by the error record.

The slightly "pathological" -ENOENT case is I guess how the fw behaves
when it is being polled and also for broken firmware which could report
a 0 buf_paddr.

Btw, that last thing I'm assuming because

  d334a49113a4 ("ACPI, APEI, Generic Hardware Error Source memory error support")

doesn't say what that check was needed for.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
