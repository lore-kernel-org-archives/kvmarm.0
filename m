Return-Path: <SRS0=T+on=IV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96064C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 11:27:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC72E600CC
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 11:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC72E600CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43D8A4B32D;
	Tue, 23 Mar 2021 07:27:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yy6t88mr6QZ8; Tue, 23 Mar 2021 07:26:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7D004B306;
	Tue, 23 Mar 2021 07:26:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79B794B128
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 21:28:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YhgbHaSRKIV8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 21:28:48 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F339E4B11D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 21:28:47 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F4DHB1G3YzwPJl;
 Tue, 23 Mar 2021 09:26:46 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Tue, 23 Mar 2021
 09:28:35 +0800
Subject: Re: [Linuxarm] Re: [PATCH v14 07/13] iommu/smmuv3: Implement
 cache_invalidate
To: Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
 <maz@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
 <alex.williamson@redhat.com>, <tn@semihalf.com>, <zhukeqian1@huawei.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-8-eric.auger@redhat.com>
 <c10c6405-5efe-5a41-2b3a-f3af85a528ba@hisilicon.com>
 <d5dcb7fe-2e09-b1fb-24d6-36249f047632@redhat.com>
 <1cf3fa95-45c6-5846-e1c2-12c222ebed46@hisilicon.com>
 <a691418f-5aa8-1d02-3519-732b39cd91cb@redhat.com>
