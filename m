Return-Path: <SRS0=yjsw=MF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E4DC07E95
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 07:45:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1E8E61249
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 07:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1E8E61249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F8D04A418;
	Tue, 13 Jul 2021 03:45:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jzf-glsqJgJM; Tue, 13 Jul 2021 03:45:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F1C4A003;
	Tue, 13 Jul 2021 03:45:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4584240629
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 03:45:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lX1G6QoEyOy3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Jul 2021 03:45:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55CD749FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 03:45:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626162351;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NzhMW8UmyexogLd7WLsnQ7mohPd+vth26CSjnwu5sho=;
 b=Iu75wkocVYXGyhqluH+KeC1bwgusaWyVkTszOJNUk7PsnFub1jRCXgSpoC0lgbtUFTfHex
 sR7DhCncpAl2mojqRhPIc9+pGimRHbfEtzbeVBzXiGQMYtWZlaqdXbjXDcStF1Wj4EoeBg
 C3+GZHc8OoU+Nj0PKes5Zwr3UsqUxwE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-n5kGxghaMX-yUl35G9-tFQ-1; Tue, 13 Jul 2021 03:45:47 -0400
X-MC-Unique: n5kGxghaMX-yUl35G9-tFQ-1
Received: by mail-wr1-f71.google.com with SMTP id
 m9-20020a5d4a090000b029013e2b4a9d1eso4053934wrq.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 00:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=NzhMW8UmyexogLd7WLsnQ7mohPd+vth26CSjnwu5sho=;
 b=RI+sU/O5ZfGb2XBMBA4Uxg1GmVidVuVKxT5cPnACxJ1xnSlblJOjOy0J7Fn2yMUTYF
 8CkWY1b5cZvRhLpzAdQl0WemFi5VIVB1XR4d+iX4AEu6yU4MsufXHPij4xE0EfHChVhi
 xj4ztWvyqByq57EPS10DdtXLHa4oMw3hRZhm00gKfAbKWPkR52U4Txg7oHIhZgz6jyoV
 kSqehZUYdya2Ztkfbhua8SU5duUTQj1VH3b9hIrLMQvIhj/qn++WB7lAsdCYj+wBu21m
 0sjMG0g7q2vyaSZ9bscOiM/L2UYlxd3ACE7A8hsv4P+2Ue/iCt7kKslWVeocKBUlO8BC
 dH9A==
X-Gm-Message-State: AOAM5326s1xWwZjdc4J/GEOcXmQnUn65dUSHrAQ2hfdyd/S+AM2H9ARc
 3l5Xzm2bRyxtiGD3q0zd/fSGAxz3YGK3VnJdlH2lGFANqEqB/vKcdQNE8rgM2IZoGq4fC4UTeZB
 p+uzGCgCaAAL53X/s+rUzeVH5
X-Received: by 2002:a5d:4f82:: with SMTP id d2mr3896521wru.345.1626162346355; 
 Tue, 13 Jul 2021 00:45:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCWsmYfh0hjLY/M0FVKG9/E4Vh+zpZr2m1Ysr7LX2IDMssKj2c36kIzZD77QuB8ng/nRFXng==
X-Received: by 2002:a5d:4f82:: with SMTP id d2mr3896486wru.345.1626162346098; 
 Tue, 13 Jul 2021 00:45:46 -0700 (PDT)
Received: from thuth.remote.csb (pd9575fd2.dip0.t-ipconnect.de.
 [217.87.95.210])
 by smtp.gmail.com with ESMTPSA id z17sm865725wrs.54.2021.07.13.00.45.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Jul 2021 00:45:45 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 2/5] scripts: Rename run_qemu_status ->
 run_test_status
To: Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
 pbonzini@redhat.com, lvivier@redhat.com, kvm-ppc@vger.kernel.org,
 david@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
 imbrenda@linux.ibm.com, linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-3-alexandru.elisei@arm.com>
From: Thomas Huth <thuth@redhat.com>
Message-ID: <24f5629f-eff4-11b3-30a3-c6052f533ced@redhat.com>
Date: Tue, 13 Jul 2021 09:45:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702163122.96110-3-alexandru.elisei@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=thuth@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: vivek.gautam@arm.com, andre.przywara@arm.com, maz@kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 02/07/2021 18.31, Alexandru Elisei wrote:
> kvm-unit-tests will get support for running tests automatically under
> kvmtool, rename the function to make it more generic.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   scripts/arch-run.bash | 2 +-
>   powerpc/run           | 2 +-
>   s390x/run             | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 5997e384019b..8ceed53ed7f8 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -69,7 +69,7 @@ run_qemu ()
>   	return $ret
>   }
>   
> -run_qemu_status ()
> +run_test_status ()
>   {
>   	local stdout ret
>   
> diff --git a/powerpc/run b/powerpc/run
> index 597ab96ed8a8..312576006504 100755
> --- a/powerpc/run
> +++ b/powerpc/run
> @@ -31,4 +31,4 @@ command="$(migration_cmd) $(timeout_cmd) $command"
>   # to fixup the fixup below by parsing the true exit code from the output.
>   # The second fixup is also a FIXME, because once we add chr-testdev
>   # support for powerpc, we won't need the second fixup.
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> diff --git a/s390x/run b/s390x/run
> index c615caa1b772..5a4bb3bda805 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -28,4 +28,4 @@ command+=" -kernel"
>   command="$(timeout_cmd) $command"
>   
>   # We return the exit code via stdout, not via the QEMU return code
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
