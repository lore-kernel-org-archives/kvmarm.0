From: Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [PATCH v3 33/41] KVM: arm64: Configure FPSIMD traps on vcpu
 load/put
Date: Wed, 31 Jan 2018 13:24:16 +0100
Message-ID: <582cf940-51b3-1492-f23a-980b99331d00@semihalf.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-34-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-34-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 12.01.2018 13:07, Christoffer Dall wrote:
> There is no need to enable/disable traps to FP registers on every switch
> to/from the VM, because the host kernel does not use this resource
> without calling vcpu_put.  We can therefore move things around enough
> that we still always write FPEXC32_EL2 before programming CPTR_EL2 but
> only program these during vcpu load/put.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>   arch/arm64/include/asm/kvm_hyp.h |  6 +++++
>   arch/arm64/kvm/hyp/switch.c      | 51 +++++++++++++++++++++++++++++-----------
>   arch/arm64/kvm/hyp/sysreg-sr.c   | 12 ++++++++--
>   3 files changed, 53 insertions(+), 16 deletions(-)
> 

[...]

>   
> -static void __hyp_text __deactivate_traps_nvhe(void)
> -{
> +static void __hyp_text __deactivate_traps_nvhe(void) {

Nit: unrelated change.

Thanks,
Tomasz
