Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F48C4167B
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 09:52:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1BF44B941;
	Tue, 13 Dec 2022 04:52:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aEA1vrUF67eh; Tue, 13 Dec 2022 04:52:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E9E74B937;
	Tue, 13 Dec 2022 04:52:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29A1C4B902
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 04:52:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YEKXhHerdwKM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Dec 2022 04:52:01 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 188BB4B75D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 04:52:01 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id h11so14987634wrw.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 01:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=Q5puRTi/aBwHreExscKf/w+BThNFn9mhIDV4jDBOxJ4=;
 b=cX9OvtSSUPl2VjlUMxN9wkJTxjF4VMryEK2+74/Jcp2+VxH/7zdJAOksUNssIxTm51
 zg9bgDUDeJ1da0Q996JdsUZgJPySpalntdnf95UOKKDwkbLVqfZrmNUqAsJxl8FWHMCo
 iy42JdAmC96Wf8DLM5Sr75akb1KR+vn97tncFrPZBcvjFGsoCr31lDbd1B+K+87hjvvn
 J6OXoKWzFDZwo6PVBpAVoy279lQ0QJaFjVIq0qJgY5lAWSUvA0Y+b8aCIhtTQTKtfXNx
 h4SjEkvduYcq4V2JhT/HRFFC/rhUGSGHW5+soZiuFIjG+etlAVkEl6tT5ICKi8K/z2Ab
 cL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Q5puRTi/aBwHreExscKf/w+BThNFn9mhIDV4jDBOxJ4=;
 b=L92cTZY/RzyohE9AmYO9xU89hoVDH4j2IBjKdqcFPCtT/Nl7GdJIKc42qoV6SJXfjI
 gZ2XkHxoO2GyyTA/N7j5nQKBv1fkVTDV9/FrpCXQJVwjVum9PPRUl+Cm44WODgnGKa6J
 gzaPEB30mEe7ZjzrgWBDYgnVxmQ6VgBwvMa/Uz5MPrbJHccl2sTSioimrjNhOE+HevFi
 Ei9b0osuYL7KCFCGb2kXNr4nqTuss2We/axpdFWnHwsha9zG5i1AbNtPTcmkQiWucrxg
 MGVWeCuVfN42tHvWuA9G/2FT3UnlYjAXvmpNXkJ8yZhsfh+YwPVEm2QDO7CQCFxCe0oO
 yDqw==
X-Gm-Message-State: ANoB5plH0GGh6uTb1E5fCA6uw6PanaX4xCrjAromwI4woDBW6GFMv/DY
 TskedHHw3+f4CvtzGM8IHrvpOg==
X-Google-Smtp-Source: AA0mqf4PMHJopL+j1/FAA6cNdu0WvhJE91YQY4pXO/EmIJ2pu66aV5lVRtcU7SIMWuMwfp4CKKKVmw==
X-Received: by 2002:adf:d22f:0:b0:242:1fb8:1ca9 with SMTP id
 k15-20020adfd22f000000b002421fb81ca9mr10116658wrh.37.1670925120065; 
 Tue, 13 Dec 2022 01:52:00 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76]) by smtp.gmail.com with ESMTPSA id
 y5-20020a5d4705000000b00241f029e672sm10620076wrq.107.2022.12.13.01.51.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Dec 2022 01:51:59 -0800 (PST)
Message-ID: <f32e0526-2c67-0962-52c8-27d02439fbc2@linaro.org>
Date: Tue, 13 Dec 2022 10:51:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 01/14] KVM: selftests: Define literal to asm constraint in
 aarch64 as unsigned long
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-2-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221213001653.3852042-2-seanjc@google.com>
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

T24gMTMvMTIvMjIgMDE6MTYsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4gRGVmaW5lIGEg
bGl0ZXJhbCAnMCcgYXNtIGlucHV0IGNvbnN0cmFpbnQgdG8gYWFyY2g2NC9wYWdlX2ZhdWx0X3Rl
c3Qncwo+IGd1ZXN0X2NhcygpIGFzIGFuIHVuc2lnbmVkIGxvbmcgdG8gbWFrZSBjbGFuZyBoYXBw
eS4KPiAKPiAgICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYWFyY2g2NC9wYWdlX2ZhdWx0
X3Rlc3QuYzoxMjA6MTY6IGVycm9yOgo+ICAgICAgdmFsdWUgc2l6ZSBkb2VzIG5vdCBtYXRjaCBy
ZWdpc3RlciBzaXplIHNwZWNpZmllZCBieSB0aGUgY29uc3RyYWludAo+ICAgICAgYW5kIG1vZGlm
aWVyIFstV2Vycm9yLC1XYXNtLW9wZXJhbmQtd2lkdGhzXQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgIDo6ICJyIiAoMCksICJyIiAoVEVTVF9EQVRBKSwgInIiIChndWVzdF90ZXN0X21lbW9yeSkp
Owo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXgo+ICAgIHRvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2t2bS9hYXJjaDY0L3BhZ2VfZmF1bHRfdGVzdC5jOjExOToxNTogbm90ZToKPiAg
ICAgIHVzZSBjb25zdHJhaW50IG1vZGlmaWVyICJ3Igo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICJjYXNhbCAlMCwgJTEsIFslMl1cbiIKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xn4KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJXcwCj4gCj4gRml4ZXM6IDM1YzU4
MTAxNTcxMiAoIktWTTogc2VsZnRlc3RzOiBhYXJjaDY0OiBBZGQgYWFyY2g2NC9wYWdlX2ZhdWx0
X3Rlc3QiKQo+IENjOiBSaWNhcmRvIEtvbGxlciA8cmljYXJrb2xAZ29vZ2xlLmNvbT4KPiBTaWdu
ZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4KPiAtLS0K
PiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3BhZ2VfZmF1bHRfdGVzdC5j
IHwgMiArLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
CgpSZXZpZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3Jn
PgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
