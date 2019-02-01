From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Forbid kprobing of the VHE
 world-switch code
Date: Fri, 1 Feb 2019 13:34:11 +0000
Message-ID: <e0b2aac7-f5b0-52c7-b4de-2c31c9b9d19d@arm.com>
References: <20190124163257.233929-1-james.morse@arm.com>
 <20190124163257.233929-2-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56E7F4A32D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 08:34:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V3V3oP1eedQL for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 08:34:17 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A10D4A320
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 08:34:17 -0500 (EST)
In-Reply-To: <20190124163257.233929-2-james.morse@arm.com>
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
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 24/01/2019 16:32, James Morse wrote:
> On systems with VHE the kernel and KVM's world-switch code run at the
> same exception level. Code that is only used on a VHE system does not
> need to be annotated as __hyp_text as it can reside anywhere in the
> kernel text.
> 
> __hyp_text was also used to prevent kprobes from patching breakpoint
> instructions into this region, as this code runs at a different
> exception level. While this is no longer true with VHE, KVM still
> switches VBAR_EL1, meaning a kprobe's breakpoint executed in the
> world-switch code will cause a hyp-panic.

[...]

For what it is worth, I've now queued this patch as a fix for 5.0.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
