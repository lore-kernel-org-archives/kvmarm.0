Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A9AC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 16:52:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD4386522C
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 16:52:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD4386522C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1993B4B6AC;
	Mon,  8 Mar 2021 11:52:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JCyBo3gKoZE4; Mon,  8 Mar 2021 11:52:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77C414B6AF;
	Mon,  8 Mar 2021 11:52:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D58D54B6A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 11:52:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J9tx05+UYDM1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 11:52:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF034B690
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 11:52:51 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25D24D6E;
 Mon,  8 Mar 2021 08:52:50 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A83C93F71B;
 Mon,  8 Mar 2021 08:52:48 -0800 (PST)
Subject: Re: [PATCH] KVM: arm64: Ensure I-cache isolation between vcpus of a
 same VM
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20210303164505.68492-1-maz@kernel.org>
 <20210305190708.GL23855@arm.com> <877dmksgaw.wl-maz@kernel.org>
 <20210306141546.GB2932@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <db428d01-594c-edc3-8d4f-75061d22c3ef@arm.com>
Date: Mon, 8 Mar 2021 16:53:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210306141546.GB2932@arm.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

Hello,

It's not clear to me why this patch is needed. If one VCPU in the VM is generating
code, is it not the software running in the VM responsible for keeping track of
the MMU state of the other VCPUs and making sure the new code is executed
correctly? Why should KVM get involved?

I don't see how this is different than running on bare metal (no hypervisor), and
one CPU with the MMU on generates code that another CPU with the MMU off must execute.

Some comments below.

On 3/6/21 2:15 PM, Catalin Marinas wrote:
> On Sat, Mar 06, 2021 at 10:54:47AM +0000, Marc Zyngier wrote:
>> On Fri, 05 Mar 2021 19:07:09 +0000,
>> Catalin Marinas <catalin.marinas@arm.com> wrote:
>>> On Wed, Mar 03, 2021 at 04:45:05PM +0000, Marc Zyngier wrote:
>>>> It recently became apparent that the ARMv8 architecture has interesting
>>>> rules regarding attributes being used when fetching instructions
>>>> if the MMU is off at Stage-1.
>>>>
>>>> In this situation, the CPU is allowed to fetch from the PoC and
>>>> allocate into the I-cache (unless the memory is mapped with
>>>> the XN attribute at Stage-2).
>>> Digging through the ARM ARM is hard. Do we have this behaviour with FWB
>>> as well?
>> The ARM ARM doesn't seem to mention FWB at all when it comes to
>> instruction fetch, which is sort of expected as it only covers the
>> D-side. I *think* we could sidestep this when CTR_EL0.DIC is set
>> though, as the I-side would then snoop the D-side.
> Not sure this helps. CTR_EL0.DIC refers to the need for maintenance to
> PoU while the SCTLR_EL1.M == 0 causes the I-cache to fetch from PoC. I
> don't think I-cache snooping the D-cache would happen to the PoU when
> the S1 MMU is off.

FEAT_FWB requires that CLIDR_EL1.{LoUIS, LoUU} = {0, 0} which means that no dcache
clean is required for instruction to data coherence (page D13-3086). I interpret
that as saying that with FEAT_FWB, CTR_EL0.IDC is effectively 1, which means that
dcache clean is not required for instruction generation, and icache invalidation
is required only if CTR_EL0.DIC = 0 (according to B2-158).

> My reading of D4.4.4 is that when SCTLR_EL1.M == 0 both I and D accesses
> are Normal Non-cacheable with a note in D4.4.6 that Non-cacheable
> accesses may be held in the I-cache.

Nitpicking, but SCTLR_EL1.M == 0 and SCTLR_EL1.I == 1 means that instruction
fetches are to Normal Cacheable, Inner and Outer Read-Allocate memory (ARM DDI
0487G.a, pages D5-2709 and indirectly at D13-3586).

Like you've pointed out, as mentioned in D4.4.6, it is always possible that
instruction fetches are held in the instruction cache, regardless of the state of
the SCTLR_EL1.M bit.

> The FWB rules on combining S1 and S2 says that Normal Non-cacheable at
> S1 is "upgraded" to cacheable. This should happen irrespective of
> whether the S1 MMU is on or off and should apply to both I and D
> accesses (since it does not explicitly says). So I think we could skip
> this IC IALLU when FWB is present.
>
> The same logic should apply when the VMM copies the VM text. With FWB,
> we probably only need D-cache maintenance to PoU and only if
> CTR_EL0.IDC==0. I haven't checked what the code currently does.

When FEAT_FWB, CTR_EL0.IDC is effectively 1 (see above), so we don't need a dcache
clean in this case.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
