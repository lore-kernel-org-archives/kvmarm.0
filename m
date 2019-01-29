From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 10/25] ACPI / APEI: Tell firmware the estatus queue
 consumed the records
Date: Tue, 29 Jan 2019 18:48:40 +0000
Message-ID: <1530de77-3f9d-f214-216e-42eec7d757b7@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-11-james.morse@arm.com>
 <20181211183634.GO27375@zn.tnic>
 <56cfa16b-ece4-76e0-3799-58201f8a4ff1@arm.com>
 <CABo9ajArdbYMOBGPRa185yo9MnKRb0pgS-pHqUNdNS9m+kKO-Q@mail.gmail.com>
 <20190111120322.GD4729@zn.tnic>
 <CABo9ajAk5XNBmNHRRfUb-dQzW7-UOs5826jPkrVz-8zrtMUYkg@mail.gmail.com>
 <0939c14d-de58-f21d-57a6-89bdce3bcb44@arm.com>
 <CABo9ajB9TAkycLbe++yyDibXx33MntNV_Hy27JSXCVsvP6rf7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADE844A39C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:48:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r3neObiOCGAr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:48:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DB4849E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:48:53 -0500 (EST)
In-Reply-To: <CABo9ajB9TAkycLbe++yyDibXx33MntNV_Hy27JSXCVsvP6rf7g@mail.gmail.com>
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
To: Tyler Baicar <baicar.tyler@gmail.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Tyler,

On 11/01/2019 20:53, Tyler Baicar wrote:
> On Fri, Jan 11, 2019 at 1:09 PM James Morse <james.morse@arm.com> wrote:
>> We can return on ENOENT out earlier, as nothing needs doing in that case. Its
>> what the GHES_TO_CLEAR spaghetti is for, we can probably move the ack thing into
>> ghes_clear_estatus(), that way that thing means 'I'm done with this memory'.
>>
>> Something like:
>> -------------------------
>> rc = ghes_read_estatus();
>> if (rc == -ENOENT)
>>         return 0;
> 
> We still should be returning at least the -ENOENT from ghes_read_estatus().
> That is being used by the SEA handling to determine if an SEA was properly
> reported/handled by the host kernel in the KVM SEA case.

Sorry, my terrible example code. You'll be glad to know I would have caught this
when testing it!


Thanks,

James
