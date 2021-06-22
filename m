Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EEDC2B9F4
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 16:02:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0BD460FE3
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 16:02:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0BD460FE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FD184A023;
	Tue, 22 Jun 2021 12:02:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id US6aurT-EjMH; Tue, 22 Jun 2021 12:02:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEAE349DE3;
	Tue, 22 Jun 2021 12:02:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CABD440CF9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 12:02:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bm-iPF7q7xJA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jun 2021 12:02:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6953E40CC5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 12:02:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDD3B31B;
 Tue, 22 Jun 2021 09:02:28 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6464F3F718;
 Tue, 22 Jun 2021 09:02:27 -0700 (PDT)
Subject: Re: [PATCH v4 0/9] KVM: arm64: Initial host support for the Apple M1
To: Marc Zyngier <maz@kernel.org>
References: <20210601104005.81332-1-maz@kernel.org>
 <9bc0923c-5c3b-eeac-86ee-c3234c486955@arm.com> <871r8tdhjq.wl-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <df8163a0-3c2e-afc5-2f98-e804934c864c@arm.com>
Date: Tue, 22 Jun 2021 17:03:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <871r8tdhjq.wl-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Hector Martin <marcan@marcan.st>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCk9uIDYvMjIvMjEgNDo1MSBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIEFs
ZXgsCj4KPiBPbiBUdWUsIDIyIEp1biAyMDIxIDE2OjM5OjExICswMTAwLAo+IEFsZXhhbmRydSBF
bGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4gd3JvdGU6Cj4+IEhpIE1hcmMsCj4+Cj4+
IE9uIDYvMS8yMSAxMTozOSBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gVGhpcyBpcyBhIG5l
dyB2ZXJzaW9uIG9mIHRoZSBzZXJpZXMgcHJldmlvdXNseSBwb3N0ZWQgYXQgWzNdLCByZXdvcmtp
bmcKPj4+IHRoZSB2R0lDIGFuZCB0aW1lciBjb2RlIHRvIGNvcGUgd2l0aCB0aGUgTTEgYnJhaW5k
ZWFkXldhbXVzaW5nIG5hdHVyZS4KPj4+Cj4+PiBIYXJkbHkgYW55IGNoYW5nZSB0aGlzIHRpbWUg
YXJvdW5kLCBtb3N0bHkgcmViYXNlZCBvbiB0b3Agb2YgdXBzdHJlYW0KPj4+IG5vdyB0aGF0IHRo
ZSBkZXBlbmRlbmNpZXMgaGF2ZSBtYWRlIGl0IGluLgo+Pj4KPj4+IFRlc3RlZCB3aXRoIG11bHRp
cGxlIGNvbmN1cnJlbnQgVk1zIHJ1bm5pbmcgZnJvbSBhbiBpbml0cmFtZnMuCj4+Pgo+Pj4gVW50
aWwgc29tZW9uZSBzaG91dHMgbG91ZGx5IG5vdywgSSdsbCB0YWtlIHRoaXMgaW50byA1LjE0IChh
bmQgaW4KPj4+IC1uZXh0IGZyb20gdG9tb3Jyb3cpLgo+PiBJIGFtIG5vdCBmYW1pbGlhciB3aXRo
IGlycWRvbWFpbnMgb3Igd2l0aCB0aGUgaXJxY2hpcAo+PiBpbmZyYXN0cnVjdHVyZSwgc28gSSBj
YW4ndCByZWFsbHkgY29tbWVudCBvbiBwYXRjaCAjOC4KPj4KPj4gSSB0cmllZCB0ZXN0aW5nIHRo
aXMgd2l0aCBhIEdJQ3YzIGJ5IG1vZGlmeWluZyB0aGUgZHJpdmVyIHRvIHNldAo+PiBub19od19k
ZWFjdGl2YXRpb24gYW5kIG5vX21haW50X2lycV9tYXNrOgo+Pgo+PiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1p
bml0LmMKPj4gaW5kZXggMzQwYzUxZDg3Njc3Li5kMGM2ZjgwOGQ3ZjQgMTAwNjQ0Cj4+IC0tLSBh
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMKPj4gKysrIGIvYXJjaC9hcm02NC9rdm0v
dmdpYy92Z2ljLWluaXQuYwo+PiBAQCAtNTY1LDggKzU2NSwxMCBAQCBpbnQga3ZtX3ZnaWNfaHlw
X2luaXQodm9pZCkKPj4gwqDCoMKgwqDCoMKgwqAgaWYgKHJldCkKPj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+IMKgCj4+ICvCoMKgwqDCoMKgwqAgLyoKPj4g
wqDCoMKgwqDCoMKgwqAgaWYgKCFoYXNfbWFzaykKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiAwOwo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+PiDC
oAo+PiDCoMKgwqDCoMKgwqDCoCByZXQgPSByZXF1ZXN0X3BlcmNwdV9pcnEoa3ZtX3ZnaWNfZ2xv
YmFsX3N0YXRlLm1haW50X2lycSwKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2Z2ljX21haW50ZW5hbmNlX2hhbmRsZXIs
Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My5jIGIvZHJpdmVycy9p
cnFjaGlwL2lycS1naWMtdjMuYwo+PiBpbmRleCA0NTNmYzQyNWVlZGUuLjljZTRkZWUyMDY1NSAx
MDA2NDQKPj4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMuYwo+PiArKysgYi9kcml2
ZXJzL2lycWNoaXAvaXJxLWdpYy12My5jCj4+IEBAIC0xODUwLDYgKzE4NTAsMTIgQEAgc3RhdGlj
IHZvaWQgX19pbml0IGdpY19vZl9zZXR1cF9rdm1faW5mbyhzdHJ1Y3QgZGV2aWNlX25vZGUKPj4g
Km5vZGUpCj4+IMKgwqDCoMKgwqDCoMKgIGlmICghcmV0KQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZ2ljX3YzX2t2bV9pbmZvLnZjcHUgPSByOwo+PiDCoAo+PiArwqDCoMKgwqDC
oMKgIGdpY192M19rdm1faW5mby5ub19od19kZWFjdGl2YXRpb24gPSB0cnVlOwo+IEJsaW5rLi4u
Cj4KPj4gK8KgwqDCoMKgwqDCoCBnaWNfdjNfa3ZtX2luZm8ubm9fbWFpbnRfaXJxX21hc2sgPSB0
cnVlOwo+PiArCj4+ICvCoMKgwqDCoMKgwqAgdmdpY19zZXRfa3ZtX2luZm8oJmdpY192M19rdm1f
aW5mbyk7Cj4+ICvCoMKgwqDCoMKgwqAgcmV0dXJuOwo+PiArCj4+IMKgwqDCoMKgwqDCoMKgIGdp
Y192M19rdm1faW5mby5oYXNfdjQgPSBnaWNfZGF0YS5yZGlzdHMuaGFzX3ZscGlzOwo+PiDCoMKg
wqDCoMKgwqDCoCBnaWNfdjNfa3ZtX2luZm8uaGFzX3Y0XzEgPSBnaWNfZGF0YS5yZGlzdHMuaGFz
X3J2cGVpZDsKPj4gwqDCoMKgwqDCoMKgwqAgdmdpY19zZXRfa3ZtX2luZm8oJmdpY192M19rdm1f
aW5mbyk7Cj4+Cj4+IEtlcHQgdGhlIG1haW50ZW5hbmNlIGlycSBJRCBzbyB0aGUgSVJRIGdldHMg
ZW5hYmxlZCBhdCB0aGUKPj4gUmVkaXN0cmlidXRvciBsZXZlbC4gSSBkb24ndCBrbm93IGlmIEkg
bWFuYWdlZCB0byBicmVhayBzb21ldGhpbmcKPj4gd2l0aCB0aG9zZSBjaGFuZ2VzLCBidXQgd2hl
biB0ZXN0aW5nIG9uIHRoZSBtb2RlbCBhbmQgb24gYSByb2NrcHJvNjQKPj4gKHdpdGggdGhlIHBh
dGNoZXMgY2hlcnJ5LXBpY2tlZCBvbiB0b3Agb2YgdjUuMTMtcmM3KSBJIGtlcHQgc2VlaW5nCj4+
IHJjdSBzdGFsbHMuIEkgYXNzdW1lIEkgZGlkIHNvbWV0aGluZyB3cm9uZy4KPiBJZiB5b3UgZG8g
dGhhdCwgdGhlIGludGVycnVwdHMgdGhhdCBhcmUgZm9yd2FyZGVkIHRvIHRoZSBndWVzdAo+ICh0
aW1lcnMpIHdpbGwgbmV2ZXIgYmUgZGVhY3RpdmF0ZWQsIGFuZCB3aWxsIGJlIGxlZnQgZGFuZ2xp
bmcgYWZ0ZXIKPiB0aGUgZmlyc3QgaW5qZWN0aW9uLiBUaGlzIGlzIGJvdW5kIHRvIGNyZWF0ZSBo
YXZvYywgYXMgd2Ugd2lsbCB0aGVuCj4gdXNlIG1hc2svdW5tYXNrIHRvIGNvbnRyb2wgdGhlIHRp
bWVyIGRlbGl2ZXJ5IChyZW1lbWJlciB0aGF0IHRoZQo+IEFjdGl2ZSBzdGF0ZSBpcyBqdXN0IGFu
b3RoZXIgZm9ybSBvZiBhdXRvLW1hc2tpbmcgb24gdG9wIG9mIHRoZQo+IHN0YW5kYXJkIGVuYWJs
ZSBiaXQpCj4KPiBPbiB0aGUgY29udHJhcnksIHRoZSBBSUMgb25seSBoYXMgYSBzaW5nbGUgYml0
IHRvIGNvbnRyb2wgdGhlIHRpbWVyCj4gKHVzZWQgYXMgYSBtYXNrKSwgd2hpY2ggaXMgd2hhdCB0
aGUgaXJxZG9tYWluIHN0dWZmIGltcGxlbWVudHMgdG8KPiBtaW1pYyB0aGUgYWN0aXZlIHN0YXRl
LgoKU28gdGhlc2UgcGF0Y2hlcyB3b3JrICoqb25seSoqIHdpdGggdGhlIEFJQywgbm90IHdpdGgg
YSBzdGFuZGFyZCBHSUN2MyB3aXRob3V0IHRoZQpIVyBiaXQgaW4gdGhlIExSIHJlZ2lzdGVycyBh
bmQgd2l0aCBhbiB1bm1hc2thYmxlIG1haW50ZW5hbmNlIElSUT8gQmVjYXVzZSBmcm9tCnRoZSBj
b21taXQgbWVzc2FnZSBmcm9tICM4IEkgZ290IHRoZSBpbXByZXNzaW9uIHRoYXQgdGhlIHB1cnBv
c2Ugb2YgdGhlIGNoYW5nZSBpcwp0byBtYWtlIHRpbWVycyB3b3JrIG9uIGEgc3RhbmRhcmQgR0lD
djMsIHNhbnMgdGhvc2UgcmVxdWlyZWQgYXJjaGl0ZWN0dXJhbCBmZWF0dXJlcy4KClRoYW5rcywK
CkFsZXgKCj4KPiBUaGFua3MsCj4KPiAJTS4KPgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
