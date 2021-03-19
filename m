Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603FAC433C1
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 17:36:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF5EB6197C
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 17:36:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF5EB6197C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF8D4B5E6;
	Fri, 19 Mar 2021 13:36:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f4q0g5UZFWRC; Fri, 19 Mar 2021 13:36:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C70454B4D9;
	Fri, 19 Mar 2021 13:36:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A88E34B49F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 13:36:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZNeTu2E9oFNf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 13:36:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1D24B0AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 13:36:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1616175397;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5eOAQHQd0/ZycZbF0USh+JA+Y7XaAJwV/qd8pF9Pi6w=;
 b=HbuMnL3d/+gQnFeMmpJ0mDTj5k3r/XXE6qVRrcnOpW/4/lZGqSgsoGRwsGFgQnb0RE815R
 TWSAji2PYb4J+WstkYetIYHYJgo2eB6PPpM3rcLYX3HVgKK46ztZK5vNUatzK9QGoPDbcL
 LSoHaYUw7APlVKSp1zi7OunStdtvCMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-ioeMyaxZNX6ROX7Fw6K4TA-1; Fri, 19 Mar 2021 13:36:33 -0400
X-MC-Unique: ioeMyaxZNX6ROX7Fw6K4TA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECF39107B768;
 Fri, 19 Mar 2021 17:36:29 +0000 (UTC)
Received: from [10.36.113.141] (ovpn-113-141.ams2.redhat.com [10.36.113.141])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EB5160C04;
 Fri, 19 Mar 2021 17:36:18 +0000 (UTC)
Subject: Re: [PATCH v14 07/13] iommu/smmuv3: Implement cache_invalidate
To: "chenxiang (M)" <chenxiang66@hisilicon.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
 alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-8-eric.auger@redhat.com>
 <c10c6405-5efe-5a41-2b3a-f3af85a528ba@hisilicon.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <d5dcb7fe-2e09-b1fb-24d6-36249f047632@redhat.com>
Date: Fri, 19 Mar 2021 18:36:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c10c6405-5efe-5a41-2b3a-f3af85a528ba@hisilicon.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

