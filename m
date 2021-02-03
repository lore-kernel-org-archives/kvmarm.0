Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D37C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 17:29:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A709964F87
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 17:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A709964F87
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD68F4B249;
	Wed,  3 Feb 2021 12:29:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LzOw1dWKDYfY; Wed,  3 Feb 2021 12:29:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 891754B285;
	Wed,  3 Feb 2021 12:29:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3575D4B285
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 12:29:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ncxjcEEXUFFJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 12:29:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E20444B283
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 12:29:40 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 645D011FB;
 Wed,  3 Feb 2021 09:29:40 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 30D533F719;
 Wed,  3 Feb 2021 09:29:39 -0800 (PST)
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
To: Marc Zyngier <maz@kernel.org>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <680c2e4f-cc9f-10c1-1158-7de32057fb0d@arm.com>
 <20c1d805997523ae04f45be90fb4dd1a@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <606d0499-961d-53c5-e391-0f6f5fcd28cf@arm.com>
Date: Wed, 3 Feb 2021 17:29:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20c1d805997523ae04f45be90fb4dd1a@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKCk9uIDIvMy8yMSAxMDozMiBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIw
MjEtMDEtMjcgMTc6NDEsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+IEhpIE1hcmMsCj4+Cj4+
IEhhZCBhbm90aGVyIGxvb2sgYXQgdGhlIHBhdGNoLCBjb21tZW50cyBiZWxvdy4KPj4KPj4gT24g
MS8yNS8yMSAxMjoyNiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gVXBncmFkaW5nIHRoZSBQ
TVUgY29kZSBmcm9tIEFSTXY4LjEgdG8gQVJNdjguNCB0dXJucyBvdXQgdG8gYmUKPj4+IHByZXR0
eSBlYXN5LiBBbGwgdGhhdCBpcyByZXF1aXJlZCBpcyBzdXBwb3J0IGZvciBQTU1JUl9FTDEsIHdo
aWNoCj4+PiBpcyByZWFkLW9ubHksIGFuZCBmb3Igd2hpY2ggcmV0dXJuaW5nIDAgaXMgYSB2YWxp
ZCBvcHRpb24gYXMgbG9uZwo+Pj4gYXMgd2UgZG9uJ3QgYWR2ZXJ0aXNlIFNUQUxMX1NMT1QgYXMg
YW4gaW1wbGVtZW50ZWQgZXZlbnQuCj4+Pgo+Pj4gTGV0J3MganVzdCBkbyB0aGF0IGFuZCBhZGp1
c3Qgd2hhdCB3ZSByZXR1cm4gdG8gdGhlIGd1ZXN0Lgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IE1h
cmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4+PiAtLS0KPj4+IMKgYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9zeXNyZWcuaCB8wqAgMyArKysKPj4+IMKgYXJjaC9hcm02NC9rdm0vcG11LWVtdWwu
Y8KgwqDCoMKgwqDCoCB8wqAgNiArKysrKysKPj4+IMKgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3Mu
Y8KgwqDCoMKgwqDCoCB8IDExICsrKysrKystLS0tCj4+PiDCoDMgZmlsZXMgY2hhbmdlZCwgMTYg
aW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVn
LmgKPj4+IGluZGV4IDhiNWU3ZTVjM2NjOC4uMmZiM2YzODY1ODhjIDEwMDY0NAo+Pj4gLS0tIGEv
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaAo+Pj4gKysrIGIvYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9zeXNyZWcuaAo+Pj4gQEAgLTg0Niw3ICs4NDYsMTAgQEAKPj4+Cj4+PiDCoCNkZWZp
bmUgSURfREZSMF9QRVJGTU9OX1NISUZUwqDCoMKgwqDCoMKgwqAgMjQKPj4+Cj4+PiArI2RlZmlu
ZSBJRF9ERlIwX1BFUkZNT05fOF8wwqDCoMKgwqDCoMKgwqAgMHgzCj4+PiDCoCNkZWZpbmUgSURf
REZSMF9QRVJGTU9OXzhfMcKgwqDCoMKgwqDCoMKgIDB4NAo+Pj4gKyNkZWZpbmUgSURfREZSMF9Q
RVJGTU9OXzhfNMKgwqDCoMKgwqDCoMKgIDB4NQo+Pj4gKyNkZWZpbmUgSURfREZSMF9QRVJGTU9O
XzhfNcKgwqDCoMKgwqDCoMKgIDB4Ngo+Pj4KPj4+IMKgI2RlZmluZSBJRF9JU0FSNF9TV1BfRlJB
Q19TSElGVMKgwqDCoMKgwqDCoMKgIDI4Cj4+PiDCoCNkZWZpbmUgSURfSVNBUjRfUFNSX01fU0hJ
RlTCoMKgwqDCoMKgwqDCoCAyNAo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3BtdS1l
bXVsLmMgYi9hcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jCj4+PiBpbmRleCAzOThmNmRmMWJiZTQu
LjcyY2Q3MDRhODM2OCAxMDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMK
Pj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+IEBAIC03OTUsNiArNzk1LDEy
IEBAIHU2NCBrdm1fcG11X2dldF9wbWNlaWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBib29sIHBt
Y2VpZDEpCj4+PiDCoMKgwqDCoMKgwqDCoMKgIGJhc2UgPSAwOwo+Pj4gwqDCoMKgwqAgfSBlbHNl
IHsKPj4+IMKgwqDCoMKgwqDCoMKgwqAgdmFsID0gcmVhZF9zeXNyZWcocG1jZWlkMV9lbDApOwo+
Pj4gK8KgwqDCoMKgwqDCoMKgIC8qCj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqIERvbid0IGFkdmVy
dGlzZSBTVEFMTF9TTE9ULCBhcyBQTU1JUl9FTDAgaXMgaGFuZGxlZAo+Pj4gK8KgwqDCoMKgwqDC
oMKgwqAgKiBhcyBSQVoKPj4+ICvCoMKgwqDCoMKgwqDCoMKgICovCj4+PiArwqDCoMKgwqDCoMKg
wqAgaWYgKHZjcHUtPmt2bS0+YXJjaC5wbXV2ZXIgPj0gSURfQUE2NERGUjBfUE1VVkVSXzhfNCkK
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZhbCAmPSB+QklUX1VMTChBUk1WOF9QTVVWM19Q
RVJGQ1RSX1NUQUxMX1NMT1QgLSAzMik7Cj4+Cj4+IFRoaXMgaXMgY29uZnVzaW5nIHRoZSBtZS4g
V2UgaGF2ZSBrdm0tPmFyY2gucG11dmVyIHNldCB0byB0aGUgaGFyZHdhcmUKPj4gUE1VIHZlcnNp
b24KPj4gKGFzIHNldCBieSBfX2FybXY4cG11X3Byb2JlX3BtdSgpKSwgYnV0IHdlIGlnbm9yZSBp
dCB3aGVuIHJlcG9ydGluZyB0aGUgUE1VCj4+IHZlcnNpb24gdG8gdGhlIGd1ZXN0LiBXaHkgZG8g
d2UgZG8gdGhhdD8gV2UgbGltaXQgdGhlIGV2ZW50IG51bWJlciBpbgo+PiBrdm1fcG11X2V2ZW50
X21hc2soKSBiYXNlZCBvbiB0aGUgaGFyZHdhcmUgUE1VIHZlcnNpb24sIHNvIGV2ZW4gaWYgd2Ug
YWR2ZXJ0aXNlCj4+IEFybXY4LjQgUE1VLCBzdXBwb3J0IGZvciBhbGwgdGhvc2UgZXh0cmEgZXZl
bnRzIGFkZGVkIGJ5IEFybTguMSBQTVUgaXMKPj4gbWlzc2luZyAoSSBob3BlIEkgdW5kZXJzdG9v
ZCB0aGUgY29kZSBjb3JyZWN0bHkpLgo+Cj4gVGhhdCdzIGEgYml0IG9mIG1lc3MtdXAuIFdlIG9i
dGFpbiBJRF9BQTY0REZSMF9FTDEgZnJvbSB0aGUgc2FuaXRpc2VkCj4gcmVncywgYnV0IGRvIG1v
c3Qgb2Ygb3VyIGhhbmRsaW5nIGJhc2VkIG9uIGt2bS0+YXJjaC5wbXV2ZXIuIFRoZXkgcmVhbGx5
Cj4gc2hvdWxkIGJlIHRoZSBzYW1lLCBiZWNhdXNlIHRoYXQncyB3aGF0IHRoZSBzYW5pdGlzZWQg
cmVnaXN0ZXJzIGdpdmUKPiB5b3UuCj4KPiBBcyBmb3IgdGhlIGV2ZW50cyB0aGVtc2VsdmVzLCBJ
IGRvbid0IGdldCB5b3VyIGRyaWZ0LiBXZSBkbyBzdXBwb3J0Cj4gYWxsIHRoZSBBUk12OC4xIFBN
VSBldmVudHMgYXMgbG9uZyBhcyB0aGUgSFcgc3VwcG9ydHMgaXQsIGFuZCB3ZQo+IGRvbid0IGxp
ZSB0byB0aGUgZ3Vlc3QgYWJvdXQgaXQgZWl0aGVyIChjcHVpZF9mZWF0dXJlX2NhcF9wZXJmbW9u
X2ZpZWxkCj4gZG9lcyAqY2FwKiB0aGUgZmllbGQgdG8gc29tZSB2YWx1ZSwgaXQgZG9lc24ndCBh
bGxvdyBpdCB0byBpbmNyZWFzZQo+IHBhc3Qgd2hhdCB0aGUgSFcgc3VwcG9ydHMpLgpUaGF0J3Mg
dGhlIHBpZWNlIHRoYXQgSSB3YXMgbWlzc2luZyAtIEkgZGlkbid0IHJlYWxpemUgdGhhdApjcHVp
ZF9mZWF0dXJlX2NhcF9wZXJmbW9uX2ZpZWxkKCkgbWFrZXMgc3VyZSB0aGF0IHRoZSBmaW5hbCB2
ZXJzaW9uIGRvZXNuJ3QgZXhjZWVkCndoYXQgdGhlIGhhcmR3YXJlIHN1cHBvcnRzLiBUaGFua3Mg
Zm9yIGNsZWFyaW5nIGl0IHVwIQo+Cj4+IEkgbG9va2VkIGF0IGNvbW1pdCBjODU0MTg4ZWEwMTAg
KCJLVk06IGFybTY0OiBsaW1pdCBQTVUgdmVyc2lvbiB0byBQTVV2MyBmb3IKPj4gQVJNdjguMSIp
IHdoaWNoIGNoYW5nZWQgcmVhZF9pZF9yZWcoKSB0byByZXBvcnQgUE1VdjMgZm9yIEFybXY4LjEK
Pj4gdW5jb25kaXRpb25hbGx5LAo+PiBhbmQgdGhlcmUncyBubyBleHBsYW5hdGlvbiB3aHkgUE1V
djMgZm9yIEFybXY4LjEgd2FzIGNob3NlbiBpbnN0ZWFkIG9mCj4+IHBsYWluIFBNVXYzIChQTVVW
ZXIgPSAwYjAxMDApLgo+Cj4gV2UgcGlja2VkIEFSTXY4LjEgYmVjYXVzZSB0aGlzIGlzIHRoZSBm
aXJzdCBQTVUgcmV2aXNpb24gdGhhdCBnaXZlcwo+IHlvdSBldmVudHMgaW4gdGhlIDB4NDAwMCBy
YW5nZSwgYWxsIG9mIHdoaWNoIGFyZSBhdmFpbGFibGUgb24KPiBjb21tb24gQVJNdjguMiBIVy4K
ClllcywgbWFrZXMgc2Vuc2UgaW4gdGhlIGNvbnRleHQgb2YgY3B1aWRfZmVhdHVyZV9jYXBfcGVy
Zm1vbl9maWVsZCgpIGNhcHBpbmcKUE1VVmVyIGJhc2VkIG9uIHRoZSBoYXJkd2FyZSBzdXBwb3J0
ZWQgdmVyc2lvbi4KClRoYW5rcywKQWxleApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
