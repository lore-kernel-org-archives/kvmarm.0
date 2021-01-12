Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCF0C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 14:55:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B7C023136
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 14:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B7C023136
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8AEB4B1CF;
	Tue, 12 Jan 2021 09:55:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AGuJFiG2eCyT; Tue, 12 Jan 2021 09:55:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0D334B1EA;
	Tue, 12 Jan 2021 09:55:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A917D4B1CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 09:55:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eHzOUjcQGu3g for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 09:55:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CFD54B184
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 09:55:52 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06BCA11B3;
 Tue, 12 Jan 2021 06:55:52 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6616C3F719;
 Tue, 12 Jan 2021 06:55:50 -0800 (PST)
Subject: Re: [PATCH 5/9] KVM: arm: move has_run_once after the map_resources
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-6-eric.auger@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <0c9976a3-12ae-29b2-1f26-06ee52aa2ffe@arm.com>
Date: Tue, 12 Jan 2021 14:55:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201212185010.26579-6-eric.auger@redhat.com>
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

SGkgRXJpYywKCk9uIDEyLzEyLzIwIDY6NTAgUE0sIEVyaWMgQXVnZXIgd3JvdGU6Cj4gaGFzX3J1
bl9vbmNlIGlzIHNldCB0byB0cnVlIGF0IHRoZSBiZWdpbm5pbmcgb2YKPiBrdm1fdmNwdV9maXJz
dF9ydW5faW5pdCgpLiBUaGlzIGdlbmVyYWxseSBpcyBub3QgYW4gaXNzdWUKPiBleGNlcHQgd2hl
biBleGVyY2lzaW5nIHRoZSBjb2RlIHdpdGggS1ZNIHNlbGZ0ZXN0cy4gSW5kZWVkLAo+IGlmIGt2
bV92Z2ljX21hcF9yZXNvdXJjZXMoKSBmYWlscyBkdWUgdG8gZXJyb25lb3VzIHVzZXIgc2V0dGlu
Z3MsCj4gaGFzX3J1bl9vbmNlIGlzIHNldCBhbmQgdGhpcyBwcmV2ZW50cyBmcm9tIGNvbnRpbnVp
bmcKPiBleGVjdXRpbmcgdGhlIHRlc3QuIFRoaXMgcGF0Y2ggbW92ZXMgdGhlIGFzc2lnbm1lbnQg
YWZ0ZXIgdGhlCj4ga3ZtX3ZnaWNfbWFwX3Jlc291cmNlcygpLgo+Cj4gU2lnbmVkLW9mZi1ieTog
RXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+IC0tLQo+ICBhcmNoL2FybTY0L2t2
bS9hcm0uYyB8IDQgKystLQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQo+Cj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FybS5jIGIvYXJjaC9h
cm02NC9rdm0vYXJtLmMKPiBpbmRleCBjMGZmYjAxOWNhOGIuLjMzMWZhZTZiZmYzMSAxMDA2NDQK
PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9hcm0uYwo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2FybS5j
Cj4gQEAgLTU0MCw4ICs1NDAsNiBAQCBzdGF0aWMgaW50IGt2bV92Y3B1X2ZpcnN0X3J1bl9pbml0
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiAgCWlmICgha3ZtX2FybV92Y3B1X2lzX2ZpbmFsaXpl
ZCh2Y3B1KSkKPiAgCQlyZXR1cm4gLUVQRVJNOwo+ICAKPiAtCXZjcHUtPmFyY2guaGFzX3J1bl9v
bmNlID0gdHJ1ZTsKPiAtCj4gIAlpZiAobGlrZWx5KGlycWNoaXBfaW5fa2VybmVsKGt2bSkpKSB7
Cj4gIAkJLyoKPiAgCQkgKiBNYXAgdGhlIFZHSUMgaGFyZHdhcmUgcmVzb3VyY2VzIGJlZm9yZSBy
dW5uaW5nIGEgdmNwdSB0aGUKPiBAQCAtNTYwLDYgKzU1OCw4IEBAIHN0YXRpYyBpbnQga3ZtX3Zj
cHVfZmlyc3RfcnVuX2luaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+ICAJCXN0YXRpY19icmFu
Y2hfaW5jKCZ1c2Vyc3BhY2VfaXJxY2hpcF9pbl91c2UpOwo+ICAJfQo+ICAKPiArCXZjcHUtPmFy
Y2guaGFzX3J1bl9vbmNlID0gdHJ1ZTsKCkkgaGF2ZSBhIGZldyBjb25jZXJucyByZWdhcmRpbmcg
dGhpczoKCjEuIE1vdmluZyBoYXNfcnVuX29uY2UgPSB0cnVlIGhlcmUgc2VlbXMgdmVyeSBhcmJp
dHJhcnkgdG8gbWUgLSBrdm1fdGltZXJfZW5hYmxlKCkKYW5kIGt2bV9hcm1fcG11X3YzX2VuYWJs
ZSgpLCBiZWxvdyBpdCwgY2FuIGJvdGggZmFpbCBiZWNhdXNlIG9mIGVycm9uZW91cyB1c2VyCnZh
bHVlcy4gSWYgdGhlcmUncyBhIHJlYXNvbiB3aHkgdGhlIGFzc2lnbm1lbnQgY2Fubm90IGJlIG1v
dmVkIGF0IHRoZSBlbmQgb2YgdGhlCmZ1bmN0aW9uLCBJIHRoaW5rIGl0IHNob3VsZCBiZSBjbGVh
cmx5IHN0YXRlZCBpbiBhIGNvbW1lbnQgZm9yIHRoZSBwZW9wbGUgd2hvCm1pZ2h0IGJlIHRlbXB0
ZWQgdG8gd3JpdGUgc2ltaWxhciB0ZXN0cyBmb3IgdGhlIHRpbWVyIG9yIHBtdS4KCjIuIFRoZXJl
IGFyZSBtYW55IHdheXMgdGhhdCBrdm1fdmdpY19tYXBfcmVzb3VyY2VzKCkgY2FuIGZhaWwsIG90
aGVyIHRoYW4KaW5jb3JyZWN0IHVzZXIgc2V0dGluZ3MuIEkgc3RhcnRlZCBkaWdnaW5nIGludG8g
aG93Cmt2bV92Z2ljX21hcF9yZXNvdXJjZXMoKS0+dmdpY192Ml9tYXBfcmVzb3VyY2VzKCkgY2Fu
IGZhaWwgZm9yIGEgVkdJQyBWMiBhbmQgdGhpcwppcyB3aGF0IEkgbWFuYWdlZCB0byBmaW5kIGJl
Zm9yZSBJIGdhdmUgdXA6CgoqIHZnaWNfaW5pdCgpIGNhbiBmYWlsIGluOgrCoMKgwqAgLSBrdm1f
dmdpY19kaXN0X2luaXQoKQrCoMKgwqAgLSB2Z2ljX3YzX2luaXQoKQrCoMKgwqAgLSBrdm1fdmdp
Y19zZXR1cF9kZWZhdWx0X2lycV9yb3V0aW5nKCkKKiB2Z2ljX3JlZ2lzdGVyX2Rpc3RfaW9kZXYo
KSBjYW4gZmFpbCBpbjoKwqDCoMKgIC0gdmdpY192M19pbml0X2Rpc3RfaW9kZXYoKQrCoMKgwqAg
LSBrdm1faW9fYnVzX3JlZ2lzdGVyX2RldigpKCopCioga3ZtX3BoeXNfYWRkcl9pb3JlbWFwKCkg
Y2FuIGZhaWwgaW46CsKgwqDCoCAtIGt2bV9tbXVfdG9wdXBfbWVtb3J5X2NhY2hlKCkKwqDCoMKg
IC0ga3ZtX3BndGFibGVfc3RhZ2UyX21hcCgpCgpTbyBpZiBhbnkgb2YgdGhlIGZ1bmN0aW9ucyBi
ZWxvdyBmYWlsLCBhcmUgd2UgMTAwJSBzdXJlIGl0IGlzIHNhZmUgdG8gYWxsb3cgdGhlCnVzZXIg
dG8gZXhlY3V0ZSBrdm1fdmdpY19tYXBfcmVzb3VyY2VzKCkgYWdhaW4/CgooKikgSXQgbG9va3Mg
dG8gbWUgbGlrZSBrdm1faW9fYnVzX3JlZ2lzdGVyX2RldigpIGRvZXNuJ3QgdGFrZSBpbnRvIGFj
Y291bnQgYQpjYWxsZXIgdGhhdCB0cmllcyB0byByZWdpc3RlciB0aGUgc2FtZSBkZXZpY2UgYWRk
cmVzcyByYW5nZSBhbmQgaXQgd2lsbCBjcmVhdGUKYW5vdGhlciBpZGVudGljYWwgcmFuZ2UuIElz
IHRoaXMgaW50ZW50aW9uYWw/IElzIGl0IGEgYnVnIHRoYXQgc2hvdWxkIGJlIGZpeGVkPyBPcgph
bSBJIG1pc3VuZGVyc3RhbmRpbmcgdGhlIGZ1bmN0aW9uPwoKVGhhbmtzLApBbGV4Cj4gKwo+ICAJ
cmV0ID0ga3ZtX3RpbWVyX2VuYWJsZSh2Y3B1KTsKPiAgCWlmIChyZXQpCj4gIAkJcmV0dXJuIHJl
dDsKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
