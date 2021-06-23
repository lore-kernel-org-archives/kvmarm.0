Return-Path: <SRS0=kEaE=LR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29372C4743C
	for <kvmarm@archiver.kernel.org>; Wed, 23 Jun 2021 16:17:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CAD26101D
	for <kvmarm@archiver.kernel.org>; Wed, 23 Jun 2021 16:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CAD26101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10E164B0F8;
	Wed, 23 Jun 2021 12:17:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 43hmysd6zfU4; Wed, 23 Jun 2021 12:17:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73EC24B0FA;
	Wed, 23 Jun 2021 12:17:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C09B54B0F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 12:17:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u9SaQTbIFbau for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Jun 2021 12:17:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 349304B0B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 12:17:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CACA31B;
 Wed, 23 Jun 2021 09:17:36 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A2C93F718;
 Wed, 23 Jun 2021 09:17:34 -0700 (PDT)
Subject: Re: [PATCH v4 0/9] KVM: arm64: Initial host support for the Apple M1
To: Marc Zyngier <maz@kernel.org>
References: <20210601104005.81332-1-maz@kernel.org>
 <9bc0923c-5c3b-eeac-86ee-c3234c486955@arm.com> <871r8tdhjq.wl-maz@kernel.org>
 <df8163a0-3c2e-afc5-2f98-e804934c864c@arm.com> <87v965c1bl.wl-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <eb5438b6-1f98-1b22-8174-e65feb319e53@arm.com>
Date: Wed, 23 Jun 2021 17:18:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87v965c1bl.wl-maz@kernel.org>
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

