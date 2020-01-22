Return-Path: <SRS0=OV02=3L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E6BC2D0DB
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 15:23:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 55CC421835
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 15:23:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JwTI5lg6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55CC421835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCE134AEA0;
	Wed, 22 Jan 2020 10:23:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bRlqBcCzDjcK; Wed, 22 Jan 2020 10:23:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F46E4AEC0;
	Wed, 22 Jan 2020 10:23:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 728554AEA0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jan 2020 10:23:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NIErs9GHHf4W for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jan 2020 10:23:01 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22C834A522
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jan 2020 10:23:01 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D22252071E;
 Wed, 22 Jan 2020 15:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579706580;
 bh=I6Fm8pRywuvXE5eAUkUFAQZAHyzekaXyAPBr1svSKo8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=JwTI5lg67kVcQZIQcX7ngbpqPVDrnWFO32tRtNk66TifmLRWur2b1K1wjX+ROG3X0
 XB30G7TCO7UebtCILqcyhNb14J2XasD7fQ/G27ccRi73U6HXREZSbiH9YsNPJiQ8dU
 m4lf4upiI6ZYcecFKp26B20XROJqHXZFQN7U8/6U=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1iuHqM-000m1N-1z; Wed, 22 Jan 2020 15:22:58 +0000
MIME-Version: 1.0
Date: Wed, 22 Jan 2020 15:22:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] irqchip/gic-v3-its: Don't confuse get_vlpi_map() by
 writing DB config
In-Reply-To: <06a484bd-4f46-6884-1bee-9b7b65fd0856@huawei.com>
References: <20200122085609.658-1-yuzenghui@huawei.com>
 <4aaaad3ae7367c5c932c430e18550d9e@kernel.org>
 <06a484bd-4f46-6884-1bee-9b7b65fd0856@huawei.com>
Message-ID: <b447c84c609e9799bbac6aada2ffb9ce@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, jason@lakedaemon.net,
 wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: tglx@linutronix.de, kvmarm@lists.cs.columbia.edu, jason@lakedaemon.net,
 linux-kernel@vger.kernel.org
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

