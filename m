Return-Path: <SRS0=nnE9=TN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A85C04AA7
	for <kvmarm@archiver.kernel.org>; Mon, 13 May 2019 12:16:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7241D20879
	for <kvmarm@archiver.kernel.org>; Mon, 13 May 2019 12:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7241D20879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED3A84A4F2;
	Mon, 13 May 2019 08:16:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 494I1azf7FZj; Mon, 13 May 2019 08:16:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F90E4A4CA;
	Mon, 13 May 2019 08:16:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA6514A4AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 May 2019 08:16:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NFIJpD5uSKzn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 May 2019 08:16:12 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52DA04A3A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 May 2019 08:16:12 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 2F26F87620;
 Mon, 13 May 2019 12:16:11 +0000 (UTC)
Received: from [10.36.116.17] (ovpn-116-17.ams2.redhat.com [10.36.116.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB24219C67;
 Mon, 13 May 2019 12:16:03 +0000 (UTC)
Subject: Re: [PATCH v7 14/23] iommu/smmuv3: Implement cache_invalidate
To: Robin Murphy <robin.murphy@arm.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-15-eric.auger@redhat.com>
 <a53d72f5-c8a2-a9e9-eb0b-2fac65964caf@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <edff2a6f-66e6-6d7e-49ca-3065e93a41a4@redhat.com>
Date: Mon, 13 May 2019 14:16:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <a53d72f5-c8a2-a9e9-eb0b-2fac65964caf@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.26]); Mon, 13 May 2019 12:16:11 +0000 (UTC)
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com,
 marc.zyngier@arm.com
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

