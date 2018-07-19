From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v8 2/4] arm64: KVM: export the capability to set guest
 SError syndrome
Date: Thu, 19 Jul 2018 17:29:07 +0800
Message-ID: <299f2265-ea03-52ef-d88e-9efab1752b60@huawei.com>
References: <20180713154751.18131-1-james.morse@arm.com>
 <20180713154751.18131-3-james.morse@arm.com>
 <CAFEAcA9pK7W=gSZXTOTxFEFDmc6kJ8GDYO4a6r_P1FHp+KuT9A@mail.gmail.com>
 <86da7b47-5026-5ec7-96dc-4d3a14caa2f8@huawei.com>
 <CAFEAcA_Amw6Pr+DmeZXHDWKQPSYf_826hDDwna2fwQvOP1+9og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E69CC49F86
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 05:16:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CKSyWHY-61zH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 05:16:29 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE11E40196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 05:16:28 -0400 (EDT)
In-Reply-To: <CAFEAcA_Amw6Pr+DmeZXHDWKQPSYf_826hDDwna2fwQvOP1+9og@mail.gmail.com>
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
To: Peter Maydell <peter.maydell@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Linuxarm <linuxarm@huawei.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2018/7/19 17:10, Peter Maydell wrote:
>> The user space will firstly check the  KVM_CAP_VCPU_EVENTS through kvm_has_vcpu_events() to know whether KVM can support get/set vcpu events,
>> If KVM supports get/set vcpu events, it will check KVM_CAP_ARM_SET_SERROR_ESR to know whether can set guest SError ESR, as shown the user space code in [1].
> OK, so this capability affects the behaviour of
> KVM_SET_VCPU_EVENTS. Can you make sure the documentation
> of KVM_SET_VCPU_EVENTS clearly explains what happens
> and the effect of whether this capability is present,
> please? People trying to understand the behaviour of
> that ioctl are not going to know that they need to
> look here as well.
sure, I will. Thanks peter's reminder and comments.
