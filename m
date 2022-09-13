Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3B4C6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 13 Sep 2022 13:34:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 351694BC0C;
	Tue, 13 Sep 2022 09:34:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@ozlabs-ru.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lVHhTRmu5Br3; Tue, 13 Sep 2022 09:34:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 942794BC0D;
	Tue, 13 Sep 2022 09:34:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 113394BBF7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 08:51:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e-pdbpdGQi9K for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2022 08:50:59 -0400 (EDT)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6C764BBEF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 08:50:59 -0400 (EDT)
Received: by mail-pl1-f171.google.com with SMTP id k21so1172342pls.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 05:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date;
 bh=m+eZZoFLZFj4EhrhLyyE+g7R7dkUsiwp1ctUGIB8Xyc=;
 b=jGIh/hBBHB9qngcxAiPKVlNnWoA+4zhrJlHf/7cC6XoKAdqrYm5GcLRzVI69z0CV39
 /w+Q5i/tkVixk74+Fp4Lhjc8bBaLEBt9cSXeJzBNcWGk1bbmt29VXx+sb3d/UPOKmUs8
 jtRkKfovsQvEtIMaRisgVTCoGaJAv2JiZu7sapDlXUUZejKRyep20zGPtVQAb1dAtjVO
 WKha2N36Mc9SKwfEVzRvas+JtOgsGBDvIwik+fsnWhTupgkW+Pqr195kPR6g7BM4ZnZd
 Bct9AUdOeRH9TAsfLZeB06sIYcOcAirND6uDCVUvlUoMTIWP43dr1J+vIaudr10e4A6O
 G5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=m+eZZoFLZFj4EhrhLyyE+g7R7dkUsiwp1ctUGIB8Xyc=;
 b=UsivIj2qauYdLRsEJZ/ni8vz8AUloNdMChLK4CLoOZzma1tKskneebAiVHJf9LtXBE
 g4Os5cZ2ttbzMIxuWNixhkPptiW+o/eqJ9CoAZkK5Ydl4eGPm5KnLiSNf6TKk7MCtiNe
 vPx/TcgxHwfyZ6/rMDCF+9AXl3RUlcWE+cL8Y4Lt4KRX5ev/KFGv4t9s9wEq78fO4w+M
 YYPP/JVVsgMRkA2vMLRs43yhMWJkMRSswFnDaNWN1lCQZL6RmGd7O54R0+pK41USxGpf
 TNpfYaWm+2qp8sVZuBYzsV10Ho30n5FecLoOHxH+1Lg3X4cvPZEesI5Xonz0iZjWM3BB
 Q/oQ==
X-Gm-Message-State: ACgBeo2QSSC2Mim6kWIswTcqUZa/w3bjbt5aJbP1Jv96ySST+VSdAaid
 WBUdKb3+toEVvoiJK4UdwEFGYw==
X-Google-Smtp-Source: AA6agR6b0dbrm/dWvV5TmvZeUsJCtL2b/PeHdCl4glygOlKhuTzGMSEz5loOjhBvm1OoAAz40VEAKw==
X-Received: by 2002:a17:902:c245:b0:178:3912:f1f7 with SMTP id
 5-20020a170902c24500b001783912f1f7mr7946684plg.75.1663073458500; 
 Tue, 13 Sep 2022 05:50:58 -0700 (PDT)
Received: from [192.168.10.153]
 (ppp121-45-204-168.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.204.168])
 by smtp.gmail.com with ESMTPSA id
 i12-20020a170902c94c00b00176da1aae5asm8419873pla.70.2022.09.13.05.50.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Sep 2022 05:50:57 -0700 (PDT)
Message-ID: <59dfb450-5a91-f27b-6edf-0adfa89729b7@ozlabs.ru>
Date: Tue, 13 Sep 2022 22:50:49 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: [PATCH kernel] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform
 dependent
Content-Language: en-US
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: kvm-ppc@vger.kernel.org
References: <20220504074807.3616813-1-aik@ozlabs.ru>
 <0d4bb0fa-10c6-3f5a-34c8-293144b3fdbb@ozlabs.ru>
In-Reply-To: <0d4bb0fa-10c6-3f5a-34c8-293144b3fdbb@ozlabs.ru>
X-Mailman-Approved-At: Tue, 13 Sep 2022 09:34:48 -0400
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Fabiano Rosas <farosas@linux.ibm.com>, x86@kernel.org,
 linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, linux-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu,
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

