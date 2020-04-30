Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DE3C83001
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 08:29:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F71121973
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 08:29:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhXeMJ0o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F71121973
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5AD54B502;
	Thu, 30 Apr 2020 04:29:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wEeEbegp3C44; Thu, 30 Apr 2020 04:29:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90FAF4B50D;
	Thu, 30 Apr 2020 04:29:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 630AE4B502
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 04:29:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fUnECYXdiGUW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 04:29:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4394A4B4F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 04:29:38 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E058E20838;
 Thu, 30 Apr 2020 08:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588235377;
 bh=onr2ezsqhSwSBf7Quz0lL5N9zMZKFWEXv6ZeY7ZIb9M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=mhXeMJ0oWGKxPahGSs7koYRzrkGLBxK5K/sKeQboCc/b2p8n6cwbTf9Sr+GZ+pIk4
 rRFVN73kuf10XTpXGBpLiLU72SuPb6wk4Vyk5xKIbm3q+QpEFT1iFr1dKbuKvsXP1y
 peJMk6/zFG8MHlDUDNC8wuM3+aZvQ2rUXtsSN08g=
Date: Thu, 30 Apr 2020 09:29:28 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] arm64: kvm: fix gcc-10 shift warning
Message-ID: <20200430082927.GA18615@willie-the-truck>
References: <20200429185657.4085975-1-arnd@arndb.de>
 <20200430090251.715f6bf0@why>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200430090251.715f6bf0@why>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Rich Felker <dalias@libc.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Paul Mackerras <paulus@samba.org>, kvmarm@lists.cs.columbia.edu,
 Jonas Bonn <jonas@southpole.se>, Stephen Rothwell <sfr@canb.auug.org.au>,
 Brian Cain <bcain@codeaurora.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Russell King <linux@armlinux.org.uk>, Ley Foon Tan <ley.foon.tan@intel.com>,
 Mike Rapoport <rppt@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Fenghua Yu <fenghua.yu@intel.com>, Arnd Bergmann <arnd@arndb.de>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>, Guan Xuetao <gxt@pku.edu.cn>,
 linux-arm-kernel@lists.infradead.org,
 Christophe Leroy <christophe.leroy@c-s.fr>, Tony Luck <tony.luck@intel.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Apr 30, 2020 at 09:02:51AM +0100, Marc Zyngier wrote:
> On Wed, 29 Apr 2020 20:56:20 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > gcc-10 warns that the 32-bit zero cannot be shifted more than
> > 32 bits to the right:
> > 
> > arch/arm64/kvm/../../../virt/kvm/arm/mmu.c: In function 'clear_hyp_p4d_entry':
> > arch/arm64/include/asm/pgtable.h:630:35: error: right shift count >= width of type [-Werror=shift-count-overflow]
> >   630 | #define pud_index(addr)  (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
> >       |                                   ^~
> > arch/arm64/include/asm/memory.h:271:45: note: in definition of macro '__phys_to_virt'
> >   271 | #define __phys_to_virt(x) ((unsigned long)((x) - physvirt_offset))
> >       |                                             ^
> > arch/arm64/include/asm/pgtable.h:633:42: note: in expansion of macro '__va'
> >   633 | #define pud_offset(dir, addr)  ((pud_t *)__va(pud_offset_phys((dir), (addr))))
> >       |                                          ^~~~
> > arch/arm64/include/asm/pgtable.h:632:73: note: in expansion of macro 'pud_index'
> >   632 | #define pud_offset_phys(dir, addr) (p4d_page_paddr(READ_ONCE(*(dir))) + pud_index(addr) * sizeof(pud_t))
> >       |                                                                         ^~~~~~~~~
> > arch/arm64/include/asm/pgtable.h:633:47: note: in expansion of macro 'pud_offset_phys'
> >   633 | #define pud_offset(dir, addr)  ((pud_t *)__va(pud_offset_phys((dir), (addr))))
> >       |                                               ^~~~~~~~~~~~~~~
> > arch/arm64/kvm/../../../virt/kvm/arm/mmu.c:510:36: note: in expansion of macro 'pud_offset'
> >   510 |  pud_t *pud_table __maybe_unused = pud_offset(p4d, 0);
> >       |                                    ^~~~~~~~~~
> > 
> > This is harmless, and the warning is a little bit silly for
> > a zero constant, but it's trivial to fix by making it an
> > unsigned long, so do that.
> > 
> > Fixes: 22998131ab33 ("arm64: add support for folded p4d page tables")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  virt/kvm/arm/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> > index 48d4288c5f1b..534d9798c3cb 100644
> > --- a/virt/kvm/arm/mmu.c
> > +++ b/virt/kvm/arm/mmu.c
> > @@ -507,7 +507,7 @@ static void clear_hyp_pgd_entry(pgd_t *pgd)
> >  
> >  static void clear_hyp_p4d_entry(p4d_t *p4d)
> >  {
> > -	pud_t *pud_table __maybe_unused = pud_offset(p4d, 0);
> > +	pud_t *pud_table __maybe_unused = pud_offset(p4d, 0UL);
> >  	VM_BUG_ON(p4d_huge(*p4d));
> >  	p4d_clear(p4d);
> >  	pud_free(NULL, pud_table);
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

Happy to queue via arm64 for 5.8. Does that work for you, Arnd, or were you
planning to get this in sooner than that?

Cheers,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
