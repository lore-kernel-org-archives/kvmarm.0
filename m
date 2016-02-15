From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 23/23] arm64: Panic when VHE and non VHE CPUs coexist
Date: Mon, 15 Feb 2016 18:14:25 +0000
Message-ID: <56C21581.5030003@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
 <1455216004-19499-24-git-send-email-marc.zyngier@arm.com>
 <20160215172653.GM6298@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F418749731
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Feb 2016 13:08:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ORR8B+uPuwmI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Feb 2016 13:08:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86E8E49695
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Feb 2016 13:08:17 -0500 (EST)
In-Reply-To: <20160215172653.GM6298@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/02/16 17:26, Will Deacon wrote:
> On Thu, Feb 11, 2016 at 06:40:04PM +0000, Marc Zyngier wrote:
>> Having both VHE and non-VHE capable CPUs in the same system
>> is likely to be a recipe for disaster.
>>
>> If the boot CPU has VHE, but a secondary is not, we won't be
>> able to downgrade and run the kernel at EL1. Add CPU hotplug
>> to the mix, and this produces a terrifying mess.
>>
>> Let's solve the problem once and for all. If you mix VHE and
>> non-VHE CPUs in the same system, you deserve to loose, and this
>> patch makes sure you don't get a chance.
>>
>> This is implemented by storing the kernel execution level in
>> a global variable. Secondaries will park themselves in a
>> WFI loop if they observe a mismatch. Also, the primary CPU
>> will detect that the secondary CPU has died on a mismatched
>> execution level. Panic will follow.
> 
> This should really be based on Suzuki's series for handling generic
> mismatches:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-January/401727.html
> 
> To avoid growing a dependency on something that's unlikely to make it
> for 4.6, I'd be inclined to drop your homegrown checks altogether amd
> help Suzuki with his series as a separate activity (i.e. it needn't be
> a blocker imo).

That's fine, I'll drop that one - we can revisit it and fold it into
Suzuki's series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
