Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83414C4332F
	for <kvmarm@archiver.kernel.org>; Mon,  2 Jan 2023 00:43:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A1F4B933;
	Sun,  1 Jan 2023 19:43:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@ozlabs-ru.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7KuV0IQLUJRW; Sun,  1 Jan 2023 19:43:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A4E4B926;
	Sun,  1 Jan 2023 19:43:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1BAC4B926
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Jan 2023 19:43:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pFC9USMdLC-L for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 Jan 2023 19:43:48 -0500 (EST)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CF684B918
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Jan 2023 19:43:48 -0500 (EST)
Received: by mail-pl1-f182.google.com with SMTP id n4so28071900plp.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 01 Jan 2023 16:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=F4QoSb/fWOPAg1k5IeIPrqcXyDvMYgELY/nQCzCaUW8=;
 b=eJCM1tGrNRNxUZMWE16lv0C43iH8oRjPiOFPEamdTYzMDfga5XZEd5nmaHr7jaf5NW
 s36laxaSoVzQlwOOkJ5mVEopFkkwEeR8t33XG9/opwTCRRdF64XKl8irzjtvfBjZt1zL
 MJYVBgnA10x8/iIWTZzoMvT1aYtGqsNtnliKTvTDPSlBLbM2ic+pdrXFn0fQsUEQfl+D
 KH9tUAPzqLjZb3TgzPzieK7AwVGuBTvDCN+zZzNoLxvzLxZBwDyOKz+IP79udYDapC3F
 Y8FM0az53iVf+SQHFnXOA7AVqLFjr2bT0SHdykl5DxmX3oZiDdaQwrrzUWaO/WWNJqzE
 dxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=F4QoSb/fWOPAg1k5IeIPrqcXyDvMYgELY/nQCzCaUW8=;
 b=ft4rYmKGSmrf16XBHI34dmDeNZ+iKDsRfHVNCuAN5UdFoNjQaEU2b12+zAc/uJWKBN
 +t3eU795m5+cQaJw6gRHjeA+LgJzRiJfKQXN6x83KW/DkcTDWA1LoK8Nqvh4g2xWSx87
 SemwDdhmMp/v/gpL/suZFNgPITsib4bhNMs8Z3+fQPN/1R9YDMwRD0A0mIpI/gOmPsUl
 A26bQheI+UTCftW7NEnPVdLD12jjrjSBTrCrv1j/uFyGliaqfVyePhtHIOaKDmXUiw04
 yFcaQUR/9tXBZFICO4XwiAakn0zlrtnVorOzBQUGJ35T7++WCHqZwP0wOfrz+rX8mEoI
 yHUg==
X-Gm-Message-State: AFqh2kr4yI6H2/jGlpe647DvsrCAEaWHzVJnx6ql5X9So5FzSRFS56GG
 mkiJ7ywNGVhFUQPLQsdXz7aBFA==
X-Google-Smtp-Source: AMrXdXuzvP/wwe5AzmqaqFsffygkIQ5oV5ALsfR8HbJvtvgLYjKM+6MTfu/2jdgg5Elbz4z4xDI7BA==
X-Received: by 2002:a17:90a:f309:b0:219:9e19:8259 with SMTP id
 ca9-20020a17090af30900b002199e198259mr42358873pjb.46.1672620227617; 
 Sun, 01 Jan 2023 16:43:47 -0800 (PST)
Received: from [192.168.10.153]
 (ppp118-208-188-115.cbr-trn-nor-bras39.tpg.internode.on.net.
 [118.208.188.115]) by smtp.gmail.com with ESMTPSA id
 u7-20020a17090a1d4700b00225bc0e5f19sm15834468pju.1.2023.01.01.16.43.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 01 Jan 2023 16:43:46 -0800 (PST)
Message-ID: <cea59fc2-1052-53fd-42b0-ac53f5699aa9@ozlabs.ru>
Date: Mon, 2 Jan 2023 11:43:40 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
Content-Language: en-US
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Paolo Bonzini <pbonzini@redhat.com>
References: <20221003235722.2085145-1-aik@ozlabs.ru>
 <7a790aa8-c643-1098-4d28-bd3b10399fcd@ozlabs.ru>
 <5178485f-60d8-0f16-558b-05207102a37e@ozlabs.ru>
In-Reply-To: <5178485f-60d8-0f16-558b-05207102a37e@ozlabs.ru>
Cc: kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

