Return-Path: <SRS0=0kEf=Z3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C41C2BD09
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 19:01:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C470F24249
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 19:01:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="deAQ7/9R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C470F24249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 519EA4A959;
	Thu,  5 Dec 2019 14:01:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GrPpY-8kpKHe; Thu,  5 Dec 2019 14:01:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF4B4AC6C;
	Thu,  5 Dec 2019 14:01:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BFBD4A959
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 14:01:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YnTR5QgKo-2f for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Dec 2019 14:01:54 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 409F140217
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 14:01:54 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575572513;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=D77fXphMC6NKMk8njAR4Uy6IgDlT5yzg7QnznzQx/3g=;
 b=deAQ7/9RaQ5EViZsksqa29abmxLXmx5fZH2XB0Pn7TNfe0bxaw4HHboFAPl07LEQ4oimTY
 g1Z3idVJL8n3rzEH+dGzxP6XxAT+1iNG0F3mlxUZLaYdVwW9DqAs8CJjZriADjOrK6MgLN
 +8w25eDulXmjUIwpqp7Usz7r9D+MXyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-98B_a_AMMLSvH1u_CCHl8w-1; Thu, 05 Dec 2019 14:01:50 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 976F5107ACC4;
 Thu,  5 Dec 2019 19:01:48 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9324C5C1B5;
 Thu,  5 Dec 2019 19:01:45 +0000 (UTC)
Subject: Re: [RFC 2/3] KVM: arm64: pmu: Fix chained SW_INCR counters
To: Marc Zyngier <maz@kernel.org>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-3-eric.auger@redhat.com>
 <561ac6df385e977cc51d51a8ab28ee49@www.loen.fr>
 <2b30c1ca-3bc0-9f73-4bea-ee42bb74cbac@redhat.com>
 <15507faca89a980056df7119e105e82a@www.loen.fr>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <145cdd1c-266c-6252-9688-e9e4c6809dfd@redhat.com>
Date: Thu, 5 Dec 2019 20:01:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <15507faca89a980056df7119e105e82a@www.loen.fr>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 98B_a_AMMLSvH1u_CCHl8w-1
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

