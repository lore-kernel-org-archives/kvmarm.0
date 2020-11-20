Return-Path: <SRS0=rD/S=E2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E731C56202
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 12:34:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80A4F22264
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 12:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YnFQR73j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80A4F22264
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F664B1D8;
	Fri, 20 Nov 2020 07:34:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jiDiRGrlzZho; Fri, 20 Nov 2020 07:34:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5DE74B37E;
	Fri, 20 Nov 2020 07:34:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 975034B2EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 07:34:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xhBD7bm6TVDq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Nov 2020 07:34:27 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9634B278
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 07:34:27 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605875667;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OOLIin4v2N9YnANejor4CHwzXzXg8lZQrdWXMbglVRM=;
 b=YnFQR73jhMUtr385CII8oDmelcZdUeWQ1SY0n/MCOBnZDWpLrLMll1FTCGhokYBwbKJNvl
 YtHZflRBFdn/kAv9k227uxy2SF4AdePW6DcQKzeb3WJljHGNScPlbqnGy3t27mIsrLfTKP
 zHdctUF6BtkXa3XrqVaksOsRSXcDlTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-RdYy3KTyNcajujCIwg3S-w-1; Fri, 20 Nov 2020 07:34:23 -0500
X-MC-Unique: RdYy3KTyNcajujCIwg3S-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E54D801B17;
 Fri, 20 Nov 2020 12:34:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.104])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D091110016F4;
 Fri, 20 Nov 2020 12:34:17 +0000 (UTC)
Date: Fri, 20 Nov 2020 13:34:14 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
Message-ID: <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
> When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpr=
o64 (on
> the Cortex-a53 cores) the its-migration test hangs. In the log file I see:
> =

> run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> -nodefaults -machine virt,gic-version=3Dhost,accel=3Dkvm -cpu host -device
> virtio-serial-device -device virtconsole,chardev=3Dctd -chardev testdev,i=
d=3Dctd
> -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp=
 6
> -machine gic-version=3D3 -append its-migration # -initrd /tmp/tmp.OrlQior=
BpY
> ITS: MAPD devid=3D2 size =3D 0x8 itt=3D0x40420000 valid=3D1
> ITS: MAPD devid=3D7 size =3D 0x8 itt=3D0x40430000 valid=3D1
> MAPC col_id=3D3 target_addr =3D 0x30000 valid=3D1
> MAPC col_id=3D2 target_addr =3D 0x20000 valid=3D1
> INVALL col_id=3D2
> INVALL col_id=3D3
> MAPTI dev_id=3D2 event_id=3D20 -> phys_id=3D8195, col_id=3D3
> MAPTI dev_id=3D7 event_id=3D255 -> phys_id=3D8196, col_id=3D2
> Now migrate the VM, then press a key to continue...
> scripts/arch-run.bash: line 103: 48549 Done=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
> =A0=A0=A0=A0 48550 Segmentation fault=A0=A0=A0=A0=A0 (core dumped) | ncat=
 -U $1
> scripts/arch-run.bash: line 103: 48568 Done=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
> =A0=A0=A0=A0 48569 Segmentation fault=A0=A0=A0=A0=A0 (core dumped) | ncat=
 -U $1
> scripts/arch-run.bash: line 103: 48583 Done=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
> =A0=A0=A0=A0 48584 Segmentation fault=A0=A0=A0=A0=A0 (core dumped) | ncat=
 -U $1
> [..]
> scripts/arch-run.bash: line 103: 49414 Done=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
> =A0=A0=A0=A0 49415 Segmentation fault=A0=A0=A0=A0=A0 (core dumped) | ncat=
 -U $1
> qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
> qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
> scripts/arch-run.bash: line 103: 49430 Done=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
> =A0=A0=A0=A0 49431 Segmentation fault=A0=A0=A0=A0=A0 (core dumped) | ncat=
 -U $1
> scripts/arch-run.bash: line 103: 49445 Done=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 echo '{ "execute":
> "qmp_capabilities" }{ "execute":' "$2" '}'
> [..]

Is your ncat segfaulting? It looks like it from this output. Have you
tried running your ncat with a UNIX socket independently of this test?

Is this the first time you've tried this test in this environment, or
is this a regression for you?

> =

> If I run the test manually:
> =

> $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3D3 -=
append
> 'its-migration'

This won't work because we need run_tests.sh to setup the run_migration()
call. The only ways to run migration tests separately are

 $ ./run_tests.sh its-migration

and

 $ tests/its-migration

For the second one you need to do 'make standalone' first.


> =

> /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=3Dhost=
,accel=3Dkvm
> -cpu host -device virtio-serial-device -device virtconsole,chardev=3Dctd =
-chardev
> testdev,id=3Dctd -device pci-testdev -display none -serial stdio -kernel
> arm/gic.flat -smp 4 -machine gic-version=3D3 -append its-migration # -ini=
trd
> /tmp/tmp.OtsTj3QD4J
> ITS: MAPD devid=3D2 size =3D 0x8 itt=3D0x403a0000 valid=3D1
> ITS: MAPD devid=3D7 size =3D 0x8 itt=3D0x403b0000 valid=3D1
> MAPC col_id=3D3 target_addr =3D 0x30000 valid=3D1
> MAPC col_id=3D2 target_addr =3D 0x20000 valid=3D1
> INVALL col_id=3D2
> INVALL col_id=3D3
> MAPTI dev_id=3D2 event_id=3D20 -> phys_id=3D8195, col_id=3D3
> MAPTI dev_id=3D7 event_id=3D255 -> phys_id=3D8196, col_id=3D2
> Now migrate the VM, then press a key to continue...
> =

> And the test hangs here after I press a key.

The test doesn't get your input because of the '</dev/null' in run_qemu(),
which ./arm-run calls. So it's not hanging it's just waiting forever on
the key press.

Thanks,
drew

> =

> Package versions:
> =

> $ ncat --version
> Ncat: Version 7.91 ( https://nmap.org/ncat )
> =

> $ /usr/bin/qemu-system-aarch64 --version
> QEMU emulator version 5.1.0
> Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
> =

> $ uname -a
> Linux rockpro 5.10.0-rc4 #33 SMP PREEMPT Thu Nov 19 15:58:57 GMT 2020 aar=
ch64
> GNU/Linux
> =

> Thanks,
> =

> Alex
> =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