T24gMjAyMC0wMS0yMiAxMToyOSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBNYXJjLAo+IAo+IE9u
IDIwMjAvMS8yMiAxODo0NCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBIaSBaZW5naHVpLAo+PiAK
Pj4gVGhhbmtzIGZvciB0aGlzLgo+PiAKPj4gT24gMjAyMC0wMS0yMiAwODo1NiwgWmVuZ2h1aSBZ
dSB3cm90ZToKPj4+IFdoZW4gd2UncmUgd3JpdGluZyBjb25maWcgZm9yIHRoZSBkb29yYmVsbCBp
bnRlcnJ1cHQsIGdldF92bHBpX21hcCgpIAo+Pj4gd2lsbAo+Pj4gZ2V0IGNvbmZ1c2VkIGJ5IGRv
b3JiZWxsJ3MgZC0+cGFyZW50X2RhdGEgaGFjayBhbmQgZmluZCB0aGUgd3JvbmcgCj4+PiBpdHNf
ZGV2Cj4+PiBhcyBjaGlwIGRhdGEgYW5kIHRoZSB3cm9uZyBldmVudC4KPj4+IAo+Pj4gRml4IHRo
aXMgaXNzdWUgYnkgbWFraW5nIHN1cmUgbm8gZG9vcmJlbGxzIHdpbGwgYmUgaW52b2x2ZWQgYmVm
b3JlIAo+Pj4gaW52b2tpbmcKPj4+IGdldF92bHBpX21hcCgpLCB3aGljaCByZXN0b3JlIHNvbWUg
b2YgdGhlIGxvZ2ljIGluIAo+Pj4gbHBpX3dyaXRlX2NvbmZpZygpLgo+Pj4gCj4+PiBGaXhlczog
YzFkNGQ1Y2QyMDNjICgiaXJxY2hpcC9naWMtdjMtaXRzOiBBZGQgaXRzX3ZscGlfbWFwIGhlbHBl
cnMiKQo+Pj4gU2lnbmVkLW9mZi1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+
Cj4+PiAtLS0KPj4+IAo+Pj4gVGhpcyBpcyBiYXNlZCBvbiBtYWlubGluZSBhbmQgY2FuJ3QgYmUg
ZGlyZWN0bHkgYXBwbGllZCB0byB0aGUgCj4+PiBjdXJyZW50Cj4+PiBpcnFjaGlwLW5leHQuCj4+
PiAKPj4+IMKgZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMgfCA1ICsrKy0tCj4+PiDC
oDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+PiAKPj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYyAKPj4+IGIvZHJp
dmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMKPj4+IGluZGV4IGUwNTY3M2JjZDUyYi4uY2M4
YTRmY2JkNmQ2IDEwMDY0NAo+Pj4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRz
LmMKPj4+ICsrKyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jCj4+PiBAQCAtMTE4
MSwxMiArMTE4MSwxMyBAQCBzdGF0aWMgc3RydWN0IGl0c192bHBpX21hcAo+Pj4gKmdldF92bHBp
X21hcChzdHJ1Y3QgaXJxX2RhdGEgKmQpCj4+PiAKPj4+IMKgc3RhdGljIHZvaWQgbHBpX3dyaXRl
X2NvbmZpZyhzdHJ1Y3QgaXJxX2RhdGEgKmQsIHU4IGNsciwgdTggc2V0KQo+Pj4gwqB7Cj4+PiAt
wqDCoMKgIHN0cnVjdCBpdHNfdmxwaV9tYXAgKm1hcCA9IGdldF92bHBpX21hcChkKTsKPj4+IMKg
wqDCoMKgIGlycV9od19udW1iZXJfdCBod2lycTsKPj4+IMKgwqDCoMKgIHZvaWQgKnZhOwo+Pj4g
wqDCoMKgwqAgdTggKmNmZzsKPj4+IAo+Pj4gLcKgwqDCoCBpZiAobWFwKSB7Cj4+PiArwqDCoMKg
IGlmIChpcnFkX2lzX2ZvcndhcmRlZF90b192Y3B1KGQpKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqAg
c3RydWN0IGl0c192bHBpX21hcCAqbWFwID0gZ2V0X3ZscGlfbWFwKGQpOwo+Pj4gKwo+Pj4gwqDC
oMKgwqDCoMKgwqDCoCB2YSA9IHBhZ2VfYWRkcmVzcyhtYXAtPnZtLT52cHJvcF9wYWdlKTsKPj4+
IMKgwqDCoMKgwqDCoMKgwqAgaHdpcnEgPSBtYXAtPnZpbnRpZDsKPj4gCj4+IFNob3VsZG4ndCB3
ZSBmaXggZ2V0X3ZscGlfbWFwKCkgaW5zdGVhZD8gU29tZXRoaW5nIGxpa2UgKHVudGVzdGVkKToK
Pj4gCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYyAKPj4g
Yi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYwo+PiBpbmRleCBlMDU2NzNiY2Q1MmIu
LmI3MDQyMTQzOTBjMCAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMt
aXRzLmMKPj4gKysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMKPj4gQEAgLTEx
NzAsMTMgKzExNzAsMTQgQEAgc3RhdGljIHZvaWQgaXRzX3NlbmRfdmNsZWFyKHN0cnVjdCBpdHNf
ZGV2aWNlIAo+PiAqZGV2LCB1MzIgZXZlbnRfaWQpCj4+ICDCoCAqLwo+PiAgwqBzdGF0aWMgc3Ry
dWN0IGl0c192bHBpX21hcCAqZ2V0X3ZscGlfbWFwKHN0cnVjdCBpcnFfZGF0YSAqZCkKPj4gIMKg
ewo+PiAtwqDCoMKgIHN0cnVjdCBpdHNfZGV2aWNlICppdHNfZGV2ID0gaXJxX2RhdGFfZ2V0X2ly
cV9jaGlwX2RhdGEoZCk7Cj4+IC3CoMKgwqAgdTMyIGV2ZW50ID0gaXRzX2dldF9ldmVudF9pZChk
KTsKPj4gK8KgwqDCoCBpZiAoaXJxZF9pc19mb3J3YXJkZWRfdG9fdmNwdShkKSkgewo+PiArwqDC
oMKgwqDCoMKgwqAgc3RydWN0IGl0c19kZXZpY2UgKml0c19kZXYgPSBpcnFfZGF0YV9nZXRfaXJx
X2NoaXBfZGF0YShkKTsKPj4gK8KgwqDCoMKgwqDCoMKgIHUzMiBldmVudCA9IGl0c19nZXRfZXZl
bnRfaWQoZCk7Cj4+IAo+PiAtwqDCoMKgIGlmICghaXJxZF9pc19mb3J3YXJkZWRfdG9fdmNwdShk
KSkKPj4gLcKgwqDCoMKgwqDCoMKgIHJldHVybiBOVUxMOwo+PiArwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIGRldl9ldmVudF90b192bHBpX21hcChpdHNfZGV2LCBldmVudCk7Cj4+ICvCoMKgwqAgfQo+
PiAKPj4gLcKgwqDCoCByZXR1cm4gZGV2X2V2ZW50X3RvX3ZscGlfbWFwKGl0c19kZXYsIGV2ZW50
KTsKPj4gK8KgwqDCoCByZXR1cm4gTlVMTDsKPj4gIMKgfQo+PiAKPj4gIMKgc3RhdGljIHZvaWQg
bHBpX3dyaXRlX2NvbmZpZyhzdHJ1Y3QgaXJxX2RhdGEgKmQsIHU4IGNsciwgdTggc2V0KQo+PiAK
Pj4gCj4+IE9yIGFtIEkgbWlzc2luZyB0aGUgYWN0dWFsIHByb2JsZW0/Cj4gCj4gTm8uIEkgYWxz
byB0aG91Z2h0IGFib3V0IGZpeGluZyB0aGUgaXNzdWUgYnkgdGhpcyB3YXkgYW5kIEknbSBPSyB3
aXRoCj4gYm90aCBhcHByb2FjaGVzLgoKT0ssIHRoYW5rcy4gSSd2ZSBhZGRlZCB0aGlzIHRvIGly
cWNoaXAtbmV4dFsxXSwgYW5kIHJlYmFzZWQgdGhlIHY0LjEKc2VyaWVzIG9uIHRvcCBvZiBpdC4g
VGhhdCB3YXksIHRoZSBmaXggd2lsbCB0cmlja2xlIGRvd24gdG8gc3RhYmxlCndpdGhvdXQgY29u
ZmxpY3RzLgoKSSd2ZSBhbHNvIGdpdmVuIGl0IGEgZ28gb24gRDA1IHdpdGggR0lDdjQgZW5hYmxl
ZCwgYW5kIG5vdGhpbmcgY2F1Z2h0IApmaXJlLgoKICAgICAgICAgTS4KClsxXSAKaHR0cHM6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbWF6L2FybS1wbGF0Zm9ybXMu
Z2l0L2NvbW1pdC8/aD1pcnEvaXJxY2hpcC1uZXh0JmlkPTA5M2JmNDM5ZmVlMGQ0MGFkZTdlMzA5
YzEyODhiNDA5Y2RjM2IzOGYKLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1
bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
