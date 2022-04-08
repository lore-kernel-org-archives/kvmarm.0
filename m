Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FBFC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 16:31:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6E484B1EF;
	Fri,  8 Apr 2022 12:31:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Uz-Gao8jFT+L; Fri,  8 Apr 2022 12:31:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA89F4B1CA;
	Fri,  8 Apr 2022 12:31:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16A024B1CA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 12:31:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ciAOSuSIkI9m for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 12:31:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2444B1C6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 12:31:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649435483;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ezLScb0qdXlLkCxr8k3PZJ3/cAq1WRV512yu5EznY7Q=;
 b=OFu/AgnAEWAwchySWkEKtuQTooL7PJmguDAu6EJh03JTUoclVE31DvvdS25xbD+F/PnpLl
 ezM6hN4GLCj1LBHkBs1SnMNJrmrFAM8GhPYhKDWb95/sUD+SLqzeDb8ZxDhK0NBMbQteIa
 EahUTbtbuD88pau5IH1AxFzb+2duLH4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-qLrRTnRpPcmGaRrEQyVkNw-1; Fri, 08 Apr 2022 12:31:22 -0400
X-MC-Unique: qLrRTnRpPcmGaRrEQyVkNw-1
Received: by mail-wr1-f69.google.com with SMTP id
 q15-20020adfab0f000000b002060c75e65aso2373598wrc.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 09:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=ezLScb0qdXlLkCxr8k3PZJ3/cAq1WRV512yu5EznY7Q=;
 b=Y2a+IMtpiGGJgPAdEMF2qt23SKJvdgsUBjsMlvoJ7Kn0PuOZbcllik5XtdL0LQRD6J
 ok4mAQI1jrSNz6ia30Qf4QvOfrI9Hyfis9eHNlFrs/2kdxGMbzQKVjGq1Wj4OeECusgQ
 noyThopqQr3F35H0YAHAWXDKCvOXs3dGql+SIPOlWuiaZYESgF6g5mD04aKwwGPRypIg
 Ps9wjXGbHkAqhe+u89NTygVpI+ZAbC8TEWIZgbMdECtXFV+BBX8jbgCB4qV7qmTskM7m
 Tm2YG14iP6YoiXm9x2uz4OkxD7S7D2hl5wypa0cwBc9ZQD7emkFOy4OzFb43Q5KkbxR3
 U/aQ==
X-Gm-Message-State: AOAM530UDf24p1YKk51iywzkTHGYX/VZZiDEV5d3jGzq30IfNYHyqNjB
 MtpYRa8iQphsQVOuWc7MmQi7G5sfwMmngAHAMUDuSMCxwK25Hu/MITQpn5nHFdS9XzAe9OHkVuX
 J8luC9G39ke97iFW7aYAV3bi1
X-Received: by 2002:a5d:548e:0:b0:206:cdc:ff90 with SMTP id
 h14-20020a5d548e000000b002060cdcff90mr15013836wrv.629.1649435481317; 
 Fri, 08 Apr 2022 09:31:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCB5NscNj/iZkhXNq3pILYqo7/vfybBBnq7QfRmjpblGzXeWKUQmZgNePGg763G/vT+dXKDg==
X-Received: by 2002:a5d:548e:0:b0:206:cdc:ff90 with SMTP id
 h14-20020a5d548e000000b002060cdcff90mr15013816wrv.629.1649435481124; 
 Fri, 08 Apr 2022 09:31:21 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
 by smtp.googlemail.com with ESMTPSA id
 i13-20020a0560001acd00b002078e242847sm3133436wry.97.2022.04.08.09.31.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 08 Apr 2022 09:31:20 -0700 (PDT)
Message-ID: <d28770af-f764-e5a2-1de6-e9d3bc8e27f1@redhat.com>
Date: Fri, 8 Apr 2022 18:31:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.18, take #1
To: Marc Zyngier <maz@kernel.org>
References: <20220408150746.260017-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220408150746.260017-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On 4/8/22 17:07, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the first batches of fixes for 5.18 (most of it courtesy of
> Oliver). The two important items here are a MMU rwlock fix when
> splitting block mappings, and a debugfs registration issue resulting
> in a potentially spectacular outcome.

Pulled, thanks.  I am not sure I will be able to send it out before 
Monday, though.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
