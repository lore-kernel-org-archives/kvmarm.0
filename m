Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2365C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 14:49:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64F224B907;
	Fri, 25 Feb 2022 09:49:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c5pJy2GnYV6G; Fri, 25 Feb 2022 09:49:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9CCA4B92C;
	Fri, 25 Feb 2022 09:49:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ED984B92B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 09:49:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cKQQpUBIjak4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 09:49:55 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D4694B900
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 09:49:55 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1645800594;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oG46p9ApnGlILl1ZLvkfxhnD10O2+FDP9Z7Tm2fwr+c=;
 b=Q4FannQMidh+cKStF5mM7UjA0ru81slTT9xfeYeW91GYut47wLCpMAoLj1KSUWLCoYuGui
 imRHQWoFvv7g+bmt7ILnLHzqu4jYU0bKIepF7D45Kto85la9TYHHjLcwhdb+pfOuK3UEqb
 L5wERKOD7za39oi4iIMz1OTdRcD95vY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-ApsMbUurNy-X0m96RwkmIA-1; Fri, 25 Feb 2022 09:49:53 -0500
X-MC-Unique: ApsMbUurNy-X0m96RwkmIA-1
Received: by mail-wm1-f70.google.com with SMTP id
 h19-20020a05600c351300b0038141cf26deso43462wmq.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 06:49:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=oG46p9ApnGlILl1ZLvkfxhnD10O2+FDP9Z7Tm2fwr+c=;
 b=Re0YTl5EzS2/s+QXJBxqnPsV5Zm0lh3DLg4BzfJNcj/nsQUFDLhr7dgCvKjL+iMB4C
 u/OeTNrHwi2z9BPLAbZv3MNTMykBT0z0440Um6u4fqZqKSJy7EMmNZMrFEC64F1KpZBZ
 sQxbJfuuyYZr5LE5VUHscb4o/m1d1oKarvvkSFPgrxuojlkh4xkP+B5z+jO2o5oFr9nQ
 2Lpm/sfnENMBrDa1sAjPi7kYTP2W3N4hus2mBamCLBhnMTbUWwR8YYWig91jlfM1jBMJ
 XZPoRMIzOKiOYGwUkbIYMJkAqUtHD3IMZMLTnrLQ8vvoJUXAsj0gbEtqBqP6ShL13Rsi
 J0zw==
X-Gm-Message-State: AOAM53046SU8aD9rNpkXcCOAi0hHBRGvnUcfgpTgh8KzZUj6s2h4jTvT
 9xDxRne8s0lP6yJGla+xWzozsPQv950xdqgU3m1C8Ov2tuTkHzpagD56bodhw32gmRSt1taA3ZV
 BxrD9BcFlh+uougTl6yrkAbXY
X-Received: by 2002:a05:6000:3c6:b0:1e4:a380:bb53 with SMTP id
 b6-20020a05600003c600b001e4a380bb53mr6213171wrg.559.1645800591923; 
 Fri, 25 Feb 2022 06:49:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPvZpYeV1cMChykbmMIlrqZ62jXUzNXFVvdiNhkV7FTQ/vQZtP351aVYLRANF8AJomAWs86Q==
X-Received: by 2002:a05:6000:3c6:b0:1e4:a380:bb53 with SMTP id
 b6-20020a05600003c600b001e4a380bb53mr6213154wrg.559.1645800591650; 
 Fri, 25 Feb 2022 06:49:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id
 l26-20020a05600c1d1a00b00380def7d3desm2672667wms.17.2022.02.25.06.49.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 25 Feb 2022 06:49:51 -0800 (PST)
Message-ID: <b03f6e27-bd55-e06b-af8d-a4e6bdf5d778@redhat.com>
Date: Fri, 25 Feb 2022 15:49:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.17, take #4
To: Marc Zyngier <maz@kernel.org>
References: <20220225131302.107215-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220225131302.107215-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 2/25/22 14:13, Marc Zyngier wrote:
> Hi Paolo,
> 
> Only a couple of fixes this time around: one for the long standing
> PSCI CPU_SUSPEND issue, and a selftest fix for systems that don't have
> a GICv3.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 5bfa685e62e9ba93c303a9a8db646c7228b9b570:
> 
>    KVM: arm64: vgic: Read HW interrupt pending state from the HW (2022-02-11 11:01:12 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-4
> 
> for you to fetch changes up to 456f89e0928ab938122a40e9f094a6524cc158b4:
> 
>    KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3 (2022-02-25 13:02:28 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.17, take #4
> 
> - Correctly synchronise PMR and co on PSCI CPU_SUSPEND
> 
> - Skip tests that depend on GICv3 when the HW isn't available
> 
> ----------------------------------------------------------------
> Mark Brown (1):
>        KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3
> 
> Oliver Upton (1):
>        KVM: arm64: Don't miss pending interrupts for suspended vCPU
> 
>   arch/arm64/kvm/psci.c                            | 3 +--
>   tools/testing/selftests/kvm/aarch64/arch_timer.c | 7 ++++++-
>   tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 4 ++++
>   tools/testing/selftests/kvm/lib/aarch64/vgic.c   | 4 +++-
>   4 files changed, 14 insertions(+), 4 deletions(-)
> 

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
