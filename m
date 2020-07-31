Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C96EC433DF
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 11:26:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E99A0208E4
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 11:26:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0T1n5+p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E99A0208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E92A4B24A;
	Fri, 31 Jul 2020 07:26:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JbKOTWn+4MMA; Fri, 31 Jul 2020 07:26:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5270D4B293;
	Fri, 31 Jul 2020 07:26:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD02C4B237
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 07:26:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LoS20Ok7MLFj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 07:26:03 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF7C54B233
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 07:26:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596194762;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qOaj9Z+2J+hwBOQBlLHm+67/cw8pKJ5RjzcvJzQQPlo=;
 b=i0T1n5+pWjw02E6d0J1/KA1JwVogtZ703RnSWUGGUlPEHLGXnYRo+84ILJ+1ynzxdjITPK
 TOhX8GTLaVcqWn5Cn/gWFx71lIsFlQxiWZXIoG2ourw3tRws6Ve5Wj/uexYfjObXeVesYn
 ERWRoditJWSgW8paA0KLjXIIIwx+oMo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-LBS_OzdIOGeYEFwmumqDTA-1; Fri, 31 Jul 2020 07:26:01 -0400
X-MC-Unique: LBS_OzdIOGeYEFwmumqDTA-1
Received: by mail-wr1-f70.google.com with SMTP id k11so8541720wrv.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=qOaj9Z+2J+hwBOQBlLHm+67/cw8pKJ5RjzcvJzQQPlo=;
 b=Ev1U4JX16GAC4MSqjDH0CURsXyFLL5B5SMiEjv46f50Nu7Njwfhbsdv+4KQgsYKIVY
 oueCC3AEXsEbXDoXPPq+duxsGoZj2H12J8EaJ4TYrlvKfocg6O3pfAjvTAfT6WelXCUV
 yIyERRk1T26N2iwsukRN4ZCLCyFCWTpgqjIZdLqvQPZwMvkH9f6zCg1GPmjQ8gmnHzSA
 h36+XBbpQYDwvX4c39MJjc/GnYqKQpzqstuKLmC/1xuH+KN/BPbS/ADrnfwMMCNe0apj
 zfayEjEoEHJ2vfrx7HdjVOA/khX4yj8AauIJqxJb0tX1PDRkLofnz6olDxDNzbZ4ALjE
 TklA==
X-Gm-Message-State: AOAM530ZTe9BJ8Y6UZ3vhQGA7bXA78xrcaLtoW5+hdrBuK2IA5k7aoEj
 Np8/OlvcHiJ5UpXfOuv4D7sDX0UqoaK45PgAJSN3c4EgzHtwmL8UIxzHJWh7iRdnO0FNhYtL52n
 AQWKiNqyOh1T7InvIZgjQPqch
X-Received: by 2002:adf:f486:: with SMTP id l6mr3109672wro.265.1596194760248; 
 Fri, 31 Jul 2020 04:26:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwk/sUGOSyrEXkSz7ip47hO4+s0lhkAC2W0ZVyNgZ4SZAfSzwoO1WyP1uGy8VewJvKt/OOPNQ==
X-Received: by 2002:adf:f486:: with SMTP id l6mr3109648wro.265.1596194759982; 
 Fri, 31 Jul 2020 04:25:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:310b:68e5:c01a:3778?
 ([2001:b07:6468:f312:310b:68e5:c01a:3778])
 by smtp.gmail.com with ESMTPSA id r22sm5313359wmh.45.2020.07.31.04.25.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 31 Jul 2020 04:25:59 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.8, take #4
To: Marc Zyngier <maz@kernel.org>
References: <20200728082255.3864378-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <29d7df19-0621-2589-50c6-c00b726e2c05@redhat.com>
Date: Fri, 31 Jul 2020 13:25:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200728082255.3864378-1-maz@kernel.org>
Content-Language: en-US
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Nick Desaulniers <ndesaulniers@google.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 28/07/20 10:22, Marc Zyngier wrote:
> Hi Paolo,
> 
> This is the last batch of fixes for 5.8. One fixes a long standing MMU
> issue, while the other addresses a more recent brekage with out-of-line
> helpers in the nVHE code.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit b9e10d4a6c9f5cbe6369ce2c17ebc67d2e5a4be5:
> 
>   KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART (2020-07-06 11:47:02 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-4
> 
> for you to fetch changes up to b757b47a2fcba584d4a32fd7ee68faca510ab96f:
> 
>   KVM: arm64: Don't inherit exec permission across page-table levels (2020-07-28 09:03:57 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for Linux 5.8, take #3
> 
> - Fix a corner case of a new mapping inheriting exec permission without
>   and yet bypassing invalidation of the I-cache
> - Make sure PtrAuth predicates oinly generate inline code for the
>   non-VHE hypervisor code
> 
> ----------------------------------------------------------------
> Marc Zyngier (1):
>       KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL functions
> 
> Will Deacon (1):
>       KVM: arm64: Don't inherit exec permission across page-table levels
> 
>  arch/arm64/include/asm/kvm_host.h | 11 ++++++++---
>  arch/arm64/kvm/mmu.c              | 11 ++++++-----
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
