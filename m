Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031A6C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 24 Dec 2022 09:17:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 882574BA3D;
	Sat, 24 Dec 2022 04:17:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cKWYMBvFqyWZ; Sat, 24 Dec 2022 04:17:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70DFC4BA78;
	Sat, 24 Dec 2022 04:17:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E61B84BA1C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 04:17:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0vDMO1W3U-Dg for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Dec 2022 04:17:03 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A804D4B9BC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 04:17:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1671873423;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1WJ5IG512JK4HdlC/w+MEPT5hs4wW6eIO1tcvJBoFHE=;
 b=F90mZhlT6A4P/+WBvMOsTfUQRosPffV66Drf29IkT+UX9MUmQ9g/eIT8fbMd+eICKynE4k
 UCrEnwBkD7+8QJEjb/bsx72dapi6ixfbEA4nWwpj2mc+7Oz/s0VsvfXXRH5Y3A+4BifQQB
 UpjU7T1r5bBMs7kvfBqBZEQQvb27Y/M=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-224-M6K4QprmN3uX1IeJeozeDQ-1; Sat, 24 Dec 2022 04:16:59 -0500
X-MC-Unique: M6K4QprmN3uX1IeJeozeDQ-1
Received: by mail-ej1-f70.google.com with SMTP id
 sg39-20020a170907a42700b007c19b10a747so4691539ejc.11
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 01:16:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=1WJ5IG512JK4HdlC/w+MEPT5hs4wW6eIO1tcvJBoFHE=;
 b=KNR8nuXT5o4VzBieHs6Zc8qLGIQW/xNIae9Jjln/dS/avg62DFuI5MEBxDQHauuJBE
 CYZq5e2Gn9GZN6ZUxUdawPIhqD2mjWM4OQHITULi9JTknfNvLzjic5I51xMqleQIlNfS
 KMfXg8EQeSnwwTEPxxWz46b55VBMmxS2qxXdEB/3+FyLLGOkhmkS8w9lVMHmJtd9yeYS
 XaZi18VWHcnGY7qe1bi22ikcyvawDuCgE9Es9QNjgirxm/LtzP1cMyXyeMgeh17Q9U4o
 DjTLX3SWEl1t5tdD77N7rQwXY8AmNnldSfgXLhrqCxDKGZOVMMEIdYrF2z/Z74MpaJxr
 x9BQ==
X-Gm-Message-State: AFqh2kpudFFr8iJZVdLhNb0/VGtdxbnIQdTmGtxXYblxuF84FstnHI4W
 1ZxFZDFlwYP+7NIOvkCjIF/20Y0j1Bcpc5TzVfzSZQ3hpl9uxJt85lhFkxxxakRTNWkdTnfBmMV
 wZ/Vw+SqxOorYhEObnb0afB/q
X-Received: by 2002:a17:906:2813:b0:7c0:f9ef:23a2 with SMTP id
 r19-20020a170906281300b007c0f9ef23a2mr12170074ejc.30.1671873418375; 
 Sat, 24 Dec 2022 01:16:58 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvxPdiaG4E8UewTBDKGwk+RrHY5iIcLLbOD+rhwdwS97aEIalcuCrM4uQvmfbCxpmo46L3Qww==
X-Received: by 2002:a17:906:2813:b0:7c0:f9ef:23a2 with SMTP id
 r19-20020a170906281300b007c0f9ef23a2mr12170039ejc.30.1671873418109; 
 Sat, 24 Dec 2022 01:16:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.googlemail.com with ESMTPSA id
 gf3-20020a170906e20300b007bff9fb211fsm2323104ejb.57.2022.12.24.01.16.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 24 Dec 2022 01:16:57 -0800 (PST)
Message-ID: <f53ed5b9-156c-e809-08e2-050217a970a5@redhat.com>
Date: Sat, 24 Dec 2022 10:16:55 +0100
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
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-10-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221213001653.3852042-10-seanjc@google.com>
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
