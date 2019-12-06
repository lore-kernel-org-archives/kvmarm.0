Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635C6C2BD09
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 09:56:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E30D820659
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 09:56:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cqv67j4s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E30D820659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4637C4AF47;
	Fri,  6 Dec 2019 04:56:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lVTA6P1ZF90K; Fri,  6 Dec 2019 04:56:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 134C24AE9D;
	Fri,  6 Dec 2019 04:56:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 454BF4AE9D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 04:56:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lSC9WCNHmtNk for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 04:56:25 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F884ACB8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 04:56:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575626185;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VOvbHJVSDRI4m0IXeh03+Ff7np0GCFp67dk4huZAiEc=;
 b=cqv67j4sttSY5qTjMR33vCJgrOxoREULo1mrzjngDUf4bUEzmqqBcRtr/qIMjio0AWx9f3
 DwISxd8aAzVSZkyNx7vJJGiLCMvm0+Y9CcdPzIEnLuJRLhZXtjNAGJw/300GJ3mKom60/S
 re5zg/SWmu+Vm6VsQVBlG0G/FsDJwfw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-VidzrRDDPNqgK98wMd65Qg-1; Fri, 06 Dec 2019 04:56:22 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81B07107ACC4;
 Fri,  6 Dec 2019 09:56:20 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07E96A4B8F;
 Fri,  6 Dec 2019 09:56:17 +0000 (UTC)
Subject: Re: [RFC 2/3] KVM: arm64: pmu: Fix chained SW_INCR counters
From: Auger Eric <eric.auger@redhat.com>
To: Marc Zyngier <maz@kernel.org>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-3-eric.auger@redhat.com>
 <561ac6df385e977cc51d51a8ab28ee49@www.loen.fr>
 <2b30c1ca-3bc0-9f73-4bea-ee42bb74cbac@redhat.com>
 <15507faca89a980056df7119e105e82a@www.loen.fr>
 <145cdd1c-266c-6252-9688-e9e4c6809dfd@redhat.com>
Message-ID: <ef4d407e-94e5-a13f-8e06-beda1d3d6459@redhat.com>
Date: Fri, 6 Dec 2019 10:56:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <145cdd1c-266c-6252-9688-e9e4c6809dfd@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: VidzrRDDPNqgK98wMd65Qg-1
X-Mimecast-Spam-Score: 0
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

