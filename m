Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC29DC48BE8
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 09:45:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A4CF613B1
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 09:45:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A4CF613B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 022D94B0D0;
	Tue, 15 Jun 2021 05:45:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OUat1OOg+9dX; Tue, 15 Jun 2021 05:45:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AFDA4B0D2;
	Tue, 15 Jun 2021 05:45:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D76894B0D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 03:11:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZQijj6R6zJAa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 03:11:53 -0400 (EDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DB744B0C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 03:11:53 -0400 (EDT)
Received: from mail-pg1-f198.google.com ([209.85.215.198])
 by youngberry.canonical.com with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.93)
 (envelope-from <po-hsu.lin@canonical.com>) id 1lt3Em-0003yJ-Dl
 for kvmarm@lists.cs.columbia.edu; Tue, 15 Jun 2021 07:11:52 +0000
Received: by mail-pg1-f198.google.com with SMTP id
 k5-20020a63ba050000b029021ab84617c0so8219811pgf.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 00:11:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2Qb3ysqAza+UPnoJVtgVxN/FG+TvGSi39emS10tXHpM=;
 b=VZ+PlFmlYVR/JwopwrYexzx+wwoaN+NzOJVNwGx0miF8SIsmOtQRiz4HBjU/fzYB0X
 JS1oZpfD9/zF99mU1sRLOL5UgKpSftGLBXxp9Cc7i8xWXvbO4w29VHIwKBl3H/0eE8Ic
 4g52CNWR/UU5dIberDMiqDOslzrH6XlkRsvMNnYojnypwVNOWTxz+9OF30OmU5CvM0q9
 RfkBlEA/NdfMAXtsssK81xCY3f857CxNNqdPVHqD1Uls06rLAE1JwDYXzBhHUeB8wZU0
 BlIvVxpHHdhDKR3jo9CMK97M8Vz1TvQWFFEcS8mG6HUbcCM6gPMUDHmbl0PIG4LUjYYy
 bWdA==
X-Gm-Message-State: AOAM5331ToxIwcYjhTnNxYXR6x1CawT9cf06B4WPWsaeLbtJOVa1RP2e
 4pKrD+homsANoEduaQM/U6ucowGqAOpIumcctBZBSSpRtuC8tassScIPUxCaMmKCJ8aAe+PTGTv
 zKuc57migu9nN2uDyh7PBdN4BmjgkQjAWf11TRBPnei5e3fZhRXE23DLI
X-Received: by 2002:a63:616:: with SMTP id 22mr20751373pgg.291.1623741110995; 
 Tue, 15 Jun 2021 00:11:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUXnua3vmCibmdhVl5Y2gtwMroxSMuD9B6kPUKMf57uEZwaHPBB7WPU/2qd7+Ysk+hIRLyDV84AoeesQWVSjI=
X-Received: by 2002:a63:616:: with SMTP id 22mr20751344pgg.291.1623741110559; 
 Tue, 15 Jun 2021 00:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
 <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
 <CAMy_GT9Y1JNyh5GkZm31RQ6nX8Jv9qHFRN2KeOe01GOyk2ifQg@mail.gmail.com>
 <20210615063659.7w2rp6jk76rhgeue@gator.home>
In-Reply-To: <20210615063659.7w2rp6jk76rhgeue@gator.home>
From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date: Tue, 15 Jun 2021 15:11:39 +0800
Message-ID: <CAMy_GT_jegx-EO20ktpBZrrdM_Q4cTaZmPSZfK2eyowonRNH3g@mail.gmail.com>
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

