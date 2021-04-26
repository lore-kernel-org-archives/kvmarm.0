Return-Path: <SRS0=roT/=JX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FA3C43460
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 08:59:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5BB0761184
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 08:59:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BB0761184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D16F4B3ED;
	Mon, 26 Apr 2021 04:59:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vh+Jyu+7qEq2; Mon, 26 Apr 2021 04:59:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B8794B3DD;
	Mon, 26 Apr 2021 04:59:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6994B3D3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 04:59:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dSnEeqq1BUfM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Apr 2021 04:59:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C24C84B389
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 04:59:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619427559;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Epl8ZIucjNRdHe1jXHsga/3GfhhLNjAVq6yo9ieGPXs=;
 b=EKwbwsJnBdHavtlyOnSQlEKPJMIWdkhgLCx4TaGoq3y6fQ5j8N9qTpk08gIv2KqKs/Qqy9
 krkAs7c04RRD5VTMfedXpoE63d4C9c0eHVV3VD7yNTDtCH3u+aU8BnbSeFws5E0CU7+rY0
 tdkduezBY9v6aL5sxg/W7Ond+YhgAY0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-275P6ulPN-S_BAXMlFqgXw-1; Mon, 26 Apr 2021 04:59:16 -0400
X-MC-Unique: 275P6ulPN-S_BAXMlFqgXw-1
Received: by mail-wr1-f70.google.com with SMTP id
 q18-20020adfc5120000b029010c2bdd72adso761008wrf.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 01:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=Epl8ZIucjNRdHe1jXHsga/3GfhhLNjAVq6yo9ieGPXs=;
 b=NoiiDAzsUHQU5n0VEQTC420yI1EvN8zhxJhaj8W/BGf2oIUeB32k23dxk6XbmQtWuK
 grmsuNKo+RhtyXCw+ozp+JOBq3FomXya8xONLmTEFPmTagEtgRq98PIu/n7NgclFFWUi
 6CfG36ZMqFYz74qgohO8ThyTqyAzD7FXfDzSWg+vUxqdkBs9iclwQlVFuKv6OFCqJYjU
 n3DZKOxErZVfABUWii1PwXC/aJKQUqu9c2wU+M/xZxIejbMmEOs7B2wOWqeZDMHZdpPF
 ZliCqb89L9bKhkY94nzhu+4SvvgpFxb8P+YP8LHfi+0S06BW6ZD2B7xlWMmwDLfMBeOb
 KYRg==
X-Gm-Message-State: AOAM533+K9+A5mn9MmdHFFYr7ZPBj9FU9TMvrNbzmxYu3C5OinSZP5Pm
 oV+1KsRkbT77yW9uiNLvofOfyyQn7OijHtSXKMckJNj7lfLYBw7HBxuLNmL84QECgThuG0KNdBm
 yfO805e9qoonBSo2t5jrKr6wa
X-Received: by 2002:a5d:47af:: with SMTP id 15mr21796283wrb.234.1619427555578; 
 Mon, 26 Apr 2021 01:59:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziTF4KtWLs4Sczh807QMr4lICITI2JNXavL1dzS9Q/EKccrdm/nMG2NDnJnY4RG1uKoqwDnA==
X-Received: by 2002:a5d:47af:: with SMTP id 15mr21796257wrb.234.1619427555235; 
 Mon, 26 Apr 2021 01:59:15 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id j7sm3404625wmi.21.2021.04.26.01.59.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 26 Apr 2021 01:59:14 -0700 (PDT)
Date: Mon, 26 Apr 2021 10:59:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 0/1] configure: arm: Replace --vmm
 with --target
Message-ID: <20210426085911.jkkuj53jsajbjmi5@gator>
References: <20210420161338.70914-1-alexandru.elisei@arm.com>
 <20210420165101.irbx2upgqbazkvlt@gator.home>
 <ed3ba802-fee7-4c58-9d73-d33dfbd44d7f@arm.com>
 <20210422155757.t4pvv6blkvoyi2oy@gator>
 <854c2d33-0b20-b7e3-c522-b01a53fcbbb3@arm.com>
MIME-Version: 1.0
In-Reply-To: <854c2d33-0b20-b7e3-c522-b01a53fcbbb3@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Fri, Apr 23, 2021 at 04:43:14PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> =

> On 4/22/21 4:57 PM, Andrew Jones wrote:
> > On Thu, Apr 22, 2021 at 04:17:27PM +0100, Alexandru Elisei wrote:
> >> Hi Drew,
> >>
> >> On 4/20/21 5:51 PM, Andrew Jones wrote:
> >>> Hi Alex,
> >>>
> >>> On Tue, Apr 20, 2021 at 05:13:37PM +0100, Alexandru Elisei wrote:
> >>>> This is an RFC because it's not exactly clear to me that this is the=
 best
