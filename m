Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22851C43331
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 21:14:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB5FB21925
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 21:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eUn8XzIw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB5FB21925
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2966B4B1B1;
	Tue, 12 Nov 2019 16:14:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kwmlXA+khvCX; Tue, 12 Nov 2019 16:14:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EED424B193;
	Tue, 12 Nov 2019 16:14:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72AA64B18E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 16:14:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ifBAb1SYmXNs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 16:14:23 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B264B178
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 16:14:23 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1573593263;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0bsLDLGgwqWjvPt7yk6eXjGQ2Ee83dUoAWlp33AQHXo=;
 b=eUn8XzIwXcI5e/lIB4FRqsmHwNyu9Vkhp2fCd1jxDhm/nMwg55msCg8EfBhr+UOhysYbnM
 PrnUD+BT3U1kIZ1GrXKTO0v7pBubChDIjfPaUb0nUEnlQCmxsaDXjMwaTq3mwjgKjfXimE
 Ug+xcPRd15FccEd8gsj8w+Tj7ZIT0Ow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-HqlNN2b1Nw-sGxj_LfAFhQ-1; Tue, 12 Nov 2019 16:14:21 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 785019266C;
 Tue, 12 Nov 2019 21:14:19 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2278B6018B;
 Tue, 12 Nov 2019 21:14:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 04/17] arm: gic: Support no IRQs test case
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Andrew Jones <drjones@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-5-andre.przywara@arm.com>
 <db89b983-425c-8b45-3f26-1a33b9817836@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a8546125-1d41-559b-1085-9289868ad009@redhat.com>
Date: Tue, 12 Nov 2019 22:14:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <db89b983-425c-8b45-3f26-1a33b9817836@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: HqlNN2b1Nw-sGxj_LfAFhQ-1
X-Mimecast-Spam-Score: 0
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

