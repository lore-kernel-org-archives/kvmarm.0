Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCAFC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 12:32:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78D3164DDB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 12:32:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78D3164DDB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D560F4B0F3;
	Thu,  4 Feb 2021 07:32:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SSXvD0mNVadH; Thu,  4 Feb 2021 07:32:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4044B223;
	Thu,  4 Feb 2021 07:32:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E1B4B21F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 07:32:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2VJoUt4JHOKn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 07:32:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D00244B21E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 07:32:27 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2CC4D6E;
 Thu,  4 Feb 2021 04:32:26 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DB543F73B;
 Thu,  4 Feb 2021 04:32:25 -0800 (PST)
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
To: Marc Zyngier <maz@kernel.org>, Auger Eric <eric.auger@redhat.com>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
 <adbdbfbcecb65a1eca21afa622679836@kernel.org>
 <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
 <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
 <d9f8b79a-74de-0058-aa14-4ed5ec3b6aab@redhat.com>
 <ac172223d388393004819e338728f45b@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7134513d-bccf-923f-961a-08527cf77f8e@arm.com>
Date: Thu, 4 Feb 2021 12:32:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <ac172223d388393004819e338728f45b@kernel.org>
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

SGksCgpPbiAyLzMvMjEgMToyOCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjEtMDIt
MDMgMTI6MzksIEF1Z2VyIEVyaWMgd3JvdGU6Cj4+IEhpLAo+Pgo+PiBPbiAyLzMvMjEgMTI6MjAg
UE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IE9uIDIwMjEtMDItMDMgMTE6MDcsIEF1Z2VyIEVy
aWMgd3JvdGU6Cj4+Pj4gSGkgTWFyYywKPj4+PiBPbiAyLzMvMjEgMTE6MzYgQU0sIE1hcmMgWnlu
Z2llciB3cm90ZToKPj4+Pj4gSGkgRXJpYywKPj4+Pj4KPj4+Pj4gT24gMjAyMS0wMS0yNyAxNzo1
MywgQXVnZXIgRXJpYyB3cm90ZToKPj4+Pj4+IEhpIE1hcmMsCj4+Pj4+Pgo+Pj4+Pj4gT24gMS8y
NS8yMSAxOjI2IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4+Pj4gVXBncmFkaW5nIHRoZSBQ
TVUgY29kZSBmcm9tIEFSTXY4LjEgdG8gQVJNdjguNCB0dXJucyBvdXQgdG8gYmUKPj4+Pj4+PiBw
cmV0dHkgZWFzeS4gQWxsIHRoYXQgaXMgcmVxdWlyZWQgaXMgc3VwcG9ydCBmb3IgUE1NSVJfRUwx
LCB3aGljaAo+Pj4+Pj4+IGlzIHJlYWQtb25seSwgYW5kIGZvciB3aGljaCByZXR1cm5pbmcgMCBp
cyBhIHZhbGlkIG9wdGlvbiBhcyBsb25nCj4+Pj4+Pj4gYXMgd2UgZG9uJ3QgYWR2ZXJ0aXNlIFNU
QUxMX1NMT1QgYXMgYW4gaW1wbGVtZW50ZWQgZXZlbnQuCj4+Pj4+Pj4KPj4+Pj4+PiBMZXQncyBq
dXN0IGRvIHRoYXQgYW5kIGFkanVzdCB3aGF0IHdlIHJldHVybiB0byB0aGUgZ3Vlc3QuCj4+Pj4+
Pj4KPj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPgo+
Pj4+Pj4+IC0tLQo+Pj4+Pj4+IMKgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaCB8wqAg
MyArKysKPj4+Pj4+PiDCoGFyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmPCoMKgwqDCoMKgwqAgfMKg
IDYgKysrKysrCj4+Pj4+Pj4gwqBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jwqDCoMKgwqDCoMKg
IHwgMTEgKysrKysrKy0tLS0KPj4+Pj4+PiDCoDMgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9u
cygrKSwgNCBkZWxldGlvbnMoLSkKPj4+Pj4+Pgo+Pj4+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+Pj4+Pj4gYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L3N5c3JlZy5oCj4+Pj4+Pj4gaW5kZXggOGI1ZTdlNWMzY2M4Li4yZmIzZjM4NjU4OGMgMTAwNjQ0
Cj4+Pj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaAo+Pj4+Pj4+ICsr
KyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmgKPj4+Pj4+PiBAQCAtODQ2LDcgKzg0
NiwxMCBAQAo+Pj4+Pj4+Cj4+Pj4+Pj4gwqAjZGVmaW5lIElEX0RGUjBfUEVSRk1PTl9TSElGVMKg
wqDCoMKgwqDCoMKgIDI0Cj4+Pj4+Pj4KPj4+Pj4+PiArI2RlZmluZSBJRF9ERlIwX1BFUkZNT05f
OF8wwqDCoMKgwqDCoMKgwqAgMHgzCj4+Pj4+Pj4gwqAjZGVmaW5lIElEX0RGUjBfUEVSRk1PTl84
XzHCoMKgwqDCoMKgwqDCoCAweDQKPj4+Pj4+PiArI2RlZmluZSBJRF9ERlIwX1BFUkZNT05fOF80
wqDCoMKgwqDCoMKgwqAgMHg1Cj4+Pj4+Pj4gKyNkZWZpbmUgSURfREZSMF9QRVJGTU9OXzhfNcKg
wqDCoMKgwqDCoMKgIDB4Ngo+Pj4+Pj4+Cj4+Pj4+Pj4gwqAjZGVmaW5lIElEX0lTQVI0X1NXUF9G
UkFDX1NISUZUwqDCoMKgwqDCoMKgwqAgMjgKPj4+Pj4+PiDCoCNkZWZpbmUgSURfSVNBUjRfUFNS
X01fU0hJRlTCoMKgwqDCoMKgwqDCoCAyNAo+Pj4+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L2t2bS9wbXUtZW11bC5jIGIvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+Pj4+Pj4+IGluZGV4
IDM5OGY2ZGYxYmJlNC4uNzJjZDcwNGE4MzY4IDEwMDY0NAo+Pj4+Pj4+IC0tLSBhL2FyY2gvYXJt
NjQva3ZtL3BtdS1lbXVsLmMKPj4+Pj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS9wbXUtZW11bC5j
Cj4+Pj4+Pj4gQEAgLTc5NSw2ICs3OTUsMTIgQEAgdTY0IGt2bV9wbXVfZ2V0X3BtY2VpZChzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4+Pj4+Pj4gYm9vbCBwbWNlaWQxKQo+Pj4+Pj4+IMKgwqDCoMKg
wqDCoMKgwqAgYmFzZSA9IDA7Cj4+Pj4+Pj4gwqDCoMKgwqAgfSBlbHNlIHsKPj4+Pj4+PiDCoMKg
wqDCoMKgwqDCoMKgIHZhbCA9IHJlYWRfc3lzcmVnKHBtY2VpZDFfZWwwKTsKPj4+Pj4+PiArwqDC
oMKgwqDCoMKgwqAgLyoKPj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqIERvbid0IGFkdmVydGlz
ZSBTVEFMTF9TTE9ULCBhcyBQTU1JUl9FTDAgaXMgaGFuZGxlZAo+Pj4+Pj4+ICvCoMKgwqDCoMKg
wqDCoMKgICogYXMgUkFaCj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKi8KPj4+Pj4+PiArwqDC
oMKgwqDCoMKgwqAgaWYgKHZjcHUtPmt2bS0+YXJjaC5wbXV2ZXIgPj0gSURfQUE2NERGUjBfUE1V
VkVSXzhfNCkKPj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2YWwgJj0gfkJJVF9VTEwo
QVJNVjhfUE1VVjNfUEVSRkNUUl9TVEFMTF9TTE9UIC0gMzIpOwo+Pj4+Pj4gd2hhdCBhYm91dCB0
aGUgU1RBTExfU0xPVF9CQUNLRU5EIGFuZCBGUk9OVEVORCBldmVudHMgdGhlbj8KPj4+Pj4KPj4+
Pj4gQXJlbid0IHRoZXNlIGEgbWFuZGF0b3J5IEFSTXY4LjEgZmVhdHVyZT8gSSBkb24ndCBzZWUg
YSByZWFzb24gdG8KPj4+Pj4gZHJvcCB0aGVtLgo+Pj4+Cj4+Pj4gSSB1bmRlcnN0YW5kIHRoZSAz
IGFyZSBsaW5rZWQgdG9nZXRoZXIuCj4+Pj4KPj4+PiBJbiBENy4xMSBpdCBpcyBzYWlkCj4+Pj4g
Igo+Pj4+IFdoZW4gYW55IG9mIHRoZSBmb2xsb3dpbmcgY29tbW9uIGV2ZW50cyBhcmUgaW1wbGVt
ZW50ZWQsIGFsbCB0aHJlZSBvZgo+Pj4+IHRoZW0gYXJlIGltcGxlbWVudGVkOgo+Pj4+IDB4MDAz
RCAsIFNUQUxMX1NMT1RfQkFDS0VORCwgTm8gb3BlcmF0aW9uIHNlbnQgZm9yIGV4ZWN1dGlvbiBv
biBhIFNsb3QKPj4+PiBkdWUgdG8gdGhlIGJhY2tlbmQsCj4+Pj4gMHgwMDNFICwgU1RBTExfU0xP
VF9GUk9OVEVORCwgTm8gb3BlcmF0aW9uIHNlbnQgZm9yIGV4ZWN1dGlvbiBvbiBhIFNsb3QKPj4+
PiBkdWUgdG8gdGhlIGZyb250ZW5kLgo+Pj4+IDB4MDAzRiAsIFNUQUxMX1NMT1QsIE5vIG9wZXJh
dGlvbiBzZW50IGZvciBleGVjdXRpb24gb24gYSBTbG90Lgo+Pj4+ICIKPj4+Cj4+PiBUaGV5IGFy
ZSBsaW5rZWQgaW4gdGhlIHNlbnNlIHRoYXQgdGhleSByZXBvcnQgcmVsYXRlZCBldmVudHMsIGJ1
dCB0aGV5Cj4+PiBkb24ndCBoYXZlIHRvIGJlIGltcGxlbWVudGVkIGluIHRoZSBzYW1lIGxldmVs
IG9mIHRoZSBhcmNoaXRlY3VyZSwgaWYgb25seQo+Pj4gYmVjYXVzZSBCQUNLRU5EL0ZST05URU5E
IHdlcmUgaW50cm9kdWNlZHdheSBiZWZvcmUgQVJNdjguNC4KPj4+Cj4+PiBXaGF0IHRoZSBhcmNo
aXRlY3R1cmUgc2F5cyBpczoKPj4+Cj4+PiAtIEZvciBGRUFUX1BNVXYzcDEgKEFSTXY4LjEpOgo+
Pj4gwqAgIlRoZSBTVEFMTF9GUk9OVEVORCBhbmQgU1RBTExfQkFDS0VORCBldmVudHMgYXJlIHJl
cXVpcmVkIHRvIGJlCj4+PiDCoMKgIGltcGxlbWVudGVkLiIgKEEyLjQuMSwgRERJMDQ4N0cuYSkK
Pj4gT0sKPj4+Cj4+PiAtIEZvciBGRUFUX1BNVXYzcDQgKEFSTXY4LjQpOgo+Pj4gwqAgIklmIEZF
QVRfUE1VdjNwNCBpcyBpbXBsZW1lbnRlZDoKPj4+IMKgwqAgLSBJZiBTVEFMTF9TTE9UIGlzIG5v
dCBpbXBsZW1lbnRlZCwgaXQgaXMgSU1QTEVNRU5UQVRJT04gREVGSU5FRAo+Pj4gd2hldGhlciB0
aGUgUE1NSVIgU3lzdGVtIHJlZ2lzdGVycyBhcmUgaW1wbGVtZW50ZWQuCj4+PiDCoMKgIC0gSWYg
U1RBTExfU0xPVCBpcyBpbXBsZW1lbnRlZCwgdGhlbiB0aGUgUE1NSVIgU3lzdGVtIHJlZ2lzdGVy
cyBhcmUKPj4+IGltcGxlbWVudGVkLiIgKEQ3LTI4NzMsIERESTA0ODdHLmEpCj4+Pgo+Pj4gU28g
d2hpbGUgQkFDS0VORC9GUk9OVEVORCBhcmUgcmVxdWlyZWQgaW4gYW4gQVJNdjguNCBpbXBsZW1l
bnRhdGlvbgo+Pj4gYnkgdmlydHVlIG9mIGJlaW5nIG1hbmRhdG9yeSBpbiBBUk12OC4xLCBTVEFM
TF9TTE9UIGlzbid0IGF0IGFueSBwb2ludC4KPj4gQnV0IHRoZW4gaG93IGRvIHlvdSB1bmRlcnN0
YW5kICJXaGVuIGFueSBvZiB0aGUgZm9sbG93aW5nIGNvbW1vbiBldmVudHMKPj4gYXJlIGltcGxl
bWVudGVkLCBhbGwgdGhyZWUgb2YgdGhlbSBhcmUgaW1wbGVtZW50ZWQiPwo+Cj4gSSB0aGluayB0
aGF0J3Mgd2hvbGx5IGluY29uc2lzdGVudCwgYmVjYXVzZSBpdCB3b3VsZCBtZWFuIHRoYXQgU1RB
TExfU0xPVAo+IGlzbid0IG9wdGlvbmFsIG9uIEFSTXY4LjQsIGFuZCB3b3VsZCBtYWtlIFBNTUlS
IG1hbmRhdG9yeS4KCkkgdGhpbmsgdGhlcmUncyBzb21lIGNvbmZ1c2lvbiByZWdhcmRpbmcgdGhl
IGV2ZW50IG5hbWVzLiBGcm9tIG15IHJlYWRpbmcgb2YgdGhlCmFyY2hpdGVjdHVyZSwgU1RBTEwg
IT0gU1RBTExfU0xPVCwgU1RBTExfQkFDS0VORCAhPSBTVEFMTF9TTE9UX0JBQ0tFTkQsClNUQUxM
X0ZST05URU5EICE9IFNUQUxMX1NMT1RfRlJPTlRFTkQuCgpTVEFMTHssIF9CQUNLRU5ELCBfRlJP
TlRFTkR9IGNvdW50IHRoZSBudW1iZXIgb2YgQ1BVIGN5Y2xlcyB3aGVyZSBubyBpbnN0cnVjdGlv
bnMKYXJlIGJlaW5nIGV4ZWN1dGVkIG9uIHRoZSBQRSAocGFnZSBENy0yODcyKSwgU1RBTExfU0xP
VHssIF9CQUNLRU5ELCBfRlJPTlRFTkR9CmNvdW50IHRoZSBudW1iZXIgb2Ygc2xvdHMgd2hlcmUg
bm8gaW5zdHJ1Y3Rpb25zIGFyZSBiZWluZyBleGVjdXRlZCAocGFnZSBENy0yODczKS4KClNUQUxM
X3tCQUNLRU5ELCBGUk9OVEVORH0gYXJlIHJlcXVpcmVkIGJ5IEFSTXY4LjEtUE1VIChwYWdlcyBB
Mi03NiwgRDctMjkxMyk7ClNUQUxMIGlzIHJlcXVpcmVkIGJ5IEFSTXY4LjQtUE1VIChwYWdlIEQ3
LTI5MTQpLgoKU1RBTExfU0xPVHssIF9CQUNLRU5ELCBfRlJPTlRFTkR9IGFyZSBvcHRpb25hbCBp
biBBUk12OC40LVBNVSAocGFnZXMgRDctMjkxMywKRDctMjkxNCksIGJ1dCBpZiBvbmUgb2YgdGhl
bSBpcyBpbXBsZW1lbnRlZCwgYWxsIG9mIHRoZW0gbXVzdCBiZSBpbXBsZW1lbnRlZCAocGFnZQpE
Ny0yOTE0KS4KClRoZSBwcm9ibGVtIEkgc2VlIHdpdGggdGhpcyBwYXRjaCBpcyB0aGF0IGl0IGRv
ZXNuJ3QgY2xlYXIgdGhlClNUQUxMX1NMT1Rfe0JBQ0tFTkQsIEZST05URU5EfSBldmVudCBiaXRz
IGFsb25nIHdpdGggdGhlIFNUQUxMX1NMT1QgYml0IGZyb20KUE1DRUlEMV9FTDAuCgpUaGFua3MK
CkFsZXgKCj4KPiBJJ20gc3RhcnRpbmcgdG8gdGhpbmsgdGhhdCBkcm9wcGluZyB0aGlzIHBhdGNo
IG1heSBiZSB0aGUgYmVzdCB0aGluZyB0byBkby4uLgo+Cj4gVGhhbmtzLAo+Cj4gwqDCoMKgwqDC
oMKgwqAgTS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
