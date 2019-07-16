Return-Path: <SRS0=eCDF=VN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFDCC76192
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 07:59:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F0C3206C2
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 07:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bVylv0GH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F0C3206C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 285214A4C1;
	Tue, 16 Jul 2019 03:59:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MF+oosjrPnFb; Tue, 16 Jul 2019 03:59:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00F5C4A4FC;
	Tue, 16 Jul 2019 03:59:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41FE64A4C1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 03:59:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hkMezHRWFAOH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jul 2019 03:59:33 -0400 (EDT)
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
 [209.85.210.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3B784A479
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 03:59:32 -0400 (EDT)
Received: by mail-pf1-f194.google.com with SMTP id g2so8718016pfq.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 00:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:cc:references:from:organization:message-id:date
 :user-agent:mime-version:in-reply-to:content-transfer-encoding;
 bh=wDfDJUQ8Kh24S4w4S2kYx9iH7GvKV6D4nFcrENbi2ME=;
 b=bVylv0GH5JJtwmXvJMyJ+I3QIJ0Yz+/V/yjBw8RctIo327Ov1tlt3RDrlw9RCHtkvS
 ZCrtNbd5DaUZyz/7G+X9HauKl5Cq76wJryN64l0pNQSqWSw6d101rS564h2h/7R4YhY3
 qMzRupey3BXSiOE9fri8g3c6QpBnwqVO9hv7ptplaeXN94OYLAChrfEUkSSfpyd8RxIy
 xGKJR2K46hbZnFpLL3XkD5zWHB6lFZEmRPFNz3MRXjH7HKlJyACmPMYaf5/8XyL6EX6w
 v7JZt2G/vw/JKkkFG42lyrVBPgMT2d2oS46Z5SExYBpu0neWDO7YTaDjUUuxelZt4Cxs
 PBjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding;
 bh=wDfDJUQ8Kh24S4w4S2kYx9iH7GvKV6D4nFcrENbi2ME=;
 b=KK91ErkF9FgUd2OZY071IUiMLIXTtHkD1gYunVJxN8XbdIuim37TYl3VcqKc1wrvDI
 ZHqG/prRfuCjzL3cfFSyMaXdU8D7h87QCd9ZwDkefuYyfyb1yQ0S5QMpe0M4TN2JVz6x
 Fy28KU7dfsLFF20otZYIm8AukMi+nt6MApNnodh3UyXlWCFLPm36GjXrDPKSbSpSl2mB
 /eXZ+98ElszDJWnmb+M24C/PnClCE8uBxy/tgQmzWsSeqk8+QaOiEth2IRHrhlz84Roy
 k3g7oKaPa9dAD+7ZWpWjXvS6sWRIygueDK6OeMFevWfDl3BKvL0FxtWHzdDJTztxGi5Y
 EARA==
X-Gm-Message-State: APjAAAWvjbK/x8h3Z6Zl/G5Y7mf6ttg0x8ZH5fC20rp7KSq7EJFqW/lg
 0Gc+n9O2S3e6gWH5mD/1UIM=
X-Google-Smtp-Source: APXvYqzwX0ZLCeqZ1Sou3FMes0IK5sTjahJt7/OI8UrRbZeOJe3vZb/j+KyXrbHYBs18ucoIipgRjA==
X-Received: by 2002:a17:90a:8d0c:: with SMTP id
 c12mr33210399pjo.140.1563263972001; 
 Tue, 16 Jul 2019 00:59:32 -0700 (PDT)
Received: from [0.0.0.0] (104.129.187.94.16clouds.com. [104.129.187.94])
 by smtp.gmail.com with ESMTPSA id o128sm23093652pfb.42.2019.07.16.00.59.21
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 16 Jul 2019 00:59:31 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] Support CPU hotplug for ARM64
To: Marc Zyngier <marc.zyngier@arm.com>,
 Maran Wilson <maran.wilson@oracle.com>, James Morse <james.morse@arm.com>,
 Xiongfeng Wang <wangxiongfeng2@huawei.com>
References: <1561776155-38975-1-git-send-email-wangxiongfeng2@huawei.com>
 <82879258-46a7-a6e9-ee54-fc3692c1cdc3@arm.com>
 <51cc9a5c-9968-c4b1-0bc7-870f44a3a761@oracle.com>
 <06ef13e1-fffe-d4a2-721e-f666f331fb3c@arm.com>