UGluZz8gSXQncyBiZWVuIGEgd2hpbGUgYW5kIHByb2JhYmx5IGdvdCBsb3N0IDotLwoKT24gMTgv
MDUvMjAyMiAxNjoyNywgQWxleGV5IEthcmRhc2hldnNraXkgd3JvdGU6Cj4gCj4gCj4gT24gNS80
LzIyIDE3OjQ4LCBBbGV4ZXkgS2FyZGFzaGV2c2tpeSB3cm90ZToKPj4gV2hlbiBpbnRyb2R1Y2Vk
LCBJUlFGRCByZXNhbXBsaW5nIHdvcmtlZCBvbiBQT1dFUjggd2l0aCBYSUNTLiBIb3dldmVyCj4+
IEtWTSBvbiBQT1dFUjkgaGFzIG5ldmVyIGltcGxlbWVudGVkIGl0IC0gdGhlIGNvbXBhdGliaWxp
dHkgbW9kZSBjb2RlCj4+ICgiWElDUy1vbi1YSVZFIikgbWlzc2VzIHRoZSBrdm1fbm90aWZ5X2Fj
a2VkX2lycSgpIGNhbGwgYW5kIHRoZSBuYXRpdmUKPj4gWElWRSBtb2RlIGRvZXMgbm90IGhhbmRs
ZSBJTlR4IGluIEtWTSBhdCBhbGwuCj4+Cj4+IFRoaXMgbW92ZWQgdGhlIGNhcGFiaWxpdHkgc3Vw
cG9ydCBhZHZlcnRpc2luZyB0byBwbGF0Zm9ybXMgYW5kIHN0b3BzCj4+IGFkdmVydGlzaW5nIGl0
IG9uIFhJVkUsIGkuZS4gUE9XRVI5IGFuZCBsYXRlci4KPj4KPj4gU2lnbmVkLW9mZi1ieTogQWxl
eGV5IEthcmRhc2hldnNraXkgPGFpa0BvemxhYnMucnU+Cj4+IC0tLQo+Pgo+Pgo+PiBPciBJIGNv
dWxkIG1vdmUgdGhpcyBvbmUgdG9nZXRoZXIgd2l0aCBLVk1fQ0FQX0lSUUZELiBUaG91Z2h0cz8K
PiAKPiAKPiBQaW5nPwo+IAo+Pgo+PiAtLS0KPj4gwqAgYXJjaC9hcm02NC9rdm0vYXJtLmPCoMKg
wqDCoMKgwqAgfCAzICsrKwo+PiDCoCBhcmNoL21pcHMva3ZtL21pcHMuY8KgwqDCoMKgwqDCoCB8
IDMgKysrCj4+IMKgIGFyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jIHwgNiArKysrKysKPj4gwqAg
YXJjaC9yaXNjdi9rdm0vdm0uY8KgwqDCoMKgwqDCoMKgIHwgMyArKysKPj4gwqAgYXJjaC9zMzkw
L2t2bS9rdm0tczM5MC5jwqDCoCB8IDMgKysrCj4+IMKgIGFyY2gveDg2L2t2bS94ODYuY8KgwqDC
oMKgwqDCoMKgwqAgfCAzICsrKwo+PiDCoCB2aXJ0L2t2bS9rdm1fbWFpbi5jwqDCoMKgwqDCoMKg
wqAgfCAxIC0KPj4gwqAgNyBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9hcm0uYyBiL2FyY2gvYXJt
NjQva3ZtL2FybS5jCj4+IGluZGV4IDUyM2JjOTM0ZmUyZi4uMDkyZjA2MTRiYWUzIDEwMDY0NAo+
PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9hcm0uYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS9hcm0u
Ywo+PiBAQCAtMjEwLDYgKzIxMCw5IEBAIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9u
KHN0cnVjdCBrdm0gKmt2bSwgCj4+IGxvbmcgZXh0KQo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NB
UF9TRVRfR1VFU1RfREVCVUc6Cj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1ZDUFVfQVRUUklC
VVRFUzoKPj4gwqDCoMKgwqDCoCBjYXNlIEtWTV9DQVBfUFRQX0tWTToKPj4gKyNpZmRlZiBDT05G
SUdfSEFWRV9LVk1fSVJRRkQKPj4gK8KgwqDCoCBjYXNlIEtWTV9DQVBfSVJRRkRfUkVTQU1QTEU6
Cj4+ICsjZW5kaWYKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIHIgPSAxOwo+PiDCoMKgwqDCoMKgwqDC
oMKgwqAgYnJlYWs7Cj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1NFVF9HVUVTVF9ERUJVRzI6
Cj4+IGRpZmYgLS1naXQgYS9hcmNoL21pcHMva3ZtL21pcHMuYyBiL2FyY2gvbWlwcy9rdm0vbWlw
cy5jCj4+IGluZGV4IGEyNWUwYjczZWU3MC4uMGYzZGU0NzBhNzNlIDEwMDY0NAo+PiAtLS0gYS9h
cmNoL21pcHMva3ZtL21pcHMuYwo+PiArKysgYi9hcmNoL21pcHMva3ZtL21pcHMuYwo+PiBAQCAt
MTA3MSw2ICsxMDcxLDkgQEAgaW50IGt2bV92bV9pb2N0bF9jaGVja19leHRlbnNpb24oc3RydWN0
IGt2bSAKPj4gKmt2bSwgbG9uZyBleHQpCj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1JFQURP
TkxZX01FTToKPj4gwqDCoMKgwqDCoCBjYXNlIEtWTV9DQVBfU1lOQ19NTVU6Cj4+IMKgwqDCoMKg
wqAgY2FzZSBLVk1fQ0FQX0lNTUVESUFURV9FWElUOgo+PiArI2lmZGVmIENPTkZJR19IQVZFX0tW
TV9JUlFGRAo+PiArwqDCoMKgIGNhc2UgS1ZNX0NBUF9JUlFGRF9SRVNBTVBMRToKPj4gKyNlbmRp
Zgo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgciA9IDE7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBicmVh
azsKPj4gwqDCoMKgwqDCoCBjYXNlIEtWTV9DQVBfTlJfVkNQVVM6Cj4+IGRpZmYgLS1naXQgYS9h
cmNoL3Bvd2VycGMva3ZtL3Bvd2VycGMuYyBiL2FyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jCj4+
IGluZGV4IDg3NWMzMGMxMmRiMC4uODc2OThmZmVmM2JlIDEwMDY0NAo+PiAtLS0gYS9hcmNoL3Bv
d2VycGMva3ZtL3Bvd2VycGMuYwo+PiArKysgYi9hcmNoL3Bvd2VycGMva3ZtL3Bvd2VycGMuYwo+
PiBAQCAtNTkxLDYgKzU5MSwxMiBAQCBpbnQga3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVuc2lvbihz
dHJ1Y3Qga3ZtICprdm0sIAo+PiBsb25nIGV4dCkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFr
Owo+PiDCoCAjZW5kaWYKPj4gKyNpZmRlZiBDT05GSUdfSEFWRV9LVk1fSVJRRkQKPj4gK8KgwqDC
oCBjYXNlIEtWTV9DQVBfSVJRRkRfUkVTQU1QTEU6Cj4+ICvCoMKgwqDCoMKgwqDCoCByID0gIXhp
dmVfZW5hYmxlZCgpOwo+PiArwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+ICsjZW5kaWYKPj4gKwo+
PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9QUENfQUxMT0NfSFRBQjoKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgIHIgPSBodl9lbmFibGVkOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+IGRp
ZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2t2bS92bS5jIGIvYXJjaC9yaXNjdi9rdm0vdm0uYwo+PiBp
bmRleCBjNzY4Zjc1Mjc5ZWYuLmI1ODU3OWIzODZiYiAxMDA2NDQKPj4gLS0tIGEvYXJjaC9yaXNj
di9rdm0vdm0uYwo+PiArKysgYi9hcmNoL3Jpc2N2L2t2bS92bS5jCj4+IEBAIC02Myw2ICs2Myw5
IEBAIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKHN0cnVjdCBrdm0gKmt2bSwgCj4+
IGxvbmcgZXh0KQo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9SRUFET05MWV9NRU06Cj4+IMKg
wqDCoMKgwqAgY2FzZSBLVk1fQ0FQX01QX1NUQVRFOgo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NB
UF9JTU1FRElBVEVfRVhJVDoKPj4gKyNpZmRlZiBDT05GSUdfSEFWRV9LVk1fSVJRRkQKPj4gK8Kg
wqDCoCBjYXNlIEtWTV9DQVBfSVJRRkRfUkVTQU1QTEU6Cj4+ICsjZW5kaWYKPj4gwqDCoMKgwqDC
oMKgwqDCoMKgIHIgPSAxOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+IMKgwqDCoMKg
wqAgY2FzZSBLVk1fQ0FQX05SX1ZDUFVTOgo+PiBkaWZmIC0tZ2l0IGEvYXJjaC9zMzkwL2t2bS9r
dm0tczM5MC5jIGIvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jCj4+IGluZGV4IDE1NmQxYzI1YTNj
MS4uODVlMDkzZmM4ZDEzIDEwMDY0NAo+PiAtLS0gYS9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMK
Pj4gKysrIGIvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jCj4+IEBAIC01NjQsNiArNTY0LDkgQEAg
aW50IGt2bV92bV9pb2N0bF9jaGVja19leHRlbnNpb24oc3RydWN0IGt2bSAqa3ZtLCAKPj4gbG9u
ZyBleHQpCj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1NFVF9HVUVTVF9ERUJVRzoKPj4gwqDC
oMKgwqDCoCBjYXNlIEtWTV9DQVBfUzM5MF9ESUFHMzE4Ogo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZN
X0NBUF9TMzkwX01FTV9PUF9FWFRFTlNJT046Cj4+ICsjaWZkZWYgQ09ORklHX0hBVkVfS1ZNX0lS
UUZECj4+ICvCoMKgwqAgY2FzZSBLVk1fQ0FQX0lSUUZEX1JFU0FNUExFOgo+PiArI2VuZGlmCj4+
IMKgwqDCoMKgwqDCoMKgwqDCoCByID0gMTsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+
PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9TRVRfR1VFU1RfREVCVUcyOgo+PiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jCj4+IGluZGV4IDBjMGNh
NTk5YTM1My4uYTBhN2I3Njk0ODNkIDEwMDY0NAo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMK
Pj4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jCj4+IEBAIC00MjczLDYgKzQyNzMsOSBAQCBpbnQg
a3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVuc2lvbihzdHJ1Y3Qga3ZtIAo+PiAqa3ZtLCBsb25nIGV4
dCkKPj4gwqDCoMKgwqDCoCBjYXNlIEtWTV9DQVBfU1lTX0FUVFJJQlVURVM6Cj4+IMKgwqDCoMKg
wqAgY2FzZSBLVk1fQ0FQX1ZBUElDOgo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9FTkFCTEVf
Q0FQOgo+PiArI2lmZGVmIENPTkZJR19IQVZFX0tWTV9JUlFGRAo+PiArwqDCoMKgIGNhc2UgS1ZN
X0NBUF9JUlFGRF9SRVNBTVBMRToKPj4gKyNlbmRpZgo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgciA9
IDE7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4gwqDCoMKgwqDCoCBjYXNlIEtWTV9D
QVBfRVhJVF9IWVBFUkNBTEw6Cj4+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIv
dmlydC9rdm0va3ZtX21haW4uYwo+PiBpbmRleCA3MGUwNWFmNWViZWEuLjg4NWU3MmU2NjhhNSAx
MDA2NDQKPj4gLS0tIGEvdmlydC9rdm0va3ZtX21haW4uYwo+PiArKysgYi92aXJ0L2t2bS9rdm1f
bWFpbi5jCj4+IEBAIC00MjkzLDcgKzQyOTMsNiBAQCBzdGF0aWMgbG9uZyAKPj4ga3ZtX3ZtX2lv
Y3RsX2NoZWNrX2V4dGVuc2lvbl9nZW5lcmljKHN0cnVjdCBrdm0gKmt2bSwgbG9uZyBhcmcpCj4+
IMKgICNlbmRpZgo+PiDCoCAjaWZkZWYgQ09ORklHX0hBVkVfS1ZNX0lSUUZECj4+IMKgwqDCoMKg
wqAgY2FzZSBLVk1fQ0FQX0lSUUZEOgo+PiAtwqDCoMKgIGNhc2UgS1ZNX0NBUF9JUlFGRF9SRVNB
TVBMRToKPj4gwqAgI2VuZGlmCj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX0lPRVZFTlRGRF9B
TllfTEVOR1RIOgo+PiDCoMKgwqDCoMKgIGNhc2UgS1ZNX0NBUF9DSEVDS19FWFRFTlNJT05fVk06
Cj4gCgotLSAKQWxleGV5Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
