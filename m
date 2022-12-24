Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAFA210A
	for <kvmarm@lists.linux.dev>; Sat, 24 Dec 2022 09:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671873421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WJ5IG512JK4HdlC/w+MEPT5hs4wW6eIO1tcvJBoFHE=;
	b=Tc7Xku+IyC+S1yNG6F9lUgTbJAW9zwMUFY5tiu4muqOWCHMn9wR0kyD4xg9R10/IYe4i3c
	1qDtcsfEA1WMUQ8qFRCQw8aqkvLZIjBSa0s6IocG9WGUOEBfwgQtcvT/wSbr8+1uG8iofw
	kSCnc/6WnZVZy5zT5iFhn6bYlpDHSuw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-441-x-42Z6uHM6-6btBaj2au8Q-1; Sat, 24 Dec 2022 04:16:59 -0500
X-MC-Unique: x-42Z6uHM6-6btBaj2au8Q-1
Received: by mail-ed1-f70.google.com with SMTP id f15-20020a056402354f00b00475a6378738so4910341edd.8
        for <kvmarm@lists.linux.dev>; Sat, 24 Dec 2022 01:16:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1WJ5IG512JK4HdlC/w+MEPT5hs4wW6eIO1tcvJBoFHE=;
        b=r0iKkl8n6YSNWCylfTNCGiMFr4yZ+Qd7L/Y/eg3HVNNP0QUJTgCFkAj1tKKVDgqkDx
         kGtBWWGQAQdfnHp2oDCdbcuh83mUcR1EIwu3dvitSsiG9HxTwrz9k0JbqqlYetPX/eN2
         ZirM5oRirXXhLanynvf/ZYCawl+AdP+xtCYaWLTa91jxsuQLU/UXpVLf8rS7pt+5QhIH
         /KZsHc3o/bTs5+8Fthrw17x3WygN5+vVidPGSjNbKBTzq+8h1nh48Kp1B6DP4pQBwChg
         GEHYAgQ6t6S1TRyG2NiWJGdqFzDrJRgiEETLv6PXrqTEeW9ecPb3U0svZ+aLaztiU00D
         HFZA==
X-Gm-Message-State: AFqh2kp47aY1KIrlgxU5DdF0zgVc581BUApPQl/thxjIW6FkdMAr1NDG
	bpQciwv9BZgPdl6Qt0FvJnsZiKbStR1lUuxlzyFMIC3ZGhlbl1++2ZLyjpkshukXsFOqPN5Ihhw
	614qt8SNnavfysUP3
X-Received: by 2002:a17:906:2813:b0:7c0:f9ef:23a2 with SMTP id r19-20020a170906281300b007c0f9ef23a2mr12170063ejc.30.1671873418351;
        Sat, 24 Dec 2022 01:16:58 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvxPdiaG4E8UewTBDKGwk+RrHY5iIcLLbOD+rhwdwS97aEIalcuCrM4uQvmfbCxpmo46L3Qww==
X-Received: by 2002:a17:906:2813:b0:7c0:f9ef:23a2 with SMTP id r19-20020a170906281300b007c0f9ef23a2mr12170039ejc.30.1671873418109;
        Sat, 24 Dec 2022 01:16:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id gf3-20020a170906e20300b007bff9fb211fsm2323104ejb.57.2022.12.24.01.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Dec 2022 01:16:57 -0800 (PST)
Message-ID: <f53ed5b9-156c-e809-08e2-050217a970a5@redhat.com>
Date: Sat, 24 Dec 2022 10:16:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 09/14] KVM: selftests: Explicitly disable builtins for
 mem*() overrides
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
 <20221213001653.3852042-10-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221213001653.3852042-10-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221224091655.vxAzQ78wQFdkNhNBvAmNDFqHBmO-4AEm2L2kAhDQpQI@z>

On 12/13/22 01:16, Sean Christopherson wrote:
> Explicitly disable the compiler's builtin memcmp(), memcpy(), and
> memset().  Because only lib/string_override.c is built with -ffreestanding,
> the compiler reserves the right to do what it wants and can try to link the
> non-freestanding code to its own crud.
> 
>    /usr/bin/x86_64-linux-gnu-ld: /lib/x86_64-linux-gnu/libc.a(memcmp.o): in function `memcmp_ifunc':
>    (.text+0x0): multiple definition of `memcmp'; tools/testing/selftests/kvm/lib/string_override.o:
>    tools/testing/selftests/kvm/lib/string_override.c:15: first defined here
>    clang: error: linker command failed with exit code 1 (use -v to see invocation)

Hmm, that's weird though.  I think it's an effect of ifunc and maybe 
even a linker bug.  The patch makes sense anyway.

Paolo

