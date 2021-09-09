Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5081C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 13:06:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5AE556115B
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 13:06:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5AE556115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC20F4B14D;
	Thu,  9 Sep 2021 09:06:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lE-WQGpuiFqI; Thu,  9 Sep 2021 09:06:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AA314B133;
	Thu,  9 Sep 2021 09:06:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50AE94B133
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 09:06:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ps+87tWvyxQc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 09:05:59 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3098E4B132
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 09:05:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631192759;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1FVErduCuTQmHI3vb5b1r9KDhDiP+77xZGlhd2lM7ew=;
 b=LlPfzEFfZ+dQtFBZozCtOpGg0JkeEk81mPUUiDlv8rHHL3/KI4aXzxe7V+pIZCNQskcWV6
 x/7E0XJsxLxCnhd0Yoyn7gX+k068bHde4TXUlynuJLCsiaAJ3D4qSlK8GDUCWPC3q0eTkW
 ewgUNBDHQQ7/S62ecesqXi4c8jrpL5g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-TO_uWvulPX2TMXGPsK5Y0A-1; Thu, 09 Sep 2021 09:05:57 -0400
X-MC-Unique: TO_uWvulPX2TMXGPsK5Y0A-1
Received: by mail-wm1-f70.google.com with SMTP id
 n16-20020a1c7210000000b002ea2ed60dc6so553040wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 06:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1FVErduCuTQmHI3vb5b1r9KDhDiP+77xZGlhd2lM7ew=;
 b=K5OrAeul7FF5kiXGqlHdfajQDGRoyL+7FvsotaVLkw0puNY9y486Tf1fBpzNIlmdXW
 +gSF5lnNFnxgvEvd+Jbpj21XLh4sUYgVh+DaKMJFqw9UgCLuxSUdwKa+aWXA0BPyeUs8
 ZFdZJXUsZ45jw+rywjaJwtxb1Wv+Uivv+yp+9jtlbWqiG8YOxPm2nnZepFKe7+CQopOs
 JazANe+pWMJcNggXTncXgEsTUoFiQBtPZ7nckHmYxCfcff6CLZEV8Y7+BpZp9TeOel3U
 XRRiej/w+G5lUqEvecN8D3mBQ2FxX/SXd9xR+PsufVUk0cwPxXlPzzEIzFlsSRXJFa+F
 /l9g==
X-Gm-Message-State: AOAM531Bn7ukZrRoECEqQTzW7ntsUmn5Fa24BvUbqxaepxgf9y9Lfr2S
 gIA7XlEeg1QQCA3jb/tXlemPf/sOCddMQpHF0kmJFOf9pugDVBX3maWD4NjczElOptaTKyrSewL
 6C6cXiFAKakOgga1kwFd8wvvu
X-Received: by 2002:a5d:5241:: with SMTP id k1mr3513720wrc.14.1631192756533;
 Thu, 09 Sep 2021 06:05:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxT+tWfcglL0t0S4eC6SA9jHkqZot0Iidmz8QttJrfgTCOxvjPtNiiEnA6df1lyr1npKB9VDA==
X-Received: by 2002:a5d:5241:: with SMTP id k1mr3513679wrc.14.1631192756264;
 Thu, 09 Sep 2021 06:05:56 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id s15sm1695653wrb.22.2021.09.09.06.05.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Sep 2021 06:05:55 -0700 (PDT)
Date: Thu, 9 Sep 2021 15:05:53 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 4/5] scripts: Generate kvmtool
 standalone tests
Message-ID: <20210909130553.gnzce7cs7d5stvjd@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-5-alexandru.elisei@arm.com>
 <20210907102135.i2w3r7j4zyj736b5@gator>
 <ee11a10a-c3e6-b9ce-81e1-147025a9b5bd@arm.com>
 <20210908160743.l4hrl4de7wkxwuda@gator>
 <9d5da497-7070-31ef-282a-a11a86e0102e@arm.com>
MIME-Version: 1.0
In-Reply-To: <9d5da497-7070-31ef-282a-a11a86e0102e@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: lvivier@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com,
 frankja@linux.ibm.com, kvm@vger.kernel.org, david@redhat.com,
 andre.przywara@arm.com, cohuck@redhat.com, kvm-ppc@vger.kernel.org,
 vivek.gautam@arm.com, maz@kernel.org, pbonzini@redhat.com,
 imbrenda@linux.ibm.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 09, 2021 at 12:11:52PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 9/8/21 5:07 PM, Andrew Jones wrote:
