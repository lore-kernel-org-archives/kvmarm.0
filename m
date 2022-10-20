Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813F0C43217
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 19:08:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0F4B4BA03;
	Thu, 20 Oct 2022 15:08:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2tGgjP7I--gP; Thu, 20 Oct 2022 15:08:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7733B4B9B5;
	Thu, 20 Oct 2022 15:08:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8660D4B95D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 15:08:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6sTkaeqZz5rL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 15:08:03 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39E894B94A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 15:08:03 -0400 (EDT)
Date: Thu, 20 Oct 2022 22:08:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666292882;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PiZzGkBrb0Pmhrx3lF3phKX07wonyvh6N79EhbYQ9YM=;
 b=mF2OxDQ1HxBVIawk2bmNq8Bm7iyc/MhjIb9HEX0EF4BkyC/oX0pEyxm0sUL411qg96fZBl
 vvYl9XnLSkacPHNqFcFZCrBHaC0854Il3yhS7XfUy7F00lguUY9JyO0xv63crUfhlv8oYV
 BG9d4KxfLL7QmpHGT2e+ZZ5tDNqTFdE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 1/9] KVM: arm64: selftests: Use FIELD_GET() to extract
 ID register fields
Message-ID: <Y1GckDU/gCNQ6tAS@google.com>
References: <20221020054202.2119018-1-reijiw@google.com>
 <20221020054202.2119018-2-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221020054202.2119018-2-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Oct 19, 2022 at 10:41:54PM -0700, Reiji Watanabe wrote:
> Use FIELD_GET() macro to extract ID register fields for existing
> aarch64 selftests code. No functional change intended.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c  | 3 ++-
>  tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 3 ++-
>  tools/testing/selftests/kvm/lib/aarch64/processor.c    | 7 ++++---
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> index 6f9c1f19c7f6..b6a5e8861b35 100644
> --- a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> @@ -13,6 +13,7 @@
>  #include "kvm_util.h"
>  #include "processor.h"
>  #include "test_util.h"
> +#include <linux/bitfield.h>
>  
>  #define BAD_ID_REG_VAL	0x1badc0deul
>  
> @@ -145,7 +146,7 @@ static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
>  
>  	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
>  
> -	el0 = (val & ARM64_FEATURE_MASK(ID_AA64PFR0_EL0)) >> ID_AA64PFR0_EL0_SHIFT;
> +	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0), val);
>  	return el0 == ID_AA64PFR0_ELx_64BIT_ONLY;
>  }
>  
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 947bd201435c..3808d3d75055 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -2,6 +2,7 @@
>  #include <test_util.h>
>  #include <kvm_util.h>
>  #include <processor.h>
> +#include <linux/bitfield.h>
>  
>  #define MDSCR_KDE	(1 << 13)
>  #define MDSCR_MDE	(1 << 15)
> @@ -284,7 +285,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
>  	uint64_t id_aa64dfr0;
>  
>  	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
> -	return id_aa64dfr0 & 0xf;
> +	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
>  }
>  
>  static void test_guest_debug_exceptions(void)
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 6f5551368944..7c96b931edd5 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -11,6 +11,7 @@
>  #include "guest_modes.h"
>  #include "kvm_util.h"
>  #include "processor.h"
> +#include <linux/bitfield.h>
>  
>  #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
>  
> @@ -486,9 +487,9 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
>  	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
>  	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
>  
> -	*ps4k = ((val >> 28) & 0xf) != 0xf;
> -	*ps64k = ((val >> 24) & 0xf) == 0;
> -	*ps16k = ((val >> 20) & 0xf) != 0;
> +	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4), val) != 0xf;
> +	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64), val) == 0;
> +	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16), val) != 0;

Not your code, but since we're here...

Should we change the field values to use the #define's? Also, the test
for TGRAN64 looks wrong. We should test != ID_AA64MMFR0_TGRAN64_NI. A
value greater than 0 would indicate an extension of the feature.

But for this exact change:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
