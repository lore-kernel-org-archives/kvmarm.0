Return-Path: <SRS0=2DZ8=GX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA51C433E6
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 15:57:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 645B92336D
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 15:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 645B92336D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DE254B10F;
	Wed, 20 Jan 2021 10:57:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9eoxP2dLySOv; Wed, 20 Jan 2021 10:57:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C8B44B0CE;
	Wed, 20 Jan 2021 10:57:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B9F4A522
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 10:57:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2sY6Czs6jy9S for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2021 10:57:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA2D14B0CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 10:57:01 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 310691063;
 Wed, 20 Jan 2021 07:57:01 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A00BF3F68F;
 Wed, 20 Jan 2021 07:56:59 -0800 (PST)
Subject: Re: [PATCH 5/9] KVM: arm: move has_run_once after the map_resources
To: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-6-eric.auger@redhat.com>
 <0c9976a3-12ae-29b2-1f26-06ee52aa2ffe@arm.com>
 <3465e1e4-d202-ae36-5b61-87f796432428@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5590800f-f77d-52e1-e408-c1afe4e284a2@arm.com>
Date: Wed, 20 Jan 2021 15:56:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <3465e1e4-d202-ae36-5b61-87f796432428@redhat.com>
Content-Language: en-US
Cc: shuah@kernel.org, pbonzini@redhat.com
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