SGkgTWFyYywKCk9uIDEyLzUvMTkgMzo1MiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIw
MTktMTItMDUgMTQ6MDYsIEF1Z2VyIEVyaWMgd3JvdGU6Cj4+IEhpIE1hcmMsCj4+Cj4+IE9uIDEy
LzUvMTkgMTA6NDMgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IEhpIEVyaWMsCj4+Pgo+Pj4g
T24gMjAxOS0xMi0wNCAyMDo0NCwgRXJpYyBBdWdlciB3cm90ZToKPj4+PiBBdCB0aGUgbW9tZW50
IGEgU1dfSU5DUiBjb3VudGVyIGFsd2F5cyBvdmVyZmxvd3Mgb24gMzItYml0Cj4+Pj4gYm91bmRh
cnksIGluZGVwZW5kZW50bHkgb24gd2hldGhlciB0aGUgbisxdGggY291bnRlciBpcwo+Pj4+IHBy
b2dyYW1tZWQgYXMgQ0hBSU4uCj4+Pj4KPj4+PiBDaGVjayB3aGV0aGVyIHRoZSBTV19JTkNSIGNv
dW50ZXIgaXMgYSA2NGIgY291bnRlciBhbmQgaWYgc28sCj4+Pj4gaW1wbGVtZW50IHRoZSA2NGIg
bG9naWMuCj4+Pj4KPj4+PiBGaXhlczogODBmMzkzYTIzYmU2ICgiS1ZNOiBhcm0vYXJtNjQ6IFN1
cHBvcnQgY2hhaW5lZCBQTVUgY291bnRlcnMiKQo+Pj4+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVn
ZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPj4+PiAtLS0KPj4+PiDCoHZpcnQva3ZtL2FybS9w
bXUuYyB8IDE2ICsrKysrKysrKysrKysrKy0KPj4+PiDCoDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+Pj4KPj4+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0v
YXJtL3BtdS5jIGIvdmlydC9rdm0vYXJtL3BtdS5jCj4+Pj4gaW5kZXggYzNmOGIwNTk4ODFlLi43
YWI0NzdkYjJmNzUgMTAwNjQ0Cj4+Pj4gLS0tIGEvdmlydC9rdm0vYXJtL3BtdS5jCj4+Pj4gKysr
IGIvdmlydC9rdm0vYXJtL3BtdS5jCj4+Pj4gQEAgLTQ5MSw2ICs0OTEsOCBAQCB2b2lkIGt2bV9w
bXVfc29mdHdhcmVfaW5jcmVtZW50KHN0cnVjdCBrdm1fdmNwdQo+Pj4+ICp2Y3B1LCB1NjQgdmFs
KQo+Pj4+Cj4+Pj4gwqDCoMKgwqAgZW5hYmxlID0gX192Y3B1X3N5c19yZWcodmNwdSwgUE1DTlRF
TlNFVF9FTDApOwo+Pj4+IMKgwqDCoMKgIGZvciAoaSA9IDA7IGkgPCBBUk1WOF9QTVVfQ1lDTEVf
SURYOyBpKyspIHsKPj4+PiArwqDCoMKgwqDCoMKgwqAgYm9vbCBjaGFpbmVkID0gdGVzdF9iaXQo
aSA+PiAxLCB2Y3B1LT5hcmNoLnBtdS5jaGFpbmVkKTsKPj4+PiArCj4+Pgo+Pj4gSSdkIHJhdGhl
ciB5b3UgdXNlIGt2bV9wbXVfcG1jX2lzX2NoYWluZWQoKSByYXRoZXIgdGhhbiBvcGVuLWNvZGlu
Zwo+Pj4gdGhpcy4gQnV0IHNlZSBiZWxvdzoKPj4+Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCBpZiAo
ISh2YWwgJiBCSVQoaSkpKQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsK
Pj4+PiDCoMKgwqDCoMKgwqDCoMKgIHR5cGUgPSBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTUVWVFlQ
RVIwX0VMMCArIGkpCj4+Pj4gQEAgLTUwMCw4ICs1MDIsMjAgQEAgdm9pZCBrdm1fcG11X3NvZnR3
YXJlX2luY3JlbWVudChzdHJ1Y3Qga3ZtX3ZjcHUKPj4+PiAqdmNwdSwgdTY0IHZhbCkKPj4+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVnID0gX192Y3B1X3N5c19yZWcodmNwdSwgUE1FVkNO
VFIwX0VMMCArIGkpICsgMTsKPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVnID0gbG93
ZXJfMzJfYml0cyhyZWcpOwo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX3ZjcHVfc3lz
X3JlZyh2Y3B1LCBQTUVWQ05UUjBfRUwwICsgaSkgPSByZWc7Cj4+Pj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaWYgKCFyZWcpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJlZykg
Lyogbm8gb3ZlcmZsb3cgKi8KPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNv
bnRpbnVlOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChjaGFpbmVkKSB7Cj4+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWcgPSBfX3ZjcHVfc3lzX3JlZyh2Y3B1
LCBQTUVWQ05UUjBfRUwwICsgaSArIDEpICsgMTsKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJlZyA9IGxvd2VyXzMyX2JpdHMocmVnKTsKPj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNRVZDTlRSMF9FTDAgKyBpICsg
MSkgPSByZWc7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmVnKQo+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsKPj4+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIG1hcmsgYW4gb3ZlcmZsb3cgb24g
aGlnaCBjb3VudGVyICovCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX3Zj
cHVfc3lzX3JlZyh2Y3B1LCBQTU9WU1NFVF9FTDApIHw9IEJJVChpICsgMSk7Cj4+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfSBlbHNlIHsKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIC8qIG1hcmsgYW4gb3ZlcmZsb3cgKi8KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTU9WU1NFVF9FTDApIHw9IEJJVChpKTsK
Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCB9Cj4+
Pj4gwqDCoMKgwqAgfQo+Pj4+IMKgfQo+Pj4KPj4+IEkgdGhpbmsgdGhlIHdob2xlIGZ1bmN0aW9u
IGlzIGEgYml0IG9mIGEgbWVzcywgYW5kIGNvdWxkIGJlIGJldHRlcgo+Pj4gc3RydWN0dXJlZCB0
byB0cmVhdCA2NGJpdCBjb3VudGVycyBhcyBhIGZpcnN0IGNsYXNzIGNpdGl6ZW4uCj4+Pgo+Pj4g
SSdtIHN1Z2dlc3Rpbmcgc29tZXRoaW5nIGFsb25nIHRob3NlIGxpbmVzLCB3aGljaCB0cmllcyB0
bwo+Pj4gc3RyZWFtbGluZSB0aGluZ3MgYSBiaXQgYW5kIGtlZXAgdGhlIGZsb3cgdW5pZm9ybSBi
ZXR3ZWVuIHRoZQo+Pj4gdHdvIHdvcmQgc2l6ZXMuIElNSE8sIGl0IGhlbHBzIHJlYXNvbm5pbmcg
YWJvdXQgaXQgYW5kIGdpdmVzCj4+PiBzY29wZSB0byB0aGUgQVJNdjguNSBmdWxsIDY0Yml0IGNv
dW50ZXJzLi4uIEl0IGlzIG9mIGNvdXJzZQo+Pj4gY29tcGxldGVseSB1bnRlc3RlZC4KPj4KPj4g
TG9va3MgT0sgdG8gbWUgYXMgd2VsbC4gT25lIHJlbWFyayB0aG91Z2gsIGRvbid0IHdlIG5lZWQg
dG8gdGVzdCBpZiB0aGUKPj4gbisxdGggcmVnIGlzIGVuYWJsZWQgYmVmb3JlIGluY3JlbWVudGlu
ZyBpdD8KPiAKPiBIbW1tLiBJJ20gbm90IHN1cmUuIEkgdGhpbmsgd2Ugc2hvdWxkIG1ha2Ugc3Vy
ZSB0aGF0IHdlIGRvbid0IGZsYWcKPiBhIGNvdW50ZXIgYXMgYmVpbmcgY2hhaW5lZCBpZiB0aGUg
b2RkIGNvdW50ZXIgaXMgZGlzYWJsZWQsIHJhdGhlcgo+IHRoYW4gY2hlY2tpbmcgaXQgaGVyZS4g
QXMgbG9uZyBhcyB0aGUgb2RkIGNvdW50ZXIgaXMgbm90IGNoYWluZWQKPiAqYW5kKiBlbmFibGVk
LCB3ZSBzaG91bGRuJ3QgdG91Y2ggaXQuPgo+IEFnYWluLCB1bnRlc3RlZDoKPiAKPiBkaWZmIC0t
Z2l0IGEvdmlydC9rdm0vYXJtL3BtdS5jIGIvdmlydC9rdm0vYXJtL3BtdS5jCj4gaW5kZXggY2Yz
NzFmNjQzYWRlLi40NzM2NjgxN2NkMmEgMTAwNjQ0Cj4gLS0tIGEvdmlydC9rdm0vYXJtL3BtdS5j
Cj4gKysrIGIvdmlydC9rdm0vYXJtL3BtdS5jCj4gQEAgLTE1LDYgKzE1LDcgQEAKPiDCoCNpbmNs
dWRlIDxrdm0vYXJtX3ZnaWMuaD4KPiAKPiDCoHN0YXRpYyB2b2lkIGt2bV9wbXVfY3JlYXRlX3Bl
cmZfZXZlbnQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQKPiBzZWxlY3RfaWR4KTsKPiArc3Rh
dGljIHZvaWQga3ZtX3BtdV91cGRhdGVfcG1jX2NoYWluZWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LCB1NjQKPiBzZWxlY3RfaWR4KTsKPiAKPiDCoCNkZWZpbmUgUEVSRl9BVFRSX0NGRzFfS1ZNX1BN
VV9DSEFJTkVEIDB4MQo+IAo+IEBAIC0yOTgsNiArMjk5LDcgQEAgdm9pZCBrdm1fcG11X2VuYWJs
ZV9jb3VudGVyX21hc2soc3RydWN0IGt2bV92Y3B1Cj4gKnZjcHUsIHU2NCB2YWwpCj4gwqDCoMKg
wqDCoMKgwqDCoMKgICogRm9yIGhpZ2ggY291bnRlcnMgb2YgY2hhaW5lZCBldmVudHMgd2UgbXVz
dCByZWNyZWF0ZSB0aGUKPiDCoMKgwqDCoMKgwqDCoMKgwqAgKiBwZXJmIGV2ZW50IHdpdGggdGhl
IGxvbmcgKDY0Yml0KSBhdHRyaWJ1dGUgc2V0Lgo+IMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ICvC
oMKgwqDCoMKgwqDCoCBrdm1fcG11X3VwZGF0ZV9wbWNfY2hhaW5lZCh2Y3B1LCBpKTsKPiDCoMKg
wqDCoMKgwqDCoMKgIGlmIChrdm1fcG11X3BtY19pc19jaGFpbmVkKHBtYykgJiYKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAga3ZtX3BtdV9pZHhfaXNfaGlnaF9jb3VudGVyKGkpKSB7Cj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9wbXVfY3JlYXRlX3BlcmZfZXZlbnQodmNwdSwgaSk7
Cj4gQEAgLTY0NSw3ICs2NDcsOCBAQCBzdGF0aWMgdm9pZCBrdm1fcG11X3VwZGF0ZV9wbWNfY2hh
aW5lZChzdHJ1Y3QKPiBrdm1fdmNwdSAqdmNwdSwgdTY0IHNlbGVjdF9pZHgpCj4gwqDCoMKgwqAg
c3RydWN0IGt2bV9wbXUgKnBtdSA9ICZ2Y3B1LT5hcmNoLnBtdTsKPiDCoMKgwqDCoCBzdHJ1Y3Qg
a3ZtX3BtYyAqcG1jID0gJnBtdS0+cG1jW3NlbGVjdF9pZHhdOwo+IAo+IC3CoMKgwqAgaWYgKGt2
bV9wbXVfaWR4X2hhc19jaGFpbl9ldnR5cGUodmNwdSwgcG1jLT5pZHgpKSB7Cj4gK8KgwqDCoCBp
ZiAoa3ZtX3BtdV9pZHhfaGFzX2NoYWluX2V2dHlwZSh2Y3B1LCBwbWMtPmlkeCkgJiYKPiArwqDC
oMKgwqDCoMKgwqAga3ZtX3BtdV9jb3VudGVyX2lzX2VuYWJsZWQodmNwdSwgcG1jLT5pZHgpKSB7
CgpJbiBjcmVhdGVfcGVyZl9ldmVudCgpLCBoYXNfY2hhaW5fZXZ0eXBlKCkgaXMgdXNlZCBhbmQg
YSA2NGIgc2FtcGxlCnBlcmlvZCB3b3VsZCBiZSBjaG9zZW4gZXZlbiBpZiB0aGUgY291bnRlcnMg
YXJlIGRpc2pvaW5lZCAoc2luY2UgdGhlIG9kZAppcyBkaXNhYmxlZCkuIFdlIHdvdWxkIG5lZWQg
dG8gdXNlIHBtY19pc19jaGFpbmVkKCkgaW5zdGVhZC4KCldpdGggcGVyZl9ldmVudHMsIHRoZSBj
aGVjayBvZiB3aGV0aGVyIHRoZSBvZGQgcmVnaXN0ZXIgaXMgZW5hYmxlZCBpcwpwcm9wZXJseSBk
b25lIChjcmVhdGVfcGVyZl9ldmVudCkuIFRoZW4gSSB1bmRlcnN0YW5kIHdoZW5ldmVyIHRoZXJl
IGlzIGEKY2hhbmdlIGluIGVuYWJsZSBzdGF0ZSBvciB0eXBlIHdlIGRlbGV0ZSB0aGUgcHJldmlv
dXMgcGVyZiBldmVudCBhbmQKcmUtY3JlYXRlIGEgbmV3IG9uZS4gRW5hYmxlIHN0YXRlIGNoZWNr
IGp1c3QgaXMgbWlzc2luZyBmb3IgU1dfSU5DUi4KClNvbWUgb3RoZXIgcXVlc3Rpb25zOgotIGRv
IHdlIG5lZWQgYSBwZXJmIGV2ZW50IHRvIGJlIGNyZWF0ZWQgZXZlbiBpZiB0aGUgY291bnRlciBp
cyBub3QKZW5hYmxlZD8gRm9yIGluc3RhbmNlIG9uIGNvdW50ZXIgcmVzZXRzLCBjcmVhdGVfcGVy
Zl9ldmVudHMgZ2V0IGNhbGxlZC4KLSBhbHNvIGFjdGlvbnMgYXJlIG1hZGUgZm9yIGNvdW50ZXJz
IHdoaWNoIGFyZSBub3QgaW1wbGVtZW50ZWQuIGxvb3AKdW50aWwgQVJNVjhfUE1VX01BWF9DT1VO
VEVSUy4gRG8geW91IHRoaW5rIGl0IGlzIHZhbHVhYmxlIHRvIGhhdmUgYQpiaXRtYXNrIG9mIHN1
cHBvcnRlZCBjb3VudGVycyBzdG9yZWQgYmVmb3JlIHBtdSByZWFkaW5lc3M/CkkgY2FuIHByb3Bv
c2Ugc3VjaCBjaGFuZ2VzIGlmIHlvdSB0aGluayB0aGV5IGFyZSB2YWx1YWJsZS4KClRoYW5rcwoK
RXJpYwoKPiDCoMKgwqDCoMKgwqDCoMKgIC8qCj4gwqDCoMKgwqDCoMKgwqDCoMKgICogRHVyaW5n
IHByb21vdGlvbiBmcm9tICFjaGFpbmVkIHRvIGNoYWluZWQgd2UgbXVzdCBlbnN1cmUKPiDCoMKg
wqDCoMKgwqDCoMKgwqAgKiB0aGUgYWRqYWNlbnQgY291bnRlciBpcyBzdG9wcGVkIGFuZCBpdHMg
ZXZlbnQgZGVzdHJveWVkCj4gCj4gV2hhdCBkbyB5b3UgdGhpbms/Cj4gCj4gwqDCoMKgwqDCoMKg
wqAgTS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
