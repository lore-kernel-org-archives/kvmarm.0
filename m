From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 00/17] kvm-arm: Add stage2 page table walker
Date: Thu, 14 Apr 2016 17:10:16 +0100
Message-ID: <570FC0E8.9030204@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
 <570F9B32.9090106@arm.com> <20160414160348.GQ30804@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C49349BC5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 12:08:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3a9HP4xh2OYv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 12:08:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D395949BC4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 12:08:36 -0400 (EDT)
In-Reply-To: <20160414160348.GQ30804@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 14/04/16 17:03, Christoffer Dall wrote:
> On Thu, Apr 14, 2016 at 02:29:22PM +0100, Suzuki K Poulose wrote:
>> On 14/04/16 14:20, Suzuki K Poulose wrote:
>>> This series adds support for stage2 page table helpers and makes
>>> the core kvm-arm MMU code make use of it. At the moment we assume
>>> that the host/hyp and the stage2 page tables have same number of
>>> levels and hence use the host level accessors (except for some
>>> hooks, e.g kvm_p.d_addr_end) and shares the routines for unmapping
>>> the page table ranges.
>>
>>> The tree is available at :
>>>       git://linux-arm.org/linux-skp.git kvm-stage2/v2
>>
>> Please note that the tree above contains one additional patch on top of kvmarm/master :
>> commit	91ad0db16a42a7d3("arm64/sunxi: 4.6-rc1: Add dependency on generic irq chip"),
>> which is there to fix a build break with ARCH_SUNXI selected on 4.6-rc1.
>>
> ok, but I can just build/test this without ARCH_SUNXI and pick the
> remains of this series only for kvmarm/next, as far as I can tell,
> right?

Yup.

> Marc, seems like you're happy with this series as well?

Very. I'm still going through the last patches, but so far it looks great.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
