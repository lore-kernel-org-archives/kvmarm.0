Return-Path: <SRS0=w8eh=K3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9003DC47080
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 21:51:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C024613B9
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 21:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C024613B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86D3149E8C;
	Tue,  1 Jun 2021 17:51:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aOZQGxwGaWC0; Tue,  1 Jun 2021 17:51:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52CF649FB0;
	Tue,  1 Jun 2021 17:51:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3E5949F82
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 17:51:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tyr04OGxGQiY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Jun 2021 17:51:25 -0400 (EDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52BE749E93
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 17:51:25 -0400 (EDT)
Received: by mail-wm1-f51.google.com with SMTP id
 l18-20020a1ced120000b029014c1adff1edso2474131wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Jun 2021 14:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=eEnFmGo+UZqq9usDjM1VKElE9vmoR0P36JtXIWuNBME=;
 b=zLN3ODyt+z+dh7cCItJooplLlyn6/+d455ILyy98nrCpsg2UcVN5IPIShVd2buvODK
 q/Aq9XD97xHJEpMvxZ1oNVZwLgxiFAEk3x+LV7G56ygvllQak9fBw6yas11//76bHLFN
 +vY6O4pHFU6FZdKfUX47qd/46xrAzthLWEwKqDpqyY+hg424pn1aJyiOcmZEzYa6inC6
 bs2tr314Tjm2o1ZTr6g1w/8gI6d7rPtEbYxo8DnvQ6aInpY8VSx0WJE3uiZppucnpv1D
 pQK1S2qT6VDS2dLAJRMXsgBUmzwBf7sq72Ov9CLcKUZl3bYaYY9k45F2GRp0kwIlQgrb
 gC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=eEnFmGo+UZqq9usDjM1VKElE9vmoR0P36JtXIWuNBME=;
 b=JiHveeSpWvk58MvVse5VuCTb0W9Eboaf3AKp/nE+xZ/GrTFYuwXLAsm0MNWFrItJpA
 At2jesQL7x/FlLhBwGRnq8GOS/dAyfXChSH6/ZkAJilZ8Jca6Vk+WXs0fJVr1vpFwGLE
 2vzTbf1E3oog/F/XDgg+cWU67GZUz0LNAdFUnXixAHIo8TcM7hlzej2RwIktrXDe/BWg
 ZFAN4vNhWmDHym8c+MabU1xyt3hH+MqAyEFqGV3O5EFEGNX/6ynB+1EmCKnMS3nDjw3Y
 RCcl/kg2wUfBjbl9fn4e5ovVBocCx8b7Bzz0FvRMkSexLJDbz1L1E9FQ46TlTV76QE5b
 fx5A==
X-Gm-Message-State: AOAM532sEfTGddUYlWacuc7Auf22x0U1+ds6eYr/wv3QhehcTAoDou3s
 T7Yuv7P76TdC/LzCITFzlyoYmw==
X-Google-Smtp-Source: ABdhPJy+O/9yUXByk5CtPEKI69bRLs831YKZ/VATXi6NUYp3immwAkZ80g7J3CvcHwxl1kHruVDz2w==
X-Received: by 2002:a7b:c4d0:: with SMTP id g16mr1811216wmk.147.1622584284192; 
 Tue, 01 Jun 2021 14:51:24 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id z10sm71291wmb.26.2021.06.01.14.51.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Jun 2021 14:51:23 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 7DD671FF7E;
 Tue,  1 Jun 2021 22:51:22 +0100 (BST)
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-5-alex.bennee@linaro.org>
 <5fe1c796-c886-e5c6-6e61-e12d0f73a884@redhat.com>
 <87sg21bk7r.fsf@linaro.org> <20210601194648.fdymtxiz6lkxycsx@gator.home>
User-agent: mu4e 1.5.13; emacs 28.0.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/4] arm64: split
 its-migrate-unmapped-collection into KVM and TCG variants
Date: Tue, 01 Jun 2021 22:50:15 +0100
In-reply-to: <20210601194648.fdymtxiz6lkxycsx@gator.home>
Message-ID: <87pmx5b6ed.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
 qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

CkFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IE9uIFR1ZSwgSnVu
IDAxLCAyMDIxIGF0IDA1OjQ5OjAxUE0gKzAxMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gCj4+
IEF1Z2VyIEVyaWMgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4gd3JpdGVzOgo+PiAKPj4gPiBIaSBB
bGV4LAo+PiA+Cj4+ID4gT24gNS8yNS8yMSA3OjI2IFBNLCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4+
ID4+IFdoZW4gcnVubmluZyB0aGUgdGVzdCBpbiBUQ0cgd2UgYXJlIGJhc2ljYWxseSBydW5uaW5n
IG9uIGJhcmUgbWV0YWwgc28KPj4gPj4gZG9uJ3QgcmVseSBvbiBoYXZpbmcgYSBwYXJ0aWN1bGFy
IGtlcm5lbCBlcnJhdGEgYXBwbGllZC4KPj4gPj4gCj4+ID4+IFlvdSBtaWdodCB3b25kZXIgd2h5
IHdlIGhhbmRsZSB0aGlzIHdpdGggYSB0b3RhbGx5IG5ldyB0ZXN0IG5hbWUKPj4gPj4gaW5zdGVh
ZCBvZiBhZGp1c3RpbmcgdGhlIGFwcGVuZCB0byB0YWtlIGFuIGV4dHJhIHBhcmFtZXRlcj8gV2Vs
bCB0aGUKPj4gPj4gcnVuX21pZ3JhdGlvbiBzaGVsbCBzY3JpcHQgdXNlcyBldmFsICIkQCIgd2hp
Y2ggdW53cmFwcyB0aGUgLWFwcGVuZAo+PiA+PiBsZWFkaW5nIHRvIGFueSBzZWNvbmQgcGFyYW1l
dGVyIGJlaW5nIHNwbGl0IGFuZCBsZWF2aW5nIFFFTVUgdmVyeQo+PiA+PiBjb25mdXNlZCBhbmQg
dGhlIHRlc3QgaGFuZ2luZy4gVGhpcyBzZWVtZWQgc2ltcGxlciB0aGFuIHJlLXdyaXRpbmcgYWxs
Cj4+ID4+IHRoZSB0ZXN0IHJ1bm5pbmcgbG9naWMgaW4gc29tZXRoaW5nIHNhbmUgOy0pCj4+ID4K
Pj4gPiB0aGVyZSBpcwo+PiA+IGxpYi9zMzkweC92bS5oOmJvb2wgdm1faXNfdGNnKHZvaWQpCj4+
ID4KPj4gPiBidXQgSSBkb24ndCBzZWUgYW55IHBhcnRpY3VsYXIgSUQgd2UgY291bGQgdXNlIHRv
IGRpZmZlcmVudGlhdGUgYm90aCB0aGUKPj4gPiBLVk0gYW5kIHRoZSBUQ0cgbW9kZSwgZG8geW91
Pwo+PiAKPj4gRm9yIC1jcHUgbWF4IHdlIGRvOgo+PiAKPj4gICAgICAgICAvKgo+PiAgICAgICAg
ICAqIFJlc2V0IE1JRFIgc28gdGhlIGd1ZXN0IGRvZXNuJ3QgbWlzdGFrZSBvdXIgJ21heCcgQ1BV
IHR5cGUgZm9yIGEgcmVhbAo+PiAgICAgICAgICAqIG9uZSBhbmQgdHJ5IHRvIGFwcGx5IGVycmF0
YSB3b3JrYXJvdW5kcyBvciB1c2UgaW1wZGVmIGZlYXR1cmVzIHdlCj4+ICAgICAgICAgICogZG9u
J3QgcHJvdmlkZS4KPj4gICAgICAgICAgKiBBbiBJTVBMRU1FTlRFUiBmaWVsZCBvZiAwIG1lYW5z
ICJyZXNlcnZlZCBmb3Igc29mdHdhcmUgdXNlIjsKPj4gICAgICAgICAgKiBBUkNISVRFQ1RVUkUg
bXVzdCBiZSAweGYgaW5kaWNhdGluZyAidjcgb3IgbGF0ZXIsIGNoZWNrIElEIHJlZ2lzdGVycwo+
PiAgICAgICAgICAqIHRvIHNlZSB3aGljaCBmZWF0dXJlcyBhcmUgcHJlc2VudCI7Cj4+ICAgICAg
ICAgICogdGhlIFZBUklBTlQsIFBBUlROVU0gYW5kIFJFVklTSU9OIGZpZWxkcyBhcmUgYWxsIGlt
cGxlbWVudGF0aW9uCj4+ICAgICAgICAgICogZGVmaW5lZCBhbmQgd2UgY2hvb3NlIHRvIGRlZmlu
ZSBQQVJUTlVNIGp1c3QgaW4gY2FzZSBndWVzdAo+PiAgICAgICAgICAqIGNvZGUgbmVlZHMgdG8g
ZGlzdGluZ3Vpc2ggdGhpcyBRRU1VIENQVSBmcm9tIG90aGVyIHNvZnR3YXJlCj4+ICAgICAgICAg
ICogaW1wbGVtZW50YXRpb25zLCB0aG91Z2ggdGhpcyBzaG91bGRuJ3QgYmUgbmVlZGVkLgo+PiAg
ICAgICAgICAqLwo+PiAgICAgICAgIHQgPSBGSUVMRF9EUDY0KDAsIE1JRFJfRUwxLCBJTVBMRU1F
TlRFUiwgMCk7Cj4+ICAgICAgICAgdCA9IEZJRUxEX0RQNjQodCwgTUlEUl9FTDEsIEFSQ0hJVEVD
VFVSRSwgMHhmKTsKPj4gICAgICAgICB0ID0gRklFTERfRFA2NCh0LCBNSURSX0VMMSwgUEFSVE5V
TSwgJ1EnKTsKPj4gICAgICAgICB0ID0gRklFTERfRFA2NCh0LCBNSURSX0VMMSwgVkFSSUFOVCwg
MCk7Cj4+ICAgICAgICAgdCA9IEZJRUxEX0RQNjQodCwgTUlEUl9FTDEsIFJFVklTSU9OLCAwKTsK
Pj4gICAgICAgICBjcHUtPm1pZHIgPSB0Owo+PiAKPj4gSG93ZXZlciBmb3IgdGhlIGRlZmF1bHQg
LWNwdSBjb3J0ZXgtYTU3IHdlIGFpbSB0byBsb29rIGp1c3QgbGlrZSB0aGUKPj4gcmVhbCB0aGlu
ZyAtIG9ubHkgd2l0aG91dCBhbnkgYW5ub3lpbmcgbWljcm8tYXJjaGl0ZWN0dXJlIGJ1Z3MgOy0p
Cj4+IAo+PiA+Cj4+ID4gd2l0aG91dCBhIG1vcmUgZWxlZ2FudCBzb2x1dGlvbiwKPj4gCj4+IEkn
bGwgbG9vayBpbnRvIHRoZSBzdWdnZXN0aW9uIG1hZGUgYnkgUmljaGFyZC4KPgo+IFdoZXJlIGRp
ZCBSaWNoYXJkIG1ha2UgYSBzdWdnZXN0aW9uPyBBbmQgd2hhdCBpcyBpdD8KClNvcnJ5IC0gSSBo
YWQgYSBicmFpbiBmYXJ0LCBJIHdhcyBvZiBjb3Vyc2UgcmVmZXJyaW5nIHRvIHlvdXIKRVJSQVRB
X0ZPUkNFIHN1Z2dlc3Rpb24uCgo+Cj4gVGhhbmtzLAo+IGRyZXcKPgo+PiAKPj4gPiBSZXZpZXdl
ZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+PiA+Cj4+ID4gVGhhbmtz
Cj4+ID4KPj4gPiBFcmljCj4+ID4KPj4gPgo+PiA+PiAKPj4gPj4gU2lnbmVkLW9mZi1ieTogQWxl
eCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgo+PiA+PiBDYzogU2hhc2hpIE1hbGxl
bGEgPHNoYXNoaS5tYWxsZWxhQGxpbmFyby5vcmc+Cj4+ID4+IC0tLQo+PiA+PiAgYXJtL2dpYy5j
ICAgICAgICAgfCAgOCArKysrKysrLQo+PiA+PiAgYXJtL3VuaXR0ZXN0cy5jZmcgfCAxMCArKysr
KysrKystCj4+ID4+ICAyIGZpbGVzIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCj4+ID4+IAo+PiA+PiBkaWZmIC0tZ2l0IGEvYXJtL2dpYy5jIGIvYXJtL2dpYy5jCj4+
ID4+IGluZGV4IGJlZjA2MWEuLjBmY2UyYTQgMTAwNjQ0Cj4+ID4+IC0tLSBhL2FybS9naWMuYwo+
PiA+PiArKysgYi9hcm0vZ2ljLmMKPj4gPj4gQEAgLTM2LDYgKzM2LDcgQEAgc3RhdGljIHN0cnVj
dCBnaWMgKmdpYzsKPj4gPj4gIHN0YXRpYyBpbnQgYWNrZWRbTlJfQ1BVU10sIHNwdXJpb3VzW05S
X0NQVVNdOwo+PiA+PiAgc3RhdGljIGludCBpcnFfc2VuZGVyW05SX0NQVVNdLCBpcnFfbnVtYmVy
W05SX0NQVVNdOwo+PiA+PiAgc3RhdGljIGNwdW1hc2tfdCByZWFkeTsKPj4gPj4gK3N0YXRpYyBi
b29sIHVuZGVyX3RjZzsKPj4gPj4gIAo+PiA+PiAgc3RhdGljIHZvaWQgbnJfY3B1X2NoZWNrKGlu
dCBucikKPj4gPj4gIHsKPj4gPj4gQEAgLTgzNCw3ICs4MzUsNyBAQCBzdGF0aWMgdm9pZCB0ZXN0
X21pZ3JhdGVfdW5tYXBwZWRfY29sbGVjdGlvbih2b2lkKQo+PiA+PiAgCQlnb3RvIGRvX21pZ3Jh
dGU7Cj4+ID4+ICAJfQo+PiA+PiAgCj4+ID4+IC0JaWYgKCFlcnJhdGEoRVJSQVRBX1VOTUFQUEVE
X0NPTExFQ1RJT05TKSkgewo+PiA+PiArCWlmICghZXJyYXRhKEVSUkFUQV9VTk1BUFBFRF9DT0xM
RUNUSU9OUykgJiYgIXVuZGVyX3RjZykgewo+PiA+PiAgCQlyZXBvcnRfc2tpcCgiU2tpcHBpbmcg
dGVzdCwgYXMgdGhpcyB0ZXN0IGhhbmdzIHdpdGhvdXQgdGhlIGZpeC4gIgo+PiA+PiAgCQkJICAg
ICJTZXQgJXM9eSB0byBlbmFibGUuIiwgRVJSQVRBX1VOTUFQUEVEX0NPTExFQ1RJT05TKTsKPj4g
Pj4gIAkJdGVzdF9za2lwcGVkID0gdHJ1ZTsKPj4gPj4gQEAgLTEwMDUsNiArMTAwNiwxMSBAQCBp
bnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCj4+ID4+ICAJCXJlcG9ydF9wcmVmaXhfcHVz
aChhcmd2WzFdKTsKPj4gPj4gIAkJdGVzdF9taWdyYXRlX3VubWFwcGVkX2NvbGxlY3Rpb24oKTsK
Pj4gPj4gIAkJcmVwb3J0X3ByZWZpeF9wb3AoKTsKPj4gPj4gKwl9IGVsc2UgaWYgKCFzdHJjbXAo
YXJndlsxXSwgIml0cy1taWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb24tdGNnIikpIHsKPj4gPj4g
KwkJdW5kZXJfdGNnID0gdHJ1ZTsKPj4gPj4gKwkJcmVwb3J0X3ByZWZpeF9wdXNoKGFyZ3ZbMV0p
Owo+PiA+PiArCQl0ZXN0X21pZ3JhdGVfdW5tYXBwZWRfY29sbGVjdGlvbigpOwo+PiA+PiArCQly
ZXBvcnRfcHJlZml4X3BvcCgpOwo+PiA+PiAgCX0gZWxzZSBpZiAoc3RyY21wKGFyZ3ZbMV0sICJp
dHMtaW50cm9zcGVjdGlvbiIpID09IDApIHsKPj4gPj4gIAkJcmVwb3J0X3ByZWZpeF9wdXNoKGFy
Z3ZbMV0pOwo+PiA+PiAgCQl0ZXN0X2l0c19pbnRyb3NwZWN0aW9uKCk7Cj4+ID4+IGRpZmYgLS1n
aXQgYS9hcm0vdW5pdHRlc3RzLmNmZyBiL2FybS91bml0dGVzdHMuY2ZnCj4+ID4+IGluZGV4IDFh
Mzk0MjguLmFkYzFiYmYgMTAwNjQ0Cj4+ID4+IC0tLSBhL2FybS91bml0dGVzdHMuY2ZnCj4+ID4+
ICsrKyBiL2FybS91bml0dGVzdHMuY2ZnCj4+ID4+IEBAIC0yMDUsNyArMjA1LDcgQEAgZXh0cmFf
cGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZlcnNpb249MyAtYXBwZW5kICdpdHMtcGVuZGluZy1taWdy
YXRpb24nCj4+ID4+ICBncm91cHMgPSBpdHMgbWlncmF0aW9uCj4+ID4+ICBhcmNoID0gYXJtNjQK
Pj4gPj4gIAo+PiA+PiAtW2l0cy1taWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb25dCj4+ID4+ICtb
aXRzLW1pZ3JhdGUtdW5tYXBwZWQtY29sbGVjdGlvbi1rdm1dCj4+ID4+ICBmaWxlID0gZ2ljLmZs
YXQKPj4gPj4gIHNtcCA9ICRNQVhfU01QCj4+ID4+ICBhY2NlbCA9IGt2bQo+PiA+PiBAQCAtMjEz
LDYgKzIxMywxNCBAQCBleHRyYV9wYXJhbXMgPSAtbWFjaGluZSBnaWMtdmVyc2lvbj0zIC1hcHBl
bmQgJ2l0cy1taWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb24nCj4+ID4+ICBncm91cHMgPSBpdHMg
bWlncmF0aW9uCj4+ID4+ICBhcmNoID0gYXJtNjQKPj4gPj4gIAo+PiA+PiArW2l0cy1taWdyYXRl
LXVubWFwcGVkLWNvbGxlY3Rpb24tdGNnXQo+PiA+PiArZmlsZSA9IGdpYy5mbGF0Cj4+ID4+ICtz
bXAgPSAkTUFYX1NNUAo+PiA+PiArYWNjZWwgPSB0Y2cKPj4gPj4gK2V4dHJhX3BhcmFtcyA9IC1t
YWNoaW5lIGdpYy12ZXJzaW9uPTMgLWFwcGVuZCAnaXRzLW1pZ3JhdGUtdW5tYXBwZWQtY29sbGVj
dGlvbi10Y2cnCj4+ID4+ICtncm91cHMgPSBpdHMgbWlncmF0aW9uCj4+ID4+ICthcmNoID0gYXJt
NjQKPj4gPj4gKwo+PiA+PiAgIyBUZXN0IFBTQ0kgZW11bGF0aW9uCj4+ID4+ICBbcHNjaV0KPj4g
Pj4gIGZpbGUgPSBwc2NpLmZsYXQKPj4gPj4gCj4+IAo+PiAKPj4gLS0gCj4+IEFsZXggQmVubsOp
ZQo+PiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+PiBr
dm1hcm0gbWFpbGluZyBsaXN0Cj4+IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKPj4gaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0KCgotLSAK
QWxleCBCZW5uw6llCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
