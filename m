Return-Path: <SRS0=rD/S=E2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CFFC56202
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 13:33:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D5B1222BA
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 13:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D5B1222BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE3EF4B3AE;
	Fri, 20 Nov 2020 08:33:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8PVa4pdbtHhY; Fri, 20 Nov 2020 08:33:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D5494B38A;
	Fri, 20 Nov 2020 08:33:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7616F4B384
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 08:33:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lfaiIAi-4LQ5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Nov 2020 08:33:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CA714B383
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 08:33:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8990C11D4;
 Fri, 20 Nov 2020 05:33:07 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC8423F718;
 Fri, 20 Nov 2020 05:33:06 -0800 (PST)
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
To: Andrew Jones <drjones@redhat.com>
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
 <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1dd15f28-2201-7061-7227-52f0eea9715f@arm.com>
Date: Fri, 20 Nov 2020 13:34:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
Content-Language: en-US
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 kvm@vger.kernel.org
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

Hi,

On 11/20/20 12:34 PM, Andrew Jones wrote:
> On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
>> When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
>> the Cortex-a53 cores) the its-migration test hangs.[..]
> Is your ncat segfaulting? It looks like it from this output. Have you
> tried running your ncat with a UNIX socket independently of this test?
>
> Is this the first time you've tried this test in this environment, or
> is this a regression for you?

Looks like it's a regression in nmap. I downgraded to nmap 7.80 and the test
passes, thank you for the help!

>
>> If I run the test manually:
>>
>> $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
>> 'its-migration'
> This won't work because we need run_tests.sh to setup the run_migration()
> call. The only ways to run migration tests separately are
>
>  $ ./run_tests.sh its-migration
>
> and
>
>  $ tests/its-migration
>
> For the second one you need to do 'make standalone' first.
>
>
>> /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
>> -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
>> testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
>> arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
>> /tmp/tmp.OtsTj3QD4J
>> ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
>> ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
>> MAPC col_id=3 target_addr = 0x30000 valid=1
>> MAPC col_id=2 target_addr = 0x20000 valid=1
>> INVALL col_id=2
>> INVALL col_id=3
>> MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
>> MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
>> Now migrate the VM, then press a key to continue...
>>
>> And the test hangs here after I press a key.
> The test doesn't get your input because of the '</dev/null' in run_qemu(),
> which ./arm-run calls. So it's not hanging it's just waiting forever on
> the key press.

I see, thanks for the explanation!

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
