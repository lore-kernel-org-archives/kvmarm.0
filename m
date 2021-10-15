Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4A5C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 08:48:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA24B61090
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 08:48:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AA24B61090
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 287784A5A0;
	Fri, 15 Oct 2021 04:48:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hXQqrAazqOd2; Fri, 15 Oct 2021 04:48:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 436F34B135;
	Fri, 15 Oct 2021 04:48:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7C3C4B126
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 04:48:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B3+w6WfzGg4f for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 04:48:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 096924B121
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 04:48:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634287682;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tB/gkkjZsllie3Yvo9phHa69OMcnPBuasEQDVapsJYA=;
 b=M/R8722dMPzaijFeH0/unDQO0RQZTWZTgbGGAwUKosY2d+BByaatqfqk6DieQ//6XiuT8V
 2903fwzdQmBZYegAueMJI1UhZEAcgnAa8rtczSzYnyU3UJgECA59g4veFWABGaO5yeJsBu
 E9SZTVEJcTuzjGG/zQxaT7YZhqG/kI8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-2JRNgfw1MUu_vb8mtBu0vA-1; Fri, 15 Oct 2021 04:48:01 -0400
X-MC-Unique: 2JRNgfw1MUu_vb8mtBu0vA-1
Received: by mail-ed1-f72.google.com with SMTP id
 r11-20020aa7cfcb000000b003d4fbd652b9so7591216edy.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 01:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=tB/gkkjZsllie3Yvo9phHa69OMcnPBuasEQDVapsJYA=;
 b=SND49AFvieplLyO5jeRwnmSgQanLdugYrtsI4urug3DTBNclZT31sYe3RQLlAVgAsK
 xnRrmlrOsdHCdnThOpQXPzBlPZig4QA1VwcEAPSzmsTfpx8Wk57mawvIAqGYN7D7Tnj0
 YeEiUWtZKQPSdeY6GgujDG1dX7yrY+uuhKGKRsTE8UZ8fb8cqG06/l0Yv4ktQY/8i21x
 Xj3FFNJK9mnxb6B9R5u66077zafwntMGglZGGHzURghdmR7bFS9VaVQJ9w6PPLS8kIhY
 XXynONHBixwTckg6SA6g7XADmEDW1hAl715crC+3K9Jn22NHnhBP3Q9LwmwFD9HrS+9Y
 acOQ==
X-Gm-Message-State: AOAM532cdnYabe62f4GJQ/UvFlzueGMC+LX8nXcUS6uBYtyhun2ZLFEg
 ZRtqgH3GOOqNIYyZVNQ+1wLrRTgIIyjDiLvadQqVKT+nB6A4UNcJktk/uFa7JFvPrS1cNtIPm+P
 qN88dFrJUEIMRpqaqcBXJPGFE
X-Received: by 2002:a05:6402:270f:: with SMTP id
 y15mr15877413edd.126.1634287680345; 
 Fri, 15 Oct 2021 01:48:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGzkOQx3Z+QfSsE67T1Qfemiv6kryTvA5QIL4gVj0vSXZETTEviS8t3FZArLP/DBF46OWw0A==
X-Received: by 2002:a05:6402:270f:: with SMTP id
 y15mr15877400edd.126.1634287680189; 
 Fri, 15 Oct 2021 01:48:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id v13sm4649609edl.69.2021.10.15.01.47.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 Oct 2021 01:47:59 -0700 (PDT)
Message-ID: <bfb75bb2-2b5d-7fd7-b563-3c1ee7607b21@redhat.com>
Date: Fri, 15 Oct 2021 10:47:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.15, take #2
To: Marc Zyngier <maz@kernel.org>
References: <20211015084245.2994276-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211015084245.2994276-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 15/10/21 10:42, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.15-2

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
