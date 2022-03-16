Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDEBC43217
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 09:28:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FA049F5A;
	Thu, 17 Mar 2022 05:28:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xm6-ROqFTRvB; Thu, 17 Mar 2022 05:28:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3899149F5B;
	Thu, 17 Mar 2022 05:28:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D21649EC4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 17:44:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h1Bz6JH5M14J for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 17:44:34 -0400 (EDT)
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com
 [209.85.161.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8524449EC2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 17:44:34 -0400 (EDT)
Received: by mail-oo1-f54.google.com with SMTP id
 h16-20020a4a6f10000000b00320507b9ccfso4309407ooc.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 14:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=jaTnWfP5Ctwr90+tTsSeB1mPeSYn8clE+CkG+kehTNk=;
 b=I4xUDzI1RQ9uhmUTrNp9Zl9awT7HtuyhW42gT4zUQGO2cTzapPafEa21pW2fJjSJh6
 M/drMRkTXwYbNkaj5qy/FlNRZ5Wal9fzyfAv5mmZE2ufle/Nnf51tWlLZ6vApCGvmJ/b
 HQYvCayrrItYl4WZl+KlwNQdbE9TFlLbt9XdKw/zBmvw6XzOVWA/FL3QJSU5ptQbbz/J
 FBGKWI5meAce6LYi9WaOSqvYJNWhTOvnbZP0iIxV9LXiAd+oDHU6/FZIUtawnMbfPqNe
 4X9OqWGaDHdwpDxUymsjkc58xeoVpXwq0ru5BfsR/re+n0rvku5p7aDCw6V8AIDDshWr
 GkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=jaTnWfP5Ctwr90+tTsSeB1mPeSYn8clE+CkG+kehTNk=;
 b=4jJu6OGYuOkw1g85fe0bWJjs07CDhNPFdUAsKcZqE9SECBbzJmctQs0lmNG4L2zQwg
 zlH1pkQS1sDZ6ERq++OkODMv6R1dOQe44+AHoz1qQQBKN9rLaTx2xtyLN37u4Cd5X2WR
 kaVSpW6W4dxoXPhGfF10KRaVqlDr0KBq2hCECWibUxFX83z1HoEd7jk3SJgRbERWRr7j
 p2j2y++dCaF3j+oQHNNzVJ5kUDPcFYr2IyD12d0WIJdh68h3HD/iWSnmVqkUlYmiGG8k
 yoXbPwt9I5otRNFmIiRHvMr0KIyOASVNRVy7YDkdDo7gdtutL2yuBzEANXlmEkoTHM7B
 J1kg==
X-Gm-Message-State: AOAM530gjOue8u7hWlVw3uhtTBb2qd0+BKUfhckHbfqOh5IJ+KjucH7o
 +PTaYTSlYsmv7/ioRX2XTIuevA==
X-Google-Smtp-Source: ABdhPJyn2zMtJrrUWIhbSfg3xPJmr73k3HTxz5k9k2IpYSZgp00Taw6kZsoWEYPNqF8D9fjRROZaKQ==
X-Received: by 2002:a05:6870:9617:b0:d7:5d73:8545 with SMTP id
 d23-20020a056870961700b000d75d738545mr677058oaq.15.1647467073556; 
 Wed, 16 Mar 2022 14:44:33 -0700 (PDT)
Received: from localhost ([2804:14d:7e39:8470:b171:978c:2a42:8690])
 by smtp.gmail.com with ESMTPSA id
 a19-20020a056808099300b002da1428db03sm1441975oic.7.2022.03.16.14.44.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Mar 2022 14:44:33 -0700 (PDT)
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-12-broonie@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 11/40] arm64/sme: Identify supported SME vector
 lengths at boot
Date: Wed, 16 Mar 2022 18:32:47 -0300
In-reply-to: <20220225165923.1474372-12-broonie@kernel.org>
Message-ID: <8435jhd13g.fsf@linaro.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 17 Mar 2022 05:28:50 -0400
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CkhlbGxvLAoKSnVzdCBhIHNtYWxsIHN1Z2dlc3Rpb246CgpNYXJrIEJyb3duIDxicm9vbmllQGtl
cm5lbC5vcmc+IHdyaXRlczoKCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20v
Y3B1LmggYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2NwdS5oCj4gaW5kZXggZDA4MDYyYmNiOWMx
Li41NTBlMWZjNGFlNmMgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jcHUu
aAo+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1LmgKPiBAQCAtNjQsNiArNjQsOSBA
QCBzdHJ1Y3QgY3B1aW5mb19hcm02NCB7Cj4gIAo+ICAJLyogcHNldWRvLVpDUiBmb3IgcmVjb3Jk
aW5nIG1heGltdW0gWkNSX0VMMSBMRU4gdmFsdWU6ICovCj4gIAl1NjQJCXJlZ196Y3I7Cj4gKwo+
ICsJLyogcHNldWRvLVNNQ1IgZm9yIHJlY29yZGluZyBtYXhpbXVtIFpDUl9FTDEgTEVOIHZhbHVl
OiAqLwo+ICsJdTY0CQlyZWdfc21jcjsKPiAgfTsKClBlcmhhcHMgYXBwZW5kIOKAnHdoZW4gaW4g
c3RyZWFtaW5nIG1vZGXigJ0gdG8gdGhlIGNvbW1lbnQgYWJvdmUgKG9yIG1lbnRpb24Kc3RyZWFt
aW5nIG1vZGUgaW4gc29tZSBvdGhlciB3YXkpLCB0byBjb252ZXkgdGhlIGRpZmZlcmVuY2UgYmV0
d2VlbgpyZWdfc21jciBhbmQgcmVnX3pjcj8KCi0tIApUaGlhZ28KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
