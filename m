Return-Path: <SRS0=nnE9=TN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148B5C04AA7
	for <kvmarm@archiver.kernel.org>; Mon, 13 May 2019 14:05:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A0A3208CA
	for <kvmarm@archiver.kernel.org>; Mon, 13 May 2019 14:05:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A0A3208CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 304F74A4EA;
	Mon, 13 May 2019 10:05:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m+WpdQpZIgxM; Mon, 13 May 2019 10:05:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D64A34A4E9;
	Mon, 13 May 2019 10:05:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 577144A4E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 May 2019 10:05:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3zuAucrQj05A for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 May 2019 10:05:12 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D74A34A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 May 2019 10:05:11 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 6E30E7FD6C;
 Mon, 13 May 2019 14:05:00 +0000 (UTC)
Received: from [10.36.116.17] (ovpn-116-17.ams2.redhat.com [10.36.116.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C655F608C3;
 Mon, 13 May 2019 14:04:49 +0000 (UTC)
Subject: Re: [PATCH v7 14/23] iommu/smmuv3: Implement cache_invalidate
To: Robin Murphy <robin.murphy@arm.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-15-eric.auger@redhat.com>
 <a53d72f5-c8a2-a9e9-eb0b-2fac65964caf@arm.com>
 <edff2a6f-66e6-6d7e-49ca-3065e93a41a4@redhat.com>
 <a181689b-94b5-5ff6-9fec-66b3f319cbc4@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <405002b2-5663-7c03-d5df-b9da6499a238@redhat.com>
Date: Mon, 13 May 2019 16:04:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <a181689b-94b5-5ff6-9fec-66b3f319cbc4@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.27]); Mon, 13 May 2019 14:05:06 +0000 (UTC)
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

