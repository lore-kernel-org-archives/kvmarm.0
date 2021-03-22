Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75CDC433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 09:06:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E2696197F
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 09:06:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E2696197F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ED024B340;
	Mon, 22 Mar 2021 05:06:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pWPsQNUI6ETz; Mon, 22 Mar 2021 05:06:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D4424B3CD;
	Mon, 22 Mar 2021 05:06:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE4314B371
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 05:06:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HrNUQa9Vc2n8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 05:06:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF3D4B340
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 05:06:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1616403974;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ceXm904oOVw8lrZ113tpWQUHaEaaD5aBF7KgDgfkeB8=;
 b=E8sfazosg2hef8PTRiXOHHnwJ839dqOseEbHI5Vmwjigmzx4yLawkEk44aszBt5tRF4r8Q
 TgdzkHyo1NLABS/86jTcKaSWQWAK+EvSTUKf+xt8vlsEyz5WtVPyUfKLGeRVqgrV3HWFBu
 R6Pj+6RAUG+gkIoZZ6Upx8Iq4kgAuRc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-bRF2cYJsOoCFt0j80lMxGA-1; Mon, 22 Mar 2021 05:06:10 -0400
X-MC-Unique: bRF2cYJsOoCFt0j80lMxGA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C80B31009456;
 Mon, 22 Mar 2021 09:06:07 +0000 (UTC)
Received: from [10.36.113.141] (ovpn-113-141.ams2.redhat.com [10.36.113.141])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C019A62A6F;
 Mon, 22 Mar 2021 09:05:58 +0000 (UTC)
Subject: Re: [Linuxarm] Re: [PATCH v14 07/13] iommu/smmuv3: Implement
 cache_invalidate
To: "chenxiang (M)" <chenxiang66@hisilicon.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
 alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-8-eric.auger@redhat.com>
 <c10c6405-5efe-5a41-2b3a-f3af85a528ba@hisilicon.com>
 <d5dcb7fe-2e09-b1fb-24d6-36249f047632@redhat.com>
 <1cf3fa95-45c6-5846-e1c2-12c222ebed46@hisilicon.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a691418f-5aa8-1d02-3519-732b39cd91cb@redhat.com>
Date: Mon, 22 Mar 2021 10:05:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1cf3fa95-45c6-5846-e1c2-12c222ebed46@hisilicon.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: jean-philippe@linaro.org, wangxingang5@huawei.com, lushenming@huawei.com,
 linuxarm@openeuler.org, vsethi@nvidia.com, vivek.gautam@arm.com,
 zhangfei.gao@linaro.org
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

