Return-Path: <SRS0=b97j=N4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6959C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 10:58:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09F5D6023D
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 10:58:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 09F5D6023D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 721994B243;
	Mon,  6 Sep 2021 06:58:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AL46FBsBcLFu; Mon,  6 Sep 2021 06:58:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B5E14B283;
	Mon,  6 Sep 2021 06:58:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 688E54B243
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 06:58:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MXU5xDqJ7zz3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Sep 2021 06:58:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 527004B242
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 06:58:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630925912;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1RDA8Bk3nt+swtUOnWsFb/ykCw+znhVEXQGv+yky4p8=;
 b=YTHGZNAu07rEVIoARTlILYYr+5WIMVV+tiC5bDesCTSfJleprUnjhzdiuL402N98tJOaCz
 mtDtFxfslDaAvH8eLQ7D0oVAI9sAZYe8uk3kyg8F+9Q5GcMzOz9/Si0Kla+Nfdgjlr9oit
 6oTglZwBC1JrFr6eKKMyXlhSk6xQV7g=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-CvsVhMPZNfqmdPZffXoVuA-1; Mon, 06 Sep 2021 06:58:31 -0400
X-MC-Unique: CvsVhMPZNfqmdPZffXoVuA-1
Received: by mail-ej1-f70.google.com with SMTP id
 m18-20020a170906849200b005c701c9b87cso2179438ejx.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Sep 2021 03:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1RDA8Bk3nt+swtUOnWsFb/ykCw+znhVEXQGv+yky4p8=;
 b=kGkvK3IJVLBfks6a6iQdrZUkTODH60xaDMFp40MhtVXg3ia5rRm8HAqAjWQUIQirwo
 jc8l7fTMX38CDjU1v2c3nE1M/S3TztTCknmoQ3Mma85FiSHD+i6uApvwOrBHYD8VsnGd
 sJp3o4X3KvYmKpmTtRboLfub9MoXr7pjerepgTDBGvIe/uxS8zdh8Qi1c4XnOn6sN8Az
 UdsZHuwczowXoOoVDb/tXDzqrhJCD/tfX1wQMwFljamoMP4hcEQfuyDTJWsVqTvcfZCv
 rQ/3U4uaXpd8ykeePNkzOyGgey6kUNaU/vTxzPgtB0AGaUkQcdQugPsHKL639K/eCXRd
 WYug==
X-Gm-Message-State: AOAM533qIry0FUz/bpEGHXOm1TQg0b5iosodGTPJaXNUS5/y4Zh8j/dy
 UZBiTPbwJ5vn2I9O7EBlpumlF5g1+9cDUNf5UIFFzUT3tvXKcXpFcc12ABDy1muR/TRIlMgFvFM
 L1odH/8vcq2wbOGKyvKNr/cz+
X-Received: by 2002:a17:906:5408:: with SMTP id
 q8mr12573273ejo.54.1630925910059; 
 Mon, 06 Sep 2021 03:58:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWrX2GgCzwIGIlvdKnLO5nw6k3AjkJdy6n1BkDhKb1omv4ojZVj6K69QMmQGj9nmdtLh4Dng==
X-Received: by 2002:a17:906:5408:: with SMTP id
 q8mr12573265ejo.54.1630925909864; 
 Mon, 06 Sep 2021 03:58:29 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id cn16sm4433015edb.87.2021.09.06.03.58.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 06 Sep 2021 03:58:29 -0700 (PDT)
Date: Mon, 6 Sep 2021 12:58:27 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
Message-ID: <20210906105827.wneqtlrsgbz3pxk5@gator.home>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
 <20210712163647.oxntpjapur4z23sl@gator>
 <7814beab-547e-98d9-9aa0-3b7e5afd803b@arm.com>
MIME-Version: 1.0
In-Reply-To: <7814beab-547e-98d9-9aa0-3b7e5afd803b@arm.com>
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

