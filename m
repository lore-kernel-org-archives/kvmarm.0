Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189F2C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:56:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A8CD64DE7
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:56:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A8CD64DE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE5F04B219;
	Thu,  4 Feb 2021 09:56:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IjqAFqVgszMu; Thu,  4 Feb 2021 09:56:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748B34B229;
	Thu,  4 Feb 2021 09:56:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E238B4B21A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:56:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x3hm1cANOpwC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 09:56:16 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE31C4B219
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:56:16 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7BEA264D9F;
 Thu,  4 Feb 2021 14:56:15 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l7g3J-00C1uA-9o; Thu, 04 Feb 2021 14:56:13 +0000
MIME-Version: 1.0
Date: Thu, 04 Feb 2021 14:56:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v7 1/3] arm64: kvm: Save/restore MTE registers
In-Reply-To: <e294d3d3-20d6-717d-4274-c190f9cc5887@arm.com>
References: <20210115152811.8398-1-steven.price@arm.com>
 <20210115152811.8398-2-steven.price@arm.com>
 <a99f09a56cf33bfa18b55c251380ef22@kernel.org>
 <e294d3d3-20d6-717d-4274-c190f9cc5887@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <bf1fe1204a075abbd294435944973f62@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Dave.Martin@arm.com, mark.rutland@arm.com, tglx@linutronix.de,
 qemu-devel@nongnu.org, quintela@redhat.com, dgilbert@redhat.com,
 richard.henderson@linaro.org, peter.maydell@linaro.org, Haibo.Xu@arm.com,
 drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

