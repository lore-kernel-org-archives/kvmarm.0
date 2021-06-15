Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D23C48BE5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 06:37:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B32F5613B6
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 06:37:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B32F5613B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E95F94B0BE;
	Tue, 15 Jun 2021 02:37:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HEV7iZOg20L5; Tue, 15 Jun 2021 02:37:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A9D34A319;
	Tue, 15 Jun 2021 02:37:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8378049E57
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 02:37:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uPDZqo1TWO+C for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 02:37:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EDE8406AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 02:37:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623739029;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/uTYDE6axgI8+V5JJRzWIMMuTTgoiXTw80Zr4xUCLF0=;
 b=FkEirsxGcYvU+iq5HtoFdXwBJVJtSWJ5ZJe3FGNuIbEfx+eVuLlGhrlBvEHYPJoITV43y6
 83hmvnD/MPkW/0Gi63whNdu+ucmG1puiUfjl8MrL9S644Oaor06Fzh7hr+/s1rZiHnxRDu
 kmtlAunwwBc4JvtbWj0tz72QBmbXBko=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-lVVpx571NvClVJOic5-5tg-1; Tue, 15 Jun 2021 02:37:07 -0400
X-MC-Unique: lVVpx571NvClVJOic5-5tg-1
Received: by mail-ej1-f70.google.com with SMTP id
 l6-20020a1709062a86b029046ec0ceaf5cso165036eje.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 23:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/uTYDE6axgI8+V5JJRzWIMMuTTgoiXTw80Zr4xUCLF0=;
 b=A5ylOUE60ceSZLKx+bE7UvMvRaUMWzSnq8zJnl+thNlavivvuJznoWvBtwavVNHc6f
 FTWKyTL8J3GZumr2W75etKfnnJBZ6V9Qf5EGqDHMQGOvHeJpeDr4fDyi3VD54tYQjQ8c
 +EI1CJjw86QmOMsgyNhyouVPoOBQoPYF0D8Md3l67/ti7hbO25CtQNV9kC02NJ2Ky903
 nLXGv1lXjfhjGF92Iu3g1hvc8nt7owz2WI6Pp7MIQArIHaP6EWlTs2nB7HUyG8rfgO72
 H56K4yRiJ3HGkDUsO5AIRi9Ntl0hfZfY9uN89/rzR2Lms3qTgtdj+rbfnf/3XGja7c9s
 PRWw==
X-Gm-Message-State: AOAM532gELAWT0vuRkNAw9Ru33T0QEiaQc7IMS/WDW8Tbz/LYL5/2EcL
 n1IaX8r0JeKVh+tKCmbBgqc5ISM94nhSxYq1vovEhhTBuxWP5dLal5/7Pm+NFXS3wB8IKlZJHah
 y8nTwMkQDAAAqv+OYx5/j28j8
X-Received: by 2002:a05:6402:10d7:: with SMTP id
 p23mr21087712edu.74.1623739026563; 
 Mon, 14 Jun 2021 23:37:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIJEY877bzl4Nl2KxraQA7dX3+GKtUBy5mvWvkO0DSmKCTjIHyEw85M40WWw7qZpl6Wa9Ihw==
X-Received: by 2002:a05:6402:10d7:: with SMTP id
 p23mr21087686edu.74.1623739026290; 
 Mon, 14 Jun 2021 23:37:06 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id q14sm10792082eds.2.2021.06.14.23.37.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Jun 2021 23:37:06 -0700 (PDT)
Date: Tue, 15 Jun 2021 08:36:59 +0200
From: Andrew Jones <drjones@redhat.com>
To: Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
Message-ID: <20210615063659.7w2rp6jk76rhgeue@gator.home>
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
 <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
 <CAMy_GT9Y1JNyh5GkZm31RQ6nX8Jv9qHFRN2KeOe01GOyk2ifQg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMy_GT9Y1JNyh5GkZm31RQ6nX8Jv9qHFRN2KeOe01GOyk2ifQg@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Tue, Jun 15, 2021 at 11:21:05AM +0800, Po-Hsu Lin wrote:
> On Fri, Nov 20, 2020 at 8:35 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
> > > When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
> > > the Cortex-a53 cores) the its-migration test hangs. In the log file I see:
> > >
> > > run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> > > -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> > > virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd
> > > -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 6
> > > -machine gic-version=3 -append its-migration # -initrd /tmp/tmp.OrlQiorBpY
> > > ITS: MAPD devid=2 size = 0x8 itt=0x40420000 valid=1
> > > ITS: MAPD devid=7 size = 0x8 itt=0x40430000 valid=1
> > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > INVALL col_id=2
> > > INVALL col_id=3
> > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > Now migrate the VM, then press a key to continue...
> > > scripts/arch-run.bash: line 103: 48549 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      48550 Segmentation fault      (core dumped) | ncat -U $1
> > > scripts/arch-run.bash: line 103: 48568 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      48569 Segmentation fault      (core dumped) | ncat -U $1
> > > scripts/arch-run.bash: line 103: 48583 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      48584 Segmentation fault      (core dumped) | ncat -U $1
> > > [..]
> > > scripts/arch-run.bash: line 103: 49414 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      49415 Segmentation fault      (core dumped) | ncat -U $1
> > > qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
> > > qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
> > > scripts/arch-run.bash: line 103: 49430 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      49431 Segmentation fault      (core dumped) | ncat -U $1
> > > scripts/arch-run.bash: line 103: 49445 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > [..]
> >
> > Is your ncat segfaulting? It looks like it from this output. Have you
> > tried running your ncat with a UNIX socket independently of this test?
> >
> > Is this the first time you've tried this test in this environment, or
> > is this a regression for you?
> >
> > >
> > > If I run the test manually:
> > >
> > > $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
> > > 'its-migration'
> >
> > This won't work because we need run_tests.sh to setup the run_migration()
> > call. The only ways to run migration tests separately are
> >
> >  $ ./run_tests.sh its-migration
> >
> > and
> >
> >  $ tests/its-migration
> >
> > For the second one you need to do 'make standalone' first.
> >
> >
> > >
> > > /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
> > > -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
> > > testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> > > arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
> > > /tmp/tmp.OtsTj3QD4J
> > > ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
> > > ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
> > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > INVALL col_id=2
> > > INVALL col_id=3
> > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > Now migrate the VM, then press a key to continue...
> > >
> > > And the test hangs here after I press a key.
> >
> > The test doesn't get your input because of the '</dev/null' in run_qemu(),
> > which ./arm-run calls. So it's not hanging it's just waiting forever on
> > the key press.
> Hello Andrew,
> We have found this waiting for key press issue on our side as well
> [1], the test will fail with TIMEOUT, it looks like it's not getting
> my input like you mentioned here.
> I would like to ask what is the expected behaviour of these migration
> related tests (its-pending-migration / its-migration /
> its-migrate-unmapped-collection)? Should they pass right after the
> tester hit a key?

They should, but normally users don't need to press a key, because the
script uses ncat to do it for them.

> Also, if these test would require user interaction, should they be
> moved to some special group like 'nodefault' to prevent it from
> failing with timeout in automated tests?

The tests shouldn't be a problem when ncat does its job.



I still think we have a script/ncat issue here. Please provide

 qemu version:
 bash version:
 ncat version:

And the distro and distro version might also be helpful.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
