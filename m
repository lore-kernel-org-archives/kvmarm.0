Return-Path: <SRS0=103j=YJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0DAECE588
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:13:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03F3B2082C
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:13:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DsnhWbbB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03F3B2082C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 821074A9CA;
	Wed, 16 Oct 2019 03:13:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dS0Wngh3R9No; Wed, 16 Oct 2019 03:13:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69D0C4A978;
	Wed, 16 Oct 2019 03:13:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AFF24A598
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:13:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wz2km7YtK3Jz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 03:13:53 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94DDA4A534
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:13:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1571210033;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=i+nkQRyeopKoQt4du7dFN9BRIgBaHV958j8ZBKBE5e0=;
 b=DsnhWbbB/IzkCDEXtVNAHV98cUVqzz3Zqi7Oc0klbZpGjaMEjrng5nAznVKVXthF1jCw+0
 L6eFco6GGZFgrh+/RaUiRk3ldRBta5zBtY+WjCLR+bx77vUQ99iCj53/AHqw7gAmyYTrC/
 pc+MEf/11HnIHnjNGiy0jc8wFp2qS8o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-tyHED_gaMiyDpT0c-j22pQ-1; Wed, 16 Oct 2019 03:13:51 -0400
Received: by mail-wm1-f72.google.com with SMTP id q9so750906wmj.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 00:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:from:to:cc:references:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=2Puk2gzKjg2U5mW3uARabrgwbGmI43WYHISWUlwSLVQ=;
 b=r7dnctEmps8xrJ0qVxFra9VNEfI45x5MMYcPAmaSlzBp8KF3wrdmByCu25CILMuR7G
 moqEHYlsW6jbCJqQwdzlze3div+ossGgiiWJytY8NoQtiTqOB1fb9w416OpTuGpgiPIF
 mnoKsfdmQmGaPg/VnTjw9tGK2CNrkHBrrGfdTucX1SKYTDpNrHiBOHf8ZkzGSOJ5T6sp
 CLNvBis/JYSiOMb4NJCZf3QC/w4wqGpokZKSZuMnrfZBW7jVrRAZyDFM02qhKdYeR2ci
 05M7a0ApVJWaLs8E4Qz/dqHWWDkoGJteZcjSw1j62sUj0xG2iuTlNncK7bfiPX9qVNVv
 Jgtw==
X-Gm-Message-State: APjAAAWudhVM0BYgORVCxxfAGXl7wCyQuam5393aUbZOMqL6G6oFRh4d
 h8walem7iUxAIE5msohlrDy2XQoXninZz45K+ZePMc1A7G8rVVbEaWr5VYc/VM7EOjNcGm7eDOp
 uML8C6P1gm5DiZeESdu4H3ss+
X-Received: by 2002:a1c:6709:: with SMTP id b9mr2164260wmc.14.1571210029968;
 Wed, 16 Oct 2019 00:13:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzil7ngX2+rV1FuqUIzc7TJZOMSmcjqUkdazl9Cfq2UEQrrOgM1lpUEgLCAkoYOX3c/5g590A==
X-Received: by 2002:a1c:6709:: with SMTP id b9mr2164227wmc.14.1571210029679;
 Wed, 16 Oct 2019 00:13:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e?
 ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
 by smtp.gmail.com with ESMTPSA id b15sm1429843wmb.28.2019.10.16.00.13.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Oct 2019 00:13:49 -0700 (PDT)
Subject: Re: [PATCH v5 5/6] ptp: arm64: Enable ptp_kvm for arm64
From: Paolo Bonzini <pbonzini@redhat.com>
To: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 Mark Rutland <Mark.Rutland@arm.com>, "will@kernel.org" <will@kernel.org>,
 Suzuki Poulose <Suzuki.Poulose@arm.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-6-jianyong.wu@arm.com>
 <da62c327-9402-9a5c-d694-c1a4378822e0@redhat.com>
 <HE1PR0801MB167654440A67AF072E28FFFDF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <6e9bfd40-4715-74b3-b5d4-fc49329bed24@redhat.com>
Message-ID: <140551c1-b56d-0942-58b3-61a1f5331e83@redhat.com>
Date: Wed, 16 Oct 2019 09:13:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6e9bfd40-4715-74b3-b5d4-fc49329bed24@redhat.com>
Content-Language: en-US
X-MC-Unique: tyHED_gaMiyDpT0c-j22pQ-1
X-Mimecast-Spam-Score: 0
Cc: "Justin He \(Arm Technology China\)" <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd <nd@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On 16/10/19 09:10, Paolo Bonzini wrote:
> On 16/10/19 05:52, Jianyong Wu (Arm Technology China) wrote:
>> This func used only by kvm_arch_ptp_get_clock and nothing to do with
>> kvm_arch_ptp_get_clock_fn. Also it can be merged into
>> kvm_arch_ptp_get_clock.
>>
> 
> Your patches also have no user for kvm_arch_ptp_get_clock, so you can
> remove it.

Nevermind.  I misread patch 2.  However, to remove the confusion, can
you rename kvm_arch_ptp_get_clock_fn to kvm_arch_ptp_get_crosststamp?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
