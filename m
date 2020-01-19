Return-Path: <SRS0=D0fm=3I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EAAC33CB1
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 17:59:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 221EC20684
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 17:59:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="InJm9Rlx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 221EC20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B62224A800;
	Sun, 19 Jan 2020 12:59:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EqTFHYjA0XzE; Sun, 19 Jan 2020 12:58:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A9654A7FF;
	Sun, 19 Jan 2020 12:58:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 533854A5C6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 12:58:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r3kFYqQRgX-m for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jan 2020 12:58:55 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C784C4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 12:58:55 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8A99920684;
 Sun, 19 Jan 2020 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579456734;
 bh=mT0Uxzq5onKGX7RnVyLTKIhtj3jJF6fLqPFpyYCi82Y=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=InJm9RlxWDH1LktQ/klJRdyuOFGDKd3INkwDthBwngqqrIjSkKlP3avdT2IHoCtJG
 QVY05Zlw/vgty6hQmfKRSBrO0tlvd3LeHcWoVTZZLdJKw1EGPt1tx9k2XIt29OnCUF
 Um58znkTSMlb9yeAl+D/lVd6/hc26rU9vsCpt4iU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1itEqa-0004H2-OX; Sun, 19 Jan 2020 17:58:52 +0000
Date: Sun, 19 Jan 2020 17:58:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 2/3] KVM: arm64: pmu: Fix chained SW_INCR counters
Message-ID: <20200119175851.2104d86f@why>
In-Reply-To: <145cdd1c-266c-6252-9688-e9e4c6809dfd@redhat.com>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-3-eric.auger@redhat.com>
 <561ac6df385e977cc51d51a8ab28ee49@www.loen.fr>
 <2b30c1ca-3bc0-9f73-4bea-ee42bb74cbac@redhat.com>
 <15507faca89a980056df7119e105e82a@www.loen.fr>
 <145cdd1c-266c-6252-9688-e9e4c6809dfd@redhat.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, andrew.murray@arm.com, suzuki.poulose@arm.com,
 drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

