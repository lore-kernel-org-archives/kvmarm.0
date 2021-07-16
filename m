Return-Path: <SRS0=U254=MI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573E2C636CA
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 10:59:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2E7B613EB
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 10:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2E7B613EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 184394B0A0;
	Fri, 16 Jul 2021 06:59:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@canonical.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VKfv8t+bt4tY; Fri, 16 Jul 2021 06:59:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC3CC4B0A3;
	Fri, 16 Jul 2021 06:59:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1204B099
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 02:35:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v1BNdA1nGnvn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Jul 2021 02:35:42 -0400 (EDT)
Received: from smtp-relay-canonical-0.canonical.com
 (smtp-relay-canonical-0.canonical.com [185.125.188.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 416564A003
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 02:35:42 -0400 (EDT)
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 4965B408A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 06:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
 s=20210705; t=1626417336;
 bh=4j7G11Xm0HV7sqp7ibnxlMwChJPMkMMUOn/ET7Wu810=;
 h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
 To:Cc:Content-Type;
 b=Ywx+rD4CrljAPFAyXp3YOB/xyZEJtMQ4T0mTz22w3OKz+yQnTlEYeoVKAcAZRjYG/
 +lpoSjubVs//ZoxhcJcPnvSNazGggCxiQI5/ri496JC9nn/ZXSA0qfdf1LU102j0LL
 S8nkBoLOu7J0R7LDJY/g8PDw/N3eg2uI7+CmVGocDMU7Xroc1y6ZnRcB92eUz1ll/6
 FIcr67kE0XDMk8Ew+EjxSRBJ2iMeU9+ETaAoQYLteTUtI46iToNHJYbSezvsKdw5AW
 nGtBC2LjOAJDFS+4ZQYwhn0Cf535mCUhY5GTnjvgkFVZSQHE1aRWebw9Q+7sBiIl5a
 WVhOqhA3mJT7w==
Received: by mail-pg1-f199.google.com with SMTP id
 s18-20020a6564520000b0290223167334a7so6227402pgv.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 23:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4j7G11Xm0HV7sqp7ibnxlMwChJPMkMMUOn/ET7Wu810=;
 b=SME4PyCeBuFNXG10HasIsHWMD50bG9S5FVVu8Xnn1P2EvTwGKDLIKpJpMdqW1qKNs4
 sHMYi5ka2UBgIENm6UevTjDAJZ7att0KNiijFjYDeULKZheL1k8lO+6AfZ/SCtQR1B5C
 xnZcugdaYJWrRUD9Sx5nkkLnRr+TsgLX8mHixriFZzoMmXW3TRhu8rkBpEjCUc9RTepj
 ujn0J7mITS4Y6NFgT/RiaYmqYvhtmqWDOTcHjD7lHjjmslhK1vXlWhQxNDUgIdMG7L0R
 zO1FUFcRxaVy3AoDZn6oHIZ+Qa7hADhZuQFSYbCm/TZ1uZ6YUDlyEy09IlZNfDDCw0oe
 vTmQ==
X-Gm-Message-State: AOAM533H1aglk93Gxy0JJQFrRvj27fb4xVhzAK/cHbI/bmhYziBS2iWa
 UtE1swL2BjOmT9q8JLyFmMPpEZ4E9AVg8TYHCx0l0v90GS42LntwvVqTicc914PjHADKxnboyDI
 R4IINn0x4Wll6/9eZUr+yyAVwZcRLNT27Tnn0XF4D9SHKSUr9NbsSTpzN
X-Received: by 2002:a63:338d:: with SMTP id z135mr8391434pgz.314.1626417334725; 
 Thu, 15 Jul 2021 23:35:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPkyAoKhEoAEXQZOmMm1wUpJkkzzHW/sfB9xk9FcBV3UKHGmi3dRJWCPts5JEZwAdnEOAhqEY+8I50GbHSWJ4=
X-Received: by 2002:a63:338d:: with SMTP id z135mr8391391pgz.314.1626417334186; 
 Thu, 15 Jul 2021 23:35:34 -0700 (PDT)
MIME-Version: 1.0
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
 <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
 <CAMy_GT9Y1JNyh5GkZm31RQ6nX8Jv9qHFRN2KeOe01GOyk2ifQg@mail.gmail.com>
 <20210615063659.7w2rp6jk76rhgeue@gator.home>
 <CAMy_GT_jegx-EO20ktpBZrrdM_Q4cTaZmPSZfK2eyowonRNH3g@mail.gmail.com>
In-Reply-To: <CAMy_GT_jegx-EO20ktpBZrrdM_Q4cTaZmPSZfK2eyowonRNH3g@mail.gmail.com>
From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date: Fri, 16 Jul 2021 14:35:22 +0800
Message-ID: <CAMy_GT_YYA=q8csbUFrQUKYu39AVNpoaVZ4dA8CdG+2iDBtDuA@mail.gmail.com>
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
To: Andrew Jones <drjones@redhat.com>
X-Mailman-Approved-At: Fri, 16 Jul 2021 06:59:17 -0400
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

On Tue, Jun 15, 2021 at 3:11 PM Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
>
> On Tue, Jun 15, 2021 at 2:37 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Tue, Jun 15, 2021 at 11:21:05AM +0800, Po-Hsu Lin wrote:
> > > On Fri, Nov 20, 2020 at 8:35 PM Andrew Jones <drjones@redhat.com> wrote:
> > > >
> > > > On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
> > > > > When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
> > > > > the Cortex-a53 cores) the its-migration test hangs. In the log file I see:
> > > > >
> > > > > run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> > > > > -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> > > > > virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd
> > > > > -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 6
> > > > > -machine gic-version=3 -append its-migration # -initrd /tmp/tmp.OrlQiorBpY
> > > > > ITS: MAPD devid=2 size = 0x8 itt=0x40420000 valid=1
> > > > > ITS: MAPD devid=7 size = 0x8 itt=0x40430000 valid=1
> > > > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > > > INVALL col_id=2
> > > > > INVALL col_id=3
> > > > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > > > Now migrate the VM, then press a key to continue...
> > > > > scripts/arch-run.bash: line 103: 48549 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      48550 Segmentation fault      (core dumped) | ncat -U $1
> > > > > scripts/arch-run.bash: line 103: 48568 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      48569 Segmentation fault      (core dumped) | ncat -U $1
> > > > > scripts/arch-run.bash: line 103: 48583 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      48584 Segmentation fault      (core dumped) | ncat -U $1
> > > > > [..]
> > > > > scripts/arch-run.bash: line 103: 49414 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      49415 Segmentation fault      (core dumped) | ncat -U $1
> > > > > qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
> > > > > qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
> > > > > scripts/arch-run.bash: line 103: 49430 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      49431 Segmentation fault      (core dumped) | ncat -U $1
> > > > > scripts/arch-run.bash: line 103: 49445 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > > [..]
> > > >
> > > > Is your ncat segfaulting? It looks like it from this output. Have you
> > > > tried running your ncat with a UNIX socket independently of this test?
> > > >
> > > > Is this the first time you've tried this test in this environment, or
> > > > is this a regression for you?
> > > >
> > > > >
> > > > > If I run the test manually:
> > > > >
> > > > > $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
> > > > > 'its-migration'
> > > >
> > > > This won't work because we need run_tests.sh to setup the run_migration()
> > > > call. The only ways to run migration tests separately are
> > > >
> > > >  $ ./run_tests.sh its-migration
> > > >
> > > > and
> > > >
> > > >  $ tests/its-migration
> > > >
> > > > For the second one you need to do 'make standalone' first.
> > > >
> > > >
> > > > >
> > > > > /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
> > > > > -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
> > > > > testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> > > > > arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
> > > > > /tmp/tmp.OtsTj3QD4J
> > > > > ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
> > > > > ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
> > > > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > > > INVALL col_id=2
> > > > > INVALL col_id=3
> > > > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > > > Now migrate the VM, then press a key to continue...
> > > > >
> > > > > And the test hangs here after I press a key.
> > > >
> > > > The test doesn't get your input because of the '</dev/null' in run_qemu(),
> > > > which ./arm-run calls. So it's not hanging it's just waiting forever on
> > > > the key press.
> > > Hello Andrew,
> > > We have found this waiting for key press issue on our side as well
> > > [1], the test will fail with TIMEOUT, it looks like it's not getting
> > > my input like you mentioned here.
> > > I would like to ask what is the expected behaviour of these migration
> > > related tests (its-pending-migration / its-migration /
> > > its-migrate-unmapped-collection)? Should they pass right after the
> > > tester hit a key?
> >
> > They should, but normally users don't need to press a key, because the
> > script uses ncat to do it for them.
> >
> > > Also, if these test would require user interaction, should they be
> > > moved to some special group like 'nodefault' to prevent it from
> > > failing with timeout in automated tests?
> >
> > The tests shouldn't be a problem when ncat does its job.
> >
> >
> >
> > I still think we have a script/ncat issue here. Please provide
> >
> >  qemu version:
> >  bash version:
> >  ncat version:
> >
> > And the distro and distro version might also be helpful.
>
> Hi Andrew,
> thanks for the info, here is my system information:
> * Ubuntu Hirsute 21.04 (5.11.0-18-generic)
> * qemu version (qemu-system-arm) - QEMU emulator version 5.2.0 (Debian
> 1:5.2+dfsg-9ubuntu3)
> * bash version - GNU bash, version 5.1.4(1)-release (aarch64-unknown-linux-gnu)
> * ncat version - Ncat: Version 7.80 ( https://nmap.org/ncat )
>
> Cheers
>
Hello Andrew,
is there anything I can test here for this issue?
Thanks!

> >
> > Thanks,
> > drew
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
