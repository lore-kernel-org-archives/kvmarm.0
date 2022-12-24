Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D86210A
	for <kvmarm@lists.linux.dev>; Sat, 24 Dec 2022 09:24:03 +0000 (UTC)
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
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-371-oY85SNIvPxyD1B340sZQrA-1; Sat, 24 Dec 2022 04:24:01 -0500
X-MC-Unique: oY85SNIvPxyD1B340sZQrA-1
Received: by mail-ed1-f70.google.com with SMTP id y20-20020a056402271400b0046c9a6ec30fso4945563edd.14
        for <kvmarm@lists.linux.dev>; Sat, 24 Dec 2022 01:24:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cQUoO4G6sdzLrmUADt2hv9AJA1j16aHhp8BOh9XyH3Y=;
        b=MsFfcHAdb2X8QMt8gLNeScYjHgexXjyxGXzakVHwt6263WRELpE4tB0q++d4Niqw1H
         kbZ205ZLYh9iN0oo8XF+lBGPR5c3/UzTWu+ncp6XHM1tHNV9nlgq1DgGOHhytP/49JBA
         huxhSsu5FBDD7I1u2twwm6WcIgwCvQNH6L1oVmqxkyDUHqbuw7a2Ak3d7arxAN6BWan2
         csVHCs5i39knyOkddLBlTRVCAgBEm4NtdPSOGLh/lJV7fabx8KhfwppVXwWJAhKBooCC
         BKyi4wF6zu6cGGWQx3+xU0mpQFwJL3adcgq1kfnzeraPWPfJ5cy1fLiFkKr1p3yucZcD
         dUGA==
X-Gm-Message-State: AFqh2kpi0MQ583amlJrDWZamTFFNU+uEtqWJeBfez5sLDcjYeF1e+pDO
	REAiRxxPprxQUhXgFIv1HlSjEMYoSfy860k27B2Z43HM6LK47/RqqYMDf/HP0fEnm43bklpWMbf
	XXHXSN6wDgCOBoKDb
X-Received: by 2002:a17:907:c084:b0:7c1:22a6:818f with SMTP id st4-20020a170907c08400b007c122a6818fmr9962693ejc.25.1671873840059;
        Sat, 24 Dec 2022 01:24:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu5yag+Wn0Qcys8xdIlgtscsBUCyajRo/QuR9Np12zFtuRKH0vsauC+7pwndJ75MH59prtGFQ==
X-Received: by 2002:a17:907:c084:b0:7c1:22a6:818f with SMTP id st4-20020a170907c08400b007c122a6818fmr9962684ejc.25.1671873839849;
        Sat, 24 Dec 2022 01:23:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id u18-20020a1709061db200b007c073be0127sm2305389ejh.202.2022.12.24.01.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Dec 2022 01:23:59 -0800 (PST)
Message-ID: <363f4713-6105-82d1-351e-423d07470cdf@redhat.com>
Date: Sat, 24 Dec 2022 10:23:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
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
Cc: James Morse <james.morse@arm.com>,
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
 <20221213001653.3852042-13-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221213001653.3852042-13-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221224092357._hbxcRh5yM2DybHzGjEftEAAS1eOXNKMTu5hXPq-BpQ@z>

On 12/13/22 01:16, Sean Christopherson wrote:
> Use $(wildcard ...) to find the library source files instead of manually
> defining the inputs, which is a maintenance burden and error prone.

No, please don't.  This leads to weird errors, for example when "git 
checkout" is interrupted with ^C.   I have applied patches 1-11.

Paolo

