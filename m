Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18EE8C433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 11:20:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76E3D64F61
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 11:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76E3D64F61
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFE984B246;
	Wed,  3 Feb 2021 06:20:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Od12GZPvqD6B; Wed,  3 Feb 2021 06:20:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA6C44B24C;
	Wed,  3 Feb 2021 06:20:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 167E34B246
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 06:20:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BAHZTaPE27Hn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 06:20:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C50614B23B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 06:20:40 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 760BD64F67;
 Wed,  3 Feb 2021 11:20:39 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l7GD7-00BjXu-B6; Wed, 03 Feb 2021 11:20:37 +0000
MIME-Version: 1.0
Date: Wed, 03 Feb 2021 11:20:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
In-Reply-To: <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
 <adbdbfbcecb65a1eca21afa622679836@kernel.org>
 <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

T24gMjAyMS0wMi0wMyAxMTowNywgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBNYXJjLAo+IE9uIDIv
My8yMSAxMTozNiBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBIaSBFcmljLAo+PiAKPj4gT24g
MjAyMS0wMS0yNyAxNzo1MywgQXVnZXIgRXJpYyB3cm90ZToKPj4+IEhpIE1hcmMsCj4+PiAKPj4+
IE9uIDEvMjUvMjEgMToyNiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+IFVwZ3JhZGluZyB0
aGUgUE1VIGNvZGUgZnJvbSBBUk12OC4xIHRvIEFSTXY4LjQgdHVybnMgb3V0IHRvIGJlCj4+Pj4g
cHJldHR5IGVhc3kuIEFsbCB0aGF0IGlzIHJlcXVpcmVkIGlzIHN1cHBvcnQgZm9yIFBNTUlSX0VM
MSwgd2hpY2gKPj4+PiBpcyByZWFkLW9ubHksIGFuZCBmb3Igd2hpY2ggcmV0dXJuaW5nIDAgaXMg
YSB2YWxpZCBvcHRpb24gYXMgbG9uZwo+Pj4+IGFzIHdlIGRvbid0IGFkdmVydGlzZSBTVEFMTF9T
TE9UIGFzIGFuIGltcGxlbWVudGVkIGV2ZW50Lgo+Pj4+IAo+Pj4+IExldCdzIGp1c3QgZG8gdGhh
dCBhbmQgYWRqdXN0IHdoYXQgd2UgcmV0dXJuIHRvIHRoZSBndWVzdC4KPj4+PiAKPj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPgo+Pj4+IC0tLQo+Pj4+IMKg
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaCB8wqAgMyArKysKPj4+PiDCoGFyY2gvYXJt
NjQva3ZtL3BtdS1lbXVsLmPCoMKgwqDCoMKgwqAgfMKgIDYgKysrKysrCj4+Pj4gwqBhcmNoL2Fy
bTY0L2t2bS9zeXNfcmVncy5jwqDCoMKgwqDCoMKgIHwgMTEgKysrKysrKy0tLS0KPj4+PiDCoDMg
ZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKPj4+PiAKPj4+
PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaAo+Pj4+IGIvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaAo+Pj4+IGluZGV4IDhiNWU3ZTVjM2NjOC4uMmZi
M2YzODY1ODhjIDEwMDY0NAo+Pj4+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVn
LmgKPj4+PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+Pj4gQEAgLTg0
Niw3ICs4NDYsMTAgQEAKPj4+PiAKPj4+PiDCoCNkZWZpbmUgSURfREZSMF9QRVJGTU9OX1NISUZU
wqDCoMKgwqDCoMKgwqAgMjQKPj4+PiAKPj4+PiArI2RlZmluZSBJRF9ERlIwX1BFUkZNT05fOF8w
wqDCoMKgwqDCoMKgwqAgMHgzCj4+Pj4gwqAjZGVmaW5lIElEX0RGUjBfUEVSRk1PTl84XzHCoMKg
wqDCoMKgwqDCoCAweDQKPj4+PiArI2RlZmluZSBJRF9ERlIwX1BFUkZNT05fOF80wqDCoMKgwqDC
oMKgwqAgMHg1Cj4+Pj4gKyNkZWZpbmUgSURfREZSMF9QRVJGTU9OXzhfNcKgwqDCoMKgwqDCoMKg
IDB4Ngo+Pj4+IAo+Pj4+IMKgI2RlZmluZSBJRF9JU0FSNF9TV1BfRlJBQ19TSElGVMKgwqDCoMKg
wqDCoMKgIDI4Cj4+Pj4gwqAjZGVmaW5lIElEX0lTQVI0X1BTUl9NX1NISUZUwqDCoMKgwqDCoMKg
wqAgMjQKPj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYyBiL2FyY2gv
YXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+PiBpbmRleCAzOThmNmRmMWJiZTQuLjcyY2Q3MDRhODM2
OCAxMDA2NDQKPj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jCj4+Pj4gKysrIGIv
YXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+Pj4+IEBAIC03OTUsNiArNzk1LDEyIEBAIHU2NCBr
dm1fcG11X2dldF9wbWNlaWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+Pj4+IGJvb2wgcG1jZWlk
MSkKPj4+PiDCoMKgwqDCoMKgwqDCoMKgIGJhc2UgPSAwOwo+Pj4+IMKgwqDCoMKgIH0gZWxzZSB7
Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCB2YWwgPSByZWFkX3N5c3JlZyhwbWNlaWQxX2VsMCk7Cj4+
Pj4gK8KgwqDCoMKgwqDCoMKgIC8qCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBEb24ndCBhZHZl
cnRpc2UgU1RBTExfU0xPVCwgYXMgUE1NSVJfRUwwIGlzIGhhbmRsZWQKPj4+PiArwqDCoMKgwqDC
oMKgwqDCoCAqIGFzIFJBWgo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgICovCj4+Pj4gK8KgwqDCoMKg
wqDCoMKgIGlmICh2Y3B1LT5rdm0tPmFyY2gucG11dmVyID49IElEX0FBNjRERlIwX1BNVVZFUl84
XzQpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmFsICY9IH5CSVRfVUxMKEFSTVY4X1BN
VVYzX1BFUkZDVFJfU1RBTExfU0xPVCAtIDMyKTsKPj4+IHdoYXQgYWJvdXQgdGhlIFNUQUxMX1NM
T1RfQkFDS0VORCBhbmQgRlJPTlRFTkQgZXZlbnRzIHRoZW4/Cj4+IAo+PiBBcmVuJ3QgdGhlc2Ug
YSBtYW5kYXRvcnkgQVJNdjguMSBmZWF0dXJlPyBJIGRvbid0IHNlZSBhIHJlYXNvbiB0bwo+PiBk
cm9wIHRoZW0uCj4gCj4gSSB1bmRlcnN0YW5kIHRoZSAzIGFyZSBsaW5rZWQgdG9nZXRoZXIuCj4g
Cj4gSW4gRDcuMTEgaXQgaXMgc2FpZAo+ICIKPiBXaGVuIGFueSBvZiB0aGUgZm9sbG93aW5nIGNv
bW1vbiBldmVudHMgYXJlIGltcGxlbWVudGVkLCBhbGwgdGhyZWUgb2YKPiB0aGVtIGFyZSBpbXBs
ZW1lbnRlZDoKPiAweDAwM0QgLCBTVEFMTF9TTE9UX0JBQ0tFTkQsIE5vIG9wZXJhdGlvbiBzZW50
IGZvciBleGVjdXRpb24gb24gYSBTbG90Cj4gZHVlIHRvIHRoZSBiYWNrZW5kLAo+IDB4MDAzRSAs
IFNUQUxMX1NMT1RfRlJPTlRFTkQsIE5vIG9wZXJhdGlvbiBzZW50IGZvciBleGVjdXRpb24gb24g
YSBTbG90Cj4gZHVlIHRvIHRoZSBmcm9udGVuZC4KPiAweDAwM0YgLCBTVEFMTF9TTE9ULCBObyBv
cGVyYXRpb24gc2VudCBmb3IgZXhlY3V0aW9uIG9uIGEgU2xvdC4KPiAiCgpUaGV5IGFyZSBsaW5r
ZWQgaW4gdGhlIHNlbnNlIHRoYXQgdGhleSByZXBvcnQgcmVsYXRlZCBldmVudHMsIGJ1dCB0aGV5
CmRvbid0IGhhdmUgdG8gYmUgaW1wbGVtZW50ZWQgaW4gdGhlIHNhbWUgbGV2ZWwgb2YgdGhlIGFy
Y2hpdGVjdXJlLCBpZiAKb25seQpiZWNhdXNlIEJBQ0tFTkQvRlJPTlRFTkQgd2VyZSBpbnRyb2R1
Y2Vkd2F5IGJlZm9yZSBBUk12OC40LgoKV2hhdCB0aGUgYXJjaGl0ZWN0dXJlIHNheXMgaXM6Cgot
IEZvciBGRUFUX1BNVXYzcDEgKEFSTXY4LjEpOgogICAiVGhlIFNUQUxMX0ZST05URU5EIGFuZCBT
VEFMTF9CQUNLRU5EIGV2ZW50cyBhcmUgcmVxdWlyZWQgdG8gYmUKICAgIGltcGxlbWVudGVkLiIg
KEEyLjQuMSwgRERJMDQ4N0cuYSkKCi0gRm9yIEZFQVRfUE1VdjNwNCAoQVJNdjguNCk6CiAgICJJ
ZiBGRUFUX1BNVXYzcDQgaXMgaW1wbGVtZW50ZWQ6CiAgICAtIElmIFNUQUxMX1NMT1QgaXMgbm90
IGltcGxlbWVudGVkLCBpdCBpcyBJTVBMRU1FTlRBVElPTiBERUZJTkVEIAp3aGV0aGVyIHRoZSBQ
TU1JUiBTeXN0ZW0gcmVnaXN0ZXJzIGFyZSBpbXBsZW1lbnRlZC4KICAgIC0gSWYgU1RBTExfU0xP
VCBpcyBpbXBsZW1lbnRlZCwgdGhlbiB0aGUgUE1NSVIgU3lzdGVtIHJlZ2lzdGVycyBhcmUgCmlt
cGxlbWVudGVkLiIgKEQ3LTI4NzMsIERESTA0ODdHLmEpCgpTbyB3aGlsZSBCQUNLRU5EL0ZST05U
RU5EIGFyZSByZXF1aXJlZCBpbiBhbiBBUk12OC40IGltcGxlbWVudGF0aW9uCmJ5IHZpcnR1ZSBv
ZiBiZWluZyBtYW5kYXRvcnkgaW4gQVJNdjguMSwgU1RBTExfU0xPVCBpc24ndCBhdCBhbnkgcG9p
bnQuCgpUaGFua3MsCgogICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qg
c21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
