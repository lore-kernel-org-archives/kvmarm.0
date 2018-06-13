From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: Delete the slot only when KVM_MEM_READONLY flag is
 changed
Date: Wed, 13 Jun 2018 17:58:18 +0200
Message-ID: <fdd4182f-6f7c-16ae-e800-3219bf1d09e9@redhat.com>
References: <1526462314-19720-1-git-send-email-zhaoshenglong@huawei.com>
 <25094a6a-df4e-3dbb-ef69-e478edb46ff3@redhat.com>
 <5B207E41.3080209@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 736E149EA4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jun 2018 11:47:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JjAxOYi4wCMM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jun 2018 11:46:53 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 923194028A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jun 2018 11:46:53 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id p126-v6so5648321wmb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jun 2018 08:58:27 -0700 (PDT)
In-Reply-To: <5B207E41.3080209@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, qemu-devel@nongnu.org, guangrong.xiao@gmail.com
Cc: shannon.zhaosl@gmail.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/06/2018 04:15, Shannon Zhao wrote:
> 
> 
> On 2018/6/12 20:17, Paolo Bonzini wrote:
>> On 16/05/2018 11:18, Shannon Zhao wrote:
>>> According to KVM commit 75d61fbc, it needs to delete the slot before
>>> changing the KVM_MEM_READONLY flag. But QEMU commit 235e8982 only check
>>> whether KVM_MEM_READONLY flag is set instead of changing. It doesn't
>>> need to delete the slot if the KVM_MEM_READONLY flag is not changed.
>>>
>>> This fixes a issue that migrating a VM at the OVMF startup stage and
>>> VM is executing the codes in rom. Between the deleting and adding the
>>> slot in kvm_set_user_memory_region, there is a chance that guest access
>>> rom and trap to KVM, then KVM can't find the corresponding memslot.
>>> While KVM (on ARM) injects an abort to guest due to the broken hva, then
>>> guest will get stuck.
>>>
>>> Signed-off-by: Shannon Zhao <zhaoshenglong@huawei.com>
>>
>> I'm a bit worried about old_flags not being set on all paths to
>> kvm_set_user_memory_region.  This would lead to extra
>> KVM_SET_USER_MEMORY_REGION calls.  It should not be a problem but
>> it is ugly.  Does something like the additional changes below work for you?
>>
> I test below patch. It works for our testcase.
> Do I need to fold them into one and resend?

No need to, thanks!

Paolo
