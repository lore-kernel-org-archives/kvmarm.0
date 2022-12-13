Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDD6C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 09:46:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1ED54B8D7;
	Tue, 13 Dec 2022 04:46:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JD5BhVDin-hC; Tue, 13 Dec 2022 04:46:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6A24B931;
	Tue, 13 Dec 2022 04:46:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C7E14B902
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 04:46:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id quzA9IfI4hml for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Dec 2022 04:46:22 -0500 (EST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42F734B8FB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 04:46:22 -0500 (EST)
Received: by mail-wr1-f53.google.com with SMTP id w15so14974337wrl.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 01:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=6HCpfsDxKsbRWDniMvTsAcm6k9bqzut02W2Q+dej5cA=;
 b=Ex6palua+CAb8sAnNRSs8QCJJYJy/CXh6vu8iuxELmuLYIDrF2/RExi4CYvGIwjJVb
 0Hw8S/7m4UBgKH+bGVe+zuk8w2F7mFhNNeHeX6LVfeyQY5x3cnou27cfkigKZrENvKBz
 LX8clCm2xYOgwgxlVTiZEEtbOr3jJ1dLVrGoE6s3UPIvxdMR9U2X4lxGEf6qw9kIOdYD
 K+ksfEaTBuwkypOmNmDFRZz5c/4gWAgs5j5mnkV4YFuQmGeJELWnGZ41hrzsIeZ+TXtt
 quGHmeCbmOcVfzAXWOBWrrgDYUWcXplwtQ/ZI6tst+MM7yleBo+Dyn7REujufWRh+W+H
 fTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=6HCpfsDxKsbRWDniMvTsAcm6k9bqzut02W2Q+dej5cA=;
 b=Lb/BmaGcOj1uodb2TLqZb3L2XIbUAYkkv8VqQwJznPp6vOosMoWVL17Xd0/vzX7JTI
 4lbd8mFR9G7r1ekkBx7ZZDAihVEcLRQUpAZw81IcIHSpsX9cpq3MjHGngN4vRdIe5+oc
 iZ7SzxanLpijfCK+QI2u5FQNQJcX7E03LuqqvIsA7t+NR/KdGpP2wv4e6LYiGHab79CH
 uYd9PP3HbQgUR6pkUqNBxWegyu898mUYoBG2YRGEb+XTG5+FofHIZOxZJmIPb5rBeQEe
 xzvJVAxRmqJcCLjbYmSO8Ff7ukyi5UqU6sqMUbuCNehYFB9Q7Pap0TbBU+Asr+4A5HUO
 xzwA==
X-Gm-Message-State: ANoB5pkTfRAUi6fOb/N1WpjQdp52mPnTjj2akSn3L73EEW2eIkMm5sL0
 edMQ7zs5INP4RshPKnw5w4j1Bw==
X-Google-Smtp-Source: AA0mqf62OayQR32aHZW7SQ2L2Smz6e0kOzvNE3xqgzO1KHXWbyXt8wEW/lnneYLd3l0I3gIKF9q7mQ==
X-Received: by 2002:a5d:5a19:0:b0:242:8177:6291 with SMTP id
 bq25-20020a5d5a19000000b0024281776291mr15276191wrb.1.1670924781185; 
 Tue, 13 Dec 2022 01:46:21 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76]) by smtp.gmail.com with ESMTPSA id
 j13-20020a5d618d000000b002422816aa25sm12963005wru.108.2022.12.13.01.46.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Dec 2022 01:46:20 -0800 (PST)
Message-ID: <84c81594-0106-536c-5e04-1afb24953727@linaro.org>
Date: Tue, 13 Dec 2022 10:46:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 03/14] KVM: selftests: Fix divide-by-zero bug in
 memslot_perf_test
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-4-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221213001653.3852042-4-seanjc@google.com>
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

T24gMTMvMTIvMjIgMDE6MTYsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4gQ2hlY2sgdGhh
dCB0aGUgbnVtYmVyIG9mIHBhZ2VzIHBlciBzbG90IGlzIG5vbi16ZXJvIGluIGdldF9tYXhfc2xv
dHMoKQo+IHByaW9yIHRvIGNvbXB1dGluZyB0aGUgcmVtYWluaW5nIG51bWJlciBvZiBwYWdlcy4g
IGNsYW5nIGdlbmVyYXRlcyBjb2RlCj4gdGhhdCB1c2VzIGFuIGFjdHVhbCBESVYgZm9yIGNhbGN1
bGF0aW5nIHRoZSByZW1haW5pbmcsIHdoaWNoIGNhdXNlcyBhICNERQo+IGlmIHRoZSB0b3RhbCBu
dW1iZXIgb2YgcGFnZXMgaXMgbGVzcyB0aGFuIHRoZSBudW1iZXIgb2Ygc2xvdHMuCj4gCj4gICAg
dHJhcHM6IG1lbXNsb3RfcGVyZl90ZVs5NzYxMV0gdHJhcCBkaXZpZGUgZXJyb3IgaXA6NDAzMGM0
IHNwOjdmZmQxOGFlNThmMAo+ICAgICAgICAgICBlcnJvcjowIGluIG1lbXNsb3RfcGVyZl90ZXN0
WzQwMTAwMCtjYjAwMF0KPiAKPiBGaXhlczogYTY5MTcwYzY1YWNkICgiS1ZNOiBzZWxmdGVzdHM6
IG1lbXNsb3RfcGVyZl90ZXN0OiBSZXBvcnQgb3B0aW1hbCBtZW1vcnkgc2xvdHMiKQo+IFNpZ25l
ZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPgo+IC0tLQo+
ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL21lbXNsb3RfcGVyZl90ZXN0LmMgfCAzICsr
Kwo+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKUmV2aWV3ZWQtYnk6IFBoaWxp
cHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4KCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