From: Jia He <jiakernel2@gmail.com>
Organization: ARM
Message-ID: <1a7b2f39-ca77-5b5f-cbb5-6356e51b0d7a@gmail.com>
Date: Tue, 16 Jul 2019 15:59:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <06ef13e1-fffe-d4a2-721e-f666f331fb3c@arm.com>
Cc: guohanjun@huawei.com, john.garry@huawei.com, rjw@rjwysocki.net,
 linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 huawei.libin@huawei.com, jonathan.cameron@huawei.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc

On 2019/7/10 17:15, Marc Zyngier wrote:
> On 09/07/2019 20:06, Maran Wilson wrote:
>> On 7/5/2019 3:12 AM, James Morse wrote:
>>> Hi guys,
>>>
>>> (CC: +kvmarm list)
>>>
>>> On 29/06/2019 03:42, Xiongfeng Wang wrote:
>>>> This patchset mark all the GICC node in MADT as possible CPUs even though it
>>>> is disabled. But only those enabled GICC node are marked as present CPUs.
>>>> So that kernel will initialize some CPU related data structure in advance before
>>>> the CPU is actually hot added into the system. This patchset also implement
>>>> 'acpi_(un)map_cpu()' and 'arch_(un)register_cpu()' for ARM64. These functions are
>>>> needed to enable CPU hotplug.
>>>>
>>>> To support CPU hotplug, we need to add all the possible GICC node in MADT
>>>> including those CPUs that are not present but may be hot added later. Those
>>>> CPUs are marked as disabled in GICC nodes.
>>> ... what do you need this for?
>>>
>>> (The term cpu-hotplug in the arm world almost never means hot-adding a new package/die to
>>> the platform, we usually mean taking CPUs online/offline for power management. e.g.
>>> cpuhp_offline_cpu_device())
>>>
>>> It looks like you're adding support for hot-adding a new package/die to the platform ...
>>> but only for virtualisation.
>>>
>>> I don't see why this is needed for virtualisation. The in-kernel irqchip needs to know
>>> these vcpu exist before you can enter the guest for the first time. You can't create them
>>> late. At best you're saving the host scheduling a vcpu that is offline. Is this really a
>>> problem?
>>>
>>> If we moved PSCI support to user-space, you could avoid creating host vcpu threads until
>>> the guest brings the vcpu online, which would solve that problem, and save the host
>>> resources for the thread too. (and its acpi/dt agnostic)
>>>
>>> I don't see the difference here between booting the guest with 'maxcpus=1', and bringing
>>> the vcpu online later. The only real difference seems to be moving the can-be-online
>>> policy into the hypervisor/VMM...
>> Isn't that an important distinction from a cloud service provider's
>> perspective?
>>
>> As far as I understand it, you also need CPU hotplug capabilities to
>> support things like Kata runtime under Kubernetes. i.e. when
>> implementing your containers in the form of light weight VMs for the
>> additional security ... and the orchestration layer cannot determine
>> ahead of time how much CPU/memory resources are going to be needed to
>> run the pod(s).
> Why would it be any different? You can pre-allocate your vcpus, leave
> them parked until some external agent decides to signal the container
> that it it can use another bunch of CPUs. At that point, the container
> must actively boot these vcpus (they aren't going to come up by magic).
>
> Given that you must have sized your virtual platform to deal with the
> maximum set of resources you anticipate (think of the GIC
> redistributors, for example), I really wonder what you gain here.
I agree with your point in GIC aspect. It will mess up things if it makes

GIC resource hotpluggable in qemu. But it also would be better that vmm

only startup limited vcpu thread resource.

How about:

1. qemu only starts only N vcpu thread (-smp N, maxcpus=M)

2. qemu reserves the GIC resource with maxium M vcpu number

3. when qmp cmd cpu hotplug-add is triggerred, send a GED event to guest kernel

4. guest kernel recv it and trigger the acpi plug process.

Currently ACPI_CPU_HOTPLUG is enabled for Kconfig but completely not workable.


---
Cheers,
Jia
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
