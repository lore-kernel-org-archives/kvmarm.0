From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Wed, 2 May 2018 10:23:01 +0100
Message-ID: <0ee505ca-9022-0ec9-6008-9e49fb723d88@arm.com>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
 <20171218191037.wjocr7jbf5ua2duj@hawk.localdomain>
 <20171220170030.zvz3oounirnlhcfi@hawk.localdomain>
 <61a11d00-cc9c-bc17-eec0-0296085026e7@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DC4F49D6B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 May 2018 05:13:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D9dTsU23rwCe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 May 2018 05:13:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9731F4029E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 May 2018 05:13:21 -0400 (EDT)
In-Reply-To: <61a11d00-cc9c-bc17-eec0-0296085026e7@cavium.com>
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
Cc: christoffer.dall@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/05/18 15:57, Kalra, Ashish wrote:
> Hello Shih-Wei,
> 
> This exception is probably due to a bug in the hvc_test (hvc call) code,
> and there is a generic bug in the hvc test code.
> In the function hvc_test(), local variables c1, c2 get mapped to 
> registers (typically x1 & x2) and those are "clobbered" across the hvc 
> call, hence, c1 gets clobbered and we get a large cycle count for 
> hvc_test (c2 - 0), which messes-up the hvc test measurements.
> 
> As per SMC64/HVC64 ABI definitions, x0-x18 can be clobbered across
> HVC/SMC calls.

I have two issues with this statement:

- Version 1.1 of the SMCCC actually says that only x0-x3 will be
potentially clobbered

- KVM makes a point in not clobbering any register, except for those
functions implemented by SMCCC 1.1.

That being said...

> 
> Currently, i am using your micro-benchmark code with the following
> hack applied ...
> 
> +register unsigned long c1_hvc asm ("x19"); 
>  
> 
> static unsigned long hvc_test(void) 
>  
> 
> {
> +     unsigned long c2;
> -     unsigned long c1, c2;
>  
>  
>  
>  
>  
> 
> +     c1_hvc = read_cc();
> -     c1 = read_cc();
>       asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0"); 
>  
> 
>       c2 = read_cc();

The reason for the problem you're seeing is probably that the
constraints are not quite right. Here, x0 is not simply clobbered, but
is actively written to in the middle of the sequence (it is at least an
early clobber). It is also, I assume, a result from the hypercall, so it
cannot simply be discarded.

It would help to get a disassembly of the function, but I'd tend to
rewrite the code as such:

extern int bar(void);

int foo(void)
{
	register int w0 asm("w0");
	int a, b;

	a = bar();
	w0 = 0x4b000000;
	asm volatile("hvc #0" : "+r" (w0) :: );
	b = bar();

	return a - b;
}

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
