Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBFCC433ED
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:35:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EFFC6115B
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:35:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EFFC6115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B69B44B29B;
	Fri,  2 Apr 2021 05:35:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tqomAxEcacip; Fri,  2 Apr 2021 05:35:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFEDB4B29C;
	Fri,  2 Apr 2021 05:35:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 079E14B297
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 05:35:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FQhFzx-W6glj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Apr 2021 05:35:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 424814B296
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 05:35:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617356141;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Pp7i/Rq4quxGmDckgflEr0uWdxRmtTCzqRhgMxNYmVI=;
 b=HVPYN/Au8+htd9ozI7CJcI37JaDjISuq37mWdtpqa/zOK42jRLGj6Si29q4dCiWzSg4mpJ
 agh6jnX3ATyM4dITwS+yl74k8eyMBbJRSuQmjNkz59f7zy0WsDAbRon3UxIgMNSXQTIPlR
 +XIDXvb4p63KP5XM53tgVgWNchAkt8o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-7C-s5-JAOuKyhG_0KlKaoA-1; Fri, 02 Apr 2021 05:35:39 -0400
X-MC-Unique: 7C-s5-JAOuKyhG_0KlKaoA-1
Received: by mail-wr1-f72.google.com with SMTP id x9so4088045wro.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Apr 2021 02:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Pp7i/Rq4quxGmDckgflEr0uWdxRmtTCzqRhgMxNYmVI=;
 b=AMmPX/V6FkKpBigBh2uSiGRTxyqeyxuysK90CaS+ZnQsvW01PQA9o8r4EtCj6kkqPC
 oZxJ0LOrlGAi7v7dagsVjFtBlbS6lDecKAkYeDQ2ycWTS+tMvNoKOkYursNF41xKb717
 JaXG4vH4e6JKxxb+iSy5gypCfWNqwrJLaNC2spS9fuPI3nyZUoU3ErHgNi8pCcb7FeqN
 Ro0kC9bk9zlKRwrWqu2JpjeGl+bzl9LyfSYlS2qqgOQMQxH2g6dYYOqxpRFS70X37nX+
 c1Lk/uu+Ue4G7DieAGfXtc03WhCFiQvaPuWMY+YBTnP9AOIzQcPHvLadDtHuVFwwYWaC
 D1og==
X-Gm-Message-State: AOAM533HBiA9dnQtdt3SKTgP4HMgyJHIZUziffWN/5O25YFBHo0kqLSS
 sur9OlbOAPAo6kpTX6uOLbKG0WFAOCgZNPpxONlLM3SYEQal9qjkyomAabkdKz+gz5mzOnICNoq
 Y60Ogan9Xjn1pbhcqX0FVfAAg
X-Received: by 2002:a05:6000:1a8a:: with SMTP id
 f10mr14051213wry.232.1617356138340; 
 Fri, 02 Apr 2021 02:35:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3IM+fWBMIWWC0dXiX9SYqbGiBYCoQN4BHK3a4+s4pude6jmvmdlBwOmMacbQNHjcYC5pL4Q==
X-Received: by 2002:a05:6000:1a8a:: with SMTP id
 f10mr14051180wry.232.1617356138121; 
 Fri, 02 Apr 2021 02:35:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id x6sm11605403wmj.32.2021.04.02.02.35.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Apr 2021 02:35:37 -0700 (PDT)
Subject: Re: [PATCH v2 07/10] KVM: Move MMU notifier's mmu_lock acquisition
 into common helper
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-8-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a30f556a-40b2-f703-f0ee-b985989ee4b7@redhat.com>
Date: Fri, 2 Apr 2021 11:35:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402005658.3024832-8-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On 02/04/21 02:56, Sean Christopherson wrote:
> +		.handler	= (void *)kvm_null_fn,
> +		.on_lock	= kvm_dec_notifier_count,
> +		.flush_on_ret	= true,

Doesn't really matter since the handler is null, but I think it's 
cleaner to have false here.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
