From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v11 4/6] target-arm: kvm64: detect guest RAS EXTENSION
 feature
Date: Wed, 6 Sep 2017 17:35:33 +0800
Message-ID: <5e3c8d25-6260-d00e-dda3-d160a9973701@huawei.com>
References: <1503066227-18251-1-git-send-email-gengdongjiu@huawei.com>
 <1503066227-18251-5-git-send-email-gengdongjiu@huawei.com>
 <CAFEAcA9oecuzXXrdo3zZHxF3AgrDUh_NHxz-znto4GU+OoxVFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA9oecuzXXrdo3zZHxF3AgrDUh_NHxz-znto4GU+OoxVFw@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Shannon Zhao <zhaoshenglong@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, "edk2-devel@lists.01.org" <edk2-devel@lists.01.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,
  Thanks very much for your review, I will check your comments in detail and reply.


On 2017/9/6 1:26, Peter Maydell wrote:
> On 18 August 2017 at 15:23, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>> check if kvm supports guest RAS EXTENSION. if so, set
>> corresponding feature bit for vcpu.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> ---
>>  linux-headers/linux/kvm.h | 1 +
>>  target/arm/cpu.h          | 3 +++
>>  target/arm/kvm64.c        | 8 ++++++++
>>  3 files changed, 12 insertions(+)
>>
>> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
>> index 7971a4f..2aa176e 100644
>> --- a/linux-headers/linux/kvm.h
>> +++ b/linux-headers/linux/kvm.h
>> @@ -929,6 +929,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_PPC_SMT_POSSIBLE 147
>>  #define KVM_CAP_HYPERV_SYNIC2 148
>>  #define KVM_CAP_HYPERV_VP_INDEX 149
>> +#define KVM_CAP_ARM_RAS_EXTENSION 150
>>
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>
> 
> Hi. Changes to linux-headers need to be done as a patch of their
> own created using scripts/update-linux-headers.sh run against a
> mainline kernel tree (and with a commit message that quotes the
> kernel commit hash used). This ensures that we have a consistent
> set of headers that don't diverge from the kernel copy.
> 
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index b39d64a..6b0961b 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -611,6 +611,8 @@ struct ARMCPU {
>>
>>      /* CPU has memory protection unit */
>>      bool has_mpu;
>> +    /* CPU has ras extension unit */
>> +    bool has_ras_extension;
>>      /* PMSAv7 MPU number of supported regions */
>>      uint32_t pmsav7_dregion;
>>
>> @@ -1229,6 +1231,7 @@ enum arm_features {
>>      ARM_FEATURE_THUMB_DSP, /* DSP insns supported in the Thumb encodings */
>>      ARM_FEATURE_PMU, /* has PMU support */
>>      ARM_FEATURE_VBAR, /* has cp15 VBAR */
>> +    ARM_FEATURE_RAS_EXTENSION, /*has RAS extension support */
> 
> Missing space after '/*' ?
> 
>>  };
>>
>>  static inline int arm_feature(CPUARMState *env, int feature)
>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
>> index a16abc8..0781367 100644
>> --- a/target/arm/kvm64.c
>> +++ b/target/arm/kvm64.c
>> @@ -518,6 +518,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>          unset_feature(&env->features, ARM_FEATURE_PMU);
>>      }
>>
>> +    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_RAS_EXTENSION)) {
>> +        cpu->has_ras_extension = true;
>> +        set_feature(&env->features, ARM_FEATURE_RAS_EXTENSION);
>> +    } else {
>> +        cpu->has_ras_extension = false;
>> +        unset_feature(&env->features, ARM_FEATURE_RAS_EXTENSION);
>> +    }
>> +
> 
> Shouldn't we need to also tell the kernel that we actually want
> it to expose RAS to the guest? Compare the PMU code in this
> function, where we set a kvm_init_features bit to do this.
> (This suggests that your ABI for the kernel part of this feature
> may not be correct?)
> 
> You should also not be calling set_feature() here -- if the
> CPU features bit doesn't say "this CPU should have the RAS
> extensions" we shouldn't create a CPU with them. Instead
> you should set it in kvm_arm_get_host_cpu_features() (again,
> compare the PMU code).
> 
> thanks
> -- PMM
> 
> .
> 

