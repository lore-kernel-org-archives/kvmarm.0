Return-Path: <SRS0=0kEf=Z3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2E1C43603
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 14:07:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C15182245C
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 14:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OZe3B9to"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C15182245C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D7C54A51F;
	Thu,  5 Dec 2019 09:07:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mYXAJmIFqBwH; Thu,  5 Dec 2019 09:07:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F25C34AE94;
	Thu,  5 Dec 2019 09:07:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 903464AC07
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 09:07:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ogNftdNXB2Ds for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Dec 2019 09:07:04 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47B5D4A51F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 09:07:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575554824;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=azQp6+u/OaRhFbUGciXV+zkPwn2tSlr6PlcS27y4L7s=;
 b=OZe3B9toYevgyFIwAOhKVxqj+toBOcATb4BUNxYMCCG/LDhEt9p74D5ksQObQISlnkhTvb
 OhWc+4FsyzH/KQEnLzKTC0GhG2QHB6riHJxkgNT3DJbxoVZH82EWMZqj9FAexTeD3TC52V
 VtthKD9CLcPa+UJVuE01sCviC/feFNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-McVFv0HuOfSqDAGpiofMiA-1; Thu, 05 Dec 2019 09:07:00 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A455A593D7;
 Thu,  5 Dec 2019 14:06:58 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FE566012E;
 Thu,  5 Dec 2019 14:06:56 +0000 (UTC)
Subject: Re: [RFC 2/3] KVM: arm64: pmu: Fix chained SW_INCR counters
To: Marc Zyngier <maz@kernel.org>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-3-eric.auger@redhat.com>
 <561ac6df385e977cc51d51a8ab28ee49@www.loen.fr>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <2b30c1ca-3bc0-9f73-4bea-ee42bb74cbac@redhat.com>
Date: Thu, 5 Dec 2019 15:06:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <561ac6df385e977cc51d51a8ab28ee49@www.loen.fr>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: McVFv0HuOfSqDAGpiofMiA-1
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

