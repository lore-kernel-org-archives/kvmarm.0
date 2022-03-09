Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F69EC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 16:58:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB09149E17;
	Wed,  9 Mar 2022 11:58:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bX-QGPaz9ZwC; Wed,  9 Mar 2022 11:58:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0D9249E3C;
	Wed,  9 Mar 2022 11:58:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB2A249E35
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:58:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lmM-bPUXTUkx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 11:58:24 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB38649E17
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:58:24 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1646845104;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SAUeJG8UY6RhUcIGm8viMKGF/F+Mz8ELefSwyfTVQTI=;
 b=f3dBURq/T4TKn6Hb4JHkwT9aZkapwPiHLE3Y+Lo3S0cDW1nL8aAPIeAxLYqa7HqCyzhWTd
 ZJOXW1psRpvvf8bkTCxiQGM3C0wmLbaQjp7AnFa81wCCNmkCpflBRGd5UTynbB974i9b5z
 yY8hPTJcT6KwN2H7GXwhfKK+42mouRA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-h3b5vQIiNV6OTKRq99tJvQ-1; Wed, 09 Mar 2022 11:58:23 -0500
X-MC-Unique: h3b5vQIiNV6OTKRq99tJvQ-1
Received: by mail-ej1-f71.google.com with SMTP id
 og24-20020a1709071dd800b006dab87bec4fso1651791ejc.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Mar 2022 08:58:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SAUeJG8UY6RhUcIGm8viMKGF/F+Mz8ELefSwyfTVQTI=;
 b=bU243dJJfSqqqiuX3ULeyiNUSdtWBmiTHHB6J2HMt2Gsy2EMjaL6b9KIF5FmCDdVKE
 fA90Ho/PMqiGio61YN+OINMmHGRT6lYW/no0wx1op3EtUSB++wSsQsx6G3Nr4JaAsDSW
 daEjZGUSTdFY4BSmNV17CcVcCTU7j2tL+fJSsEOjZORa0enneraZxIDpGV2sOG/Xw2tl
 9P63cpRmj/K/MbtMxOn/npUumK87uspu5POP/7748+qM9wtZPEjcCHVHF28k54ibnXGW
 i0VTMcCjNmBobjXphx4oiQXycY7JzIm57wSLzjjXJcwnkdyuFCvNLk6OAm5ck/nFhz5D
 2h7g==
X-Gm-Message-State: AOAM530QEm1Wq1DYNSxsfHRroHyRCXXuGPqTRXg68YzkMQ5DtZcl6kh0
 Ci94p8Utjd4Ez3UiMJjmc9drSnKiltzoiVJfSqAkRtsVXVjm57Ufw0SsJRXVoRo4rC+lcLqyjBw
 Vg/sM4xzz8ID2nCrIDl7AUqP2
X-Received: by 2002:a17:907:c1c:b0:6db:62b7:8357 with SMTP id
 ga28-20020a1709070c1c00b006db62b78357mr637251ejc.536.1646845096314; 
 Wed, 09 Mar 2022 08:58:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLGi3RtaPnymESOcjh/lKXdPE2+WXXCEbhupK9tOpWsDHLVS5te2YjIiSdqV+8bbb7Q0NcVg==
X-Received: by 2002:a17:907:c1c:b0:6db:62b7:8357 with SMTP id
 ga28-20020a1709070c1c00b006db62b78357mr637236ejc.536.1646845096102; 
 Wed, 09 Mar 2022 08:58:16 -0800 (PST)
Received: from gator (cst-prg-78-140.cust.vodafone.cz. [46.135.78.140])
 by smtp.gmail.com with ESMTPSA id
 v2-20020a509d02000000b00412d53177a6sm1071505ede.20.2022.03.09.08.58.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Mar 2022 08:58:15 -0800 (PST)
Date: Wed, 9 Mar 2022 17:58:12 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] arm/run: Fix using
 qemu-system-aarch64 to run aarch32 tests on aarch64
Message-ID: <20220309165812.46xmnjek72yrv3g6@gator>
References: <20220309162117.56681-1-alexandru.elisei@arm.com>
 <20220309162117.56681-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20220309162117.56681-3-alexandru.elisei@arm.com>
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

On Wed, Mar 09, 2022 at 04:21:17PM +0000, Alexandru Elisei wrote:
> From: Andrew Jones <drjones@redhat.com>
> 
> KVM on arm64 can create 32 bit and 64 bit VMs. kvm-unit-tests tries to
> take advantage of this by setting the aarch64=off -cpu option. However,
> get_qemu_accelerator() isn't aware that KVM on arm64 can run both types
> of VMs and it selects qemu-system-arm instead of qemu-system-aarch64.
> This leads to an error in premature_failure() and the test is marked as
> skipped:
> 
> $ ./run_tests.sh selftest-setup
> SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)
> 
> Fix this by setting QEMU to the correct qemu binary before calling
> get_qemu_accelerator().
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> [ Alex E: Added commit message, changed the logic to make it clearer ]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/run | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arm/run b/arm/run
> index 2153bd320751..5fe0a45c4820 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -13,6 +13,11 @@ processor="$PROCESSOR"
>  ACCEL=$(get_qemu_accelerator) ||
>  	exit $?
>  
> +# KVM for arm64 can create a VM in either aarch32 or aarch64 modes.
> +if [ "$ACCEL" = kvm ] && [ -z "$QEMU" ] && [ "$HOST" = "aarch64" ]; then
> +	QEMU=qemu-system-aarch64
> +fi
> +
>  qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> -- 
> 2.35.1
>

So there's a bug with this patch which was also present in the patch I
proposed. By setting $QEMU before we call search_qemu_binary() we may
force a "A QEMU binary was not found." failure even though a perfectly
good 'qemu-kvm' binary is present.

I'll try to come up with something better.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
