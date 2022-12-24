Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B90C10F1B
	for <kvmarm@archiver.kernel.org>; Sat, 24 Dec 2022 09:18:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FA564BA78;
	Sat, 24 Dec 2022 04:18:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E0kXGxeHR3Wu; Sat, 24 Dec 2022 04:18:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E577C4BA88;
	Sat, 24 Dec 2022 04:18:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 248844B9BC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 04:18:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Mlv+3hfANfx for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Dec 2022 04:18:41 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED0EA4BA3D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 04:18:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1671873520;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QxublDXwR8D5DtOHl7/e/B0PH3ei1t0qPkoztnwEfr0=;
 b=YhKgv7ArEmsLS3tM3IOIS99lwy/ZTJdMA5eRTU6Oc8wM+J+alNp38wVAvmfODlsNouRja9
 6iX85jLUjCokTljlVeNbwNPYRjN/WgFM9Ro849ZOQHC6+ebX0FvxGukd+3zIaoKHIcp9v1
 j9f/SZqd0XurqBomshGixqYSQFrorS8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-392-Q6WDC5YFMLKZP9vbxzDp7Q-1; Sat, 24 Dec 2022 04:18:39 -0500
X-MC-Unique: Q6WDC5YFMLKZP9vbxzDp7Q-1
Received: by mail-ed1-f71.google.com with SMTP id
 x13-20020a05640226cd00b0047ac11c9774so4939415edd.17
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 01:18:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=QxublDXwR8D5DtOHl7/e/B0PH3ei1t0qPkoztnwEfr0=;
 b=aE9iIABwxT56LMU6LLsqg1JV5UmyxHhun/mSHZsnzq9QvAEJNuopGhSmFga1CpddY0
 LzpTM1+IBxscOB6ky849YHIBcuOKvbupCogAjFqVYFluerqDJ+FDBUZgVY+Gt6iUmHy7
 agtEY9xIkC7zsPqs2HI4UXcyiFs3oEyRkFbnQCcD+Tx3eFgKYQ07Q1tMVYXQXSrOsHw5
 VPlxlYkb5c7Fg3wVID3f73DEawqC4H8VOmZrDX1kuAzCvCgDyZpbfIMCHT0x7/S1TASn
 9Ppx5IIUYAgBhyvooWB0TpDDXquljP0OrQB2VkdFUyTYia47Ms4hytRgARctXoDVr6S8
 VCWw==
X-Gm-Message-State: AFqh2kq9q2iuYkcy0yaZsaHXCgIQt/6QiYdiS/9jHLA8y+fL33u/bRow
 13JnL/MLpFLmt5VRQYxbQH4NktaJnRQIH0ZxEhW7vDJlxwm6i+/DZjW4QbpAZu7+J4h+c6r6RfA
 DztzdZXVNBZrq0tJlAsZxVrZe
X-Received: by 2002:a17:907:20b0:b0:7d3:8159:f361 with SMTP id
 pw16-20020a17090720b000b007d38159f361mr10353256ejb.36.1671873517910; 
 Sat, 24 Dec 2022 01:18:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuzaX4Vch7tXx6y3KWiTjg6uUOEDxqKJ4lnD0J2K3STImlt9Y+l7L7jqIYGtkrdkVnkKuq68w==
X-Received: by 2002:a17:907:20b0:b0:7d3:8159:f361 with SMTP id
 pw16-20020a17090720b000b007d38159f361mr10353228ejb.36.1671873517691; 
 Sat, 24 Dec 2022 01:18:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.googlemail.com with ESMTPSA id
 kx20-20020a170907775400b0078d3f96d293sm2338931ejc.30.2022.12.24.01.18.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 24 Dec 2022 01:18:37 -0800 (PST)
Message-ID: <4f789996-28aa-1d9c-f918-03de663d28b8@redhat.com>
Date: Sat, 24 Dec 2022 10:18:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 10/14] KVM: selftests: Include lib.mk before consuming
 $(CC)
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-11-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221213001653.3852042-11-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
 Tom Rix <trix@redhat.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
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

On 12/13/22 01:16, Sean Christopherson wrote:
> Include lib.mk before consuming $(CC) and document that lib.mk overwrites
> $(CC) unless make was invoked with -e or $(CC) was specified after make
> (which apparently makes the environment override the Makefile?!?!).

Yes, it does.  In projects that don't use configure or similar, you 
might have seen

CFLAGS = -O2 -g

to be overridden with "make CFLAGS=-g" if optimization is undesirable.

Paolo

> Including lib.mk after using it for probing, e.g. for -no-pie, can lead
> to weirdness.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
