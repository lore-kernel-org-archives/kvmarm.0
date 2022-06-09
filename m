Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EA2C43334
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 14:32:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 193274B2AC;
	Thu,  9 Jun 2022 10:32:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b2Wxqsr6YBby; Thu,  9 Jun 2022 10:32:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9D2D4B34F;
	Thu,  9 Jun 2022 10:32:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9DB14B268
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 10:32:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kVYKkB6cAmUq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 10:32:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA764B24A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 10:32:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654785122;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=yyBQlUeeoBduR7JhY4CL4tsX2MNk3eyYarhXHreOnQc=;
 b=frBhheUhSlf1gCUbB5BmHcba+KN/3angJymqrw3Cs4Ro5Z5Seo8RkXFeeleksc+86DqfPB
 ibX95UAh21opWqel4Ub1Ip0oLcP1e0wvrNVyaphESnqorflrEbnu+5sR2E+b5PC0+fhIZ1
 WXtrjhGdVP3AykPNns2Z4a4mkKYbs68=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-X1cqGCtgNcikIsP93B-i4Q-1; Thu, 09 Jun 2022 10:32:01 -0400
X-MC-Unique: X1cqGCtgNcikIsP93B-i4Q-1
Received: by mail-ej1-f72.google.com with SMTP id
 pv1-20020a170907208100b00710f5f8105cso6433425ejb.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jun 2022 07:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=yyBQlUeeoBduR7JhY4CL4tsX2MNk3eyYarhXHreOnQc=;
 b=W3YgxuzouvWVLt8GZfVpbelVb7yTyVQqznbBJyUufZVAxRlmLfWISWDuHEvHQJkGKB
 nputGllmG5WE63jrCYx1WgW6nb7jDc4vDm5LDaj9NMaO4nSEP+ysDA9AIic4bttLWyAr
 zo+hZEcv3B74uXXFlrlJkF3sOf2X8Z3YjO8iG9pYAF4D/J5mHZcYRztippe/heYogqDa
 pHSQ+ICjKZfRzbrIu5WSjo9tCo8TjOAKZqUlxFecPajhipa/1PPycBH6ZFnJBISYAag7
 J8phwuUnL7lPoRT85SYhhHUZ/jn1Y3he5zOu9AGghp8r7TRTI/Zy8zD2aKr+rGg3TVvh
 bnpQ==
X-Gm-Message-State: AOAM5326PKCX06r1a1WOOFOB7usmONPEcZ/vtYo9ldk1gmGdPoOwZ2Ny
 BAk52QrOoYo2Gcb4FcUNRKTHEFeRjj5zDlVozAyhUIGNIDFtrZpcQpPDzYXZZjtfgsxeU+W30uR
 3NNPLvX5OCmwVMuKZR6bTM3dK
X-Received: by 2002:a05:6402:2694:b0:42d:e05d:3984 with SMTP id
 w20-20020a056402269400b0042de05d3984mr45048175edd.419.1654785119489; 
 Thu, 09 Jun 2022 07:31:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjKIDr06Ob8RUhbWgv5oIhFuMymqzsjg5w/CWS5+EBMFZvCWCH4hGdAZjOA3AlQIOofjXZxA==
X-Received: by 2002:a05:6402:2694:b0:42d:e05d:3984 with SMTP id
 w20-20020a056402269400b0042de05d3984mr45048155edd.419.1654785119282; 
 Thu, 09 Jun 2022 07:31:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 vf5-20020a170907238500b007066283fdfesm10065131ejb.111.2022.06.09.07.31.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Jun 2022 07:31:58 -0700 (PDT)
Message-ID: <f9437202-9a80-7dbe-e6b1-b831a0c50b0a@redhat.com>
Date: Thu, 9 Jun 2022 16:31:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.19, take #1
To: Marc Zyngier <maz@kernel.org>
References: <20220609141731.1197304-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220609141731.1197304-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, sunliming <sunliming@kylinos.cn>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 6/9/22 16:17, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.19-1

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
