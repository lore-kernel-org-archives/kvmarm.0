From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v8 2/4] arm64: KVM: export the capability to set guest
 SError syndrome
Date: Thu, 19 Jul 2018 10:10:23 +0100
Message-ID: <CAFEAcA_Amw6Pr+DmeZXHDWKQPSYf_826hDDwna2fwQvOP1+9og@mail.gmail.com>
References: <20180713154751.18131-1-james.morse@arm.com>
 <20180713154751.18131-3-james.morse@arm.com>
 <CAFEAcA9pK7W=gSZXTOTxFEFDmc6kJ8GDYO4a6r_P1FHp+KuT9A@mail.gmail.com>
 <86da7b47-5026-5ec7-96dc-4d3a14caa2f8@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0126B4065F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 04:57:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MZuMLE5JCSZW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 04:57:38 -0400 (EDT)
Received: from mail-oi0-f67.google.com (mail-oi0-f67.google.com
 [209.85.218.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F333340196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 04:57:37 -0400 (EDT)
Received: by mail-oi0-f67.google.com with SMTP id y207-v6so14180174oie.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 02:10:44 -0700 (PDT)
In-Reply-To: <86da7b47-5026-5ec7-96dc-4d3a14caa2f8@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Linuxarm <linuxarm@huawei.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 July 2018 at 09:54, gengdongjiu <gengdongjiu@huawei.com> wrote:
> Hi peter,
>   Thanks for the review.
>
> On 2018/7/18 0:36, Peter Maydell wrote:
>> How does this capability interact with the KVM_CAP_VCPU_EVENTS
>> API in patch 1? Is it saying "you can specify the ESR via
>> that API", or talking about something else?
>
> The user space will firstly check the  KVM_CAP_VCPU_EVENTS through kvm_has_vcpu_events() to know whether KVM can support get/set vcpu events,
> If KVM supports get/set vcpu events, it will check KVM_CAP_ARM_SET_SERROR_ESR to know whether can set guest SError ESR, as shown the user space code in [1].

OK, so this capability affects the behaviour of
KVM_SET_VCPU_EVENTS. Can you make sure the documentation
of KVM_SET_VCPU_EVENTS clearly explains what happens
and the effect of whether this capability is present,
please? People trying to understand the behaviour of
that ioctl are not going to know that they need to
look here as well.

thanks
-- PMM
