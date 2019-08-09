Return-Path: <SRS0=zTnl=WF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B0AC31E40
	for <kvmarm@archiver.kernel.org>; Fri,  9 Aug 2019 15:47:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2423D20C01
	for <kvmarm@archiver.kernel.org>; Fri,  9 Aug 2019 15:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2423D20C01
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 832BD4A568;
	Fri,  9 Aug 2019 11:47:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s4YAoLqkXkFz; Fri,  9 Aug 2019 11:47:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91D184A54A;
	Fri,  9 Aug 2019 11:47:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9A034A547
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Aug 2019 11:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QSCkEldmSrZ5 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Aug 2019 11:47:12 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E54444A4F6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Aug 2019 11:47:11 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id n9so98791482wru.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Aug 2019 08:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=//yT3qJ8WuM03AEopdit51IEjFSTwNzla/34blwGVms=;
 b=i1cYe/yu0TsqbiyWUBIq+PNjpEoCAd2rnT+FlqkXp9yQCcRLfkbJgMCVgJYyjZy0s+
 3sscPO4sYcfLUsjMxnYOheWvohAh5clFXk73ARXIK3Juf8sxEm+lak+FXVv/Yw3YIURx
 NOh8XaNCoJ0evmdeEd5w9znrmrOWW/DmF/JcwfgtKLZA80WckL1ah+Zi4bbuP2A2Eh/V
 Z/5uuJFHZRmuZYeUA5laz2L3vU/r+0x4oe+U7TaVm0K13IaVo/6tFMFbXkVWNuSYVQKO
 TXT4idkSUizCrRxqyEeSmnsMw8PCH7oEO7JlCPdKEqxL6ULKo9Ae8irr0mKO/plX0QBH
 Q/rw==
X-Gm-Message-State: APjAAAUMNwuR0lX/F+VPHy8n/2p+cSxpgFChDera6BaXGnaFgQz6E43R
 XouRxI7Ik5xbejBat/BD7Ns1kg==
X-Google-Smtp-Source: APXvYqwMa058GcHnbYlQie7XSJJGnWJhLkCr/dR0jJdaNszGDMBL8D3HgdiIM/Wds/e4MYbYyG3u/w==
X-Received: by 2002:adf:dd0f:: with SMTP id a15mr7416971wrm.265.1565365630847; 
 Fri, 09 Aug 2019 08:47:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9418:b1e8:9e8b:8c2f?
 ([2001:b07:6468:f312:9418:b1e8:9e8b:8c2f])
 by smtp.gmail.com with ESMTPSA id w13sm19709449wre.44.2019.08.09.08.47.09
 (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
 Fri, 09 Aug 2019 08:47:10 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm updates for 5.3-rc4
To: Marc Zyngier <maz@kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
References: <20190809074832.13283-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9a6b90f4-7583-e002-76ba-a54525879469@redhat.com>
Date: Fri, 9 Aug 2019 17:47:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809074832.13283-1-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/08/19 09:48, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.3
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.3-2

Pulled both.  Thank you for including the lore link to the 5.3-rc3 pull
request.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
