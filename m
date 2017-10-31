From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 13/21] arm64: cpufeature: Enable IESB on exception
 entry/return for firmware-first
Date: Tue, 31 Oct 2017 13:56:16 +0000
Message-ID: <20171031135616.GM5584@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-14-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7246349D14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 09:54:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i8wQkJQ2VBwB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 09:54:38 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F50440651
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 09:54:38 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171019145807.23251-14-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 19, 2017 at 03:57:59PM +0100, James Morse wrote:
> ARM v8.2 has a feature to add implicit error synchronization barriers
> whenever the CPU enters or returns from an exception level. Add code to
> detect this feature and enable the SCTLR_ELx.IESB bit.
> 
> This feature causes RAS errors that are not yet visible to software to
> become pending SErrors. We expect to have firmware-first RAS support
> so synchronised RAS errors will be take immediately to EL3.
> Any system without firmware-first handling of errors will take the SError
> either immediatly after exception return, or when we unmask SError after
> entry.S's work.
> 
> Platform level RAS support may require additional firmware support.
> 
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

To be honest, I'd just set this bit unconditionally. I realise the
architecture would rather we didn't do that for v8 parts where it's RES0,
but we do this elsewhere (e.g. HD and HA in the TCR) and practically it's
fine.

Will