SGkgTWFyYywKCk9uIDYvMjIvMjEgNToyNiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIFR1
ZSwgMjIgSnVuIDIwMjEgMTc6MDM6MjIgKzAxMDAsCj4gQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFu
ZHJ1LmVsaXNlaUBhcm0uY29tPiB3cm90ZToKPj4gSGkgTWFyYywKPj4KPj4gT24gNi8yMi8yMSA0
OjUxIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiBIaSBBbGV4LAo+Pj4KPj4+IE9uIFR1ZSwg
MjIgSnVuIDIwMjEgMTY6Mzk6MTEgKzAxMDAsCj4+PiBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4YW5k
cnUuZWxpc2VpQGFybS5jb20+IHdyb3RlOgo+Pj4+IEhpIE1hcmMsCj4+Pj4KPj4+PiBPbiA2LzEv
MjEgMTE6MzkgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+Pj4gVGhpcyBpcyBhIG5ldyB2ZXJz
aW9uIG9mIHRoZSBzZXJpZXMgcHJldmlvdXNseSBwb3N0ZWQgYXQgWzNdLCByZXdvcmtpbmcKPj4+
Pj4gdGhlIHZHSUMgYW5kIHRpbWVyIGNvZGUgdG8gY29wZSB3aXRoIHRoZSBNMSBicmFpbmRlYWRe
V2FtdXNpbmcgbmF0dXJlLgo+Pj4+Pgo+Pj4+PiBIYXJkbHkgYW55IGNoYW5nZSB0aGlzIHRpbWUg
YXJvdW5kLCBtb3N0bHkgcmViYXNlZCBvbiB0b3Agb2YgdXBzdHJlYW0KPj4+Pj4gbm93IHRoYXQg
dGhlIGRlcGVuZGVuY2llcyBoYXZlIG1hZGUgaXQgaW4uCj4+Pj4+Cj4+Pj4+IFRlc3RlZCB3aXRo
IG11bHRpcGxlIGNvbmN1cnJlbnQgVk1zIHJ1bm5pbmcgZnJvbSBhbiBpbml0cmFtZnMuCj4+Pj4+
Cj4+Pj4+IFVudGlsIHNvbWVvbmUgc2hvdXRzIGxvdWRseSBub3csIEknbGwgdGFrZSB0aGlzIGlu
dG8gNS4xNCAoYW5kIGluCj4+Pj4+IC1uZXh0IGZyb20gdG9tb3Jyb3cpLgo+Pj4+IEkgYW0gbm90
IGZhbWlsaWFyIHdpdGggaXJxZG9tYWlucyBvciB3aXRoIHRoZSBpcnFjaGlwCj4+Pj4gaW5mcmFz
dHJ1Y3R1cmUsIHNvIEkgY2FuJ3QgcmVhbGx5IGNvbW1lbnQgb24gcGF0Y2ggIzguCj4+Pj4KPj4+
PiBJIHRyaWVkIHRlc3RpbmcgdGhpcyB3aXRoIGEgR0lDdjMgYnkgbW9kaWZ5aW5nIHRoZSBkcml2
ZXIgdG8gc2V0Cj4+Pj4gbm9faHdfZGVhY3RpdmF0aW9uIGFuZCBub19tYWludF9pcnFfbWFzazoK
Pj4+Pgo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jIGIv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYwo+Pj4+IGluZGV4IDM0MGM1MWQ4NzY3Ny4u
ZDBjNmY4MDhkN2Y0IDEwMDY0NAo+Pj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1p
bml0LmMKPj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jCj4+Pj4gQEAg
LTU2NSw4ICs1NjUsMTAgQEAgaW50IGt2bV92Z2ljX2h5cF9pbml0KHZvaWQpCj4+Pj4gwqDCoMKg
wqDCoMKgwqAgaWYgKHJldCkKPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIHJldDsKPj4+PiDCoAo+Pj4+ICvCoMKgwqDCoMKgwqAgLyoKPj4+PiDCoMKgwqDCoMKgwqDC
oCBpZiAoIWhhc19tYXNrKQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1
cm4gMDsKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+Pj4+IMKgCj4+Pj4g
wqDCoMKgwqDCoMKgwqAgcmV0ID0gcmVxdWVzdF9wZXJjcHVfaXJxKGt2bV92Z2ljX2dsb2JhbF9z
dGF0ZS5tYWludF9pcnEsCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2Z2ljX21haW50ZW5hbmNlX2hhbmRsZXIsCj4+
Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLmMgYi9kcml2ZXJzL2ly
cWNoaXAvaXJxLWdpYy12My5jCj4+Pj4gaW5kZXggNDUzZmM0MjVlZWRlLi45Y2U0ZGVlMjA2NTUg
MTAwNjQ0Cj4+Pj4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMuYwo+Pj4+ICsrKyBi
L2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLmMKPj4+PiBAQCAtMTg1MCw2ICsxODUwLDEyIEBA
IHN0YXRpYyB2b2lkIF9faW5pdCBnaWNfb2Zfc2V0dXBfa3ZtX2luZm8oc3RydWN0IGRldmljZV9u
b2RlCj4+Pj4gKm5vZGUpCj4+Pj4gwqDCoMKgwqDCoMKgwqAgaWYgKCFyZXQpCj4+Pj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdpY192M19rdm1faW5mby52Y3B1ID0gcjsKPj4+PiDC
oAo+Pj4+ICvCoMKgwqDCoMKgwqAgZ2ljX3YzX2t2bV9pbmZvLm5vX2h3X2RlYWN0aXZhdGlvbiA9
IHRydWU7Cj4+PiBCbGluay4uLgo+Pj4KPj4+PiArwqDCoMKgwqDCoMKgIGdpY192M19rdm1faW5m
by5ub19tYWludF9pcnFfbWFzayA9IHRydWU7Cj4+Pj4gKwo+Pj4+ICvCoMKgwqDCoMKgwqAgdmdp
Y19zZXRfa3ZtX2luZm8oJmdpY192M19rdm1faW5mbyk7Cj4+Pj4gK8KgwqDCoMKgwqDCoCByZXR1
cm47Cj4+Pj4gKwo+Pj4+IMKgwqDCoMKgwqDCoMKgIGdpY192M19rdm1faW5mby5oYXNfdjQgPSBn
aWNfZGF0YS5yZGlzdHMuaGFzX3ZscGlzOwo+Pj4+IMKgwqDCoMKgwqDCoMKgIGdpY192M19rdm1f
aW5mby5oYXNfdjRfMSA9IGdpY19kYXRhLnJkaXN0cy5oYXNfcnZwZWlkOwo+Pj4+IMKgwqDCoMKg
wqDCoMKgIHZnaWNfc2V0X2t2bV9pbmZvKCZnaWNfdjNfa3ZtX2luZm8pOwo+Pj4+Cj4+Pj4gS2Vw
dCB0aGUgbWFpbnRlbmFuY2UgaXJxIElEIHNvIHRoZSBJUlEgZ2V0cyBlbmFibGVkIGF0IHRoZQo+
Pj4+IFJlZGlzdHJpYnV0b3IgbGV2ZWwuIEkgZG9uJ3Qga25vdyBpZiBJIG1hbmFnZWQgdG8gYnJl
YWsgc29tZXRoaW5nCj4+Pj4gd2l0aCB0aG9zZSBjaGFuZ2VzLCBidXQgd2hlbiB0ZXN0aW5nIG9u
IHRoZSBtb2RlbCBhbmQgb24gYSByb2NrcHJvNjQKPj4+PiAod2l0aCB0aGUgcGF0Y2hlcyBjaGVy
cnktcGlja2VkIG9uIHRvcCBvZiB2NS4xMy1yYzcpIEkga2VwdCBzZWVpbmcKPj4+PiByY3Ugc3Rh
bGxzLiBJIGFzc3VtZSBJIGRpZCBzb21ldGhpbmcgd3JvbmcuCj4+PiBJZiB5b3UgZG8gdGhhdCwg
dGhlIGludGVycnVwdHMgdGhhdCBhcmUgZm9yd2FyZGVkIHRvIHRoZSBndWVzdAo+Pj4gKHRpbWVy
cykgd2lsbCBuZXZlciBiZSBkZWFjdGl2YXRlZCwgYW5kIHdpbGwgYmUgbGVmdCBkYW5nbGluZyBh
ZnRlcgo+Pj4gdGhlIGZpcnN0IGluamVjdGlvbi4gVGhpcyBpcyBib3VuZCB0byBjcmVhdGUgaGF2
b2MsIGFzIHdlIHdpbGwgdGhlbgo+Pj4gdXNlIG1hc2svdW5tYXNrIHRvIGNvbnRyb2wgdGhlIHRp
bWVyIGRlbGl2ZXJ5IChyZW1lbWJlciB0aGF0IHRoZQo+Pj4gQWN0aXZlIHN0YXRlIGlzIGp1c3Qg
YW5vdGhlciBmb3JtIG9mIGF1dG8tbWFza2luZyBvbiB0b3Agb2YgdGhlCj4+PiBzdGFuZGFyZCBl
bmFibGUgYml0KQo+Pj4KPj4+IE9uIHRoZSBjb250cmFyeSwgdGhlIEFJQyBvbmx5IGhhcyBhIHNp
bmdsZSBiaXQgdG8gY29udHJvbCB0aGUgdGltZXIKPj4+ICh1c2VkIGFzIGEgbWFzayksIHdoaWNo
IGlzIHdoYXQgdGhlIGlycWRvbWFpbiBzdHVmZiBpbXBsZW1lbnRzIHRvCj4+PiBtaW1pYyB0aGUg
YWN0aXZlIHN0YXRlLgo+PiBTbyB0aGVzZSBwYXRjaGVzIHdvcmsgKipvbmx5Kiogd2l0aCB0aGUg
QUlDLCBub3Qgd2l0aCBhIHN0YW5kYXJkCj4+IEdJQ3YzIHdpdGhvdXQgdGhlIEhXIGJpdCBpbiB0
aGUgTFIgcmVnaXN0ZXJzIGFuZCB3aXRoIGFuIHVubWFza2FibGUKPj4gbWFpbnRlbmFuY2UgSVJR
PyBCZWNhdXNlIGZyb20gdGhlIGNvbW1pdCBtZXNzYWdlIGZyb20gIzggSSBnb3QgdGhlCj4+IGlt
cHJlc3Npb24gdGhhdCB0aGUgcHVycG9zZSBvZiB0aGUgY2hhbmdlIGlzIHRvIG1ha2UgdGltZXJz
IHdvcmsgb24KPj4gYSBzdGFuZGFyZCBHSUN2Mywgc2FucyB0aG9zZSByZXF1aXJlZCBhcmNoaXRl
Y3R1cmFsIGZlYXR1cmVzLgo+IEkgZG9uJ3QgdW5kZXJzdGFuZCB3aGF0IHlvdSBtZWFuLgoKSSB0
aGluayBJIHVuZGVyc3RhbmQgd2hhdCBpcyBoYXBwZW5pbmcgYmV0dGVyIG5vdy4KCldpdGggbXkg
Y2hhbmdlcywgdmdpY19zZXRfaXJxX3BoeXNfYWN0aXZlKGlycSwKZmFsc2UpLT5pcnFfc2V0X2ly
cWNoaXBfc3RhdGUoaG9zdF9pcnEsIElSUUNISVBfU1RBVEVfQUNUSVZFLCBmYWxzZSkgd2lsbCBj
YWxsCnRpbWVyX3NldF9pcnFjaGlwX3N0YXRlKCktPmlycWNoaXBfdW5tYXNrX3BhcmVudCgpIHdo
aWNoIGRvZXNuJ3QgY2xlYXIgdGhlIGFjdGl2ZQpzdGF0ZSBvZiB0aGUgdGltZXIgaW50ZXJydXB0
IGF0IHRoZSBHSUMgbGV2ZWwuIFRoaXMgbWVhbnMgdGhhdCB0aGUgdGltZXIgaW50ZXJydXB0CmFj
dHMgbGlrZSBpdCdzIHBlcm1hbmVudGx5IG1hc2tlZCBhZnRlciB0aGF0IGZpcnN0IGludGVycnVw
dCwgbGlrZSB5b3UndmUgc2FpZC4KCkZyb20gdGhpcyBJIHVuZGVyc3RhbmQgdGhhdCB0aGUgQUlD
IGlzIHRoZSBvbmx5IEdJQyBpbXBsZW1lbnRhdGlvbiB0aGF0IHdpbGwgd29yawp3aGVuIG5vX2h3
X2RlYWN0aXZhdGlvbiA9IHRydWUuIFRvIHB1dCBpdCBhbm90aGVyIHdheSwgYSBHSUMgaW1wbGVt
ZW50YXRpb24gdGhhdAppcyAxMDAlIGFjY29yZGluZyB0byB0aGUgc3BlYyB3aXRoIHRoZSBleGNl
cHRpb24gdGhhdCBJQ0hfTFIuSFcgaXMgaGFyZHdpcmVkIHRvIDAKYW5kIHRoZSBtYWludGVuYW5j
ZSBpbnRlcnJ1cHQgZW5hYmxlZCBhbmQgdW5tYXNrYWJsZSB3aWxsIG5vdCB3b3JrIHdpdGggdGhl
c2UKcGF0Y2hlcyBiZWNhdXNlIHZnaWNfc2V0X2lycV9waHlzX2FjdGl2ZShpcnEsIGZhbHNlKSB3
aWxsIHVubWFzayB0aGUgaW50ZXJydXB0Cmluc3RlYWQgb2YgY2xlYXJpbmcgdGhlIGFjdGl2ZSBz
dGF0ZS4KCkkgd2FzIGNvbmZ1c2VkIGFib3V0IHRoYXQgYmVjYXVzZSBJIGRpZG4ndCBmaW5kIGFu
eXdoZXJlIG1lbnRpb25lZCBpbiB0aGUgY29tbWl0Cm1lc3NhZ2Ugb3IgaW4gdGhlIGNvZGUgZm9y
IHBhdGNoICM4IHRoYXQgdGhlIHBhdGNoIG9ubHkgd29ya3Mgd2l0aCBhbiBBSUMsIGFuZCBub3QK
d2l0aCBhIGdlbmVyaWMgR0lDdjMgd2l0aG91dCBoYXJkd2FyZSBkZWFjdGl2YXRpb24uCgpUaGFu
a3MsCgpBbGV4Cgo+IFRoZSBIVyBiaXQgaW4gdGhlIExSIGFuZCBkZWFjdGl2YXRpb24gKmFyZSog
cmVxdWlyZWQsIG5vbi1uZWdvdGlhYmxlCj4gcGFydHMgb2YgdGhlIEdJQ3YzIGFyY2hpdGVjdHVy
ZS4gQXBwbGUgZGlkIG5vdCBpbXBsZW1lbnQgaXQgaXMgYQo+IGNvbnNlcXVlbmNlIG9mIHRoZSBB
SUMgbm90IGhhdmluZyBhbiBhY3RpdmUgc3RhdGUgdGhhdCB0aGUgZ3Vlc3QgY2FuCj4gbWFuaXB1
bGF0ZSBpbmRlcGVuZGVudGx5IG9mIHRoZSBob3N0Lgo+Cj4gRWl0aGVyIHlvdSBoYXZlIGJvdGgg
SFcgYml0IGFuZCBhY3RpdmUgc3RhdGUsIGFuZCBib3RoIHdvcmsgdG9nZXRoZXIKPiAobm9ybWFs
IEdJQ3YzKSwgb3IgeW91IGhhdmUgbm9uZSBvZiB0aGF0IGFuZCB3ZSByZWx5IG9uIHRoZQo+IG1h
aW50ZW5hbmNlIGludGVycnVwdCB0byBleGl0IGFuZCBmaXggdGhlIG1lc3MgKEFwcGxlIGNyYXAp
LiBZb3UKPiBjYW5ub3QgaGF2ZSBhbiBpbnRlcm1lZGlhdGUgc3RhdGUgYmV0d2VlbiB0aGUgdHdv
Lgo+Cj4gVGhhbmtzLAo+Cj4gCU0uCj4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
