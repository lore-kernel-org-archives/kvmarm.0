Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E414C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 07:24:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A402F4B1DC;
	Wed, 12 Jan 2022 02:24:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z5GyzJxJVAkx; Wed, 12 Jan 2022 02:24:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9754B0DE;
	Wed, 12 Jan 2022 02:24:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76FD840C1B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 02:24:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4PSNL8hydziB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 02:24:24 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B39B40256
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 02:24:24 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641972264;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4/5pK0Zr6DD8A5nn05o+mZc3e8AW7Gue1WA4ZvFpbm8=;
 b=RVPfnuAdFLOTFu4OKtEkdS81/6vyg93Hg0bp94MTbkLq5S744QL+veq03nE1H/ei6MMUGY
 Vd/qQ34WzkelNrOhCYoGc3Bx9W5AeSQoEugSK2WJ0fjkdab49OXyg53RX7dbr6AuWK5AmM
 RQT0aeG5G24wKuBtCCbF9fdR6m185ss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-PyQcd5q3MT2vf5hnsOavGw-1; Wed, 12 Jan 2022 02:24:20 -0500
X-MC-Unique: PyQcd5q3MT2vf5hnsOavGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 753E713EA;
 Wed, 12 Jan 2022 07:24:19 +0000 (UTC)
Received: from [10.72.12.204] (ovpn-12-204.pek2.redhat.com [10.72.12.204])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 460D95F92B;
 Wed, 12 Jan 2022 07:24:15 +0000 (UTC)
Subject: Re: [PATCH v4 00/21] Support SDEI Virtualization
To: Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <eee7eeb2-cedf-e52f-1e5f-403d9edabd94@redhat.com>
 <7f5e86dd-b38d-8699-58bd-35db78ec1b7a@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <cb75497e-6e24-3b9e-36b2-a80a6478c439@redhat.com>
Date: Wed, 12 Jan 2022 15:24:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <7f5e86dd-b38d-8699-58bd-35db78ec1b7a@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