SGkgUm9iaW4sCk9uIDUvOC8xOSA1OjAxIFBNLCBSb2JpbiBNdXJwaHkgd3JvdGU6Cj4gT24gMDgv
MDQvMjAxOSAxMzoxOSwgRXJpYyBBdWdlciB3cm90ZToKPj4gSW1wbGVtZW50IGRvbWFpbi1zZWxl
Y3RpdmUgYW5kIHBhZ2Utc2VsZWN0aXZlIElPVExCIGludmFsaWRhdGlvbnMuCj4+Cj4+IFNpZ25l
ZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPj4KPj4gLS0tCj4+
IHY2IC0+IHY3Cj4+IC0gY2hlY2sgdGhlIHVhcGkgdmVyc2lvbgo+Pgo+PiB2MyAtPiB2NDoKPj4g
LSBhZGFwdCB0byBjaGFuZ2VzIGluIHRoZSB1YXBpCj4+IC0gYWRkIHN1cHBvcnQgZm9yIGxlYWYg
cGFyYW1ldGVyCj4+IC0gZG8gbm90IHVzZSBhcm1fc21tdV90bGJfaW52X3JhbmdlX25vc3luYyBv
ciBhcm1fc21tdV90bGJfaW52X2NvbnRleHQKPj4gwqDCoCBhbnltb3JlCj4+Cj4+IHYyIC0+IHYz
Ogo+PiAtIHJlcGxhY2UgX19hcm1fc21tdV90bGJfc3luYyBieSBhcm1fc21tdV9jbWRxX2lzc3Vl
X3N5bmMKPj4KPj4gdjEgLT4gdjI6Cj4+IC0gcHJvcGVybHkgcGFzcyB0aGUgYXNpZAo+PiAtLS0K
Pj4gwqAgZHJpdmVycy9pb21tdS9hcm0tc21tdS12My5jIHwgNjAgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKwo+PiDCoCAxIGZpbGUgY2hhbmdlZCwgNjAgaW5zZXJ0aW9ucygr
KQo+Pgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9hcm0tc21tdS12My5jIGIvZHJpdmVy
cy9pb21tdS9hcm0tc21tdS12My5jCj4+IGluZGV4IDE0ODZiYWY1MzQyNS4uNDM2NjkyMWQ4MzE4
IDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL2lvbW11L2FybS1zbW11LXYzLmMKPj4gKysrIGIvZHJp
dmVycy9pb21tdS9hcm0tc21tdS12My5jCj4+IEBAIC0yMzI2LDYgKzIzMjYsNjUgQEAgc3RhdGlj
IHZvaWQgYXJtX3NtbXVfZGV0YWNoX3Bhc2lkX3RhYmxlKHN0cnVjdAo+PiBpb21tdV9kb21haW4g
KmRvbWFpbikKPj4gwqDCoMKgwqDCoCBtdXRleF91bmxvY2soJnNtbXVfZG9tYWluLT5pbml0X211
dGV4KTsKPj4gwqAgfQo+PiDCoCArc3RhdGljIGludAo+PiArYXJtX3NtbXVfY2FjaGVfaW52YWxp
ZGF0ZShzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sIHN0cnVjdCBkZXZpY2UKPj4gKmRldiwK
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBpb21tdV9jYWNoZV9pbnZhbGlk
YXRlX2luZm8gKmludl9pbmZvKQo+PiArewo+PiArwqDCoMKgIHN0cnVjdCBhcm1fc21tdV9kb21h
aW4gKnNtbXVfZG9tYWluID0gdG9fc21tdV9kb21haW4oZG9tYWluKTsKPj4gK8KgwqDCoCBzdHJ1
Y3QgYXJtX3NtbXVfZGV2aWNlICpzbW11ID0gc21tdV9kb21haW4tPnNtbXU7Cj4+ICsKPj4gK8Kg
wqDCoCBpZiAoc21tdV9kb21haW4tPnN0YWdlICE9IEFSTV9TTU1VX0RPTUFJTl9ORVNURUQpCj4+
ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPj4gKwo+PiArwqDCoMKgIGlmICghc21t
dSkKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+PiArCj4+ICvCoMKgwqAgaWYg
KGludl9pbmZvLT52ZXJzaW9uICE9IElPTU1VX0NBQ0hFX0lOVkFMSURBVEVfSU5GT19WRVJTSU9O
XzEpCj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPj4gKwo+PiArwqDCoMKgIGlm
IChpbnZfaW5mby0+Y2FjaGUgJiBJT01NVV9DQUNIRV9JTlZfVFlQRV9JT1RMQikgewo+PiArwqDC
oMKgwqDCoMKgwqAgaWYgKGludl9pbmZvLT5ncmFudWxhcml0eSA9PSBJT01NVV9JTlZfR1JBTlVf
UEFTSUQpIHsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGFybV9zbW11X2NtZHFf
ZW50IGNtZCA9IHsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAub3Bjb2RlID0g
Q01EUV9PUF9UTEJJX05IX0FTSUQsCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
LnRsYmkgPSB7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAudm1p
ZCA9IHNtbXVfZG9tYWluLT5zMl9jZmcudm1pZCwKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIC5hc2lkID0gaW52X2luZm8tPnBhc2lkLAo+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIH0sCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH07Cj4+ICsK
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYXJtX3NtbXVfY21kcV9pc3N1ZV9jbWQoc21tdSwg
JmNtZCk7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGFybV9zbW11X2NtZHFfaXNzdWVfc3lu
YyhzbW11KTsKPiAKPiBJJ2QgbXVjaCByYXRoZXIgbWFrZSBhcm1fc21tdV90bGJfaW52X2NvbnRl
eHQoKSB1bmRlcnN0YW5kIG5lc3RlZAo+IGRvbWFpbnMgdGhhbiBvcGVuLWNvZGUgY29tbWFuZHMg
YWxsIG92ZXIgdGhlIHBsYWNlLgoKCj4gCj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIH0gZWxzZSBp
ZiAoaW52X2luZm8tPmdyYW51bGFyaXR5ID09IElPTU1VX0lOVl9HUkFOVV9BRERSKSB7Cj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBpb21tdV9pbnZfYWRkcl9pbmZvICppbmZvID0g
Jmludl9pbmZvLT5hZGRyX2luZm87Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVfdCBz
aXplID0gaW5mby0+bmJfZ3JhbnVsZXMgKiBpbmZvLT5ncmFudWxlX3NpemU7Cj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGJvb2wgbGVhZiA9IGluZm8tPmZsYWdzICYgSU9NTVVfSU5WX0FERFJf
RkxBR1NfTEVBRjsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGFybV9zbW11X2Nt
ZHFfZW50IGNtZCA9IHsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAub3Bjb2Rl
ID0gQ01EUV9PUF9UTEJJX05IX1ZBLAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IC50bGJpID0gewo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLmFk
ZHIgPSBpbmZvLT5hZGRyLAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgLnZtaWQgPSBzbW11X2RvbWFpbi0+czJfY2ZnLnZtaWQsCj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAuYXNpZCA9IGluZm8tPnBhc2lkLAo+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLmxlYWYgPSBsZWFmLAo+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0sCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH07Cj4+
ICsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZG8gewo+PiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGFybV9zbW11X2NtZHFfaXNzdWVfY21kKHNtbXUsICZjbWQpOwo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNtZC50bGJpLmFkZHIgKz0gaW5mby0+Z3JhbnVs
ZV9zaXplOwo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9IHdoaWxlIChzaXplIC09IGluZm8t
PmdyYW51bGVfc2l6ZSk7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGFybV9zbW11X2NtZHFf
aXNzdWVfc3luYyhzbW11KTsKPiAKPiBBbiB0aGlzIGluIHBhcnRpY3VsYXIgSSB3b3VsZCByZWFs
bHkgbGlrZSB0byBnbyBhbGwgdGhlIHdheSB0aHJvdWdoCj4gaW9fcGd0YWJsZV90bGJfYWRkX2Zs
dXNoKCkvaW9fcGd0YWJsZV9zeW5jKCkgaWYgYXQgYWxsIHBvc3NpYmxlLiBIb29raW5nCj4gdXAg
cmFuZ2UtYmFzZWQgaW52YWxpZGF0aW9ucyBpcyBnb2luZyB0byBiZSBhIG1hc3NpdmUgaGVhZGFj
aGUgaWYgdGhlCj4gYWJzdHJhY3Rpb24gaXNuJ3Qgc29saWQuCgpUaGUgY29uY2VybiBpcyB0aGUg
aG9zdCBkb2VzIG5vdCAib3duIiB0aGUgczEgY29uZmlnIGFzaWQKKHNtbXVfZG9tYWluLT5zMV9j
ZmcuY2QuYXNpZCBpcyBub3Qgc2V0LCBwcmFjdGljYWxseSkuIEluIG91ciBjYXNlIHRoZQphc2lk
IG9ubHkgaXMgcGFzc2VkIGJ5IHRoZSB1c2Vyc3BhY2Ugb24gQ0FDSEVfSU5WQUxJREFURSBpb2N0
bCBjYWxsLgoKYXJtX3NtbXVfdGxiX2ludl9jb250ZXh0IGFuZCBhcm1fc21tdV90bGJfaW52X3Jh
bmdlX25vc3luYyB1c2UgdGhpcyBmaWVsZAoKSmVhbi1QaGlsaXBwZSBoaWdobGlnaHRlZCB0aGF0
IGZhY3QgaW4KaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMTkvMS8xMS8xMDYyIGFuZCBzdWdnZXN0
ZWQgdG8gb3Blbi1jb2RlIGNvbW1hbmRzCmluc3RlYWQsIGhlbmNlIHRoZSBjdXJyZW50IGZvcm0u
CgpUaGFua3MKCkVyaWMKPiAKPiBSb2Jpbi4KPiAKPj4gK8KgwqDCoMKgwqDCoMKgIH0gZWxzZSB7
Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+PiArwqDCoMKgwqDC
oMKgwqAgfQo+PiArwqDCoMKgIH0KPj4gK8KgwqDCoCBpZiAoaW52X2luZm8tPmNhY2hlICYgSU9N
TVVfQ0FDSEVfSU5WX1RZUEVfUEFTSUQgfHwKPj4gK8KgwqDCoMKgwqDCoMKgIGludl9pbmZvLT5j
YWNoZSAmIElPTU1VX0NBQ0hFX0lOVl9UWVBFX0RFVl9JT1RMQikgewo+PiArwqDCoMKgwqDCoMKg
wqAgcmV0dXJuIC1FTk9FTlQ7Cj4+ICvCoMKgwqAgfQo+PiArwqDCoMKgIHJldHVybiAwOwo+PiAr
fQo+PiArCj4+IMKgIHN0YXRpYyBzdHJ1Y3QgaW9tbXVfb3BzIGFybV9zbW11X29wcyA9IHsKPj4g
wqDCoMKgwqDCoCAuY2FwYWJsZcKgwqDCoMKgwqDCoMKgID0gYXJtX3NtbXVfY2FwYWJsZSwKPj4g
wqDCoMKgwqDCoCAuZG9tYWluX2FsbG9jwqDCoMKgwqDCoMKgwqAgPSBhcm1fc21tdV9kb21haW5f
YWxsb2MsCj4+IEBAIC0yMzQ2LDYgKzI0MDUsNyBAQCBzdGF0aWMgc3RydWN0IGlvbW11X29wcyBh
cm1fc21tdV9vcHMgPSB7Cj4+IMKgwqDCoMKgwqAgLnB1dF9yZXN2X3JlZ2lvbnPCoMKgwqAgPSBh
cm1fc21tdV9wdXRfcmVzdl9yZWdpb25zLAo+PiDCoMKgwqDCoMKgIC5hdHRhY2hfcGFzaWRfdGFi
bGXCoMKgwqAgPSBhcm1fc21tdV9hdHRhY2hfcGFzaWRfdGFibGUsCj4+IMKgwqDCoMKgwqAgLmRl
dGFjaF9wYXNpZF90YWJsZcKgwqDCoCA9IGFybV9zbW11X2RldGFjaF9wYXNpZF90YWJsZSwKPj4g
K8KgwqDCoCAuY2FjaGVfaW52YWxpZGF0ZcKgwqDCoCA9IGFybV9zbW11X2NhY2hlX2ludmFsaWRh
dGUsCj4+IMKgwqDCoMKgwqAgLnBnc2l6ZV9iaXRtYXDCoMKgwqDCoMKgwqDCoCA9IC0xVUwsIC8q
IFJlc3RyaWN0ZWQgZHVyaW5nIGRldmljZSBhdHRhY2ggKi8KPj4gwqAgfTsKPj4gwqAKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcg
bGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1i
aWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
