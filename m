From: "Chen, Tiejun" <tiejun.chen@intel.com>
Subject: Re: [PATCH v2 06/12] KVM: mark kvm->buses as empty once they were
 destroyed
Date: Fri, 27 Mar 2015 10:10:46 +0800
Message-ID: <5514BC26.3080103@intel.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com> <1427126309-11223-7-git-send-email-andre.przywara@arm.com> <5512EBB9.2050304@arm.com> <20150327013151.GA2882@amt.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150327013151.GA2882@amt.cnet>
Sender: kvm-owner@vger.kernel.org
To: Marcelo Tosatti <mtosatti@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "n.nikolaev@virtualopensystems.com" <n.nikolaev@virtualopensystems.com>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2015/3/27 9:31, Marcelo Tosatti wrote:
> On Wed, Mar 25, 2015 at 05:09:13PM +0000, Marc Zyngier wrote:
>> On 23/03/15 15:58, Andre Przywara wrote:
>>> In kvm_destroy_vm() we call kvm_io_bus_destroy() pretty early,
>>> especially before calling kvm_arch_destroy_vm(). To avoid
>>> unregistering devices from the already destroyed bus, let's mark
>>> the bus with NULL to let other users know it has been destroyed
>>> already.
>>> This avoids a crash on a VM shutdown with the VGIC using the
>>> kvm_io_bus later (the unregistering is in there to be able to roll
>>> back a faulting init).
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>
>> That seems sensible, but I don't see why nobody else hits that. What are
>> we doing differently?
>>
>> Otherwise,
>>
>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>>
>> Paolo, Marcelo, can we have your Ack on this?
>>
>> Thanks,
>>
>> 	M.
>>
>>> ---
>>>   virt/kvm/kvm_main.c |    4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index 8c7ab0b..6f164eb 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -604,8 +604,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
>>>   	list_del(&kvm->vm_list);
>>>   	spin_unlock(&kvm_lock);
>>>   	kvm_free_irq_routing(kvm);
>>> -	for (i = 0; i < KVM_NR_BUSES; i++)
>>> +	for (i = 0; i < KVM_NR_BUSES; i++) {
>>>   		kvm_io_bus_destroy(kvm->buses[i]);
>>> +		kvm->buses[i] = NULL;

Could we fold this line into a common like,

@@ -596,7 +597,6 @@ static void kvm_destroy_devices(struct kvm *kvm)

  static void kvm_destroy_vm(struct kvm *kvm)
  {
-       int i;
         struct mm_struct *mm = kvm->mm;

         kvm_arch_sync_events(kvm);
@@ -604,8 +604,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
         list_del(&kvm->vm_list);
         spin_unlock(&kvm_lock);
         kvm_free_irq_routing(kvm);
-       for (i = 0; i < KVM_NR_BUSES; i++)
-               kvm_io_bus_destroy(kvm->buses[i]);
+       kvm_destroy_all_io_bus(kvm);
         kvm_coalesced_mmio_free(kvm);
  #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
         mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
@@ -2943,6 +2942,16 @@ static void kvm_io_bus_destroy(struct kvm_io_bus 
*bus)
         kfree(bus);
  }

+static void kvm_destroy_all_io_bus(struct kvm *kvm)
+{
+       int i;
+
+       for (i = 0; i < KVM_NR_BUSES; i++) {
+           kvm_io_bus_destroy(kvm->buses[i]);
+           kvm->buses[i] = NULL;
+       }
+}
+
  static inline int kvm_io_bus_cmp(const struct kvm_io_range *r1,
                                   const struct kvm_io_range *r2)
  {

Thanks
Tiejun
