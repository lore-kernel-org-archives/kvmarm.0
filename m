From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 00/12] arm64: Paravirtualized time support
Date: Mon, 3 Dec 2018 14:36:05 +0000
Message-ID: <e6ce401e-7c7a-484d-9aa0-b7149c802e03@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
 <20181203132552.5exdbzda6dfud2d2@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E8474A2BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 09:36:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LL9gQUaWkOMH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 09:36:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04CDE4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 09:36:08 -0500 (EST)
In-Reply-To: <20181203132552.5exdbzda6dfud2d2@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Steven Price <steven.price@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/2018 13:25, Andrew Jones wrote:
> On Wed, Nov 28, 2018 at 02:45:15PM +0000, Steven Price wrote:

[...]

>> It implements support for Live Physical Time (LPT) which provides the
>> guest with a method to derive a stable counter of time during which the
>> guest is executing even when the guest is being migrated between hosts
>> with different physical counter frequencies.
> 
> Intel has TSC scaling. Is there any reason Arm is proposing a PV
> solution instead of adding a similar virt extension?

Even if we were to add such an extension tomorrow, we need something
that works for today's system. Not to mention that "tomorrow in the
architecture" usually translates as "in silicon in 3 years"...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
