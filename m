Return-Path: <SRS0=nnE9=TN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96630C04AA7
	for <kvmarm@archiver.kernel.org>; Mon, 13 May 2019 12:04:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C82420989
	for <kvmarm@archiver.kernel.org>; Mon, 13 May 2019 12:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C82420989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B0744A4BE;
	Mon, 13 May 2019 08:04:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RkYBLN5B+jAt; Mon, 13 May 2019 08:04:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44F9B4A47A;
	Mon, 13 May 2019 08:04:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A5084A47A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 May 2019 08:04:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id shZ23Xie+w5B for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 May 2019 08:04:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F200C4A477
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 May 2019 08:04:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32888374;
 Mon, 13 May 2019 05:04:29 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 564573F703;
 Mon, 13 May 2019 05:04:26 -0700 (PDT)
Subject: Re: [PATCH v7 13/23] iommu/smmuv3: Implement attach/detach_pasid_table
To: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-14-eric.auger@redhat.com>
 <acde8b95-9cbc-c5e6-eb28-37bff7431e40@arm.com>
 <30020e0d-2164-5b39-f1ca-04a85263b7f3@redhat.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <1b700d41-71c3-a68d-58a5-4715a58c6b84@arm.com>
Date: Mon, 13 May 2019 13:04:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <30020e0d-2164-5b39-f1ca-04a85263b7f3@redhat.com>
Content-Language: en-GB
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTAvMDUvMjAxOSAxNTozNSwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBSb2JpbiwKPiAKPiBP
biA1LzgvMTkgNDozOCBQTSwgUm9iaW4gTXVycGh5IHdyb3RlOgo+PiBPbiAwOC8wNC8yMDE5IDEz
OjE5LCBFcmljIEF1Z2VyIHdyb3RlOgo+Pj4gT24gYXR0YWNoX3Bhc2lkX3RhYmxlKCkgd2UgcHJv
Z3JhbSBTVEUgUzEgcmVsYXRlZCBpbmZvIHNldAo+Pj4gYnkgdGhlIGd1ZXN0IGludG8gdGhlIGFj
dHVhbCBwaHlzaWNhbCBTVEVzLiBBdCBtaW5pbXVtCj4+PiB3ZSBuZWVkIHRvIHByb2dyYW0gdGhl
IGNvbnRleHQgZGVzY3JpcHRvciBHUEEgYW5kIGNvbXB1dGUKPj4+IHdoZXRoZXIgdGhlIHN0YWdl
MSBpcyB0cmFuc2xhdGVkL2J5cGFzc2VkIG9yIGFib3J0ZWQuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1i
eTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+Pj4KPj4+IC0tLQo+Pj4gdjYg
LT4gdjc6Cj4+PiAtIGNoZWNrIHZlcnNpb25zIGFuZCBjb21tZW50IHRoZSBmYWN0IHdlIGRvbid0
IG5lZWQgdG8gdGFrZQo+Pj4gIMKgwqAgaW50byBhY2NvdW50IHMxZHNzIGFuZCBzMWZtdAo+Pj4g
djMgLT4gdjQ6Cj4+PiAtIGFkYXB0IHRvIGNoYW5nZXMgaW4gaW9tbXVfcGFzaWRfdGFibGVfY29u
ZmlnCj4+PiAtIGRpZmZlcmVudCBwcm9ncmFtbWluZyBjb252ZW50aW9uIGF0IHMxX2NmZy9zMl9j
Zmcvc3RlLmFib3J0Cj4+Pgo+Pj4gdjIgLT4gdjM6Cj4+PiAtIGNhbGxiYWNrIG5vdyBpcyBuYW1l
ZCBzZXRfcGFzaWRfdGFibGUgYW5kIHN0cnVjdCBmaWVsZHMKPj4+ICDCoMKgIGFyZSBsYWlkIG91
dCBkaWZmZXJlbnRseS4KPj4+Cj4+PiB2MSAtPiB2MjoKPj4+IC0gaW52YWxpZGF0ZSB0aGUgU1RF
IGJlZm9yZSBjaGFuZ2luZyB0aGVtCj4+PiAtIGhvbGQgaW5pdF9tdXRleAo+Pj4gLSBoYW5kbGUg
bmV3IGZpZWxkcwo+Pj4gLS0tCj4+PiAgwqAgZHJpdmVycy9pb21tdS9hcm0tc21tdS12My5jIHwg
MTIxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+Pj4gIMKgIDEgZmlsZSBj
aGFuZ2VkLCAxMjEgaW5zZXJ0aW9ucygrKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lv
bW11L2FybS1zbW11LXYzLmMgYi9kcml2ZXJzL2lvbW11L2FybS1zbW11LXYzLmMKPj4+IGluZGV4
IGUyMmU5NDRmZmMwNS4uMTQ4NmJhZjUzNDI1IDEwMDY0NAo+Pj4gLS0tIGEvZHJpdmVycy9pb21t
dS9hcm0tc21tdS12My5jCj4+PiArKysgYi9kcml2ZXJzL2lvbW11L2FybS1zbW11LXYzLmMKPj4+
IEBAIC0yMjA3LDYgKzIyMDcsMTI1IEBAIHN0YXRpYyB2b2lkIGFybV9zbW11X3B1dF9yZXN2X3Jl
Z2lvbnMoc3RydWN0Cj4+PiBkZXZpY2UgKmRldiwKPj4+ICDCoMKgwqDCoMKgwqDCoMKgwqAga2Zy
ZWUoZW50cnkpOwo+Pj4gIMKgIH0KPj4+ICDCoCArc3RhdGljIGludCBhcm1fc21tdV9hdHRhY2hf
cGFzaWRfdGFibGUoc3RydWN0IGlvbW11X2RvbWFpbiAqZG9tYWluLAo+Pj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBpb21tdV9wYXNpZF90YWJs
ZV9jb25maWcgKmNmZykKPj4+ICt7Cj4+PiArwqDCoMKgIHN0cnVjdCBhcm1fc21tdV9kb21haW4g
KnNtbXVfZG9tYWluID0gdG9fc21tdV9kb21haW4oZG9tYWluKTsKPj4+ICvCoMKgwqAgc3RydWN0
IGFybV9zbW11X21hc3Rlcl9kYXRhICplbnRyeTsKPj4+ICvCoMKgwqAgc3RydWN0IGFybV9zbW11
X3MxX2NmZyAqczFfY2ZnOwo+Pj4gK8KgwqDCoCBzdHJ1Y3QgYXJtX3NtbXVfZGV2aWNlICpzbW11
Owo+Pj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIGZsYWdzOwo+Pj4gK8KgwqDCoCBpbnQgcmV0ID0g
LUVJTlZBTDsKPj4+ICsKPj4+ICvCoMKgwqAgaWYgKGNmZy0+Zm9ybWF0ICE9IElPTU1VX1BBU0lE
X0ZPUk1BVF9TTU1VVjMpCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+PiAr
Cj4+PiArwqDCoMKgIGlmIChjZmctPnZlcnNpb24gIT0gUEFTSURfVEFCTEVfQ0ZHX1ZFUlNJT05f
MSB8fAo+Pj4gK8KgwqDCoMKgwqDCoMKgIGNmZy0+c21tdXYzLnZlcnNpb24gIT0gUEFTSURfVEFC
TEVfU01NVVYzX0NGR19WRVJTSU9OXzEpCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5W
QUw7Cj4+PiArCj4+PiArwqDCoMKgIG11dGV4X2xvY2soJnNtbXVfZG9tYWluLT5pbml0X211dGV4
KTsKPj4+ICsKPj4+ICvCoMKgwqAgc21tdSA9IHNtbXVfZG9tYWluLT5zbW11Owo+Pj4gKwo+Pj4g
K8KgwqDCoCBpZiAoIXNtbXUpCj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+PiArCj4+
PiArwqDCoMKgIGlmICghKChzbW11LT5mZWF0dXJlcyAmIEFSTV9TTU1VX0ZFQVRfVFJBTlNfUzEp
ICYmCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgIChzbW11LT5mZWF0dXJlcyAmIEFSTV9TTU1VX0ZF
QVRfVFJBTlNfUzIpKSkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIGRldl9pbmZvKHNtbXVfZG9tYWlu
LT5zbW11LT5kZXYsCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJkb2VzIG5vdCBpbXBs
ZW1lbnQgdHdvIHN0YWdlc1xuIik7Cj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+PiAr
wqDCoMKgIH0KPj4KPj4gVGhhdCBjaGVjayBpcyByZWR1bmRhbnQgKGFuZCBmcmFua2x5IGxvb2tz
IGEgbGl0dGxlIGJpdCBzcGFtbXkpLiBJZiB0aGUKPj4gb25lIGJlbG93IGlzIG5vdCBlbm91Z2gs
IHRoZXJlIGlzIGEgcHJvYmxlbSBlbHNld2hlcmUgLSBpZiBpdCdzIHBvc3NpYmxlCj4+IGZvciBz
bW11X2RvbWFpbi0+c3RhZ2UgdG8gZXZlciBnZXQgc2V0IHRvIEFSTV9TTU1VX0RPTUFJTl9ORVNU
RUQgd2l0aG91dAo+PiBib3RoIHN0YWdlcyBvZiB0cmFuc2xhdGlvbiBwcmVzZW50LCB3ZSd2ZSBh
bHJlYWR5IGdvbmUgZnVuZGFtZW50YWxseSB3cm9uZy4KPiAKPiBNYWtlcyBzZW5zZS4gTW92ZWQg
dGhhdCBjaGVjayB0byBhcm1fc21tdV9kb21haW5fZmluYWxpc2UoKSBpbnN0ZWFkIGFuZAo+IHJl
bW92ZSByZWR1bmRhbnQgb25lcy4KClVyZ2gsIEkgZm9yZ290IGV4YWN0bHkgaG93IHRoZSBjcmF6
eSBkb21haW4tYWxsb2NhdGlvbiBkYW5jZSB3b3JrZWQsIApzdWNoIHRoYXQgd2UncmUgbm90IGlu
IGEgcG9zaXRpb24gdG8gcmVmdXNlIHRoZSBkb21haW5fc2V0X2F0dHIoKSBjYWxsIAppdHNlbGYs
IGJ1dCB0aGF0IGRvZXMgc291bmQgbGlrZSB0aGUgYmVzdCBjb21wcm9taXNlIGZvciBub3cuCgpU
aGFua3MsClJvYmluLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
