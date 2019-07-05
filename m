Return-Path: <SRS0=Y16Y=VC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1CEC46499
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jul 2019 10:12:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A4B362082F
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jul 2019 10:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4B362082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 117AA4005D;
	Fri,  5 Jul 2019 06:12:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u1w2IUrHdtSE; Fri,  5 Jul 2019 06:12:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF7A74A36B;
	Fri,  5 Jul 2019 06:12:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 655F24A32E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jul 2019 06:12:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UAVh-41Wr+JG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jul 2019 06:12:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26AF34005D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jul 2019 06:12:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EC872B;
 Fri,  5 Jul 2019 03:12:10 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 779B73F703;
 Fri,  5 Jul 2019 03:12:08 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] Support CPU hotplug for ARM64
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
References: <1561776155-38975-1-git-send-email-wangxiongfeng2@huawei.com>
From: James Morse <james.morse@arm.com>
Message-ID: <82879258-46a7-a6e9-ee54-fc3692c1cdc3@arm.com>
Date: Fri, 5 Jul 2019 11:12:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1561776155-38975-1-git-send-email-wangxiongfeng2@huawei.com>
Content-Language: en-GB
Cc: jonathan.cameron@huawei.com, john.garry@huawei.com, rjw@rjwysocki.net,
 linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 huawei.libin@huawei.com, guohanjun@huawei.com, kvmarm@lists.cs.columbia.edu,
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

Hi guys,

(CC: +kvmarm list)

On 29/06/2019 03:42, Xiongfeng Wang wrote:
> This patchset mark all the GICC node in MADT as possible CPUs even though it
> is disabled. But only those enabled GICC node are marked as present CPUs.
> So that kernel will initialize some CPU related data structure in advance before
> the CPU is actually hot added into the system. This patchset also implement 
> 'acpi_(un)map_cpu()' and 'arch_(un)register_cpu()' for ARM64. These functions are
> needed to enable CPU hotplug.
> 
> To support CPU hotplug, we need to add all the possible GICC node in MADT
> including those CPUs that are not present but may be hot added later. Those
> CPUs are marked as disabled in GICC nodes.

... what do you need this for?

(The term cpu-hotplug in the arm world almost never means hot-adding a new package/die to
the platform, we usually mean taking CPUs online/offline for power management. e.g.
cpuhp_offline_cpu_device())

It looks like you're adding support for hot-adding a new package/die to the platform ...
but only for virtualisation.

I don't see why this is needed for virtualisation. The in-kernel irqchip needs to know
these vcpu exist before you can enter the guest for the first time. You can't create them
late. At best you're saving the host scheduling a vcpu that is offline. Is this really a
problem?

If we moved PSCI support to user-space, you could avoid creating host vcpu threads until
the guest brings the vcpu online, which would solve that problem, and save the host
resources for the thread too. (and its acpi/dt agnostic)

I don't see the difference here between booting the guest with 'maxcpus=1', and bringing
the vcpu online later. The only real difference seems to be moving the can-be-online
policy into the hypervisor/VMM...


I think physical package/die hotadd is a much bigger, uglier problem than doing the same
under virtualisation. Its best to do this on real hardware first so we don't miss
something. (cpu-topology, numa, memory, errata, timers?)
I'm worried that doing virtualisation first means the firmware-requirements for physical
hotadd stuff is "whatever Qemu does".


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