On Mon, Sep 06, 2021 at 11:20:31AM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> Sorry for taking so long to reply, been busy with other things.
> 
> On 7/12/21 5:36 PM, Andrew Jones wrote:
> > On Fri, Jul 02, 2021 at 05:31:18PM +0100, Alexandru Elisei wrote:
> >> The arm64 tests can be run under kvmtool, which doesn't emulate a
> >> chr-testdev device. In preparation for adding run script support for
> >> kvmtool, print the test exit status so the scripts can pick it up and
> >> correctly mark the test as pass or fail.
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  lib/chr-testdev.h |  1 +
> >>  lib/arm/io.c      | 10 +++++++++-
> >>  lib/chr-testdev.c |  5 +++++
> >>  3 files changed, 15 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
> >> index ffd9a851aa9b..09b4b424670e 100644
> >> --- a/lib/chr-testdev.h
> >> +++ b/lib/chr-testdev.h
> >> @@ -11,4 +11,5 @@
> >>   */
> >>  extern void chr_testdev_init(void);
> >>  extern void chr_testdev_exit(int code);
> >> +extern bool chr_testdev_available(void);
> >>  #endif
> >> diff --git a/lib/arm/io.c b/lib/arm/io.c
> >> index 343e10822263..9e62b571a91b 100644
> >> --- a/lib/arm/io.c
> >> +++ b/lib/arm/io.c
> >> @@ -125,7 +125,15 @@ extern void halt(int code);
> >>  
> >>  void exit(int code)
> >>  {
> >> -	chr_testdev_exit(code);
> >> +	if (chr_testdev_available()) {
> >> +		chr_testdev_exit(code);
> > chr_testdev_exit() already has a 'if !vcon goto out' in it, so you can
> > just call it unconditionally. No need for chr_testdev_available().
> 
> I'm not sure what you mean. There has to be a way to check if chr-testdev is
> available, and if it's not present on the system, to print the EXIT: STATUS
> message, and vcon is static in chr-testdev.c.
> 
> Are you suggesting that we move the message to chr_testdev_exit(code)?

I'm saying you can unconditionally call chr_testdev_exit(), because it
only conditionally does anything, and on the same condition that you're
adding (vcon != NULL). 

$ /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,accel=tcg -cpu cortex-a57 -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/selftest.flat
ABORT: selftest: no test specified
SUMMARY: 0 tests
$ echo $?
127
$ /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,accel=tcg -cpu cortex-a57 -display none -serial stdio -kernel arm/selftest.flat
ABORT: selftest: no test specified
SUMMARY: 0 tests
$ echo $?
0

See, no explosions when the device is removed. Just a lack of return code.

Also, since chr_testdev_exit() exits, any calls after it won't happen. So
the exit print statement doesn't need to be in an else clause. That said,
I think the print statement should come first in order to also put it in
the qemu output logs. We might as well have consistent output between qemu
and kvmtool.

Thanks,
drew


> 
> Thanks,
> 
> Alex
> 
> >
> >> +	} else {
> >> +		/*
> >> +		 * Print the test return code in the format used by chr-testdev
> >> +		 * so the runner script can parse it.
> >> +		 */
> >> +		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> >> +	}
> >>  	psci_system_off();
> >>  	halt(code);
> >>  	__builtin_unreachable();
> >> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> >> index b3c641a833fe..301e73a6c064 100644
> >> --- a/lib/chr-testdev.c
> >> +++ b/lib/chr-testdev.c
> >> @@ -68,3 +68,8 @@ void chr_testdev_init(void)
> >>  	in_vq = vqs[0];
> >>  	out_vq = vqs[1];
> >>  }
> >> +
> >> +bool chr_testdev_available(void)
> >> +{
> >> +	return vcon != NULL;
> >> +}
> >> -- 
> >> 2.32.0
> >>
> > Thanks,
> > drew 
> >
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
