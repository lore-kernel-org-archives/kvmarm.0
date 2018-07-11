From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 1/4] arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
Date: Wed, 11 Jul 2018 08:45:11 +0100
Message-ID: <1cbb0f3f-1bc4-5205-d28c-1843d09a702e@arm.com>
References: <20180710164952.23736-1-james.morse@arm.com>
 <20180710164952.23736-2-james.morse@arm.com>
 <b0eb95f3-7905-8aab-f816-529c17f07e04@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2FCB4A0C9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jul 2018 03:32:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8y16Pbvh9GVu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jul 2018 03:32:28 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A43CF49E14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jul 2018 03:32:28 -0400 (EDT)
In-Reply-To: <b0eb95f3-7905-8aab-f816-529c17f07e04@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linuxarm@huawei.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/07/18 07:48, gengdongjiu wrote:
> Hi, James,
> 
> [...]
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index d10944e619d3..e3940f8715a5 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -835,11 +835,13 @@ struct kvm_clock_data {
>>  
>>  Capability: KVM_CAP_VCPU_EVENTS
>>  Extended by: KVM_CAP_INTR_SHADOW
>> -Architectures: x86
>> -Type: vm ioctl
>> +Architectures: x86, arm64
> 
>    In my previous patch, I only add the arm64 support, now you add patches to support arm32 platform,
>    so you can add "ARM" to the Architectures, for example: "Architectures: x86, ARM, arm64"

That should be the job of the last patch, shouldn't it? At this point in
the series, there is no 32bit support whatsoever.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
