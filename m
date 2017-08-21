From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 4/7] support user space to query RAS extension feature
Date: Mon, 21 Aug 2017 23:08:24 +0200
Message-ID: <20170821210824.GC20436@cbox>
References: <1503065517-7920-1-git-send-email-gengdongjiu@huawei.com>
 <1503065517-7920-5-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6932849C26
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Aug 2017 17:06:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D1FC-dU01nfo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Aug 2017 17:06:40 -0400 (EDT)
Received: from mail-wr0-f176.google.com (mail-wr0-f176.google.com
 [209.85.128.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0544149C19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Aug 2017 17:06:39 -0400 (EDT)
Received: by mail-wr0-f176.google.com with SMTP id p14so40494967wrg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Aug 2017 14:08:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1503065517-7920-5-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: wangkefeng.wang@huawei.com, kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, tbaicar@codeaurora.org, will.deacon@arm.com, linuxarm@huawei.com, robert.moore@intel.com, lv.zheng@intel.com, zjzhang@codeaurora.org, mingo@kernel.org, stefan@hello-penguin.com, mst@redhat.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, huangshaoyu@huawei.com, huangdaode@hisilicon.com, bp@suse.de, Dave.Martin@arm.com, lenb@kernel.org, wuquanming@huawei.com, marc.zyngier@arm.com, john.garry@huawei.com, kristina.martsenko@arm.com, cov@codeaurora.org, jonathan.cameron@huawei.com, zhengqiang10@huawei.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com, shiju.jose@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 18, 2017 at 10:11:54PM +0800, Dongjiu Geng wrote:

You should put KVM and arm64 in the subject here.

> In armv8.2 RAS extension, it adds virtual SError exception
> syndrome registeri(VSESR_EL2), user space will specify that
> value. so user space will check whether CPU feature has RAS
> extension. if has, it will specify the virtual SError syndrome
> value. Otherwise, it will not set. This patch adds this support
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  arch/arm64/kvm/reset.c   | 3 +++
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 3256b9228e75..b7313ee028e9 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_PMU_V3:
>  		r = kvm_arm_support_pmu_v3();
>  		break;
> +	case KVM_CAP_ARM_RAS_EXTENSION:
> +		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
> +		break;
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  		r = 1;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6cd63c18708a..5a2a338cae57 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -929,6 +929,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_SMT_POSSIBLE 147
>  #define KVM_CAP_HYPERV_SYNIC2 148
>  #define KVM_CAP_HYPERV_VP_INDEX 149
> +#define KVM_CAP_ARM_RAS_EXTENSION 150
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.14.0
> 

Thanks,
-Christoffer
