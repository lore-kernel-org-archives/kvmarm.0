Return-Path: <SRS0=5C08=FU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7415EC4361B
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 12:37:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D561623124
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 12:37:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D561623124
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB414B4CE;
	Wed, 16 Dec 2020 07:37:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IzlDye2rOS3P; Wed, 16 Dec 2020 07:37:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F02B54B4B9;
	Wed, 16 Dec 2020 07:37:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C11604B482
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 07:37:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R+aqB37lWwI6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2020 07:37:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD59E4B369
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 07:37:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1608122251;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oABMoOhptkaqKsqL4N/pdk2T+GrxPZ3e3Rs5s0jG0lQ=;
 b=Wpij8qNNXtr5NE/KZqWYNRd2QMCs8B0Y8Gr9iUe95wFHLHNsUzJAVF2+6jF8hyJr4R8tkH
 VshUNYSkskGVA4t3NAFv/v0WbXsbkpCVJ2yjq/fqDlcA0PQnMT+oV/oLBvXtL9oVKquxye
 Xx88CaQ+gp2ik7Glq/3zjSna3alXcOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-_kHs0LayO4uj6OSt2HP73A-1; Wed, 16 Dec 2020 07:37:27 -0500
X-MC-Unique: _kHs0LayO4uj6OSt2HP73A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B44E1005504;
 Wed, 16 Dec 2020 12:37:26 +0000 (UTC)
Received: from [10.36.112.243] (ovpn-112-243.ams2.redhat.com [10.36.112.243])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 759265D9E8;
 Wed, 16 Dec 2020 12:37:23 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 08/10] arm/arm64: gic: Split check_acked()
 into two functions
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-9-alexandru.elisei@arm.com>
 <0eb98cb0-835c-e257-484e-8210f1279f2c@redhat.com>
 <2b8d774e-9398-e24b-6989-8643f5dd2492@arm.com>
 <b5ccedb2-5f8d-50d5-8caf-776013613d90@redhat.com>
 <a01f61cf-d174-87b7-4db1-32b62a2c3e8a@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <08ba32cf-0a6f-79d9-fb53-a84205cae4b1@redhat.com>
Date: Wed, 16 Dec 2020 13:37:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a01f61cf-d174-87b7-4db1-32b62a2c3e8a@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Hi Alexandru,

On 12/16/20 12:40 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 12/15/20 1:58 PM, Auger Eric wrote:
>> Hi Alexandru,
>>
>> On 12/10/20 3:45 PM, Alexandru Elisei wrote:
>>> Hi Eric,
>>>
>>> On 12/3/20 1:39 PM, Auger Eric wrote:
>>>> [..]
>>>>  
>>>>  static void check_spurious(void)
>>>> @@ -300,7 +318,8 @@ static void ipi_test_self(void)
>>>>  	cpumask_clear(&mask);
>>>>  	cpumask_set_cpu(smp_processor_id(), &mask);
>>>>  	gic->ipi.send_self();
>>>> -	check_acked("IPI: self", &mask);
>>>> +	wait_for_interrupts(&mask);
>>>> +	report(check_acked(&mask), "Interrupts received");
>>>>  	report_prefix_pop();
>>>>  }
>>>>  
>>>> @@ -315,7 +334,8 @@ static void ipi_test_smp(void)
>>>>  	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
>>>>  		cpumask_clear_cpu(i, &mask);
>>>>  	gic_ipi_send_mask(IPI_IRQ, &mask);
>>>> -	check_acked("IPI: directed", &mask);
>>>> +	wait_for_interrupts(&mask);
>>>> +	report(check_acked(&mask), "Interrupts received");
>>>> both ipi_test_smp and ipi_test_self are called from the same test so
>>>> better to use different error messages like it was done originally.
>>> I used the same error message because the tests have a different prefix
>>> ("target-list" versus "broadcast"). Do you think there are cases where that's not
>>> enough?
>> I think in "ipi" test,
>> ipi_test -> ipi_send -> ipi_test_self, ipi_test_smp
> 
> I'm afraid I don't understand what you are trying to say. This is the log for the
> gicv3-ipi test:
> 
> $ cat logs/gicv3-ipi.log
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine
> virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device
> virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none
> -serial stdio -kernel arm/gic.flat -smp 6 -machine gic-version=3 -append ipi #
> -initrd /tmp/tmp.trk6aAcaZx
> WARNING: early print support may not work. Found uart at 0x9000000, but early base
> is 0x3f8.
> PASS: gicv3: ipi: self: Interrupts received
> PASS: gicv3: ipi: target-list: Interrupts received
> PASS: gicv3: ipi: broadcast: Interrupts received
> SUMMARY: 3 tests
> 
> The warning is because I forgot to reconfigure the tests with --vmm=qemu.
> 
> Would you mind pointing out what you think is ambiguous?
Hum sorry I did not pay attention to the report_prefix_push() within
ipi_test_self & ipi_test_smp. I had in mind those were only in the main().

Forgive me for the noise

Eric
> 
> Thanks,
> 
> Alex
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
