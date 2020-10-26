Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8152AC2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 08:33:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F506223B0
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 08:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="C51WLzaj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F506223B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFABE4B688;
	Mon, 26 Oct 2020 04:33:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zqad3CDeJuFg; Mon, 26 Oct 2020 04:33:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 832A34B452;
	Mon, 26 Oct 2020 04:33:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B63164B47B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 00:56:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M6a+NgdF6oIy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 00:56:54 -0400 (EDT)
Received: from hqnvemgate24.nvidia.com (hqnvemgate24.nvidia.com
 [216.228.121.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFF394B452
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 00:56:53 -0400 (EDT)
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by
 hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
 id <B5f96571c0001>; Sun, 25 Oct 2020 21:57:00 -0700
Received: from HQMAIL107.nvidia.com ([172.20.161.6])
 by hqpgpgate102.nvidia.com (PGP Universal service);
 Sun, 25 Oct 2020 21:56:52 -0700
X-PGP-Universal: processed;
 by hqpgpgate102.nvidia.com on Sun, 25 Oct 2020 21:56:52 -0700
Received: from [10.40.103.237] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 04:56:44 +0000
Subject: Re: [PATCH] KVM: arm64: Correctly handle the mmio faulting
To: Marc Zyngier <maz@kernel.org>
References: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
 <0a239ac4481fa01c8d09cf2e56dfdabe@kernel.org>
From: Santosh Shukla <sashukla@nvidia.com>
Message-ID: <f56e0d71-ceb5-8ecf-e865-4ee857e333e1@nvidia.com>
Date: Mon, 26 Oct 2020 10:26:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <0a239ac4481fa01c8d09cf2e56dfdabe@kernel.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Language: en-US
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
 t=1603688220; bh=AzRHHGkWpntrbD2lE06mNjLuvp6LDyjJklFEptHtizk=;
 h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
 User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
 X-ClientProxiedBy:Content-Type:Content-Language;
 b=C51WLzajLr79HZ1MLmLEgjTvpQT6lOUVOzOXqlxK9DBVHfm1eJRZ9CgNV2t9zJ+a/
 arcw/H1eRf0DKsLrpcFq8dSOSxmp0BU3H0FRtF42no98fdDxPkGSRDSZxnVAW6l9Ha
 Co7l7QdCntMF1efHdfXpfkkkWlBBOg+ObAVHMpiBkQ1gArJWAr6x6jt7u6eIX9pKU+
 iAKAK1aI53fUPi4cr99F7rP+J5eh0h5eV8/zjARLALheB00eDi7H4LjsQgdb7xby57
 z8XrX2ddJrUIZGRKNr/Bi9QIzagKE9iAXSEgdWm09uUV7rff6I7EaMWbSvEjrbZVdm
 D64wHiP/deuNQ==
X-Mailman-Approved-At: Mon, 26 Oct 2020 04:33:20 -0400
Cc: mcrossley@nvidia.com, cjia@nvidia.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, kwankhede@nvidia.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============1958668128028338298=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============1958668128028338298==
Content-Type: multipart/alternative;
	boundary="------------689407E11535ADDFC0C452E2"
Content-Language: en-US

--------------689407E11535ADDFC0C452E2
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit

Hi Marc,

Thanks for the review comment.

On 10/23/2020 4:59 PM, Marc Zyngier wrote:
>
> Hi Santosh,
>
> Thanks for this.
>
> On 2020-10-21 17:16, Santosh Shukla wrote:
>> The Commit:6d674e28 introduces a notion to detect and handle the
>> device mapping. The commit checks for the VM_PFNMAP flag is set
>> in vma->flags and if set then marks force_pte to true such that
>> if force_pte is true then ignore the THP function check
>> (/transparent_hugepage_adjust()).
>>
>> There could be an issue with the VM_PFNMAP flag setting and checking.
>> For example consider a case where the mdev vendor driver register's
>> the vma_fault handler named vma_mmio_fault(), which maps the
>> host MMIO region in-turn calls remap_pfn_range() and maps
>> the MMIO's vma space. Where, remap_pfn_range implicitly sets
>> the VM_PFNMAP flag into vma->flags.
>>
>> Now lets assume a mmio fault handing flow where guest first access
>> the MMIO region whose 2nd stage translation is not present.
>> So that results to arm64-kvm hypervisor executing guest abort handler,
>> like below:
>>
>> kvm_handle_guest_abort() -->
>>  user_mem_abort()--> {
>>
>>     ...
>>     0. checks the vma->flags for the VM_PFNMAP.
>>     1. Since VM_PFNMAP flag is not yet set so force_pte _is_ false;
>>     2. gfn_to_pfn_prot() -->
>>         __gfn_to_pfn_memslot() -->
>>             fixup_user_fault() -->
>>                 handle_mm_fault()-->
>>                     __do_fault() -->
>>                        vma_mmio_fault() --> // vendor's mdev fault
>> handler
>>                         remap_pfn_range()--> // Here sets the VM_PFNMAP
>>                                               flag into vma->flags.
>>     3. Now that force_pte is set to false in step-2),
>>        will execute transparent_hugepage_adjust() func and
>>        that lead to Oops [4].
>>  }
>
> Hmmm. Nice. Any chance you could provide us with an actual reproducer?
>
I tried to create the reproducer scenario with vfio-pci driver using
nvidia GPU in PT mode, As because vfio-pci driver now supports
vma faulting (/vfio_pci_mmap_fault) so could create a crude reproducer
situation with that.

To create the repro - I did an ugly hack into arm64/kvm/mmu.c.
The hack is to make sure that stage2 mapping are not created
at the time of vm_init by unsetting VM_PFNMAP flag. This `unsetting` flag
needed because vfio-pci's mmap func(/vfio_pci_mmap) by-default
sets the VM_PFNMAP flag for the MMIO region but I want
the remap_pfn_range() func to set the _PFNMAP flag via vfio's fault
handler func vfio_pci_mmap_fault().

So with above, when guest access the MMIO region, this will
trigger the mmio fault path at arm64-kvm hypervisor layer like below:
user_mem_abort() {->...
     --> Check the VM_PFNMAP flag, since not set so marks force_pte=false
     ....
     __gfn_to_pfn_memslot()-->
     ...
     handle_mm_fault()-->
     do_fault()-->
     vfio_pci_mmio_fault()-->
     remap_pfn_range()--> Now will set the VM_PFNMAP flag.
}

I have also set the force_pte=true, just to avoid the THP Oops which was
mentioned in the previous thread.

hackish change to reproduce scenario:

--->
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 19aacc7d64de..9ef70dc624cf 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -836,9 +836,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
phys_addr_t fault_ipa,
         }
         if (is_error_noslot_pfn(pfn))
                 return -EFAULT;
