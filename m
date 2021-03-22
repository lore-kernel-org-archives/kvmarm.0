Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085D1C433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4937861969
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4937861969
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABB194B252;
	Mon, 22 Mar 2021 06:01:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vLH4fGwkSTP6; Mon, 22 Mar 2021 06:01:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D325E4B2AD;
	Mon, 22 Mar 2021 06:01:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED8374B371
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:41:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cua7fgkfXeAR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 02:41:04 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F9C44B36F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:41:00 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F3lFs6xPxzwPYL;
 Mon, 22 Mar 2021 14:38:57 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Mon, 22 Mar 2021
 14:40:47 +0800
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
From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <1cf3fa95-45c6-5846-e1c2-12c222ebed46@hisilicon.com>
Date: Mon, 22 Mar 2021 14:40:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <d5dcb7fe-2e09-b1fb-24d6-36249f047632@redhat.com>
X-Originating-IP: [10.40.193.166]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Mon, 22 Mar 2021 06:01:05 -0400
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

SGkgRXJpYywKCgrlnKggMjAyMS8zLzIwIDE6MzYsIEF1Z2VyIEVyaWMg5YaZ6YGTOgo+IEhpIENo
ZW54aWFuZywKPgo+IE9uIDMvNC8yMSA4OjU1IEFNLCBjaGVueGlhbmcgKE0pIHdyb3RlOgo+PiBI
aSBFcmljLAo+Pgo+Pgo+PiDlnKggMjAyMS8yLzI0IDQ6NTYsIEVyaWMgQXVnZXIg5YaZ6YGTOgo+
Pj4gSW1wbGVtZW50IGRvbWFpbi1zZWxlY3RpdmUsIHBhc2lkIHNlbGVjdGl2ZSBhbmQgcGFnZS1z
ZWxlY3RpdmUKPj4+IElPVExCIGludmFsaWRhdGlvbnMuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTog
RXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+Pj4KPj4+IC0tLQo+Pj4KPj4+IHYx
MyAtPiB2MTQ6Cj4+PiAtIEFkZCBkb21haW4gaW52YWxpZGF0aW9uCj4+PiAtIGRvIGdsb2JhbCBp
bnZhbCB3aGVuIGFzaWQgaXMgbm90IHByb3ZpZGVkIHdpdGggYWRkcgo+Pj4gICAgZ3JhbnVsYXJp
dHkKPj4+Cj4+PiB2NyAtPiB2ODoKPj4+IC0gQVNJRCBiYXNlZCBpbnZhbGlkYXRpb24gdXNpbmcg
aW9tbXVfaW52X3Bhc2lkX2luZm8KPj4+IC0gY2hlY2sgQVJDSElEL1BBU0lEIGZsYWdzIGluIGFk
ZHIgYmFzZWQgaW52YWxpZGF0aW9uCj4+PiAtIHVzZSBfX2FybV9zbW11X3RsYl9pbnZfY29udGV4
dCBhbmQgX19hcm1fc21tdV90bGJfaW52X3JhbmdlX25vc3luYwo+Pj4KPj4+IHY2IC0+IHY3Cj4+
PiAtIGNoZWNrIHRoZSB1YXBpIHZlcnNpb24KPj4+Cj4+PiB2MyAtPiB2NDoKPj4+IC0gYWRhcHQg
dG8gY2hhbmdlcyBpbiB0aGUgdWFwaQo+Pj4gLSBhZGQgc3VwcG9ydCBmb3IgbGVhZiBwYXJhbWV0
ZXIKPj4+IC0gZG8gbm90IHVzZSBhcm1fc21tdV90bGJfaW52X3JhbmdlX25vc3luYyBvciBhcm1f
c21tdV90bGJfaW52X2NvbnRleHQKPj4+ICAgIGFueW1vcmUKPj4+Cj4+PiB2MiAtPiB2MzoKPj4+
IC0gcmVwbGFjZSBfX2FybV9zbW11X3RsYl9zeW5jIGJ5IGFybV9zbW11X2NtZHFfaXNzdWVfc3lu
Ywo+Pj4KPj4+IHYxIC0+IHYyOgo+Pj4gLSBwcm9wZXJseSBwYXNzIHRoZSBhc2lkCj4+PiAtLS0K
Pj4+ICAgZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYyB8IDc0ICsr
KysrKysrKysrKysrKysrKysrKwo+Pj4gICAxIGZpbGUgY2hhbmdlZCwgNzQgaW5zZXJ0aW9ucygr
KQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0t
c21tdS12My5jIGIvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYwo+
Pj4gaW5kZXggNGMxOWExMTE0ZGU0Li5kZjNhZGM0OTExMWMgMTAwNjQ0Cj4+PiAtLS0gYS9kcml2
ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jCj4+PiArKysgYi9kcml2ZXJz
L2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jCj4+PiBAQCAtMjk0OSw2ICsyOTQ5
LDc5IEBAIHN0YXRpYyB2b2lkIGFybV9zbW11X2RldGFjaF9wYXNpZF90YWJsZShzdHJ1Y3QgaW9t
bXVfZG9tYWluICpkb21haW4pCj4+PiAgIAltdXRleF91bmxvY2soJnNtbXVfZG9tYWluLT5pbml0
X211dGV4KTsKPj4+ICAgfQo+Pj4gICAKPj4+ICtzdGF0aWMgaW50Cj4+PiArYXJtX3NtbXVfY2Fj
aGVfaW52YWxpZGF0ZShzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sIHN0cnVjdCBkZXZpY2Ug
KmRldiwKPj4+ICsJCQkgIHN0cnVjdCBpb21tdV9jYWNoZV9pbnZhbGlkYXRlX2luZm8gKmludl9p
bmZvKQo+Pj4gK3sKPj4+ICsJc3RydWN0IGFybV9zbW11X2NtZHFfZW50IGNtZCA9IHsub3Bjb2Rl
ID0gQ01EUV9PUF9UTEJJX05TTkhfQUxMfTsKPj4+ICsJc3RydWN0IGFybV9zbW11X2RvbWFpbiAq
c21tdV9kb21haW4gPSB0b19zbW11X2RvbWFpbihkb21haW4pOwo+Pj4gKwlzdHJ1Y3QgYXJtX3Nt
bXVfZGV2aWNlICpzbW11ID0gc21tdV9kb21haW4tPnNtbXU7Cj4+PiArCj4+PiArCWlmIChzbW11
X2RvbWFpbi0+c3RhZ2UgIT0gQVJNX1NNTVVfRE9NQUlOX05FU1RFRCkKPj4+ICsJCXJldHVybiAt
RUlOVkFMOwo+Pj4gKwo+Pj4gKwlpZiAoIXNtbXUpCj4+PiArCQlyZXR1cm4gLUVJTlZBTDsKPj4+
ICsKPj4+ICsJaWYgKGludl9pbmZvLT52ZXJzaW9uICE9IElPTU1VX0NBQ0hFX0lOVkFMSURBVEVf
SU5GT19WRVJTSU9OXzEpCj4+PiArCQlyZXR1cm4gLUVJTlZBTDsKPj4+ICsKPj4+ICsJaWYgKGlu
dl9pbmZvLT5jYWNoZSAmIElPTU1VX0NBQ0hFX0lOVl9UWVBFX1BBU0lEIHx8Cj4+PiArCSAgICBp
bnZfaW5mby0+Y2FjaGUgJiBJT01NVV9DQUNIRV9JTlZfVFlQRV9ERVZfSU9UTEIpIHsKPj4+ICsJ
CXJldHVybiAtRU5PRU5UOwo+Pj4gKwl9Cj4+PiArCj4+PiArCWlmICghKGludl9pbmZvLT5jYWNo
ZSAmIElPTU1VX0NBQ0hFX0lOVl9UWVBFX0lPVExCKSkKPj4+ICsJCXJldHVybiAtRUlOVkFMOwo+
Pj4gKwo+Pj4gKwkvKiBJT1RMQiBpbnZhbGlkYXRpb24gKi8KPj4+ICsKPj4+ICsJc3dpdGNoIChp
bnZfaW5mby0+Z3JhbnVsYXJpdHkpIHsKPj4+ICsJY2FzZSBJT01NVV9JTlZfR1JBTlVfUEFTSUQ6
Cj4+PiArCXsKPj4+ICsJCXN0cnVjdCBpb21tdV9pbnZfcGFzaWRfaW5mbyAqaW5mbyA9Cj4+PiAr
CQkJJmludl9pbmZvLT5ncmFudS5wYXNpZF9pbmZvOwo+Pj4gKwo+Pj4gKwkJaWYgKGluZm8tPmZs
YWdzICYgSU9NTVVfSU5WX0FERFJfRkxBR1NfUEFTSUQpCj4+PiArCQkJcmV0dXJuIC1FTk9FTlQ7
Cj4+PiArCQlpZiAoIShpbmZvLT5mbGFncyAmIElPTU1VX0lOVl9QQVNJRF9GTEFHU19BUkNISUQp
KQo+Pj4gKwkJCXJldHVybiAtRUlOVkFMOwo+Pj4gKwo+Pj4gKwkJX19hcm1fc21tdV90bGJfaW52
X2NvbnRleHQoc21tdV9kb21haW4sIGluZm8tPmFyY2hpZCk7Cj4+PiArCQlyZXR1cm4gMDsKPj4+
ICsJfQo+Pj4gKwljYXNlIElPTU1VX0lOVl9HUkFOVV9BRERSOgo+Pj4gKwl7Cj4+PiArCQlzdHJ1
Y3QgaW9tbXVfaW52X2FkZHJfaW5mbyAqaW5mbyA9ICZpbnZfaW5mby0+Z3JhbnUuYWRkcl9pbmZv
Owo+Pj4gKwkJc2l6ZV90IHNpemUgPSBpbmZvLT5uYl9ncmFudWxlcyAqIGluZm8tPmdyYW51bGVf
c2l6ZTsKPj4+ICsJCWJvb2wgbGVhZiA9IGluZm8tPmZsYWdzICYgSU9NTVVfSU5WX0FERFJfRkxB
R1NfTEVBRjsKPj4+ICsKPj4+ICsJCWlmIChpbmZvLT5mbGFncyAmIElPTU1VX0lOVl9BRERSX0ZM
QUdTX1BBU0lEKQo+Pj4gKwkJCXJldHVybiAtRU5PRU5UOwo+Pj4gKwo+Pj4gKwkJaWYgKCEoaW5m
by0+ZmxhZ3MgJiBJT01NVV9JTlZfQUREUl9GTEFHU19BUkNISUQpKQo+Pj4gKwkJCWJyZWFrOwo+
Pj4gKwo+Pj4gKwkJYXJtX3NtbXVfdGxiX2ludl9yYW5nZV9kb21haW4oaW5mby0+YWRkciwgc2l6
ZSwKPj4+ICsJCQkJCSAgICAgIGluZm8tPmdyYW51bGVfc2l6ZSwgbGVhZiwKPj4+ICsJCQkJCSAg
ICAgIGluZm8tPmFyY2hpZCwgc21tdV9kb21haW4pOwo+PiBJcyBpdCBwb3NzaWJsZSB0byBhZGQg
YSBjaGVjayBiZWZvcmUgdGhlIGZ1bmN0aW9uIHRvIG1ha2Ugc3VyZSB0aGF0Cj4+IGluZm8tPmdy
YW51bGVfc2l6ZSBjYW4gYmUgcmVjb2duaXplZCBieSBTTU1VPwo+PiBUaGVyZSBpcyBhIHNjZW5h
cmlvIHdoaWNoIHdpbGwgY2F1c2UgVExCSSBpc3N1ZTogUklMIGZlYXR1cmUgaXMgZW5hYmxlZAo+
PiBvbiBndWVzdCBidXQgaXMgZGlzYWJsZWQgb24gaG9zdCwgYW5kIHRoZW4gb24KPj4gaG9zdCBp
dCBqdXN0IGludmFsaWRhdGUgNEsvMk0vMUcgb25jZSBhIHRpbWUsIGJ1dCBmcm9tIFFFTVUsCj4+
IGluZm8tPm5iX2dyYW51bGVzIGlzIGFsd2F5cyAxIGFuZCBpbmZvLT5ncmFudWxlX3NpemUgPSBz
aXplLAo+PiBpZiBzaXplIGlzIG5vdCBlcXVhbCB0byA0SyBvciAyTSBvciAxRyAoZm9yIGV4YW1w
bGUgc2l6ZSA9IGdyYW51bGVfc2l6ZQo+PiBpcyA1TSksIGl0IHdpbGwgb25seSBwYXJ0IG9mIHRo
ZSBzaXplIGl0IHdhbnRzIHRvIGludmFsaWRhdGUuCgpEbyB5b3UgaGF2ZSBhbnkgaWRlYSBhYm91
dCB0aGlzIGlzc3VlPwoKPj4KPj4gSSB0aGluayBtYXliZSB3ZSBjYW4gYWRkIGEgY2hlY2sgaGVy
ZTogaWYgUklMIGlzIG5vdCBlbmFibGVkIGFuZCBhbHNvCj4+IHNpemUgaXMgbm90IHRoZSBncmFu
dWxlX3NpemUgKDRLLzJNLzFHKSBzdXBwb3J0ZWQgYnkKPj4gU01NVSBoYXJkd2FyZSwgY2FuIHdl
IGp1c3Qgc2ltcGx5IHVzZSB0aGUgc21hbGxlc3QgZ3JhbnVsZV9zaXplCj4+IHN1cHBvcnRlZCBi
eSBoYXJkd2FyZSBhbGwgdGhlIHRpbWU/Cj4+Cj4+PiArCj4+PiArCQlhcm1fc21tdV9jbWRxX2lz
c3VlX3N5bmMoc21tdSk7Cj4+PiArCQlyZXR1cm4gMDsKPj4+ICsJfQo+Pj4gKwljYXNlIElPTU1V
X0lOVl9HUkFOVV9ET01BSU46Cj4+PiArCQlicmVhazsKPj4gSSBjaGVjayB0aGUgcWVtdSBjb2Rl
Cj4+IChodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL3FlbXUvdHJlZS92NS4yLjAtMnN0YWdlLXJm
Y3Y4KSwgZm9yIG9wY29kZQo+PiBDTURfVExCSV9OSF9BTEwgb3IgQ01EX1RMQklfTlNOSF9BTEwg
ZnJvbSBndWVzdCBPUwo+PiBpdCBjYWxscyBzbW11X2ludl9ub3RpZmllcnNfYWxsKCkgdG8gdW5h
bXAgYWxsIG5vdGlmaWVycyBvZiBhbGwgbXIncywKPj4gYnV0IGl0IHNlZW1zIG5vdCBzZXQgZXZl
bnQuZW50cnkuZ3JhbnVsYXJpdHkgd2hpY2ggaSB0aGluayBpdCBzaG91bGQgc2V0Cj4+IElPTU1V
X0lOVl9HUkFOX0FERFIuCj4gdGhpcyBpcyBiZWNhdXNlIElPTU1VX0lOVl9HUkFOX0FERFIgPSAw
LiBCdXQgZm9yIGNsYXJpdHkgSSBzaG91bGQgcmF0aGVyCj4gc2V0IGl0IGV4cGxpY2l0bHkgOy0p
CgpvawoKPj4gQlRXLCBmb3Igb3Bjb2RlIENNRF9UTEJJX05IX0FMTCBvciBDTURfVExCSV9OU05I
X0FMTCwgaXQgbmVlZHMgdG8gdW5tYXAKPj4gc2l6ZSA9IDB4MTAwMDAwMDAwMDAwMCBvbiA0OGJp
dCBzeXN0ZW0gKGl0IG1heSBzcGVuZCBtdWNoIHRpbWUpLCAgbWF5YmUKPj4gaXQgaXMgYmV0dGVy
Cj4+IHRvIHNldCBpdCBhcyBJT01NVV9JTlZfR1JBTlVfRE9NQUlOLCB0aGVuIGluIGhvc3QgT1Ms
IHNlbmQgVExCSV9OSF9BTEwKPj4gZGlyZWN0bHkgd2hlbiBJT01NVV9JTlZfR1JBTlVfRE9NQUlO
Lgo+IFllcyB5b3UncmUgcmlnaHQuIElmIHRoZSBob3N0IGRvZXMgbm90IHN1cHBvcnQgUklMIHRo
ZW4gaXQgaXMgYW4gaXNzdWUuCj4gVGhpcyBpcyBnb2luZyB0byBiZSBmaXhlZCBpbiB0aGUgbmV4
dCB2ZXJzaW9uLgoKR3JlYXQKCj4KPiBUaGFuayB5b3UgZm9yIHRoZSByZXBvcnQhCj4KPiBCZXN0
IFJlZ2FyZHMKPgo+IEVyaWMKPj4KPj4+ICsJZGVmYXVsdDoKPj4+ICsJCXJldHVybiAtRUlOVkFM
Owo+Pj4gKwl9Cj4+PiArCj4+PiArCS8qIEdsb2JhbCBTMSBpbnZhbGlkYXRpb24gKi8KPj4+ICsJ
Y21kLnRsYmkudm1pZCAgID0gc21tdV9kb21haW4tPnMyX2NmZy52bWlkOwo+Pj4gKwlhcm1fc21t
dV9jbWRxX2lzc3VlX2NtZChzbW11LCAmY21kKTsKPj4+ICsJYXJtX3NtbXVfY21kcV9pc3N1ZV9z
eW5jKHNtbXUpOwo+Pj4gKwlyZXR1cm4gMDsKPj4+ICt9Cj4+PiArCj4+PiAgIHN0YXRpYyBib29s
IGFybV9zbW11X2Rldl9oYXNfZmVhdHVyZShzdHJ1Y3QgZGV2aWNlICpkZXYsCj4+PiAgIAkJCQkg
ICAgIGVudW0gaW9tbXVfZGV2X2ZlYXR1cmVzIGZlYXQpCj4+PiAgIHsKPj4+IEBAIC0zMDQ4LDYg
KzMxMjEsNyBAQCBzdGF0aWMgc3RydWN0IGlvbW11X29wcyBhcm1fc21tdV9vcHMgPSB7Cj4+PiAg
IAkucHV0X3Jlc3ZfcmVnaW9ucwk9IGdlbmVyaWNfaW9tbXVfcHV0X3Jlc3ZfcmVnaW9ucywKPj4+
ICAgCS5hdHRhY2hfcGFzaWRfdGFibGUJPSBhcm1fc21tdV9hdHRhY2hfcGFzaWRfdGFibGUsCj4+
PiAgIAkuZGV0YWNoX3Bhc2lkX3RhYmxlCT0gYXJtX3NtbXVfZGV0YWNoX3Bhc2lkX3RhYmxlLAo+
Pj4gKwkuY2FjaGVfaW52YWxpZGF0ZQk9IGFybV9zbW11X2NhY2hlX2ludmFsaWRhdGUsCj4+PiAg
IAkuZGV2X2hhc19mZWF0CQk9IGFybV9zbW11X2Rldl9oYXNfZmVhdHVyZSwKPj4+ICAgCS5kZXZf
ZmVhdF9lbmFibGVkCT0gYXJtX3NtbXVfZGV2X2ZlYXR1cmVfZW5hYmxlZCwKPj4+ICAgCS5kZXZf
ZW5hYmxlX2ZlYXQJPSBhcm1fc21tdV9kZXZfZW5hYmxlX2ZlYXR1cmUsCj4gX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBMaW51eGFybSBtYWlsaW5nIGxp
c3QgLS0gbGludXhhcm1Ab3BlbmV1bGVyLm9yZwo+IFRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1h
aWwgdG8gbGludXhhcm0tbGVhdmVAb3BlbmV1bGVyLm9yZwoKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
