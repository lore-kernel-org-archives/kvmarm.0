Return-Path: <SRS0=dOSa=5Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8A0C43331
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 14:45:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E7D42078B
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 14:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/0TmEi9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E7D42078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C9BC4B08C;
	Tue, 31 Mar 2020 10:45:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HmHtL1sW3BfV; Tue, 31 Mar 2020 10:45:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 805614B092;
	Tue, 31 Mar 2020 10:45:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C94FD4ACC9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 10:45:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rE-zJaLKwESw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2020 10:45:17 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C00EC4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 10:45:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585665917;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XkVeG+wiUd998qeT4qan+1QjPL9epNOUfW2FxCj8pH4=;
 b=L/0TmEi9e9Gu+FUmx1VZ/k4mRRFvrRUm9JZEKBjfHQypxjnuF1XajyrV5YckCLRTNUutrD
 T/jhQ9lQ+NcEBt9UbdvBfAvCmjyCiVxFJ5KOFN62fc9GhC5LvIDwhoBsLQd3JSEIMu3vs7
 ryJbsLB6AI09T6Cff0A1ZcGmb7K771U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Y8tp1RfpO2Gb4i-AFZ9P4g-1; Tue, 31 Mar 2020 10:45:11 -0400
X-MC-Unique: Y8tp1RfpO2Gb4i-AFZ9P4g-1
Received: by mail-wr1-f72.google.com with SMTP id d1so13051908wru.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 07:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=XkVeG+wiUd998qeT4qan+1QjPL9epNOUfW2FxCj8pH4=;
 b=PMjRswrnacVXYfJH4LaOMTphl87D18lqbvtLzTPHBZuPPHYlC5lh2+OEe1FxaCQ4Po
 aYSO1eolbiOXAzv50ICSkzzoz18bN6/76YrRyp+4MkAEP4+WABP+LfFmbY5blMCuRf2l
 rC4Gx5OoQ9dtYsMv7RxU+hOJsur6pN2GFWbVeVkYEB6xhbiv42dYsIh8ExYVhxa+uXpI
 lBXQv+sBZhzsKPOTmts39zrhIIcRQ+JYhL2AuvFQkzZ5vierxOyFT6ZHcbItOlzTbZsk
 oPF+5e6lixl5VcvWBevQ/rdb0tcBWYLZfSAaq6PCx4LhwMBs/j4fL+bStWIaT1tUXWkp
 WY1A==
X-Gm-Message-State: ANhLgQ3AF6bkZvExz+Migk3PHGbI1KpqMQbjuOR5eaXhf7zD3mVX46fo
 4lgyOVk62jmC5u+8AehxZYWkxsJ9OZRdcCPL+MkZ1TCtrl2dZ3mOX/GH312RykhT0VhR4i8Zy1s
 i+jDXDugp8tDKx9Ri7vBEQFtW
X-Received: by 2002:a1c:4054:: with SMTP id n81mr3643238wma.114.1585665910101; 
 Tue, 31 Mar 2020 07:45:10 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvRBGuELyCrlyg1lc7SNVVMP1SITAsNZT3BZtrLyIlYKUQ2VKqqSdXcjj6kZdCsf1nf2xKUeg==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr3643204wma.114.1585665909844; 
 Tue, 31 Mar 2020 07:45:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea?
 ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
 by smtp.gmail.com with ESMTPSA id i1sm25851518wrq.89.2020.03.31.07.45.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 31 Mar 2020 07:45:09 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm updates for Linux 5.7
To: Marc Zyngier <maz@kernel.org>
References: <20200331121645.388250-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb49ff66-e943-f8fe-65bc-2e52ae36e47e@redhat.com>
Date: Tue, 31 Mar 2020 16:45:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200331121645.388250-1-maz@kernel.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
 KarimAllah Ahmed <karahmed@amazon.de>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, linux-arm-kernel@lists.infradead.org,
 Olof Johansson <olof@lixom.net>, Will Deacon <will@kernel.org>,
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

On 31/03/20 14:16, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-5.7

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
