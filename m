Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BB8C43215
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 15:15:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A91A921781
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 15:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHoXGEgW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A91A921781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31AE34AE8E;
	Thu, 28 Nov 2019 10:15:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A9YdKqSqqlcC; Thu, 28 Nov 2019 10:15:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FC694ACBA;
	Thu, 28 Nov 2019 10:15:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3D864A5C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 10:15:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id czCk7hp0qiUy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 10:15:13 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D47F74A4DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 10:15:13 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1574954113;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references:openpgp:openpgp;
 bh=hfUt0po4HUkFebbmizcVL2YPqGm9Z9smJkavIxeX74U=;
 b=SHoXGEgW5ai/jXl1pE3/Q38g8PHcPoJsHxAcIa/2NYS0BN69EyIpZRdPdsUKrnERVzVETh
 lG3wYZ5l+n1su6d74Xty8p0rtsE9MqdJyi7YMU1hQq1ZfaRvRJqliURw/hZ21WwvAFj7o/
 wSb0+12FSf+XCQZHVmXSimdZ3uRyiZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-7JlSLQCEMNaPr56R7JzhtA-1; Thu, 28 Nov 2019 10:15:10 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FB91107ACC5;
 Thu, 28 Nov 2019 15:15:09 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-114.ams2.redhat.com [10.36.116.114])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5455119C6A;
 Thu, 28 Nov 2019 15:15:08 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] arm: Enable the VFP
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20191128143421.13815-1-drjones@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <05576e71-eb32-e41f-5631-1cd90b4dddd5@redhat.com>
Date: Thu, 28 Nov 2019 16:15:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191128143421.13815-1-drjones@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 7JlSLQCEMNaPr56R7JzhtA-1
X-Mimecast-Spam-Score: 0
Cc: pbonzini@redhat.com
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

On 28/11/2019 15.34, Andrew Jones wrote:
> Variable argument macros frequently depend on floating point
> registers. Indeed we needed to enable the VFP for arm64 since its
> introduction in order to use printf and the like. Somehow we
> didn't need to do that for arm32 until recently when compiling
> with GCC 9.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
> 
> CC'ing Thomas because I think he had to workaround travis tests
> failing due to this issue once. Maybe travis can now be
> un-worked-around?

Yes, this patch fixes the problem with GCC9 for me:

 https://gitlab.com/huth/kvm-unit-tests/-/jobs/364079089

Feel free to add my

Tested-by: Thomas Huth <thuth@redhat.com>

and if you like, please also include this hunk:

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -17,7 +17,7 @@ build-aarch64:

 build-arm:
  script:
- - dnf install -y qemu-system-arm gcc-arm-linux-gnu-8.2.1-1.fc30.2
+ - dnf install -y qemu-system-arm gcc-arm-linux-gnu
  - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh

 Thomas

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