> >>>> approach. I'm also open to using a different name for the new option=
, maybe
> >>>> something like --platform if it makes more sense.
> >>> I like 'target'.
> >>>
> >>>> I see two use cases for the patch:
> >>>>
> >>>> 1. Using different files when compiling kvm-unit-tests to run as an =
EFI app
> >>>> as opposed to a KVM guest (described in the commit message).
> >>>>
> >>>> 2. This is speculation on my part, but I can see extending
> >>>> arm/unittests.cfg with a "target" test option which can be used to d=
ecide
> >>>> which tests need to be run based on the configure --target value. For
> >>>> example, migration tests don't make much sense on kvmtool, which doe=
sn't
> >>>> have migration support. Similarly, the micro-bench test doesn't make=
 much
> >>>> sense (to me, at least) as an EFI app. Of course, this is only usefu=
l if
> >>>> there are automated scripts to run the tests under kvmtool or EFI, w=
hich
> >>>> doesn't look likely at the moment, so I left it out of the commit me=
ssage.
> >>> Sounds like a good idea. unittests.cfg could get a new option 'target=
s'
> >>> where a list of targets is given. If targets is not present, then the
> >>> test assumes it's for all targets. Might be nice to also accept !<tar=
get>
> >>> syntax. E.g.
> >>>
> >>> # builds/runs for all targets
> >>> [mytest]
> >>> file =3D mytest.flat
> >>>
> >>> # builds/runs for given targets
> >>> [mytest2]
> >>> file =3D mytest2.flat
> >>> targets =3D qemu,kvmtool
> >>>
> >>> # builds/runs for all targets except disabled targets
> >>> [mytest3]
> >>> file =3D mytest3.flat
> >>> targets =3D !kvmtool
> >> That's sounds like a good idea, but to be honest, I would wait until s=
omeone
> >> actually needs it before implementing it. That way we don't risk not t=
aking a use
> >> case into account and then having to rework it.
> > Don't we have a usecase? Above you said that kvmtool should at least sk=
ip
> > the migration tests.
> =

> Sorry for not making myself clear, when I was talking about adding a "tar=
gets"
> parameter to a test, I was thinking that it will only be used by the run =
scripts.
> All the tests can run under qemu, and run_tests.sh only knows about qemu,=
 so, from
> that point of view, that's why I think the "targets" argument is not usef=
ul at the
> moment.
> =

> As for the migration test specifically, the VM migration is implemented i=
n the run
> scripts, not in the test itself; the test waits for the UART to signal th=
at
> migration is complete. That test runs just fine under kvmtool, but no mig=
ration is
> taking place:
> =

> $ ./vm run --irqchip=3Dgicv3-its -c6 -m128 -f arm/gic.flat --params its-m=
igration
> =A0 # lkvm run --firmware arm/gic.flat -m 128 -c 6 --name guest-1440
> =A0 Info: Placing fdt at 0x80200000 - 0x80210000
> chr_testdev_init: chr-testdev: can't find a virtio-console
> ITS: MAPD devid=3D2 size =3D 0x8 itt=3D0x801e0000 valid=3D1
> ITS: MAPD devid=3D7 size =3D 0x8 itt=3D0x801f0000 valid=3D1
> MAPC col_id=3D3 target_addr =3D 0x30000 valid=3D1
> MAPC col_id=3D2 target_addr =3D 0x20000 valid=3D1
> INVALL col_id=3D2
> INVALL col_id=3D3
> MAPTI dev_id=3D2 event_id=3D20 -> phys_id=3D8195, col_id=3D3
> MAPTI dev_id=3D7 event_id=3D255 -> phys_id=3D8196, col_id=3D2
> Now migrate the VM, then press a key to continue...
> INFO: gicv3: its-migration: Migration complete
> INT dev_id=3D2 event_id=3D20
> PASS: gicv3: its-migration: dev2/eventid=3D20 triggers LPI 8195 on PE #3 =
after migration
> INT dev_id=3D7 event_id=3D255
> PASS: gicv3: its-migration: dev7/eventid=3D255 triggers LPI 8196 on PE #2=
 after
> migration
> SUMMARY: 2 tests
> =

> Even the pci-test works under kvmtool, even though it targets qemu's pci-=
testdev:
> =

