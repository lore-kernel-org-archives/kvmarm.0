Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C8DC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 18:19:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA0C6233CF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 18:19:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA0C6233CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E1B44B475;
	Thu,  7 Jan 2021 13:19:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0D2wTpdGhw7r; Thu,  7 Jan 2021 13:19:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3005B4B468;
	Thu,  7 Jan 2021 13:19:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD7384B468
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 13:19:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JoqNJzd6gD7Y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 13:19:19 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC5FD4B467
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 13:19:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610043559;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=A6HJ7qfwjQQFa0/zX8yYwuKoznigbFaw8YRs3WGQwro=;
 b=T1ihq1bozgBH8b76aBw3WgCNKtvJLiEf1ljz/hnd5VnPIrDdq650zmYYIrI8oeuzorcQL1
 gHb1/YCFBgiQiw26RqZ5yoXQCDt8v2SAml8Y2dD0zCAvFyEJs/XQMcv89FMGY3cyoFbCQK
 RZToBVvi/oa8eQw+kc2MeW8jYzioR3o=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-slRcoHMOOvyaG6ZgHfR9dQ-1; Thu, 07 Jan 2021 13:19:16 -0500
X-MC-Unique: slRcoHMOOvyaG6ZgHfR9dQ-1
Received: by mail-ej1-f71.google.com with SMTP id s17so2737124ejm.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Jan 2021 10:19:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=A6HJ7qfwjQQFa0/zX8yYwuKoznigbFaw8YRs3WGQwro=;
 b=LK7r9AwGUOwbtQ46/XG9fE0ONA0i76Tn8J1NdkRhAdasV0TNftrOOQjZ+CBn1pO+4f
 fpxZqxTlrsLcoU9qAIetW2N+Tnd2VXMS1Ey02fwQ72Qj4DDYht5NIYyhgmJk1J400d43
 etSN+wam56vVYIz4Z/B+ho7UG1d2MR1rPK4VI8s7HPT+ipqqhAYubLn7tF5b2sVlotp+
 Zrl78fiMg1WM1YgSQVcmk+mxZl6jOYNHjq6GGLzAIQ/rtZiyjTokhGD4H2JKbppKXH1S
 8SaVNrETC0nsfhBMgKAoyVR00Tx5zz6fw/lcT79BtK1Wa4HagV4NO2xQl+t/dwRUDOcA
 0Fdw==
X-Gm-Message-State: AOAM5300K4OuepJmkhc9ovee3Kxs2WuJ/9YpyBR7YxZ1kMrb6XfIKsHb
 v0qrDxyFw6zw80qSv2WVUQ8yJR3OrgRgAY/+5UB3xQkHCkgsitmHI8LFTEvWZ28fabpfwO7d2fV
 EQ+zh61QozBxgf9XbhK2cjnvE
X-Received: by 2002:a05:6402:46:: with SMTP id
 f6mr2564922edu.163.1610043554903; 
 Thu, 07 Jan 2021 10:19:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygSyi78s9OkXtGMdK1CXDasTKhjxLxjzYadK664iqRG7NLG5/QFZWbRvoitnHe38sdxlcZOg==
X-Received: by 2002:a05:6402:46:: with SMTP id
 f6mr2564897edu.163.1610043554745; 
 Thu, 07 Jan 2021 10:19:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id r18sm2947955edx.41.2021.01.07.10.19.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 07 Jan 2021 10:19:13 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.11, take #1
To: Marc Zyngier <maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d523a25-aaf0-32f0-d03c-b26115c77e79@redhat.com>
Date: Thu, 7 Jan 2021 19:19:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org, Qian Cai <qcai@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On 07/01/21 12:20, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.11-1

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
