Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563B9C352A1
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 04:39:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC14E4B293;
	Mon,  5 Dec 2022 23:39:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@ozlabs-ru.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5sAsBZuIYpiQ; Mon,  5 Dec 2022 23:39:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24DB24B2A3;
	Mon,  5 Dec 2022 23:39:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 734204B293
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 23:39:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GjhOhab0yWUi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2022 23:39:34 -0500 (EST)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 635134080A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 23:39:34 -0500 (EST)
Received: by mail-pg1-f173.google.com with SMTP id h193so12337586pgc.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Dec 2022 20:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=xqFAh2v1WFBzklz04TP/AWAU1Y1s3gtwJhYETzOXFDc=;
 b=RbDRgNiJz9xtr32BYRh+f8GcS3c0nxUbEPIp1hnX6CG4hrzfuOJBSUfbDecnbBnA6+
 P2DXhBTCnwrPQc01XtKp4mfVEKsMk5c1dOmUflMIjV0Tk/LpVkUb4/TATrApVk992Tc2
 DKeruPykkdLQnhLii4FgB28hUaVeQir2QI8vkSaHBvMH/bzf9N5P5K0tDCGHMb1Yjq2i
 CRj+iSeCv0HrSY+67Z14pGdgCMSMdAJbs64jcpKFzbdqnqTesMCy/i5hBV6QS9N1WOqG
 jIxBPQf0FAEICEWnOXwAJs1JduW2dlvTAiD1+oNly76DtPv1PeISuPRpGDSFDdWx522G
 YhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=xqFAh2v1WFBzklz04TP/AWAU1Y1s3gtwJhYETzOXFDc=;
 b=Xie3dRn6/7Lildk/RQuthjDEZxA6UoClXGT3jiz8vDLwVln3o51PoBFp8XM838BtbB
 nlrXj6mqu1RlY078dXFtD693WCmpu6jVTMczFVOyotJSALavU5lrFJrNISt6TSXBDatd
 PbBVmI/UOMvBZTGxauKxWfVLsA06n5IYvcJ+8mYjtE4sR62Ea6OmyjPXHCvvtP20QVVo
 1u6oZeEQ9INa/eKra5qVesNb4d9sGz9aw3U2L3G+OkqtManyMgkIKFAIzZgj4nuIC5+C
 Ji+jXW6UA/l4e5Z8sxRCJz6oQ8nCPodA6BFgDsAggQAgSx0dyWYooWu12akgtsj8bz4h
 HC7A==
X-Gm-Message-State: ANoB5pk+WKC7ZKFLstns45RrG2DmR8P17Ox9r3RfaLdmSS9IHHe4Z+Hb
 dPCbrLSanS5+EF6JGhqjWxwxhA==
X-Google-Smtp-Source: AA0mqf70H74bcqANnaDC/TsW/8gS3627MclHUagndhuJZ04rPP179n67SWk/SHm/c9P2dBIwhD9BFw==
X-Received: by 2002:a63:1609:0:b0:477:467f:3dc0 with SMTP id
 w9-20020a631609000000b00477467f3dc0mr56706765pgl.504.1670301573310; 
 Mon, 05 Dec 2022 20:39:33 -0800 (PST)
Received: from [192.168.10.153]
 (ppp121-45-204-168.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.204.168])
 by smtp.gmail.com with ESMTPSA id
 f14-20020a170902684e00b0018971fba556sm11410996pln.139.2022.12.05.20.39.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 05 Dec 2022 20:39:32 -0800 (PST)
Message-ID: <5178485f-60d8-0f16-558b-05207102a37e@ozlabs.ru>
Date: Tue, 6 Dec 2022 15:39:26 +1100
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
In-Reply-To: <7a790aa8-c643-1098-4d28-bd3b10399fcd@ozlabs.ru>
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