SGkgQ2hlbnhpYW5nLAoKT24gMy80LzIxIDg6NTUgQU0sIGNoZW54aWFuZyAoTSkgd3JvdGU6Cj4g
SGkgRXJpYywKPiAKPiAKPiDlnKggMjAyMS8yLzI0IDQ6NTYsIEVyaWMgQXVnZXIg5YaZ6YGTOgo+
PiBJbXBsZW1lbnQgZG9tYWluLXNlbGVjdGl2ZSwgcGFzaWQgc2VsZWN0aXZlIGFuZCBwYWdlLXNl
bGVjdGl2ZQo+PiBJT1RMQiBpbnZhbGlkYXRpb25zLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBFcmlj
IEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+Cj4+IC0tLQo+Pgo+PiB2MTMgLT4gdjE0
Ogo+PiAtIEFkZCBkb21haW4gaW52YWxpZGF0aW9uCj4+IC0gZG8gZ2xvYmFsIGludmFsIHdoZW4g
YXNpZCBpcyBub3QgcHJvdmlkZWQgd2l0aCBhZGRyCj4+ICAgZ3JhbnVsYXJpdHkKPj4KPj4gdjcg
LT4gdjg6Cj4+IC0gQVNJRCBiYXNlZCBpbnZhbGlkYXRpb24gdXNpbmcgaW9tbXVfaW52X3Bhc2lk
X2luZm8KPj4gLSBjaGVjayBBUkNISUQvUEFTSUQgZmxhZ3MgaW4gYWRkciBiYXNlZCBpbnZhbGlk
YXRpb24KPj4gLSB1c2UgX19hcm1fc21tdV90bGJfaW52X2NvbnRleHQgYW5kIF9fYXJtX3NtbXVf
dGxiX2ludl9yYW5nZV9ub3N5bmMKPj4KPj4gdjYgLT4gdjcKPj4gLSBjaGVjayB0aGUgdWFwaSB2
ZXJzaW9uCj4+Cj4+IHYzIC0+IHY0Ogo+PiAtIGFkYXB0IHRvIGNoYW5nZXMgaW4gdGhlIHVhcGkK
Pj4gLSBhZGQgc3VwcG9ydCBmb3IgbGVhZiBwYXJhbWV0ZXIKPj4gLSBkbyBub3QgdXNlIGFybV9z
bW11X3RsYl9pbnZfcmFuZ2Vfbm9zeW5jIG9yIGFybV9zbW11X3RsYl9pbnZfY29udGV4dAo+PiAg
IGFueW1vcmUKPj4KPj4gdjIgLT4gdjM6Cj4+IC0gcmVwbGFjZSBfX2FybV9zbW11X3RsYl9zeW5j
IGJ5IGFybV9zbW11X2NtZHFfaXNzdWVfc3luYwo+Pgo+PiB2MSAtPiB2MjoKPj4gLSBwcm9wZXJs
eSBwYXNzIHRoZSBhc2lkCj4+IC0tLQo+PiAgZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMv
YXJtLXNtbXUtdjMuYyB8IDc0ICsrKysrKysrKysrKysrKysrKysrKwo+PiAgMSBmaWxlIGNoYW5n
ZWQsIDc0IGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvYXJt
L2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMgYi9kcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12
My9hcm0tc21tdS12My5jCj4+IGluZGV4IDRjMTlhMTExNGRlNC4uZGYzYWRjNDkxMTFjIDEwMDY0
NAo+PiAtLS0gYS9kcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jCj4+
ICsrKyBiL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMKPj4gQEAg
LTI5NDksNiArMjk0OSw3OSBAQCBzdGF0aWMgdm9pZCBhcm1fc21tdV9kZXRhY2hfcGFzaWRfdGFi
bGUoc3RydWN0IGlvbW11X2RvbWFpbiAqZG9tYWluKQo+PiAgCW11dGV4X3VubG9jaygmc21tdV9k
b21haW4tPmluaXRfbXV0ZXgpOwo+PiAgfQo+PiAgCj4+ICtzdGF0aWMgaW50Cj4+ICthcm1fc21t
dV9jYWNoZV9pbnZhbGlkYXRlKHN0cnVjdCBpb21tdV9kb21haW4gKmRvbWFpbiwgc3RydWN0IGRl
dmljZSAqZGV2LAo+PiArCQkJICBzdHJ1Y3QgaW9tbXVfY2FjaGVfaW52YWxpZGF0ZV9pbmZvICpp
bnZfaW5mbykKPj4gK3sKPj4gKwlzdHJ1Y3QgYXJtX3NtbXVfY21kcV9lbnQgY21kID0gey5vcGNv
ZGUgPSBDTURRX09QX1RMQklfTlNOSF9BTEx9Owo+PiArCXN0cnVjdCBhcm1fc21tdV9kb21haW4g
KnNtbXVfZG9tYWluID0gdG9fc21tdV9kb21haW4oZG9tYWluKTsKPj4gKwlzdHJ1Y3QgYXJtX3Nt
bXVfZGV2aWNlICpzbW11ID0gc21tdV9kb21haW4tPnNtbXU7Cj4+ICsKPj4gKwlpZiAoc21tdV9k
b21haW4tPnN0YWdlICE9IEFSTV9TTU1VX0RPTUFJTl9ORVNURUQpCj4+ICsJCXJldHVybiAtRUlO
VkFMOwo+PiArCj4+ICsJaWYgKCFzbW11KQo+PiArCQlyZXR1cm4gLUVJTlZBTDsKPj4gKwo+PiAr
CWlmIChpbnZfaW5mby0+dmVyc2lvbiAhPSBJT01NVV9DQUNIRV9JTlZBTElEQVRFX0lORk9fVkVS
U0lPTl8xKQo+PiArCQlyZXR1cm4gLUVJTlZBTDsKPj4gKwo+PiArCWlmIChpbnZfaW5mby0+Y2Fj
aGUgJiBJT01NVV9DQUNIRV9JTlZfVFlQRV9QQVNJRCB8fAo+PiArCSAgICBpbnZfaW5mby0+Y2Fj
aGUgJiBJT01NVV9DQUNIRV9JTlZfVFlQRV9ERVZfSU9UTEIpIHsKPj4gKwkJcmV0dXJuIC1FTk9F
TlQ7Cj4+ICsJfQo+PiArCj4+ICsJaWYgKCEoaW52X2luZm8tPmNhY2hlICYgSU9NTVVfQ0FDSEVf
SU5WX1RZUEVfSU9UTEIpKQo+PiArCQlyZXR1cm4gLUVJTlZBTDsKPj4gKwo+PiArCS8qIElPVExC
IGludmFsaWRhdGlvbiAqLwo+PiArCj4+ICsJc3dpdGNoIChpbnZfaW5mby0+Z3JhbnVsYXJpdHkp
IHsKPj4gKwljYXNlIElPTU1VX0lOVl9HUkFOVV9QQVNJRDoKPj4gKwl7Cj4+ICsJCXN0cnVjdCBp
b21tdV9pbnZfcGFzaWRfaW5mbyAqaW5mbyA9Cj4+ICsJCQkmaW52X2luZm8tPmdyYW51LnBhc2lk
X2luZm87Cj4+ICsKPj4gKwkJaWYgKGluZm8tPmZsYWdzICYgSU9NTVVfSU5WX0FERFJfRkxBR1Nf
UEFTSUQpCj4+ICsJCQlyZXR1cm4gLUVOT0VOVDsKPj4gKwkJaWYgKCEoaW5mby0+ZmxhZ3MgJiBJ
T01NVV9JTlZfUEFTSURfRkxBR1NfQVJDSElEKSkKPj4gKwkJCXJldHVybiAtRUlOVkFMOwo+PiAr
Cj4+ICsJCV9fYXJtX3NtbXVfdGxiX2ludl9jb250ZXh0KHNtbXVfZG9tYWluLCBpbmZvLT5hcmNo
aWQpOwo+PiArCQlyZXR1cm4gMDsKPj4gKwl9Cj4+ICsJY2FzZSBJT01NVV9JTlZfR1JBTlVfQURE
UjoKPj4gKwl7Cj4+ICsJCXN0cnVjdCBpb21tdV9pbnZfYWRkcl9pbmZvICppbmZvID0gJmludl9p
bmZvLT5ncmFudS5hZGRyX2luZm87Cj4+ICsJCXNpemVfdCBzaXplID0gaW5mby0+bmJfZ3JhbnVs
ZXMgKiBpbmZvLT5ncmFudWxlX3NpemU7Cj4+ICsJCWJvb2wgbGVhZiA9IGluZm8tPmZsYWdzICYg
SU9NTVVfSU5WX0FERFJfRkxBR1NfTEVBRjsKPj4gKwo+PiArCQlpZiAoaW5mby0+ZmxhZ3MgJiBJ
T01NVV9JTlZfQUREUl9GTEFHU19QQVNJRCkKPj4gKwkJCXJldHVybiAtRU5PRU5UOwo+PiArCj4+
ICsJCWlmICghKGluZm8tPmZsYWdzICYgSU9NTVVfSU5WX0FERFJfRkxBR1NfQVJDSElEKSkKPj4g
KwkJCWJyZWFrOwo+PiArCj4+ICsJCWFybV9zbW11X3RsYl9pbnZfcmFuZ2VfZG9tYWluKGluZm8t
PmFkZHIsIHNpemUsCj4+ICsJCQkJCSAgICAgIGluZm8tPmdyYW51bGVfc2l6ZSwgbGVhZiwKPj4g
KwkJCQkJICAgICAgaW5mby0+YXJjaGlkLCBzbW11X2RvbWFpbik7Cj4gCj4gSXMgaXQgcG9zc2li
bGUgdG8gYWRkIGEgY2hlY2sgYmVmb3JlIHRoZSBmdW5jdGlvbiB0byBtYWtlIHN1cmUgdGhhdAo+
IGluZm8tPmdyYW51bGVfc2l6ZSBjYW4gYmUgcmVjb2duaXplZCBieSBTTU1VPwo+IFRoZXJlIGlz
IGEgc2NlbmFyaW8gd2hpY2ggd2lsbCBjYXVzZSBUTEJJIGlzc3VlOiBSSUwgZmVhdHVyZSBpcyBl
bmFibGVkCj4gb24gZ3Vlc3QgYnV0IGlzIGRpc2FibGVkIG9uIGhvc3QsIGFuZCB0aGVuIG9uCj4g
aG9zdCBpdCBqdXN0IGludmFsaWRhdGUgNEsvMk0vMUcgb25jZSBhIHRpbWUsIGJ1dCBmcm9tIFFF
TVUsCj4gaW5mby0+bmJfZ3JhbnVsZXMgaXMgYWx3YXlzIDEgYW5kIGluZm8tPmdyYW51bGVfc2l6
ZSA9IHNpemUsCj4gaWYgc2l6ZSBpcyBub3QgZXF1YWwgdG8gNEsgb3IgMk0gb3IgMUcgKGZvciBl
eGFtcGxlIHNpemUgPSBncmFudWxlX3NpemUKPiBpcyA1TSksIGl0IHdpbGwgb25seSBwYXJ0IG9m
IHRoZSBzaXplIGl0IHdhbnRzIHRvIGludmFsaWRhdGUuCj4gCj4gSSB0aGluayBtYXliZSB3ZSBj
YW4gYWRkIGEgY2hlY2sgaGVyZTogaWYgUklMIGlzIG5vdCBlbmFibGVkIGFuZCBhbHNvCj4gc2l6
ZSBpcyBub3QgdGhlIGdyYW51bGVfc2l6ZSAoNEsvMk0vMUcpIHN1cHBvcnRlZCBieQo+IFNNTVUg
aGFyZHdhcmUsIGNhbiB3ZSBqdXN0IHNpbXBseSB1c2UgdGhlIHNtYWxsZXN0IGdyYW51bGVfc2l6
ZQo+IHN1cHBvcnRlZCBieSBoYXJkd2FyZSBhbGwgdGhlIHRpbWU/Cj4gCj4+ICsKPj4gKwkJYXJt
X3NtbXVfY21kcV9pc3N1ZV9zeW5jKHNtbXUpOwo+PiArCQlyZXR1cm4gMDsKPj4gKwl9Cj4+ICsJ
Y2FzZSBJT01NVV9JTlZfR1JBTlVfRE9NQUlOOgo+PiArCQlicmVhazsKPiAKPiBJIGNoZWNrIHRo
ZSBxZW11IGNvZGUKPiAoaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9xZW11L3RyZWUvdjUuMi4w
LTJzdGFnZS1yZmN2OCksIGZvciBvcGNvZGUKPiBDTURfVExCSV9OSF9BTEwgb3IgQ01EX1RMQklf
TlNOSF9BTEwgZnJvbSBndWVzdCBPUwo+IGl0IGNhbGxzIHNtbXVfaW52X25vdGlmaWVyc19hbGwo
KSB0byB1bmFtcCBhbGwgbm90aWZpZXJzIG9mIGFsbCBtcidzLAo+IGJ1dCBpdCBzZWVtcyBub3Qg
c2V0IGV2ZW50LmVudHJ5LmdyYW51bGFyaXR5IHdoaWNoIGkgdGhpbmsgaXQgc2hvdWxkIHNldAo+
IElPTU1VX0lOVl9HUkFOX0FERFIuCnRoaXMgaXMgYmVjYXVzZSBJT01NVV9JTlZfR1JBTl9BRERS
ID0gMC4gQnV0IGZvciBjbGFyaXR5IEkgc2hvdWxkIHJhdGhlcgpzZXQgaXQgZXhwbGljaXRseSA7
LSkKPiBCVFcsIGZvciBvcGNvZGUgQ01EX1RMQklfTkhfQUxMIG9yIENNRF9UTEJJX05TTkhfQUxM
LCBpdCBuZWVkcyB0byB1bm1hcAo+IHNpemUgPSAweDEwMDAwMDAwMDAwMDAgb24gNDhiaXQgc3lz
dGVtIChpdCBtYXkgc3BlbmQgbXVjaCB0aW1lKSzCoCBtYXliZQo+IGl0IGlzIGJldHRlcgo+IHRv
IHNldCBpdCBhcyBJT01NVV9JTlZfR1JBTlVfRE9NQUlOLCB0aGVuIGluIGhvc3QgT1MsIHNlbmQg
VExCSV9OSF9BTEwKPiBkaXJlY3RseSB3aGVuIElPTU1VX0lOVl9HUkFOVV9ET01BSU4uClllcyB5
b3UncmUgcmlnaHQuIElmIHRoZSBob3N0IGRvZXMgbm90IHN1cHBvcnQgUklMIHRoZW4gaXQgaXMg
YW4gaXNzdWUuClRoaXMgaXMgZ29pbmcgdG8gYmUgZml4ZWQgaW4gdGhlIG5leHQgdmVyc2lvbi4K
ClRoYW5rIHlvdSBmb3IgdGhlIHJlcG9ydCEKCkJlc3QgUmVnYXJkcwoKRXJpYwo+IAo+IAo+PiAr
CWRlZmF1bHQ6Cj4+ICsJCXJldHVybiAtRUlOVkFMOwo+PiArCX0KPj4gKwo+PiArCS8qIEdsb2Jh
bCBTMSBpbnZhbGlkYXRpb24gKi8KPj4gKwljbWQudGxiaS52bWlkICAgPSBzbW11X2RvbWFpbi0+
czJfY2ZnLnZtaWQ7Cj4+ICsJYXJtX3NtbXVfY21kcV9pc3N1ZV9jbWQoc21tdSwgJmNtZCk7Cj4+
ICsJYXJtX3NtbXVfY21kcV9pc3N1ZV9zeW5jKHNtbXUpOwo+PiArCXJldHVybiAwOwo+PiArfQo+
PiArCj4+ICBzdGF0aWMgYm9vbCBhcm1fc21tdV9kZXZfaGFzX2ZlYXR1cmUoc3RydWN0IGRldmlj
ZSAqZGV2LAo+PiAgCQkJCSAgICAgZW51bSBpb21tdV9kZXZfZmVhdHVyZXMgZmVhdCkKPj4gIHsK
Pj4gQEAgLTMwNDgsNiArMzEyMSw3IEBAIHN0YXRpYyBzdHJ1Y3QgaW9tbXVfb3BzIGFybV9zbW11
X29wcyA9IHsKPj4gIAkucHV0X3Jlc3ZfcmVnaW9ucwk9IGdlbmVyaWNfaW9tbXVfcHV0X3Jlc3Zf
cmVnaW9ucywKPj4gIAkuYXR0YWNoX3Bhc2lkX3RhYmxlCT0gYXJtX3NtbXVfYXR0YWNoX3Bhc2lk
X3RhYmxlLAo+PiAgCS5kZXRhY2hfcGFzaWRfdGFibGUJPSBhcm1fc21tdV9kZXRhY2hfcGFzaWRf
dGFibGUsCj4+ICsJLmNhY2hlX2ludmFsaWRhdGUJPSBhcm1fc21tdV9jYWNoZV9pbnZhbGlkYXRl
LAo+PiAgCS5kZXZfaGFzX2ZlYXQJCT0gYXJtX3NtbXVfZGV2X2hhc19mZWF0dXJlLAo+PiAgCS5k
ZXZfZmVhdF9lbmFibGVkCT0gYXJtX3NtbXVfZGV2X2ZlYXR1cmVfZW5hYmxlZCwKPj4gIAkuZGV2
X2VuYWJsZV9mZWF0CT0gYXJtX3NtbXVfZGV2X2VuYWJsZV9mZWF0dXJlLAo+IAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