SGksCgpPbiAxMi81LzE5IDg6MDEgUE0sIEF1Z2VyIEVyaWMgd3JvdGU6Cj4gSGkgTWFyYywKPiAK
PiBPbiAxMi81LzE5IDM6NTIgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAxOS0xMi0w
NSAxNDowNiwgQXVnZXIgRXJpYyB3cm90ZToKPj4+IEhpIE1hcmMsCj4+Pgo+Pj4gT24gMTIvNS8x
OSAxMDo0MyBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+IEhpIEVyaWMsCj4+Pj4KPj4+PiBP
biAyMDE5LTEyLTA0IDIwOjQ0LCBFcmljIEF1Z2VyIHdyb3RlOgo+Pj4+PiBBdCB0aGUgbW9tZW50
IGEgU1dfSU5DUiBjb3VudGVyIGFsd2F5cyBvdmVyZmxvd3Mgb24gMzItYml0Cj4+Pj4+IGJvdW5k
YXJ5LCBpbmRlcGVuZGVudGx5IG9uIHdoZXRoZXIgdGhlIG4rMXRoIGNvdW50ZXIgaXMKPj4+Pj4g
cHJvZ3JhbW1lZCBhcyBDSEFJTi4KPj4+Pj4KPj4+Pj4gQ2hlY2sgd2hldGhlciB0aGUgU1dfSU5D
UiBjb3VudGVyIGlzIGEgNjRiIGNvdW50ZXIgYW5kIGlmIHNvLAo+Pj4+PiBpbXBsZW1lbnQgdGhl
IDY0YiBsb2dpYy4KPj4+Pj4KPj4+Pj4gRml4ZXM6IDgwZjM5M2EyM2JlNiAoIktWTTogYXJtL2Fy
bTY0OiBTdXBwb3J0IGNoYWluZWQgUE1VIGNvdW50ZXJzIikKPj4+Pj4gU2lnbmVkLW9mZi1ieTog
RXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+Pj4+PiAtLS0KPj4+Pj4gwqB2aXJ0
L2t2bS9hcm0vcG11LmMgfCAxNiArKysrKysrKysrKysrKystCj4+Pj4+IMKgMSBmaWxlIGNoYW5n
ZWQsIDE1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPj4+Pj4KPj4+Pj4gZGlmZiAtLWdp
dCBhL3ZpcnQva3ZtL2FybS9wbXUuYyBiL3ZpcnQva3ZtL2FybS9wbXUuYwo+Pj4+PiBpbmRleCBj
M2Y4YjA1OTg4MWUuLjdhYjQ3N2RiMmY3NSAxMDA2NDQKPj4+Pj4gLS0tIGEvdmlydC9rdm0vYXJt
L3BtdS5jCj4+Pj4+ICsrKyBiL3ZpcnQva3ZtL2FybS9wbXUuYwo+Pj4+PiBAQCAtNDkxLDYgKzQ5
MSw4IEBAIHZvaWQga3ZtX3BtdV9zb2Z0d2FyZV9pbmNyZW1lbnQoc3RydWN0IGt2bV92Y3B1Cj4+
Pj4+ICp2Y3B1LCB1NjQgdmFsKQo+Pj4+Pgo+Pj4+PiDCoMKgwqDCoCBlbmFibGUgPSBfX3ZjcHVf
c3lzX3JlZyh2Y3B1LCBQTUNOVEVOU0VUX0VMMCk7Cj4+Pj4+IMKgwqDCoMKgIGZvciAoaSA9IDA7
IGkgPCBBUk1WOF9QTVVfQ1lDTEVfSURYOyBpKyspIHsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGJv
b2wgY2hhaW5lZCA9IHRlc3RfYml0KGkgPj4gMSwgdmNwdS0+YXJjaC5wbXUuY2hhaW5lZCk7Cj4+
Pj4+ICsKPj4+Pgo+Pj4+IEknZCByYXRoZXIgeW91IHVzZSBrdm1fcG11X3BtY19pc19jaGFpbmVk
KCkgcmF0aGVyIHRoYW4gb3Blbi1jb2RpbmcKPj4+PiB0aGlzLiBCdXQgc2VlIGJlbG93Ogo+Pj4+
Cj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKCEodmFsICYgQklUKGkpKSkKPj4+Pj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgIHR5cGUg
PSBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTUVWVFlQRVIwX0VMMCArIGkpCj4+Pj4+IEBAIC01MDAs
OCArNTAyLDIwIEBAIHZvaWQga3ZtX3BtdV9zb2Z0d2FyZV9pbmNyZW1lbnQoc3RydWN0IGt2bV92
Y3B1Cj4+Pj4+ICp2Y3B1LCB1NjQgdmFsKQo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmVnID0gX192Y3B1X3N5c19yZWcodmNwdSwgUE1FVkNOVFIwX0VMMCArIGkpICsgMTsKPj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlZyA9IGxvd2VyXzMyX2JpdHMocmVnKTsKPj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNRVZDTlRSMF9F
TDAgKyBpKSA9IHJlZzsKPj4+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFyZWcpCj4+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChyZWcpIC8qIG5vIG92ZXJmbG93ICovCj4+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7Cj4+Pj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGlmIChjaGFpbmVkKSB7Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmVnID0gX192Y3B1X3N5c19yZWcodmNwdSwgUE1FVkNOVFIwX0VMMCAr
IGkgKyAxKSArIDE7Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVnID0g
bG93ZXJfMzJfYml0cyhyZWcpOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNRVZDTlRSMF9FTDAgKyBpICsgMSkgPSByZWc7Cj4+Pj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJlZykKPj4+Pj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+Pj4+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIG1hcmsgYW4gb3ZlcmZsb3cgb24gaGlnaCBjb3VudGVy
ICovCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX192Y3B1X3N5c19yZWco
dmNwdSwgUE1PVlNTRVRfRUwwKSB8PSBCSVQoaSArIDEpOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB9IGVsc2Ugewo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8q
IG1hcmsgYW4gb3ZlcmZsb3cgKi8KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgX192Y3B1X3N5c19yZWcodmNwdSwgUE1PVlNTRVRfRUwwKSB8PSBCSVQoaSk7Cj4+Pj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCB9Cj4+Pj4+IMKg
wqDCoMKgIH0KPj4+Pj4gwqB9Cj4+Pj4KPj4+PiBJIHRoaW5rIHRoZSB3aG9sZSBmdW5jdGlvbiBp
cyBhIGJpdCBvZiBhIG1lc3MsIGFuZCBjb3VsZCBiZSBiZXR0ZXIKPj4+PiBzdHJ1Y3R1cmVkIHRv
IHRyZWF0IDY0Yml0IGNvdW50ZXJzIGFzIGEgZmlyc3QgY2xhc3MgY2l0aXplbi4KPj4+Pgo+Pj4+
IEknbSBzdWdnZXN0aW5nIHNvbWV0aGluZyBhbG9uZyB0aG9zZSBsaW5lcywgd2hpY2ggdHJpZXMg
dG8KPj4+PiBzdHJlYW1saW5lIHRoaW5ncyBhIGJpdCBhbmQga2VlcCB0aGUgZmxvdyB1bmlmb3Jt
IGJldHdlZW4gdGhlCj4+Pj4gdHdvIHdvcmQgc2l6ZXMuIElNSE8sIGl0IGhlbHBzIHJlYXNvbm5p
bmcgYWJvdXQgaXQgYW5kIGdpdmVzCj4+Pj4gc2NvcGUgdG8gdGhlIEFSTXY4LjUgZnVsbCA2NGJp
dCBjb3VudGVycy4uLiBJdCBpcyBvZiBjb3Vyc2UKPj4+PiBjb21wbGV0ZWx5IHVudGVzdGVkLgo+
Pj4KPj4+IExvb2tzIE9LIHRvIG1lIGFzIHdlbGwuIE9uZSByZW1hcmsgdGhvdWdoLCBkb24ndCB3
ZSBuZWVkIHRvIHRlc3QgaWYgdGhlCj4+PiBuKzF0aCByZWcgaXMgZW5hYmxlZCBiZWZvcmUgaW5j
cmVtZW50aW5nIGl0Pwo+Pgo+PiBIbW1tLiBJJ20gbm90IHN1cmUuIEkgdGhpbmsgd2Ugc2hvdWxk
IG1ha2Ugc3VyZSB0aGF0IHdlIGRvbid0IGZsYWcKPj4gYSBjb3VudGVyIGFzIGJlaW5nIGNoYWlu
ZWQgaWYgdGhlIG9kZCBjb3VudGVyIGlzIGRpc2FibGVkLCByYXRoZXIKPj4gdGhhbiBjaGVja2lu
ZyBpdCBoZXJlLiBBcyBsb25nIGFzIHRoZSBvZGQgY291bnRlciBpcyBub3QgY2hhaW5lZAo+PiAq
YW5kKiBlbmFibGVkLCB3ZSBzaG91bGRuJ3QgdG91Y2ggaXQuPgo+PiBBZ2FpbiwgdW50ZXN0ZWQ6
Cj4+Cj4+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vcG11LmMgYi92aXJ0L2t2bS9hcm0vcG11
LmMKPj4gaW5kZXggY2YzNzFmNjQzYWRlLi40NzM2NjgxN2NkMmEgMTAwNjQ0Cj4+IC0tLSBhL3Zp
cnQva3ZtL2FybS9wbXUuYwo+PiArKysgYi92aXJ0L2t2bS9hcm0vcG11LmMKPj4gQEAgLTE1LDYg
KzE1LDcgQEAKPj4gwqAjaW5jbHVkZSA8a3ZtL2FybV92Z2ljLmg+Cj4+Cj4+IMKgc3RhdGljIHZv
aWQga3ZtX3BtdV9jcmVhdGVfcGVyZl9ldmVudChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NAo+
PiBzZWxlY3RfaWR4KTsKPj4gK3N0YXRpYyB2b2lkIGt2bV9wbXVfdXBkYXRlX3BtY19jaGFpbmVk
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0Cj4+IHNlbGVjdF9pZHgpOwo+Pgo+PiDCoCNkZWZp
bmUgUEVSRl9BVFRSX0NGRzFfS1ZNX1BNVV9DSEFJTkVEIDB4MQo+Pgo+PiBAQCAtMjk4LDYgKzI5
OSw3IEBAIHZvaWQga3ZtX3BtdV9lbmFibGVfY291bnRlcl9tYXNrKHN0cnVjdCBrdm1fdmNwdQo+
PiAqdmNwdSwgdTY0IHZhbCkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgICogRm9yIGhpZ2ggY291bnRl
cnMgb2YgY2hhaW5lZCBldmVudHMgd2UgbXVzdCByZWNyZWF0ZSB0aGUKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgICogcGVyZiBldmVudCB3aXRoIHRoZSBsb25nICg2NGJpdCkgYXR0cmlidXRlIHNldC4K
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgICovCj4+ICvCoMKgwqDCoMKgwqDCoCBrdm1fcG11X3VwZGF0
ZV9wbWNfY2hhaW5lZCh2Y3B1LCBpKTsKPj4gwqDCoMKgwqDCoMKgwqDCoCBpZiAoa3ZtX3BtdV9w
bWNfaXNfY2hhaW5lZChwbWMpICYmCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fcG11
X2lkeF9pc19oaWdoX2NvdW50ZXIoaSkpIHsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2
bV9wbXVfY3JlYXRlX3BlcmZfZXZlbnQodmNwdSwgaSk7Cj4+IEBAIC02NDUsNyArNjQ3LDggQEAg
c3RhdGljIHZvaWQga3ZtX3BtdV91cGRhdGVfcG1jX2NoYWluZWQoc3RydWN0Cj4+IGt2bV92Y3B1
ICp2Y3B1LCB1NjQgc2VsZWN0X2lkeCkKPj4gwqDCoMKgwqAgc3RydWN0IGt2bV9wbXUgKnBtdSA9
ICZ2Y3B1LT5hcmNoLnBtdTsKPj4gwqDCoMKgwqAgc3RydWN0IGt2bV9wbWMgKnBtYyA9ICZwbXUt
PnBtY1tzZWxlY3RfaWR4XTsKPj4KPj4gLcKgwqDCoCBpZiAoa3ZtX3BtdV9pZHhfaGFzX2NoYWlu
X2V2dHlwZSh2Y3B1LCBwbWMtPmlkeCkpIHsKPj4gK8KgwqDCoCBpZiAoa3ZtX3BtdV9pZHhfaGFz
X2NoYWluX2V2dHlwZSh2Y3B1LCBwbWMtPmlkeCkgJiYKPj4gK8KgwqDCoMKgwqDCoMKgIGt2bV9w
bXVfY291bnRlcl9pc19lbmFibGVkKHZjcHUsIHBtYy0+aWR4KSkgewo+IAo+IEluIGNyZWF0ZV9w
ZXJmX2V2ZW50KCksIGhhc19jaGFpbl9ldnR5cGUoKSBpcyB1c2VkIGFuZCBhIDY0YiBzYW1wbGUK
PiBwZXJpb2Qgd291bGQgYmUgY2hvc2VuIGV2ZW4gaWYgdGhlIGNvdW50ZXJzIGFyZSBkaXNqb2lu
ZWQgKHNpbmNlIHRoZSBvZGQKPiBpcyBkaXNhYmxlZCkuIFdlIHdvdWxkIG5lZWQgdG8gdXNlIHBt
Y19pc19jaGFpbmVkKCkgaW5zdGVhZC4KPiAKPiBXaXRoIHBlcmZfZXZlbnRzLCB0aGUgY2hlY2sg
b2Ygd2hldGhlciB0aGUgb2RkIHJlZ2lzdGVyIGlzIGVuYWJsZWQgaXMKPiBwcm9wZXJseSBkb25l
IChjcmVhdGVfcGVyZl9ldmVudCkuCgpIdW0gdGhhdCdzIG5vdCBmdWxseSB0cnVlLiBJZiB3ZSBk
byBub3QgZW5hYmxlIHRoZSBDSEFJTiBvZGQgb25lIGJ1dApvbmx5IHRoZSBldmVudCBvbmUsIHRo
ZSBjb3JyZWN0IDMyYiBwZXJmIGNvdW50ZXIgaXMgY3JlYXRlZC4gQnV0IHdoZW4KcmVhZGluZyB0
aGUgb2RkIHJlZyBhZnRlciBvdmVyZmxvdyB3ZSBnZXQgdGhlIGluY3JlbWVudGVkIHZhbHVlCihn
ZXRfY291bnRlcl92YWx1ZSkuCgpUaGFua3MKCkVyaWMKCiBUaGVuIEkgdW5kZXJzdGFuZCB3aGVu
ZXZlciB0aGVyZSBpcyBhCj4gY2hhbmdlIGluIGVuYWJsZSBzdGF0ZSBvciB0eXBlIHdlIGRlbGV0
ZSB0aGUgcHJldmlvdXMgcGVyZiBldmVudCBhbmQKPiByZS1jcmVhdGUgYSBuZXcgb25lLiBFbmFi
bGUgc3RhdGUgY2hlY2sganVzdCBpcyBtaXNzaW5nIGZvciBTV19JTkNSLgo+IAo+IFNvbWUgb3Ro
ZXIgcXVlc3Rpb25zOgo+IC0gZG8gd2UgbmVlZCBhIHBlcmYgZXZlbnQgdG8gYmUgY3JlYXRlZCBl
dmVuIGlmIHRoZSBjb3VudGVyIGlzIG5vdAo+IGVuYWJsZWQ/IEZvciBpbnN0YW5jZSBvbiBjb3Vu
dGVyIHJlc2V0cywgY3JlYXRlX3BlcmZfZXZlbnRzIGdldCBjYWxsZWQuCj4gLSBhbHNvIGFjdGlv
bnMgYXJlIG1hZGUgZm9yIGNvdW50ZXJzIHdoaWNoIGFyZSBub3QgaW1wbGVtZW50ZWQuIGxvb3AK
PiB1bnRpbCBBUk1WOF9QTVVfTUFYX0NPVU5URVJTLiBEbyB5b3UgdGhpbmsgaXQgaXMgdmFsdWFi
bGUgdG8gaGF2ZSBhCj4gYml0bWFzayBvZiBzdXBwb3J0ZWQgY291bnRlcnMgc3RvcmVkIGJlZm9y
ZSBwbXUgcmVhZGluZXNzPwo+IEkgY2FuIHByb3Bvc2Ugc3VjaCBjaGFuZ2VzIGlmIHlvdSB0aGlu
ayB0aGV5IGFyZSB2YWx1YWJsZS4KPiAKPiBUaGFua3MKPiAKPiBFcmljCj4gCj4+IMKgwqDCoMKg
wqDCoMKgwqAgLyoKPj4gwqDCoMKgwqDCoMKgwqDCoMKgICogRHVyaW5nIHByb21vdGlvbiBmcm9t
ICFjaGFpbmVkIHRvIGNoYWluZWQgd2UgbXVzdCBlbnN1cmUKPj4gwqDCoMKgwqDCoMKgwqDCoMKg
ICogdGhlIGFkamFjZW50IGNvdW50ZXIgaXMgc3RvcHBlZCBhbmQgaXRzIGV2ZW50IGRlc3Ryb3ll
ZAo+Pgo+PiBXaGF0IGRvIHlvdSB0aGluaz8KPj4KPj4gwqDCoMKgwqDCoMKgwqAgTS4KCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