SGkgRXJpYywKCk9uIDEvMTQvMjEgMTA6MDIgQU0sIEF1Z2VyIEVyaWMgd3JvdGU6Cj4gSGkgQWxl
eGFuZHJ1LAo+Cj4gT24gMS8xMi8yMSAzOjU1IFBNLCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+
PiBIaSBFcmljLAo+Pgo+PiBPbiAxMi8xMi8yMCA2OjUwIFBNLCBFcmljIEF1Z2VyIHdyb3RlOgo+
Pj4gaGFzX3J1bl9vbmNlIGlzIHNldCB0byB0cnVlIGF0IHRoZSBiZWdpbm5pbmcgb2YKPj4+IGt2
bV92Y3B1X2ZpcnN0X3J1bl9pbml0KCkuIFRoaXMgZ2VuZXJhbGx5IGlzIG5vdCBhbiBpc3N1ZQo+
Pj4gZXhjZXB0IHdoZW4gZXhlcmNpc2luZyB0aGUgY29kZSB3aXRoIEtWTSBzZWxmdGVzdHMuIElu
ZGVlZCwKPj4+IGlmIGt2bV92Z2ljX21hcF9yZXNvdXJjZXMoKSBmYWlscyBkdWUgdG8gZXJyb25l
b3VzIHVzZXIgc2V0dGluZ3MsCj4+PiBoYXNfcnVuX29uY2UgaXMgc2V0IGFuZCB0aGlzIHByZXZl
bnRzIGZyb20gY29udGludWluZwo+Pj4gZXhlY3V0aW5nIHRoZSB0ZXN0LiBUaGlzIHBhdGNoIG1v
dmVzIHRoZSBhc3NpZ25tZW50IGFmdGVyIHRoZQo+Pj4ga3ZtX3ZnaWNfbWFwX3Jlc291cmNlcygp
Lgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNv
bT4KPj4+IC0tLQo+Pj4gIGFyY2gvYXJtNjQva3ZtL2FybS5jIHwgNCArKy0tCj4+PiAgMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPj4+Cj4+PiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vYXJtLmMgYi9hcmNoL2FybTY0L2t2bS9hcm0uYwo+Pj4gaW5k
ZXggYzBmZmIwMTljYThiLi4zMzFmYWU2YmZmMzEgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2FybTY0
L2t2bS9hcm0uYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMKPj4+IEBAIC01NDAsOCAr
NTQwLDYgQEAgc3RhdGljIGludCBrdm1fdmNwdV9maXJzdF9ydW5faW5pdChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpCj4+PiAgCWlmICgha3ZtX2FybV92Y3B1X2lzX2ZpbmFsaXplZCh2Y3B1KSkKPj4+
ICAJCXJldHVybiAtRVBFUk07Cj4+PiAgCj4+PiAtCXZjcHUtPmFyY2guaGFzX3J1bl9vbmNlID0g
dHJ1ZTsKPj4+IC0KPj4+ICAJaWYgKGxpa2VseShpcnFjaGlwX2luX2tlcm5lbChrdm0pKSkgewo+
Pj4gIAkJLyoKPj4+ICAJCSAqIE1hcCB0aGUgVkdJQyBoYXJkd2FyZSByZXNvdXJjZXMgYmVmb3Jl
IHJ1bm5pbmcgYSB2Y3B1IHRoZQo+Pj4gQEAgLTU2MCw2ICs1NTgsOCBAQCBzdGF0aWMgaW50IGt2
bV92Y3B1X2ZpcnN0X3J1bl9pbml0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+ICAJCXN0YXRp
Y19icmFuY2hfaW5jKCZ1c2Vyc3BhY2VfaXJxY2hpcF9pbl91c2UpOwo+Pj4gIAl9Cj4+PiAgCj4+
PiArCXZjcHUtPmFyY2guaGFzX3J1bl9vbmNlID0gdHJ1ZTsKPj4gSSBoYXZlIGEgZmV3IGNvbmNl
cm5zIHJlZ2FyZGluZyB0aGlzOgo+Pgo+PiAxLiBNb3ZpbmcgaGFzX3J1bl9vbmNlID0gdHJ1ZSBo
ZXJlIHNlZW1zIHZlcnkgYXJiaXRyYXJ5IHRvIG1lIC0ga3ZtX3RpbWVyX2VuYWJsZSgpCj4+IGFu
ZCBrdm1fYXJtX3BtdV92M19lbmFibGUoKSwgYmVsb3cgaXQsIGNhbiBib3RoIGZhaWwgYmVjYXVz
ZSBvZiBlcnJvbmVvdXMgdXNlcgo+PiB2YWx1ZXMuIElmIHRoZXJlJ3MgYSByZWFzb24gd2h5IHRo
ZSBhc3NpZ25tZW50IGNhbm5vdCBiZSBtb3ZlZCBhdCB0aGUgZW5kIG9mIHRoZQo+PiBmdW5jdGlv
biwgSSB0aGluayBpdCBzaG91bGQgYmUgY2xlYXJseSBzdGF0ZWQgaW4gYSBjb21tZW50IGZvciB0
aGUgcGVvcGxlIHdobwo+PiBtaWdodCBiZSB0ZW1wdGVkIHRvIHdyaXRlIHNpbWlsYXIgdGVzdHMg
Zm9yIHRoZSB0aW1lciBvciBwbXUuCj4gU2V0dGluZyBoYXNfcnVuX29uY2UgPSB0cnVlIGF0IHRo
ZSBlbnRyeSBvZiB0aGUgZnVuY3Rpb24gbG9va3MgdG8gbWUKPiBldmVuIG1vcmUgYXJiaXRyYXJ5
LiBJIGFncmVlIHdpdGggeW91IHRoYXQgZXZlbnR1YWxseSBoYXNfcnVuX29uY2UgbWF5CgpPciBp
dCBjb3VsZCBiZSBpdCdzIHRoZXJlIHRvIHByZXZlbnQgdGhlIHVzZXIgZnJvbSBjYWxsaW5nCmt2
bV92Z2ljX21hcF9yZXNvdXJjZXMoKSBhIHNlY29uZCB0aW1lIGFmdGVyIGl0IGZhaWxlZC4gVGhp
cyBpcyB3aGF0IEknbSBjb25jZXJuZWQKYWJvdXQgYW5kIEkgdGhpbmsgZGVzZXJ2ZXMgbW9yZSBp
bnZlc3RpZ2F0aW9uLgoKVGhhbmtzLApBbGV4Cj4gYmUgbW92ZWQgYXQgdGhlIHZlcnkgZW5kIGJ1
dCBtYXliZSB0aGlzIGNhbiBiZSBkb25lIGxhdGVyIG9uY2UgdGltZXIsCj4gcG11IHRlc3RzIGhh
dmVuIGJlbiB3cml0dGVuCj4+IDIuIFRoZXJlIGFyZSBtYW55IHdheXMgdGhhdCBrdm1fdmdpY19t
YXBfcmVzb3VyY2VzKCkgY2FuIGZhaWwsIG90aGVyIHRoYW4KPj4gaW5jb3JyZWN0IHVzZXIgc2V0
dGluZ3MuIEkgc3RhcnRlZCBkaWdnaW5nIGludG8gaG93Cj4+IGt2bV92Z2ljX21hcF9yZXNvdXJj
ZXMoKS0+dmdpY192Ml9tYXBfcmVzb3VyY2VzKCkgY2FuIGZhaWwgZm9yIGEgVkdJQyBWMiBhbmQg
dGhpcwo+PiBpcyB3aGF0IEkgbWFuYWdlZCB0byBmaW5kIGJlZm9yZSBJIGdhdmUgdXA6Cj4+Cj4+
ICogdmdpY19pbml0KCkgY2FuIGZhaWwgaW46Cj4+IMKgwqDCoCAtIGt2bV92Z2ljX2Rpc3RfaW5p
dCgpCj4+IMKgwqDCoCAtIHZnaWNfdjNfaW5pdCgpCj4+IMKgwqDCoCAtIGt2bV92Z2ljX3NldHVw
X2RlZmF1bHRfaXJxX3JvdXRpbmcoKQo+PiAqIHZnaWNfcmVnaXN0ZXJfZGlzdF9pb2RldigpIGNh
biBmYWlsIGluOgo+PiDCoMKgwqAgLSB2Z2ljX3YzX2luaXRfZGlzdF9pb2RldigpCj4+IMKgwqDC
oCAtIGt2bV9pb19idXNfcmVnaXN0ZXJfZGV2KCkoKikKPj4gKiBrdm1fcGh5c19hZGRyX2lvcmVt
YXAoKSBjYW4gZmFpbCBpbjoKPj4gwqDCoMKgIC0ga3ZtX21tdV90b3B1cF9tZW1vcnlfY2FjaGUo
KQo+PiDCoMKgwqAgLSBrdm1fcGd0YWJsZV9zdGFnZTJfbWFwKCkKPiBJIGNoYW5nZWQgdGhlIGNv
bW1pdCBtc2cgc28gdGhhdCAiaW5jb3JyZWN0IHVzZXIgc2V0dGluZ3MiIHNvdW5kcyBhcyBhbgo+
IGV4YW1wbGUuCj4+IFNvIGlmIGFueSBvZiB0aGUgZnVuY3Rpb25zIGJlbG93IGZhaWwsIGFyZSB3
ZSAxMDAlIHN1cmUgaXQgaXMgc2FmZSB0byBhbGxvdyB0aGUKPj4gdXNlciB0byBleGVjdXRlIGt2
bV92Z2ljX21hcF9yZXNvdXJjZXMoKSBhZ2Fpbj8KPiBJIHRoaW5rIGFkZGl0aW9uYWwgdGVzdHMg
d2lsbCBjb25maXJtIHRoaXMuIEhvd2V2ZXIgYXQgdGhlIG1vbWVudCwKPiBtb3ZpbmcgdGhlIGFz
c2lnbm1lbnQsIHdoaWNoIGRvZXMgbm90IGxvb2sgd3JvbmcgdG8gbWUsIGFsbG93cyB0bwo+IGdy
ZWF0bHkgc2ltcGxpZnkgdGhlIHRlc3RzIHNvIEkgd291bGQgdGVuZCB0byBzYXkgdGhhdCBpdCBp
cyB3b3J0aC4KPj4gKCopIEl0IGxvb2tzIHRvIG1lIGxpa2Uga3ZtX2lvX2J1c19yZWdpc3Rlcl9k
ZXYoKSBkb2Vzbid0IHRha2UgaW50byBhY2NvdW50IGEKPj4gY2FsbGVyIHRoYXQgdHJpZXMgdG8g
cmVnaXN0ZXIgdGhlIHNhbWUgZGV2aWNlIGFkZHJlc3MgcmFuZ2UgYW5kIGl0IHdpbGwgY3JlYXRl
Cj4+IGFub3RoZXIgaWRlbnRpY2FsIHJhbmdlLiBJcyB0aGlzIGludGVudGlvbmFsPyBJcyBpdCBh
IGJ1ZyB0aGF0IHNob3VsZCBiZSBmaXhlZD8gT3IKPj4gYW0gSSBtaXN1bmRlcnN0YW5kaW5nIHRo
ZSBmdW5jdGlvbj8KPiBkb2Vzbid0IGt2bV9pb19idXNfY21wKCkgZG8gdGhlIGNoZWNrPwo+Cj4g
VGhhbmtzCj4KPiBFcmljCj4+IFRoYW5rcywKPj4gQWxleAo+Pj4gKwo+Pj4gIAlyZXQgPSBrdm1f
dGltZXJfZW5hYmxlKHZjcHUpOwo+Pj4gIAlpZiAocmV0KQo+Pj4gIAkJcmV0dXJuIHJldDsKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
