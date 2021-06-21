Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348E9C48BE5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 15:38:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8B5B61153
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 15:38:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8B5B61153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 397D64057F;
	Mon, 21 Jun 2021 11:38:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DZBiBD3uIsp5; Mon, 21 Jun 2021 11:38:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E7FB40642;
	Mon, 21 Jun 2021 11:38:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27D104057F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 11:38:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ERlqmmsMDEOC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 11:38:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2492E40569
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 11:38:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624289917;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/PT2H+5rBlFaNgMWz3m8mH4Pq2q3IOb/grR2Heyyj5M=;
 b=h3M7RrIUraXMVZiEIDWYZNj6aWvtQ6JKsgffrlyf+xgOXwW9onFLPF17GChKowLoox5rmE
 34cLYQRwpyA93VSWCo/P9IIwvEzQQk/0mvB+Ed8mHi4TzGfcf9cblqRaayhtJk81XtD7Us
 aBN8kuyfbruJj/LS6gpBDxEaX+hM1fg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-pAi8UvE1OT2-rUmZqR5H4g-1; Mon, 21 Jun 2021 11:38:35 -0400
X-MC-Unique: pAi8UvE1OT2-rUmZqR5H4g-1
Received: by mail-wm1-f71.google.com with SMTP id
 u17-20020a05600c19d1b02901af4c4deac5so135536wmq.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 08:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=/PT2H+5rBlFaNgMWz3m8mH4Pq2q3IOb/grR2Heyyj5M=;
 b=mwQljeKpD6Xen5FIVXO11MBvAT3hG7rsmD9Q+VAeiVsalBhoLlt5SzpyRp8kgkBs32
 AaJq1ktnyLpJG6j8RVGpdblKP/fcOzma6JqUt+cExuSvlEZ4Q4+siUBGI3eNHpPHjrWj
 VcFmR9w9Rw3WpHxDpTsH7V+cgcYjZZouVScRNaccm1z+ktLL/umNwhwccYXkt8mbPG7O
 67kLAcCXriYBG4IIa+Tuakyh5YwYCulg7Jg+w+U8XunyQUPiq/eDP4evQ/NFEWxBfchP
 IyLr6UaqGH+XqRidaoQgIS4jD5s97mdmr+sVjPBOSSx4G0nsgAvmo5o3zzlYU8dbHTB5
 O5uQ==
X-Gm-Message-State: AOAM5336c8esv8JUiSOWp5TKlqdsjmds4CdappAxx+X0IGzGCKx9TtMp
 6KK484XjH8uVO6HvDyXKvwaz3JTZJX9PsqiJgbz9Z3tk1Rhl6egu0Z2Ysm+2auvsn6RV5esn0JG
 048io1ophTsv6oGLWmQefGAME6aBMboZrNIVeR7P+p1hqGWErTldfb+i5b7yLDQsfW/7fHUoApL
 tyZWU=
X-Received: by 2002:a05:6000:1001:: with SMTP id
 a1mr26918936wrx.418.1624289914131; 
 Mon, 21 Jun 2021 08:38:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBmisgDmIC43EwBLz2kszOmTyi7ROWV2l0j77EjN7RpHdmMIn2XY6HwlfXesCj3PgXQh5ttw==
X-Received: by 2002:a05:6000:1001:: with SMTP id
 a1mr26918915wrx.418.1624289913893; 
 Mon, 21 Jun 2021 08:38:33 -0700 (PDT)
Received: from [192.168.43.95] ([37.173.110.237])
 by smtp.gmail.com with ESMTPSA id n13sm19466650wrg.75.2021.06.21.08.38.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 21 Jun 2021 08:38:33 -0700 (PDT)
Subject: Re: [PATCH for-stable-5.4] KVM: arm/arm64: Fix
 KVM_VGIC_V3_ADDR_TYPE_REDIST read
To: Greg KH <greg@kroah.com>
References: <20210621124232.793383-1-eric.auger@redhat.com>
 <YNCvA4qDuc2Tlmi0@kroah.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <acd4fdcb-d6d4-755b-6f9d-9acf4b08d564@redhat.com>
Date: Mon, 21 Jun 2021 17:38:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YNCvA4qDuc2Tlmi0@kroah.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, eric.auger.pro@gmail.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

Hi Greg,

On 6/21/21 5:23 PM, Greg KH wrote:
> On Mon, Jun 21, 2021 at 02:42:32PM +0200, Eric Auger wrote:
>> When reading the base address of the a REDIST region
>> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
>> redistributor region list to be populated with a single
>> element.
>>
>> However list_first_entry() expects the list to be non empty.
>> Instead we should use list_first_entry_or_null which effectively
>> returns NULL if the list is empty.
>>
>> Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
>> Cc: <Stable@vger.kernel.org> # v5.4
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reported-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com
>> ---
>>  virt/kvm/arm/vgic/vgic-kvm-device.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
> Both now queued up, thanks.
>
> Next time, give us a hint as to what the upstream commit id is, so that
> we do not have to dig it up ourselves :)
Sure I will.

Thanks!

Eric
>
> thanks,
>
> greg k-h
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