T24gVGh1LCA1IERlYyAyMDE5IDIwOjAxOjQyICswMTAwCkF1Z2VyIEVyaWMgPGVyaWMuYXVnZXJA
cmVkaGF0LmNvbT4gd3JvdGU6CgpIaSBFcmljLAoKPiBIaSBNYXJjLAo+IAo+IE9uIDEyLzUvMTkg
Mzo1MiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+ID4gT24gMjAxOS0xMi0wNSAxNDowNiwgQXVn
ZXIgRXJpYyB3cm90ZTogIAo+ID4+IEhpIE1hcmMsCj4gPj4KPiA+PiBPbiAxMi81LzE5IDEwOjQz
IEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6ICAKPiA+Pj4gSGkgRXJpYywKPiA+Pj4KPiA+Pj4gT24g
MjAxOS0xMi0wNCAyMDo0NCwgRXJpYyBBdWdlciB3cm90ZTogIAo+ID4+Pj4gQXQgdGhlIG1vbWVu
dCBhIFNXX0lOQ1IgY291bnRlciBhbHdheXMgb3ZlcmZsb3dzIG9uIDMyLWJpdAo+ID4+Pj4gYm91
bmRhcnksIGluZGVwZW5kZW50bHkgb24gd2hldGhlciB0aGUgbisxdGggY291bnRlciBpcwo+ID4+
Pj4gcHJvZ3JhbW1lZCBhcyBDSEFJTi4KPiA+Pj4+Cj4gPj4+PiBDaGVjayB3aGV0aGVyIHRoZSBT
V19JTkNSIGNvdW50ZXIgaXMgYSA2NGIgY291bnRlciBhbmQgaWYgc28sCj4gPj4+PiBpbXBsZW1l
bnQgdGhlIDY0YiBsb2dpYy4KPiA+Pj4+Cj4gPj4+PiBGaXhlczogODBmMzkzYTIzYmU2ICgiS1ZN
OiBhcm0vYXJtNjQ6IFN1cHBvcnQgY2hhaW5lZCBQTVUgY291bnRlcnMiKQo+ID4+Pj4gU2lnbmVk
LW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+ID4+Pj4gLS0tCj4g
Pj4+PiDCoHZpcnQva3ZtL2FybS9wbXUuYyB8IDE2ICsrKysrKysrKysrKysrKy0KPiA+Pj4+IMKg
MSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiA+Pj4+Cj4g
Pj4+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3BtdS5jIGIvdmlydC9rdm0vYXJtL3BtdS5j
Cj4gPj4+PiBpbmRleCBjM2Y4YjA1OTg4MWUuLjdhYjQ3N2RiMmY3NSAxMDA2NDQKPiA+Pj4+IC0t
LSBhL3ZpcnQva3ZtL2FybS9wbXUuYwo+ID4+Pj4gKysrIGIvdmlydC9rdm0vYXJtL3BtdS5jCj4g
Pj4+PiBAQCAtNDkxLDYgKzQ5MSw4IEBAIHZvaWQga3ZtX3BtdV9zb2Z0d2FyZV9pbmNyZW1lbnQo
c3RydWN0IGt2bV92Y3B1Cj4gPj4+PiAqdmNwdSwgdTY0IHZhbCkKPiA+Pj4+Cj4gPj4+PiDCoMKg
wqDCoCBlbmFibGUgPSBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTUNOVEVOU0VUX0VMMCk7Cj4gPj4+
PiDCoMKgwqDCoCBmb3IgKGkgPSAwOyBpIDwgQVJNVjhfUE1VX0NZQ0xFX0lEWDsgaSsrKSB7Cj4g
Pj4+PiArwqDCoMKgwqDCoMKgwqAgYm9vbCBjaGFpbmVkID0gdGVzdF9iaXQoaSA+PiAxLCB2Y3B1
LT5hcmNoLnBtdS5jaGFpbmVkKTsKPiA+Pj4+ICsgIAo+ID4+Pgo+ID4+PiBJJ2QgcmF0aGVyIHlv
dSB1c2Uga3ZtX3BtdV9wbWNfaXNfY2hhaW5lZCgpIHJhdGhlciB0aGFuIG9wZW4tY29kaW5nCj4g
Pj4+IHRoaXMuIEJ1dCBzZWUgYmVsb3c6Cj4gPj4+ICAKPiA+Pj4+IMKgwqDCoMKgwqDCoMKgwqAg
aWYgKCEodmFsICYgQklUKGkpKSkKPiA+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250
aW51ZTsKPiA+Pj4+IMKgwqDCoMKgwqDCoMKgwqAgdHlwZSA9IF9fdmNwdV9zeXNfcmVnKHZjcHUs
IFBNRVZUWVBFUjBfRUwwICsgaSkKPiA+Pj4+IEBAIC01MDAsOCArNTAyLDIwIEBAIHZvaWQga3Zt
X3BtdV9zb2Z0d2FyZV9pbmNyZW1lbnQoc3RydWN0IGt2bV92Y3B1Cj4gPj4+PiAqdmNwdSwgdTY0
IHZhbCkKPiA+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWcgPSBfX3ZjcHVfc3lzX3Jl
Zyh2Y3B1LCBQTUVWQ05UUjBfRUwwICsgaSkgKyAxOwo+ID4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJlZyA9IGxvd2VyXzMyX2JpdHMocmVnKTsKPiA+Pj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTUVWQ05UUjBfRUwwICsgaSkgPSByZWc7Cj4g
Pj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIXJlZykKPiA+Pj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGlmIChyZWcpIC8qIG5vIG92ZXJmbG93ICovCj4gPj4+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+ID4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgaWYgKGNoYWluZWQpIHsKPiA+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgcmVnID0gX192Y3B1X3N5c19yZWcodmNwdSwgUE1FVkNOVFIwX0VMMCArIGkgKyAxKSArIDE7
Cj4gPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlZyA9IGxvd2VyXzMyX2Jp
dHMocmVnKTsKPiA+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX192Y3B1X3N5
c19yZWcodmNwdSwgUE1FVkNOVFIwX0VMMCArIGkgKyAxKSA9IHJlZzsKPiA+Pj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJlZykKPiA+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsKPiA+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgLyogbWFyayBhbiBvdmVyZmxvdyBvbiBoaWdoIGNvdW50ZXIgKi8KPiA+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX192Y3B1X3N5c19yZWcodmNwdSwg
UE1PVlNTRVRfRUwwKSB8PSBCSVQoaSArIDEpOwo+ID4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfSBlbHNlIHsKPiA+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyogbWFy
ayBhbiBvdmVyZmxvdyAqLwo+ID4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
X192Y3B1X3N5c19yZWcodmNwdSwgUE1PVlNTRVRfRUwwKSB8PSBCSVQoaSk7Cj4gPj4+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4gPj4+PiDCoMKgwqDCoMKgwqDCoMKgIH0KPiA+Pj4+IMKg
wqDCoMKgIH0KPiA+Pj4+IMKgfSAgCj4gPj4+Cj4gPj4+IEkgdGhpbmsgdGhlIHdob2xlIGZ1bmN0
aW9uIGlzIGEgYml0IG9mIGEgbWVzcywgYW5kIGNvdWxkIGJlIGJldHRlcgo+ID4+PiBzdHJ1Y3R1
cmVkIHRvIHRyZWF0IDY0Yml0IGNvdW50ZXJzIGFzIGEgZmlyc3QgY2xhc3MgY2l0aXplbi4KPiA+
Pj4KPiA+Pj4gSSdtIHN1Z2dlc3Rpbmcgc29tZXRoaW5nIGFsb25nIHRob3NlIGxpbmVzLCB3aGlj
aCB0cmllcyB0bwo+ID4+PiBzdHJlYW1saW5lIHRoaW5ncyBhIGJpdCBhbmQga2VlcCB0aGUgZmxv
dyB1bmlmb3JtIGJldHdlZW4gdGhlCj4gPj4+IHR3byB3b3JkIHNpemVzLiBJTUhPLCBpdCBoZWxw
cyByZWFzb25uaW5nIGFib3V0IGl0IGFuZCBnaXZlcwo+ID4+PiBzY29wZSB0byB0aGUgQVJNdjgu
NSBmdWxsIDY0Yml0IGNvdW50ZXJzLi4uIEl0IGlzIG9mIGNvdXJzZQo+ID4+PiBjb21wbGV0ZWx5
IHVudGVzdGVkLiAgCj4gPj4KPiA+PiBMb29rcyBPSyB0byBtZSBhcyB3ZWxsLiBPbmUgcmVtYXJr
IHRob3VnaCwgZG9uJ3Qgd2UgbmVlZCB0byB0ZXN0IGlmIHRoZQo+ID4+IG4rMXRoIHJlZyBpcyBl
bmFibGVkIGJlZm9yZSBpbmNyZW1lbnRpbmcgaXQ/ICAKPiA+IAo+ID4gSG1tbS4gSSdtIG5vdCBz
dXJlLiBJIHRoaW5rIHdlIHNob3VsZCBtYWtlIHN1cmUgdGhhdCB3ZSBkb24ndCBmbGFnCj4gPiBh
IGNvdW50ZXIgYXMgYmVpbmcgY2hhaW5lZCBpZiB0aGUgb2RkIGNvdW50ZXIgaXMgZGlzYWJsZWQs
IHJhdGhlcgo+ID4gdGhhbiBjaGVja2luZyBpdCBoZXJlLiBBcyBsb25nIGFzIHRoZSBvZGQgY291
bnRlciBpcyBub3QgY2hhaW5lZAo+ID4gKmFuZCogZW5hYmxlZCwgd2Ugc2hvdWxkbid0IHRvdWNo
IGl0Lj4KPiA+IEFnYWluLCB1bnRlc3RlZDoKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL3ZpcnQva3Zt
L2FybS9wbXUuYyBiL3ZpcnQva3ZtL2FybS9wbXUuYwo+ID4gaW5kZXggY2YzNzFmNjQzYWRlLi40
NzM2NjgxN2NkMmEgMTAwNjQ0Cj4gPiAtLS0gYS92aXJ0L2t2bS9hcm0vcG11LmMKPiA+ICsrKyBi
L3ZpcnQva3ZtL2FybS9wbXUuYwo+ID4gQEAgLTE1LDYgKzE1LDcgQEAKPiA+IMKgI2luY2x1ZGUg
PGt2bS9hcm1fdmdpYy5oPgo+ID4gCj4gPiDCoHN0YXRpYyB2b2lkIGt2bV9wbXVfY3JlYXRlX3Bl
cmZfZXZlbnQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQKPiA+IHNlbGVjdF9pZHgpOwo+ID4g
K3N0YXRpYyB2b2lkIGt2bV9wbXVfdXBkYXRlX3BtY19jaGFpbmVkKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwgdTY0Cj4gPiBzZWxlY3RfaWR4KTsKPiA+IAo+ID4gwqAjZGVmaW5lIFBFUkZfQVRUUl9D
RkcxX0tWTV9QTVVfQ0hBSU5FRCAweDEKPiA+IAo+ID4gQEAgLTI5OCw2ICsyOTksNyBAQCB2b2lk
IGt2bV9wbXVfZW5hYmxlX2NvdW50ZXJfbWFzayhzdHJ1Y3Qga3ZtX3ZjcHUKPiA+ICp2Y3B1LCB1
NjQgdmFsKQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgICogRm9yIGhpZ2ggY291bnRlcnMgb2YgY2hh
aW5lZCBldmVudHMgd2UgbXVzdCByZWNyZWF0ZSB0aGUKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoCAq
IHBlcmYgZXZlbnQgd2l0aCB0aGUgbG9uZyAoNjRiaXQpIGF0dHJpYnV0ZSBzZXQuCj4gPiDCoMKg
wqDCoMKgwqDCoMKgwqAgKi8KPiA+ICvCoMKgwqDCoMKgwqDCoCBrdm1fcG11X3VwZGF0ZV9wbWNf
Y2hhaW5lZCh2Y3B1LCBpKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKGt2bV9wbXVfcG1jX2lz
X2NoYWluZWQocG1jKSAmJgo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9wbXVfaWR4
X2lzX2hpZ2hfY291bnRlcihpKSkgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9w
bXVfY3JlYXRlX3BlcmZfZXZlbnQodmNwdSwgaSk7Cj4gPiBAQCAtNjQ1LDcgKzY0Nyw4IEBAIHN0
YXRpYyB2b2lkIGt2bV9wbXVfdXBkYXRlX3BtY19jaGFpbmVkKHN0cnVjdAo+ID4ga3ZtX3ZjcHUg
KnZjcHUsIHU2NCBzZWxlY3RfaWR4KQo+ID4gwqDCoMKgwqAgc3RydWN0IGt2bV9wbXUgKnBtdSA9
ICZ2Y3B1LT5hcmNoLnBtdTsKPiA+IMKgwqDCoMKgIHN0cnVjdCBrdm1fcG1jICpwbWMgPSAmcG11
LT5wbWNbc2VsZWN0X2lkeF07Cj4gPiAKPiA+IC3CoMKgwqAgaWYgKGt2bV9wbXVfaWR4X2hhc19j
aGFpbl9ldnR5cGUodmNwdSwgcG1jLT5pZHgpKSB7Cj4gPiArwqDCoMKgIGlmIChrdm1fcG11X2lk
eF9oYXNfY2hhaW5fZXZ0eXBlKHZjcHUsIHBtYy0+aWR4KSAmJgo+ID4gK8KgwqDCoMKgwqDCoMKg
IGt2bV9wbXVfY291bnRlcl9pc19lbmFibGVkKHZjcHUsIHBtYy0+aWR4KSkgeyAgCj4gCj4gSW4g
Y3JlYXRlX3BlcmZfZXZlbnQoKSwgaGFzX2NoYWluX2V2dHlwZSgpIGlzIHVzZWQgYW5kIGEgNjRi
IHNhbXBsZQo+IHBlcmlvZCB3b3VsZCBiZSBjaG9zZW4gZXZlbiBpZiB0aGUgY291bnRlcnMgYXJl
IGRpc2pvaW5lZCAoc2luY2UgdGhlIG9kZAo+IGlzIGRpc2FibGVkKS4gV2Ugd291bGQgbmVlZCB0
byB1c2UgcG1jX2lzX2NoYWluZWQoKSBpbnN0ZWFkLgo+IAo+IFdpdGggcGVyZl9ldmVudHMsIHRo
ZSBjaGVjayBvZiB3aGV0aGVyIHRoZSBvZGQgcmVnaXN0ZXIgaXMgZW5hYmxlZCBpcwo+IHByb3Bl
cmx5IGRvbmUgKGNyZWF0ZV9wZXJmX2V2ZW50KS4gVGhlbiBJIHVuZGVyc3RhbmQgd2hlbmV2ZXIg
dGhlcmUgaXMgYQo+IGNoYW5nZSBpbiBlbmFibGUgc3RhdGUgb3IgdHlwZSB3ZSBkZWxldGUgdGhl
IHByZXZpb3VzIHBlcmYgZXZlbnQgYW5kCj4gcmUtY3JlYXRlIGEgbmV3IG9uZS4gRW5hYmxlIHN0
YXRlIGNoZWNrIGp1c3QgaXMgbWlzc2luZyBmb3IgU1dfSU5DUi4KCkNhbiB5b3UgcGxlYXNlIHJl
c3BpbiB0aGlzPyBJJ2QgbGlrZSB0byBoYXZlIGl0IHF1ZXVlZCBxdWlja2x5LCBpZiBhdAphbGwg
cG9zc2libGUuCgo+IAo+IFNvbWUgb3RoZXIgcXVlc3Rpb25zOgo+IC0gZG8gd2UgbmVlZCBhIHBl
cmYgZXZlbnQgdG8gYmUgY3JlYXRlZCBldmVuIGlmIHRoZSBjb3VudGVyIGlzIG5vdAo+IGVuYWJs
ZWQ/IEZvciBpbnN0YW5jZSBvbiBjb3VudGVyIHJlc2V0cywgY3JlYXRlX3BlcmZfZXZlbnRzIGdl
dCBjYWxsZWQuCgpJdCBzaG91bGRuJ3QgYmUgbmVjZXNzYXJ5LgoKPiAtIGFsc28gYWN0aW9ucyBh
cmUgbWFkZSBmb3IgY291bnRlcnMgd2hpY2ggYXJlIG5vdCBpbXBsZW1lbnRlZC4gbG9vcAo+IHVu
dGlsIEFSTVY4X1BNVV9NQVhfQ09VTlRFUlMuIERvIHlvdSB0aGluayBpdCBpcyB2YWx1YWJsZSB0
byBoYXZlIGEKPiBiaXRtYXNrIG9mIHN1cHBvcnRlZCBjb3VudGVycyBzdG9yZWQgYmVmb3JlIHBt
dSByZWFkaW5lc3M/Cj4gSSBjYW4gcHJvcG9zZSBzdWNoIGNoYW5nZXMgaWYgeW91IHRoaW5rIHRo
ZXkgYXJlIHZhbHVhYmxlLgoKVGhhdCB3b3VsZCBjZXJ0YWlubHkgYmUgYSBwZXJmb3JtYW5jZSBv
cHRpbWl6YXRpb24uCgpUaGFua3MsCgoJTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qg
c21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
