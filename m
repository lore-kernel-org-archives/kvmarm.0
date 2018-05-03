From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Thu, 3 May 2018 17:24:24 +0100
Message-ID: <6667183c-6a89-f6c8-e630-efa2faf5b003@arm.com>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
 <20171218191037.wjocr7jbf5ua2duj@hawk.localdomain>
 <20171220170030.zvz3oounirnlhcfi@hawk.localdomain>
 <61a11d00-cc9c-bc17-eec0-0296085026e7@cavium.com>
 <0ee505ca-9022-0ec9-6008-9e49fb723d88@arm.com>
 <ff987fdf-4394-4058-9246-32d5be858290@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 776C7402B8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 May 2018 12:15:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6O1NP3o1H41H for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 May 2018 12:14:41 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E84040192
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 May 2018 12:14:41 -0400 (EDT)
In-Reply-To: <ff987fdf-4394-4058-9246-32d5be858290@cavium.com>
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
To: "Kalra, Ashish" <Ashish.Kalra@cavium.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: pbonzini@redhat.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/05/18 12:12, Kalra, Ashish wrote:
> 
>>>
>>> The reason for the problem you're seeing is probably that the
>>> constraints are not quite right. Here, x0 is not simply clobbered, but
>>> is actively written to in the middle of the sequence (it is at least an
>>> early clobber). It is also, I assume, a result from the hypercall, so it
>>> cannot simply be discarded.
>>>
>>> It would help to get a disassembly of the function, but I'd tend to
>>> rewrite the code as such:
>>>
>>> extern int bar(void);
>>>
>>> int foo(void)
>>> {
>>> 	register int w0 asm("w0");
>>> 	int a, b;
>>>
>>> 	a = bar();
>>> 	w0 = 0x4b000000;
>>> 	asm volatile("hvc #0" : "+r" (w0) :: );
>>> 	b = bar();
>>>
>>> 	return a - b;
>>> }
> 
> There still is the issue of x1-x3 registers being used for local 
> variables and clobbering of the same across the "hvc" call.
> 
> Comparatively, the fix below works more reliably :
> 
> asm volatile("hvc #0" : "+r" (w0) :: "x1","x2","x3");

Is that because this hypercall is explicitly clobbering these registers?
or because KVM is corrupting them? If the former, fine. If the latter,
that'd be a KVM bug.

So which one is it?

	M.
-- 
Jazz is not dead. It just smells funny...
