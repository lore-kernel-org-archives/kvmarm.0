Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7922F38
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673454190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bAzX0I8qhNQFozyjHTOv5miI6bc1TzOt0NGHpESsMAQ=;
	b=ZF9oTALa1/CtwK3qQhO+AnEJN3srrAyktMfRkyBHlt13zXNE/jEQAfGtPx+rgiPQEYexoK
	oi4u/uN5aPDIvrT9GpaGL6bY0fj1Cv0YPD8vVU7Zmn2YngMMIxn0CQarC0atJCLF51F44I
	Z1vGfeqTf1gVr7v8TwQo0BvPQGasHFU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-574-VX8tHpXnNGei2eRL0CRqiw-1; Wed, 11 Jan 2023 11:23:06 -0500
X-MC-Unique: VX8tHpXnNGei2eRL0CRqiw-1
Received: by mail-wr1-f72.google.com with SMTP id m12-20020adfa3cc000000b002b881cb0cb4so2819368wrb.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 08:23:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bAzX0I8qhNQFozyjHTOv5miI6bc1TzOt0NGHpESsMAQ=;
        b=YhtjIols912Z463631px8JgpElGB6AuYI1+3Jps86c1bWZkZXTDIEHue12U3v+0aFd
         pFJomFuJE3pBNwHjOCuC27S8fhN78Q7uldcjov2keU1svHCFl1dqrJkU2dzzJQsBrzML
         3KHaSgRLmg2VR6fr8srH6u4r1BvXXMZmcb2P+wNeDWLv9fDi5/TdPrxyI7XzDD1jkPDT
         Qvenel4nZkjJbw1ltqhYTiBHvBZ4IXL560weNMdtGq1ywZdQzLi2fkl87zhwG5Eplrd+
         JWMnIbIpE7IK/aHeZgUNAU3l62h6T4E4P1zogu+eUqfs+5mBRvl1LjFxdXlDg135I5Fy
         tS2Q==
X-Gm-Message-State: AFqh2kqPh0mxgl4lDfPqZvbQXaFjb0CJ9ssAuZycVvZje44YlHZ9FgCq
	NZbnPMNybzsXmU9m7m4lvVrGcZEtrkrZ9P0LSvGX557jL9oqllHHL4fGimlLV/o8AvyTSV564M8
	tQTHmEDejoJrWECUz
X-Received: by 2002:a7b:ce06:0:b0:3cf:a483:3100 with SMTP id m6-20020a7bce06000000b003cfa4833100mr52806232wmc.3.1673454185163;
        Wed, 11 Jan 2023 08:23:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtLvuQHiCtmyqnm4CLAs4LBNQIvAx3luYBZ9kZsu5kzE6A6u6fOimphXyAb5WqlrOBkfqsJsQ==
X-Received: by 2002:a7b:ce06:0:b0:3cf:a483:3100 with SMTP id m6-20020a7bce06000000b003cfa4833100mr52806198wmc.3.1673454184874;
        Wed, 11 Jan 2023 08:23:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id v10-20020a05600c444a00b003d998412db6sm25266750wmn.28.2023.01.11.08.23.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 08:23:04 -0800 (PST)
Message-ID: <8333e62b-8bb6-981f-ba07-d867ec61657e@redhat.com>
Date: Wed, 11 Jan 2023 17:23:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 11/14] KVM: selftests: Disable
 "gnu-variable-sized-type-not-at-end" warning
To: Sean Christopherson <seanjc@google.com>,
 Nick Desaulniers <ndesaulniers@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Nathan Chancellor <nathan@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Tom Rix <trix@redhat.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
 Aaron Lewis <aaronlewis@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-12-seanjc@google.com>
 <CAKwvOdnRQQb9YbH=MgDymBmmjYgajc8tkyjbJVxjpA5zDZpNTQ@mail.gmail.com>
 <Y5ffxebJ/eRzEXh+@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5ffxebJ/eRzEXh+@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/22 03:13, Sean Christopherson wrote:
> AFAICT, gcc stopped treating unknown "-Wno" flags as unconditional errors starting
> with gcc-4.4, and the kernel's min supported version is 5.1.  gcc-4.4 through
> gcc-9.5 all print a mild warning if there's a different error, but otherwise
> silently ignore the uknown "-Wno".
> 
>    cc1: warning: unrecognized command line option '-Wno-gnu-variable-sized-type-not-at-end'

scripts/Makefile.compiler has cc-disable-warning for this, we can copy 
it to tools/.

Paolo