UGFvbG8sIHBpbmc/IDopCgoKT24gMjcvMTAvMjAyMiAxODozOCwgQWxleGV5IEthcmRhc2hldnNr
aXkgd3JvdGU6Cj4gUGFvbG8sIHBpbmc/Cj4gCj4gCj4gT24gMDQvMTAvMjAyMiAxMDo1NywgQWxl
eGV5IEthcmRhc2hldnNraXkgd3JvdGU6Cj4+IFdoZW4gaW50cm9kdWNlZCwgSVJRRkQgcmVzYW1w
bGluZyB3b3JrZWQgb24gUE9XRVI4IHdpdGggWElDUy4gSG93ZXZlcgo+PiBLVk0gb24gUE9XRVI5
IGhhcyBuZXZlciBpbXBsZW1lbnRlZCBpdCAtIHRoZSBjb21wYXRpYmlsaXR5IG1vZGUgY29kZQo+
PiAoIlhJQ1Mtb24tWElWRSIpIG1pc3NlcyB0aGUga3ZtX25vdGlmeV9hY2tlZF9pcnEoKSBjYWxs
IGFuZCB0aGUgbmF0aXZlCj4+IFhJVkUgbW9kZSBkb2VzIG5vdCBoYW5kbGUgSU5UeCBpbiBLVk0g
YXQgYWxsLgo+Pgo+PiBUaGlzIG1vdmVkIHRoZSBjYXBhYmlsaXR5IHN1cHBvcnQgYWR2ZXJ0aXNp
bmcgdG8gcGxhdGZvcm1zIGFuZCBzdG9wcwo+PiBhZHZlcnRpc2luZyBpdCBvbiBYSVZFLCBpLmUu
IFBPV0VSOSBhbmQgbGF0ZXIuCj4+Cj4+IFRoaXMgc2hvdWxkIGNhdXNlIG5vIGJlaGF2aW91cmFs
IGNoYW5nZSBmb3Igb3RoZXIgYXJjaGl0ZWN0dXJlcy4KPj4KPj4gU2lnbmVkLW9mZi1ieTogQWxl
eGV5IEthcmRhc2hldnNraXkgPGFpa0BvemxhYnMucnU+Cj4+IEFja2VkLWJ5OiBOaWNob2xhcyBQ
aWdnaW4gPG5waWdnaW5AZ21haWwuY29tPgo+PiBBY2tlZC1ieTogTWFyYyBaeW5naWVyIDxtYXpA
a2VybmVsLm9yZz4KPj4gLS0tCj4+IENoYW5nZXM6Cj4+IHY0Ogo+PiAqIHJlbW92ZWQgaW5jb3Jy
ZWN0IGNsYXVzZSBhYm91dCBjaGFuZ2luZyBiZWhhdm9pciBvbiBNSVBTIGFuZCBSSVNDVgo+Pgo+
PiB2MzoKPj4gKiByZW1vdmVkIGFsbCBpZmRlZmVycnkKPj4gKiByZW1vdmVkIHRoZSBjYXBhYmls
aXR5IGZvciBNSVBTIGFuZCBSSVNDVgo+PiAqIGFkanVzdGVkIHRoZSBjb21taXQgbG9nIGFib3V0
IE1JUFMgYW5kIFJJU0NWCj4+Cj4+IHYyOgo+PiAqIHJlbW92ZWQgaWZkZWYgZm9yIEFSTTY0Lgo+
PiAtLS0KPj4gwqAgYXJjaC9hcm02NC9rdm0vYXJtLmPCoMKgwqDCoMKgwqAgfCAxICsKPj4gwqAg
YXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMgfCA2ICsrKysrKwo+PiDCoCBhcmNoL3MzOTAva3Zt
L2t2bS1zMzkwLmPCoMKgIHwgMSArCj4+IMKgIGFyY2gveDg2L2t2bS94ODYuY8KgwqDCoMKgwqDC
oMKgwqAgfCAxICsKPj4gwqAgdmlydC9rdm0va3ZtX21haW4uY8KgwqDCoMKgwqDCoMKgIHwgMSAt
Cj4+IMKgIDUgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+
Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9hcm0uYyBiL2FyY2gvYXJtNjQva3ZtL2Fy
bS5jCj4+IGluZGV4IDJmZjBlZjYyYWJhZC4uZDJkYWE0ZDM3NWI1IDEwMDY0NAo+PiAtLS0gYS9h
cmNoL2FybTY0L2t2bS9hcm0uYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS9hcm0uYwo+PiBAQCAt
MjE4LDYgKzIxOCw3IEBAIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKHN0cnVjdCBr
dm0gKmt2bSwgCj4+IGxvbmcgZXh0KQo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9WQ1BVX0FU
VFJJQlVURVM6Cj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1BUUF9LVk06Cj4+IMKgwqDCoMKg
wqAgY2FzZSBLVk1fQ0FQX0FSTV9TWVNURU1fU1VTUEVORDoKPj4gK8KgwqDCoCBjYXNlIEtWTV9D
QVBfSVJRRkRfUkVTQU1QTEU6Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByID0gMTsKPj4gwqDCoMKg
wqDCoMKgwqDCoMKgIGJyZWFrOwo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9TRVRfR1VFU1Rf
REVCVUcyOgo+PiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMgYi9hcmNo
L3Bvd2VycGMva3ZtL3Bvd2VycGMuYwo+PiBpbmRleCBmYjE0OTA3NjFjODcuLjkwOGNlOGJkOTFj
OSAxMDA2NDQKPj4gLS0tIGEvYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMKPj4gKysrIGIvYXJj
aC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMKPj4gQEAgLTU5Myw2ICs1OTMsMTIgQEAgaW50IGt2bV92
bV9pb2N0bF9jaGVja19leHRlbnNpb24oc3RydWN0IGt2bSAqa3ZtLCAKPj4gbG9uZyBleHQpCj4+
IMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4gwqAgI2VuZGlmCj4+ICsjaWZkZWYgQ09ORklH
X0hBVkVfS1ZNX0lSUUZECj4+ICvCoMKgwqAgY2FzZSBLVk1fQ0FQX0lSUUZEX1JFU0FNUExFOgo+
PiArwqDCoMKgwqDCoMKgwqAgciA9ICF4aXZlX2VuYWJsZWQoKTsKPj4gK8KgwqDCoMKgwqDCoMKg
IGJyZWFrOwo+PiArI2VuZGlmCj4+ICsKPj4gwqDCoMKgwqDCoCBjYXNlIEtWTV9DQVBfUFBDX0FM
TE9DX0hUQUI6Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByID0gaHZfZW5hYmxlZDsKPj4gwqDCoMKg
wqDCoMKgwqDCoMKgIGJyZWFrOwo+PiBkaWZmIC0tZ2l0IGEvYXJjaC9zMzkwL2t2bS9rdm0tczM5
MC5jIGIvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jCj4+IGluZGV4IGVkZmQ0YmJkMGNiYS4uNzUy
MWFkYWRiODFiIDEwMDY0NAo+PiAtLS0gYS9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMKPj4gKysr
IGIvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jCj4+IEBAIC01NzcsNiArNTc3LDcgQEAgaW50IGt2
bV92bV9pb2N0bF9jaGVja19leHRlbnNpb24oc3RydWN0IGt2bSAqa3ZtLCAKPj4gbG9uZyBleHQp
Cj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1NFVF9HVUVTVF9ERUJVRzoKPj4gwqDCoMKgwqDC
oCBjYXNlIEtWTV9DQVBfUzM5MF9ESUFHMzE4Ogo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9T
MzkwX01FTV9PUF9FWFRFTlNJT046Cj4+ICvCoMKgwqAgY2FzZSBLVk1fQ0FQX0lSUUZEX1JFU0FN
UExFOgo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgciA9IDE7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBi
cmVhazsKPj4gwqDCoMKgwqDCoCBjYXNlIEtWTV9DQVBfU0VUX0dVRVNUX0RFQlVHMjoKPj4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYwo+PiBpbmRl
eCA0M2E2YTdlZmM2ZWMuLjJkNmM1YThmZGYxNCAxMDA2NDQKPj4gLS0tIGEvYXJjaC94ODYva3Zt
L3g4Ni5jCj4+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYuYwo+PiBAQCAtNDM5NSw2ICs0Mzk1LDcg
QEAgaW50IGt2bV92bV9pb2N0bF9jaGVja19leHRlbnNpb24oc3RydWN0IGt2bSAKPj4gKmt2bSwg
bG9uZyBleHQpCj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1ZBUElDOgo+PiDCoMKgwqDCoMKg
IGNhc2UgS1ZNX0NBUF9FTkFCTEVfQ0FQOgo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9WTV9E
SVNBQkxFX05YX0hVR0VfUEFHRVM6Cj4+ICvCoMKgwqAgY2FzZSBLVk1fQ0FQX0lSUUZEX1JFU0FN
UExFOgo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgciA9IDE7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBi
cmVhazsKPj4gwqDCoMKgwqDCoCBjYXNlIEtWTV9DQVBfRVhJVF9IWVBFUkNBTEw6Cj4+IGRpZmYg
LS1naXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYwo+PiBpbmRl
eCA1ODRhNWJhYjNhZjMuLjA1Y2Y5NDAxM2YwMiAxMDA2NDQKPj4gLS0tIGEvdmlydC9rdm0va3Zt
X21haW4uYwo+PiArKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCj4+IEBAIC00NDQ3LDcgKzQ0NDcs
NiBAQCBzdGF0aWMgbG9uZyAKPj4ga3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVuc2lvbl9nZW5lcmlj
KHN0cnVjdCBrdm0gKmt2bSwgbG9uZyBhcmcpCj4+IMKgICNlbmRpZgo+PiDCoCAjaWZkZWYgQ09O
RklHX0hBVkVfS1ZNX0lSUUZECj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX0lSUUZEOgo+PiAt
wqDCoMKgIGNhc2UgS1ZNX0NBUF9JUlFGRF9SRVNBTVBMRToKPj4gwqAgI2VuZGlmCj4+IMKgwqDC
oMKgwqAgY2FzZSBLVk1fQ0FQX0lPRVZFTlRGRF9BTllfTEVOR1RIOgo+PiDCoMKgwqDCoMKgIGNh
c2UgS1ZNX0NBUF9DSEVDS19FWFRFTlNJT05fVk06Cj4gCgotLSAKQWxleGV5Cl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