SGkgTWFyYywKCk9uIDEyLzUvMTkgMTA6NDMgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSBF
cmljLAo+IAo+IE9uIDIwMTktMTItMDQgMjA6NDQsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+IEF0IHRo
ZSBtb21lbnQgYSBTV19JTkNSIGNvdW50ZXIgYWx3YXlzIG92ZXJmbG93cyBvbiAzMi1iaXQKPj4g
Ym91bmRhcnksIGluZGVwZW5kZW50bHkgb24gd2hldGhlciB0aGUgbisxdGggY291bnRlciBpcwo+
PiBwcm9ncmFtbWVkIGFzIENIQUlOLgo+Pgo+PiBDaGVjayB3aGV0aGVyIHRoZSBTV19JTkNSIGNv
dW50ZXIgaXMgYSA2NGIgY291bnRlciBhbmQgaWYgc28sCj4+IGltcGxlbWVudCB0aGUgNjRiIGxv
Z2ljLgo+Pgo+PiBGaXhlczogODBmMzkzYTIzYmU2ICgiS1ZNOiBhcm0vYXJtNjQ6IFN1cHBvcnQg
Y2hhaW5lZCBQTVUgY291bnRlcnMiKQo+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmlj
LmF1Z2VyQHJlZGhhdC5jb20+Cj4+IC0tLQo+PiDCoHZpcnQva3ZtL2FybS9wbXUuYyB8IDE2ICsr
KysrKysrKysrKysrKy0KPj4gwqAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3BtdS5jIGIvdmlydC9r
dm0vYXJtL3BtdS5jCj4+IGluZGV4IGMzZjhiMDU5ODgxZS4uN2FiNDc3ZGIyZjc1IDEwMDY0NAo+
PiAtLS0gYS92aXJ0L2t2bS9hcm0vcG11LmMKPj4gKysrIGIvdmlydC9rdm0vYXJtL3BtdS5jCj4+
IEBAIC00OTEsNiArNDkxLDggQEAgdm9pZCBrdm1fcG11X3NvZnR3YXJlX2luY3JlbWVudChzdHJ1
Y3Qga3ZtX3ZjcHUKPj4gKnZjcHUsIHU2NCB2YWwpCj4+Cj4+IMKgwqDCoMKgIGVuYWJsZSA9IF9f
dmNwdV9zeXNfcmVnKHZjcHUsIFBNQ05URU5TRVRfRUwwKTsKPj4gwqDCoMKgwqAgZm9yIChpID0g
MDsgaSA8IEFSTVY4X1BNVV9DWUNMRV9JRFg7IGkrKykgewo+PiArwqDCoMKgwqDCoMKgwqAgYm9v
bCBjaGFpbmVkID0gdGVzdF9iaXQoaSA+PiAxLCB2Y3B1LT5hcmNoLnBtdS5jaGFpbmVkKTsKPj4g
Kwo+IAo+IEknZCByYXRoZXIgeW91IHVzZSBrdm1fcG11X3BtY19pc19jaGFpbmVkKCkgcmF0aGVy
IHRoYW4gb3Blbi1jb2RpbmcKPiB0aGlzLiBCdXQgc2VlIGJlbG93Ogo+IAo+PiDCoMKgwqDCoMKg
wqDCoMKgIGlmICghKHZhbCAmIEJJVChpKSkpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBj
b250aW51ZTsKPj4gwqDCoMKgwqDCoMKgwqDCoCB0eXBlID0gX192Y3B1X3N5c19yZWcodmNwdSwg
UE1FVlRZUEVSMF9FTDAgKyBpKQo+PiBAQCAtNTAwLDggKzUwMiwyMCBAQCB2b2lkIGt2bV9wbXVf
c29mdHdhcmVfaW5jcmVtZW50KHN0cnVjdCBrdm1fdmNwdQo+PiAqdmNwdSwgdTY0IHZhbCkKPj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlZyA9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNRVZD
TlRSMF9FTDAgKyBpKSArIDE7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWcgPSBsb3dl
cl8zMl9iaXRzKHJlZyk7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX3ZjcHVfc3lzX3Jl
Zyh2Y3B1LCBQTUVWQ05UUjBfRUwwICsgaSkgPSByZWc7Cj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGlmICghcmVnKQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmVnKSAvKiBubyBv
dmVyZmxvdyAqLwo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoY2hhaW5lZCkgewo+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHJlZyA9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNRVZDTlRSMF9F
TDAgKyBpICsgMSkgKyAxOwo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlZyA9
IGxvd2VyXzMyX2JpdHMocmVnKTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBf
X3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTUVWQ05UUjBfRUwwICsgaSArIDEpID0gcmVnOwo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChyZWcpCj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAvKiBtYXJrIGFuIG92ZXJmbG93IG9uIGhpZ2ggY291bnRlciAqLwo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNT1ZTU0VU
X0VMMCkgfD0gQklUKGkgKyAxKTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfSBlbHNlIHsK
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBtYXJrIGFuIG92ZXJmbG93ICov
Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUs
IFBNT1ZTU0VUX0VMMCkgfD0gQklUKGkpOwo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4+
IMKgwqDCoMKgwqDCoMKgwqAgfQo+PiDCoMKgwqDCoCB9Cj4+IMKgfQo+IAo+IEkgdGhpbmsgdGhl
IHdob2xlIGZ1bmN0aW9uIGlzIGEgYml0IG9mIGEgbWVzcywgYW5kIGNvdWxkIGJlIGJldHRlcgo+
IHN0cnVjdHVyZWQgdG8gdHJlYXQgNjRiaXQgY291bnRlcnMgYXMgYSBmaXJzdCBjbGFzcyBjaXRp
emVuLgo+IAo+IEknbSBzdWdnZXN0aW5nIHNvbWV0aGluZyBhbG9uZyB0aG9zZSBsaW5lcywgd2hp
Y2ggdHJpZXMgdG8KPiBzdHJlYW1saW5lIHRoaW5ncyBhIGJpdCBhbmQga2VlcCB0aGUgZmxvdyB1
bmlmb3JtIGJldHdlZW4gdGhlCj4gdHdvIHdvcmQgc2l6ZXMuIElNSE8sIGl0IGhlbHBzIHJlYXNv
bm5pbmcgYWJvdXQgaXQgYW5kIGdpdmVzCj4gc2NvcGUgdG8gdGhlIEFSTXY4LjUgZnVsbCA2NGJp
dCBjb3VudGVycy4uLiBJdCBpcyBvZiBjb3Vyc2UKPiBjb21wbGV0ZWx5IHVudGVzdGVkLgoKTG9v
a3MgT0sgdG8gbWUgYXMgd2VsbC4gT25lIHJlbWFyayB0aG91Z2gsIGRvbid0IHdlIG5lZWQgdG8g
dGVzdCBpZiB0aGUKbisxdGggcmVnIGlzIGVuYWJsZWQgYmVmb3JlIGluY3JlbWVudGluZyBpdD8K
ClRoYW5rcwoKRXJpYwo+IAo+IFRob3VnaHRzPwo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCj4gCj4g
ZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9wbXUuYyBiL3ZpcnQva3ZtL2FybS9wbXUuYwo+IGlu
ZGV4IDg3MzFkZmVjZWQ4Yi4uY2YzNzFmNjQzYWRlIDEwMDY0NAo+IC0tLSBhL3ZpcnQva3ZtL2Fy
bS9wbXUuYwo+ICsrKyBiL3ZpcnQva3ZtL2FybS9wbXUuYwo+IEBAIC00ODAsMjYgKzQ4MCw0MyBA
QCBzdGF0aWMgdm9pZCBrdm1fcG11X3BlcmZfb3ZlcmZsb3coc3RydWN0Cj4gcGVyZl9ldmVudCAq
cGVyZl9ldmVudCwKPiDCoCAqLwo+IMKgdm9pZCBrdm1fcG11X3NvZnR3YXJlX2luY3JlbWVudChz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB2YWwpCj4gwqB7Cj4gK8KgwqDCoCBzdHJ1Y3Qga3Zt
X3BtdSAqcG11ID0gJnZjcHUtPmFyY2gucG11Owo+IMKgwqDCoMKgIGludCBpOwo+IC3CoMKgwqAg
dTY0IHR5cGUsIGVuYWJsZSwgcmVnOwo+IAo+IC3CoMKgwqAgaWYgKHZhbCA9PSAwKQo+IC3CoMKg
wqDCoMKgwqDCoCByZXR1cm47Cj4gK8KgwqDCoCAvKiBXZWVkIG91dCBkaXNhYmxlZCBjb3VudGVy
cyAqLwo+ICvCoMKgwqAgdmFsICY9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNQ05URU5TRVRfRUww
KTsKPiAKPiAtwqDCoMKgIGVuYWJsZSA9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNQ05URU5TRVRf
RUwwKTsKPiDCoMKgwqDCoCBmb3IgKGkgPSAwOyBpIDwgQVJNVjhfUE1VX0NZQ0xFX0lEWDsgaSsr
KSB7Cj4gK8KgwqDCoMKgwqDCoMKgIHU2NCB0eXBlLCByZWc7Cj4gK8KgwqDCoMKgwqDCoMKgIGlu
dCBvdnMgPSBpOwo+ICsKPiDCoMKgwqDCoMKgwqDCoMKgIGlmICghKHZhbCAmIEJJVChpKSkpCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+IC3CoMKgwqDCoMKgwqDCoCB0eXBl
ID0gX192Y3B1X3N5c19yZWcodmNwdSwgUE1FVlRZUEVSMF9FTDAgKyBpKQo+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgICYgQVJNVjhfUE1VX0VWVFlQRV9FVkVOVDsKPiAtwqDCoMKgwqDC
oMKgwqAgaWYgKCh0eXBlID09IEFSTVY4X1BNVVYzX1BFUkZDVFJfU1dfSU5DUikKPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAmJiAoZW5hYmxlICYgQklUKGkpKSkgewo+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJlZyA9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNRVZDTlRSMF9FTDAgKyBpKSAr
IDE7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVnID0gbG93ZXJfMzJfYml0cyhyZWcpOwo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNRVZDTlRSMF9F
TDAgKyBpKSA9IHJlZzsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIXJlZykKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNT1ZTU0VU
X0VMMCkgfD0gQklUKGkpOwo+ICsKPiArwqDCoMKgwqDCoMKgwqAgLyogUE1TV0lOQyBvbmx5IGFw
cGxpZXMgdG8gLi4uIFNXX0lOQyEgKi8KPiArwqDCoMKgwqDCoMKgwqAgdHlwZSA9IF9fdmNwdV9z
eXNfcmVnKHZjcHUsIFBNRVZUWVBFUjBfRUwwICsgaSk7Cj4gK8KgwqDCoMKgwqDCoMKgIHR5cGUg
Jj0gQVJNVjhfUE1VX0VWVFlQRV9FVkVOVDsKPiArwqDCoMKgwqDCoMKgwqAgaWYgKHR5cGUgIT0g
QVJNVjhfUE1VVjNfUEVSRkNUUl9TV19JTkNSKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNv
bnRpbnVlOwo+ICsKPiArwqDCoMKgwqDCoMKgwqAgLyogUG90ZW50aWFsIDY0Yml0IHZhbHVlICov
Cj4gK8KgwqDCoMKgwqDCoMKgIHJlZyA9IGt2bV9wbXVfZ2V0X2NvdW50ZXJfdmFsdWUodmNwdSwg
aSkgKyAxOwo+ICsKPiArwqDCoMKgwqDCoMKgwqAgLyogU3RhcnQgYnkgd3JpdGluZyBiYWNrIHRo
ZSBsb3cgMzJiaXRzICovCj4gK8KgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBN
RVZDTlRSMF9FTDAgKyBpKSA9IGxvd2VyXzMyX2JpdHMocmVnKTsKPiArCj4gK8KgwqDCoMKgwqDC
oMKgIC8qCj4gK8KgwqDCoMKgwqDCoMKgwqAgKiA2NGJpdCBjb3VudGVyPyBXcml0ZSBiYWNrIHRo
ZSB1cHBlciBiaXRzIGFuZCB0YXJnZXQKPiArwqDCoMKgwqDCoMKgwqDCoCAqIHRoZSBvdmVyZmxv
dyBiaXQgYXQgdGhlIG5leHQgY291bnRlcgo+ICvCoMKgwqDCoMKgwqDCoMKgICovCj4gK8KgwqDC
oMKgwqDCoMKgIGlmIChrdm1fcG11X3BtY19pc19jaGFpbmVkKCZwbXUtPnBtY1tpXSkpIHsKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWcgPSB1cHBlcl8zMl9iaXRzKHJlZyk7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgX192Y3B1X3N5c19yZWcodmNwdSwgUE1FVkNOVFIwX0VMMCArIGkg
KyAxKSA9IHJlZzsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBvdnMrKzsKPiDCoMKgwqDCoMKg
wqDCoMKgIH0KPiArCj4gK8KgwqDCoMKgwqDCoMKgIGlmICghbG93ZXJfMzJfYml0cyhyZWcpKQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNT1ZTU0VUX0VM
MCkgfD0gQklUKG92cyk7Cj4gwqDCoMKgwqAgfQo+IMKgfQo+IAo+IAoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