-
         if (kvm_is_device_pfn(pfn)) {
                 device = true;
+               force_pte = true;
         } else if (logging_active && !write_fault) {
                 /*
                  * Only actually map the page as writable if this was a 
write
@@ -1317,6 +1317,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
                 vm_start = max(hva, vma->vm_start);
                 vm_end = min(reg_end, vma->vm_end);

+               /* Hack to make sure stage2 mapping not present, thus 
trigger
+                * user_mem_abort for stage2 mapping */
+               if (vma->vm_flags & VM_PFNMAP) {
+                       vma->vm_flags = vma->vm_flags & (~VM_PFNMAP);
+               }
                 if (vma->vm_flags & VM_PFNMAP) {
                         gpa_t gpa = mem->guest_phys_addr +
                                     (vm_start - mem->userspace_addr);

>>
>> The proposition is to check is_iomap flag before executing the THP
>> function transparent_hugepage_adjust().
>>
>> [4] THP Oops:
>>> pc: kvm_is_transparent_hugepage+0x18/0xb0
>>> ...
>>> ...
>>> user_mem_abort+0x340/0x9b8
>>> kvm_handle_guest_abort+0x248/0x468
>>> handle_exit+0x150/0x1b0
>>> kvm_arch_vcpu_ioctl_run+0x4d4/0x778
>>> kvm_vcpu_ioctl+0x3c0/0x858
>>> ksys_ioctl+0x84/0xb8
>>> __arm64_sys_ioctl+0x28/0x38
>>
>> Tested on Huawei Kunpeng Taishan-200 arm64 server, Using VFIO-mdev
>> device.
>> Linux tip: 583090b1
>>
>> Fixes: 6d674e28 ("KVM: arm/arm64: Properly handle faulting of device
>> mappings")
>> Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
>> ---
>>  arch/arm64/kvm/mmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 3d26b47..ff15357 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1947,7 +1947,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu,
>> phys_addr_t fault_ipa,
>>        * If we are not forced to use page mapping, check if we are
>>        * backed by a THP and thus use block mapping if possible.
>>        */
>> -     if (vma_pagesize == PAGE_SIZE && !force_pte)
>> +     if (vma_pagesize == PAGE_SIZE && !force_pte && !is_iomap(flags))
>>               vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>> &pfn, &fault_ipa);
>>       if (writable)
>
> Why don't you directly set force_pte to true at the point where we
> update
> the flags? It certainly would be a bit more readable:
>
Yes.
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3d26b47a1343..7a4ad984d54e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1920,6 +1920,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu,
> phys_addr_t fault_ipa,
>        if (kvm_is_device_pfn(pfn)) {
>                mem_type = PAGE_S2_DEVICE;
>                flags |= KVM_S2PTE_FLAG_IS_IOMAP;
> +               force_pte = true;
>        } else if (logging_active) {
>                /*
>                 * Faults on pages in a memslot with logging enabled
>
> and almost directly applies to what we have queued for 5.10.
>
Right. I believe - Above code is sightly changed at linux-next commit: 
9695c4ff

Modified one looks like below:

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 19aacc7..d4cd253 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -839,6 +839,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
phys_addr_t fault_ipa,

         if (kvm_is_device_pfn(pfn)) {
                 device = true;
+               force_pte = true;
         } else if (logging_active && !write_fault) {
                 /*
                  * Only actually map the page as writable if this was a 
write

pl. let me know if above is okay and will send out v2.

Thanks.

Santosh


> Thanks,
>
>         M.
> -- 
> Jazz is not dead. It just smells funny...

--------------689407E11535ADDFC0C452E2
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <pre>Hi Marc,

Thanks for the review comment.
</pre>
    <div class="moz-cite-prefix">On 10/23/2020 4:59 PM, Marc Zyngier
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:0a239ac4481fa01c8d09cf2e56dfdabe@kernel.org"><br>
      Hi Santosh,
      <br>
      <br>
      Thanks for this.
      <br>
      <br>
      On 2020-10-21 17:16, Santosh Shukla wrote:
      <br>
      <blockquote type="cite">The Commit:6d674e28 introduces a notion to
        detect and handle the
        <br>
        device mapping. The commit checks for the VM_PFNMAP flag is set
        <br>
        in vma-&gt;flags and if set then marks force_pte to true such
        that
        <br>
        if force_pte is true then ignore the THP function check
        <br>
        (/transparent_hugepage_adjust()).
        <br>
        <br>
        There could be an issue with the VM_PFNMAP flag setting and
        checking.
        <br>
        For example consider a case where the mdev vendor driver
        register's
        <br>
        the vma_fault handler named vma_mmio_fault(), which maps the
        <br>
        host MMIO region in-turn calls remap_pfn_range() and maps
        <br>
        the MMIO's vma space. Where, remap_pfn_range implicitly sets
        <br>
        the VM_PFNMAP flag into vma-&gt;flags.
        <br>
        <br>
        Now lets assume a mmio fault handing flow where guest first
        access
        <br>
        the MMIO region whose 2nd stage translation is not present.
        <br>
        So that results to arm64-kvm hypervisor executing guest abort
        handler,
        <br>
        like below:
        <br>
        <br>
        kvm_handle_guest_abort() --&gt;
        <br>
         user_mem_abort()--&gt; {
        <br>
        <br>
            ...
        <br>
            0. checks the vma-&gt;flags for the VM_PFNMAP.
        <br>
            1. Since VM_PFNMAP flag is not yet set so force_pte _is_
        false;
        <br>
            2. gfn_to_pfn_prot() --&gt;
        <br>
                __gfn_to_pfn_memslot() --&gt;
        <br>
                    fixup_user_fault() --&gt;
        <br>
                        handle_mm_fault()--&gt;
        <br>
                            __do_fault() --&gt;
        <br>
                               vma_mmio_fault() --&gt; // vendor's mdev
        fault
        <br>
        handler
        <br>
                                remap_pfn_range()--&gt; // Here sets the
        VM_PFNMAP
        <br>
                                                      flag into
        vma-&gt;flags.
        <br>
            3. Now that force_pte is set to false in step-2),
        <br>
               will execute transparent_hugepage_adjust() func and
        <br>
               that lead to Oops [4].
        <br>
         }
        <br>
      </blockquote>
      <br>
      Hmmm. Nice. Any chance you could provide us with an actual
      reproducer?
      <br>
      <br>
    </blockquote>
    <p>I tried to create the reproducer scenario with vfio-pci driver
      using<br>
      nvidia GPU in PT mode, As because vfio-pci driver now supports<br>
      vma faulting (/vfio_pci_mmap_fault) so could create a crude
      reproducer<br>
      situation with that.<br>
      <br>
      To create the repro - I did an ugly hack into arm64/kvm/mmu.c.<br>
      The hack is to make sure that stage2 mapping are not created<br>
      at the time of vm_init by unsetting VM_PFNMAP flag. This
      `unsetting` flag<br>
      needed because vfio-pci's mmap func(/vfio_pci_mmap) by-default<br>
      sets the VM_PFNMAP flag for the MMIO region but I want<br>
      the remap_pfn_range() func to set the _PFNMAP flag via vfio's
      fault<br>
      handler func vfio_pci_mmap_fault().<br>
      <br>
      So with above, when guest access the MMIO region, this will<br>
      trigger the mmio fault path at arm64-kvm hypervisor layer like
      below:<br>
      user_mem_abort() {-&gt;...<br>
          --&gt; Check the VM_PFNMAP flag, since not set so marks
      force_pte=false<br>
          ....<br>
          __gfn_to_pfn_memslot()--&gt;<br>
          ...<br>
          handle_mm_fault()--&gt;<br>
          do_fault()--&gt;<br>
          vfio_pci_mmio_fault()--&gt;<br>
          remap_pfn_range()--&gt; Now will set the VM_PFNMAP flag.<br>
      }<br>
      <br>
      I have also set the force_pte=true, just to avoid the THP Oops
      which was<br>
      mentioned in the previous thread.<br>
      <br>
      hackish change to reproduce scenario:</p>
    <p>---&gt;<br>
      diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c<br>
      index 19aacc7d64de..9ef70dc624cf 100644<br>
      --- a/arch/arm64/kvm/mmu.c<br>
      +++ b/arch/arm64/kvm/mmu.c<br>
      @@ -836,9 +836,9 @@ static int user_mem_abort(struct kvm_vcpu
      *vcpu, phys_addr_t fault_ipa,<br>
              }<br>
              if (is_error_noslot_pfn(pfn))<br>
                      return -EFAULT;<br>
      -<br>
              if (kvm_is_device_pfn(pfn)) {<br>
                      device = true;<br>
      +               force_pte = true;<br>
              } else if (logging_active &amp;&amp; !write_fault) {<br>
                      /*<br>
                       * Only actually map the page as writable if this
      was a write<br>
      @@ -1317,6 +1317,11 @@ int kvm_arch_prepare_memory_region(struct
      kvm *kvm,<br>
                      vm_start = max(hva, vma-&gt;vm_start);<br>
                      vm_end = min(reg_end, vma-&gt;vm_end);<br>
      <br>
      +               /* Hack to make sure stage2 mapping not present,
      thus trigger<br>
      +                * user_mem_abort for stage2 mapping */<br>
      +               if (vma-&gt;vm_flags &amp; VM_PFNMAP) {<br>
      +                       vma-&gt;vm_flags = vma-&gt;vm_flags &amp;
      (~VM_PFNMAP);<br>
      +               }<br>
                      if (vma-&gt;vm_flags &amp; VM_PFNMAP) {<br>
                              gpa_t gpa = mem-&gt;guest_phys_addr +<br>
                                          (vm_start -
      mem-&gt;userspace_addr);<br>
      <br>
    </p>
    <blockquote type="cite"
      cite="mid:0a239ac4481fa01c8d09cf2e56dfdabe@kernel.org">
      <blockquote type="cite">
        <br>
        The proposition is to check is_iomap flag before executing the
        THP
        <br>
        function transparent_hugepage_adjust().
        <br>
        <br>
        [4] THP Oops:
        <br>
        <blockquote type="cite">pc:
          kvm_is_transparent_hugepage+0x18/0xb0
          <br>
          ...
          <br>
          ...
          <br>
          user_mem_abort+0x340/0x9b8
          <br>
          kvm_handle_guest_abort+0x248/0x468
          <br>
          handle_exit+0x150/0x1b0
          <br>
          kvm_arch_vcpu_ioctl_run+0x4d4/0x778
          <br>
          kvm_vcpu_ioctl+0x3c0/0x858
          <br>
          ksys_ioctl+0x84/0xb8
          <br>
          __arm64_sys_ioctl+0x28/0x38
          <br>
        </blockquote>
        <br>
        Tested on Huawei Kunpeng Taishan-200 arm64 server, Using
        VFIO-mdev
        <br>
        device.
        <br>
        Linux tip: 583090b1
        <br>
        <br>
        Fixes: 6d674e28 ("KVM: arm/arm64: Properly handle faulting of
        device
        <br>
        mappings")
        <br>
        Signed-off-by: Santosh Shukla <a class="moz-txt-link-rfc2396E" href="mailto:sashukla@nvidia.com">&lt;sashukla@nvidia.com&gt;</a>
        <br>
        ---
        <br>
         arch/arm64/kvm/mmu.c | 2 +-
        <br>
         1 file changed, 1 insertion(+), 1 deletion(-)
        <br>
        <br>
        diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
        <br>
        index 3d26b47..ff15357 100644
        <br>
        --- a/arch/arm64/kvm/mmu.c
        <br>
        +++ b/arch/arm64/kvm/mmu.c
        <br>
        @@ -1947,7 +1947,7 @@ static int user_mem_abort(struct kvm_vcpu
        *vcpu,
        <br>
        phys_addr_t fault_ipa,
        <br>
               * If we are not forced to use page mapping, check if we
        are
        <br>
               * backed by a THP and thus use block mapping if possible.
        <br>
               */
        <br>
        -     if (vma_pagesize == PAGE_SIZE &amp;&amp; !force_pte)
        <br>
        +     if (vma_pagesize == PAGE_SIZE &amp;&amp; !force_pte
        &amp;&amp; !is_iomap(flags))
        <br>
                      vma_pagesize =
        transparent_hugepage_adjust(memslot, hva,
        <br>
                                                                
        &amp;pfn, &amp;fault_ipa);
        <br>
              if (writable)
        <br>
      </blockquote>
      <br>
      Why don't you directly set force_pte to true at the point where we
      <br>
      update
      <br>
      the flags? It certainly would be a bit more readable:
      <br>
      <br>
    </blockquote>
    Yes.<br>
    <blockquote type="cite"
      cite="mid:0a239ac4481fa01c8d09cf2e56dfdabe@kernel.org">diff --git
      a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
      <br>
      index 3d26b47a1343..7a4ad984d54e 100644
      <br>
      --- a/arch/arm64/kvm/mmu.c
      <br>
      +++ b/arch/arm64/kvm/mmu.c
      <br>
      @@ -1920,6 +1920,7 @@ static int user_mem_abort(struct kvm_vcpu
      *vcpu,
      <br>
      phys_addr_t fault_ipa,
      <br>
             if (kvm_is_device_pfn(pfn)) {
      <br>
                     mem_type = PAGE_S2_DEVICE;
      <br>
                     flags |= KVM_S2PTE_FLAG_IS_IOMAP;
      <br>
      +               force_pte = true;
      <br>
             } else if (logging_active) {
      <br>
                     /*
      <br>
                      * Faults on pages in a memslot with logging
      enabled
      <br>
      <br>
      and almost directly applies to what we have queued for 5.10.
      <br>
      <br>
    </blockquote>
    <p>Right. I believe - Above code is sightly changed at linux-next
      commit: 9695c4ff <br>
    </p>
    <p>Modified one looks like below:</p>
    <p>diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c<br>
      index 19aacc7..d4cd253 100644<br>
      --- a/arch/arm64/kvm/mmu.c<br>
      +++ b/arch/arm64/kvm/mmu.c<br>
      @@ -839,6 +839,7 @@ static int user_mem_abort(struct kvm_vcpu
      *vcpu, phys_addr_t fault_ipa,<br>
       <br>
              if (kvm_is_device_pfn(pfn)) {<br>
                      device = true;<br>
      +               force_pte = true;<br>
              } else if (logging_active &amp;&amp; !write_fault) {<br>
                      /*<br>
                       * Only actually map the page as writable if this
      was a write<br>
    </p>
    <p>pl. let me know if above is okay and will send out v2.</p>
    <p>Thanks.</p>
    <p>Santosh</p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:0a239ac4481fa01c8d09cf2e56dfdabe@kernel.org">Thanks,
      <br>
      <br>
              M.
      <br>
      --
      <br>
      Jazz is not dead. It just smells funny...
      <br>
    </blockquote>
  </body>
</html>

--------------689407E11535ADDFC0C452E2--

--===============1958668128028338298==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1958668128028338298==--
