Return-Path: <SRS0=LQ+R=KW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0361C4707F
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 13:24:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52BBF613F9
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 13:24:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52BBF613F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C229F4A2E5;
	Thu, 27 May 2021 09:24:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gEVRX0pBamuQ; Thu, 27 May 2021 09:24:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E206D49F92;
	Thu, 27 May 2021 09:24:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D202749F92
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 09:24:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4+s72fcd0kSO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 May 2021 09:24:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEF56406D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 09:24:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622121891;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=onocq9toJsJ3anY/i2nAmWaCyfsOMUV30kjs3HuzEGw=;
 b=f6XxH9vku9rsMA8x62gFax9ajbHT8sjZ0APnx7gMl9+711wIK9yh0yZdIc8ADkobzhtsNp
 QlKm2aJ2uPA+846W/tAHqA5/mtY9g+uGs74cYIUi9tbW+L9+cGF5M0rZgTDY0DTQ4t2NAN
 sgiFbvujf5uAocl/AL8IOi3203rlHS0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-DIU79DuKOq-xhdJscck5ww-1; Thu, 27 May 2021 09:24:50 -0400
X-MC-Unique: DIU79DuKOq-xhdJscck5ww-1
Received: by mail-ed1-f70.google.com with SMTP id
 d8-20020a0564020008b0290387d38e3ce0so324560edu.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 06:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=onocq9toJsJ3anY/i2nAmWaCyfsOMUV30kjs3HuzEGw=;
 b=UKX395Msqc+mRU1qVuQrA7ar7Xu7zPzAKpTpqpF6ubfAIEmmrMNv99YeLHCcCqNUM/
 AqJKkLxs7VrI0k/KiQziqZprl28LUl3AvI/bhWX2pmXHclHozG5wcvIhjMgcqCOed34O
 9+adi64MQQrLQz14zpN1dFoDQktUQzvdKwf2JjODBa/U1SN0I/Wo5CeeX4JJBaDeFTRk
 thRDBy4Q7MF1ZzfIxMSnI8/iuze3lTP5jq48klPPv9BtwVWOztzwXCUqwUulV+w8Uvuy
 DzMcm8VggA+PjYghB1qBTVkYAep7uQ7OC95AVYhqlwA6R5NVMPoMcA83IPZDuy8vqCV3
 BMUA==
X-Gm-Message-State: AOAM531Lqg/8P/cFDKdyv8mL2fBgpKNdUQYXbrGZMokVYFghVxSym/We
 YE+4Y9A6NxtVCOWy8BY+h5ovCcL6XPDYkmIaB4bozkZ8HiaNY9uhd4Idf5+CarfV9zht6/VswaB
 7MfZOoNBKbar0OpXHdtThlAEE
X-Received: by 2002:a17:906:bcf9:: with SMTP id
 op25mr3861495ejb.453.1622121889007; 
 Thu, 27 May 2021 06:24:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhsiOXi652bfEl8+DPc/2hFhsuQTRK8by65rd6hN6BD3Rv9F7gDIXGUDuyJKcmwK9w3AljGg==
X-Received: by 2002:a17:906:bcf9:: with SMTP id
 op25mr3861479ejb.453.1622121888860; 
 Thu, 27 May 2021 06:24:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id lf5sm986833ejc.112.2021.05.27.06.24.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 27 May 2021 06:24:48 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.13, take #2
To: Marc Zyngier <maz@kernel.org>
References: <20210527104131.65624-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d1a9f961-15f9-f65b-c485-e942ad7a7694@redhat.com>
Date: Thu, 27 May 2021 15:24:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210527104131.65624-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On 27/05/21 12:41, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.13-2

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
