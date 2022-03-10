Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB84FC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 10 Mar 2022 06:59:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B5E5410FF;
	Thu, 10 Mar 2022 01:59:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IDHAL08Af4yT; Thu, 10 Mar 2022 01:59:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19974412AF;
	Thu, 10 Mar 2022 01:59:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E9E0410FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 01:59:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wHQZ+JKntdPV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 01:59:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6229241003
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 01:59:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1646895588;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=skQuq6bUu9CQKoQjP/6DzDdhCXF+NhdIYDq6kSNE/tU=;
 b=hTW2bFynlykMaymzwR/qX9Tx7iAMNYslvPaUq/G9sCodCoL3EDRfyTdSSwlLJkreIjOl8Q
 5Yib7osq89SQh/SqtA0BtEk8ZjxAiAdgVL23mgaar/uia3GSiNxJNfgqvlsg9fXs7PCFOq
 D2QyS4iU0cE3EjhygQNq5k5+CV32kig=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-U1qfsnhrMgmdtgcjPyaziA-1; Thu, 10 Mar 2022 01:59:46 -0500
X-MC-Unique: U1qfsnhrMgmdtgcjPyaziA-1
Received: by mail-ej1-f69.google.com with SMTP id
 hr26-20020a1709073f9a00b006d6d1ee8cf8so2552493ejc.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Mar 2022 22:59:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=skQuq6bUu9CQKoQjP/6DzDdhCXF+NhdIYDq6kSNE/tU=;
 b=BPk+5Pb8Xr4Nfm+ztRykGXmrNe+04zKWyk22/AYL89/Gk0xFiNnpEJJHOcmpmZlyA7
 HGHYJI/HlQgkwtCAxBYsNchPEdsfrqerXShvmtnIDKPNPiKhXl5CKnm/QfgaTO71+STV
 PNmyj+8Hn3pOu0AIh2JsNcG5fwshZfBARFU1HZCVN5rKOZtCT1k1rmWzNlDRLSOc794w
 er3Bgc5GfCkFk/Y/X1GtMpZGjAGmLo/AdYpFrG1lu7zLRhN1B1Pd7jFATrB8r9K9XR7M
 +FoLX/Zjxfa2h/dM/j67unSD/3dt1fXBTJ6Go15jvNaO17krb69YkoSuKtdDtMjOukar
 pRLg==
X-Gm-Message-State: AOAM530OlNAPWB7+VOH1xP6wdVGItrajElFoMuY/xlLt9aRGg0GCiEt3
 6abCmEaiMFV1jZNquHPJ0Wl29b/M5JD8V5dTuElmHi6A9y+qJuoJ7Zuf3Xu+wlvCcry5drwrNj/
 Z0p8aEO828UCoheTN2M/9jTzW
X-Received: by 2002:a05:6402:518c:b0:416:b9bb:46d with SMTP id
 q12-20020a056402518c00b00416b9bb046dmr670701edd.297.1646895585557; 
 Wed, 09 Mar 2022 22:59:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcJDnzMitALmVPhEH/srLzLmpQDrONXmjWGOdwmzwyTnp1nu72Pal3goJ8BGfiwfD2EJCK0A==
X-Received: by 2002:a05:6402:518c:b0:416:b9bb:46d with SMTP id
 q12-20020a056402518c00b00416b9bb046dmr670683edd.297.1646895585295; 
 Wed, 09 Mar 2022 22:59:45 -0800 (PST)
Received: from gator (cst-prg-19-210.cust.vodafone.cz. [46.135.19.210])
 by smtp.gmail.com with ESMTPSA id
 z15-20020a170906240f00b006d703ca573fsm1446380eja.85.2022.03.09.22.59.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Mar 2022 22:59:44 -0800 (PST)
Date: Thu, 10 Mar 2022 07:59:41 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] arm/run: Fix using
 qemu-system-aarch64 to run aarch32 tests on aarch64
Message-ID: <20220310065941.2na6kig2o5hxh4vx@gator>
References: <20220309162117.56681-1-alexandru.elisei@arm.com>
 <20220309162117.56681-3-alexandru.elisei@arm.com>
 <20220309165812.46xmnjek72yrv3g6@gator>
 <Yijf5TlbOKhV+Mw6@monolith.localdoman>
MIME-Version: 1.0
In-Reply-To: <Yijf5TlbOKhV+Mw6@monolith.localdoman>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: pbonzini@redhat.com, thuth@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Mar 09, 2022 at 05:12:05PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Wed, Mar 09, 2022 at 05:58:12PM +0100, Andrew Jones wrote:
> > On Wed, Mar 09, 2022 at 04:21:17PM +0000, Alexandru Elisei wrote:
> > > From: Andrew Jones <drjones@redhat.com>
> > > 
> > > KVM on arm64 can create 32 bit and 64 bit VMs. kvm-unit-tests tries to
> > > take advantage of this by setting the aarch64=off -cpu option. However,
> > > get_qemu_accelerator() isn't aware that KVM on arm64 can run both types
> > > of VMs and it selects qemu-system-arm instead of qemu-system-aarch64.
> > > This leads to an error in premature_failure() and the test is marked as
> > > skipped:
> > > 
> > > $ ./run_tests.sh selftest-setup
> > > SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)
> > > 
> > > Fix this by setting QEMU to the correct qemu binary before calling
> > > get_qemu_accelerator().
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > [ Alex E: Added commit message, changed the logic to make it clearer ]
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  arm/run | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/arm/run b/arm/run
> > > index 2153bd320751..5fe0a45c4820 100755
> > > --- a/arm/run
> > > +++ b/arm/run
> > > @@ -13,6 +13,11 @@ processor="$PROCESSOR"
> > >  ACCEL=$(get_qemu_accelerator) ||
> > >  	exit $?
> > >  
> > > +# KVM for arm64 can create a VM in either aarch32 or aarch64 modes.
> > > +if [ "$ACCEL" = kvm ] && [ -z "$QEMU" ] && [ "$HOST" = "aarch64" ]; then
> > > +	QEMU=qemu-system-aarch64
> > > +fi
> > > +
> > >  qemu=$(search_qemu_binary) ||
> > >  	exit $?
> > >  
> > > -- 
> > > 2.35.1
> > >
> > 
> > So there's a bug with this patch which was also present in the patch I
> > proposed. By setting $QEMU before we call search_qemu_binary() we may
> > force a "A QEMU binary was not found." failure even though a perfectly
> > good 'qemu-kvm' binary is present.
> 
> I noticed that search_qemu_binary() tries to search for both
> qemu-system-ARCH_NAME and qemu-kvm, and I first thought that qemu-kvm is a
> legacy name for qemu-system-ARCH_NAME.
> 
> I just did some googling, and I think it's actually how certain distros (like
> SLES) package qemu-system-ARCH_NAME, is that correct?

Right

> 
> If that is so, one idea I toyed with (for something else) is to move the error
> messages from search_qemu_binary() to the call sites, that way arm/run can first
> try to find qemu-system-aarch64, then fallback to qemu-kvm, and only after both
> aren't found exit with an error. Just a suggestion, in case you find it useful.

We don't have to move the error messages, even if we want to use
search_qemu_binary() as a silent check. We can just call it with
a &>/dev/null and then check its return code. I still need to
allocate some time to think more about this though.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
