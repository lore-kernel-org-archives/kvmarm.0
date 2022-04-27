Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380AAC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 10:22:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FCAD4B1B6;
	Wed, 27 Apr 2022 06:22:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oCczUMQSCZkh; Wed, 27 Apr 2022 06:21:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 623CB4B1D8;
	Wed, 27 Apr 2022 06:21:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C08C4B1B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 06:21:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 11GArXineKn4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 06:21:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E86664B15E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 06:21:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F42B143D;
 Wed, 27 Apr 2022 03:21:56 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40A703F774;
 Wed, 27 Apr 2022 03:21:55 -0700 (PDT)
Date: Wed, 27 Apr 2022 11:21:52 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] KVM/arm64: Print emulated register table name when
 it is unsorted
Message-ID: <YmkZQE1dUR2ajMeJ@monolith.localdoman>
References: <20220425163904.859195-1-alexandru.elisei@arm.com>
 <20220425163904.859195-3-alexandru.elisei@arm.com>
 <871qxja6ho.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <871qxja6ho.wl-maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi,

On Tue, Apr 26, 2022 at 10:18:27PM +0100, Marc Zyngier wrote:
> On Mon, 25 Apr 2022 17:39:03 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > When a sysreg table entry is out-of-order, KVM attempts to print the
> > address of the table:
> > 
> > [    0.143881] kvm [1]: sys_reg table (____ptrval____) out of order (0)
> > 
> > Printing the name of the table instead of a pointer is more helpful in this
> > case:
> > 
> > [    0.143881] kvm [1]: sys_reg table sys_reg_descs out of order (0)
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 57302048afd0..7b62a2daf056 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2188,18 +2188,18 @@ static const struct sys_reg_desc cp15_64_regs[] = {
> >  };
> >  
> >  static bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
> > -			       bool is_32)
> > +			       const char *table_name, bool is_32)
> >  {
> >  	unsigned int i;
> >  
> >  	for (i = 0; i < n; i++) {
> >  		if (!is_32 && table[i].reg && !table[i].reset) {
> > -			kvm_err("sys_reg table %p entry %d lacks reset\n", table, i);
> > +			kvm_err("sys_reg table %s entry %d lacks reset\n", table_name, i);
> 
> Instead of passing a table name, could we simply use something like
> %pS? If this works, it would be a good indication of both what table
> and what entry in that table is at fault.

With the change:

-                       kvm_err("sys_reg table %s out of order (%d)\n", table_name, i - 1);
+                       kvm_err("sys_reg table %pS out of order (%d)\n", &table[i - 1], i - 1);


this is what KVM prints with %pS if the second entry is out-of-order:

[    0.143698] kvm [1]: sys_reg table sys_reg_descs+0x50/0x7490 out of order (1)

There's redundant information now, the entry can be calculated from the
table offset, but printing the offset directly is certainly convenient.

I like it more than passing the table name, if you agree I'll send a v2
with this change.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