UGFvbG8sIHBpbmc/CgoKT24gMDYvMTIvMjAyMiAxNTozOSwgQWxleGV5IEthcmRhc2hldnNraXkg
d3JvdGU6Cj4gUGFvbG8sIHBpbmc/IDopCj4gCj4gCj4gT24gMjcvMTAvMjAyMiAxODozOCwgQWxl
eGV5IEthcmRhc2hldnNraXkgd3JvdGU6Cj4+IFBhb2xvLCBwaW5nPwo+Pgo+Pgo+PiBPbiAwNC8x
MC8yMDIyIDEwOjU3LCBBbGV4ZXkgS2FyZGFzaGV2c2tpeSB3cm90ZToKPj4+IFdoZW4gaW50cm9k
dWNlZCwgSVJRRkQgcmVzYW1wbGluZyB3b3JrZWQgb24gUE9XRVI4IHdpdGggWElDUy4gSG93ZXZl
cgo+Pj4gS1ZNIG9uIFBPV0VSOSBoYXMgbmV2ZXIgaW1wbGVtZW50ZWQgaXQgLSB0aGUgY29tcGF0
aWJpbGl0eSBtb2RlIGNvZGUKPj4+ICgiWElDUy1vbi1YSVZFIikgbWlzc2VzIHRoZSBrdm1fbm90
aWZ5X2Fja2VkX2lycSgpIGNhbGwgYW5kIHRoZSBuYXRpdmUKPj4+IFhJVkUgbW9kZSBkb2VzIG5v
dCBoYW5kbGUgSU5UeCBpbiBLVk0gYXQgYWxsLgo+Pj4KPj4+IFRoaXMgbW92ZWQgdGhlIGNhcGFi
aWxpdHkgc3VwcG9ydCBhZHZlcnRpc2luZyB0byBwbGF0Zm9ybXMgYW5kIHN0b3BzCj4+PiBhZHZl
cnRpc2luZyBpdCBvbiBYSVZFLCBpLmUuIFBPV0VSOSBhbmQgbGF0ZXIuCj4+Pgo+Pj4gVGhpcyBz
aG91bGQgY2F1c2Ugbm8gYmVoYXZpb3VyYWwgY2hhbmdlIGZvciBvdGhlciBhcmNoaXRlY3R1cmVz
Lgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhleSBLYXJkYXNoZXZza2l5IDxhaWtAb3psYWJz
LnJ1Pgo+Pj4gQWNrZWQtYnk6IE5pY2hvbGFzIFBpZ2dpbiA8bnBpZ2dpbkBnbWFpbC5jb20+Cj4+
PiBBY2tlZC1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPj4+IC0tLQo+Pj4gQ2hh
bmdlczoKPj4+IHY0Ogo+Pj4gKiByZW1vdmVkIGluY29ycmVjdCBjbGF1c2UgYWJvdXQgY2hhbmdp
bmcgYmVoYXZvaXIgb24gTUlQUyBhbmQgUklTQ1YKPj4+Cj4+PiB2MzoKPj4+ICogcmVtb3ZlZCBh
bGwgaWZkZWZlcnJ5Cj4+PiAqIHJlbW92ZWQgdGhlIGNhcGFiaWxpdHkgZm9yIE1JUFMgYW5kIFJJ
U0NWCj4+PiAqIGFkanVzdGVkIHRoZSBjb21taXQgbG9nIGFib3V0IE1JUFMgYW5kIFJJU0NWCj4+
Pgo+Pj4gdjI6Cj4+PiAqIHJlbW92ZWQgaWZkZWYgZm9yIEFSTTY0Lgo+Pj4gLS0tCj4+PiDCoCBh
cmNoL2FybTY0L2t2bS9hcm0uY8KgwqDCoMKgwqDCoCB8IDEgKwo+Pj4gwqAgYXJjaC9wb3dlcnBj
L2t2bS9wb3dlcnBjLmMgfCA2ICsrKysrKwo+Pj4gwqAgYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5j
wqDCoCB8IDEgKwo+Pj4gwqAgYXJjaC94ODYva3ZtL3g4Ni5jwqDCoMKgwqDCoMKgwqDCoCB8IDEg
Kwo+Pj4gwqAgdmlydC9rdm0va3ZtX21haW4uY8KgwqDCoMKgwqDCoMKgIHwgMSAtCj4+PiDCoCA1
IGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+Pj4KPj4+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9hcm0uYyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jCj4+
PiBpbmRleCAyZmYwZWY2MmFiYWQuLmQyZGFhNGQzNzViNSAxMDA2NDQKPj4+IC0tLSBhL2FyY2gv
YXJtNjQva3ZtL2FybS5jCj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS9hcm0uYwo+Pj4gQEAgLTIx
OCw2ICsyMTgsNyBAQCBpbnQga3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVuc2lvbihzdHJ1Y3Qga3Zt
ICprdm0sIAo+Pj4gbG9uZyBleHQpCj4+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9WQ1BVX0FU
VFJJQlVURVM6Cj4+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9QVFBfS1ZNOgo+Pj4gwqDCoMKg
wqDCoCBjYXNlIEtWTV9DQVBfQVJNX1NZU1RFTV9TVVNQRU5EOgo+Pj4gK8KgwqDCoCBjYXNlIEtW
TV9DQVBfSVJRRkRfUkVTQU1QTEU6Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgciA9IDE7Cj4+PiDC
oMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9TRVRf
R1VFU1RfREVCVUcyOgo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5j
IGIvYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMKPj4+IGluZGV4IGZiMTQ5MDc2MWM4Ny4uOTA4
Y2U4YmQ5MWM5IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMKPj4+
ICsrKyBiL2FyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jCj4+PiBAQCAtNTkzLDYgKzU5MywxMiBA
QCBpbnQga3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVuc2lvbihzdHJ1Y3Qga3ZtIAo+Pj4gKmt2bSwg
bG9uZyBleHQpCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+PiDCoCAjZW5kaWYKPj4+
ICsjaWZkZWYgQ09ORklHX0hBVkVfS1ZNX0lSUUZECj4+PiArwqDCoMKgIGNhc2UgS1ZNX0NBUF9J
UlFGRF9SRVNBTVBMRToKPj4+ICvCoMKgwqDCoMKgwqDCoCByID0gIXhpdmVfZW5hYmxlZCgpOwo+
Pj4gK8KgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4gKyNlbmRpZgo+Pj4gKwo+Pj4gwqDCoMKgwqDC
oCBjYXNlIEtWTV9DQVBfUFBDX0FMTE9DX0hUQUI6Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgciA9
IGh2X2VuYWJsZWQ7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+PiBkaWZmIC0tZ2l0
IGEvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jIGIvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jCj4+
PiBpbmRleCBlZGZkNGJiZDBjYmEuLjc1MjFhZGFkYjgxYiAxMDA2NDQKPj4+IC0tLSBhL2FyY2gv
czM5MC9rdm0va3ZtLXMzOTAuYwo+Pj4gKysrIGIvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jCj4+
PiBAQCAtNTc3LDYgKzU3Nyw3IEBAIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKHN0
cnVjdCBrdm0gKmt2bSwgCj4+PiBsb25nIGV4dCkKPj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQ
X1NFVF9HVUVTVF9ERUJVRzoKPj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1MzOTBfRElBRzMx
ODoKPj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1MzOTBfTUVNX09QX0VYVEVOU0lPTjoKPj4+
ICvCoMKgwqAgY2FzZSBLVk1fQ0FQX0lSUUZEX1JFU0FNUExFOgo+Pj4gwqDCoMKgwqDCoMKgwqDC
oMKgIHIgPSAxOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4gwqDCoMKgwqDCoCBj
YXNlIEtWTV9DQVBfU0VUX0dVRVNUX0RFQlVHMjoKPj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMKPj4+IGluZGV4IDQzYTZhN2VmYzZlYy4uMmQ2
YzVhOGZkZjE0IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jCj4+PiArKysgYi9h
cmNoL3g4Ni9rdm0veDg2LmMKPj4+IEBAIC00Mzk1LDYgKzQzOTUsNyBAQCBpbnQga3ZtX3ZtX2lv
Y3RsX2NoZWNrX2V4dGVuc2lvbihzdHJ1Y3Qga3ZtIAo+Pj4gKmt2bSwgbG9uZyBleHQpCj4+PiDC
oMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9WQVBJQzoKPj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQ
X0VOQUJMRV9DQVA6Cj4+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9WTV9ESVNBQkxFX05YX0hV
R0VfUEFHRVM6Cj4+PiArwqDCoMKgIGNhc2UgS1ZNX0NBUF9JUlFGRF9SRVNBTVBMRToKPj4+IMKg
wqDCoMKgwqDCoMKgwqDCoCByID0gMTsKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4+
IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX0VYSVRfSFlQRVJDQUxMOgo+Pj4gZGlmZiAtLWdpdCBh
L3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCj4+PiBpbmRleCA1ODRh
NWJhYjNhZjMuLjA1Y2Y5NDAxM2YwMiAxMDA2NDQKPj4+IC0tLSBhL3ZpcnQva3ZtL2t2bV9tYWlu
LmMKPj4+ICsrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMKPj4+IEBAIC00NDQ3LDcgKzQ0NDcsNiBA
QCBzdGF0aWMgbG9uZyAKPj4+IGt2bV92bV9pb2N0bF9jaGVja19leHRlbnNpb25fZ2VuZXJpYyhz
dHJ1Y3Qga3ZtICprdm0sIGxvbmcgYXJnKQo+Pj4gwqAgI2VuZGlmCj4+PiDCoCAjaWZkZWYgQ09O
RklHX0hBVkVfS1ZNX0lSUUZECj4+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9JUlFGRDoKPj4+
IC3CoMKgwqAgY2FzZSBLVk1fQ0FQX0lSUUZEX1JFU0FNUExFOgo+Pj4gwqAgI2VuZGlmCj4+PiDC
oMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9JT0VWRU5URkRfQU5ZX0xFTkdUSDoKPj4+IMKgwqDCoMKg
wqAgY2FzZSBLVk1fQ0FQX0NIRUNLX0VYVEVOU0lPTl9WTToKPj4KPiAKCi0tIApBbGV4ZXkKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
