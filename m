Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079C0C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 13:29:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4154D64F55
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 13:29:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4154D64F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82BB24B202;
	Wed,  3 Feb 2021 08:29:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NYAfJvybTVp7; Wed,  3 Feb 2021 08:29:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38BE64B265;
	Wed,  3 Feb 2021 08:29:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 274174B25D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 08:29:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 29dPCEsAro7j for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 08:29:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4B3A4B202
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 08:28:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 930A860295;
 Wed,  3 Feb 2021 13:28:58 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l7IDI-00BlHH-BW; Wed, 03 Feb 2021 13:28:56 +0000
MIME-Version: 1.0
Date: Wed, 03 Feb 2021 13:28:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
In-Reply-To: <d9f8b79a-74de-0058-aa14-4ed5ec3b6aab@redhat.com>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
 <adbdbfbcecb65a1eca21afa622679836@kernel.org>
 <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
 <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
 <d9f8b79a-74de-0058-aa14-4ed5ec3b6aab@redhat.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <ac172223d388393004819e338728f45b@kernel.org>
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

T24gMjAyMS0wMi0wMyAxMjozOSwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSwKPiAKPiBPbiAyLzMv
MjEgMTI6MjAgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMS0wMi0wMyAxMTowNywg
QXVnZXIgRXJpYyB3cm90ZToKPj4+IEhpIE1hcmMsCj4+PiBPbiAyLzMvMjEgMTE6MzYgQU0sIE1h
cmMgWnluZ2llciB3cm90ZToKPj4+PiBIaSBFcmljLAo+Pj4+IAo+Pj4+IE9uIDIwMjEtMDEtMjcg
MTc6NTMsIEF1Z2VyIEVyaWMgd3JvdGU6Cj4+Pj4+IEhpIE1hcmMsCj4+Pj4+IAo+Pj4+PiBPbiAx
LzI1LzIxIDE6MjYgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+Pj4+IFVwZ3JhZGluZyB0aGUg
UE1VIGNvZGUgZnJvbSBBUk12OC4xIHRvIEFSTXY4LjQgdHVybnMgb3V0IHRvIGJlCj4+Pj4+PiBw
cmV0dHkgZWFzeS4gQWxsIHRoYXQgaXMgcmVxdWlyZWQgaXMgc3VwcG9ydCBmb3IgUE1NSVJfRUwx
LCB3aGljaAo+Pj4+Pj4gaXMgcmVhZC1vbmx5LCBhbmQgZm9yIHdoaWNoIHJldHVybmluZyAwIGlz
IGEgdmFsaWQgb3B0aW9uIGFzIGxvbmcKPj4+Pj4+IGFzIHdlIGRvbid0IGFkdmVydGlzZSBTVEFM
TF9TTE9UIGFzIGFuIGltcGxlbWVudGVkIGV2ZW50Lgo+Pj4+Pj4gCj4+Pj4+PiBMZXQncyBqdXN0
IGRvIHRoYXQgYW5kIGFkanVzdCB3aGF0IHdlIHJldHVybiB0byB0aGUgZ3Vlc3QuCj4+Pj4+PiAK
Pj4+Pj4+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4+Pj4+
PiAtLS0KPj4+Pj4+IMKgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaCB8wqAgMyArKysK
Pj4+Pj4+IMKgYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuY8KgwqDCoMKgwqDCoCB8wqAgNiArKysr
KysKPj4+Pj4+IMKgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuY8KgwqDCoMKgwqDCoCB8IDExICsr
KysrKystLS0tCj4+Pj4+PiDCoDMgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkKPj4+Pj4+IAo+Pj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVk
ZS9hc20vc3lzcmVnLmgKPj4+Pj4+IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaAo+
Pj4+Pj4gaW5kZXggOGI1ZTdlNWMzY2M4Li4yZmIzZjM4NjU4OGMgMTAwNjQ0Cj4+Pj4+PiAtLS0g
YS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+Pj4+PiArKysgYi9hcmNoL2FybTY0
L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+Pj4+PiBAQCAtODQ2LDcgKzg0NiwxMCBAQAo+Pj4+Pj4g
Cj4+Pj4+PiDCoCNkZWZpbmUgSURfREZSMF9QRVJGTU9OX1NISUZUwqDCoMKgwqDCoMKgwqAgMjQK
Pj4+Pj4+IAo+Pj4+Pj4gKyNkZWZpbmUgSURfREZSMF9QRVJGTU9OXzhfMMKgwqDCoMKgwqDCoMKg
IDB4Mwo+Pj4+Pj4gwqAjZGVmaW5lIElEX0RGUjBfUEVSRk1PTl84XzHCoMKgwqDCoMKgwqDCoCAw
eDQKPj4+Pj4+ICsjZGVmaW5lIElEX0RGUjBfUEVSRk1PTl84XzTCoMKgwqDCoMKgwqDCoCAweDUK
Pj4+Pj4+ICsjZGVmaW5lIElEX0RGUjBfUEVSRk1PTl84XzXCoMKgwqDCoMKgwqDCoCAweDYKPj4+
Pj4+IAo+Pj4+Pj4gwqAjZGVmaW5lIElEX0lTQVI0X1NXUF9GUkFDX1NISUZUwqDCoMKgwqDCoMKg
wqAgMjgKPj4+Pj4+IMKgI2RlZmluZSBJRF9JU0FSNF9QU1JfTV9TSElGVMKgwqDCoMKgwqDCoMKg
IDI0Cj4+Pj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYyBiL2FyY2gv
YXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+Pj4+IGluZGV4IDM5OGY2ZGYxYmJlNC4uNzJjZDcwNGE4
MzY4IDEwMDY0NAo+Pj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+Pj4+Pj4g
KysrIGIvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+Pj4+Pj4gQEAgLTc5NSw2ICs3OTUsMTIg
QEAgdTY0IGt2bV9wbXVfZ2V0X3BtY2VpZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4+Pj4+PiBi
b29sIHBtY2VpZDEpCj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgIGJhc2UgPSAwOwo+Pj4+Pj4gwqDC
oMKgwqAgfSBlbHNlIHsKPj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqAgdmFsID0gcmVhZF9zeXNyZWco
cG1jZWlkMV9lbDApOwo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qCj4+Pj4+PiArwqDCoMKgwqDC
oMKgwqDCoCAqIERvbid0IGFkdmVydGlzZSBTVEFMTF9TTE9ULCBhcyBQTU1JUl9FTDAgaXMgaGFu
ZGxlZAo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBhcyBSQVoKPj4+Pj4+ICvCoMKgwqDCoMKg
wqDCoMKgICovCj4+Pj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKHZjcHUtPmt2bS0+YXJjaC5wbXV2
ZXIgPj0gSURfQUE2NERGUjBfUE1VVkVSXzhfNCkKPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHZhbCAmPSB+QklUX1VMTChBUk1WOF9QTVVWM19QRVJGQ1RSX1NUQUxMX1NMT1QgLSAzMik7
Cj4+Pj4+IHdoYXQgYWJvdXQgdGhlIFNUQUxMX1NMT1RfQkFDS0VORCBhbmQgRlJPTlRFTkQgZXZl
bnRzIHRoZW4/Cj4+Pj4gCj4+Pj4gQXJlbid0IHRoZXNlIGEgbWFuZGF0b3J5IEFSTXY4LjEgZmVh
dHVyZT8gSSBkb24ndCBzZWUgYSByZWFzb24gdG8KPj4+PiBkcm9wIHRoZW0uCj4+PiAKPj4+IEkg
dW5kZXJzdGFuZCB0aGUgMyBhcmUgbGlua2VkIHRvZ2V0aGVyLgo+Pj4gCj4+PiBJbiBENy4xMSBp
dCBpcyBzYWlkCj4+PiAiCj4+PiBXaGVuIGFueSBvZiB0aGUgZm9sbG93aW5nIGNvbW1vbiBldmVu
dHMgYXJlIGltcGxlbWVudGVkLCBhbGwgdGhyZWUgb2YKPj4+IHRoZW0gYXJlIGltcGxlbWVudGVk
Ogo+Pj4gMHgwMDNEICwgU1RBTExfU0xPVF9CQUNLRU5ELCBObyBvcGVyYXRpb24gc2VudCBmb3Ig
ZXhlY3V0aW9uIG9uIGEgCj4+PiBTbG90Cj4+PiBkdWUgdG8gdGhlIGJhY2tlbmQsCj4+PiAweDAw
M0UgLCBTVEFMTF9TTE9UX0ZST05URU5ELCBObyBvcGVyYXRpb24gc2VudCBmb3IgZXhlY3V0aW9u
IG9uIGEgCj4+PiBTbG90Cj4+PiBkdWUgdG8gdGhlIGZyb250ZW5kLgo+Pj4gMHgwMDNGICwgU1RB
TExfU0xPVCwgTm8gb3BlcmF0aW9uIHNlbnQgZm9yIGV4ZWN1dGlvbiBvbiBhIFNsb3QuCj4+PiAi
Cj4+IAo+PiBUaGV5IGFyZSBsaW5rZWQgaW4gdGhlIHNlbnNlIHRoYXQgdGhleSByZXBvcnQgcmVs
YXRlZCBldmVudHMsIGJ1dCB0aGV5Cj4+IGRvbid0IGhhdmUgdG8gYmUgaW1wbGVtZW50ZWQgaW4g
dGhlIHNhbWUgbGV2ZWwgb2YgdGhlIGFyY2hpdGVjdXJlLCBpZiAKPj4gb25seQo+PiBiZWNhdXNl
IEJBQ0tFTkQvRlJPTlRFTkQgd2VyZSBpbnRyb2R1Y2Vkd2F5IGJlZm9yZSBBUk12OC40Lgo+PiAK
Pj4gV2hhdCB0aGUgYXJjaGl0ZWN0dXJlIHNheXMgaXM6Cj4+IAo+PiAtIEZvciBGRUFUX1BNVXYz
cDEgKEFSTXY4LjEpOgo+PiDCoCAiVGhlIFNUQUxMX0ZST05URU5EIGFuZCBTVEFMTF9CQUNLRU5E
IGV2ZW50cyBhcmUgcmVxdWlyZWQgdG8gYmUKPj4gwqDCoCBpbXBsZW1lbnRlZC4iIChBMi40LjEs
IERESTA0ODdHLmEpCj4gT0sKPj4gCj4+IC0gRm9yIEZFQVRfUE1VdjNwNCAoQVJNdjguNCk6Cj4+
IMKgICJJZiBGRUFUX1BNVXYzcDQgaXMgaW1wbGVtZW50ZWQ6Cj4+IMKgwqAgLSBJZiBTVEFMTF9T
TE9UIGlzIG5vdCBpbXBsZW1lbnRlZCwgaXQgaXMgSU1QTEVNRU5UQVRJT04gREVGSU5FRAo+PiB3
aGV0aGVyIHRoZSBQTU1JUiBTeXN0ZW0gcmVnaXN0ZXJzIGFyZSBpbXBsZW1lbnRlZC4KPj4gwqDC
oCAtIElmIFNUQUxMX1NMT1QgaXMgaW1wbGVtZW50ZWQsIHRoZW4gdGhlIFBNTUlSIFN5c3RlbSBy
ZWdpc3RlcnMgYXJlCj4+IGltcGxlbWVudGVkLiIgKEQ3LTI4NzMsIERESTA0ODdHLmEpCj4+IAo+
PiBTbyB3aGlsZSBCQUNLRU5EL0ZST05URU5EIGFyZSByZXF1aXJlZCBpbiBhbiBBUk12OC40IGlt
cGxlbWVudGF0aW9uCj4+IGJ5IHZpcnR1ZSBvZiBiZWluZyBtYW5kYXRvcnkgaW4gQVJNdjguMSwg
U1RBTExfU0xPVCBpc24ndCBhdCBhbnkgCj4+IHBvaW50Lgo+IEJ1dCB0aGVuIGhvdyBkbyB5b3Ug
dW5kZXJzdGFuZCAiV2hlbiBhbnkgb2YgdGhlIGZvbGxvd2luZyBjb21tb24gZXZlbnRzCj4gYXJl
IGltcGxlbWVudGVkLCBhbGwgdGhyZWUgb2YgdGhlbSBhcmUgaW1wbGVtZW50ZWQiPwoKSSB0aGlu
ayB0aGF0J3Mgd2hvbGx5IGluY29uc2lzdGVudCwgYmVjYXVzZSBpdCB3b3VsZCBtZWFuIHRoYXQg
ClNUQUxMX1NMT1QKaXNuJ3Qgb3B0aW9uYWwgb24gQVJNdjguNCwgYW5kIHdvdWxkIG1ha2UgUE1N
SVIgbWFuZGF0b3J5LgoKSSdtIHN0YXJ0aW5nIHRvIHRoaW5rIHRoYXQgZHJvcHBpbmcgdGhpcyBw
YXRjaCBtYXkgYmUgdGhlIGJlc3QgdGhpbmcgdG8gCmRvLi4uCgpUaGFua3MsCgogICAgICAgICBN
LgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
