From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH] kvm: Delete the slot only when KVM_MEM_READONLY flag
 is changed
Date: Wed, 13 Jun 2018 10:15:29 +0800
Message-ID: <5B207E41.3080209@huawei.com>
References: <1526462314-19720-1-git-send-email-zhaoshenglong@huawei.com>
 <25094a6a-df4e-3dbb-ef69-e478edb46ff3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E02FD40683
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jun 2018 22:05:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ooEWxmEkjWNq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jun 2018 22:05:27 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97EB44065F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jun 2018 22:05:27 -0400 (EDT)
In-Reply-To: <25094a6a-df4e-3dbb-ef69-e478edb46ff3@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org, guangrong.xiao@gmail.com
Cc: shannon.zhaosl@gmail.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2018/6/12 20:17, Paolo Bonzini wrote:
> On 16/05/2018 11:18, Shannon Zhao wrote:
>> According to KVM commit 75d61fbc, it needs to delete the slot before
>> changing the KVM_MEM_READONLY flag. But QEMU commit 235e8982 only check
>> whether KVM_MEM_READONLY flag is set instead of changing. It doesn't
>> need to delete the slot if the KVM_MEM_READONLY flag is not changed.
>>
>> This fixes a issue that migrating a VM at the OVMF startup stage and
>> VM is executing the codes in rom. Between the deleting and adding the
>> slot in kvm_set_user_memory_region, there is a chance that guest access
>> rom and trap to KVM, then KVM can't find the corresponding memslot.
>> While KVM (on ARM) injects an abort to guest due to the broken hva, then
>> guest will get stuck.
>>
>> Signed-off-by: Shannon Zhao <zhaoshenglong@huawei.com>
> 
> I'm a bit worried about old_flags not being set on all paths to
> kvm_set_user_memory_region.  This would lead to extra
> KVM_SET_USER_MEMORY_REGION calls.  It should not be a problem but
> it is ugly.  Does something like the additional changes below work for you?
> 
I test below patch. It works for our testcase.
Do I need to fold them into one and resend?

Thanks,
-- 
Shannon

> Thanks,
> 
> Paolo
> 
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index b04f193a76..e318bcfb78 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -257,7 +257,7 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
>      return 0;
>  }
>  
> -static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot)
> +static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, bool new)
>  {
>      KVMState *s = kvm_state;
>      struct kvm_userspace_memory_region mem;
> @@ -268,7 +268,7 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot)
>      mem.userspace_addr = (unsigned long)slot->ram;
>      mem.flags = slot->flags;
>  
> -    if (slot->memory_size && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
> +    if (slot->memory_size && !new && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
>          /* Set the slot size to 0 before setting the slot to the desired
>           * value. This is needed based on KVM commit 75d61fbc. */
>          mem.memory_size = 0;
> @@ -276,6 +276,7 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot)
>      }
>      mem.memory_size = slot->memory_size;
>      ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +    slot->old_flags = mem.flags;
>      trace_kvm_set_user_memory(mem.slot, mem.flags, mem.guest_phys_addr,
>                                mem.memory_size, mem.userspace_addr, ret);
>      return ret;
> @@ -394,7 +395,6 @@ static int kvm_slot_update_flags(KVMMemoryListener *kml, KVMSlot *mem,
>  {
>      int old_flags;
>  
> -    mem->old_flags = mem->flags;
>      mem->flags = kvm_mem_flags(mr);
>  
>      /* If nothing changed effectively, no need to issue ioctl */
> @@ -402,7 +402,7 @@ static int kvm_slot_update_flags(KVMMemoryListener *kml, KVMSlot *mem,
>          return 0;
>      }
>  
> -    return kvm_set_user_memory_region(kml, mem);
> +    return kvm_set_user_memory_region(kml, mem, false);
>  }
>  
>  static int kvm_section_update_flags(KVMMemoryListener *kml,
> @@ -756,7 +756,8 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
>  
>          /* unregister the slot */
>          mem->memory_size = 0;
> -        err = kvm_set_user_memory_region(kml, mem);
> +        mem->flags = 0;
> +        err = kvm_set_user_memory_region(kml, mem, false);
>          if (err) {
>              fprintf(stderr, "%s: error unregistering slot: %s\n",
>                      __func__, strerror(-err));
> @@ -772,7 +773,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
>      mem->ram = ram;
>      mem->flags = kvm_mem_flags(mr);
>  
> -    err = kvm_set_user_memory_region(kml, mem);
> +    err = kvm_set_user_memory_region(kml, mem, true);
>      if (err) {
>          fprintf(stderr, "%s: error registering slot: %s\n", __func__,
>                  strerror(-err));
> 
> .
> 
