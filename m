Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A144FC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Nov 2021 20:30:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF594B0CE;
	Thu, 25 Nov 2021 15:30:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ewx1vlMH7o5i; Thu, 25 Nov 2021 15:30:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F44E4B134;
	Thu, 25 Nov 2021 15:30:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 208CF4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 15:30:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G2tnLEzpojMj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Nov 2021 15:30:54 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 164324B0C5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 15:30:54 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637872253;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dEpF0Ya03y+5CSbJ4wmHYDmPmNwCt74NIwf3iLZqZgg=;
 b=UBG5+HEPWvuaq32Vd1sMJvFDlWdt49r34Hi5FQAxzhWfAut+my2ywnkD8ujPZpcRQAtOJx
 6u5BaNuyyGgjAsj4NZojQBBD50Cj1wbjkpvSoYtNIjv5lHcOQysLD6hkoZUJzMwSYDRVU8
 oux8d1LCCYJE+i+EqH8tKYE4SpU7bnU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-UMQXP9wsNqG2W_5A4vTzhQ-1; Thu, 25 Nov 2021 15:30:52 -0500
X-MC-Unique: UMQXP9wsNqG2W_5A4vTzhQ-1
Received: by mail-wm1-f72.google.com with SMTP id
 138-20020a1c0090000000b00338bb803204so3773181wma.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 12:30:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=dEpF0Ya03y+5CSbJ4wmHYDmPmNwCt74NIwf3iLZqZgg=;
 b=n9o05XxefiuzZ5xOqtA8jjHlYZNSdwTj3TOu7Duq44teU6uh70lleMVN3+mEKsrxlM
 9tJo9fuPvxpriTFLQAT2wBg+ldtBZjFMzHoyWAEyXLtqPX9Xd7ySvokWxrxo7CrHiiOJ
 N3l9bR8zgQnIlxWEarRXZvnU4CeUYRIVTcpcvx5x3j+um+eWJwj/ei0DjF2408tsZv3M
 xt37W72XTBZrYtEWJte60jAcF9eSu45T53TbrxLR+hMwYCfjVr1+uQpCML5FzbiGaaLq
 LaXf8DMZp8iArvElw3um6C7OZG+aW01YbDId392d5+ywJCqPwp+nEGh5Jcx0sChakt5Y
 OtuQ==
X-Gm-Message-State: AOAM533ktm/1Ut48PNb/wsEFjiGRBjTjdMwnPOjXIPM4Grt2yCTUNru8
 b4N6JLV8zeCn20bdWGOq+GlvB0K/meRwnpsa49yxo8x/hyj4rUrPteG8Uf9Rlr8EthhD64gp8c7
 fq02uJeSlisFEpNSKrbXdOB1G
X-Received: by 2002:a5d:6312:: with SMTP id i18mr10186653wru.475.1637872251640; 
 Thu, 25 Nov 2021 12:30:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0gaKevT6dubAbNdgl8Mlg1Ca3d8cwo7W4YwZVK8nM2ffYuZwM+HX5qjU1mVul0Cey+e9psA==
X-Received: by 2002:a5d:6312:: with SMTP id i18mr10186629wru.475.1637872251479; 
 Thu, 25 Nov 2021 12:30:51 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id h2sm3566055wrz.23.2021.11.25.12.30.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Nov 2021 12:30:50 -0800 (PST)
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To: Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
Date: Thu, 25 Nov 2021 21:30:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-10-reijiw@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> expose the value for the guest as it is.  Since KVM doesn't support
> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> exopse 0x0 (PMU is not implemented) instead.
s/exopse/expose
> 
> Change cpuid_feature_cap_perfmon_field() to update the field value
> to 0x0 when it is 0xf.
is it wrong to expose the guest with a Perfmon value of 0xF? Then the
guest should not use it as a PMUv3?

Eric
> 
> Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index ef6be92b1921..fd7ad8193827 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
>  
>  	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
>  	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
> -		val = 0;
> +		return (features & ~mask);
>  
>  	if (val > cap) {
>  		features &= ~mask;
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
