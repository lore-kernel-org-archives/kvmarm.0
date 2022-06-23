Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8EDC43334
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 12:16:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 347FE4B3B6;
	Thu, 23 Jun 2022 08:16:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lh+YDwNGAhTL; Thu, 23 Jun 2022 08:16:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D4EA40B03;
	Thu, 23 Jun 2022 08:16:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9FE740B03
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 08:16:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5BX5HCZcEi-3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 08:16:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C686E4089E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 08:16:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655986581;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=g5bzHytzbyt3LJ4/dxkxeQpreFgNZKacxErPJ4wA59E=;
 b=B0LfD2kV0x229827MmnrCxoND3KXyjEh8upwnejclhbooyx2BeSUcpFXoYA4SB3TxqUO8N
 gOvmYPBpMT6H+wG3C0RKvM5/2mmEdg7K6NyTR7NCGm/YUcnF0bZoDIH73+bC7SVTrnKyHa
 2Udv29QhVchWNBaPGvT7JExwzm5mhmY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-yK_4-uxJNN2cASOef3wsmw-1; Thu, 23 Jun 2022 08:16:20 -0400
X-MC-Unique: yK_4-uxJNN2cASOef3wsmw-1
Received: by mail-ed1-f69.google.com with SMTP id
 m8-20020a056402430800b00435cfa7c6d1so1312154edc.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 05:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=g5bzHytzbyt3LJ4/dxkxeQpreFgNZKacxErPJ4wA59E=;
 b=s4uiRqDHqybRh37WygCkmdMO9W6kWwPjNOfCq7adND6LM+piMOYdU6drJUrezeim+L
 39ZV6SmDA2A4cGGFnB3BjB0IVbLCOZKAfvj+aOiAjyCiXZnJLhyxYUWoUhUAo3X/GEJl
 uJXm1EtKcitHuAB80mrE8mz3XlUQjbiJgYKLVLgZsT5qO3EuEv+S39Suq24c1l+3ACWO
 2RHYk7VvrUR2TQ5bDG//N1RwZMqQUwfcSnOhMdgzSncbY9QLeomPyLiKYySjIGXO1Fve
 ScomJW3gHPtN3FRqpT6xvSn7F3ACbPdW1nun4Tx7jUFeiSjisxJzfaw7TP0M5Y63B1gS
 VxEA==
X-Gm-Message-State: AJIora8KZmNO0Fqaop2WAk5WwcMHwrz1P6gU0M787xnI0fOhlAHmlMlN
 brPqDWhw0uUfHzifSujWz2+JWr5RVO65rim5+QrBJzbX/RuU/NnHXD5nCH9YvHlov18bRtuLxXh
 kUxl5jyUlrkR2dbRWJs5AdGQe
X-Received: by 2002:a05:6402:3546:b0:42e:2f58:2c90 with SMTP id
 f6-20020a056402354600b0042e2f582c90mr10416197edd.84.1655986579146; 
 Thu, 23 Jun 2022 05:16:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5GbGLU/i4oYJJek4q+iHhJv6ku0wmJbThXLZyDHJYQGqHKnaW+A0I0asdOmN8xuRbLwQSQA==
X-Received: by 2002:a05:6402:3546:b0:42e:2f58:2c90 with SMTP id
 f6-20020a056402354600b0042e2f582c90mr10416167edd.84.1655986578936; 
 Thu, 23 Jun 2022 05:16:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 d8-20020a056402000800b00435a912358dsm3953372edu.30.2022.06.23.05.16.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 23 Jun 2022 05:16:18 -0700 (PDT)
Message-ID: <795f73d0-9f88-28c9-9d8f-41e931f51230@redhat.com>
Date: Thu, 23 Jun 2022 14:16:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.19, take #2
To: Marc Zyngier <maz@kernel.org>
References: <20220623074158.1429243-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220623074158.1429243-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Mike Rapoport <rppt@kernel.org>
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

On 6/23/22 09:41, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.19-2

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
