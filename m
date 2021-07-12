Return-Path: <SRS0=bTo6=ME=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27AB0C11F66
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 16:37:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A7E161221
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 16:37:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A7E161221
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 189F040CF8;
	Mon, 12 Jul 2021 12:37:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SRCphGY0OhnN; Mon, 12 Jul 2021 12:37:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0748340839;
	Mon, 12 Jul 2021 12:37:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7274048B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 12:37:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tmsHiqf14FP9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Jul 2021 12:37:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCBC840489
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 12:37:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626107868;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=DmsrfUJqVuzKIhoeVB1ab8GPQvYJh20rCkMxoqwgccc=;
 b=iLcJaA84nFVoUH12X/mg1M6/IB6BEiXGRP/w/SUBVbTkpxA1Bor1X9vtVmqhoZHD5q7y3g
 DnKzkMIY+aeqW8xkd8KdGpqgJD/NqLLkoseE88HuP12mqCAhv/ZPdCPC9VswQ8nYFCAUI4
 9YbKCKZ36D/zW3dwNOMitmWpJaLc2II=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-i9ZC5zFRNWiiSYqGqUlUQA-1; Mon, 12 Jul 2021 12:37:47 -0400
X-MC-Unique: i9ZC5zFRNWiiSYqGqUlUQA-1
Received: by mail-il1-f200.google.com with SMTP id
 s12-20020a056e02216cb02901f9cee02769so5764430ilv.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 09:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DmsrfUJqVuzKIhoeVB1ab8GPQvYJh20rCkMxoqwgccc=;
 b=e1Vm0upYurpAfx596b9yEPfF57GbimH7TP0zaU8HUdI4n2KpEW1NBWJD3U3BpYeDtF
 QsAujsLPS1NmD+c9CVAfnDGX9t+INKui1Nfse2+s/rU+XjvIvM/YPXj6+KFu1xwNz6kf
 I8jsXex0Py6cX0t4irnS1ROKp2N/Hn55Nd+DFb2G7vUXTnsFiGpfiLSCLOk33tWZCGbZ
 VRWgwEzl9Ble7T0xI5Rf73PWoW/mgrxzeN3ih3bV88HOs3CZj/DtyhpoQdvr8mZM91r3
 DlNw+8woktGW+XTxbSZYeqCDRWq8r0EDt4P0cFcwnb1BqJFvaou0tbV0VgQkmrznpT9a
 vbMg==
X-Gm-Message-State: AOAM532R15KigqM9DwWJvxNEzN5XsBnJfWvI7VaCLXWs29J8b422NOhd
 eaWbQrO/afp7uJdZ58/A83O2FHM4mBmVstsvEKdjcBg+DidpvPVLXdJWZxqkMPYA6OLqNeXloic
 TtEFYEoU7DZrzYxOiM8RjbxzU
X-Received: by 2002:a92:7a12:: with SMTP id v18mr11239779ilc.27.1626107866875; 
 Mon, 12 Jul 2021 09:37:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVBVoWaMr/V5Gyw1JMvoSpF+iBmSnxs3Lb0dTzJIaWKLxJccOVfvstXhDuQpUmyCOaoGc3Jw==
X-Received: by 2002:a92:7a12:: with SMTP id v18mr11239751ilc.27.1626107866573; 
 Mon, 12 Jul 2021 09:37:46 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id y13sm7797842ioa.51.2021.07.12.09.37.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Jul 2021 09:37:46 -0700 (PDT)
Date: Mon, 12 Jul 2021 18:37:44 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 2/5] scripts: Rename run_qemu_status
 -> run_test_status
Message-ID: <20210712163744.5qj3jddg4j6abuq4@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210702163122.96110-3-alexandru.elisei@arm.com>
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

On Fri, Jul 02, 2021 at 05:31:19PM +0100, Alexandru Elisei wrote:
> kvm-unit-tests will get support for running tests automatically under
> kvmtool, rename the function to make it more generic.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/arch-run.bash | 2 +-
>  powerpc/run           | 2 +-
>  s390x/run             | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 5997e384019b..8ceed53ed7f8 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -69,7 +69,7 @@ run_qemu ()
>  	return $ret
>  }
>  
> -run_qemu_status ()
> +run_test_status ()
>  {
>  	local stdout ret
>  
> diff --git a/powerpc/run b/powerpc/run
> index 597ab96ed8a8..312576006504 100755
> --- a/powerpc/run
> +++ b/powerpc/run
> @@ -31,4 +31,4 @@ command="$(migration_cmd) $(timeout_cmd) $command"
>  # to fixup the fixup below by parsing the true exit code from the output.
>  # The second fixup is also a FIXME, because once we add chr-testdev
>  # support for powerpc, we won't need the second fixup.
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> diff --git a/s390x/run b/s390x/run
> index c615caa1b772..5a4bb3bda805 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -28,4 +28,4 @@ command+=" -kernel"
>  command="$(timeout_cmd) $command"
>  
>  # We return the exit code via stdout, not via the QEMU return code
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> -- 
> 2.32.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
