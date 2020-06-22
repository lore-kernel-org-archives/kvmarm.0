Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9E3C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:39:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5630206F1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:39:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="BYWy1U3L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5630206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39B6C4B0DB;
	Mon, 22 Jun 2020 06:39:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S8I79syxz5BE; Mon, 22 Jun 2020 06:39:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19D2D4AEE2;
	Mon, 22 Jun 2020 06:39:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AE184AEE2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:39:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nQlR71sGogWH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 06:39:39 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F4E14AEDC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:39:39 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id t194so15200010wmt.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 03:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=Lb/frQrugPlke769VI0ZGjO7llYS1ocNVbXaMbRE4lg=;
 b=BYWy1U3LTb7z1OQDvwZvSosKr1sv3gduL754zzevWWN7Ns1D38AkKsd8PAjr7ruqJP
 6N36GAb4b+1ZsqTjT9BGrE7KWe6iP5ifH6s3842R+A+9WxhZ5pnuVruniORrL3BAEAvk
 mj6HXKQ45TrrgkqBKLaFqO9x73kt+C/ulCuNRcQn12CJEOApO9pxx5gXJTgGdy5WmY3k
 a8Gs3FP1mmk0BhmfR8zcCbQlZYkEfdhv+D7gyjFiwPjkiCCnfwW7vEH89P5um6fgfwXT
 9IXfqrX+ZNUkFtXTxkzsHQX7s85JjnoMpwb2Wm1HTIu6XaDeTOsltX4wJIEfDxHr/NIk
 +7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=Lb/frQrugPlke769VI0ZGjO7llYS1ocNVbXaMbRE4lg=;
 b=sKsBMkGxK4pgd6qeKx4QQzSLdZQ5qy7dBn0azybwZDGaOSSXzInd1jffDp5TxGpNL/
 m1u8qYi5ehc/Or85jM0kkmmW/GGfkbHAF00McjOPy1tv+Tycj+mcfsErZWIz5GPmeiil
 Y0PHddovuaexacg/MV6xIBEGytAyQyrzkgOOdynBgO+Us3/PcdtJaTVBME+I+b2QslcM
 iKONZQizmvtBzr+Dfh5BTJp98/rbpgFyAOVLEiWShm+M8Rr5mvk3tNaDiP2aRWPHRZoN
 7xmx3OFMf/Gnm8wkRaEcOXGM7n2PHiyrcU6oT4BOwCFi4ldUOjeluELPtT5MCvrqvEEU
 Ewew==
X-Gm-Message-State: AOAM533R9dpbtb9ekcfnsT53cuyGIsGwQ3FZzLSWcK+tdIcSqpnpGXaf
 GJPLsIKunkPFU8B7DT8QS5/t+Q==
X-Google-Smtp-Source: ABdhPJw4ly1lF7pDB7TqBfR669amiQoWOkVZzba+2H5Qih6YqqlqJd9J1Sg6mf6Q9ECAf2qRBMfBMw==
X-Received: by 2002:a1c:6408:: with SMTP id y8mr9774703wmb.122.1592822378088; 
 Mon, 22 Jun 2020 03:39:38 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id 65sm12666681wre.6.2020.06.22.03.39.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 Jun 2020 03:39:37 -0700 (PDT)
Date: Mon, 22 Jun 2020 11:39:32 +0100
From: Andrew Scull <ascull@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Message-ID: <20200622103932.GA178085@google.com>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
 <20200622091508.GB88608@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200622091508.GB88608@C02TD0UTHF1T.local>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

