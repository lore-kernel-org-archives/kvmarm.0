From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 05/13] arm64: Unconditionally enable IESB on exception
 entry/return for firmware-first
Date: Tue, 16 Jan 2018 09:55:20 +0000
Message-ID: <c9ab8b4f-090e-d575-b220-178f512d0efb@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-6-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EA1349DED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:50:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Z-M5qEAbQYZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 04:50:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 408B349DE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:50:23 -0500 (EST)
In-Reply-To: <20180115193906.30053-6-james.morse@arm.com>
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
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/18 19:38, James Morse wrote:
> ARM v8.2 has a feature to add implicit error synchronization barriers
> whenever the CPU enters or returns from an exception level. Add this to the
> features we always enable. CPUs that don't support this feature will treat
> the bit as RES0.
> 
> This feature causes RAS errors that are not yet visible to software to
> become pending SErrors. We expect to have firmware-first RAS support
> so synchronised RAS errors will be take immediately to EL3.
> Any system without firmware-first handling of errors will take the SError
> either immediatly after exception return, or when we unmask SError after
> entry.S's work.
> 
> Adding IESB to the ELx flags causes it to be enabled by KVM and kexec
> too.
> 
> Platform level RAS support may require additional firmware support.
> 
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Suggested-by: Will Deacon <will.deacon@arm.com>
> Link: https://www.spinics.net/lists/kvm-arm/msg28192.html
> Signed-off-by: James Morse <james.morse@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
