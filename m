Return-Path: <SRS0=4uwO=PT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9ECC433F5
	for <kvmarm@archiver.kernel.org>; Sun, 31 Oct 2021 06:30:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFCD160F93
	for <kvmarm@archiver.kernel.org>; Sun, 31 Oct 2021 06:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BFCD160F93
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B47C4B11A;
	Sun, 31 Oct 2021 02:30:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4n0BzTrYrliX; Sun, 31 Oct 2021 02:30:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28EE44B11E;
	Sun, 31 Oct 2021 02:30:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DE474B11A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 02:30:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R+-dyHMjbBrg for <kvmarm@lists.cs.columbia.edu>;
 Sun, 31 Oct 2021 02:30:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F3E04B10D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 02:30:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635661847;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UuMUoN3DNgMNQuGO47M8OlVwO//v5SsV/9a4qP2ja2s=;
 b=IjxHk3ZTnGhm+BX+KtfXVHrz8+ySDmnZ1GKNv2bqLiGaL8M6rc/bBiSiw6uKURHNFdvSni
 MRHvrEcyQPJ0+eyguSnIqE+JkVshDpT+uYnLYVTJ1Aam0Vp/G0SQgiErISzA/VyG87e64w
 NdTARKrjMkxYkOGLl4ABSsaxeKBXaBQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-bsF0C521NUGt5X2l2cJBOg-1; Sun, 31 Oct 2021 02:30:45 -0400
X-MC-Unique: bsF0C521NUGt5X2l2cJBOg-1
Received: by mail-ed1-f69.google.com with SMTP id
 c25-20020a056402143900b003dc19782ea8so12879817edx.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Oct 2021 23:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=UuMUoN3DNgMNQuGO47M8OlVwO//v5SsV/9a4qP2ja2s=;
 b=VwUUOn4V/ZejMJUDU9Z+u/K7Hz++JBz4C0/A1Baq4YVILsCy7IVItEmdPKab/ldafs
 zSlb2N/24vHSll/3R0AZ44bbIEjFC2ahzTY3ML0bVEVVHgvqX0lW4k4yoI+uOz5zBzDZ
 vN7lxnPjQTBiGOw7sN9kmhglUz8sm+P0/cIsLih66B733kfPr4ROaP9bhM1JD7cYy7hC
 3Bx6i2NsdimhpR37coWjMZuvVgxUbQ3UnxkI7YfWV9UjadmSsO60LLZfwHnz/1KOCLH/
 rj04nDe5Ya3iiEieyt0X8jymbh25jHsIZZyIh2vcTqg2JL+uFXpC3sy83bV6X7eINMSe
 6WJQ==
X-Gm-Message-State: AOAM531CpQsQRTb5hQwikRVQKXNobdO3dqxr6gCojXOcoRsIzqJ0zsY+
 9YHjhJ7mWlKVuJg48XbK6Z2VQgIskIzbK04P8UqeRbFKRzD6i5zuQwxNe0aYz3yVgz2ePGsP490
 vi22gh8z0akjAJGLZIuHz/OKx
X-Received: by 2002:a17:907:9810:: with SMTP id
 ji16mr7345906ejc.373.1635661843954; 
 Sat, 30 Oct 2021 23:30:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYR8/w3iMBcLwPHxc1ndn6etLor4iw6lD26BqfNQfkVxlJyFTmd+iZCakiFuTDetnIrtSR4w==
X-Received: by 2002:a17:907:9810:: with SMTP id
 ji16mr7345886ejc.373.1635661843735; 
 Sat, 30 Oct 2021 23:30:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id s3sm5194685ejm.49.2021.10.30.23.30.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 30 Oct 2021 23:30:42 -0700 (PDT)
Message-ID: <cfd722b9-7b18-232e-b2c7-65806b8d05ff@redhat.com>
Date: Sun, 31 Oct 2021 07:30:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.16
To: Marc Zyngier <maz@kernel.org>
References: <20211029093510.3682241-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211029093510.3682241-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: linux-arm-kernel@lists.infradead.org, Jia He <justin.he@arm.com>,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.cs.columbia.edu
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

On 29/10/21 11:35, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.16

Pulled, thanks!

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
