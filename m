Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3ECC4167B
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 09:48:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 418FD40439;
	Tue, 13 Dec 2022 04:48:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h5Ikb+xsp7OM; Tue, 13 Dec 2022 04:48:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCE184B92F;
	Tue, 13 Dec 2022 04:48:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1FDD4B902
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 04:48:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id US3XNa2x3YMX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Dec 2022 04:48:03 -0500 (EST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90BE340439
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 04:48:03 -0500 (EST)
Received: by mail-wr1-f42.google.com with SMTP id o5so15018134wrm.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 01:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=9kjr0P8P3evTsHtv0kx5R0LLm1BjbVlP2JBqTHfgIEU=;
 b=wxREDceclsVP4jxePxvte5FDBoV8oOTQ+kk6QFnlyxJvqYJlw6q99Pp1nurNiEIDcM
 9/QhIdsqo/Mvmd0D1NOjeYmiTaUYd27+N8bXw7PgG1XVqeuHvL0gucTFuUCy0TiqiLnY
 cJGcXgCzKmAfB+NHUwBa04Ks9c6wflPCLOsAECG/QjplFaeuNUn2phsb6D3wu+2hEwsu
 84WblEtk36HvUMtvdeu9efTCSwNFLmaTDZ8ypqla1IRKx/eWU0SU7u2K0C26EvvPsz9i
 fQ3rQMJDeLJobD49zJBFgCw9BxJVhEqU4EgqX+/2ZBjH0vLq+9zvQwzpZ3qp6a0lyLlu
 Xprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=9kjr0P8P3evTsHtv0kx5R0LLm1BjbVlP2JBqTHfgIEU=;
 b=I4fxMadsQjyot3Cd+9wowTE2GsBRwGoJ0ZlnMO3/8l6GMBq7PbuV8UfkMDxuGz3+bw
 h+UZUG2Ew+kWBLUywmVpgPZQBnfI0TTmLRHo3NAD92XuexBnaFte/9DG5z6g3uZP00n3
 YtOh1ewlKkHu5t5EKTvJxGFHm72/nhYKNU6QZ+wO7IZaN5rsaC7pJFvx4DZJfO6Sr0ls
 pPSV6MSkZE5yOD3DmWX7q9SZi/JvfNLgLISAOB3GAfgFfwpiZeDAqd8y7AZR56emhLsY
 EJZwggaGBmupECZ2MyB+s6SdaHl2neuyTIhwQNEkixcD9xjWWTr38AEZbzSr08d4/yTF
 oG3Q==
X-Gm-Message-State: ANoB5pmHfxbMxrZLezhmUmrv3Z4c68OcOavHcN4C6qjTRskNVCEsG7oI
 WC18GJw3wvAOHfB4NuE/fevImg==
X-Google-Smtp-Source: AA0mqf7qf8gp5KDq16JqrUroPUpREMH1ONeNa3KMxmeoce64zNsGbHFkbza+M0tQPkVeVr4/pP6aWw==
X-Received: by 2002:a5d:490d:0:b0:242:fa5:ce83 with SMTP id
 x13-20020a5d490d000000b002420fa5ce83mr14631600wrq.37.1670924882743; 
 Tue, 13 Dec 2022 01:48:02 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76]) by smtp.gmail.com with ESMTPSA id
 f7-20020a5d5687000000b002365730eae8sm11005215wrv.55.2022.12.13.01.48.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Dec 2022 01:48:02 -0800 (PST)
Message-ID: <ba1760b7-3153-d761-d0aa-3bf321f2f682@linaro.org>
Date: Tue, 13 Dec 2022 10:48:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 07/14] KVM: selftests: Use proper function prototypes in
 probing code
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-8-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221213001653.3852042-8-seanjc@google.com>
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTMvMTIvMjIgMDE6MTYsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4gTWFrZSB0aGUg
bWFpbigpIGZ1bmN0aW9ucyBpbiB0aGUgcHJvYmluZyBjb2RlIHByb3BlciBwcm90b3R5cGVzIHNv
IHRoYXQKPiBjb21waWxpbmcgdGhlIHByb2JpbmcgY29kZSB3aXRoIG1vcmUgc3RyaWN0IGZsYWdz
IHdvbid0IGdlbmVyYXRlIGZhbHNlCj4gbmVnYXRpdmVzLgo+IAo+ICAgIDxzdGRpbj46MTo1OiBl
cnJvcjogZnVuY3Rpb24gZGVjbGFyYXRpb24gaXNu4oCZdCBhIHByb3RvdHlwZSBbLVdlcnJvcj1z
dHJpY3QtcHJvdG90eXBlc10KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4KPiAtLS0KPiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2
bS9NYWtlZmlsZSB8IDQgKystLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKClJldmlld2VkLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhp
bG1kQGxpbmFyby5vcmc+CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