On Tue, Jun 15, 2021 at 2:37 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Tue, Jun 15, 2021 at 11:21:05AM +0800, Po-Hsu Lin wrote:
> > On Fri, Nov 20, 2020 at 8:35 PM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
> > > > When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
> > > > the Cortex-a53 cores) the its-migration test hangs. In the log file I see:
> > > >
> > > > run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> > > > -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> > > > virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd
> > > > -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 6
> > > > -machine gic-version=3 -append its-migration # -initrd /tmp/tmp.OrlQiorBpY
> > > > ITS: MAPD devid=2 size = 0x8 itt=0x40420000 valid=1
> > > > ITS: MAPD devid=7 size = 0x8 itt=0x40430000 valid=1
> > > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > > INVALL col_id=2
> > > > INVALL col_id=3
> > > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > > Now migrate the VM, then press a key to continue...
> > > > scripts/arch-run.bash: line 103: 48549 Done                    echo '{ "execute":
> > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > >      48550 Segmentation fault      (core dumped) | ncat -U $1
> > > > scripts/arch-run.bash: line 103: 48568 Done                    echo '{ "execute":
> > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > >      48569 Segmentation fault      (core dumped) | ncat -U $1
> > > > scripts/arch-run.bash: line 103: 48583 Done                    echo '{ "execute":
> > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > >      48584 Segmentation fault      (core dumped) | ncat -U $1
> > > > [..]
> > > > scripts/arch-run.bash: line 103: 49414 Done                    echo '{ "execute":
> > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > >      49415 Segmentation fault      (core dumped) | ncat -U $1
> > > > qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
> > > > qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
> > > > scripts/arch-run.bash: line 103: 49430 Done                    echo '{ "execute":
> > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > >      49431 Segmentation fault      (core dumped) | ncat -U $1
> > > > scripts/arch-run.bash: line 103: 49445 Done                    echo '{ "execute":
> > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > [..]
> > >
> > > Is your ncat segfaulting? It looks like it from this output. Have you
> > > tried running your ncat with a UNIX socket independently of this test?
> > >
> > > Is this the first time you've tried this test in this environment, or
> > > is this a regression for you?
> > >
> > > >
> > > > If I run the test manually:
> > > >
> > > > $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
> > > > 'its-migration'
> > >
> > > This won't work because we need run_tests.sh to setup the run_migration()
> > > call. The only ways to run migration tests separately are
> > >
> > >  $ ./run_tests.sh its-migration
> > >
> > > and
> > >
> > >  $ tests/its-migration
> > >
> > > For the second one you need to do 'make standalone' first.
> > >
> > >
> > > >
> > > > /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
> > > > -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
> > > > testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> > > > arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
> > > > /tmp/tmp.OtsTj3QD4J
> > > > ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
> > > > ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
> > > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > > INVALL col_id=2
> > > > INVALL col_id=3
> > > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > > Now migrate the VM, then press a key to continue...
> > > >
> > > > And the test hangs here after I press a key.
> > >
> > > The test doesn't get your input because of the '</dev/null' in run_qemu(),
> > > which ./arm-run calls. So it's not hanging it's just waiting forever on
> > > the key press.
> > Hello Andrew,
> > We have found this waiting for key press issue on our side as well
> > [1], the test will fail with TIMEOUT, it looks like it's not getting
> > my input like you mentioned here.
> > I would like to ask what is the expected behaviour of these migration
> > related tests (its-pending-migration / its-migration /
> > its-migrate-unmapped-collection)? Should they pass right after the
> > tester hit a key?
>
> They should, but normally users don't need to press a key, because the
> script uses ncat to do it for them.
>
> > Also, if these test would require user interaction, should they be
> > moved to some special group like 'nodefault' to prevent it from
> > failing with timeout in automated tests?
>
> The tests shouldn't be a problem when ncat does its job.
>
>
>
> I still think we have a script/ncat issue here. Please provide
>
>  qemu version:
>  bash version:
>  ncat version:
>
> And the distro and distro version might also be helpful.

Hi Andrew,
thanks for the info, here is my system information:
* Ubuntu Hirsute 21.04 (5.11.0-18-generic)
* qemu version (qemu-system-arm) - QEMU emulator version 5.2.0 (Debian
1:5.2+dfsg-9ubuntu3)
* bash version - GNU bash, version 5.1.4(1)-release (aarch64-unknown-linux-gnu)
* ncat version - Ncat: Version 7.80 ( https://nmap.org/ncat )

Cheers

>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