SGkgQ2hlbnhpYW5nLAoKT24gMy8yMi8yMSA3OjQwIEFNLCBjaGVueGlhbmcgKE0pIHdyb3RlOgo+
IEhpIEVyaWMsCj4gCj4gCj4g5ZyoIDIwMjEvMy8yMCAxOjM2LCBBdWdlciBFcmljIOWGmemBkzoK
Pj4gSGkgQ2hlbnhpYW5nLAo+Pgo+PiBPbiAzLzQvMjEgODo1NSBBTSwgY2hlbnhpYW5nIChNKSB3
cm90ZToKPj4+IEhpIEVyaWMsCj4+Pgo+Pj4KPj4+IOWcqCAyMDIxLzIvMjQgNDo1NiwgRXJpYyBB
dWdlciDlhpnpgZM6Cj4+Pj4gSW1wbGVtZW50IGRvbWFpbi1zZWxlY3RpdmUsIHBhc2lkIHNlbGVj
dGl2ZSBhbmQgcGFnZS1zZWxlY3RpdmUKPj4+PiBJT1RMQiBpbnZhbGlkYXRpb25zLgo+Pj4+Cj4+
Pj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+Pj4+
Cj4+Pj4gLS0tCj4+Pj4KPj4+PiB2MTMgLT4gdjE0Ogo+Pj4+IC0gQWRkIGRvbWFpbiBpbnZhbGlk
YXRpb24KPj4+PiAtIGRvIGdsb2JhbCBpbnZhbCB3aGVuIGFzaWQgaXMgbm90IHByb3ZpZGVkIHdp
dGggYWRkcgo+Pj4+IMKgwqAgZ3JhbnVsYXJpdHkKPj4+Pgo+Pj4+IHY3IC0+IHY4Ogo+Pj4+IC0g
QVNJRCBiYXNlZCBpbnZhbGlkYXRpb24gdXNpbmcgaW9tbXVfaW52X3Bhc2lkX2luZm8KPj4+PiAt
IGNoZWNrIEFSQ0hJRC9QQVNJRCBmbGFncyBpbiBhZGRyIGJhc2VkIGludmFsaWRhdGlvbgo+Pj4+
IC0gdXNlIF9fYXJtX3NtbXVfdGxiX2ludl9jb250ZXh0IGFuZCBfX2FybV9zbW11X3RsYl9pbnZf
cmFuZ2Vfbm9zeW5jCj4+Pj4KPj4+PiB2NiAtPiB2Nwo+Pj4+IC0gY2hlY2sgdGhlIHVhcGkgdmVy
c2lvbgo+Pj4+Cj4+Pj4gdjMgLT4gdjQ6Cj4+Pj4gLSBhZGFwdCB0byBjaGFuZ2VzIGluIHRoZSB1
YXBpCj4+Pj4gLSBhZGQgc3VwcG9ydCBmb3IgbGVhZiBwYXJhbWV0ZXIKPj4+PiAtIGRvIG5vdCB1
c2UgYXJtX3NtbXVfdGxiX2ludl9yYW5nZV9ub3N5bmMgb3IgYXJtX3NtbXVfdGxiX2ludl9jb250
ZXh0Cj4+Pj4gwqDCoCBhbnltb3JlCj4+Pj4KPj4+PiB2MiAtPiB2MzoKPj4+PiAtIHJlcGxhY2Ug
X19hcm1fc21tdV90bGJfc3luYyBieSBhcm1fc21tdV9jbWRxX2lzc3VlX3N5bmMKPj4+Pgo+Pj4+
IHYxIC0+IHYyOgo+Pj4+IC0gcHJvcGVybHkgcGFzcyB0aGUgYXNpZAo+Pj4+IC0tLQo+Pj4+IMKg
IGRyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMgfCA3NAo+Pj4+ICsr
KysrKysrKysrKysrKysrKysrKwo+Pj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA3NCBpbnNlcnRpb25z
KCspCj4+Pj4KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMv
YXJtLXNtbXUtdjMuYwo+Pj4+IGIvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNt
bXUtdjMuYwo+Pj4+IGluZGV4IDRjMTlhMTExNGRlNC4uZGYzYWRjNDkxMTFjIDEwMDY0NAo+Pj4+
IC0tLSBhL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMKPj4+PiAr
KysgYi9kcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jCj4+Pj4gQEAg
LTI5NDksNiArMjk0OSw3OSBAQCBzdGF0aWMgdm9pZAo+Pj4+IGFybV9zbW11X2RldGFjaF9wYXNp
ZF90YWJsZShzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4pCj4+Pj4gwqDCoMKgwqDCoCBtdXRl
eF91bmxvY2soJnNtbXVfZG9tYWluLT5pbml0X211dGV4KTsKPj4+PiDCoCB9Cj4+Pj4gwqAgK3N0
YXRpYyBpbnQKPj4+PiArYXJtX3NtbXVfY2FjaGVfaW52YWxpZGF0ZShzdHJ1Y3QgaW9tbXVfZG9t
YWluICpkb21haW4sIHN0cnVjdAo+Pj4+IGRldmljZSAqZGV2LAo+Pj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBzdHJ1Y3QgaW9tbXVfY2FjaGVfaW52YWxpZGF0ZV9pbmZvICppbnZfaW5m
bykKPj4+PiArewo+Pj4+ICvCoMKgwqAgc3RydWN0IGFybV9zbW11X2NtZHFfZW50IGNtZCA9IHsu
b3Bjb2RlID0gQ01EUV9PUF9UTEJJX05TTkhfQUxMfTsKPj4+PiArwqDCoMKgIHN0cnVjdCBhcm1f
c21tdV9kb21haW4gKnNtbXVfZG9tYWluID0gdG9fc21tdV9kb21haW4oZG9tYWluKTsKPj4+PiAr
wqDCoMKgIHN0cnVjdCBhcm1fc21tdV9kZXZpY2UgKnNtbXUgPSBzbW11X2RvbWFpbi0+c21tdTsK
Pj4+PiArCj4+Pj4gK8KgwqDCoCBpZiAoc21tdV9kb21haW4tPnN0YWdlICE9IEFSTV9TTU1VX0RP
TUFJTl9ORVNURUQpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+Pj4+ICsK
Pj4+PiArwqDCoMKgIGlmICghc21tdSkKPj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5W
QUw7Cj4+Pj4gKwo+Pj4+ICvCoMKgwqAgaWYgKGludl9pbmZvLT52ZXJzaW9uICE9IElPTU1VX0NB
Q0hFX0lOVkFMSURBVEVfSU5GT19WRVJTSU9OXzEpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldHVy
biAtRUlOVkFMOwo+Pj4+ICsKPj4+PiArwqDCoMKgIGlmIChpbnZfaW5mby0+Y2FjaGUgJiBJT01N
VV9DQUNIRV9JTlZfVFlQRV9QQVNJRCB8fAo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpbnZfaW5mby0+
Y2FjaGUgJiBJT01NVV9DQUNIRV9JTlZfVFlQRV9ERVZfSU9UTEIpIHsKPj4+PiArwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIC1FTk9FTlQ7Cj4+Pj4gK8KgwqDCoCB9Cj4+Pj4gKwo+Pj4+ICvCoMKgwqAg
aWYgKCEoaW52X2luZm8tPmNhY2hlICYgSU9NTVVfQ0FDSEVfSU5WX1RZUEVfSU9UTEIpKQo+Pj4+
ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPj4+PiArCj4+Pj4gK8KgwqDCoCAvKiBJ
T1RMQiBpbnZhbGlkYXRpb24gKi8KPj4+PiArCj4+Pj4gK8KgwqDCoCBzd2l0Y2ggKGludl9pbmZv
LT5ncmFudWxhcml0eSkgewo+Pj4+ICvCoMKgwqAgY2FzZSBJT01NVV9JTlZfR1JBTlVfUEFTSUQ6
Cj4+Pj4gK8KgwqDCoCB7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHN0cnVjdCBpb21tdV9pbnZfcGFz
aWRfaW5mbyAqaW5mbyA9Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJmludl9pbmZvLT5n
cmFudS5wYXNpZF9pbmZvOwo+Pj4+ICsKPj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGluZm8tPmZs
YWdzICYgSU9NTVVfSU5WX0FERFJfRkxBR1NfUEFTSUQpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIC1FTk9FTlQ7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmICghKGluZm8tPmZs
YWdzICYgSU9NTVVfSU5WX1BBU0lEX0ZMQUdTX0FSQ0hJRCkpCj4+Pj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+Pj4gKwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBfX2Fy
bV9zbW11X3RsYl9pbnZfY29udGV4dChzbW11X2RvbWFpbiwgaW5mby0+YXJjaGlkKTsKPj4+PiAr
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4+Pj4gK8KgwqDCoCB9Cj4+Pj4gK8KgwqDCoCBjYXNl
IElPTU1VX0lOVl9HUkFOVV9BRERSOgo+Pj4+ICvCoMKgwqAgewo+Pj4+ICvCoMKgwqDCoMKgwqDC
oCBzdHJ1Y3QgaW9tbXVfaW52X2FkZHJfaW5mbyAqaW5mbyA9ICZpbnZfaW5mby0+Z3JhbnUuYWRk
cl9pbmZvOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBzaXplX3Qgc2l6ZSA9IGluZm8tPm5iX2dyYW51
bGVzICogaW5mby0+Z3JhbnVsZV9zaXplOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBib29sIGxlYWYg
PSBpbmZvLT5mbGFncyAmIElPTU1VX0lOVl9BRERSX0ZMQUdTX0xFQUY7Cj4+Pj4gKwo+Pj4+ICvC
oMKgwqDCoMKgwqDCoCBpZiAoaW5mby0+ZmxhZ3MgJiBJT01NVV9JTlZfQUREUl9GTEFHU19QQVNJ
RCkKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVOT0VOVDsKPj4+PiArCj4+
Pj4gK8KgwqDCoMKgwqDCoMKgIGlmICghKGluZm8tPmZsYWdzICYgSU9NTVVfSU5WX0FERFJfRkxB
R1NfQVJDSElEKSkKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4+PiArCj4+
Pj4gK8KgwqDCoMKgwqDCoMKgIGFybV9zbW11X3RsYl9pbnZfcmFuZ2VfZG9tYWluKGluZm8tPmFk
ZHIsIHNpemUsCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGluZm8tPmdyYW51bGVfc2l6ZSwgbGVhZiwKPj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW5mby0+YXJjaGlkLCBzbW11X2Rv
bWFpbik7Cj4+PiBJcyBpdCBwb3NzaWJsZSB0byBhZGQgYSBjaGVjayBiZWZvcmUgdGhlIGZ1bmN0
aW9uIHRvIG1ha2Ugc3VyZSB0aGF0Cj4+PiBpbmZvLT5ncmFudWxlX3NpemUgY2FuIGJlIHJlY29n
bml6ZWQgYnkgU01NVT8KPj4+IFRoZXJlIGlzIGEgc2NlbmFyaW8gd2hpY2ggd2lsbCBjYXVzZSBU
TEJJIGlzc3VlOiBSSUwgZmVhdHVyZSBpcyBlbmFibGVkCj4+PiBvbiBndWVzdCBidXQgaXMgZGlz
YWJsZWQgb24gaG9zdCwgYW5kIHRoZW4gb24KPj4+IGhvc3QgaXQganVzdCBpbnZhbGlkYXRlIDRL
LzJNLzFHIG9uY2UgYSB0aW1lLCBidXQgZnJvbSBRRU1VLAo+Pj4gaW5mby0+bmJfZ3JhbnVsZXMg
aXMgYWx3YXlzIDEgYW5kIGluZm8tPmdyYW51bGVfc2l6ZSA9IHNpemUsCj4+PiBpZiBzaXplIGlz
IG5vdCBlcXVhbCB0byA0SyBvciAyTSBvciAxRyAoZm9yIGV4YW1wbGUgc2l6ZSA9IGdyYW51bGVf
c2l6ZQo+Pj4gaXMgNU0pLCBpdCB3aWxsIG9ubHkgcGFydCBvZiB0aGUgc2l6ZSBpdCB3YW50cyB0
byBpbnZhbGlkYXRlLgo+IAo+IERvIHlvdSBoYXZlIGFueSBpZGVhIGFib3V0IHRoaXMgaXNzdWU/
CgpBdCB0aGUgUUVNVSBWRklPIG5vdGlmaWVyIGxldmVsLCB3aGVuIEkgZmlsbCB0aGUgc3RydWN0
CmlvbW11X2NhY2hlX2ludmFsaWRhdGVfaW5mbywgSSBjdXJyZW50bHkgbWlzcyB0aGUgZ3JhbnVs
ZSBpbmZvLCBoZW5jZQp0aGlzIHdlaXJkIGNob2ljZSBvZiBzZXR0aW5nIHNldHRpbmcgaW5mby0+
bmJfZ3JhbnVsZXMgaXMgYWx3YXlzIDEgYW5kCmluZm8tPmdyYW51bGVfc2l6ZSA9IHNpemUuIEkg
dGhpbmsgaW4gYXJtX3NtbXVfY2FjaGVfaW52YWxpZGF0ZSgpIEkgbmVlZAp0byBjb252ZXJ0IHRo
aXMgaW5mbyBiYWNrIHRvIGEgdGhlIGxlYWYgcGFnZSBzaXplLCBpbiBjYXNlIHRoZSBob3N0IGRv
ZXMKbm90IHN1cHBvcnQgUklMLiBKdXN0IGFzIGl0IGlzIGRvbmUgaW4gIF9fYXJtX3NtbXVfdGxi
X2ludl9yYW5nZSBpZiBSSUwKaXMgc3VwcG9ydGVkLgoKRG9lcyBpdCBtYWtlcyBzZW5zZSB0byB5
b3U/CgpUaGFuayB5b3UgZm9yIHNwb3R0aW5nIHRoZSBpc3N1ZS4KCkVyaWMKPiAKPj4+Cj4+PiBJ
IHRoaW5rIG1heWJlIHdlIGNhbiBhZGQgYSBjaGVjayBoZXJlOiBpZiBSSUwgaXMgbm90IGVuYWJs
ZWQgYW5kIGFsc28KPj4+IHNpemUgaXMgbm90IHRoZSBncmFudWxlX3NpemUgKDRLLzJNLzFHKSBz
dXBwb3J0ZWQgYnkKPj4+IFNNTVUgaGFyZHdhcmUsIGNhbiB3ZSBqdXN0IHNpbXBseSB1c2UgdGhl
IHNtYWxsZXN0IGdyYW51bGVfc2l6ZQo+Pj4gc3VwcG9ydGVkIGJ5IGhhcmR3YXJlIGFsbCB0aGUg
dGltZT8KPj4+Cj4+Pj4gKwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBhcm1fc21tdV9jbWRxX2lzc3Vl
X3N5bmMoc21tdSk7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAwOwo+Pj4+ICvCoMKgwqAg
fQo+Pj4+ICvCoMKgwqAgY2FzZSBJT01NVV9JTlZfR1JBTlVfRE9NQUlOOgo+Pj4+ICvCoMKgwqDC
oMKgwqDCoCBicmVhazsKPj4+IEkgY2hlY2sgdGhlIHFlbXUgY29kZQo+Pj4gKGh0dHBzOi8vZ2l0
aHViLmNvbS9lYXVnZXIvcWVtdS90cmVlL3Y1LjIuMC0yc3RhZ2UtcmZjdjgpLCBmb3Igb3Bjb2Rl
Cj4+PiBDTURfVExCSV9OSF9BTEwgb3IgQ01EX1RMQklfTlNOSF9BTEwgZnJvbSBndWVzdCBPUwo+
Pj4gaXQgY2FsbHMgc21tdV9pbnZfbm90aWZpZXJzX2FsbCgpIHRvIHVuYW1wIGFsbCBub3RpZmll
cnMgb2YgYWxsIG1yJ3MsCj4+PiBidXQgaXQgc2VlbXMgbm90IHNldCBldmVudC5lbnRyeS5ncmFu
dWxhcml0eSB3aGljaCBpIHRoaW5rIGl0IHNob3VsZCBzZXQKPj4+IElPTU1VX0lOVl9HUkFOX0FE
RFIuCj4+IHRoaXMgaXMgYmVjYXVzZSBJT01NVV9JTlZfR1JBTl9BRERSID0gMC4gQnV0IGZvciBj
bGFyaXR5IEkgc2hvdWxkIHJhdGhlcgo+PiBzZXQgaXQgZXhwbGljaXRseSA7LSkKPiAKPiBvawo+
IAo+Pj4gQlRXLCBmb3Igb3Bjb2RlIENNRF9UTEJJX05IX0FMTCBvciBDTURfVExCSV9OU05IX0FM
TCwgaXQgbmVlZHMgdG8gdW5tYXAKPj4+IHNpemUgPSAweDEwMDAwMDAwMDAwMDAgb24gNDhiaXQg
c3lzdGVtIChpdCBtYXkgc3BlbmQgbXVjaCB0aW1lKSzCoCBtYXliZQo+Pj4gaXQgaXMgYmV0dGVy
Cj4+PiB0byBzZXQgaXQgYXMgSU9NTVVfSU5WX0dSQU5VX0RPTUFJTiwgdGhlbiBpbiBob3N0IE9T
LCBzZW5kIFRMQklfTkhfQUxMCj4+PiBkaXJlY3RseSB3aGVuIElPTU1VX0lOVl9HUkFOVV9ET01B
SU4uCj4+IFllcyB5b3UncmUgcmlnaHQuIElmIHRoZSBob3N0IGRvZXMgbm90IHN1cHBvcnQgUklM
IHRoZW4gaXQgaXMgYW4gaXNzdWUuCj4+IFRoaXMgaXMgZ29pbmcgdG8gYmUgZml4ZWQgaW4gdGhl
IG5leHQgdmVyc2lvbi4KPiAKPiBHcmVhdAo+IAo+Pgo+PiBUaGFuayB5b3UgZm9yIHRoZSByZXBv
cnQhCj4+Cj4+IEJlc3QgUmVnYXJkcwo+Pgo+PiBFcmljCj4+Pgo+Pj4+ICvCoMKgwqAgZGVmYXVs
dDoKPj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+Pj4gK8KgwqDCoCB9Cj4+
Pj4gKwo+Pj4+ICvCoMKgwqAgLyogR2xvYmFsIFMxIGludmFsaWRhdGlvbiAqLwo+Pj4+ICvCoMKg
wqAgY21kLnRsYmkudm1pZMKgwqAgPSBzbW11X2RvbWFpbi0+czJfY2ZnLnZtaWQ7Cj4+Pj4gK8Kg
wqDCoCBhcm1fc21tdV9jbWRxX2lzc3VlX2NtZChzbW11LCAmY21kKTsKPj4+PiArwqDCoMKgIGFy
bV9zbW11X2NtZHFfaXNzdWVfc3luYyhzbW11KTsKPj4+PiArwqDCoMKgIHJldHVybiAwOwo+Pj4+
ICt9Cj4+Pj4gKwo+Pj4+IMKgIHN0YXRpYyBib29sIGFybV9zbW11X2Rldl9oYXNfZmVhdHVyZShz
dHJ1Y3QgZGV2aWNlICpkZXYsCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZW51bSBpb21tdV9kZXZfZmVhdHVyZXMgZmVhdCkKPj4+PiDCoCB7Cj4+Pj4g
QEAgLTMwNDgsNiArMzEyMSw3IEBAIHN0YXRpYyBzdHJ1Y3QgaW9tbXVfb3BzIGFybV9zbW11X29w
cyA9IHsKPj4+PiDCoMKgwqDCoMKgIC5wdXRfcmVzdl9yZWdpb25zwqDCoMKgID0gZ2VuZXJpY19p
b21tdV9wdXRfcmVzdl9yZWdpb25zLAo+Pj4+IMKgwqDCoMKgwqAgLmF0dGFjaF9wYXNpZF90YWJs
ZcKgwqDCoCA9IGFybV9zbW11X2F0dGFjaF9wYXNpZF90YWJsZSwKPj4+PiDCoMKgwqDCoMKgIC5k
ZXRhY2hfcGFzaWRfdGFibGXCoMKgwqAgPSBhcm1fc21tdV9kZXRhY2hfcGFzaWRfdGFibGUsCj4+
Pj4gK8KgwqDCoCAuY2FjaGVfaW52YWxpZGF0ZcKgwqDCoCA9IGFybV9zbW11X2NhY2hlX2ludmFs
aWRhdGUsCj4+Pj4gwqDCoMKgwqDCoCAuZGV2X2hhc19mZWF0wqDCoMKgwqDCoMKgwqAgPSBhcm1f
c21tdV9kZXZfaGFzX2ZlYXR1cmUsCj4+Pj4gwqDCoMKgwqDCoCAuZGV2X2ZlYXRfZW5hYmxlZMKg
wqDCoCA9IGFybV9zbW11X2Rldl9mZWF0dXJlX2VuYWJsZWQsCj4+Pj4gwqDCoMKgwqDCoCAuZGV2
X2VuYWJsZV9mZWF0wqDCoMKgID0gYXJtX3NtbXVfZGV2X2VuYWJsZV9mZWF0dXJlLAo+PiBfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+PiBMaW51eGFybSBt
YWlsaW5nIGxpc3QgLS0gbGludXhhcm1Ab3BlbmV1bGVyLm9yZwo+PiBUbyB1bnN1YnNjcmliZSBz
ZW5kIGFuIGVtYWlsIHRvIGxpbnV4YXJtLWxlYXZlQG9wZW5ldWxlci5vcmcKPiAKPiAKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
