Return-Path: <SRS0=LttP=ZO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86024C432C0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 15:36:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08D8520715
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 15:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4Q0ivJh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08D8520715
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 604D54AEDC;
	Fri, 22 Nov 2019 10:36:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tu+iH2XXS9R6; Fri, 22 Nov 2019 10:36:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 690CF4AEC5;
	Fri, 22 Nov 2019 10:36:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 993DC4AE89
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 10:34:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XKil3QQqhojH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Nov 2019 10:34:44 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A58F24ACE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 10:34:44 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1574436884;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3aAdYcU/DpgTBj1D1MB1Kf+RmmmZXkhKfjH2rk3afw4=;
 b=F4Q0ivJh4rn8Wx82sCq9T1G8az/wapQH+TeedqlzgZMukSC2RTcza8BMYr2SiV8DrnoTov
 DHC1nl76y2zB0lGLjbjpdf/F7uW491PdQlCxUlvLWZJnwEvhK1el6DQkvXL38SpRMyoME9
 I6wIfa9k8W+ZUDlyLB1YC4dAEH+W524=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-B9qG6LJgPOab6SOmu8LG8g-1; Fri, 22 Nov 2019 10:34:42 -0500
Received: by mail-ed1-f71.google.com with SMTP id t32so4133039edd.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 07:34:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=L1o9pUpmewZ91EzFhu6CTxYRyhDCmevRuCylTHV2sso=;
 b=qFxCO041IRIt2kSXLulJULKmPoDgZ+LadzYUr5pRAUETKVrvUoaFDZzYJiJYEBE/7J
 57Wv2I0OKfj4WkqumTVFCqe3ZOHcJFlSYOo45/+gnThuH21gvg2C5gONqnao1le10U/r
 /OFYSzBbmIC3FyD0yJs12WQN62mYcIblsyiXO34wDTCVAUzZn9gHehN1YpspS8qDW3mc
 dGv4eF5erqWNWiSdnsSxe3+PQO5i9TTT/8D7YESY+XehGu8qFe2XEiprdgEojtSKdGQW
 ieT8JfiAvt8TjcRV3ItsnSq+/bQ4eq6jePdi06+VnbR8NDeNw00me3cOxNt18wOnCFX+
 j4JQ==
X-Gm-Message-State: APjAAAXeqfgc6veaoCBWqCLtYR9OiJexONk9Hh0XORte5ORQHSExgZzL
 VKGXya6HS9nbLy+3qFJIOCmGQ8cRgdBvFQwS0hlRcWUBAQMQrxpvOzlBjscnd2pthBk8h21dWvw
 yx07ZCuaxcESJnMEieOmexajL
X-Received: by 2002:a17:906:edd2:: with SMTP id
 sb18mr23323546ejb.112.1574436881595; 
 Fri, 22 Nov 2019 07:34:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqzCEDkMj1/lU3zx1T1EXu+zdCLVq6/aSdGbbbWSWQbZDd/0YIeelbPjztZZ7eCsTFrBxqkP5A==
X-Received: by 2002:adf:cf10:: with SMTP id o16mr18560218wrj.334.1574436880120; 
 Fri, 22 Nov 2019 07:34:40 -0800 (PST)
Received: from [192.168.1.35] (131.red-88-21-102.staticip.rima-tde.net.
 [88.21.102.131])
 by smtp.gmail.com with ESMTPSA id u18sm7934629wrp.14.2019.11.22.07.34.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 22 Nov 2019 07:34:39 -0800 (PST)
Subject: Re: [PATCH] target/arm: Fix ISR_EL1 tracking when executing at EL2
To: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <maz@kernel.org>
References: <20191122135833.28953-1-maz@kernel.org>
 <CAFEAcA-aRwc9bogn-QbT-q5FzkqieYmQOZMr6H=kK5ixMGANMg@mail.gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <d91a9721-1a76-7434-cfc0-493ed4d0d7e2@redhat.com>
Date: Fri, 22 Nov 2019 16:34:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-aRwc9bogn-QbT-q5FzkqieYmQOZMr6H=kK5ixMGANMg@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: B9qG6LJgPOab6SOmu8LG8g-1
X-Mimecast-Spam-Score: 0
X-Mailman-Approved-At: Fri, 22 Nov 2019 10:36:11 -0500
Cc: Will Deacon <will@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
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

On 11/22/19 3:16 PM, Peter Maydell wrote:
> On Fri, 22 Nov 2019 at 13:59, Marc Zyngier <maz@kernel.org> wrote:
>>
>> The ARMv8 ARM states when executing at EL2, EL3 or Secure EL1,
>> ISR_EL1 shows the pending status of the physical IRQ, FIQ, or
>> SError interrupts.
>>
>> Unfortunately, QEMU's implementation only considers the HCR_EL2
>> bits, and ignores the current exception level. This means a hypervisor
>> trying to look at its own interrupt state actually sees the guest
>> state, which is unexpected and breaks KVM as of Linux 5.3.
>>
>> Instead, check for the running EL and return the physical bits
>> if not running in a virtualized context.
>>
>> Fixes: 636540e9c40b
>> Reported-by: Quentin Perret <qperret@google.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Congratulations on your first QEMU patch :-)

:))

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