SGkgRXJpYywKCk9uIDExLzEwLzIxIDEwOjI5IFBNLCBFcmljIEF1Z2VyIHdyb3RlOgo+IE9uIDgv
MTUvMjEgMjoxOSBBTSwgR2F2aW4gU2hhbiB3cm90ZToKPj4gT24gOC8xNS8yMSAxMDoxMyBBTSwg
R2F2aW4gU2hhbiB3cm90ZToKPj4+IFRoaXMgc2VyaWVzIGludGVuZHMgdG8gdmlydHVhbGl6ZSBT
b2Z0d2FyZSBEZWxlZ2F0ZWQgRXhjZXB0aW9uIEludGVyZmFjZQo+Pj4gKFNERUkpLCB3aGljaCBp
cyBkZWZpbmVkIGJ5IERFTjAwNTRBLiBJdCBhbGxvd3MgdGhlIGh5cGVydmlzb3IgdG8gZGVsaXZl
cgo+Pj4gTk1JLWFsaWtlIGV2ZW50IHRvIGd1ZXN0IGFuZCBpdCdzIG5lZWRlZCBieSBhc3luY2hy
b25vdXMgcGFnZSBmYXVsdCB0bwo+Pj4gZGVsaXZlciBwYWdlLW5vdC1wcmVzZW50IG5vdGlmaWNh
dGlvbiBmcm9tIGh5cGVydmlzb3IgdG8gZ3Vlc3QuIFRoZSBjb2RlCj4+PiBhbmQgdGhlIHJlcXVp
cmVkIHFlbXUgY2hhbmdlcyBjYW4gYmUgZm91bmQgZnJvbToKPj4+Cj4+PiAgwqDCoMKgIGh0dHBz
Oi8vZGV2ZWxvcGVyLmFybS5jb20vZG9jdW1lbnRhdGlvbi9kZW4wMDU0L2xhdGVzdAo+Pj4gIMKg
wqDCoCBodHRwczovL2dpdGh1Yi5jb20vZ3dzaGFuL2xpbnV4wqDCoMKgICgia3ZtL2FybTY0X3Nk
ZWkiKQo+Pj4gIMKgwqDCoCBodHRwczovL2dpdGh1Yi5jb20vZ3dzaGFuL3FlbXXCoMKgwqDCoCAo
Imt2bS9hcm02NF9zZGVpIikKPj4+Cj4+PiBUaGUgU0RFSSBldmVudCBpcyBpZGVudGlmaWVkIGJ5
IGEgMzItYml0cyBudW1iZXIuIEJpdHNbMzE6MjRdIGFyZSB1c2VkCj4+PiB0byBpbmRpY2F0ZSB0
aGUgU0RFSSBldmVudCBwcm9wZXJ0aWVzIHdoaWxlIGJpdHNbMjM6MF0gYXJlIGlkZW50aWZ5aW5n
Cj4+PiB0aGUgdW5pcXVlIG51bWJlci4gVGhlIGltcGxlbWVudGF0aW9uIHRha2VzIGJpdHNbMjM6
MjJdIHRvIGluZGljYXRlIHRoZQo+Pj4gb3duZXIgb2YgdGhlIFNERUkgZXZlbnQuIEZvciBleGFt
cGxlLCB0aG9zZSBTREVJIGV2ZW50cyBvd25lZCBieSBLVk0KPj4+IHNob3VsZCBoYXZlIHRoZXNl
IHR3byBiaXRzIHNldCB0byAwYjAxLiBCZXNpZGVzLCB0aGUgaW1wbGVtZW50YXRpb24KPj4+IHN1
cHBvcnRzIFNERUkgZXZlbnRzIG93bmVkIGJ5IEtWTSBvbmx5Lgo+Pj4KPj4+IFRoZSBkZXNpZ24g
aXMgcHJldHR5IHN0cmFpZ2h0Zm9yd2FyZCBhbmQgdGhlIGltcGxlbWVudGF0aW9uIGlzIGp1c3QK
Pj4+IGZvbGxvd2luZyB0aGUgU0RFSSBzcGVjaWZpY2F0aW9uLCB0byBzdXBwb3J0IHRoZSBkZWZp
bmVkIFNNQ0NDIGludGVmYWNlcywKPj4+IGV4Y2VwdCB0aGUgSVJRIGJpbmRpbmcgc3R1ZmYuIFRo
ZXJlIGFyZSBzZXZlcmFsIGRhdGEgc3RydWN0dXJlcwo+Pj4gaW50cm9kdWNlZC4KPj4+IFNvbWUg
b2YgdGhlIG9iamVjdHMgaGF2ZSB0byBiZSBtaWdyYXRlZCBieSBWTU0uIFNvIHRoZWlyIGRlZmlu
aXRpb25zIGFyZQo+Pj4gc3BsaXQgdXAgZm9yIFZNTSB0byBpbmNsdWRlIHRoZSBjb3JyZXNwb25k
aW5nIHN0YXRlcyBmb3IgbWlncmF0aW9uLgo+Pj4KPj4+ICDCoMKgwqAgc3RydWN0IGt2bV9zZGVp
X2t2bQo+Pj4gIMKgwqDCoMKgwqDCoCBBc3NvY2lhdGVkIHdpdGggVk0gYW5kIHVzZWQgdG8gdHJh
Y2sgdGhlIEtWTSBleHBvc2VkIFNERUkgZXZlbnRzCj4+PiAgwqDCoMKgwqDCoMKgIGFuZCB0aG9z
ZSByZWdpc3RlcmVkIGJ5IGd1ZXN0Lgo+Pj4gIMKgwqDCoCBzdHJ1Y3Qga3ZtX3NkZWlfdmNwdQo+
Pj4gIMKgwqDCoMKgwqDCoCBBc3NvY2lhdGVkIHdpdGggdkNQVSBhbmQgdXNlZCB0byB0cmFjayBT
REVJIGV2ZW50IGRlbGl2ZXJ5LiBUaGUKPj4+ICDCoMKgwqDCoMKgwqAgcHJlZW1wdGVkIGNvbnRl
eHQgaXMgc2F2ZWQgcHJpb3IgdG8gdGhlIGRlbGl2ZXJ5IGFuZCByZXN0b3JlZAo+Pj4gIMKgwqDC
oMKgwqDCoCBhZnRlciB0aGF0Lgo+Pj4gIMKgwqDCoCBzdHJ1Y3Qga3ZtX3NkZWlfZXZlbnQKPj4+
ICDCoMKgwqDCoMKgwqAgU0RFSSBldmVudHMgZXhwb3NlZCBieSBLVk0gc28gdGhhdCBndWVzdCBj
YW4gcmVnaXN0ZXIgYW5kIGVuYWJsZS4KPj4+ICDCoMKgwqAgc3RydWN0IGt2bV9zZGVpX2t2bV9l
dmVudAo+Pj4gIMKgwqDCoMKgwqDCoCBTREVJIGV2ZW50cyB0aGF0IGhhdmUgYmVlbiByZWdpc3Rl
cmVkIGJ5IGd1ZXN0Lgo+Pj4gIMKgwqDCoCBzdHJ1Y3Qga3ZtX3NkZWlfdmNwdV9ldmVudAo+Pj4g
IMKgwqDCoMKgwqDCoCBTREVJIGV2ZW50cyB0aGF0IGhhdmUgYmVlbiBxdWV1ZWQgdG8gc3BlY2lm
aWMgdkNQVSBmb3IgZGVsaXZlcnkuCj4+Pgo+Pj4gVGhlIHNlcmllcyBpcyBvcmdhbml6ZWQgYXMg
YmVsb3c6Cj4+Pgo+Pj4gIMKgwqDCoCBQQVRDSFswMV3CoMKgwqAgSW50cm9kdWNlcyB0ZW1wbGF0
ZSBmb3Igc21jY2NfZ2V0X2FyZ3goKQo+Pj4gIMKgwqDCoCBQQVRDSFswMl3CoMKgwqAgSW50cm9k
dWNlcyB0aGUgZGF0YSBzdHJ1Y3R1cmVzIGFuZCBpbmZyYXN0cnVjdHVyZQo+Pj4gIMKgwqDCoCBQ
QVRDSFswMy0xNF0gU3VwcG9ydHMgdmFyaW91cyBTREVJIHJlbGF0ZWQgaHlwZXJjYWxscwo+Pj4g
IMKgwqDCoCBQQVRDSFsxNV3CoMKgwqAgU3VwcG9ydHMgU0RFSSBldmVudCBub3RpZmljYXRpb24K
Pj4+ICDCoMKgwqAgUEFUQ0hbMTYtMTddIEludHJvZHVjZXMgaW9jdGwgY29tbWFuZCBmb3IgbWln
cmF0aW9uCj4+PiAgwqDCoMKgIFBBVENIWzE4LTE5XSBTdXBwb3J0cyBTREVJIGV2ZW50IGluamVj
dGlvbiBhbmQgY2FuY2VsbGF0aW9uCj4+PiAgwqDCoMKgIFBBVENIWzIwXcKgwqDCoCBFeHBvcnRz
IFNERUkgY2FwYWJpbGl0eQo+Pj4gIMKgwqDCoCBQQVRDSFsyMV3CoMKgwqAgQWRkcyBzZWxmLXRl
c3QgY2FzZSBmb3IgU0RFSSB2aXJ0dWFsaXphdGlvbgo+Pj4KPj4KPj4gWy4uLl0KPj4KPj4gSSBl
eHBsaWNpdGx5IGNvcGllZCBKYW1lcyBNb3JzZSBhbmQgTWFyayBSdXRsYW5kIHdoZW4gcG9zdGlu
ZyB0aGUgc2VyaWVzLAo+PiBidXQgc29tZXRoaW5nIHVua25vd24gd2VudCB3cm9uZy4gSSdtIGlu
Y2x1ZGluZyB0aGVtIGhlcmUgdG8gYXZvaWQKPj4gcmVwb3N0aW5nIHRoZSB3aG9sZSBzZXJpZXMu
Cj4gSSBkb24ndCBzZWUgSmFtZXMgbm9yIE1hcmsgaW5jbHVkZWQgaGVyZSBlaXRoZXIKPiAKClll
YWgsIEkgdXNlZCB0aGUgZm9sbG93aW5nIGNvbW1hbmQgdG8gcG9zdCB0aGUgc2VyaWVzLCBidXQg
SSBkb24ndCBrbm93CndoeSBKYW1lcy9NYXJrIGFyZSBtaXNzZWQuIEknbSBub3Qgc3VyZSBpdCdz
IGdpdC1zZW5kZW1haWwgaXNzdWUgb3Igbm90CnNvIGZhci4gVGhlIGlzc3VlIGFwcGVhcnMgc29t
ZSB0aW1lcyBvbiBteSBsYXB0b3AgOikKCiMgZ2l0LXNlbmRlbWFpbCAtLXRvPTxtYWlsMD4gLS1j
Yz08bWFpbDE+IC0tY2M9PG1haWwyPiAqLnBhdGNoCgpUaGFua3MsCkdhdmluCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
