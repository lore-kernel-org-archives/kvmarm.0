Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D11F1E526
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713861434; cv=none; b=comxAFMBZBH1u09ixRsY/+wmRAIOlm05KmmWNw9sCDrf9tULRD/mVxrLbMaOT5PoA2fAHEi2IQO1RzpXSAa4S0KWUK4j2rBT/We8wjjOsYidy7c49ws306dybaqBBNRxPeHnffRRcMJiSpbft/nxluckYrqQB/30qTgd6Epp6o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713861434; c=relaxed/simple;
	bh=7oeQQuf3noBO7CIh+mHesHr4kh/RlAFbjneTpiehjl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYDFdUxDkWsKGrjlA22awIrAm9D8y4XNgYr9G0QuUNuKKyYA8OPedM2MjBDF0/95lNOMdlCT6R968kdb8aLQoZbUQ4lFfqr7SndXv6PLqybZeuCimkvQ5ME+LgzleTC4m4iTHI/apzd/Ku/gglOq1KE+iSK9UgJxFY47ccp9d5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF947339;
	Tue, 23 Apr 2024 01:37:39 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.21.210])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB9CA3F64C;
	Tue, 23 Apr 2024 01:37:09 -0700 (PDT)
Date: Tue, 23 Apr 2024 09:37:04 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>, Will Deacon <will@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linaro Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH] KVM: arm64: nv: Work around lack of pauth support in old
 toolchains
Message-ID: <ZidzMO-tcsFUgL1r@FVFF77S0Q05N>
References: <20240422224849.2238222-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240422224849.2238222-1-maz@kernel.org>

On Mon, Apr 22, 2024 at 11:48:49PM +0100, Marc Zyngier wrote:
> We still support GCC 8.x, and it appears that this toolchain
> does not understand "pauth" as a valid architectural extension.
> After all, it's only been 8 years since ARMv8.3 was released...
> 
> This results in the NV ERETAx code breaking the build, as it relies
> on this extention to make use of the PACGA instruction.
> 
> Work around it by hand-assembling the instruction using a mind-bending
> trick lifted from an old patch by Will. Magic.
> 
> Fixes: e09faab353a6 ("KVM: arm64: nv: Add emulation for ERETAx instructions")
> Reported-by: Linaro Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pauth.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
> index a3a5c404375b..8baf2a2cbdd3 100644
> --- a/arch/arm64/kvm/pauth.c
> +++ b/arch/arm64/kvm/pauth.c
> @@ -17,6 +17,22 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/pointer_auth.h>
>  
> +/*
> + * "// This is some of my finest work" (Will Deacon, 2019-02-12)
> + *
> + * The jury is still out on that one.
> + */
> +#define REG(r)	"(0%x[" #r "] - ((0%x[" #r "] >> 4) * 6))"
> +
> +/* PACGA Xd, Xn, Xm */
> +#define PACGA(d,n,m)						\
> +	asm volatile(".inst 0x9AC03000   |"			\
> +		     "(" REG(Rd) "<< 0)  |"			\
> +		     "(" REG(Rn) "<< 5)  |"			\
> +		     "(" REG(Rm) "<< 16)\n"			\
> +		     : [Rd] "=r" ((d))				\
> +		     : [Rn] "r" ((n)), [Rm] "r" ((m)))

Can you please use <asm/gpr-num.h> rather than open-coding this new REG()
helper? That way this'll be consistent with the way we assemble MRS/MSR in
<asm/sysreg.h>, and it avoids the few seconds of confusion trying to figure out
the maths in the REG() helper (neat trick though!).

Fixlet for that below; I've build tested this and the resulting object file is
the same before and after (diff shows that only the name of the file changed):

| [mark@lakrids:~/src/linux]% usekorg 13.2.0 aarch64-linux-objdump -d pauth-maz.o | grep pacga
|  204:   9ac03335        pacga   x21, x25, x0
| [mark@lakrids:~/src/linux]% usekorg 13.2.0 aarch64-linux-objdump -d pauth-rutland.o | grep pacga
|  204:   9ac03335        pacga   x21, x25, x0
| [mark@lakrids:~/src/linux]% diff <(usekorg 13.2.0 aarch64-linux-objdump -d pauth-maz.o) <(usekorg 13.2.0 aarch64-linux-objdump -d pauth-rutland.o)
| 2c2
| < pauth-maz.o:     file format elf64-littleaarch64
| ---
| > pauth-rutland.o:     file format elf64-littleaarch64

If you'd prefer I can send this as a patch.

Otherwise, this looks good to me; thanks for the fix!

Mark.

---->8----
diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
index 8baf2a2cbdd32..e518baf570c86 100644
--- a/arch/arm64/kvm/pauth.c
+++ b/arch/arm64/kvm/pauth.c
@@ -14,24 +14,20 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/gpr-num.h>
 #include <asm/kvm_emulate.h>
 #include <asm/pointer_auth.h>
 
-/*
- * "// This is some of my finest work" (Will Deacon, 2019-02-12)
- *
- * The jury is still out on that one.
- */
-#define REG(r)	"(0%x[" #r "] - ((0%x[" #r "] >> 4) * 6))"
-
 /* PACGA Xd, Xn, Xm */
-#define PACGA(d,n,m)						\
-	asm volatile(".inst 0x9AC03000   |"			\
-		     "(" REG(Rd) "<< 0)  |"			\
-		     "(" REG(Rn) "<< 5)  |"			\
-		     "(" REG(Rm) "<< 16)\n"			\
-		     : [Rd] "=r" ((d))				\
-		     : [Rn] "r" ((n)), [Rm] "r" ((m)))
+#define PACGA(d,n,m)				\
+	asm volatile(				\
+	__DEFINE_ASM_GPR_NUMS			\
+	"	.inst 0x9AC03000          |"	\
+	"	(.L__gpr_num_%[Rd] << 0)  |"	\
+	"	(.L__gpr_num_%[Rn] << 5)  |"	\
+	"	(.L__gpr_num_%[Rm] << 16)\n"	\
+	: [Rd] "=r" ((d))			\
+	: [Rn] "r" ((n)), [Rm] "r" ((m)))
 
 static u64 compute_pac(struct kvm_vcpu *vcpu, u64 ptr,
 		       struct ptrauth_key ikey)
