Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27AD6C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 15:33:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DE4249F33;
	Thu, 17 Mar 2022 11:33:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8HqviS1moiy4; Thu, 17 Mar 2022 11:33:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 069B349EF6;
	Thu, 17 Mar 2022 11:33:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 203A049F49
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 09:24:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cy71F4mB47n7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 09:24:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA3549F35
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 09:24:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C303B1515;
 Thu, 17 Mar 2022 06:24:48 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD8113F766;
 Thu, 17 Mar 2022 06:24:42 -0700 (PDT)
Message-ID: <0d9d605e-4f92-3947-f99d-91faf9dbc2d7@arm.com>
Date: Thu, 17 Mar 2022 13:24:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/6] Partially revert "KVM: Pass kvm_init()'s opaque
 param to additional arch funcs"
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>, seanjc@google.com, maz@kernel.org,
 kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
 tglx@linutronix.de
References: <20220216031528.92558-1-chao.gao@intel.com>
 <20220216031528.92558-3-chao.gao@intel.com>
From: Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20220216031528.92558-3-chao.gao@intel.com>
X-Mailman-Approved-At: Thu, 17 Mar 2022 11:33:14 -0400
Cc: x86@kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Borislav Petkov <bp@alien8.de>, Atish Patra <atishp@atishpatra.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Bharata B Rao <bharata@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 kvm-riscv@lists.infradead.org, Michael Ellerman <mpe@ellerman.id.au>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 16/02/2022 03:15, Chao Gao wrote:
> This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaque
> param to additional arch funcs") remove opaque from
> kvm_arch_check_processor_compat because no one uses this opaque now.
> Address conflicts for ARM (due to file movement) and manually handle RISC-V
> which comes after the commit.
> 
> And changes about kvm_arch_hardware_setup() in original commit are still
> needed so they are not reverted.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kvm/arm.c       |  2 +-
>   arch/mips/kvm/mips.c       |  2 +-
>   arch/powerpc/kvm/powerpc.c |  2 +-
>   arch/riscv/kvm/main.c      |  2 +-
>   arch/s390/kvm/kvm-s390.c   |  2 +-
>   arch/x86/kvm/x86.c         |  2 +-
>   include/linux/kvm_host.h   |  2 +-
>   virt/kvm/kvm_main.c        | 16 +++-------------
>   8 files changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ecc5958e27fe..0165cf3aac3a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -73,7 +73,7 @@ int kvm_arch_hardware_setup(void *opaque)
>   	return 0;
>   }
>   
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>   {
>   	return 0;
>   }

For arm64 :

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
