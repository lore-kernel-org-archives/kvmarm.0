Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D57C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 03:29:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D0334B8A9;
	Mon, 14 Nov 2022 22:29:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VRaAX4bNRbIB; Mon, 14 Nov 2022 22:29:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EACA4B8AD;
	Mon, 14 Nov 2022 22:29:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7CE34B8A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 22:29:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ew0je31NX6dR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Nov 2022 22:29:02 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2FAE4B89C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 22:29:01 -0500 (EST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBBPz29c4zqSHG;
 Tue, 15 Nov 2022 11:25:11 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 11:28:56 +0800
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
 <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
 <CABgObfYtS6wiQe=BhF3t5usr7J6q4PWE4=rwZMMukfC9wT_6fA@mail.gmail.com>
 <YVIAdVxc+q2UWB+J@google.com>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <32810c89-44c6-6780-9d05-e49f6b897b6e@huawei.com>
Date: Tue, 15 Nov 2022 11:28:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YVIAdVxc+q2UWB+J@google.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
 kvm-ppc <kvm-ppc@vger.kernel.org>,
 "open list:MIPS" <linux-mips@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Jon Cargille <jcargill@google.com>, David Matlack <dmatlack@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>
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

Hi Sean, Paolo,

I recently also notice the behavior change of param halt_poll_ns.
Now it loses the ability to:
1) dynamically disable halt polling for all the running VMs
by `echo 0 > /sys`
2) dynamically adjust the halt polling interval for all the
running VMs by `echo * > /sys`

While in our cases, we usually use above two abilities, and
KVM_CAP_HALT_POLL is not used yet.

On 2021/9/28 1:33, Sean Christopherson wrote:
> On Mon, Sep 27, 2021, Paolo Bonzini wrote:
>> On Mon, Sep 27, 2021 at 5:17 PM Christian Borntraeger
>> <borntraeger@de.ibm.com> wrote:
>>>> So I think there are two possibilities that makes sense:
>>>>
>>>> * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns follow that
>>> what about using halt_poll_ns for those VMs that did not uses KVM_CAP_HALT_POLL and the private number for those that did.
>> Yes, that's what I meant.  David pointed out that doesn't allow you to
>> disable halt polling altogether, but for that you can always ask each
>> VM's userspace one by one, or just not use KVM_CAP_HALT_POLL. (Also, I
>> don't know about Google's usecase, but mine was actually more about
>> using KVM_CAP_HALT_POLL to *disable* halt polling on some VMs!).
> I kinda like the idea if special-casing halt_poll_ns=0, e.g. for testing or
> in-the-field mitigation if halt-polling is broken.  It'd be trivial to support, e.g.
Do we have any plan to repost the diff as a fix?
I would be very nice that this issue can be solved.

Besides, I think we may need some Doc for users to describe
how halt_poll_ns works with KVM_CAP_HALT_POLL, like
"Documentation/virt/guest-halt-polling.rst".
> @@ -3304,19 +3304,23 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>                  update_halt_poll_stats(vcpu, start, poll_end, !waited);
>
>          if (halt_poll_allowed) {
> +               max_halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
> +               if (!max_halt_poll_ns || !halt_poll_ns)  <------ squish the max if halt_poll_ns==0
> +                       max_halt_poll_ns = halt_poll_ns;
> +
Does this mean that KVM_CAP_HALT_POLL will not be able to
disable halt polling for a VM individually when halt_poll_ns !=0?
>                  if (!vcpu_valid_wakeup(vcpu)) {
>                          shrink_halt_poll_ns(vcpu);
> -               } else if (vcpu->kvm->max_halt_poll_ns) {
> +               } else if (max_halt_poll_ns) {
>                          if (halt_ns <= vcpu->halt_poll_ns)
>                                  ;
>                          /* we had a long block, shrink polling */
>                          else if (vcpu->halt_poll_ns &&
> -                                halt_ns > vcpu->kvm->max_halt_poll_ns)
> +                                halt_ns > max_halt_poll_ns)
>                                  shrink_halt_poll_ns(vcpu);
>                          /* we had a short halt and our poll time is too small */
> -                       else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
> -                                halt_ns < vcpu->kvm->max_halt_poll_ns)
> -                               grow_halt_poll_ns(vcpu);
> +                       else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
> +                                halt_ns < max_halt_poll_ns)
> +                               grow_halt_poll_ns(vcpu, max_halt_poll_ns);
>                  } else {
>                          vcpu->halt_poll_ns = 0;
>                  }
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> .
Thanks,
Yanan
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