T24gMjAyMS0wMi0wNCAxNDozMywgU3RldmVuIFByaWNlIHdyb3RlOgo+IE9uIDAyLzAyLzIwMjEg
MTU6MzYsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMS0wMS0xNSAxNToyOCwgU3RldmVu
IFByaWNlIHdyb3RlOgo+Pj4gRGVmaW5lIHRoZSBuZXcgc3lzdGVtIHJlZ2lzdGVycyB0aGF0IE1U
RSBpbnRyb2R1Y2VzIGFuZCBjb250ZXh0IAo+Pj4gc3dpdGNoCj4+PiB0aGVtLiBUaGUgTVRFIGZl
YXR1cmUgaXMgc3RpbGwgaGlkZGVuIGZyb20gdGhlIElEIHJlZ2lzdGVyIGFzIGl0IAo+Pj4gaXNu
J3QKPj4+IHN1cHBvcnRlZCBpbiBhIFZNIHlldC4KPj4+IAo+Pj4gU2lnbmVkLW9mZi1ieTogU3Rl
dmVuIFByaWNlIDxzdGV2ZW4ucHJpY2VAYXJtLmNvbT4KPj4+IC0tLQo+Pj4gwqBhcmNoL2FybTY0
L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmjCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDQgKysKPj4+IMKg
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fbXRlLmjCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDc0
IAo+Pj4gKysrKysrKysrKysrKysrKysrKysrKwo+Pj4gwqBhcmNoL2FybTY0L2luY2x1ZGUvYXNt
L3N5c3JlZy5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMyArLQo+Pj4gwqBhcmNoL2FybTY0
L2tlcm5lbC9hc20tb2Zmc2V0cy5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMyArCj4+PiDC
oGFyY2gvYXJtNjQva3ZtL2h5cC9lbnRyeS5TwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfMKgIDcgKysKPj4+IMKgYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N5c3JlZy1z
ci5oIHzCoCA0ICsrCj4+PiDCoGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmPCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMTQgKystLQo+Pj4gwqA3IGZpbGVzIGNoYW5nZWQsIDEw
NCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQo+Pj4gwqBjcmVhdGUgbW9kZSAxMDA2NDQg
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fbXRlLmgKPj4+IAo+Pj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+Pj4gYi9hcmNoL2FybTY0L2luY2x1ZGUv
YXNtL2t2bV9ob3N0LmgKPj4+IGluZGV4IDExYmVkYTg1ZWU3ZS4uNTE1OTBhMzk3ZTRiIDEwMDY0
NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCj4+PiArKysgYi9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPj4+IEBAIC0xNDgsNiArMTQ4LDggQEAg
ZW51bSB2Y3B1X3N5c3JlZyB7Cj4+PiDCoMKgwqDCoCBTQ1RMUl9FTDEswqDCoMKgIC8qIFN5c3Rl
bSBDb250cm9sIFJlZ2lzdGVyICovCj4+PiDCoMKgwqDCoCBBQ1RMUl9FTDEswqDCoMKgIC8qIEF1
eGlsaWFyeSBDb250cm9sIFJlZ2lzdGVyICovCj4+PiDCoMKgwqDCoCBDUEFDUl9FTDEswqDCoMKg
IC8qIENvcHJvY2Vzc29yIEFjY2VzcyBDb250cm9sICovCj4+PiArwqDCoMKgIFJHU1JfRUwxLMKg
wqDCoCAvKiBSYW5kb20gQWxsb2NhdGlvbiBUYWcgU2VlZCBSZWdpc3RlciAqLwo+Pj4gK8KgwqDC
oCBHQ1JfRUwxLMKgwqDCoCAvKiBUYWcgQ29udHJvbCBSZWdpc3RlciAqLwo+Pj4gwqDCoMKgwqAg
WkNSX0VMMSzCoMKgwqAgLyogU1ZFIENvbnRyb2wgKi8KPj4+IMKgwqDCoMKgIFRUQlIwX0VMMSzC
oMKgwqAgLyogVHJhbnNsYXRpb24gVGFibGUgQmFzZSBSZWdpc3RlciAwICovCj4+PiDCoMKgwqDC
oCBUVEJSMV9FTDEswqDCoMKgIC8qIFRyYW5zbGF0aW9uIFRhYmxlIEJhc2UgUmVnaXN0ZXIgMSAq
Lwo+Pj4gQEAgLTE2NCw2ICsxNjYsOCBAQCBlbnVtIHZjcHVfc3lzcmVnIHsKPj4+IMKgwqDCoMKg
IFRQSURSX0VMMSzCoMKgwqAgLyogVGhyZWFkIElELCBQcml2aWxlZ2VkICovCj4+PiDCoMKgwqDC
oCBBTUFJUl9FTDEswqDCoMKgIC8qIEF1eCBNZW1vcnkgQXR0cmlidXRlIEluZGlyZWN0aW9uIFJl
Z2lzdGVyICovCj4+PiDCoMKgwqDCoCBDTlRLQ1RMX0VMMSzCoMKgwqAgLyogVGltZXIgQ29udHJv
bCBSZWdpc3RlciAoRUwxKSAqLwo+Pj4gK8KgwqDCoCBURlNSRTBfRUwxLMKgwqDCoCAvKiBUYWcg
RmF1bHQgU3RhdHVzIFJlZ2lzdGVyIChFTDApICovCj4+PiArwqDCoMKgIFRGU1JfRUwxLMKgwqDC
oCAvKiBUYWcgRmF1bHQgU3RhdXRzIFJlZ2lzdGVyIChFTDEpICovCj4+IAo+PiBzL1N0YXV0cy9T
dGF0dXMvCj4+IAo+PiBJcyB0aGVyZSBhbnkgcmVhc29uIHdoeSB0aGUgTVRFIHJlZ2lzdGVycyBh
cmVuJ3QgZ3JvdXBlZCB0b2dldGhlcj8KPiAKPiBJIGhhcyBiZWVuIHVuZGVyIHRoZSBpbXByZXNz
aW9uIHRoaXMgbGlzdCBpcyBzb3J0ZWQgYnkgdGhlIGVuY29kaW5nIG9mCj4gdGhlIHN5c3RlbSBy
ZWdpc3RlcnMsIGFsdGhvdWdoIGRvdWJsZSBjaGVja2luZyBJJ3ZlIHNjcmV3ZWQgdXAgdGhlCj4g
b3JkZXIgb2YgVEZTUkUwX0VMMS9URlNSX0VMMSwgYW5kIG5vdCBhbGwgdGhlIG90aGVyIGZpZWxk
cyBhcmUgc29ydGVkCj4gdGhhdCB3YXkuCgpJdCBncmV3IG9yZ2FuaWNhbGx5LCBhbmQgd2FzIGlu
aXRpYWxseSBtYXRjaGluZyB0aGUgb3JpZ2luYWwgb3JkZXIKb2YgdGhlIHNhdmUvcmVzdG9yZSBz
ZXF1ZW5jZS4gVGhpcyBvcmRlciBoYXMgbG9uZyBkaXNhcHBlYXJlZCB3aXRoClZIRSwgYW5kIHRo
aXMgaXMgZXNzZW50aWFsbHkgbm90aGluZyBtb3JlIHRoYW4gYSBiYWcgb2YgaW5kaWNlcwooYWx0
aG91Z2ggTlYgZG9lcyBicmluZyBzb21lIG9yZGVyIGJhY2sgdG8gZGVhbCB3aXRoIFZOQ1ItYmFj
a2VkCnJlZ2lzdGVycykuCgpbLi4uXQoKPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9o
eXAvaW5jbHVkZS9oeXAvc3lzcmVnLXNyLmgKPj4+IGIvYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1
ZGUvaHlwL3N5c3JlZy1zci5oCj4+PiBpbmRleCBjY2U0M2JmZTE1OGYuLjk0ZDk3MzZmMDEzMyAx
MDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cC9pbmNsdWRlL2h5cC9zeXNyZWctc3Iu
aAo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N5c3JlZy1zci5oCj4+
PiBAQCAtNDUsNiArNDUsOCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgX19zeXNyZWdfc2F2ZV9lbDFf
c3RhdGUoc3RydWN0Cj4+PiBrdm1fY3B1X2NvbnRleHQgKmN0eHQpCj4+PiDCoMKgwqDCoCBjdHh0
X3N5c19yZWcoY3R4dCwgQ05US0NUTF9FTDEpwqDCoMKgID0gCj4+PiByZWFkX3N5c3JlZ19lbDEo
U1lTX0NOVEtDVEwpOwo+Pj4gwqDCoMKgwqAgY3R4dF9zeXNfcmVnKGN0eHQsIFBBUl9FTDEpwqDC
oMKgID0gcmVhZF9zeXNyZWdfcGFyKCk7Cj4+PiDCoMKgwqDCoCBjdHh0X3N5c19yZWcoY3R4dCwg
VFBJRFJfRUwxKcKgwqDCoCA9IHJlYWRfc3lzcmVnKHRwaWRyX2VsMSk7Cj4+PiArwqDCoMKgIGlm
IChzeXN0ZW1fc3VwcG9ydHNfbXRlKCkpCj4+PiArwqDCoMKgwqDCoMKgwqAgY3R4dF9zeXNfcmVn
KGN0eHQsIFRGU1JfRUwxKSA9IHJlYWRfc3lzcmVnX2VsMShTWVNfVEZTUik7Cj4+IAo+PiBJIGFs
cmVhZHkgYXNrZWQgZm9yIGl0LCBhbmQgSSdtIGdvaW5nIHRvIGFzayBmb3IgaXQgYWdhaW46Cj4+
IE1vc3Qgb2YgdGhlIHN5c3JlZyBzYXZlL3Jlc3RvcmUgaXMgZ3VhcmRlZCBieSBhIHBlci12Y3B1
IGNoZWNrCj4+IChIQ1JfRUwyLkFUQSksIHdoaWxlIHRoaXMgb25lIGlzIHVuY29uZGl0aW9uYWxs
eSBzYXZlZC9yZXN0b3JlCj4+IGlmIHRoZSBob3N0IGlzIE1URSBjYXBhYmxlLiBXaHkgaXMgdGhh
dCBzbz8KPiAKPiBTb3JyeSwgSSB0aG91Z2h0IHlvdXIgY29uY2VybiB3YXMgZm9yIHJlZ2lzdGVy
cyB0aGF0IGFmZmVjdCB0aGUgaG9zdAo+IChhcyB0aGV5IGFyZSBvYnZpb3VzbHkgbW9yZSBwZXJm
b3JtYW5jZSBjcml0aWNhbCBhcyB0aGV5IGFyZSBoaXQgb24KPiBldmVyeSBndWVzdCBleGl0KS4g
QWx0aG91Z2ggSSBndWVzcyB0aGF0J3MgaW5jb3JyZWN0IGZvciBuVkhFIHdoaWNoIGlzCj4gd2hh
dCBhbGwgdGhlIGNvb2wga2lkcyB3YW50IG5vdyA7KQoKSSB0aGluayB3ZSB3YW50IGJvdGggY29y
cmVjdG5lc3MgKmFuZCogcGVyZm9ybWFuY2UsIGZvciBib3RoIFZIRQphbmQgblZIRS4gVGhpbmdz
IGxpa2UgRUwwIHJlZ2lzdGVycyBzaG91bGQgYmUgYWJsZSB0byBiZSBtb3ZlZAp0byBsb2FkL3B1
dCBvbiBhbGwgaW1wbGVtZW50YXRpb25zLCBhbmQgdGhlIGNvcnJlY3Qgc3dpdGNoaW5nCmJlIGRv
bmUgYXQgdGhlIHJpZ2h0IHNwb3Qgb25seSB3aGVuIHJlcXVpcmVkLgoKVGhhbmtzLAoKICAgICAg
ICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
