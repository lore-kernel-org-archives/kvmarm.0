Return-Path: <SRS0=1iCv=TP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B40C04E53
	for <kvmarm@archiver.kernel.org>; Wed, 15 May 2019 21:42:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51C2B2082E
	for <kvmarm@archiver.kernel.org>; Wed, 15 May 2019 21:42:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51C2B2082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C188F4A476;
	Wed, 15 May 2019 17:42:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xog6W6LYryFe; Wed, 15 May 2019 17:42:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBA404A477;
	Wed, 15 May 2019 17:42:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C6AD4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 May 2019 17:42:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CQXCBra1n36o for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 May 2019 17:42:18 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FD814A36B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 May 2019 17:42:18 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id j187so1435781wmj.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 May 2019 14:42:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=cK3Y9KxZ958VjTN9/j0HmLvhqtWrqpj1Eiv0iIXluz8=;
 b=NOe78SffOL5j4fPqXXuji3T4KTM3Ofj9PAkXRzRuuNzVTkoX/vjRbvE4yhj6mwvKkN
 w0ugwesC/vworyslT/atoIgi7Qwesg32MrtaUfD8KoiK5V80tJY76dMxmEvfoxenAgh5
 Jzap0aXD+Yniv+E6F9Q0zlCMhSBemxZ6fqKacViYtnOT2Rq7nmIvX3JBQfSRfO1PzBo3
 hfsafjFWkCpS2fO2mMToTzMxtAgpOZDIHJcu6aYcTzPJVZe1Fb48+QV/bdcWjt5f56up
 LQdq5zEMtGAJAlGPc9RhZOkkDJPhMF5gGxSiwrB98rB6yrZTY5ycloQn99VUx1QsFqH5
 fTBA==
X-Gm-Message-State: APjAAAXGr/x728h823f6ZHgrhkAisPW/dAKsfXOQT4pC92cvz3XzCNG9
 T13TUEXqpNPfvB51wprWu/HW+w==
X-Google-Smtp-Source: APXvYqxmP3hKGokzzdV6R/wU044EEKCdMwU8XI2vejExX4Tlo4rebHLW3WTheFhtyMVcTqUqCtPCxA==
X-Received: by 2002:a05:600c:492:: with SMTP id
 d18mr10215934wme.59.1557956537037; 
 Wed, 15 May 2019 14:42:17 -0700 (PDT)
Received: from [172.10.18.228] (24-113-124-115.wavecable.com. [24.113.124.115])
 by smtp.gmail.com with ESMTPSA id y7sm7019701wrg.45.2019.05.15.14.42.11
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 15 May 2019 14:42:16 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm updates for 5.2
To: Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8bd20863-f03c-9621-d3ae-10c4da28764d@redhat.com>
Date: Wed, 15 May 2019 23:42:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

On 03/05/19 14:43, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-v5.2

Pulled, thnaks.  Note that capabilities had to be renumbered to avoid
conflicts.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
