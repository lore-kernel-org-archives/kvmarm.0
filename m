Return-Path: <SRS0=5C08=FU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B682C4361B
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 11:40:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE0F123381
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 11:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE0F123381
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CFBB4B4AF;
	Wed, 16 Dec 2020 06:40:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SRaVuJ+hDi8F; Wed, 16 Dec 2020 06:40:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 088B44B4C4;
	Wed, 16 Dec 2020 06:40:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A0334B4C9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 06:40:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zxUXhDnBulRi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2020 06:40:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF3C4B4C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 06:40:43 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7591131B;
 Wed, 16 Dec 2020 03:40:42 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBFBD3F66B;
 Wed, 16 Dec 2020 03:40:41 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 08/10] arm/arm64: gic: Split check_acked()
 into two functions
To: Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-9-alexandru.elisei@arm.com>
 <0eb98cb0-835c-e257-484e-8210f1279f2c@redhat.com>
 <2b8d774e-9398-e24b-6989-8643f5dd2492@arm.com>
 <b5ccedb2-5f8d-50d5-8caf-776013613d90@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a01f61cf-d174-87b7-4db1-32b62a2c3e8a@arm.com>
Date: Wed, 16 Dec 2020 11:40:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <b5ccedb2-5f8d-50d5-8caf-776013613d90@redhat.com>
Content-Language: en-US
Cc: andre.przywara@arm.com
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

Hi Eric,

On 12/15/20 1:58 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 12/10/20 3:45 PM, Alexandru Elisei wrote:
>> Hi Eric,
>>
>> On 12/3/20 1:39 PM, Auger Eric wrote:
>>> [..]
>>>  
>>>  static void check_spurious(void)
>>> @@ -300,7 +318,8 @@ static void ipi_test_self(void)
>>>  	cpumask_clear(&mask);
>>>  	cpumask_set_cpu(smp_processor_id(), &mask);
>>>  	gic->ipi.send_self();
>>> -	check_acked("IPI: self", &mask);
>>> +	wait_for_interrupts(&mask);
>>> +	report(check_acked(&mask), "Interrupts received");
>>>  	report_prefix_pop();
>>>  }
>>>  
>>> @@ -315,7 +334,8 @@ static void ipi_test_smp(void)
>>>  	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
>>>  		cpumask_clear_cpu(i, &mask);
>>>  	gic_ipi_send_mask(IPI_IRQ, &mask);
>>> -	check_acked("IPI: directed", &mask);
>>> +	wait_for_interrupts(&mask);
>>> +	report(check_acked(&mask), "Interrupts received");
>>> both ipi_test_smp and ipi_test_self are called from the same test so
>>> better to use different error messages like it was done originally.
>> I used the same error message because the tests have a different prefix
>> ("target-list" versus "broadcast"). Do you think there are cases where that's not
>> enough?
> I think in "ipi" test,
> ipi_test -> ipi_send -> ipi_test_self, ipi_test_smp

I'm afraid I don't understand what you are trying to say. This is the log for the
gicv3-ipi test:

$ cat logs/gicv3-ipi.log
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine
virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device
virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none
-serial stdio -kernel arm/gic.flat -smp 6 -machine gic-version=3 -append ipi #
-initrd /tmp/tmp.trk6aAcaZx
WARNING: early print support may not work. Found uart at 0x9000000, but early base
is 0x3f8.
PASS: gicv3: ipi: self: Interrupts received
PASS: gicv3: ipi: target-list: Interrupts received
PASS: gicv3: ipi: broadcast: Interrupts received
SUMMARY: 3 tests

The warning is because I forgot to reconfigure the tests with --vmm=qemu.

Would you mind pointing out what you think is ambiguous?

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
