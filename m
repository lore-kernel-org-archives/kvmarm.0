Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22AEC48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 09:45:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D4C2613ED
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 09:45:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D4C2613ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8767B4B08C;
	Tue, 15 Jun 2021 05:45:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6F0-1wxKoI9a; Tue, 15 Jun 2021 05:45:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C208A4B0E4;
	Tue, 15 Jun 2021 05:45:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D36DC49DE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 23:21:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QXhT94gOYpGo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 23:21:20 -0400 (EDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F5CC40CF8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 23:21:20 -0400 (EDT)
Received: from mail-pf1-f200.google.com ([209.85.210.200])
 by youngberry.canonical.com with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.93)
 (envelope-from <po-hsu.lin@canonical.com>) id 1lszde-0006M9-PN
 for kvmarm@lists.cs.columbia.edu; Tue, 15 Jun 2021 03:21:18 +0000
Received: by mail-pf1-f200.google.com with SMTP id
 p42-20020a056a000a2ab02902f33d81f23fso9443748pfh.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 20:21:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Y27UbtFOQ8c39eVLx06R3uWLnW6dhZQzs0wPAm5K83o=;
 b=ZxTkAaoeH9rhKowgcybYTa3+Ae4fpzV12QYp+UBOxgFDqBHYPutBTSQuDE2xm6ZORD
 bwZryKRvhmCxBUtqiRSMAnjx2GZK/zDdmJXDwwEXClKPuPi026X0CIXIDJ7V3hQ5gTI9
 HTEBVFVeWLN8rgpM6DRD1XJT9c+MlSQYFCkal7X570lmBxgyWfvQQBbkahR1xGq6IAiL
 +d18r9fiB/hEhCGEQgw5E/ksKsLMYx9fU2wGFuk2PqhG+pjWL83gpkAll6FDz9eilg+h
 LIdOe42tsd88Y00AW041ieJSsejDGPUswwqlen3uU3AvYJ3Um1MudFSnNny5nzEs+ep0
 mF0A==
X-Gm-Message-State: AOAM530Mc+WauBJq7ah6sc6VdCHBS4GYX9KMhx8uDHAZ7u6EgnvBHWX3
 IrNchNFdPnitJ2+24l8j1fsJXXk+xUTTO5kXRC/H/GKDyD4buYp2IIdu4m7nZk/T93ab1BLwb1t
 P33Eeqplsg++GtQnDSJWQM5y6J8l1G34rRb7TFjrDRU7X0W8l+YbdKF3G
X-Received: by 2002:a62:3344:0:b029:25e:a0a8:1c51 with SMTP id
 z65-20020a6233440000b029025ea0a81c51mr2260513pfz.58.1623727277196; 
 Mon, 14 Jun 2021 20:21:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzexSvriwW6xx6lNJddJMvfRC0bGnFI1v9u8YQnjAImetW0yirOAeb6eRv6xa0GzZf8Zx3jXavguowXoco3M7U=
X-Received: by 2002:a62:3344:0:b029:25e:a0a8:1c51 with SMTP id
 z65-20020a6233440000b029025ea0a81c51mr2260481pfz.58.1623727276783; Mon, 14
 Jun 2021 20:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
 <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
In-Reply-To: <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date: Tue, 15 Jun 2021 11:21:05 +0800
Message-ID: <CAMy_GT9Y1JNyh5GkZm31RQ6nX8Jv9qHFRN2KeOe01GOyk2ifQg@mail.gmail.com>
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
To: Andrew Jones <drjones@redhat.com>
X-Mailman-Approved-At: Tue, 15 Jun 2021 05:45:20 -0400
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

