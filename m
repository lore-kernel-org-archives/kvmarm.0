Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C48FC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 18:03:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FBA164E1D
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 18:03:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FBA164E1D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D964B4B1AF;
	Thu, 28 Jan 2021 13:03:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0QbBC6cgjQpG; Thu, 28 Jan 2021 13:03:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF1764B19A;
	Thu, 28 Jan 2021 13:03:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 335034B168
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 13:03:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YHBFdpbeRxxH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 13:03:01 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C36F4B162
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 13:03:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1611856981;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LWWNoe1Kl8O/5xgq3+qKNWzE/mKzopSaV6Z4yzkSMwk=;
 b=OAw+aSmCMlaGKHkYmYLCy3lsjZFziKt6au3PgwtV+NWLGRj0TMZDD/4QhehC249+8JzfVF
 S1hBtibM0WcqLTj/7WgIfbJYRmwzKuxm7QtkOyqmgYHDdafjSy5b2FtLAQUN3VfLrkCamP
 WmXlw6PnF7yM/sTSKt3fNC4loMa7Juc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-mrUyIhJSMdW5fg0lPwjDGA-1; Thu, 28 Jan 2021 13:02:58 -0500
X-MC-Unique: mrUyIhJSMdW5fg0lPwjDGA-1
Received: by mail-ej1-f71.google.com with SMTP id m4so2550139ejc.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 10:02:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=LWWNoe1Kl8O/5xgq3+qKNWzE/mKzopSaV6Z4yzkSMwk=;
 b=S0hCaQ5agcp7WmMijiGSZCFVJprZA5+rwBm8X1iC0Kff++D7+x7ZxXad8mJrDzlbyQ
 BaNjGXmDs88cSGfdOHBgXsYFmfI1K2kKF8MHNNLhERkL4FobXzNiYUCkHHcoQDo4NvZ6
 8QuzXK8e3D01iAow2Dkozd6ng6a72jh5Y4cQTObcBUdV+uRPyeIK/dOaNgLWCZbrKhTr
 IdvxKTkTGBp1uS19udNsGwN3Y4xrdM99RjwsshlQbrD2AY1thdoXy/cAd17Nvbls3Rte
 9jmcFyP+AjmekNc5tzMx/VcI7kAzjOQedcSCKmJ8dBbP4ds6pZgTQGrzPXeSiXNyOp54
 9tRg==
X-Gm-Message-State: AOAM530iVBpl5lB01XxvD27xSViyI9PiuadsRkkZwFKT5u0qURobxSdm
 Z0xvYse/mSrmtiWnupzAYOKH+uaRG5HrH2iygAteubSZa+GTZwLGJCM4ZAAKdFT5/wrnkOjIm2V
 gzbUprQQnv1h8B0/TOGjG8nE7
X-Received: by 2002:a17:906:447:: with SMTP id e7mr635637eja.172.1611856977131; 
 Thu, 28 Jan 2021 10:02:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynZACnAFdmDQ6RsE2ukS8Kfxeu82Y0UYa5PGs5IJ3GI2SC/eCgyP4bYCf+CPUcppXGumVtiw==
X-Received: by 2002:a17:906:447:: with SMTP id e7mr635616eja.172.1611856976990; 
 Thu, 28 Jan 2021 10:02:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id dm1sm3322486edb.72.2021.01.28.10.02.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 Jan 2021 10:02:56 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.11, take #3
To: Marc Zyngier <maz@kernel.org>
References: <20210128175830.3035035-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32fac3c7-0141-d303-7412-cd8c3a8ae039@redhat.com>
Date: Thu, 28 Jan 2021 19:02:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210128175830.3035035-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 28/01/21 18:58, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.11-3

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
