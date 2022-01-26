Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12FCC28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:12:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D08449B08;
	Wed, 26 Jan 2022 10:12:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Rk0e6dNpbJC; Wed, 26 Jan 2022 10:12:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E14749E27;
	Wed, 26 Jan 2022 10:12:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A928F40BAF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:12:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uF5TV+6bL3g8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:12:34 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 931E140658
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:12:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643209954;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UUIXRDsB43LqGC6wuVo5tX7u3LkbrScUsL4k4ngSu2Y=;
 b=W4zik2eG40YkFtA8d2/yLSWgTOg0vcF6M2XB2Vh4J449Wg98ARJHJAxSkHKh9C7NRSi4l5
 CEWJjR1AQEOR4jNnpukMOS7kFob7zJdN0vqIW888KCc58dlP3oYwJtnQmr3N5Ew8FPKBPJ
 P8CPZRr2Ltma9lyFeobhOS5ykXB/MzM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-T-NmGVwXPImDofn_mDD0ZQ-1; Wed, 26 Jan 2022 10:12:31 -0500
X-MC-Unique: T-NmGVwXPImDofn_mDD0ZQ-1
Received: by mail-ej1-f70.google.com with SMTP id
 13-20020a170906328d00b006982d0888a4so4982176ejw.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 07:12:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UUIXRDsB43LqGC6wuVo5tX7u3LkbrScUsL4k4ngSu2Y=;
 b=KPlAK9dClL+HqMUw2wnf8oR8vaUmYWO9UcYZVaFLm0BTMl5jix88x7re0Nv2InD1Pp
 xFFr2RkqZDIBKfdniCMwCq6tWvRbmEZ790dqvCbAALIrU0FNEXlcU7Gpk59NJCKHoU3K
 uOXfyeD/g0w2aYFGGuJ/7NEzxU2HYRqEbyg4S6YW+VrDPOYmKmDG/g9nsVZGtWzVbN4Z
 XXcHrKJCg68VU8hKri5jCTQfI/NnRiFeDRlDMJhi/Z1PrlG5gsUil6W9oyRdCjrai1RR
 aGtkpEmj5vtf9bEVfiMIp7WwuaLkKqkWKnK4ilFyCnm1npRG1lGkrPg7x2Ig54cWEfkF
 hZ5A==
X-Gm-Message-State: AOAM533rJQlHHmFIg36jq9crhIJ07hzcdImUbSFQHqSiviVzFT/kZo8e
 2r1jQEBhXo7Yv9UNnIHbsK5+ftpyGwIAlkavfLZ9U/2o9gzONA/BdgLHWgGAw5ix4U5OSpvF8fL
 Nd13KpRMHqcUiURbQGbZOolXp
X-Received: by 2002:a05:6402:1e93:: with SMTP id
 f19mr24928682edf.343.1643209949954; 
 Wed, 26 Jan 2022 07:12:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6Qy96gPxqMhyDBBrrHHmi32FfITBGmSSHPgu5dt26Cvx+nGMpg11N+n6bAEnecDU6AecWoQ==
X-Received: by 2002:a05:6402:1e93:: with SMTP id
 f19mr24928663edf.343.1643209949742; 
 Wed, 26 Jan 2022 07:12:29 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id u17sm7479631ejb.31.2022.01.26.07.12.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jan 2022 07:12:29 -0800 (PST)
Date: Wed, 26 Jan 2022 16:12:27 +0100
From: Andrew Jones <drjones@redhat.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
Message-ID: <20220126151227.jlhb5o32jwal24m6@gator>
References: <20220126145242.3473836-1-broonie@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220126145242.3473836-1-broonie@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-kselftest@vger.kernel.org
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

On Wed, Jan 26, 2022 at 02:52:42PM +0000, Mark Brown wrote:
> The arch_timer and vgic_irq kselftests assume that they can create a
> vgic-v3, using the library function vgic_v3_setup() which aborts with a
> test failure if it is not possible to do so. Since vgic-v3 can only be
> instantiated on systems where the host has GICv3 this leads to false
> positives on older systems where that is not the case.
> 
> Fix this by changing vgic_v3_setup() to return an error if the vgic can't
> be instantiated and have the callers skip if this happens. We could also
> exit flagging a skip in vgic_v3_setup() but this would prevent future test
> cases conditionally deciding which GIC to use or generally doing more
> complex output.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> 
> v3:
>  - Use custom print_skip() helper.
>  - Use internal version of _kvm_create_device.
> v2:
>  - The test for being able to create the GIC doesn't actually
>    instantiate it, add a call doing so in that case.
> 
>  tools/testing/selftests/kvm/aarch64/arch_timer.c | 7 ++++++-
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 4 ++++
>  tools/testing/selftests/kvm/lib/aarch64/vgic.c   | 4 +++-
>  3 files changed, 13 insertions(+), 2 deletions(-)
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
