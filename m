From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/2] arm/arm64: KVM: fix two build failured under
 STRICT_MM_TYPECHECKS
Date: Wed, 01 Jul 2015 11:56:34 +0100
Message-ID: <5593C762.1050309@arm.com>
References: <1435680290-13945-1-git-send-email-ard.biesheuvel@linaro.org>
 <1435680290-13945-2-git-send-email-ard.biesheuvel@linaro.org>
 <20150630170315.GL7445@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4512557417
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2015 06:45:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rszAKnTQMFNp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jul 2015 06:45:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A6E57415
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2015 06:45:23 -0400 (EDT)
In-Reply-To: <20150630170315.GL7445@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/06/15 18:03, Catalin Marinas wrote:
> On Tue, Jun 30, 2015 at 06:04:50PM +0200, Ard Biesheuvel wrote:
>> This fixes two instances where a pgprot_t is used as the operand
>> of a bitwise & operation. In order to comply with STRICT_MM_TYPECHECKS,
>> bitwise arithmetic on a pgprot_t should go via the pgprot_val()
>> accessor.
>>
>> Cc: kvmarm@lists.cs.columbia.edu
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> (I guess it will go via the kvm tree)

Yes, I'll queue it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