SGksCgpPbiAxMS8xMi8xOSAyOjI2IFBNLCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+IEhpLAo+
IAo+IE9uIDExLzgvMTkgMjo0MiBQTSwgQW5kcmUgUHJ6eXdhcmEgd3JvdGU6Cj4+IEZvciBzb21l
IHRlc3RzIGl0IHdvdWxkIGJlIGltcG9ydGFudCB0byBjaGVjayB0aGF0IGFuIElSUSB3YXMgKm5v
dCoKPj4gdHJpZ2dlcmVkLCBmb3IgaW5zdGFuY2UgdG8gdGVzdCBjZXJ0YWluIG1hc2tpbmcgb3Bl
cmF0aW9ucy4KPj4KPj4gRXh0ZW5kIHRoZSBjaGVja19hZGRlZCgpIGZ1bmN0aW9uIHRvIHJlY29n
bmlzZSBhbiBlbXB0eSBjcHVtYXNrIHRvCj4+IGRldGVjdCB0aGlzIHNpdHVhdGlvbi4gVGhlIHRp
bWVvdXQgZHVyYXRpb24gaXMgcmVkdWNlZCwgYW5kIHRoZSAibm8gSVJRcwo+IAo+IFdoeSBpcyB0
aGUgdGltZW91dCBkdXJhdGlvbiByZWR1Y2VkPwo+IAo+PiB0cmlnZ2VyZWQiIGNhc2UgaXMgYWN0
dWFsbHkgcmVwb3J0ZWQgYXMgYSBzdWNjZXNzIGluIHRoaXMgY2FzZS4KPj4KPj4gU2lnbmVkLW9m
Zi1ieTogQW5kcmUgUHJ6eXdhcmEgPGFuZHJlLnByenl3YXJhQGFybS5jb20+Cj4+IC0tLQo+PiAg
YXJtL2dpYy5jIHwgMTAgKysrKysrKystLQo+PiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2FybS9naWMuYyBiL2FybS9n
aWMuYwo+PiBpbmRleCBhMTE0MDA5Li5lY2E5MTg4IDEwMDY0NAo+PiAtLS0gYS9hcm0vZ2ljLmMK
Pj4gKysrIGIvYXJtL2dpYy5jCj4+IEBAIC02Niw5ICs2NiwxMCBAQCBzdGF0aWMgdm9pZCBjaGVj
a19hY2tlZChjb25zdCBjaGFyICp0ZXN0bmFtZSwgY3B1bWFza190ICptYXNrKQo+PiAgCWludCBt
aXNzaW5nID0gMCwgZXh0cmEgPSAwLCB1bmV4cGVjdGVkID0gMDsKPj4gIAlpbnQgbnJfcGFzcywg
Y3B1LCBpOwo+PiAgCWJvb2wgYmFkID0gZmFsc2U7Cj4+ICsJYm9vbCBub2lycXMgPSBjcHVtYXNr
X2VtcHR5KG1hc2spOwo+PiAgCj4+ICAJLyogV2FpdCB1cCB0byA1cyBmb3IgYWxsIGludGVycnVw
dHMgdG8gYmUgZGVsaXZlcmVkICovCj4gCj4gVGhpcyBjb21tZW50IG5lZWRzIHVwZGF0aW5nLgo+
IAo+PiAtCWZvciAoaSA9IDA7IGkgPCA1MDsgKytpKSB7Cj4+ICsJZm9yIChpID0gMDsgaSA8IChu
b2lycXMgPyAxNSA6IDUwKTsgKytpKSB7Cj4+ICAJCW1kZWxheSgxMDApOwo+PiAgCQlucl9wYXNz
ID0gMDsKPj4gIAkJZm9yX2VhY2hfcHJlc2VudF9jcHUoY3B1KSB7Cj4+IEBAIC04OCw3ICs4OSw3
IEBAIHN0YXRpYyB2b2lkIGNoZWNrX2Fja2VkKGNvbnN0IGNoYXIgKnRlc3RuYW1lLCBjcHVtYXNr
X3QgKm1hc2spCj4+ICAJCQkJYmFkID0gdHJ1ZTsKPj4gIAkJCX0KPj4gIAkJfQo+PiAtCQlpZiAo
bnJfcGFzcyA9PSBucl9jcHVzKSB7Cj4+ICsJCWlmICghbm9pcnFzICYmIG5yX3Bhc3MgPT0gbnJf
Y3B1cykgewo+IAo+IFRoaXMgY29uZGl0aW9uIGlzIHByZXR0eSBoYXJkIHRvIHJlYWQgLSB3aGF0
IHlvdSBhcmUgZG9pbmcgaGVyZSBpcyBtYWtpbmcgc3VyZQo+IHRoYXQgd2hlbiBjaGVja19hY2tl
ZCB0ZXN0cyB0aGF0IG5vIGlycXMgaGF2ZSBiZWVuIHJlY2VpdmVkLCB5b3UgZG8gdGhlIGVudGly
ZSBmb3IKPiBsb29wIGFuZCB3YWl0IHRoZSBlbnRpcmUgdGltZW91dCBkdXJhdGlvbi4gRGlkIEkg
Z2V0IHRoYXQgcmlnaHQ/Cj4gCj4gSG93IGFib3V0IHRoaXMgKGNvbXBpbGUgdGVzdGVkIG9ubHkp
Ogo+IAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChub2lycXMpCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIFdhaXQgZm9yIHRoZSBl
bnRpcmUgdGltZW91dCBkdXJhdGlvbi4gKi8KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7Cj4gKwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAobnJfcGFzcyA9PSBucl9jcHVzKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXBvcnQoIiVzIiwgIWJhZCwgdGVzdG5hbWUpOwo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGkpCj4g
Cj4+ICAJCQlyZXBvcnQoIiVzIiwgIWJhZCwgdGVzdG5hbWUpOwo+PiAgCQkJaWYgKGk+PiAgCQkJ
CXJlcG9ydF9pbmZvKCJ0b29rIG1vcmUgdGhhbiAlZCBtcyIsIGkgKiAxMDApOwo+PiBAQCAtOTYs
NiArOTcsMTEgQEAgc3RhdGljIHZvaWQgY2hlY2tfYWNrZWQoY29uc3QgY2hhciAqdGVzdG5hbWUs
IGNwdW1hc2tfdCAqbWFzaykKPj4gIAkJfQo+PiAgCX0KPj4gIAo+PiArCWlmIChub2lycXMgJiYg
bnJfcGFzcyA9PSBucl9jcHVzKSB7Cj4+ICsJCXJlcG9ydCgiJXMiLCAhYmFkLCB0ZXN0bmFtZSk7
CgpUaGlzIG9uZSBsb29rcyBhdCB0aGUgcmVzdWx0IG9mIHRoZSBsYXN0IGl0ZXJhdGlvbiAob24g
dGltZW91dCkuCgpJbiBjYXNlIG9mIG5vaXJxcyBJIHRoaW5rIHdlIHNob3VsZCBiZSBhYmxlIHRv
IHJldHVybiBhIGZhaWx1cmUgYXMgc29vbgphcyBhbiBpcnEgaXMgZGV0ZWN0ZWQgd2hlcmUgd2Ug
ZG8gbm90IGV4cGVjdCBpdCwgd2l0aG91dCB3YWl0aW5nIGZvciB0aGUKZnVsbCBkZWxheT8KClRo
YW5rcwoKRXJpYwo+IAo+IGJhZCBpcyB0cnVlIG9ubHkgd2hlbiBiYWRfc2VuZGVyW2NwdV0gIT0g
LTEgb3IgYmFkX2lycVtjcHVdICE9IC0xLCB3aGljaCBvbmx5IGdldAo+IHNldCBpbiB0aGUgaXJx
IG9yIGlwaSBoYW5kbGVzciwgbWVhbmluZyB3aGVuIHlvdSBkbyBnZXQgYW4gaW50ZXJydXB0LiBJ
ZiBucl9wYXNzCj4gPT0gbnJfY3B1cyBhbmQgbm9pcnFzLCB0aGVuIHlvdSBzaG91bGRuJ3QgaGF2
ZSBnb3R0ZW4gYW4gaW50ZXJydXB0LiBJIHRoaW5rIGl0J3MKPiBzYWZlIHRvIHdyaXRlIGl0IGFz
IHJlcG9ydCgiJXMiLCB0cnVlLCB0ZXN0bmFtZSkuIEkgdGhpbmsgYSBzaG9ydCBjb21tZW50IGFi
b3ZlCj4gZXhwbGFpbmluZyB3aHkgd2UgZG8gdGhpcyBjaGVjayAodGltZW91dCBleHBpcmVkIGFu
ZCB3ZSBoYXZlbid0IGdvdHRlbiBhbnkKPiBpbnRlcnJ1cHRzKSB3b3VsZCBhbHNvIGltcHJvdmUg
cmVhZGFiaWxpdHkgb2YgdGhlIGNvZGUsIGJ1dCB0aGF0J3MgdXAgdG8geW91Lgo+IAo+IFRoYW5r
cywKPiBBbGV4Cj4+ICsJCXJldHVybjsKPj4gKwl9Cj4+ICsKPj4gIAlmb3JfZWFjaF9wcmVzZW50
X2NwdShjcHUpIHsKPj4gIAkJaWYgKGNwdW1hc2tfdGVzdF9jcHUoY3B1LCBtYXNrKSkgewo+PiAg
CQkJaWYgKCFhY2tlZFtjcHVdKQo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCj4ga3ZtYXJtIG1haWxpbmcgbGlzdAo+IGt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKPiBodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
