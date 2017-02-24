From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 00/13] arm64/kvm: use common sysreg definitions
Date: Fri, 24 Feb 2017 11:16:50 +0100
Message-ID: <20170224101650.GE1409@cbox>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 390A440D4C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:16:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A+yyj5THHXt0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Feb 2017 05:16:03 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5F7F40D56
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:16:03 -0500 (EST)
Received: by mail-wm0-f54.google.com with SMTP id t18so7787659wmt.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 02:17:05 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On Tue, Jan 31, 2017 at 06:05:38PM +0000, Mark Rutland wrote:
> Whenever we add new functionality involving new system registers, we need to
> add sys_reg() definitions so that we can access the registers regardless of
> whether the toolchain can assemble them. At the same time, we have to add
> duplicate definitions of the register encodings to KVM's sysreg tables, so that
> we can handle any configurable traps. This redundancy is unfortunate, and
> defining the encodings directly in the sysreg tables can make those tables
> difficult to read.
> 
> This series attempts to address both of these issues by allowing us to use
> common sys_reg() mnemonics in <asm/sysreg.h> to initialise KVM's sysreg tables.
> To that end, this series tries to make <asm/sysreg.h> the canonical location
> for common sysreg encodings.
> 
> Largely, I've only attacked the AArch64-native SYS encodings required by KVM
> today, though for the debug and perfmon groups it was easier to take the whole
> group from the ARM ARM than to filter them to only what KVM needed. I've
> ignored CP{15,14} registers for now, but these could be encoded similarly.
> 
> To verify that I haven't accidentally broken KVM, I've diffed sys_regs.o and
> sys_regs_generic_v8.o on a section-by-section basis before and after the series
> is applied. The .text, .data, and .rodata sections (and most others) are
> identical. The __bug_table section, and some .debug* sections differ, and this
> appears to be due to line numbers changing due to removed lines.
> 
> One thing I wasn't sure how to address was banks of registers such as
> PMEVCNTR<n>_EL0. We currently enumerate all cases for our GICv3 definitions,
> but it seemed painful to expand ~30 cases for PMEVCNTR<n>_EL0 and friends, and
> for these I've made the macros take an 'n' parameter.
> 
> The series is based on the arm64/for-next/core branch, since it relies on
> commit c9ee0f98662a6e35 ("arm64: cpufeature: Define helpers for sys_reg id")
> for the definition of SYS_DESC().
> 

I did not do a full in-depth review, but I really like this overall
change and the changes to KVM look great to me.

Thanks for doing this!
-Christoffer
