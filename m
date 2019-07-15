Return-Path: <SRS0=W8aC=VM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33323C7618F
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 13:43:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB0612067C
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 13:43:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB0612067C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F0714A49C;
	Mon, 15 Jul 2019 09:43:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WvXzT7qZn9VD; Mon, 15 Jul 2019 09:43:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF3144A4A4;
	Mon, 15 Jul 2019 09:43:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C25D4A49C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 09:43:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QlOATNRid+Dn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jul 2019 09:43:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAC234A3A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 09:43:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 720C228;
 Mon, 15 Jul 2019 06:43:20 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E77153F71F;
 Mon, 15 Jul 2019 06:43:17 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] Support CPU hotplug for ARM64
To: Maran Wilson <maran.wilson@oracle.com>
References: <1561776155-38975-1-git-send-email-wangxiongfeng2@huawei.com>
 <82879258-46a7-a6e9-ee54-fc3692c1cdc3@arm.com>
 <51cc9a5c-9968-c4b1-0bc7-870f44a3a761@oracle.com>
 <06ef13e1-fffe-d4a2-721e-f666f331fb3c@arm.com>
 <d65c2aca-470f-177d-57cf-6375c989054c@oracle.com>
From: James Morse <james.morse@arm.com>
Message-ID: <5f1cba3d-d9aa-b17c-8e10-721ac69b921f@arm.com>
Date: Mon, 15 Jul 2019 14:43:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <d65c2aca-470f-177d-57cf-6375c989054c@oracle.com>
Content-Language: en-GB
Cc: Marc Zyngier <marc.zyngier@arm.com>, john.garry@huawei.com,
 rjw@rjwysocki.net, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-acpi@vger.kernel.org, huawei.libin@huawei.com, guohanjun@huawei.com,
 jonathan.cameron@huawei.com, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Maran,

On 10/07/2019 17:05, Maran Wilson wrote:
> On 7/10/2019 2:15 AM, Marc Zyngier wrote:
>> On 09/07/2019 20:06, Maran Wilson wrote:
>>> On 7/5/2019 3:12 AM, James Morse wrote:
>>>> On 29/06/2019 03:42, Xiongfeng Wang wrote:
>>>>> This patchset mark all the GICC node in MADT as possible CPUs even though it
>>>>> is disabled. But only those enabled GICC node are marked as present CPUs.
>>>>> So that kernel will initialize some CPU related data structure in advance before
>>>>> the CPU is actually hot added into the system. This patchset also implement
>>>>> 'acpi_(un)map_cpu()' and 'arch_(un)register_cpu()' for ARM64. These functions are
>>>>> needed to enable CPU hotplug.
>>>>>
>>>>> To support CPU hotplug, we need to add all the possible GICC node in MADT
>>>>> including those CPUs that are not present but may be hot added later. Those
>>>>> CPUs are marked as disabled in GICC nodes.
>>>> ... what do you need this for?
>>>>
>>>> (The term cpu-hotplug in the arm world almost never means hot-adding a new package/die to
>>>> the platform, we usually mean taking CPUs online/offline for power management. e.g.
>>>> cpuhp_offline_cpu_device())
>>>>
>>>> It looks like you're adding support for hot-adding a new package/die to the platform ...
>>>> but only for virtualisation.
>>>>
>>>> I don't see why this is needed for virtualisation. The in-kernel irqchip needs to know
>>>> these vcpu exist before you can enter the guest for the first time. You can't create them
>>>> late. At best you're saving the host scheduling a vcpu that is offline. Is this really a
>>>> problem?
>>>>
>>>> If we moved PSCI support to user-space, you could avoid creating host vcpu threads until
>>>> the guest brings the vcpu online, which would solve that problem, and save the host
>>>> resources for the thread too. (and its acpi/dt agnostic)
>>>>
>>>> I don't see the difference here between booting the guest with 'maxcpus=1', and bringing
>>>> the vcpu online later. The only real difference seems to be moving the can-be-online
>>>> policy into the hypervisor/VMM...

>>> Isn't that an important distinction from a cloud service provider's
>>> perspective?

Host cpu-time is. Describing this as guest vcpu's is a bit weird.

I'd expect the statement be something like "you're paying for 50% of one Xeon v-whatever".
It shouldn't make a difference if I run 8 vcpus or 2, the amount of cpu-time would still
be constrained by the cloud provider.


>>> As far as I understand it, you also need CPU hotplug capabilities to
>>> support things like Kata runtime under Kubernetes. i.e. when
>>> implementing your containers in the form of light weight VMs for the
>>> additional security ... and the orchestration layer cannot determine
>>> ahead of time how much CPU/memory resources are going to be needed to
>>> run the pod(s).

>> Why would it be any different? You can pre-allocate your vcpus, leave
>> them parked until some external agent decides to signal the container
>> that it it can use another bunch of CPUs. At that point, the container
>> must actively boot these vcpus (they aren't going to come up by magic).
>>
>> Given that you must have sized your virtual platform to deal with the
>> maximum set of resources you anticipate (think of the GIC
>> redistributors, for example), I really wonder what you gain here.

> Maybe I'm not following the alternative proposal completely, but wouldn't a guest VM (who
> happens to be in control of its OS) be able to add/online vCPU resources without approval
> from the VMM this way?

The in-kernel PSCI implementation will allow all CPUs to be online/offline. If we moved
that support to the VMM, it could apply some policy as to whether a cpu-online call
succeeds or fails.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
