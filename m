Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8FAC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:21:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 892D164F51
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:21:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 892D164F51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EE164B258;
	Thu,  4 Feb 2021 09:21:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A8w3DXjLzTF1; Thu,  4 Feb 2021 09:21:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EB154B22D;
	Thu,  4 Feb 2021 09:21:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40B944B1E2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:21:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6konzm5teMMY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 09:21:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E15234B1DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:21:40 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8F6DA64DEB;
 Thu,  4 Feb 2021 14:21:39 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l7fVp-00C1TC-Fb; Thu, 04 Feb 2021 14:21:37 +0000
MIME-Version: 1.0
Date: Thu, 04 Feb 2021 14:21:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
In-Reply-To: <7134513d-bccf-923f-961a-08527cf77f8e@arm.com>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
 <adbdbfbcecb65a1eca21afa622679836@kernel.org>
 <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
 <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
 <d9f8b79a-74de-0058-aa14-4ed5ec3b6aab@redhat.com>
 <ac172223d388393004819e338728f45b@kernel.org>
 <7134513d-bccf-923f-961a-08527cf77f8e@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <30d455e9eacf8b4b9b43ff30b3a48309@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, eric.auger@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMS0wMi0wNCAxMjozMiwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPiBIaSwKPiAKPiBP
biAyLzMvMjEgMToyOCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBPbiAyMDIxLTAyLTAzIDEy
OjM5LCBBdWdlciBFcmljIHdyb3RlOgo+Pj4gSGksCj4+PiAKPj4+IE9uIDIvMy8yMSAxMjoyMCBQ
TSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+IE9uIDIwMjEtMDItMDMgMTE6MDcsIEF1Z2VyIEVy
aWMgd3JvdGU6Cj4+Pj4+IEhpIE1hcmMsCj4+Pj4+IE9uIDIvMy8yMSAxMTozNiBBTSwgTWFyYyBa
eW5naWVyIHdyb3RlOgo+Pj4+Pj4gSGkgRXJpYywKPj4+Pj4+IAo+Pj4+Pj4gT24gMjAyMS0wMS0y
NyAxNzo1MywgQXVnZXIgRXJpYyB3cm90ZToKPj4+Pj4+PiBIaSBNYXJjLAo+Pj4+Pj4+IAo+Pj4+
Pj4+IE9uIDEvMjUvMjEgMToyNiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+Pj4+PiBVcGdy
YWRpbmcgdGhlIFBNVSBjb2RlIGZyb20gQVJNdjguMSB0byBBUk12OC40IHR1cm5zIG91dCB0byBi
ZQo+Pj4+Pj4+PiBwcmV0dHkgZWFzeS4gQWxsIHRoYXQgaXMgcmVxdWlyZWQgaXMgc3VwcG9ydCBm
b3IgUE1NSVJfRUwxLCAKPj4+Pj4+Pj4gd2hpY2gKPj4+Pj4+Pj4gaXMgcmVhZC1vbmx5LCBhbmQg
Zm9yIHdoaWNoIHJldHVybmluZyAwIGlzIGEgdmFsaWQgb3B0aW9uIGFzIAo+Pj4+Pj4+PiBsb25n
Cj4+Pj4+Pj4+IGFzIHdlIGRvbid0IGFkdmVydGlzZSBTVEFMTF9TTE9UIGFzIGFuIGltcGxlbWVu
dGVkIGV2ZW50Lgo+Pj4+Pj4+PiAKPj4+Pj4+Pj4gTGV0J3MganVzdCBkbyB0aGF0IGFuZCBhZGp1
c3Qgd2hhdCB3ZSByZXR1cm4gdG8gdGhlIGd1ZXN0Lgo+Pj4+Pj4+PiAKPj4+Pj4+Pj4gU2lnbmVk
LW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPj4+Pj4+Pj4gLS0tCj4+Pj4+
Pj4+IMKgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaCB8wqAgMyArKysKPj4+Pj4+Pj4g
wqBhcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jwqDCoMKgwqDCoMKgIHzCoCA2ICsrKysrKwo+Pj4+
Pj4+PiDCoGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmPCoMKgwqDCoMKgwqAgfCAxMSArKysrKysr
LS0tLQo+Pj4+Pj4+PiDCoDMgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkKPj4+Pj4+Pj4gCj4+Pj4+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL3N5c3JlZy5oCj4+Pj4+Pj4+IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcu
aAo+Pj4+Pj4+PiBpbmRleCA4YjVlN2U1YzNjYzguLjJmYjNmMzg2NTg4YyAxMDA2NDQKPj4+Pj4+
Pj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaAo+Pj4+Pj4+PiArKysgYi9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+Pj4+Pj4+IEBAIC04NDYsNyArODQ2LDEw
IEBACj4+Pj4+Pj4+IAo+Pj4+Pj4+PiDCoCNkZWZpbmUgSURfREZSMF9QRVJGTU9OX1NISUZUwqDC
oMKgwqDCoMKgwqAgMjQKPj4+Pj4+Pj4gCj4+Pj4+Pj4+ICsjZGVmaW5lIElEX0RGUjBfUEVSRk1P
Tl84XzDCoMKgwqDCoMKgwqDCoCAweDMKPj4+Pj4+Pj4gwqAjZGVmaW5lIElEX0RGUjBfUEVSRk1P
Tl84XzHCoMKgwqDCoMKgwqDCoCAweDQKPj4+Pj4+Pj4gKyNkZWZpbmUgSURfREZSMF9QRVJGTU9O
XzhfNMKgwqDCoMKgwqDCoMKgIDB4NQo+Pj4+Pj4+PiArI2RlZmluZSBJRF9ERlIwX1BFUkZNT05f
OF81wqDCoMKgwqDCoMKgwqAgMHg2Cj4+Pj4+Pj4+IAo+Pj4+Pj4+PiDCoCNkZWZpbmUgSURfSVNB
UjRfU1dQX0ZSQUNfU0hJRlTCoMKgwqDCoMKgwqDCoCAyOAo+Pj4+Pj4+PiDCoCNkZWZpbmUgSURf
SVNBUjRfUFNSX01fU0hJRlTCoMKgwqDCoMKgwqDCoCAyNAo+Pj4+Pj4+PiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYyAKPj4+Pj4+Pj4gYi9hcmNoL2FybTY0L2t2bS9wbXUt
ZW11bC5jCj4+Pj4+Pj4+IGluZGV4IDM5OGY2ZGYxYmJlNC4uNzJjZDcwNGE4MzY4IDEwMDY0NAo+
Pj4+Pj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jCj4+Pj4+Pj4+ICsrKyBiL2Fy
Y2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+Pj4+Pj4gQEAgLTc5NSw2ICs3OTUsMTIgQEAgdTY0
IGt2bV9wbXVfZ2V0X3BtY2VpZChzdHJ1Y3Qga3ZtX3ZjcHUgCj4+Pj4+Pj4+ICp2Y3B1LAo+Pj4+
Pj4+PiBib29sIHBtY2VpZDEpCj4+Pj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqAgYmFzZSA9IDA7Cj4+
Pj4+Pj4+IMKgwqDCoMKgIH0gZWxzZSB7Cj4+Pj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqAgdmFsID0g
cmVhZF9zeXNyZWcocG1jZWlkMV9lbDApOwo+Pj4+Pj4+PiArwqDCoMKgwqDCoMKgwqAgLyoKPj4+
Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBEb24ndCBhZHZlcnRpc2UgU1RBTExfU0xPVCwgYXMg
UE1NSVJfRUwwIGlzIGhhbmRsZWQKPj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBhcyBSQVoK
Pj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKi8KPj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGlm
ICh2Y3B1LT5rdm0tPmFyY2gucG11dmVyID49IElEX0FBNjRERlIwX1BNVVZFUl84XzQpCj4+Pj4+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZhbCAmPSB+QklUX1VMTChBUk1WOF9QTVVWM19Q
RVJGQ1RSX1NUQUxMX1NMT1QgLSAKPj4+Pj4+Pj4gMzIpOwo+Pj4+Pj4+IHdoYXQgYWJvdXQgdGhl
IFNUQUxMX1NMT1RfQkFDS0VORCBhbmQgRlJPTlRFTkQgZXZlbnRzIHRoZW4/Cj4+Pj4+PiAKPj4+
Pj4+IEFyZW4ndCB0aGVzZSBhIG1hbmRhdG9yeSBBUk12OC4xIGZlYXR1cmU/IEkgZG9uJ3Qgc2Vl
IGEgcmVhc29uIHRvCj4+Pj4+PiBkcm9wIHRoZW0uCj4+Pj4+IAo+Pj4+PiBJIHVuZGVyc3RhbmQg
dGhlIDMgYXJlIGxpbmtlZCB0b2dldGhlci4KPj4+Pj4gCj4+Pj4+IEluIEQ3LjExIGl0IGlzIHNh
aWQKPj4+Pj4gIgo+Pj4+PiBXaGVuIGFueSBvZiB0aGUgZm9sbG93aW5nIGNvbW1vbiBldmVudHMg
YXJlIGltcGxlbWVudGVkLCBhbGwgdGhyZWUgCj4+Pj4+IG9mCj4+Pj4+IHRoZW0gYXJlIGltcGxl
bWVudGVkOgo+Pj4+PiAweDAwM0QgLCBTVEFMTF9TTE9UX0JBQ0tFTkQsIE5vIG9wZXJhdGlvbiBz
ZW50IGZvciBleGVjdXRpb24gb24gYSAKPj4+Pj4gU2xvdAo+Pj4+PiBkdWUgdG8gdGhlIGJhY2tl
bmQsCj4+Pj4+IDB4MDAzRSAsIFNUQUxMX1NMT1RfRlJPTlRFTkQsIE5vIG9wZXJhdGlvbiBzZW50
IGZvciBleGVjdXRpb24gb24gYSAKPj4+Pj4gU2xvdAo+Pj4+PiBkdWUgdG8gdGhlIGZyb250ZW5k
Lgo+Pj4+PiAweDAwM0YgLCBTVEFMTF9TTE9ULCBObyBvcGVyYXRpb24gc2VudCBmb3IgZXhlY3V0
aW9uIG9uIGEgU2xvdC4KPj4+Pj4gIgo+Pj4+IAo+Pj4+IFRoZXkgYXJlIGxpbmtlZCBpbiB0aGUg
c2Vuc2UgdGhhdCB0aGV5IHJlcG9ydCByZWxhdGVkIGV2ZW50cywgYnV0IAo+Pj4+IHRoZXkKPj4+
PiBkb24ndCBoYXZlIHRvIGJlIGltcGxlbWVudGVkIGluIHRoZSBzYW1lIGxldmVsIG9mIHRoZSBh
cmNoaXRlY3VyZSwgCj4+Pj4gaWYgb25seQo+Pj4+IGJlY2F1c2UgQkFDS0VORC9GUk9OVEVORCB3
ZXJlIGludHJvZHVjZWR3YXkgYmVmb3JlIEFSTXY4LjQuCj4+Pj4gCj4+Pj4gV2hhdCB0aGUgYXJj
aGl0ZWN0dXJlIHNheXMgaXM6Cj4+Pj4gCj4+Pj4gLSBGb3IgRkVBVF9QTVV2M3AxIChBUk12OC4x
KToKPj4+PiDCoCAiVGhlIFNUQUxMX0ZST05URU5EIGFuZCBTVEFMTF9CQUNLRU5EIGV2ZW50cyBh
cmUgcmVxdWlyZWQgdG8gYmUKPj4+PiDCoMKgIGltcGxlbWVudGVkLiIgKEEyLjQuMSwgRERJMDQ4
N0cuYSkKPj4+IE9LCj4+Pj4gCj4+Pj4gLSBGb3IgRkVBVF9QTVV2M3A0IChBUk12OC40KToKPj4+
PiDCoCAiSWYgRkVBVF9QTVV2M3A0IGlzIGltcGxlbWVudGVkOgo+Pj4+IMKgwqAgLSBJZiBTVEFM
TF9TTE9UIGlzIG5vdCBpbXBsZW1lbnRlZCwgaXQgaXMgSU1QTEVNRU5UQVRJT04gREVGSU5FRAo+
Pj4+IHdoZXRoZXIgdGhlIFBNTUlSIFN5c3RlbSByZWdpc3RlcnMgYXJlIGltcGxlbWVudGVkLgo+
Pj4+IMKgwqAgLSBJZiBTVEFMTF9TTE9UIGlzIGltcGxlbWVudGVkLCB0aGVuIHRoZSBQTU1JUiBT
eXN0ZW0gcmVnaXN0ZXJzIAo+Pj4+IGFyZQo+Pj4+IGltcGxlbWVudGVkLiIgKEQ3LTI4NzMsIERE
STA0ODdHLmEpCj4+Pj4gCj4+Pj4gU28gd2hpbGUgQkFDS0VORC9GUk9OVEVORCBhcmUgcmVxdWly
ZWQgaW4gYW4gQVJNdjguNCBpbXBsZW1lbnRhdGlvbgo+Pj4+IGJ5IHZpcnR1ZSBvZiBiZWluZyBt
YW5kYXRvcnkgaW4gQVJNdjguMSwgU1RBTExfU0xPVCBpc24ndCBhdCBhbnkgCj4+Pj4gcG9pbnQu
Cj4+PiBCdXQgdGhlbiBob3cgZG8geW91IHVuZGVyc3RhbmQgIldoZW4gYW55IG9mIHRoZSBmb2xs
b3dpbmcgY29tbW9uIAo+Pj4gZXZlbnRzCj4+PiBhcmUgaW1wbGVtZW50ZWQsIGFsbCB0aHJlZSBv
ZiB0aGVtIGFyZSBpbXBsZW1lbnRlZCI/Cj4+IAo+PiBJIHRoaW5rIHRoYXQncyB3aG9sbHkgaW5j
b25zaXN0ZW50LCBiZWNhdXNlIGl0IHdvdWxkIG1lYW4gdGhhdCAKPj4gU1RBTExfU0xPVAo+PiBp
c24ndCBvcHRpb25hbCBvbiBBUk12OC40LCBhbmQgd291bGQgbWFrZSBQTU1JUiBtYW5kYXRvcnku
Cj4gCj4gSSB0aGluayB0aGVyZSdzIHNvbWUgY29uZnVzaW9uIHJlZ2FyZGluZyB0aGUgZXZlbnQg
bmFtZXMuIEZyb20gbXkgCj4gcmVhZGluZyBvZiB0aGUKPiBhcmNoaXRlY3R1cmUsIFNUQUxMICE9
IFNUQUxMX1NMT1QsIFNUQUxMX0JBQ0tFTkQgIT0gU1RBTExfU0xPVF9CQUNLRU5ELAo+IFNUQUxM
X0ZST05URU5EICE9IFNUQUxMX1NMT1RfRlJPTlRFTkQuCgpEYW1taXQsIEkgaGFkbid0IHJlYWxp
c2VkIHRoYXQgYXQgYWxsLiBUaGFua3MgZm9yIHB1dHRpbmcgbWUgcmlnaHQuCgo+IAo+IFNUQUxM
eywgX0JBQ0tFTkQsIF9GUk9OVEVORH0gY291bnQgdGhlIG51bWJlciBvZiBDUFUgY3ljbGVzIHdo
ZXJlIG5vCj4gaW5zdHJ1Y3Rpb25zCj4gYXJlIGJlaW5nIGV4ZWN1dGVkIG9uIHRoZSBQRSAocGFn
ZSBENy0yODcyKSwgU1RBTExfU0xPVHssIF9CQUNLRU5ELCAKPiBfRlJPTlRFTkR9Cj4gY291bnQg
dGhlIG51bWJlciBvZiBzbG90cyB3aGVyZSBubyBpbnN0cnVjdGlvbnMgYXJlIGJlaW5nIGV4ZWN1
dGVkCj4gKHBhZ2UgRDctMjg3MykuCj4gCj4gU1RBTExfe0JBQ0tFTkQsIEZST05URU5EfSBhcmUg
cmVxdWlyZWQgYnkgQVJNdjguMS1QTVUgKHBhZ2VzIEEyLTc2LCAKPiBENy0yOTEzKTsKPiBTVEFM
TCBpcyByZXF1aXJlZCBieSBBUk12OC40LVBNVSAocGFnZSBENy0yOTE0KS4KPiAKPiBTVEFMTF9T
TE9UeywgX0JBQ0tFTkQsIF9GUk9OVEVORH0gYXJlIG9wdGlvbmFsIGluIEFSTXY4LjQtUE1VIChw
YWdlcyAKPiBENy0yOTEzLAo+IEQ3LTI5MTQpLCBidXQgaWYgb25lIG9mIHRoZW0gaXMgaW1wbGVt
ZW50ZWQsIGFsbCBvZiB0aGVtIG11c3QgYmUKPiBpbXBsZW1lbnRlZCAocGFnZSBENy0yOTE0KS4K
PiAKPiBUaGUgcHJvYmxlbSBJIHNlZSB3aXRoIHRoaXMgcGF0Y2ggaXMgdGhhdCBpdCBkb2Vzbid0
IGNsZWFyIHRoZQo+IFNUQUxMX1NMT1Rfe0JBQ0tFTkQsIEZST05URU5EfSBldmVudCBiaXRzIGFs
b25nIHdpdGggdGhlIFNUQUxMX1NMT1QgYml0IAo+IGZyb20KPiBQTUNFSUQxX0VMMC4KCk9LLCBz
byBFcmljIHdhcyByaWdodCwgYW5kIEknbSBhbiBpbGxpdGVyYXRlIGlkaW90ISBJJ2xsIGZpeCB0
aGUgcGF0Y2ggCmFuZCByZXBvc3QKdGhlIHdob2xlIHRoaW5nLgoKVGhhbmtzLAoKICAgICAgICAg
TS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