> $ ./vm run --irqchip=3Dgicv3-its -c6 -m128 -f arm/pci-test.flat
> =A0 # lkvm run --firmware arm/pci-test.flat -m 128 -c 6 --name guest-1468
> =A0 Info: Placing fdt at 0x80200000 - 0x80210000
> chr_testdev_init: chr-testdev: can't find a virtio-console
> No PCIe ECAM compatible controller found
> PCI bus probing failed, skipping tests...
> SUMMARY: 0 tests
> =

> The test is still useful for kvmtool, because it tests that the PCI node =
in the
> DTB is generated as expected. And after kvmtool gets support for PCIE (wo=
rk in
> progress), it will test PCI device probing, which makes it even more usef=
ul than
> it is today.
> =

> So I guess the question is, do what should "targets" represent, how shoul=
d it be
> used and do we need it now?

I'll leave that up to you, since you're the one driving support for
kvmtool and, hopefully soon, bare-metal AArch64. BTW, I think we're long
overdue for adding kvmtool runner functionality, either by adapting what
we have (possibly by applying a TARGET variable :-) or by simply adding
new runner scripts. I personally would like to easily run kvmtool when
I'm testing arm/queue, and I don't want to have my own personal kvmtool
runner script to do that.

> =

> >
> >>> And it wouldn't bother me to have special logic for kvmtool's lack of
> >>> migration put directly in scripts/runtime.bash
> >> Good to keep in mind when support is added.
> >>
> >>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> >>> index 132389c7dd59..0d5cb51df4f4 100644
> >>> --- a/scripts/runtime.bash
> >>> +++ b/scripts/runtime.bash
> >>> @@ -132,7 +132,7 @@ function run()
> >>>      }
> >>>  =

> >>>      cmdline=3D$(get_cmdline $kernel)
> >>> -    if grep -qw "migration" <<<$groups ; then
> >>> +    if grep -qw "migration" <<<$groups && [ "$TARGET" !=3D "kvmtool"=
 ]; then
> >>>          cmdline=3D"MIGRATION=3Dyes $cmdline"
> >>>      fi
> >>>      if [ "$verbose" =3D "yes" ]; then
> >>>
> >>>> Using --vmm will trigger a warning. I was thinking about removing it=
 entirely in
> >>>> a about a year's time, but that's not set in stone. Note that qemu u=
sers
> >>>> (probably the vast majority of people) will not be affected by this =
change as
> >>>> long as they weren't setting --vmm explicitely to its default value =
of "qemu".
> >>>>
> >>> While we'd risk automated configure+build tools, like git{hub,lab} CI,
> >>> failing, I think the risk is pretty low right now that anybody is usi=
ng
> >>> the option. Also, we might as well make them change sooner than later=
 by
> >>> failing configure. IOW, I'd just do s/vmm/target/g to rename it now. =
If
> >>> we are concerned about the disruption, then I'd just make vmm an alias
> >>> for target and not bother deprecating it ever.
> >> I also think it will not be too bad if we make the change now, but I'm=
 not sure
> >> what you mean by making vmm an alias of target. The patch ignores --vm=
m is it's
> >> not specified, and if it is specified on the configure command line, t=
hen it must
> >> match the value of --target, otherwise configure fails.
> >>
> > The current patch does both things; it says don't use --vmm and it says
> > the new --vmm is --target. I'm saying do one or the other. Either
> > completely rename vmm to target, which will then error out when vmm is
> > specified as an unknown option or allow the user to use either --vmm or
> > --target with no error and where both mean to do the same thing, which =
is
> > to set the TARGET variable.
> =

> I'm sorry, but it's still not clear to me what you are trying to say.
> =

> The current behaviour:
> =

> $ ./configure --arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu- --vmm=3D=
qemu
> INFO: --vmm is deprecated and will be removed in future versions
> $ ./configure --arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu- --vmm=3D=
qemu --target=3Dqemu
> INFO: --vmm is deprecated and will be removed in future versions
> $ ./configure --arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu- --vmm=3D=
kvmtool
> --target=3Dqemu
> INFO: --vmm is deprecated and will be removed in future versions
> --vmm must have the same value as --target (qemu)
> Usage: ./configure [options]
> [..]
> $ ./configure --arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu- --vmm=3D=
kvmtool
> --target=3Dkvmtool
> INFO: --vmm is deprecated and will be removed in future versions
> =

> Can you point out what makes you think that the patch tries to do two thi=
ngs at once?

Deprecation requires you do two things at once; add a warning to the old
and add the new. I'm saying we don't need to deprecate --vmm. Either just
do the new (s/vmm/target/g) or always allow the old (s/vmm/target/g plus
make --vmm an alias for --target without any warning). I'd prefer the
first one, since I'm not too worried about a few users having to figure
out how to change their muscle memory and CI scripts when they start
getting unknown option errors at configure time.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
