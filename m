From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 00/18] APEI in_nmi() rework
Date: Tue, 25 Sep 2018 14:45:26 +0200
Message-ID: <20180925124526.GD23986@zn.tnic>
References: <20180921221705.6478-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B56D24A1F2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Sep 2018 08:45:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w5DImp8ZooPb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Sep 2018 08:45:25 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8252C49F93
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Sep 2018 08:45:25 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180921221705.6478-1-james.morse@arm.com>
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
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 21, 2018 at 11:16:47PM +0100, James Morse wrote:
> Hello,
> 
> The GHES driver has collected quite a few bugs:
> 
> ghes_proc() at ghes_probe() time can be interrupted by an NMI that
> will clobber the ghes->estatus fields, flags, and the buffer_paddr.
> 
> ghes_copy_tofrom_phys() uses in_nmi() to decide which path to take. arm64's
> SEA taking both paths, depending on what it interrupted.
> 
> There is no guarantee that queued memory_failure() errors will be processed
> before this CPU returns to user-space.
> 
> x86 can't TLBI from interrupt-masked code which this driver does all the
> time.
> 
> 
> This series aims to fix the first three, with an eye to fixing the
> last one with a follow-up series.
> 
> Previous postings included the SDEI notification calls, which I haven't
> finished re-testing. This series is big enough as it is.

Yeah, and everywhere I look, this thing looks overengineered. Like,
for example, what's the purpose of this ghes_esource_prealloc_size()
computing a size each time the pool changes size?

AFAICT, this size can be computed exactly *once* at driver init and be
done with it. Right?

Or am I missing something subtle?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
