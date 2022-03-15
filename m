Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA07C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 17:14:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67E7049F18;
	Tue, 15 Mar 2022 13:14:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UBcLPWW+2UYl; Tue, 15 Mar 2022 13:14:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D66449F05;
	Tue, 15 Mar 2022 13:14:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92ADE49E43
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 13:14:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IfE12+4JNB0P for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 13:14:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F239411D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 13:14:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647364460;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=u807ZeNN2qGEsYuS4UPVVqtbsA7t3x+ouYSiSBveyD0=;
 b=aMoDFdlm9LMuyX5MLCX1tQjOPJEeSMURht6xd9GynB7MM3rLAu9nmxonanlCaIHrQIqdvn
 HnSbkriv7S8bmANjaG36EGfBltsAFuYm0EOBGumSRv6F9/Y2mgwOXg+Bmk9H20zOs+h2Uo
 BnYnUyReY5I6T04AzYdM5Wg88Q/6M+U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-lPFVNdZ8OqOObftnMBKfWA-1; Tue, 15 Mar 2022 13:14:17 -0400
X-MC-Unique: lPFVNdZ8OqOObftnMBKfWA-1
Received: by mail-wm1-f70.google.com with SMTP id
 l1-20020a1c2501000000b00389c7b9254cso1130331wml.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 10:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=u807ZeNN2qGEsYuS4UPVVqtbsA7t3x+ouYSiSBveyD0=;
 b=B9J5M/XRygszzHuMY7H0cuX380gaJKDjiKAVwNwmawykYrmzxGCIeVk1sFhEglwn+h
 eGA6trwRSciYbpvEBdz3MN7lxJ27V9Z1gW1ZdKyYQanAg2CgBT4sMfctDsFiOtlzYibs
 Rbov/segeINfj1y++PMrCGfygAjnz29hDDtlwZaVi/O4mNos7k8LZDdu2iZh7IOfcAd+
 w0ebwV0Xo+lgEzAly1QHJ0RyN5G2zdxTjAf3syCshSD1yllIIEhrzqzZ4hAhuze7RXUE
 Ojxlk0PGR/e0TH8cgPHo/wQ+ftaayl2Cwo+9L7Ma4DxDv4mccts/swWZ05L39QeC3vem
 yxIQ==
X-Gm-Message-State: AOAM533NAPQDVf2EGrwVsVlmMHEf4rxM8UfNPA/TWv4NIq9WAAhdSoOq
 E84WQPTsZIe47WTBbx9FIlIDJAPH2JS56p+1258Ue52hSjlPkcF91cjxfuMDtUDOJowzU9upFPI
 hRs3jhxyYqiANweN7QfgEPTih
X-Received: by 2002:a5d:5512:0:b0:1ef:5f08:29fb with SMTP id
 b18-20020a5d5512000000b001ef5f0829fbmr21204939wrv.653.1647364455726; 
 Tue, 15 Mar 2022 10:14:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYqL5fPHSADziBs+XqlZkT9FX7MI9CEk0Zn3ysRNe2yyWlIwJCNPYYOU/70wMG7mwc8FemXw==
X-Received: by 2002:a5d:5512:0:b0:1ef:5f08:29fb with SMTP id
 b18-20020a5d5512000000b001ef5f0829fbmr21204918wrv.653.1647364455472; 
 Tue, 15 Mar 2022 10:14:15 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 u11-20020a05600c19cb00b00389efe9c512sm3184824wmq.23.2022.03.15.10.14.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 10:14:14 -0700 (PDT)
Date: Tue, 15 Mar 2022 18:14:12 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvm-unit-tests] arch-run: Introduce QEMU_ARCH
Message-ID: <20220315171412.5esfm4ygjjq2bbjh@gator>
References: <20220315080152.224606-1-drjones@redhat.com>
 <YjCHcV3iyTtSrw3k@monolith.localdoman>
 <20220315151630.obxraie6ikqrwtrw@gator>
 <YjC62NycFfevZ4wx@monolith.localdoman>
MIME-Version: 1.0
In-Reply-To: <YjC62NycFfevZ4wx@monolith.localdoman>
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

On Tue, Mar 15, 2022 at 04:31:34PM +0000, Alexandru Elisei wrote:
> Well, kvm-unit-tests selects KVM or TCG under the hood without the user
> being involved at all.

The under the hood aspect isn't great. It's best for testers to know what
they're testing. It's pretty obvious, though, that if you choose
ARCH != HOST that you'll end up on TCG. And, since KVM has historically
been the primary focus of kvm-unit-tests, then it's probably reasonable
to assume KVM is used when ARCH == HOST. However, we still silently fall
back to TCG, even when ARCH == HOST, if /dev/kvm isn't available! And,
the whole AArch32 guest support on AArch64 hosts with KVM requiring a
different qemu binary muddies things further...

Anyway, I hope serious test runners always specify ACCEL and QEMU to
whatever they plan to test.

> In my opinion, it's slightly better from an
> usability perspective for kvm-unit-tests to do its best to run the tests
> based on what the user specifically set (QEMU=qemu-system-arm) than fail to
> run the tests because of an internal heuristic of which the user might be
> entirely ignorant (if arm64 and /dev/kvm is available, pick ACCEL=kvm).

If you'd like to post a patch for it, then I'd prefer something like
below, which spells out the condition that the override is applied
and also allows $QEMU to be checked by search_qemu_binary() before
using it to make decisions.

Thanks,
drew

diff --git a/arm/run b/arm/run
index 28a0b4ad2729..128489125dcb 100755
--- a/arm/run
+++ b/arm/run
@@ -10,16 +10,24 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 processor="$PROCESSOR"
 
-ACCEL=$(get_qemu_accelerator) ||
+accel=$(get_qemu_accelerator) ||
        exit $?
 
-if [ "$ACCEL" = "kvm" ]; then
+if [ "$accel" = "kvm" ]; then
        QEMU_ARCH=$HOST
 fi
 
 qemu=$(search_qemu_binary) ||
        exit $?
 
+if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
+   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
+   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
+       accel=tcg
+fi
+
+ACCEL=$accel
+
 if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
        echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
        exit 2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
