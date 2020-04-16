Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F68C2BB85
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 09:16:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8DC1220644
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 09:16:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DC1220644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E73EC4B20F;
	Thu, 16 Apr 2020 05:16:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y7pYfpZIKRD1; Thu, 16 Apr 2020 05:16:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91F804B235;
	Thu, 16 Apr 2020 05:16:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E4E04B21E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 05:16:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FDP7rWLOIqiD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 05:16:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A81094B20F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 05:16:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F5B4C14;
 Thu, 16 Apr 2020 02:16:53 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AAF993F73D;
 Thu, 16 Apr 2020 02:16:51 -0700 (PDT)
Date: Thu, 16 Apr 2020 10:16:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH RFCv1 0/7] Support Async Page Fault
Message-ID: <20200416091621.GA4987@lakrids.cambridge.arm.com>
References: <20200410085820.758686-1-gshan@redhat.com>
 <d2882e806ad2f9793437160093c8d3fa@kernel.org>
 <6a1d7e8b-da10-409f-16d0-354004566a1a@redhat.com>
 <20200414110554.GB2486@C02TD0UTHF1T.local>
 <5bc62c4f-e19d-82f2-072e-dfa4498dccf3@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5bc62c4f-e19d-82f2-072e-dfa4498dccf3@redhat.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: Marc Zyngier <maz@kernel.org>, sudeep.holla@arm.com, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Apr 16, 2020 at 05:59:33PM +1000, Gavin Shan wrote:
> On 4/14/20 9:05 PM, Mark Rutland wrote:
> > On Tue, Apr 14, 2020 at 03:39:56PM +1000, Gavin Shan wrote:
> > > On 4/10/20 10:52 PM, Marc Zyngier wrote:
> > > > On 2020-04-10 09:58, Gavin Shan wrote:
> > > > > In order to fulfil the control flow and convey signals between host
> > > > > and guest. A IMPDEF system register (SYS_ASYNC_PF_EL1) is introduced.
> > > > > The register accepts control block's physical address, plus requested
> > > > > features. Also, the signal is sent using data abort with the specific
> > > > > IMPDEF Data Fault Status Code (DFSC). The specific signal is stored
> > > > > in the control block by host, to be consumed by guest.
> > 
> > > > - We don't add IMPDEF sysregs, period. That's reserved for the HW. If
> > > >     you want to trap, there's the HVC instruction to that effect.
> > 
> > > I really don't understand how IMPDEF sysreg is used by hardware vendors.
> > > Do we have an existing functionality, which depends on IMPDEF sysreg?
> > > I was thinking the IMPDEF sysreg can be used by software either, but
> > > it seems I'm wrong.
> > 
> > The key is in the name: an IMPLEMENTATION DEFINED register is defined by
> > the implementation (i.e. the specific CPU microarchitecture), so it's
> > wrong for software to come up with an arbitrary semantic as this will
> > differ from the implementation's defined semantic for the register.
> > 
> > Typically, IMP DEF resgisters are used for things that firmware needs to
> > do (e.g. enter/exit coherency), or for bringup-time debug (e.g. poking
> > into TLB/cache internals), and are not usually intended for general
> > purpose software.
> > 
> > Linux generally avoids the use of IMP DEF registers, but does so in some
> > cases (e.g. for PMUs) after FW explicitly describes that those are safe
> > to access.
> 
> Thanks for the explanation and details, which make things much clear. Since
> the IMPDEF system register can't be used like this way, hypercall (HVC) would
> be considered to serve same purpose - deliver signals from host to guest.

I'm not sure I follow how you'd use HVC to inject a signal into a guest;
the HVC would have to be issued by the guest to the host. Unless you're
injecting the signal via some other mechanism (e.g. an interrupt), and
the guest issues the HVC in response to that?

> However, the hypercall number and behaviors are guarded by
> specification. For example, the hypercalls used by para-virtualized
> stolen time, which are defined in include/linux/arm-smccc.h, are
> specified by ARM DEN0057A [1]. So I need a specification to be
> created, where the hypercalls used by this feature are defined? If
> it's not needed, can I pick hypercalls that aren't used and define
> their behaviors by myself?
> 
> [1] http://infocenter.arm.com/help/topic/com.arm.doc.den0057a/DEN0057A_Paravirtualized_Time_for_Arm_based_Systems_v1_0.pdf

Take a look at the SMCCC / SMC Calling Convention:

 https://developer.arm.com/docs/den0028/c

... that defines ranges set aside for hypervisor-specific usage, and
despite its name it also applies to HVC calls.

There's been intermittent work to add a probing story for that, so that
part is subject to change, but for prototyping you can just choose an
arbitray number in that range -- just be suere to mention in the commit
and cover letter that this part isn't complete.

> Another thing I want to check is about the ESR_EL1[DFSC]. In this series,
> the asynchronous page fault is identified by IMPDEF DFSC (Data Fault Status
> Code) in ESR_EL1. According to what we discussed, the IMPDEF DFSC shouldn't
> be fired (produced) by software. It should be produced by hardware either?
> What I understood is IMPDEF is hardware behavior. If this is true, I need
> to avoid using IMPDEF DFSC in next revision :)

Yes, similar applies here.

If the guest is making a hypercall, you can return the fault info as the
response in GPRs, so I don't think you need to touch any architectural
fault registers.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
