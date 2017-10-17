From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 06/10] KVM: arm/arm64: Only clean the dcache on
 translation fault
Date: Tue, 17 Oct 2017 10:34:15 +0100
Message-ID: <210cf2dc-2566-a29b-637e-901f3dcc80b6@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-7-marc.zyngier@arm.com> <20171016200811.GH1845@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CFFE49D4A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 05:33:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X+JCC-Smz0qh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 05:33:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D26D549D48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 05:33:21 -0400 (EDT)
In-Reply-To: <20171016200811.GH1845@lvm>
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
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/10/17 21:08, Christoffer Dall wrote:
> On Mon, Oct 09, 2017 at 04:20:28PM +0100, Marc Zyngier wrote:
>> The only case where we actually need to perform a dache maintenance
>> is when we map the page for the first time, and subsequent permission
>> faults do not require cache maintenance. Let's make it conditional
>> on not being a permission fault (and thus a translation fault).
> 
> Why do we actually need to do any dcache maintenance when faulting in a
> page?
> 
> Is this for the case when the stage 1 MMU is disabled, or to support
> guest mappings using uncached attributes?

These are indeed the two cases that require cleaning the dcache to PoC.

> Can we do better, for example
> by only flushing the cache if the guest MMU is disabled?

The guest MMU being disabled is easy. But the uncached mapping is much
trickier, and would involve parsing the guest page tables. Not something
I'm really eager to implement.

> 
> Beyond that:
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Thanks!

	M.
-- 
Jazz is not dead. It just smells funny...
