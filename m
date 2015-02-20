From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Fri, 20 Feb 2015 15:29:05 +0100
Message-ID: <20150220142905.GA10942@hawk.usersys.redhat.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150219165731.GA26965@hawk.usersys.redhat.com>
 <CAKv+Gu8Je3RRrgEFCZ7JUWtOgk3WqA_qdBEOPAMc3OqnKr1bwg@mail.gmail.com>
 <20150219175518.GB26965@hawk.usersys.redhat.com>
 <54E62404.9040702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 350C04621B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Feb 2015 09:23:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UPpTcfAnUW9v for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Feb 2015 09:23:46 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C503F461CA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Feb 2015 09:23:45 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <54E62404.9040702@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 19, 2015 at 06:57:24PM +0100, Paolo Bonzini wrote:
> 
> 
> On 19/02/2015 18:55, Andrew Jones wrote:
> >> > > (I don't have an exact number for how many times it went to EL1 because
> >> > >  access_mair() doesn't have a trace point.)
> >> > > (I got the 62873 number by testing a 3rd kernel build that only had patch
> >> > >  3/3 applied to the base, and counting kvm_toggle_cache events.)
> >> > > (The number 50 is the number of kvm_toggle_cache events *without* 3/3
> >> > >  applied.)
> >> > >
> >> > > I consider this bad news because, even considering it only goes to EL2,
> >> > > it goes a ton more than it used to. I realize patch 3/3 isn't the final
> >> > > plan for enabling traps though.
> 
> If a full guest boots, can you try timing a kernel compile?
>

Guests boot. I used an 8 vcpu, 14G memory guest; compiled the kernel 4
times inside the guest for each host kernel; base and mair. I dropped
the time from the first run of each set, and captured the other 3.
Command line used below. Time is from the
  Elapsed (wall clock) time (h:mm:ss or m:ss):
output of /usr/bin/time - the host's wall clock.

  /usr/bin/time --verbose ssh $VM 'cd kernel && make -s clean && make -s -j8'

Results:
base: 3:06.11 3:07.00 3:10.93
mair: 3:08.47 3:06.75 3:04.76

So looks like the 3 orders of magnitude greater number of traps
(only to el2) don't impact kernel compiles.

Then I thought I'd be able to quick measure the number of cycles
a trap to el2 takes with this kvm-unit-tests test

int main(void)
{
	unsigned long start, end;
	unsigned int sctlr;

	asm volatile(
	"	mrs %0, sctlr_el1\n"
	"	msr pmcr_el0, %1\n"
	: "=&r" (sctlr) : "r" (5));

	asm volatile(
	"	mrs %0, pmccntr_el0\n"
	"	msr sctlr_el1, %2\n"
	"	mrs %1, pmccntr_el0\n"
	: "=&r" (start), "=&r" (end) : "r" (sctlr));

	printf("%llx\n", end - start);
	return 0;
}

after applying this patch to kvm

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index bb91b6fc63861..5de39d740aa58 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -770,7 +770,7 @@
 
 	mrs	x2, mdcr_el2
 	and	x2, x2, #MDCR_EL2_HPMN_MASK
-	orr	x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
+//	orr	x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
 	orr	x2, x2, #(MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
 
 	// Check for KVM_ARM64_DEBUG_DIRTY, and set debug to trap

But I get zero for the cycle count. Not sure what I'm missing.

drew
