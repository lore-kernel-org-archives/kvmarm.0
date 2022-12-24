Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2590C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 24 Dec 2022 09:24:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A6BD4BA7E;
	Sat, 24 Dec 2022 04:24:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XSTx78qGG9tD; Sat, 24 Dec 2022 04:24:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36D954BA89;
	Sat, 24 Dec 2022 04:24:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E88AA4BA7E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 04:24:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cv3WdUMjVnYE for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Dec 2022 04:24:03 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 026614BA7D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 04:24:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1671873842;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cQUoO4G6sdzLrmUADt2hv9AJA1j16aHhp8BOh9XyH3Y=;
 b=CZBoYWAy6Z5RBAWnvdnyWFuYL2HcefczTyu05FYC19uc2jlNr+paRq58bkJuJaAuvF2e3I
 R1reaewZCxioBnU2dHsH8dS6QYUSFl4Jk9864ePBdKrNoZMdYGmMfyk71g2byGORYJB+mc
 tvYYGTM3jXQHulCMLta+IdQDIItMIXA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-KzJKDRkmNKS8vgI6bxO4bw-1; Sat, 24 Dec 2022 04:24:01 -0500
X-MC-Unique: KzJKDRkmNKS8vgI6bxO4bw-1
Received: by mail-ed1-f72.google.com with SMTP id
 m18-20020a056402511200b0046db14dc1c9so4965050edd.10
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 01:24:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=cQUoO4G6sdzLrmUADt2hv9AJA1j16aHhp8BOh9XyH3Y=;
 b=sH5VD4FGeemOZ/mSmw3TSVRahbr0TBWFjX5memQyvXxhvvJ3NTxas9l6Vlnb7JhtH+
 1n6Emp+KyvWOBnF1+9dz8/STP5c0FDB8dZe/dY+kZsoWqoIZitJYrizcxAhiSGg8BuQT
 /nDc2ELq7MiYJLRa2FGvUuSzshEOIUgyBtIcv7u4xFIiUyoNytCWPklyLKyDm3aA35hc
 avnhy9+RWr17H8QVDyh6x1BVG2u4aimgTLpcAEod4QQ7fOxwjeZUuH7acOaSDyntSuGW
 jbyr02HdaJ7Phc6DPIc0K7UrLDow0BdjM9CpJuxhsL3Mq9QdvBEj+z+oQeYGW5AT4WqH
 ANIg==
X-Gm-Message-State: AFqh2krAnFIGGZxoSiaMmlHcc29n51T7C1OSNJn3HCWwAH+BBzChoS5z
 SghjpcqPJMWEtSQP2qT0MIP7ZVMPYXc/gX1HrC4DxSs+xr9HTSGdVUUEds+3gx6Z5idQHJFFWtx
 KzXmXardg+3tT9EjYtUn9fH8q
X-Received: by 2002:a17:907:c084:b0:7c1:22a6:818f with SMTP id
 st4-20020a170907c08400b007c122a6818fmr9962694ejc.25.1671873840059; 
 Sat, 24 Dec 2022 01:24:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu5yag+Wn0Qcys8xdIlgtscsBUCyajRo/QuR9Np12zFtuRKH0vsauC+7pwndJ75MH59prtGFQ==
X-Received: by 2002:a17:907:c084:b0:7c1:22a6:818f with SMTP id
 st4-20020a170907c08400b007c122a6818fmr9962684ejc.25.1671873839849; 
 Sat, 24 Dec 2022 01:23:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.googlemail.com with ESMTPSA id
 u18-20020a1709061db200b007c073be0127sm2305389ejh.202.2022.12.24.01.23.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 24 Dec 2022 01:23:59 -0800 (PST)
Message-ID: <363f4713-6105-82d1-351e-423d07470cdf@redhat.com>
Date: Sat, 24 Dec 2022 10:23:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 12/14] KVM: selftests: Use wildcards to find library
 source files
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-13-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221213001653.3852042-13-seanjc@google.com>
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
> Use $(wildcard ...) to find the library source files instead of manually
> defining the inputs, which is a maintenance burden and error prone.

No, please don't.  This leads to weird errors, for example when "git 
checkout" is interrupted with ^C.   I have applied patches 1-11.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
