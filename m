Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49199C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:38:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBB5361186
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:38:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DBB5361186
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87EE34024F;
	Tue, 21 Sep 2021 13:38:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t3k9CCRt3zXi; Tue, 21 Sep 2021 13:38:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56E0B40413;
	Tue, 21 Sep 2021 13:38:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7F940191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:38:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GotxCY28nJCc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 13:38:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B5940162
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:38:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632245922;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=g4x8fIa6lEehlH6YSx+A89ipydpaaLldQpHkxWi3LP8=;
 b=eXsNdwO0IfMQHIYHlI/UGuMbCMlhs7NNp8mFG9rmXSSsqYagiEVbtejmQvhNpunsDx0P6Z
 Yo/Pz9jiSCuBT3BW5dlN/LmQUdkwUEges81hQuDjGPJteilGOA0pkVpc9aM7mqojS5lhXF
 VK7gURuW0iwUkuHgpxkVUkZwBsNm6oY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-yxSpzeePPCumXcUA23SHHA-1; Tue, 21 Sep 2021 13:38:41 -0400
X-MC-Unique: yxSpzeePPCumXcUA23SHHA-1
Received: by mail-ed1-f72.google.com with SMTP id
 r11-20020aa7cfcb000000b003d4fbd652b9so19778613edy.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 10:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=g4x8fIa6lEehlH6YSx+A89ipydpaaLldQpHkxWi3LP8=;
 b=YKosYgXxaeLZpdpU1voJKPnZPy/cLxt4jiECp//LzIw4fAPaPCOze+WMLtGwoKbzLl
 04d8CeDIjZ+4Q3MusYgKTZz3A8ZdCpnbD758yvCs2aMnPEubvtSAdrgZGDGHWEV8H3Y2
 cDV4WnAuxs7ZXVteOOQRYFGTtwA6/YktgxHDT2P6RQtwWly7atUZn95lrDAFHSgjztQS
 Z8U1XDrf8IdyuIeRfUDJJFlIsMQ6IjpUNY1MGrsSnVUHTMji60fkqZ7H/up9A9vwRJn2
 LYyELBOBYbwYoiwgGdzdMDiDKaXIF9Ifr76D85GfJ4cDwVhO4VVAPiBFmn1INR/vf3Ur
 z8aA==
X-Gm-Message-State: AOAM532yqj+pbdjpnX/4hRc4O64VcaQtgCqm7HzBhHlvXY7cadIu32z1
 MMmUyZGJByIapjAJIIIimcKSzSykWHba/QuMp0R8v2m4hyimwXwLWpdiKOcOB8b99lMgfj/kWMG
 o0lFiWdAO2ZcPIso/T6Iov4El
X-Received: by 2002:a17:906:e094:: with SMTP id
 gh20mr37662777ejb.252.1632245919434; 
 Tue, 21 Sep 2021 10:38:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG0dI4y8cwBsr6Qzl02Dh4NFyuqTM5EkeEabM8u43/L8oDrq8XZ/KwKPq32rZu6mumygWVgQ==
X-Received: by 2002:a17:906:e094:: with SMTP id
 gh20mr37662749ejb.252.1632245919237; 
 Tue, 21 Sep 2021 10:38:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id h13sm8884541edr.4.2021.09.21.10.38.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 10:38:38 -0700 (PDT)
Subject: Re: [PATCH 1/2] selftests: KVM: Fix compiler warning in
 demand_paging_test
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210921010120.1256762-1-oupton@google.com>
 <20210921010120.1256762-2-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1fcd4084-c1fe-0689-da46-5d81191eeae7@redhat.com>
Date: Tue, 21 Sep 2021 19:38:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921010120.1256762-2-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>,
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

On 21/09/21 03:01, Oliver Upton wrote:
> Building demand_paging_test.c with clang throws the following warning:
> 
>>> demand_paging_test.c:182:7: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
>                    if (!pollfd[0].revents & POLLIN)
> 
> Silence the warning by placing the bitwise operation within parentheses.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index e79c1b64977f..10edae425ab3 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -179,7 +179,7 @@ static void *uffd_handler_thread_fn(void *arg)
>   			return NULL;
>   		}
>   
> -		if (!pollfd[0].revents & POLLIN)
> +		if (!(pollfd[0].revents & POLLIN))
>   			continue;
>   
>   		r = read(uffd, &msg, sizeof(msg));
> 

Queued (with small adjustments to the commit message and Cc: stable), 
thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
