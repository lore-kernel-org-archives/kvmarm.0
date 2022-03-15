Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBFEC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 15:16:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28A4949F02;
	Tue, 15 Mar 2022 11:16:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SSqwR2wWkBss; Tue, 15 Mar 2022 11:16:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD9C49EBC;
	Tue, 15 Mar 2022 11:16:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFBB9408B3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 11:16:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lfhIxOoKnp+q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 11:16:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99976408AB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 11:16:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647357396;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=m/7BYXukn7buzDSsXOMYbRlp86FSMB6fqjAlxafd0GI=;
 b=iKV4FEQftp42cB4DU04pz1bU9JoWw3qUT7GfIoh10vJqVw4OZ1Uc0gctpI3vvQtB0MQ+zc
 qxOPZEckkTjsM2M0H1hrbLVojQM5/Q+/0FxG/AO7Sekq6RAoJHallgM1TVIYYR2gL1dgk9
 7m04DBhcKAfbR02op8NFdP9N0Qub7A8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-2EiP-unBMS-HMBnNrYzJCw-1; Tue, 15 Mar 2022 11:16:34 -0400
X-MC-Unique: 2EiP-unBMS-HMBnNrYzJCw-1
Received: by mail-wm1-f72.google.com with SMTP id
 f189-20020a1c38c6000000b0037d1bee4847so1355763wma.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 08:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=m/7BYXukn7buzDSsXOMYbRlp86FSMB6fqjAlxafd0GI=;
 b=ikgRqDEuIbT/aBxorHhH0Lxv23bnW8MXi1KhtlKhIiqbscDUTPlwf6kBzt6AW/GFJB
 gwXZUsbro4SNwhRJLdwSSsFQdJpb0ld6XRbwfy1q6aT/OLnQKzbnSNLyT1Axmeq5MGtX
 rErAxu8mbLIhMkwRUzm/C7/raSg01tdEOHwBklc+EsoKIfPaFDjwEG4E5Ql7AlNqZyT+
 Q6qgUOmxCN96Jkc5NE891+Xe9sl542xYA1LFCYIDEnpkzeMO1CJEmd0QG/Z5qCdupM7g
 3hHSxrj34YI3JRz89nnzPFEIoHZOjSEwqR5vJZs+2ND8xkur7zx6buDKJsWpdGWvVg7l
 EitQ==
X-Gm-Message-State: AOAM532vEmLeJTpeK+hBAA2U2E/upKBPfGdPovIw8g9FMRJW/JDIuHZ3
 3wdMcQAu57i89FC3PI7IGgZjKaOSFvuNdg/6JkIv4iQY1999KQFHW6777nOEwEfyS4p2wU3Kta3
 c4eV76bAfeVf0TJsjwjN0xjdh
X-Received: by 2002:adf:dbd2:0:b0:1ea:9382:6bff with SMTP id
 e18-20020adfdbd2000000b001ea93826bffmr20441374wrj.705.1647357393618; 
 Tue, 15 Mar 2022 08:16:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8Aa12w4oOTyt/U2Fn3zGv+XBxaSJ3EAWOWRw+ZWLtaqS3q+xxi95Suhv+sCUMw2Y229UZCA==
X-Received: by 2002:adf:dbd2:0:b0:1ea:9382:6bff with SMTP id
 e18-20020adfdbd2000000b001ea93826bffmr20441312wrj.705.1647357392616; 
 Tue, 15 Mar 2022 08:16:32 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 l25-20020a1c7919000000b0038999b380e9sm2467699wme.38.2022.03.15.08.16.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 08:16:32 -0700 (PDT)
Date: Tue, 15 Mar 2022 16:16:30 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvm-unit-tests] arch-run: Introduce QEMU_ARCH
Message-ID: <20220315151630.obxraie6ikqrwtrw@gator>
References: <20220315080152.224606-1-drjones@redhat.com>
 <YjCHcV3iyTtSrw3k@monolith.localdoman>
MIME-Version: 1.0
In-Reply-To: <YjCHcV3iyTtSrw3k@monolith.localdoman>
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

On Tue, Mar 15, 2022 at 12:33:17PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Mar 15, 2022 at 09:01:52AM +0100, Andrew Jones wrote:
> > Add QEMU_ARCH, which allows run scripts to specify which architecture
> > of QEMU should be used. This is useful on AArch64 when running with
> > KVM and running AArch32 tests. For those tests, we *don't* want to
> > select the 'arm' QEMU, as would have been selected, but rather the
> > $HOST ('aarch64') QEMU.
> > 
> > To use this new variable, simply ensure it's set prior to calling
> > search_qemu_binary().
> 
> Looks good, tested on an arm64 machine, with ACCEL set to tcg -
> run_tests.sh selects qemu-system-arm; ACCEL unset - run_tests.sh selects
> ACCEL=kvm and qemu-system-aarch64; also tested on an x86 machine -
> run_tests.sh selects ACCEL=tcg and qemu-system-arm:
> 
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> One thing I noticed is that if the user sets QEMU=qemu-system-arm on an arm64
> machine, run_tests.sh still selects ACCEL=kvm which leads to the following
> failure:
> 
> SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)
> 
> I'm not sure if this deserves a fix, if the user set the QEMU variable I
> believe it is probable that the user is also aware of the ACCEL variable
> and the error message does a good job explaining what is wrong.

Yes, we assume the user selected the wrong qemu, rather than assuming the
user didn't expect KVM to be enabled. If we're wrong, then the error
message should hopefully imply to the user that they need to do

 QEMU=qemu-system-arm ACCEL=tcg ...

> Just in
> case, this is what I did to make kvm-unit-tests pick the right accelerator
> (copied-and-pasted the find_word function from scripts/runtime.bash):
> 
> diff --git a/arm/run b/arm/run
> index 94adcddb7399..b0c9613b8d28 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -10,6 +15,10 @@ if [ -z "$KUT_STANDALONE" ]; then
>  fi
>  processor="$PROCESSOR"
> 
> +if [ -z $ACCEL ] && [ "$HOST" = "aarch64" ] && ! find_word "qemu-system-arm" "$QEMU"; then

Instead of find_word,

 [ "$QEMU" ] && [ "$(basename $QEMU)" = "qemu-system-arm" ]

> +       ACCEL=tcg
> +fi
> +

When ACCEL is unset, we currently set it to kvm when we have /dev/kvm and
$HOST == $ARCH_NAME or ($HOST == aarch64 && $ARCH == arm) and tcg
otherwise. Adding logic like the above would allow overriding the
"set to kvm" logic when $QEMU == qemu-system-arm. That makes sense to
me, but we trade one assumption for another. We would now assume that
$QEMU is correct and the user wants to run with TCG, rather than that
$QEMU is wrong and the user wanted to run with KVM.

I think I'd prefer not adding the special case override. I think it's
more likely the user expects to run with KVM when running on an AArch64
host and that they mistakenly selected the wrong qemu, than that they
wanted TCG with qemu-system-arm. We also avoid a few more lines of code
and a change in behavior by maintaining the old assumption.

I've pushed this to arm/queue -- and MR coming up.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
