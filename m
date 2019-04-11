Return-Path: <SRS0=Fx/F=SN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47802C10F13
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 09:45:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2D7B2084D
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 09:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2D7B2084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 307384A4C1;
	Thu, 11 Apr 2019 05:45:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ym8utd4xluW0; Thu, 11 Apr 2019 05:45:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3D5D4A4B0;
	Thu, 11 Apr 2019 05:45:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D33144A4AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Apr 2019 05:44:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pyn9JMzK-vef for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Apr 2019 05:44:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 996A34A422
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Apr 2019 05:44:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCB9A374;
 Thu, 11 Apr 2019 02:44:57 -0700 (PDT)
Received: from [10.37.12.253] (unknown [10.37.12.253])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27BD23F59C;
 Thu, 11 Apr 2019 02:44:54 -0700 (PDT)
Subject: Re: [PATCH 1/2] kvm: arm: Clean up the checking for huge mapping
To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org
References: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-2-git-send-email-suzuki.poulose@arm.com>
 <529f8515-a069-948b-cb63-96fa35b291a6@huawei.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <ab173598-56a8-f9d3-1165-1bd748c2b8d6@arm.com>
Date: Thu, 11 Apr 2019 10:47:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <529f8515-a069-948b-cb63-96fa35b291a6@huawei.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190411094712.6lWsjY7IPPUPkrAquyvZWMBvX7JzY5XdMbEUnb3U-HA@z>

T24gMDQvMTEvMjAxOSAwMjo0OCBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiAKPiBPbiAyMDE5LzQv
MTAgMjM6MjMsIFN1enVraSBLIFBvdWxvc2Ugd3JvdGU6Cj4+IElmIHdlIGFyZSBjaGVja2luZyB3
aGV0aGVyIHRoZSBzdGFnZTIgY2FuIG1hcCBQQUdFX1NJWkUsCj4+IHdlIGRvbid0IGhhdmUgdG8g
ZG8gdGhlIGJvdW5kYXJ5IGNoZWNrcyBhcyBib3RoIHRoZSBob3N0Cj4+IFZNQSBhbmQgdGhlIGd1
ZXN0IG1lbXNsb3RzIGFyZSBwYWdlIGFsaWduZWQuIEJhaWwgdGhlIGNhc2UKPj4gZWFzaWx5Lgo+
Pgo+PiBDYzogQ2hyaXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBhcm0uY29tPgo+PiBD
YzogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KPj4gU2lnbmVkLW9mZi1ieTog
U3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNvbT4KPj4gLS0tCj4+IMKgIHZp
cnQva3ZtL2FybS9tbXUuYyB8IDQgKysrKwo+PiDCoCAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRp
b25zKCspCj4+Cj4+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vbW11LmMgYi92aXJ0L2t2bS9h
cm0vbW11LmMKPj4gaW5kZXggYTM5ZGNmZC4uNmQ3MzMyMiAxMDA2NDQKPj4gLS0tIGEvdmlydC9r
dm0vYXJtL21tdS5jCj4+ICsrKyBiL3ZpcnQva3ZtL2FybS9tbXUuYwo+PiBAQCAtMTYyNCw2ICsx
NjI0LDEwIEBAIHN0YXRpYyBib29sIAo+PiBmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBw
aW5nKHN0cnVjdCBrdm1fbWVtb3J5X3Nsb3QgKm1lbXNsb3QsCj4+IMKgwqDCoMKgwqAgaHZhX3Qg
dWFkZHJfc3RhcnQsIHVhZGRyX2VuZDsKPj4gwqDCoMKgwqDCoCBzaXplX3Qgc2l6ZTsKPj4gK8Kg
wqDCoCAvKiBUaGUgbWVtc2xvdCBhbmQgdGhlIFZNQSBhcmUgZ3VhcmFudGVlZCB0byBiZSBhbGln
bmVkIHRvIAo+PiBQQUdFX1NJWkUgKi8KPj4gK8KgwqDCoCBpZiAobWFwX3NpemUgPT0gUEFHRV9T
SVpFKQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHRydWU7Cj4+ICsKPj4gwqDCoMKgwqDCoCBz
aXplID0gbWVtc2xvdC0+bnBhZ2VzICogUEFHRV9TSVpFOwo+PiDCoMKgwqDCoMKgIGdwYV9zdGFy
dCA9IG1lbXNsb3QtPmJhc2VfZ2ZuIDw8IFBBR0VfU0hJRlQ7Cj4+Cj4gV2UgY2FuIGRvIGEgY29t
bWVudCBjbGVhbiB1cCBhcyB3ZWxsIGluIHRoaXMgcGF0Y2guCj4gCj4gcy88PCBQQUdFX1NJWkUv
PDwgUEFHRV9TSElGVC8KClN1cmUsIEkgbWlzc2VkIHRoYXQuIFdpbGwgZml4IGl0IGluIHRoZSBu
ZXh0IHZlcnNpb24uCgpDaGVlcnMKU3V6dWtpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