> > On Wed, Sep 08, 2021 at 04:37:39PM +0100, Alexandru Elisei wrote:
> >> Hi Drew,
> >>
> >> On 9/7/21 11:21 AM, Andrew Jones wrote:
> >>> On Fri, Jul 02, 2021 at 05:31:21PM +0100, Alexandru Elisei wrote:
> >>>> Add support for the standalone target when running kvm-unit-tests under
> >>>> kvmtool.
> >>>>
> >>>> Example command line invocation:
> >>>>
> >>>> $ ./configure --target=kvmtool
> >>>> $ make clean && make standalone
> >>>>
> >>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>>> ---
> >>>>  scripts/mkstandalone.sh | 14 +++++++-------
> >>>>  1 file changed, 7 insertions(+), 7 deletions(-)
> >>>>
> >>>> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> >>>> index 16f461c06842..d84bdb7e278c 100755
> >>>> --- a/scripts/mkstandalone.sh
> >>>> +++ b/scripts/mkstandalone.sh
> >>>> @@ -44,6 +44,10 @@ generate_test ()
> >>>>  	config_export ARCH_NAME
> >>>>  	config_export PROCESSOR
> >>>>  
> >>>> +	if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "arm" ]; then
> >>>> +		config_export TARGET
> >>>> +	fi
> >>> Should export unconditionally, since we'll want TARGET set
> >>> unconditionally.
> >> Yes, will do.
> >>
> >>>> +
> >>>>  	echo "echo BUILD_HEAD=$(cat build-head)"
> >>>>  
> >>>>  	if [ ! -f $kernel ]; then
> >>>> @@ -59,7 +63,7 @@ generate_test ()
> >>>>  		echo 'export FIRMWARE'
> >>>>  	fi
> >>>>  
> >>>> -	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> >>>> +	if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> >>> I think it would be better to ensure that ENVIRON_DEFAULT is "no" for
> >>> TARGET=kvmtool in configure.
> >> From looking at the code, it is my understanding that with ENVIRON_DEFAULT=yes, an
> >> initrd file is generated with the contents of erratatxt and other information, in
> >> a key=value pair format. This initrd is then passed on to the test (please correct
> >> me if I'm wrong). With ENVIRON_DEFAULT=no (set via ./configure
> >> --disable-default-environ), this initrd is not generated.
> >>
> >> kvmtool doesn't have support for passing an initrd when loading firmware, so yes,
> >> I believe the default should be no.
> >>
> >> However, I have two questions:
> >>
> >> 1. What happens when the user specifically enables the default environ via
> >> ./configure --enable-default-environ --target=kvmtool? In my opinion, that should
> >> be an error because the user wants something that is not possible with kvmtool
> >> (loading an image with --firmware in kvmtool means that the initrd image it not
> >> loaded into the guest memory and no node is generated for it in the dtb), but I
> >> would like to hear your thoughts about it.
> > As part of the forcing ENVIRON_DEFAULT to "no" for kvmtool in configure an
> > error should be generated if a user tries to explicitly enable it.
> >
> >> 2. If the default environment is disabled, is it still possible for an user to
> >> pass an initrd via other means? I couldn't find where that is implemented, so I'm
> >> guessing it's not possible.
> > Yes, a user could have a KVM_UNIT_TESTS_ENV environment variable set when
> > they launch the tests. If that variable points to a file then it will get
> > passed as an initrd. I guess you should also report a warning in arm/run
> > if KVM_UNIT_TESTS_ENV is set which states that the environment file will
> > be ignored when running with kvmtool.
> 
> Thank you for explaining it, I had looked at
> scripts/arch-run.bash::initrd_create(), but it didn't click that setting the
> KVM_UNIT_TESTS_ENV environment variable is enough to generate and use the initrd.
> 
> After looking at the code some more, in the logs the -initrd argument is shown as
> a comment, instead of an actual argument that is passed to qemu:
> 
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine
> virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device
> virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none
> -serial stdio -kernel arm/cache.flat -smp 1 # -initrd /tmp/tmp.rUIZ3h9KLJ
> QEMU_ACCEL = kvm
> INFO: IDC-DIC: dcache clean to PoU required
> INFO: IDC-DIC: icache invalidation to PoU required
> PASS: IDC-DIC: code generation
> SUMMARY: 1 tests
> 
> This is done intentionally in scripts/arch-run.bash::run_qemu(). I don't
> understand the reason for that. When I first looked at the logs, I was sure that
> no initrd is passed to the test. I had to go dig through the scripts to figure out
> that the "#" sign (which marks the beginning of a comment) is not present in the
> qemu invocation.

It's commented out because if you want to copy+paste the command line to
use it again it'll fail to run because the temp file will be gone. Of
course somebody depending on the environment for their test run will have
other problems when it's gone, but those people can use the
KVM_UNIT_TESTS_ENV variable to specify a non-temp file which includes the
default environment and then configure without the default environment.
The command line won't get the # in that case.

Thanks,
drew

> 
> Thanks,
> 
> Alex
> 
> >
> > There aren't currently any other ways to invoke the addition of the
> > -initrd command line option, because so far we only support passing a
> > single file to test (the environment "file"). If we ever want to pass
> > more files, then we'd need to create a simple file system on the initrd
> > and make it possible to add -initrd even when no environment is desired.
> > But, that may never happen.
> >
> > Thanks,
> > drew
> >
> >> Thanks,
> >>
> >> Alex
> >>
> >>>
> >>>>  		temp_file ERRATATXT "$ERRATATXT"
> >>>>  		echo 'export ERRATATXT'
> >>>>  	fi
> >>>> @@ -95,12 +99,8 @@ function mkstandalone()
> >>>>  	echo Written $standalone.
> >>>>  }
> >>>>  
> >>>> -if [ "$TARGET" = "kvmtool" ]; then
> >>>> -	echo "Standalone tests not supported with kvmtool"
> >>>> -	exit 2
> >>>> -fi
> >>>> -
> >>>> -if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> >>>> +if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && \
> >>>> +		[ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> >>>>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
> >>>>  	exit 2
> >>>>  fi
> >>>> -- 
> >>>> 2.32.0
> >>>>
> >>> Thanks,
> >>> drew 
> >>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
