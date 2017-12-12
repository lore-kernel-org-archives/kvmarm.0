From: Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH 05/12] arm64: mm: Remove VMALLOC checks from
 update_mapping_prot(.)
Date: Tue, 12 Dec 2017 15:39:23 +0000
Message-ID: <20171212153923.a7z6kcowxj7thljy@capper-debian.cambridge.arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
 <20171204141313.31604-6-steve.capper@arm.com>
 <CAKv+Gu80J1vGn6V6Z3eXajDos=sjY_fLhUQP=-n0A8MyunTfgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1AF449D2B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 10:36:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NE55aYPyDgSE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Dec 2017 10:36:07 -0500 (EST)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on0047.outbound.protection.outlook.com [104.47.0.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EBB040D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 10:36:07 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu80J1vGn6V6Z3eXajDos=sjY_fLhUQP=-n0A8MyunTfgQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, takahiro.akashi@linaro.org, nd@arm.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Ard,

On Mon, Dec 04, 2017 at 04:01:09PM +0000, Ard Biesheuvel wrote:
> On 4 December 2017 at 14:13, Steve Capper <steve.capper@arm.com> wrote:
> > update_mapping_prot assumes that it will be used on the VA for the
> > kernel .text section. (Via the check virt >= VMALLOC_START)
> >
> > Recent kdump patches employ this function to modify the protection of
> > the direct linear mapping (which is strictly speaking outside of this
> > area), via mark_linear_text_alias_ro(.).
> >
> 
> Isn't that a bug? Is it guaranteed that those protection attributes
> can be modified without splitting live page tables, and the resulting
> risk of TLB conflicts?

IIUC there is a bug in my earlier patch to flip the kernel VA space round,
it should allow addresses from the linear mapping to be processed by
update_mapping_prot. I'll update the logic in VA flip patch, so this
patch can be removed from the series.

It is not apparent to me how mark_linear_text_alias_ro(.) guarantees
that no page table entries for the linear map are split, though.

Cheers,
-- 
Steve
