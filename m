Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C715C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 28 Jan 2022 12:48:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213A74B0D9;
	Fri, 28 Jan 2022 07:48:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cv6Iy-o5EbQz; Fri, 28 Jan 2022 07:48:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D52C24B0E1;
	Fri, 28 Jan 2022 07:48:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 580AC4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 07:48:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z0-znBipcxvS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jan 2022 07:48:24 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2151049F1C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 07:48:24 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643374103;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Bo8ZOiKS2adjR5eMsgOruuTsYEGNkSRUgFp15Xq4s0k=;
 b=d0jDuJhy77oKEDTTcVGOdLpqMa/JRl7RFEsmmMX8SAggTjntqp7qi6puwEafCakj1suL/z
 H8anDsaZ2MVqmxkaz0+3e0jvIO4yD6IBQFh1ikfnTWxIMKbws91T1lWQ7mA4Ye72e0VvAp
 2Y4yrgGeTn6rch90CxekjcGn61wUMN0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-LQRSnvr3OGOy0c9rqSB5Qw-1; Fri, 28 Jan 2022 07:48:19 -0500
X-MC-Unique: LQRSnvr3OGOy0c9rqSB5Qw-1
Received: by mail-ej1-f72.google.com with SMTP id
 r18-20020a17090609d200b006a6e943d09eso2812432eje.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 04:48:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Bo8ZOiKS2adjR5eMsgOruuTsYEGNkSRUgFp15Xq4s0k=;
 b=vOJDwvBQhpmSt1usrmt6FAiYWFMugmrS3UlgGCigCpC16lc/M9K4wWAqs/AGMmHJc0
 XX3vqiQmZysnE5z1zYp8HVjh8Sr3B609iG3vxqB2O80OKSgRL4sOm5xgTfjp8dW9OvQT
 VqtYf3eE47ymLh7OTMsnCgSVdbD34o+gPr4iHjO7yJb3xHQPFfjJ8KazgQbuLRxE7i1r
 GU+XQx2ZQuJZX0FPDsF4TR2t2mc+pnu7n7tPbbfRbcjTG/tLRLY/FLXdEEWrbKh9ftuu
 z1FTmEIS16wURVt0S9P9cRwjJRFEt5cKRkelFVQOEhx7oLU6OuYFfMo/dIQ5Z7Unym4O
 9znA==
X-Gm-Message-State: AOAM532keV6TGiSteKAgbkTxcy1KHmkumKdk8B7Yqom/4FjFzI45SjD1
 s00H1ep8I8U3E+iApOju6ycZMTFcoCScAuwAVifZUFBCBNUSz6EIn0dWrdlv3/FvzGQHdG0Zjn7
 /m3rmRP3K+F5jmZhyzGU9xOga
X-Received: by 2002:a05:6402:650:: with SMTP id
 u16mr8010751edx.167.1643374098331; 
 Fri, 28 Jan 2022 04:48:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwB2OzlwLHsX6cQfqU4/ONk7VwKQxBpbkHfUGKrzVKUNTmNb3W4B/+uFDcrKSXpWkuMhcbW/Q==
X-Received: by 2002:a05:6402:650:: with SMTP id
 u16mr8010728edx.167.1643374098108; 
 Fri, 28 Jan 2022 04:48:18 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id d3sm2657530edq.13.2022.01.28.04.48.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 28 Jan 2022 04:48:17 -0800 (PST)
Message-ID: <8a78eca4-79b2-e183-f01a-6f56124bfdeb@redhat.com>
Date: Fri, 28 Jan 2022 13:48:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.17, take #1
To: Marc Zyngier <maz@kernel.org>
References: <20220128101245.506715-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220128101245.506715-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 1/28/22 11:12, Marc Zyngier wrote:
> The following changes since commit 1c53a1ae36120997a82f936d044c71075852e521:
> 
>    Merge branch kvm-arm64/misc-5.17 into kvmarm-master/next (2022-01-04 17:16:15 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-1
> 
> for you to fetch changes up to 278583055a237270fac70518275ba877bf9e4013:
> 
>    KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE (2022-01-24 09:39:03 +0000)

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
