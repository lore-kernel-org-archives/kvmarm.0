From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Advice on HYP interface for AsyncPF
Date: Thu, 9 Apr 2015 08:57:23 +0100
Message-ID: <20150409085723.0a201cb9@why.wild-wind.fr.eu.org>
References: <5525DA0E.2010103@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C75E4BCE2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 03:48:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vrbPtclcY2Ef for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 03:48:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B77F34BCDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 03:48:56 -0400 (EDT)
In-Reply-To: <5525DA0E.2010103@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 9 Apr 2015 02:46:54 +0100
Mario Smarduch <m.smarduch@samsung.com> wrote:

Hi Mario,

> I'm working with AsyncPF, and currently using
> hyp call to communicate guest GFN for host to inject
> virtual abort - page not available/page available.
> 
> Currently only PSCI makes use of that interface,
> (handle_hvc()) can we overload interface with additional
> hyp calls in this case pass guest gfn? Set arg0
> to some range outside of PSCI use.

I can't see a reason why we wouldn't open handle_hvc() to other
paravirtualized services. But this has to be done with extreme caution:

- This becomes an ABI between host and guest
- We need a discovery protocol
- We need to make sure other hypervisors don't reuse the same function
  number for other purposes

Maybe we should adopt Xen's idea of a hypervisor node in DT where we
would describe the various services? How will that work with ACPI?

Coming back to AsyncPF, and purely out of curiosity: why do you need a
HYP entry point? From what I remember, AsyncPF works by injecting a
fault in the guest when the page is found not present or made
available, with the GFN being stored in a per-vcpu memory location.

Am I missing something obvious? Or have I just displayed my ignorance on
this subject? ;-)

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
