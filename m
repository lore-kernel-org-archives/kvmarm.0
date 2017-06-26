From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v3 1/3] arm64: kvm: support kvmtool to detect RAS
 extension feature
Date: Mon, 26 Jun 2017 13:22:27 +0800
Message-ID: <9e94c06f-f438-7106-ac96-67e021dcf729@huawei.com>
References: <1493530677-4919-1-git-send-email-gengdongjiu@huawei.com>
 <5908A5BC.1060202@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5908A5BC.1060202@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: peter.maydell@linaro.org, mtsirkin@redhat.com, kvm@vger.kernel.org, rkrcmar@redhat.com, tbaicar@codeaurora.org, qemu-devel@nongnu.org, wangxiongfeng2@huawei.com, ben@skyportsystems.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, huangshaoyu@huawei.com, zhaoshenglong@huawei.com, lersek@redhat.com, songwenjun@huawei.com, drjones@redhat.com, wuquanming@huawei.com, xiexiuqi@huawei.com, marc.zyngier@arm.com, qemu-arm@nongnu.org, imammedo@redhat.com, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, pbonzini@redhat.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

   I have changed the SEA/SEI injection method according you suggestion, but I think this patch may also be needed.
Now for the  SEI, the virtual ESR value is specified by the userspace. only RAS extension support to set the virtual ESR value. so user space will check it to decide whether pass the virtual ESR value.
At the same time, reserve this interface for other possible usage by user space. what do you think about this patch?



On 2017/5/2 23:29, James Morse wrote:
> Hi Dongjiu Geng,
> 
> On 30/04/17 06:37, Dongjiu Geng wrote:
>> Handle kvmtool's detection for RAS extension, because sometimes
>> the APP needs to know the CPU's capacity
> 
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index d9e9697..1004039 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -64,6 +64,14 @@ static bool cpu_has_32bit_el1(void)
>>  	return !!(pfr0 & 0x20);
>>  }
>>  
>> +static bool kvm_arm_support_ras_extension(void)
>> +{
>> +	u64 pfr0;
>> +
>> +	pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
>> +	return !!(pfr0 & 0x10000000);
>> +}
> 
> Why are we telling user-space that the CPU has RAS extensions? EL0 can't do
> anything with this and the guest EL1 can detect it from the id registers.
> 
> 
> Are you using this to decide whether or not to generate a HEST for the guest?
> 
> If Qemu/kvmtool supports handling memory-failure notifications from signals you
> should always generate a HEST. The GHES notification method could be anything
> Qemu can deliver to the guest using the KVM APIs. Notifications from Qemu to the
> guest don't depend on the RAS extensions. KVM has APIs for IRQ and SEA (you can
> use KVM_SET_ONE_REG).
> 
> 
> I think we need a new API for injecting SError for SEI from Qemu/kvmtool, but it
> shouldn't be related to the RAS extensions. All v8.0 CPUs have HCR_EL2.VSE, so
> we need to know KVM supports this API.
> 
> Your later patch adds code to set VSESR to make virtual RAS SErrors work, I
> think we need to expose that to user-space.
> 
> 
> Thanks,
> 
> James
> .
> 
