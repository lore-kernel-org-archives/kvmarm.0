Return-Path: <SRS0=Pfd/=4Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB5EC10F00
	for <kvmarm@archiver.kernel.org>; Sat,  7 Mar 2020 12:40:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7ED3E206D7
	for <kvmarm@archiver.kernel.org>; Sat,  7 Mar 2020 12:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGgOZOJ3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7ED3E206D7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4B7A4A7E4;
	Sat,  7 Mar 2020 07:40:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H6CzBVE4-QRL; Sat,  7 Mar 2020 07:40:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C43D64A7F0;
	Sat,  7 Mar 2020 07:40:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDD854A982
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2020 23:00:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oYpzDGJsJ5nX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2020 23:00:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B25264A95B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2020 23:00:19 -0500 (EST)
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net
 [73.231.172.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2B2EA206D5;
 Sat,  7 Mar 2020 04:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1583553618;
 bh=oV9dzypff0UA0jPadqQOWi55OmuNhXb+CU9VyawDDys=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=SGgOZOJ38TBhL5PMq2t97iVlOYiTJrLFrJZwUFY+PkmX4j8DweXDMSJ8amOibPULY
 dukXRc++p/7grHQAkoJmRzC/WSXOXanM1qDKv14ejj7flbmiHB/27z6x/csQKB/k1O
 jFq+DE3IugyBsaFEvfl6ba2s2SLpEYfJdkqCDacY=
Date: Fri, 6 Mar 2020 20:00:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v3 07/14] powerpc/32: drop get_pteptr()
Message-Id: <20200306200016.6f3865ada0daa68b645fe5d7@linux-foundation.org>
In-Reply-To: <20200227084608.18223-8-rppt@kernel.org>
References: <20200227084608.18223-1-rppt@kernel.org>
 <20200227084608.18223-8-rppt@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
X-Mailman-Approved-At: Sat, 07 Mar 2020 07:40:23 -0500
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org,
 Geert Uytterhoeven <geert+renesas@glider.be>, linux-sh@vger.kernel.org,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
 Paul Mackerras <paulus@samba.org>, linux-hexagon@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Jonas Bonn <jonas@southpole.se>, linux-arch@vger.kernel.org,
 Brian Cain <bcain@codeaurora.org>, Marc Zyngier <maz@kernel.org>,
 Russell King <linux@armlinux.org.uk>, Ley Foon Tan <ley.foon.tan@intel.com>,
 Mike Rapoport <rppt@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 uclinux-h8-devel@lists.sourceforge.jp, Fenghua Yu <fenghua.yu@intel.com>,
 Arnd Bergmann <arnd@arndb.de>, kvm-ppc@vger.kernel.org,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 openrisc@lists.librecores.org, Stafford Horne <shorne@gmail.com>,
 Guan Xuetao <gxt@pku.edu.cn>, linux-arm-kernel@lists.infradead.org,
 Christophe Leroy <christophe.leroy@c-s.fr>, Tony Luck <tony.luck@intel.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, nios2-dev@lists.rocketboards.org,
 linuxppc-dev@lists.ozlabs.org
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

On Thu, 27 Feb 2020 10:46:01 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> Commit 8d30c14cab30 ("powerpc/mm: Rework I$/D$ coherency (v3)") and
> commit 90ac19a8b21b ("[POWERPC] Abolish iopa(), mm_ptov(),
> io_block_mapping() from arch/powerpc") removed the use of get_pteptr()
> outside of mm/pgtable_32.c
> 
> In mm/pgtable_32.c, the only user of get_pteptr() is __change_page_attr()
> which operates on kernel context and on lowmem pages only.
> 
> Move page table traversal to __change_page_attr() and drop get_pteptr().

People have been changing things in linux-next and the powerpc patches
are hurting.

I'll disable this patch series for now.  Can you please redo
powerpc-32-drop-get_pteptr.patch and
powerpc-add-support-for-folded-p4d-page-tables.patch (and
powerpc-add-support-for-folded-p4d-page-tables-fix.patch)?

Thanks.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
