Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D12C04FDE
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 09:47:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFFEF4B93C;
	Tue, 13 Dec 2022 04:47:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7ISDpqKPzMFf; Tue, 13 Dec 2022 04:47:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E8974B921;
	Tue, 13 Dec 2022 04:47:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24C974B902
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 04:47:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UYovbhIBcz8z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Dec 2022 04:47:27 -0500 (EST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D910540439
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 04:47:26 -0500 (EST)
Received: by mail-wm1-f42.google.com with SMTP id
 o5-20020a05600c510500b003d21f02fbaaso601648wms.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 01:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=VUffeOkZJV6CbBOjXRvBE9aKOOUHPUai9QNqwF2Rw6k=;
 b=s1JH0apqKbSMIxIiwVTiEGvWlt6voHGA0Qg93k6bu0bo94Xy2pc1rgrx+aKZpEtkx6
 tAkY+DS3eAY/MbbRYxforucS9NjS3Y/J+tyLt2y4zma1TERO/0grq5KMq0vq/JPyZFBz
 uuzCElIdsA0WjdkodayUEVOjRvLIQMBQqZyE+ugj5nJLcFiHRq0Adeoz1JxR/vw5valn
 M6ePXoLF+ntrgyqEb+FWCTpZ/Y72s2I7CfUH8aDCBnPG2ygVESeMtHM7BOVqZvMx+DrN
 +34OyPj6HJPDo1O1oBSY+duAkwoi2k2YHG0FzskbkMhvLtYA4PBVWcLfgYnkAWBL9chR
 D2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=VUffeOkZJV6CbBOjXRvBE9aKOOUHPUai9QNqwF2Rw6k=;
 b=U9W3L/7h+oX9wnENStUv+iHap+96WmZIBKQyvO4i8kiCxutffeJSHZ05cH/eXs0J8V
 8DTXhGFhqzWlfq/ELPY9V5BygC8gBpc9OdOpNyZ343m4o2nVfvCAZXebkitf0A7YLQaa
 Mcw1bNCVmg5gAZcyhfCe89fgRYoPGTDWu5ssVAhsMoLs1fuGqJAuTX0yG9UpiLSWhNy9
 UBBOGRoBVlcTCBzkXG3/vK7CI1xV+Aaa9T1uXazXEbjv/m0dU3fMQbobI8kUVn6wtLRL
 POAMT95mCSO8SnlSOSXLUDd+yOwL61Fiqh6X6oAMJS2XoBNDNVTMe9ErjhfMhs1Pzm+v
 olqg==
X-Gm-Message-State: ANoB5pkfXqIBrbu2YT2fHRXWcmkgf1EtuFLUL79o7E74Me2CQVnzSMH9
 OP1Td7N9lMSxDkqbPe9GnBC+eQ==
X-Google-Smtp-Source: AA0mqf45B8663eyuUa7gYYZoZljx5xDAypBaIEMtrhbpuNigeolIoqaS3rVH+IjTq+i8TltLJF+66w==
X-Received: by 2002:a05:600c:a54:b0:3cf:a41d:844b with SMTP id
 c20-20020a05600c0a5400b003cfa41d844bmr15253803wmq.5.1670924845957; 
 Tue, 13 Dec 2022 01:47:25 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76]) by smtp.gmail.com with ESMTPSA id
 ay13-20020a05600c1e0d00b003c6bd91caa5sm12602817wmb.17.2022.12.13.01.47.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Dec 2022 01:47:25 -0800 (PST)
Message-ID: <2505189d-c682-ed70-442b-798c258d3b68@linaro.org>
Date: Tue, 13 Dec 2022 10:47:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 05/14] KVM: selftests: Fix a typo in x86-64's
 kvm_get_cpu_address_width()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-6-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221213001653.3852042-6-seanjc@google.com>
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

T24gMTMvMTIvMjIgMDE6MTYsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4gRml4IGEgPT0g
dnMuID0gdHlwbyBpbiBrdm1fZ2V0X2NwdV9hZGRyZXNzX3dpZHRoKCkgdGhhdCByZXN1bHRzIGlu
Cj4gQHBhX2JpdHMgYmVpbmcgbGVmdCB1bnNldCBpZiB0aGUgQ1BVIGRvZXNuJ3Qgc3VwcG9ydCBl
bnVtZXJhdGluZyBpdHMKPiBNQVhfUEhZX0FERFIuICBGbGFnZ2VkIGJ5IGNsYW5nJ3MgdW51c3Vl
ZC12YWx1ZSB3YXJuaW5nLgo+IAo+IGxpYi94ODZfNjQvcHJvY2Vzc29yLmM6MTAzNDo1MTogd2Fy
bmluZzogZXhwcmVzc2lvbiByZXN1bHQgdW51c2VkIFstV3VudXNlZC12YWx1ZV0KPiAgICAgICAg
ICAgICAgICAgICpwYV9iaXRzID09IGt2bV9jcHVfaGFzKFg4Nl9GRUFUVVJFX1BBRSkgPyAzNiA6
IDMyOwo+IAo+IEZpeGVzOiAzYmQzOTYzNTNkMTggKCJLVk06IHNlbGZ0ZXN0czogQWRkIFg4Nl9G
RUFUVVJFX1BBRSBhbmQgdXNlIGl0IGNhbGMgImZhbGxiYWNrIiBNQVhQSFlBRERSIikKPiBTaWdu
ZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4KPiAtLS0K
PiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIveDg2XzY0L3Byb2Nlc3Nvci5jIHwg
MiArLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCj4g
Cj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIveDg2XzY0L3By
b2Nlc3Nvci5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2xpYi94ODZfNjQvcHJvY2Vz
c29yLmMKPiBpbmRleCBjNGQzNjhkNTZjZmUuLmFjZmExZDAxZTdkZiAxMDA2NDQKPiAtLS0gYS90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbGliL3g4Nl82NC9wcm9jZXNzb3IuYwo+ICsrKyBi
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIveDg2XzY0L3Byb2Nlc3Nvci5jCj4gQEAg
LTEwMzEsNyArMTAzMSw3IEBAIGJvb2wgaXNfYW1kX2NwdSh2b2lkKQo+ICAgdm9pZCBrdm1fZ2V0
X2NwdV9hZGRyZXNzX3dpZHRoKHVuc2lnbmVkIGludCAqcGFfYml0cywgdW5zaWduZWQgaW50ICp2
YV9iaXRzKQo+ICAgewo+ICAgCWlmICgha3ZtX2NwdV9oYXNfcChYODZfUFJPUEVSVFlfTUFYX1BI
WV9BRERSKSkgewo+IC0JCSpwYV9iaXRzID09IGt2bV9jcHVfaGFzKFg4Nl9GRUFUVVJFX1BBRSkg
PyAzNiA6IDMyOwo+ICsJCSpwYV9iaXRzID0ga3ZtX2NwdV9oYXMoWDg2X0ZFQVRVUkVfUEFFKSA/
IDM2IDogMzI7Cgo6KQoKUmV2aWV3ZWQtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGls
bWRAbGluYXJvLm9yZz4KCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
