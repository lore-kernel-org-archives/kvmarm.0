From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: ***SPAM*** KVM on ARM: How to add some functions into interrupt.S
 with C code?
Date: Fri, 10 Jul 2015 14:38:38 +0100
Message-ID: <559FCADE.3030200@arm.com>
References: <5675dfef.1beed.14e77374fec.Coremail.13401187209@126.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9F658519
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 09:27:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x8cFjPO1rqpM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 09:27:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 850225850D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 09:27:04 -0400 (EDT)
In-Reply-To: <5675dfef.1beed.14e77374fec.Coremail.13401187209@126.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: harry <13401187209@126.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Harry,

On 10/07/15 10:06, harry wrote:
> I want to add some functions into interrupt.S with C code to do some
> operations in hyp mode with a hypcall.
> 
> I have tried to add .global [function name] and use bl [function name],
> but there will be a prefetch abort.
> 
> So I want to know if the C code can be linked into interrupt.S and how
> to achieve this.

It is most likely to fail if your C code is not part of the section that
gets mapped in HYP mode. So jumping there gets you an abort because this
area is not covered by any HYP page table.

At the moment, only the code that is between __kvm_hyp_code_start and
__kvm_hyp_code_end is mapped at HYP, and that's fairly restrictive. You
could adopt something similar to what we've done for arm64, where
__kvm_hyp_code_{start,end} are just #defines that resolve as symbols
created in vmlinux.lds.S.

You could then make both interrupt.S and your C code to be part of the
same .hyp.text section, using something an attribute like
__attribute__((__section__(".hyp.text"))). This should ensure that all
the HYP code can get mapped by create_hyp_mapping in one go.

Hope this helps,

	M.
-- 
Jazz is not dead. It just smells funny...
