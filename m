From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 00/15] arm64/kvm: use common sysreg definitions
Date: Wed, 15 Mar 2017 10:07:48 +0100
Message-ID: <20170315090748.GK1277@cbox>
References: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
 <87a88tv94d.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B09940A63
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 05:06:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lbF1KE9N71h4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 05:06:26 -0400 (EDT)
Received: from mail-wr0-f173.google.com (mail-wr0-f173.google.com
 [209.85.128.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FA0740190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 05:06:26 -0400 (EDT)
Received: by mail-wr0-f173.google.com with SMTP id u108so6445117wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 02:08:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <87a88tv94d.fsf@on-the-bus.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 10, 2017 at 08:17:22AM +0000, Marc Zyngier wrote:
> On Thu, Mar 09 2017 at  5:07:12 pm GMT, Mark Rutland <mark.rutland@arm.com> wrote:
> > Currently we duplicate effort in maintaining system register encodings across
> > arm64's <asm/sysreg.h>, KVM's sysreg tables, and other places. This redundancy
> > is unfortunate, and as encodings are encoded in-place without any mnemonic,
> > this ends up more painful to read than necessary.
> >
> > This series ameliorates this by making <asm/sysreg.h> the canonical location
> > for (architected) system register encodings, with other users building atop of
> > this, e.g. with KVM deriving its sysreg table values from the common mnemonics.
> >
> > I've only attacked AArch64-native SYS encodings, and ignored CP{15,14}
> > registers for now, but these could be handled similarly. Largely, I've stuck to
> > only what KVM needs, though for the debug and perfmon groups it was easier to
> > take the whole group from the ARM ARM than to filter them to only what KVM
> > needed today.
> >
> > To verify that I haven't accidentally broken KVM, I've diffed sys_regs.o and
> > sys_regs_generic_v8.o on a section-by-section basis before and after the series
> > is applied. The .text, .data, and .rodata sections (and most others) are
> > identical. The __bug_table section, and some .debug* sections differ, and this
> > appears to be due to line numbers changing due to removed lines.
> >
> > One thing I wasn't sure how to address was banks of registers such as
> > PMEVCNTR<n>_EL0. We currently enumerate all cases for our GICv3 definitions,
> > but it seemed painful to expand ~30 cases for PMEVCNTR<n>_EL0 and friends, and
> > for these I've made the macros take an 'n' parameter. It would be nice to be
> > consistent either way, and I'm happy to expand those cases.
> >
> > I've pushed thes series out to a branch [1] based on v4.11-rc1. It looks like
> > git rebase is also happy to apply the patches atop of the kvm-arm-for-4.11-rc2
> > tag.
> 
> I had a quick glance at this series, and this looks like a very good
> piece of work - thanks for doing this.

Agreed.  You can add my acked-by on all the KVM patches if you please.

Thanks,
-Christoffer