From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <15938ed5-2095-e903-a290-333c299015a2@hisilicon.com>
Date: Tue, 23 Mar 2021 09:28:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <a691418f-5aa8-1d02-3519-732b39cd91cb@redhat.com>
X-Originating-IP: [10.40.193.166]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Tue, 23 Mar 2021 07:26:56 -0400
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgRXJpYywKCgrlnKggMjAyMS8zLzIyIDE3OjA1LCBBdWdlciBFcmljIOWGmemBkzoKPiBIaSBD
aGVueGlhbmcsCj4KPiBPbiAzLzIyLzIxIDc6NDAgQU0sIGNoZW54aWFuZyAoTSkgd3JvdGU6Cj4+
IEhpIEVyaWMsCj4+Cj4+Cj4+IOWcqCAyMDIxLzMvMjAgMTozNiwgQXVnZXIgRXJpYyDlhpnpgZM6
Cj4+PiBIaSBDaGVueGlhbmcsCj4+Pgo+Pj4gT24gMy80LzIxIDg6NTUgQU0sIGNoZW54aWFuZyAo
TSkgd3JvdGU6Cj4+Pj4gSGkgRXJpYywKPj4+Pgo+Pj4+Cj4+Pj4g5ZyoIDIwMjEvMi8yNCA0OjU2
LCBFcmljIEF1Z2VyIOWGmemBkzoKPj4+Pj4gSW1wbGVtZW50IGRvbWFpbi1zZWxlY3RpdmUsIHBh
c2lkIHNlbGVjdGl2ZSBhbmQgcGFnZS1zZWxlY3RpdmUKPj4+Pj4gSU9UTEIgaW52YWxpZGF0aW9u
cy4KPj4+Pj4KPj4+Pj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRo
YXQuY29tPgo+Pj4+Pgo+Pj4+PiAtLS0KPj4+Pj4KPj4+Pj4gdjEzIC0+IHYxNDoKPj4+Pj4gLSBB
ZGQgZG9tYWluIGludmFsaWRhdGlvbgo+Pj4+PiAtIGRvIGdsb2JhbCBpbnZhbCB3aGVuIGFzaWQg
aXMgbm90IHByb3ZpZGVkIHdpdGggYWRkcgo+Pj4+PiAgICAgZ3JhbnVsYXJpdHkKPj4+Pj4KPj4+
Pj4gdjcgLT4gdjg6Cj4+Pj4+IC0gQVNJRCBiYXNlZCBpbnZhbGlkYXRpb24gdXNpbmcgaW9tbXVf
aW52X3Bhc2lkX2luZm8KPj4+Pj4gLSBjaGVjayBBUkNISUQvUEFTSUQgZmxhZ3MgaW4gYWRkciBi
YXNlZCBpbnZhbGlkYXRpb24KPj4+Pj4gLSB1c2UgX19hcm1fc21tdV90bGJfaW52X2NvbnRleHQg
YW5kIF9fYXJtX3NtbXVfdGxiX2ludl9yYW5nZV9ub3N5bmMKPj4+Pj4KPj4+Pj4gdjYgLT4gdjcK
Pj4+Pj4gLSBjaGVjayB0aGUgdWFwaSB2ZXJzaW9uCj4+Pj4+Cj4+Pj4+IHYzIC0+IHY0Ogo+Pj4+
PiAtIGFkYXB0IHRvIGNoYW5nZXMgaW4gdGhlIHVhcGkKPj4+Pj4gLSBhZGQgc3VwcG9ydCBmb3Ig
bGVhZiBwYXJhbWV0ZXIKPj4+Pj4gLSBkbyBub3QgdXNlIGFybV9zbW11X3RsYl9pbnZfcmFuZ2Vf
bm9zeW5jIG9yIGFybV9zbW11X3RsYl9pbnZfY29udGV4dAo+Pj4+PiAgICAgYW55bW9yZQo+Pj4+
Pgo+Pj4+PiB2MiAtPiB2MzoKPj4+Pj4gLSByZXBsYWNlIF9fYXJtX3NtbXVfdGxiX3N5bmMgYnkg
YXJtX3NtbXVfY21kcV9pc3N1ZV9zeW5jCj4+Pj4+Cj4+Pj4+IHYxIC0+IHYyOgo+Pj4+PiAtIHBy
b3Blcmx5IHBhc3MgdGhlIGFzaWQKPj4+Pj4gLS0tCj4+Pj4+ICAgIGRyaXZlcnMvaW9tbXUvYXJt
L2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMgfCA3NAo+Pj4+PiArKysrKysrKysrKysrKysrKysr
KysKPj4+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDc0IGluc2VydGlvbnMoKykKPj4+Pj4KPj4+Pj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMK
Pj4+Pj4gYi9kcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jCj4+Pj4+
IGluZGV4IDRjMTlhMTExNGRlNC4uZGYzYWRjNDkxMTFjIDEwMDY0NAo+Pj4+PiAtLS0gYS9kcml2
ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jCj4+Pj4+ICsrKyBiL2RyaXZl
cnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMKPj4+Pj4gQEAgLTI5NDksNiAr
Mjk0OSw3OSBAQCBzdGF0aWMgdm9pZAo+Pj4+PiBhcm1fc21tdV9kZXRhY2hfcGFzaWRfdGFibGUo
c3RydWN0IGlvbW11X2RvbWFpbiAqZG9tYWluKQo+Pj4+PiAgICAgICAgbXV0ZXhfdW5sb2NrKCZz
bW11X2RvbWFpbi0+aW5pdF9tdXRleCk7Cj4+Pj4+ICAgIH0KPj4+Pj4gICAgK3N0YXRpYyBpbnQK
Pj4+Pj4gK2FybV9zbW11X2NhY2hlX2ludmFsaWRhdGUoc3RydWN0IGlvbW11X2RvbWFpbiAqZG9t
YWluLCBzdHJ1Y3QKPj4+Pj4gZGV2aWNlICpkZXYsCj4+Pj4+ICsgICAgICAgICAgICAgIHN0cnVj
dCBpb21tdV9jYWNoZV9pbnZhbGlkYXRlX2luZm8gKmludl9pbmZvKQo+Pj4+PiArewo+Pj4+PiAr
ICAgIHN0cnVjdCBhcm1fc21tdV9jbWRxX2VudCBjbWQgPSB7Lm9wY29kZSA9IENNRFFfT1BfVExC
SV9OU05IX0FMTH07Cj4+Pj4+ICsgICAgc3RydWN0IGFybV9zbW11X2RvbWFpbiAqc21tdV9kb21h
aW4gPSB0b19zbW11X2RvbWFpbihkb21haW4pOwo+Pj4+PiArICAgIHN0cnVjdCBhcm1fc21tdV9k
ZXZpY2UgKnNtbXUgPSBzbW11X2RvbWFpbi0+c21tdTsKPj4+Pj4gKwo+Pj4+PiArICAgIGlmIChz
bW11X2RvbWFpbi0+c3RhZ2UgIT0gQVJNX1NNTVVfRE9NQUlOX05FU1RFRCkKPj4+Pj4gKyAgICAg
ICAgcmV0dXJuIC1FSU5WQUw7Cj4+Pj4+ICsKPj4+Pj4gKyAgICBpZiAoIXNtbXUpCj4+Pj4+ICsg
ICAgICAgIHJldHVybiAtRUlOVkFMOwo+Pj4+PiArCj4+Pj4+ICsgICAgaWYgKGludl9pbmZvLT52
ZXJzaW9uICE9IElPTU1VX0NBQ0hFX0lOVkFMSURBVEVfSU5GT19WRVJTSU9OXzEpCj4+Pj4+ICsg
ICAgICAgIHJldHVybiAtRUlOVkFMOwo+Pj4+PiArCj4+Pj4+ICsgICAgaWYgKGludl9pbmZvLT5j
YWNoZSAmIElPTU1VX0NBQ0hFX0lOVl9UWVBFX1BBU0lEIHx8Cj4+Pj4+ICsgICAgICAgIGludl9p
bmZvLT5jYWNoZSAmIElPTU1VX0NBQ0hFX0lOVl9UWVBFX0RFVl9JT1RMQikgewo+Pj4+PiArICAg
ICAgICByZXR1cm4gLUVOT0VOVDsKPj4+Pj4gKyAgICB9Cj4+Pj4+ICsKPj4+Pj4gKyAgICBpZiAo
IShpbnZfaW5mby0+Y2FjaGUgJiBJT01NVV9DQUNIRV9JTlZfVFlQRV9JT1RMQikpCj4+Pj4+ICsg
ICAgICAgIHJldHVybiAtRUlOVkFMOwo+Pj4+PiArCj4+Pj4+ICsgICAgLyogSU9UTEIgaW52YWxp
ZGF0aW9uICovCj4+Pj4+ICsKPj4+Pj4gKyAgICBzd2l0Y2ggKGludl9pbmZvLT5ncmFudWxhcml0
eSkgewo+Pj4+PiArICAgIGNhc2UgSU9NTVVfSU5WX0dSQU5VX1BBU0lEOgo+Pj4+PiArICAgIHsK
Pj4+Pj4gKyAgICAgICAgc3RydWN0IGlvbW11X2ludl9wYXNpZF9pbmZvICppbmZvID0KPj4+Pj4g
KyAgICAgICAgICAgICZpbnZfaW5mby0+Z3JhbnUucGFzaWRfaW5mbzsKPj4+Pj4gKwo+Pj4+PiAr
ICAgICAgICBpZiAoaW5mby0+ZmxhZ3MgJiBJT01NVV9JTlZfQUREUl9GTEFHU19QQVNJRCkKPj4+
Pj4gKyAgICAgICAgICAgIHJldHVybiAtRU5PRU5UOwo+Pj4+PiArICAgICAgICBpZiAoIShpbmZv
LT5mbGFncyAmIElPTU1VX0lOVl9QQVNJRF9GTEFHU19BUkNISUQpKQo+Pj4+PiArICAgICAgICAg
ICAgcmV0dXJuIC1FSU5WQUw7Cj4+Pj4+ICsKPj4+Pj4gKyAgICAgICAgX19hcm1fc21tdV90bGJf
aW52X2NvbnRleHQoc21tdV9kb21haW4sIGluZm8tPmFyY2hpZCk7Cj4+Pj4+ICsgICAgICAgIHJl
dHVybiAwOwo+Pj4+PiArICAgIH0KPj4+Pj4gKyAgICBjYXNlIElPTU1VX0lOVl9HUkFOVV9BRERS
Ogo+Pj4+PiArICAgIHsKPj4+Pj4gKyAgICAgICAgc3RydWN0IGlvbW11X2ludl9hZGRyX2luZm8g
KmluZm8gPSAmaW52X2luZm8tPmdyYW51LmFkZHJfaW5mbzsKPj4+Pj4gKyAgICAgICAgc2l6ZV90
IHNpemUgPSBpbmZvLT5uYl9ncmFudWxlcyAqIGluZm8tPmdyYW51bGVfc2l6ZTsKPj4+Pj4gKyAg
ICAgICAgYm9vbCBsZWFmID0gaW5mby0+ZmxhZ3MgJiBJT01NVV9JTlZfQUREUl9GTEFHU19MRUFG
Owo+Pj4+PiArCj4+Pj4+ICsgICAgICAgIGlmIChpbmZvLT5mbGFncyAmIElPTU1VX0lOVl9BRERS
X0ZMQUdTX1BBU0lEKQo+Pj4+PiArICAgICAgICAgICAgcmV0dXJuIC1FTk9FTlQ7Cj4+Pj4+ICsK
Pj4+Pj4gKyAgICAgICAgaWYgKCEoaW5mby0+ZmxhZ3MgJiBJT01NVV9JTlZfQUREUl9GTEFHU19B
UkNISUQpKQo+Pj4+PiArICAgICAgICAgICAgYnJlYWs7Cj4+Pj4+ICsKPj4+Pj4gKyAgICAgICAg
YXJtX3NtbXVfdGxiX2ludl9yYW5nZV9kb21haW4oaW5mby0+YWRkciwgc2l6ZSwKPj4+Pj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgaW5mby0+Z3JhbnVsZV9zaXplLCBsZWFmLAo+Pj4+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICBpbmZvLT5hcmNoaWQsIHNtbXVfZG9tYWluKTsKPj4+
PiBJcyBpdCBwb3NzaWJsZSB0byBhZGQgYSBjaGVjayBiZWZvcmUgdGhlIGZ1bmN0aW9uIHRvIG1h
a2Ugc3VyZSB0aGF0Cj4+Pj4gaW5mby0+Z3JhbnVsZV9zaXplIGNhbiBiZSByZWNvZ25pemVkIGJ5
IFNNTVU/Cj4+Pj4gVGhlcmUgaXMgYSBzY2VuYXJpbyB3aGljaCB3aWxsIGNhdXNlIFRMQkkgaXNz
dWU6IFJJTCBmZWF0dXJlIGlzIGVuYWJsZWQKPj4+PiBvbiBndWVzdCBidXQgaXMgZGlzYWJsZWQg
b24gaG9zdCwgYW5kIHRoZW4gb24KPj4+PiBob3N0IGl0IGp1c3QgaW52YWxpZGF0ZSA0Sy8yTS8x
RyBvbmNlIGEgdGltZSwgYnV0IGZyb20gUUVNVSwKPj4+PiBpbmZvLT5uYl9ncmFudWxlcyBpcyBh
bHdheXMgMSBhbmQgaW5mby0+Z3JhbnVsZV9zaXplID0gc2l6ZSwKPj4+PiBpZiBzaXplIGlzIG5v
dCBlcXVhbCB0byA0SyBvciAyTSBvciAxRyAoZm9yIGV4YW1wbGUgc2l6ZSA9IGdyYW51bGVfc2l6
ZQo+Pj4+IGlzIDVNKSwgaXQgd2lsbCBvbmx5IHBhcnQgb2YgdGhlIHNpemUgaXQgd2FudHMgdG8g
aW52YWxpZGF0ZS4KPj4gRG8geW91IGhhdmUgYW55IGlkZWEgYWJvdXQgdGhpcyBpc3N1ZT8KPiBB
dCB0aGUgUUVNVSBWRklPIG5vdGlmaWVyIGxldmVsLCB3aGVuIEkgZmlsbCB0aGUgc3RydWN0Cj4g
aW9tbXVfY2FjaGVfaW52YWxpZGF0ZV9pbmZvLCBJIGN1cnJlbnRseSBtaXNzIHRoZSBncmFudWxl
IGluZm8sIGhlbmNlCj4gdGhpcyB3ZWlyZCBjaG9pY2Ugb2Ygc2V0dGluZyBzZXR0aW5nIGluZm8t
Pm5iX2dyYW51bGVzIGlzIGFsd2F5cyAxIGFuZAo+IGluZm8tPmdyYW51bGVfc2l6ZSA9IHNpemUu
IEkgdGhpbmsgaW4gYXJtX3NtbXVfY2FjaGVfaW52YWxpZGF0ZSgpIEkgbmVlZAo+IHRvIGNvbnZl
cnQgdGhpcyBpbmZvIGJhY2sgdG8gYSB0aGUgbGVhZiBwYWdlIHNpemUsIGluIGNhc2UgdGhlIGhv
c3QgZG9lcwo+IG5vdCBzdXBwb3J0IFJJTC4gSnVzdCBhcyBpdCBpcyBkb25lIGluICBfX2FybV9z
bW11X3RsYl9pbnZfcmFuZ2UgaWYgUklMCj4gaXMgc3VwcG9ydGVkLgo+Cj4gRG9lcyBpdCBtYWtl
cyBzZW5zZSB0byB5b3U/CgpZZXMsIGl0IG1ha2VzIHNlbnNlIHRvIG1lLgpJIGFtIGdsYWQgdG8g
dGVzdCB0aGVtIGlmIHRoZSBwYXRjaHNldCBhcmUgcmVhZHkuCgoKPgo+IFRoYW5rIHlvdSBmb3Ig
c3BvdHRpbmcgdGhlIGlzc3VlLgo+Cj4gRXJpYwo+Pj4+IEkgdGhpbmsgbWF5YmUgd2UgY2FuIGFk
ZCBhIGNoZWNrIGhlcmU6IGlmIFJJTCBpcyBub3QgZW5hYmxlZCBhbmQgYWxzbwo+Pj4+IHNpemUg
aXMgbm90IHRoZSBncmFudWxlX3NpemUgKDRLLzJNLzFHKSBzdXBwb3J0ZWQgYnkKPj4+PiBTTU1V
IGhhcmR3YXJlLCBjYW4gd2UganVzdCBzaW1wbHkgdXNlIHRoZSBzbWFsbGVzdCBncmFudWxlX3Np
emUKPj4+PiBzdXBwb3J0ZWQgYnkgaGFyZHdhcmUgYWxsIHRoZSB0aW1lPwo+Pj4+Cj4+Pj4+ICsK
Pj4+Pj4gKyAgICAgICAgYXJtX3NtbXVfY21kcV9pc3N1ZV9zeW5jKHNtbXUpOwo+Pj4+PiArICAg
ICAgICByZXR1cm4gMDsKPj4+Pj4gKyAgICB9Cj4+Pj4+ICsgICAgY2FzZSBJT01NVV9JTlZfR1JB
TlVfRE9NQUlOOgo+Pj4+PiArICAgICAgICBicmVhazsKPj4+PiBJIGNoZWNrIHRoZSBxZW11IGNv
ZGUKPj4+PiAoaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9xZW11L3RyZWUvdjUuMi4wLTJzdGFn
ZS1yZmN2OCksIGZvciBvcGNvZGUKPj4+PiBDTURfVExCSV9OSF9BTEwgb3IgQ01EX1RMQklfTlNO
SF9BTEwgZnJvbSBndWVzdCBPUwo+Pj4+IGl0IGNhbGxzIHNtbXVfaW52X25vdGlmaWVyc19hbGwo
KSB0byB1bmFtcCBhbGwgbm90aWZpZXJzIG9mIGFsbCBtcidzLAo+Pj4+IGJ1dCBpdCBzZWVtcyBu
b3Qgc2V0IGV2ZW50LmVudHJ5LmdyYW51bGFyaXR5IHdoaWNoIGkgdGhpbmsgaXQgc2hvdWxkIHNl
dAo+Pj4+IElPTU1VX0lOVl9HUkFOX0FERFIuCj4+PiB0aGlzIGlzIGJlY2F1c2UgSU9NTVVfSU5W
X0dSQU5fQUREUiA9IDAuIEJ1dCBmb3IgY2xhcml0eSBJIHNob3VsZCByYXRoZXIKPj4+IHNldCBp
dCBleHBsaWNpdGx5IDstKQo+PiBvawo+Pgo+Pj4+IEJUVywgZm9yIG9wY29kZSBDTURfVExCSV9O
SF9BTEwgb3IgQ01EX1RMQklfTlNOSF9BTEwsIGl0IG5lZWRzIHRvIHVubWFwCj4+Pj4gc2l6ZSA9
IDB4MTAwMDAwMDAwMDAwMCBvbiA0OGJpdCBzeXN0ZW0gKGl0IG1heSBzcGVuZCBtdWNoIHRpbWUp
LCAgbWF5YmUKPj4+PiBpdCBpcyBiZXR0ZXIKPj4+PiB0byBzZXQgaXQgYXMgSU9NTVVfSU5WX0dS
QU5VX0RPTUFJTiwgdGhlbiBpbiBob3N0IE9TLCBzZW5kIFRMQklfTkhfQUxMCj4+Pj4gZGlyZWN0
bHkgd2hlbiBJT01NVV9JTlZfR1JBTlVfRE9NQUlOLgo+Pj4gWWVzIHlvdSdyZSByaWdodC4gSWYg
dGhlIGhvc3QgZG9lcyBub3Qgc3VwcG9ydCBSSUwgdGhlbiBpdCBpcyBhbiBpc3N1ZS4KPj4+IFRo
aXMgaXMgZ29pbmcgdG8gYmUgZml4ZWQgaW4gdGhlIG5leHQgdmVyc2lvbi4KPj4gR3JlYXQKPj4K
Pj4+IFRoYW5rIHlvdSBmb3IgdGhlIHJlcG9ydCEKPj4+Cj4+PiBCZXN0IFJlZ2FyZHMKPj4+Cj4+
PiBFcmljCj4+Pj4+ICsgICAgZGVmYXVsdDoKPj4+Pj4gKyAgICAgICAgcmV0dXJuIC1FSU5WQUw7
Cj4+Pj4+ICsgICAgfQo+Pj4+PiArCj4+Pj4+ICsgICAgLyogR2xvYmFsIFMxIGludmFsaWRhdGlv
biAqLwo+Pj4+PiArICAgIGNtZC50bGJpLnZtaWQgICA9IHNtbXVfZG9tYWluLT5zMl9jZmcudm1p
ZDsKPj4+Pj4gKyAgICBhcm1fc21tdV9jbWRxX2lzc3VlX2NtZChzbW11LCAmY21kKTsKPj4+Pj4g
KyAgICBhcm1fc21tdV9jbWRxX2lzc3VlX3N5bmMoc21tdSk7Cj4+Pj4+ICsgICAgcmV0dXJuIDA7
Cj4+Pj4+ICt9Cj4+Pj4+ICsKPj4+Pj4gICAgc3RhdGljIGJvb2wgYXJtX3NtbXVfZGV2X2hhc19m
ZWF0dXJlKHN0cnVjdCBkZXZpY2UgKmRldiwKPj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAg
ZW51bSBpb21tdV9kZXZfZmVhdHVyZXMgZmVhdCkKPj4+Pj4gICAgewo+Pj4+PiBAQCAtMzA0OCw2
ICszMTIxLDcgQEAgc3RhdGljIHN0cnVjdCBpb21tdV9vcHMgYXJtX3NtbXVfb3BzID0gewo+Pj4+
PiAgICAgICAgLnB1dF9yZXN2X3JlZ2lvbnMgICAgPSBnZW5lcmljX2lvbW11X3B1dF9yZXN2X3Jl
Z2lvbnMsCj4+Pj4+ICAgICAgICAuYXR0YWNoX3Bhc2lkX3RhYmxlICAgID0gYXJtX3NtbXVfYXR0
YWNoX3Bhc2lkX3RhYmxlLAo+Pj4+PiAgICAgICAgLmRldGFjaF9wYXNpZF90YWJsZSAgICA9IGFy
bV9zbW11X2RldGFjaF9wYXNpZF90YWJsZSwKPj4+Pj4gKyAgICAuY2FjaGVfaW52YWxpZGF0ZSAg
ICA9IGFybV9zbW11X2NhY2hlX2ludmFsaWRhdGUsCj4+Pj4+ICAgICAgICAuZGV2X2hhc19mZWF0
ICAgICAgICA9IGFybV9zbW11X2Rldl9oYXNfZmVhdHVyZSwKPj4+Pj4gICAgICAgIC5kZXZfZmVh
dF9lbmFibGVkICAgID0gYXJtX3NtbXVfZGV2X2ZlYXR1cmVfZW5hYmxlZCwKPj4+Pj4gICAgICAg
IC5kZXZfZW5hYmxlX2ZlYXQgICAgPSBhcm1fc21tdV9kZXZfZW5hYmxlX2ZlYXR1cmUsCj4+PiBf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+Pj4gTGludXhh
cm0gbWFpbGluZyBsaXN0IC0tIGxpbnV4YXJtQG9wZW5ldWxlci5vcmcKPj4+IFRvIHVuc3Vic2Ny
aWJlIHNlbmQgYW4gZW1haWwgdG8gbGludXhhcm0tbGVhdmVAb3BlbmV1bGVyLm9yZwo+Pgo+Cj4g
Lgo+CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