T24gTW9uLCBKdW4gMjIsIDIwMjAgYXQgMTA6MTU6MDhBTSArMDEwMCwgTWFyayBSdXRsYW5kIHdy
b3RlOgo+IE9uIE1vbiwgSnVuIDIyLCAyMDIwIGF0IDA5OjA2OjQzQU0gKzAxMDAsIE1hcmMgWnlu
Z2llciB3cm90ZToKCgo+ID4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fcHRyYXV0
aC5oCj4gPiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9wdHJhdXRoLmgKPiA+IEBA
IC02MSw0NCArNjEsMzYgQEAKPiA+ICAKPiA+ICAvKgo+ID4gICAqIEJvdGggcHRyYXV0aF9zd2l0
Y2hfdG9fZ3Vlc3QgYW5kIHB0cmF1dGhfc3dpdGNoX3RvX2hvc3QgbWFjcm9zIHdpbGwKPiA+IC0g
KiBjaGVjayBmb3IgdGhlIHByZXNlbmNlIG9mIG9uZSBvZiB0aGUgY3B1ZmVhdHVyZSBmbGFnCj4g
PiAtICogQVJNNjRfSEFTX0FERFJFU1NfQVVUSF9BUkNIIG9yIEFSTTY0X0hBU19BRERSRVNTX0FV
VEhfSU1QX0RFRiBhbmQKPiA+ICsgKiBjaGVjayBmb3IgdGhlIHByZXNlbmNlIEFSTTY0X0hBU19B
RERSRVNTX0FVVEgsIHdoaWNoIGlzIGRlZmluZWQgYXMKPiA+ICsgKiAoQVJNNjRfSEFTX0FERFJF
U1NfQVVUSF9BUkNIIHx8IEFSTTY0X0hBU19BRERSRVNTX0FVVEhfSU1QX0RFRikgYW5kCj4gPiAg
ICogdGhlbiBwcm9jZWVkIGFoZWFkIHdpdGggdGhlIHNhdmUvcmVzdG9yZSBvZiBQb2ludGVyIEF1
dGhlbnRpY2F0aW9uCj4gPiAtICoga2V5IHJlZ2lzdGVycy4KPiA+ICsgKiBrZXkgcmVnaXN0ZXJz
IGlmIGVuYWJsZWQgZm9yIHRoZSBndWVzdC4KPiA+ICAgKi8KPiA+ICAubWFjcm8gcHRyYXV0aF9z
d2l0Y2hfdG9fZ3Vlc3QgZ19jdHh0LCByZWcxLCByZWcyLCByZWczCj4gPiAtYWx0ZXJuYXRpdmVf
aWYgQVJNNjRfSEFTX0FERFJFU1NfQVVUSF9BUkNICj4gPiArYWx0ZXJuYXRpdmVfaWZfbm90IEFS
TTY0X0hBU19BRERSRVNTX0FVVEgKPiA+ICAJYgkxMDAwZgo+ID4gIGFsdGVybmF0aXZlX2Vsc2Vf
bm9wX2VuZGlmCj4gPiAtYWx0ZXJuYXRpdmVfaWZfbm90IEFSTTY0X0hBU19BRERSRVNTX0FVVEhf
SU1QX0RFRgo+ID4gLQliCTEwMDFmCj4gPiAtYWx0ZXJuYXRpdmVfZWxzZV9ub3BfZW5kaWYKPiA+
IC0xMDAwOgo+ID4gIAltcnMJXHJlZzEsIGhjcl9lbDIKPiA+ICAJYW5kCVxyZWcxLCBccmVnMSwg
IyhIQ1JfQVBJIHwgSENSX0FQSykKPiA+IC0JY2J6CVxyZWcxLCAxMDAxZgo+ID4gKwljYnoJXHJl
ZzEsIDEwMDBmCj4gPiAgCWFkZAlccmVnMSwgXGdfY3R4dCwgI0NQVV9BUElBS0VZTE9fRUwxCj4g
PiAgCXB0cmF1dGhfcmVzdG9yZV9zdGF0ZQlccmVnMSwgXHJlZzIsIFxyZWczCj4gPiAtMTAwMToK
PiA+ICsxMDAwOgo+ID4gIC5lbmRtCj4gCj4gU2luY2UgdGhlc2UgYXJlIGluIG1hY3Jvcywgd2Ug
Y291bGQgdXNlIFxAIHRvIGdlbmVyYXRlIGEgbWFjcm8tc3BlY2lmaWMKPiBsYXZlbCByYXRoZXIg
dGhhbiBhIG1hZ2ljIG51bWJlciwgd2hpY2ggd291bGQgYmUgbGVzcyBsaWtlbHkgdG8gY29uZmxp
Y3QKPiB3aXRoIHRoZSBzdXJyb3VuZGluZyBlbnZpcm9ubWVudCBhbmQgd291bGQgYmUgbW9yZSBk
ZXNjcmlwdGl2ZS4gV2UgZG8KPiB0aGF0IGluIGEgZmV3IHBsYWNlcyBhbHJlYWR5LCBhbmQgaGVy
ZSBpdCBjb3VsZCBsb29rIHNvbWV0aGluZyBsaWtlOgo+IAo+IHwgYWx0ZXJuYXRpdmVfaWZfbm90
IEFSTTY0X0hBU19BRERSRVNTX0FVVEgKPiB8IAliCS5MX19za2lwX3BhdXRoX3N3aXRjaFxACj4g
fCBhbHRlcm5hdGl2ZV9lbHNlX25vcF9lbmRpZgo+IHwgCQo+IHwgCS4uLgo+IHwgCj4gfCAuTF9f
c2tpcF9wYXV0aF9zd2l0Y2hcQDoKPiAKPiBQZXIgdGhlIGdhcyBkb2N1bWVudGF0aW9uCj4gCj4g
fCBcQAo+IHwKPiB8ICAgIGFzIG1haW50YWlucyBhIGNvdW50ZXIgb2YgaG93IG1hbnkgbWFjcm9z
IGl0IGhhcyBleGVjdXRlZCBpbiB0aGlzCj4gfCAgICBwc2V1ZG8tdmFyaWFibGU7IHlvdSBjYW4g
Y29weSB0aGF0IG51bWJlciB0byB5b3VyIG91dHB1dCB3aXRoIOKAmFxA4oCZLAo+IHwgICAgYnV0
IG9ubHkgd2l0aGluIGEgbWFjcm8gZGVmaW5pdGlvbi4KCklzIHRoaXMgcmVsaWJhbGUgZm9yIHRo
aXMgc29ydCBvZiBhcHBsaWNhdGlvbj8gVGhlIGRlc2NyaXB0aW9uIGp1c3QKc291bmRzIGxpa2Ug
YSBjb3VudGVyIG9mIG1hY3JvcyByYXRoZXIgdGhhbiBzcGVjaWZpY2FsbHkgYSB1bmlxdWUgbGFi
ZWwKZ2VuZXJhdG9yLiBJdCBtYXkgd29yayBtb3N0IG9mIHRoZSB0aW1lIGJ1dCBhbHNvIHNlZW1z
IHRoYXQgaXQgaGFzIHRoZQpwb3RlbnRpYWwgdG8gYmUgbW9yZSBmcmFnaWxlIGdpdmVuIHRoYXQg
aXQgd291bGQgY2hhbmdlIGJhc2VkIG9uIHRoZQpyZXN0IG9mIHRoZSBjb2RlIGluIHRoZSBmaWxl
IHRvIHBvdGVudGlhbGx5IGNvbmZsaWN0IHdpdGggc29tZXRoaW5nIGl0CmRpZG4ndCBwcmV2aW91
c2x5IGNvbmZsaWN0IHdpdGguIApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