On Fri, Nov 20, 2020 at 8:35 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
> > When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
> > the Cortex-a53 cores) the its-migration test hangs. In the log file I see:
> >
> > run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> > -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> > virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd
> > -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 6
> > -machine gic-version=3 -append its-migration # -initrd /tmp/tmp.OrlQiorBpY
> > ITS: MAPD devid=2 size = 0x8 itt=0x40420000 valid=1
> > ITS: MAPD devid=7 size = 0x8 itt=0x40430000 valid=1
> > MAPC col_id=3 target_addr = 0x30000 valid=1
> > MAPC col_id=2 target_addr = 0x20000 valid=1
> > INVALL col_id=2
> > INVALL col_id=3
> > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > Now migrate the VM, then press a key to continue...
> > scripts/arch-run.bash: line 103: 48549 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      48550 Segmentation fault      (core dumped) | ncat -U $1
> > scripts/arch-run.bash: line 103: 48568 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      48569 Segmentation fault      (core dumped) | ncat -U $1
> > scripts/arch-run.bash: line 103: 48583 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      48584 Segmentation fault      (core dumped) | ncat -U $1
> > [..]
> > scripts/arch-run.bash: line 103: 49414 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      49415 Segmentation fault      (core dumped) | ncat -U $1
> > qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
> > qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
> > scripts/arch-run.bash: line 103: 49430 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> >      49431 Segmentation fault      (core dumped) | ncat -U $1
> > scripts/arch-run.bash: line 103: 49445 Done                    echo '{ "execute":
> > "qmp_capabilities" }{ "execute":' "$2" '}'
> > [..]
>
> Is your ncat segfaulting? It looks like it from this output. Have you
> tried running your ncat with a UNIX socket independently of this test?
>
> Is this the first time you've tried this test in this environment, or
> is this a regression for you?
>
> >
> > If I run the test manually:
> >
> > $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
> > 'its-migration'
>
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
> >
> > /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
> > -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
> > testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> > arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
> > /tmp/tmp.OtsTj3QD4J
> > ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
> > ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
> > MAPC col_id=3 target_addr = 0x30000 valid=1
> > MAPC col_id=2 target_addr = 0x20000 valid=1
> > INVALL col_id=2
> > INVALL col_id=3
> > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > Now migrate the VM, then press a key to continue...
> >
> > And the test hangs here after I press a key.
>
> The test doesn't get your input because of the '</dev/null' in run_qemu(),
> which ./arm-run calls. So it's not hanging it's just waiting forever on
> the key press.
Hello Andrew,
We have found this waiting for key press issue on our side as well
[1], the test will fail with TIMEOUT, it looks like it's not getting
my input like you mentioned here.
I would like to ask what is the expected behaviour of these migration
related tests (its-pending-migration / its-migration /
its-migrate-unmapped-collection)? Should they pass right after the
tester hit a key?
Also, if these test would require user interaction, should they be
moved to some special group like 'nodefault' to prevent it from
failing with timeout in automated tests?

I tried to remove '</dev/null' in 'errors=$("${@}" $INITRD </dev/null
2> >(tee /dev/stderr) > /dev/fd/$stdout)' from script/arch-run.bash
and run it again, and found out that if you wait to see that 'Now
migrate the VM, then press a key to continue...' prompt, it's too late
for the test to catch your key press. You will have to press any key
right after the test started. However although the test will pass, it
won't be terminated properly but keep complaining about "Ncat:
Connection refused." until I hit ctrl + c. Not sure if this is
expected?

$ uname -a
Linux kuzzle 5.11.0-18-generic #19-Ubuntu SMP Fri May 7 14:21:20 UTC
2021 aarch64 aarch64 aarch64 GNU/Linux
$ sudo ./its-migration
BUILD_HEAD=90a7d30e
k (my key press)
run_migration timeout -k 1s --foreground 90s
/usr/bin/qemu-system-aarch64 -nodefaults -machine
virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device
-device virtconsole,chardev=ctd -chardev testdev,id=ctd -device
pci-testdev -display none -serial stdio -kernel /tmp/tmp.HhCjbIcns7
-smp 32 -machine gic-version=3 -append its-migration # -initrd
/tmp/tmp.AyirrSboiF
ITS: MAPD devid=2 size = 0x8 itt=0x408d0000 valid=1
ITS: MAPD devid=7 size = 0x8 itt=0x408e0000 valid=1
MAPC col_id=3 target_addr = 0x30000 valid=1
MAPC col_id=2 target_addr = 0x20000 valid=1
INVALL col_id=2
INVALL col_id=3
MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
Now migrate the VM, then press a key to continue...
INFO: gicv3: its-migration: Migration complete
INT dev_id=2 event_id=20
PASS: gicv3: its-migration: dev2/eventid=20 triggers LPI 8195 on PE #3
after migration
INT dev_id=7 event_id=255
PASS: gicv3: its-migration: dev7/eventid=255 triggers LPI 8196 on PE
#2 after migration
SUMMARY: 2 tests
Ncat: Connection refused.
Ncat: Connection refused.
Ncat: Connection refused.

Ncat: Version 7.80

Thanks!
PHLin

[1] https://bugs.launchpad.net/ubuntu-kernel-tests/+bug/1931680

>
> Thanks,
> drew
>
> >
> > Package versions:
> >
> > $ ncat --version
> > Ncat: Version 7.91 ( https://nmap.org/ncat )
> >
> > $ /usr/bin/qemu-system-aarch64 --version
> > QEMU emulator version 5.1.0
> > Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
> >
> > $ uname -a
> > Linux rockpro 5.10.0-rc4 #33 SMP PREEMPT Thu Nov 19 15:58:57 GMT 2020 aarch64
> > GNU/Linux
> >
> > Thanks,
> >
> > Alex
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
