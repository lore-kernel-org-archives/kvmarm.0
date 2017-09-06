From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: save and restore some PSTATE bits
Date: Wed, 6 Sep 2017 09:17:41 +0100
Message-ID: <2a5d4299-2523-aef5-7db1-f351ca66b562@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F2015DF717@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 987AA49C24
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 04:15:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Svcmw3gtT-Mv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Sep 2017 04:15:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4644B40A86
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 04:15:20 -0400 (EDT)
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2015DF717@DGGEMA503-MBX.china.huawei.com>
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
To: gengdongjiu <gengdongjiu@huawei.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "vladimir.murzin@arm.com" <vladimir.murzin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/09/17 19:58, gengdongjiu wrote:
> when exit from guest, some host PSTATE bits may be lost, such as
> PSTATE.PAN or PSTATE.UAO. It is because host and hypervisor all run
> in the EL2, host PSTATE value cannot be saved and restored via
> SPSR_EL2. So if guest has changed the PSTATE, host continues with
> a wrong value guest has set.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Haibin Zhang <zhanghaibin7@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  8 +++++++
>  arch/arm64/include/asm/kvm_hyp.h  |  2 ++
>  arch/arm64/include/asm/sysreg.h   | 23 +++++++++++++++++++
>  arch/arm64/kvm/hyp/entry.S        |  2 --
>  arch/arm64/kvm/hyp/switch.c       | 24 ++++++++++++++++++--
>  arch/arm64/kvm/hyp/sysreg-sr.c    | 48 ++++++++++++++++++++++++++++++++++++---
>  6 files changed, 100 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e923b58..cba7d3e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -193,6 +193,12 @@ struct kvm_cpu_context {
>  	};
>  };
>  
> +struct kvm_cpu_host_pstate {
> +	u64 daif;
> +	u64 uao;
> +	u64 pan;
> +};

I love it. This is the most expensive way of saving/restoring a single
32bit value.

More seriously, please see the discussion between James and Christoffer
there[1]. I expect James to address the PAN/UAO states together with the
debug state in the next iteration of his patch.

Thanks,

	M.

[1] https://www.spinics.net/lists/arm-kernel/msg599798.html
-- 
Jazz is not dead. It just smells funny...