SGkgUm9iaW4sCgpPbiA1LzEzLzE5IDQ6MDEgUE0sIFJvYmluIE11cnBoeSB3cm90ZToKPiBPbiAx
My8wNS8yMDE5IDEzOjE2LCBBdWdlciBFcmljIHdyb3RlOgo+PiBIaSBSb2JpbiwKPj4gT24gNS84
LzE5IDU6MDEgUE0sIFJvYmluIE11cnBoeSB3cm90ZToKPj4+IE9uIDA4LzA0LzIwMTkgMTM6MTks
IEVyaWMgQXVnZXIgd3JvdGU6Cj4+Pj4gSW1wbGVtZW50IGRvbWFpbi1zZWxlY3RpdmUgYW5kIHBh
Z2Utc2VsZWN0aXZlIElPVExCIGludmFsaWRhdGlvbnMuCj4+Pj4KPj4+PiBTaWduZWQtb2ZmLWJ5
OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+Pj4KPj4+PiAtLS0KPj4+PiB2
NiAtPiB2Nwo+Pj4+IC0gY2hlY2sgdGhlIHVhcGkgdmVyc2lvbgo+Pj4+Cj4+Pj4gdjMgLT4gdjQ6
Cj4+Pj4gLSBhZGFwdCB0byBjaGFuZ2VzIGluIHRoZSB1YXBpCj4+Pj4gLSBhZGQgc3VwcG9ydCBm
b3IgbGVhZiBwYXJhbWV0ZXIKPj4+PiAtIGRvIG5vdCB1c2UgYXJtX3NtbXVfdGxiX2ludl9yYW5n
ZV9ub3N5bmMgb3IgYXJtX3NtbXVfdGxiX2ludl9jb250ZXh0Cj4+Pj4gwqDCoMKgIGFueW1vcmUK
Pj4+Pgo+Pj4+IHYyIC0+IHYzOgo+Pj4+IC0gcmVwbGFjZSBfX2FybV9zbW11X3RsYl9zeW5jIGJ5
IGFybV9zbW11X2NtZHFfaXNzdWVfc3luYwo+Pj4+Cj4+Pj4gdjEgLT4gdjI6Cj4+Pj4gLSBwcm9w
ZXJseSBwYXNzIHRoZSBhc2lkCj4+Pj4gLS0tCj4+Pj4gwqDCoCBkcml2ZXJzL2lvbW11L2FybS1z
bW11LXYzLmMgfCA2MAo+Pj4+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysK
Pj4+PiDCoMKgIDEgZmlsZSBjaGFuZ2VkLCA2MCBpbnNlcnRpb25zKCspCj4+Pj4KPj4+PiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9pb21tdS9hcm0tc21tdS12My5jIGIvZHJpdmVycy9pb21tdS9hcm0t
c21tdS12My5jCj4+Pj4gaW5kZXggMTQ4NmJhZjUzNDI1Li40MzY2OTIxZDgzMTggMTAwNjQ0Cj4+
Pj4gLS0tIGEvZHJpdmVycy9pb21tdS9hcm0tc21tdS12My5jCj4+Pj4gKysrIGIvZHJpdmVycy9p
b21tdS9hcm0tc21tdS12My5jCj4+Pj4gQEAgLTIzMjYsNiArMjMyNiw2NSBAQCBzdGF0aWMgdm9p
ZCBhcm1fc21tdV9kZXRhY2hfcGFzaWRfdGFibGUoc3RydWN0Cj4+Pj4gaW9tbXVfZG9tYWluICpk
b21haW4pCj4+Pj4gwqDCoMKgwqDCoMKgIG11dGV4X3VubG9jaygmc21tdV9kb21haW4tPmluaXRf
bXV0ZXgpOwo+Pj4+IMKgwqAgfQo+Pj4+IMKgwqAgK3N0YXRpYyBpbnQKPj4+PiArYXJtX3NtbXVf
Y2FjaGVfaW52YWxpZGF0ZShzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sIHN0cnVjdCBkZXZp
Y2UKPj4+PiAqZGV2LAo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgaW9t
bXVfY2FjaGVfaW52YWxpZGF0ZV9pbmZvICppbnZfaW5mbykKPj4+PiArewo+Pj4+ICvCoMKgwqAg
c3RydWN0IGFybV9zbW11X2RvbWFpbiAqc21tdV9kb21haW4gPSB0b19zbW11X2RvbWFpbihkb21h
aW4pOwo+Pj4+ICvCoMKgwqAgc3RydWN0IGFybV9zbW11X2RldmljZSAqc21tdSA9IHNtbXVfZG9t
YWluLT5zbW11Owo+Pj4+ICsKPj4+PiArwqDCoMKgIGlmIChzbW11X2RvbWFpbi0+c3RhZ2UgIT0g
QVJNX1NNTVVfRE9NQUlOX05FU1RFRCkKPj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5W
QUw7Cj4+Pj4gKwo+Pj4+ICvCoMKgwqAgaWYgKCFzbW11KQo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gLUVJTlZBTDsKPj4+PiArCj4+Pj4gK8KgwqDCoCBpZiAoaW52X2luZm8tPnZlcnNpb24g
IT0gSU9NTVVfQ0FDSEVfSU5WQUxJREFURV9JTkZPX1ZFUlNJT05fMSkKPj4+PiArwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+Pj4gKwo+Pj4+ICvCoMKgwqAgaWYgKGludl9pbmZvLT5j
YWNoZSAmIElPTU1VX0NBQ0hFX0lOVl9UWVBFX0lPVExCKSB7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKg
IGlmIChpbnZfaW5mby0+Z3JhbnVsYXJpdHkgPT0gSU9NTVVfSU5WX0dSQU5VX1BBU0lEKSB7Cj4+
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGFybV9zbW11X2NtZHFfZW50IGNtZCA9
IHsKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC5vcGNvZGUgPSBDTURRX09Q
X1RMQklfTkhfQVNJRCwKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC50bGJp
ID0gewo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAudm1pZCA9
IHNtbXVfZG9tYWluLT5zMl9jZmcudm1pZCwKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgLmFzaWQgPSBpbnZfaW5mby0+cGFzaWQsCj4+Pj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB9LAo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH07Cj4+
Pj4gKwo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGFybV9zbW11X2NtZHFfaXNzdWVfY21k
KHNtbXUsICZjbWQpOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGFybV9zbW11X2NtZHFf
aXNzdWVfc3luYyhzbW11KTsKPj4+Cj4+PiBJJ2QgbXVjaCByYXRoZXIgbWFrZSBhcm1fc21tdV90
bGJfaW52X2NvbnRleHQoKSB1bmRlcnN0YW5kIG5lc3RlZAo+Pj4gZG9tYWlucyB0aGFuIG9wZW4t
Y29kZSBjb21tYW5kcyBhbGwgb3ZlciB0aGUgcGxhY2UuCj4+Cj4+Cj4+Pgo+Pj4+ICsKPj4+PiAr
wqDCoMKgwqDCoMKgwqAgfSBlbHNlIGlmIChpbnZfaW5mby0+Z3JhbnVsYXJpdHkgPT0gSU9NTVVf
SU5WX0dSQU5VX0FERFIpIHsKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgaW9t
bXVfaW52X2FkZHJfaW5mbyAqaW5mbyA9ICZpbnZfaW5mby0+YWRkcl9pbmZvOwo+Pj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHNpemVfdCBzaXplID0gaW5mby0+bmJfZ3JhbnVsZXMgKiBpbmZv
LT5ncmFudWxlX3NpemU7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYm9vbCBsZWFmID0g
aW5mby0+ZmxhZ3MgJiBJT01NVV9JTlZfQUREUl9GTEFHU19MRUFGOwo+Pj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHN0cnVjdCBhcm1fc21tdV9jbWRxX2VudCBjbWQgPSB7Cj4+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAub3Bjb2RlID0gQ01EUV9PUF9UTEJJX05IX1ZBLAo+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLnRsYmkgPSB7Cj4+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC5hZGRyID0gaW5mby0+YWRkciwKPj4+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLnZtaWQgPSBzbW11X2Rv
bWFpbi0+czJfY2ZnLnZtaWQsCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIC5hc2lkID0gaW5mby0+cGFzaWQsCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIC5sZWFmID0gbGVhZiwKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIH0sCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfTsKPj4+PiArCj4+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZG8gewo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgYXJtX3NtbXVfY21kcV9pc3N1ZV9jbWQoc21tdSwgJmNtZCk7Cj4+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjbWQudGxiaS5hZGRyICs9IGluZm8tPmdyYW51bGVf
c2l6ZTsKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9IHdoaWxlIChzaXplIC09IGluZm8t
PmdyYW51bGVfc2l6ZSk7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYXJtX3NtbXVfY21k
cV9pc3N1ZV9zeW5jKHNtbXUpOwo+Pj4KPj4+IEFuIHRoaXMgaW4gcGFydGljdWxhciBJIHdvdWxk
IHJlYWxseSBsaWtlIHRvIGdvIGFsbCB0aGUgd2F5IHRocm91Z2gKPj4+IGlvX3BndGFibGVfdGxi
X2FkZF9mbHVzaCgpL2lvX3BndGFibGVfc3luYygpIGlmIGF0IGFsbCBwb3NzaWJsZS4gSG9va2lu
Zwo+Pj4gdXAgcmFuZ2UtYmFzZWQgaW52YWxpZGF0aW9ucyBpcyBnb2luZyB0byBiZSBhIG1hc3Np
dmUgaGVhZGFjaGUgaWYgdGhlCj4+PiBhYnN0cmFjdGlvbiBpc24ndCBzb2xpZC4KPj4KPj4gVGhl
IGNvbmNlcm4gaXMgdGhlIGhvc3QgZG9lcyBub3QgIm93biIgdGhlIHMxIGNvbmZpZyBhc2lkCj4+
IChzbW11X2RvbWFpbi0+czFfY2ZnLmNkLmFzaWQgaXMgbm90IHNldCwgcHJhY3RpY2FsbHkpLiBJ
biBvdXIgY2FzZSB0aGUKPj4gYXNpZCBvbmx5IGlzIHBhc3NlZCBieSB0aGUgdXNlcnNwYWNlIG9u
IENBQ0hFX0lOVkFMSURBVEUgaW9jdGwgY2FsbC4KPj4KPj4gYXJtX3NtbXVfdGxiX2ludl9jb250
ZXh0IGFuZCBhcm1fc21tdV90bGJfaW52X3JhbmdlX25vc3luYyB1c2UgdGhpcyBmaWVsZAo+IAo+
IFJpZ2h0LCBidXQgdGhhdCdzIG5vdCBleGFjdGx5IGhhcmQgdG8gc29sdmUuIEV2ZW4ganVzdCBz
b21ldGhpbmcgbGlrZQo+IHRoZSAodW50ZXN0ZWQsIHB1cmVseSBpbGx1c3RyYXRpdmUpIHJlZmFj
dG9yaW5nIGJlbG93IHdvdWxkIGJlIGJlbmVmaWNpYWwuClN1cmUgSSBjYW4gZ28gdGhpcyB3YXku
CgpUaGFuayB5b3UgZm9yIGRldGFpbGluZwoKRXJpYwo+IAo+IFJvYmluLgo+IAo+IC0tLS0tPjgt
LS0tLQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2FybS1zbW11LXYzLmMgYi9kcml2ZXJz
L2lvbW11L2FybS1zbW11LXYzLmMKPiBpbmRleCBkMzg4MDAxMGM2Y2YuLjMxZWY3MDNjZjY3MSAx
MDA2NDQKPiAtLS0gYS9kcml2ZXJzL2lvbW11L2FybS1zbW11LXYzLmMKPiArKysgYi9kcml2ZXJz
L2lvbW11L2FybS1zbW11LXYzLmMKPiBAQCAtMTQyMywxMSArMTQyMyw5IEBAIHN0YXRpYyB2b2lk
IGFybV9zbW11X3RsYl9pbnZfY29udGV4dCh2b2lkICpjb29raWUpCj4gwqDCoMKgwqAgYXJtX3Nt
bXVfY21kcV9pc3N1ZV9zeW5jKHNtbXUpOwo+IMKgfQo+IAo+IC1zdGF0aWMgdm9pZCBhcm1fc21t
dV90bGJfaW52X3JhbmdlX25vc3luYyh1bnNpZ25lZCBsb25nIGlvdmEsIHNpemVfdCBzaXplLAo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZV90IGdyYW51
bGUsIGJvb2wgbGVhZiwgdm9pZCAqY29va2llKQo+ICtzdGF0aWMgdm9pZCBfX2FybV9zbW11X3Rs
Yl9pbnZfcmFuZ2Uoc3RydWN0IGFybV9zbW11X2RvbWFpbgo+ICpzbW11X2RvbWFpbiwgdTE2IGFz
aWQsCj4gK8KgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgaW92YSwgc2l6ZV90IHNpemUsIHNp
emVfdCBncmFudWxlLCBib29sIGxlYWYpCj4gwqB7Cj4gLcKgwqDCoCBzdHJ1Y3QgYXJtX3NtbXVf
ZG9tYWluICpzbW11X2RvbWFpbiA9IGNvb2tpZTsKPiAtwqDCoMKgIHN0cnVjdCBhcm1fc21tdV9k
ZXZpY2UgKnNtbXUgPSBzbW11X2RvbWFpbi0+c21tdTsKPiDCoMKgwqDCoCBzdHJ1Y3QgYXJtX3Nt
bXVfY21kcV9lbnQgY21kID0gewo+IMKgwqDCoMKgwqDCoMKgwqAgLnRsYmkgPSB7Cj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIC5sZWFmwqDCoMKgID0gbGVhZiwKPiBAQCAtMTQzNywxOCArMTQz
NSwyNyBAQCBzdGF0aWMgdm9pZAo+IGFybV9zbW11X3RsYl9pbnZfcmFuZ2Vfbm9zeW5jKHVuc2ln
bmVkIGxvbmcgaW92YSwgc2l6ZV90IHNpemUsCj4gCj4gwqDCoMKgwqAgaWYgKHNtbXVfZG9tYWlu
LT5zdGFnZSA9PSBBUk1fU01NVV9ET01BSU5fUzEpIHsKPiDCoMKgwqDCoMKgwqDCoMKgIGNtZC5v
cGNvZGXCoMKgwqAgPSBDTURRX09QX1RMQklfTkhfVkE7Cj4gLcKgwqDCoMKgwqDCoMKgIGNtZC50
bGJpLmFzaWTCoMKgwqAgPSBzbW11X2RvbWFpbi0+czFfY2ZnLmNkLmFzaWQ7Cj4gK8KgwqDCoMKg
wqDCoMKgIGNtZC50bGJpLmFzaWTCoMKgwqAgPSBhc2lkOwo+IMKgwqDCoMKgIH0gZWxzZSB7Cj4g
wqDCoMKgwqDCoMKgwqDCoCBjbWQub3Bjb2RlwqDCoMKgID0gQ01EUV9PUF9UTEJJX1MyX0lQQTsK
PiDCoMKgwqDCoMKgwqDCoMKgIGNtZC50bGJpLnZtaWTCoMKgwqAgPSBzbW11X2RvbWFpbi0+czJf
Y2ZnLnZtaWQ7Cj4gwqDCoMKgwqAgfQo+IAo+IMKgwqDCoMKgIGRvIHsKPiAtwqDCoMKgwqDCoMKg
wqAgYXJtX3NtbXVfY21kcV9pc3N1ZV9jbWQoc21tdSwgJmNtZCk7Cj4gK8KgwqDCoMKgwqDCoMKg
IGFybV9zbW11X2NtZHFfaXNzdWVfY21kKHNtbXVfZG9tYWluLT5zbW11LCAmY21kKTsKPiDCoMKg
wqDCoMKgwqDCoMKgIGNtZC50bGJpLmFkZHIgKz0gZ3JhbnVsZTsKPiDCoMKgwqDCoCB9IHdoaWxl
IChzaXplIC09IGdyYW51bGUpOwo+IMKgfQo+IAo+ICtzdGF0aWMgdm9pZCBhcm1fc21tdV90bGJf
aW52X3JhbmdlX25vc3luYyh1bnNpZ25lZCBsb25nIGlvdmEsIHNpemVfdCBzaXplLAo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZV90IGdyYW51bGUsIGJv
b2wgbGVhZiwgdm9pZCAqY29va2llKQo+ICt7Cj4gK8KgwqDCoCBzdHJ1Y3QgYXJtX3NtbXVfZG9t
YWluICpzbW11X2RvbWFpbiA9IGNvb2tpZTsKPiArCj4gK8KgwqDCoCBfX2FybV9zbW11X3RsYl9p
bnZfcmFuZ2Uoc21tdV9kb21haW4sIHNtbXVfZG9tYWluLT5zMV9jZmcuY2QuYXNpZCwKPiBpb3Zh
LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemUsIGdyYW51bGUsIGxlYWYpOwo+ICt9Cj4g
Kwo+IMKgc3RhdGljIGNvbnN0IHN0cnVjdCBpb21tdV9nYXRoZXJfb3BzIGFybV9zbW11X2dhdGhl
cl9vcHMgPSB7Cj4gwqDCoMKgwqAgLnRsYl9mbHVzaF9hbGzCoMKgwqAgPSBhcm1fc21tdV90bGJf
aW52X2NvbnRleHQsCj4gwqDCoMKgwqAgLnRsYl9hZGRfZmx1c2jCoMKgwqAgPSBhcm1fc21tdV90
bGJfaW52X3JhbmdlX25vc3luYywKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
