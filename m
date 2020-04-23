Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782B9C54FCB
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 14:35:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36CEE20728
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 14:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36CEE20728
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C26664B141;
	Thu, 23 Apr 2020 10:35:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aailSOO9hIoa; Thu, 23 Apr 2020 10:35:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D60D4B14D;
	Thu, 23 Apr 2020 10:35:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD3CC4B13C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 10:35:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MKE3rNGcMHHR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 10:35:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 519B04B130
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 10:35:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0445B31B;
 Thu, 23 Apr 2020 07:35:01 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21CBA3F6CF;
 Thu, 23 Apr 2020 07:34:59 -0700 (PDT)
Subject: Re: [PATCH v3 5/6] KVM: arm64: vgic-v3: Retire all pending LPIs on
 vcpu destroy
To: Marc Zyngier <maz@kernel.org>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-6-maz@kernel.org>
 <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
 <c4b89164d79b733bcc38801c9483417d@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <b76bf753-caaa-a6ce-9cdc-0fcf05821a56@arm.com>
Date: Thu, 23 Apr 2020 15:34:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c4b89164d79b733bcc38801c9483417d@kernel.org>
Content-Language: en-GB
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
 Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
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

SGkgZ3V5cywKCk9uIDIzLzA0LzIwMjAgMTM6MDMsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAy
MDIwLTA0LTIzIDEyOjM1LCBKYW1lcyBNb3JzZSB3cm90ZToKPj4gT24gMjIvMDQvMjAyMCAxNzox
OCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gRnJvbTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1
YXdlaS5jb20+Cj4+Pgo+Pj4gSXQncyBsaWtlbHkgdGhhdCB0aGUgdmNwdSBmYWlscyB0byBoYW5k
bGUgYWxsIHZpcnR1YWwgaW50ZXJydXB0cyBpZgo+Pj4gdXNlcnNwYWNlIGRlY2lkZXMgdG8gZGVz
dHJveSBpdCwgbGVhdmluZyB0aGUgcGVuZGluZyBvbmVzIHN0YXkgaW4gdGhlCj4+PiBhcF9saXN0
LiBJZiB0aGUgdW4taGFuZGxlZCBvbmUgaXMgYSBMUEksIGl0cyB2Z2ljX2lycSBzdHJ1Y3R1cmUg
d2lsbAo+Pj4gYmUgZXZlbnR1YWxseSBsZWFrZWQgYmVjYXVzZSBvZiBhbiBleHRyYSByZWZjb3Vu
dCBpbmNyZW1lbnQgaW4KPj4+IHZnaWNfcXVldWVfaXJxX3VubG9jaygpLgo+Pgo+Pj4gZGlmZiAt
LWdpdCBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaW5pdC5jIGIvdmlydC9rdm0vYXJtL3ZnaWMv
dmdpYy1pbml0LmMKPj4+IGluZGV4IGE5NjNiOWQ3NjZiNzMuLjUzZWM5YjlkOWJjNDMgMTAwNjQ0
Cj4+PiAtLS0gYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLWluaXQuYwo+Pj4gKysrIGIvdmlydC9r
dm0vYXJtL3ZnaWMvdmdpYy1pbml0LmMKPj4+IEBAIC0zNDgsNiArMzQ4LDEyIEBAIHZvaWQga3Zt
X3ZnaWNfdmNwdV9kZXN0cm95KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+IMKgewo+Pj4gwqDC
oMKgwqAgc3RydWN0IHZnaWNfY3B1ICp2Z2ljX2NwdSA9ICZ2Y3B1LT5hcmNoLnZnaWNfY3B1Owo+
Pj4KPj4+ICvCoMKgwqAgLyoKPj4+ICvCoMKgwqDCoCAqIFJldGlyZSBhbGwgcGVuZGluZyBMUElz
IG9uIHRoaXMgdmNwdSBhbnl3YXkgYXMgd2UncmUKPj4+ICvCoMKgwqDCoCAqIGdvaW5nIHRvIGRl
c3Ryb3kgaXQuCj4+PiArwqDCoMKgwqAgKi8KPj4KPj4gTG9va2luZyBhdCB0aGUgb3RoZXIgY2Fs
bGVyLCBkbyB3ZSBuZWVkIHNvbWV0aGluZyBsaWtlOgo+PiB8wqDCoMKgIGlmICh2Z2ljX2NwdS0+
bHBpc19lbmFibGVkKQo+Pgo+PiA/Cj4gCj4gSHVoLi4uIE9uIGl0cyBvd24sIHRoaXMgY2FsbCBp
cyBhYnNvbHV0ZWx5IGhhcm1sZXNzIGV2ZW4gaWYgeW91Cj4gZG9uJ3QgaGF2ZSBMUElzLiBCdXQg
c2VlIGJlbG93Lgo+IAo+Pgo+Pj4gK8KgwqDCoCB2Z2ljX2ZsdXNoX3BlbmRpbmdfbHBpcyh2Y3B1
KTsKPj4+ICsKPj4KPj4gT3RoZXJ3aXNlLCBJIGdldCB0aGlzIG9uIGEgZ2ljLXYyIG1hY2hpbmUh
Ogo+PiBbIDE3NDIuMTg3MTM5XSBCVUc6IEtBU0FOOiB1c2UtYWZ0ZXItZnJlZSBpbiB2Z2ljX2Zs
dXNoX3BlbmRpbmdfbHBpcysweDI1MC8weDJjMAo+PiBbIDE3NDIuMTk0MzAyXSBSZWFkIG9mIHNp
emUgOCBhdCBhZGRyIGZmZmYwMDA4ZTFiZjFmMjggYnkgdGFzawo+PiBxZW11LXN5c3RlbS1hYXIv
NTQyCj4+IFsgMTc0Mi4yMDMxNDBdIENQVTogMiBQSUQ6IDU0MiBDb21tOiBxZW11LXN5c3RlbS1h
YXIgTm90IHRhaW50ZWQKPj4gNS43LjAtcmMyLTAwMDA2LWc0ZmIwZjdiYjBlMjcgIzIKPj4gWyAx
NzQyLjIxMTc4MF0gSGFyZHdhcmUgbmFtZTogQVJNIExURCBBUk0gSnVubyBEZXZlbG9wbWVudAo+
PiBQbGF0Zm9ybS9BUk0gSnVubyBEZXZlbG9wbWVudAo+PiBQbGF0Zm9ybSwgQklPUyBFREsgSUkg
SnVsIDMwIDIwMTgKPj4gWyAxNzQyLjIyMjU5Nl0gQ2FsbCB0cmFjZToKPj4gWyAxNzQyLjIyNTA1
OV3CoCBkdW1wX2JhY2t0cmFjZSsweDAvMHgzMjgKPj4gWyAxNzQyLjIyODczOF3CoCBzaG93X3N0
YWNrKzB4MTgvMHgyOAo+PiBbIDE3NDIuMjMyMDcxXcKgIGR1bXBfc3RhY2srMHgxMzQvMHgxYjAK
Pj4gWyAxNzQyLjIzNTU3OF3CoCBwcmludF9hZGRyZXNzX2Rlc2NyaXB0aW9uLmlzcmEuMCsweDZj
LzB4MzUwCj4+IFsgMTc0Mi4yNDA5MTBdwqAgX19rYXNhbl9yZXBvcnQrMHgxMGMvMHgxODAKPj4g
WyAxNzQyLjI0NDc2M13CoCBrYXNhbl9yZXBvcnQrMHg0Yy8weDY4Cj4+IFsgMTc0Mi4yNDgyNjhd
wqAgX19hc2FuX3JlcG9ydF9sb2FkOF9ub2Fib3J0KzB4MzAvMHg0OAo+PiBbIDE3NDIuMjUzMDgx
XcKgIHZnaWNfZmx1c2hfcGVuZGluZ19scGlzKzB4MjUwLzB4MmMwCj4+IFsgMTc0Mi4yNTc3MThd
wqAgX19rdm1fdmdpY19kZXN0cm95KzB4MWNjLzB4NDc4Cj4+IFsgMTc0Mi4yNjE5MTldwqAga3Zt
X3ZnaWNfZGVzdHJveSsweDMwLzB4NDgKPj4gWyAxNzQyLjI2NTc3M13CoCBrdm1fYXJjaF9kZXN0
cm95X3ZtKzB4MjAvMHgxMjgKPj4gWyAxNzQyLjI2OTk3Nl3CoCBrdm1fcHV0X2t2bSsweDNlMC8w
eDhkMAo+PiBbIDE3NDIuMjczNTY3XcKgIGt2bV92bV9yZWxlYXNlKzB4M2MvMHg2MAo+PiBbIDE3
NDIuMjc3MjQ4XcKgIF9fZnB1dCsweDIxOC8weDYzMAo+PiBbIDE3NDIuMjgwNDA2XcKgIF9fX19m
cHV0KzB4MTAvMHgyMAo+PiBbIDE3NDIuMjgzNTY1XcKgIHRhc2tfd29ya19ydW4rMHhkOC8weDFm
MAo+PiBbIDE3NDIuMjg3MjQ1XcKgIGRvX2V4aXQrMHg4N2MvMHgyNjQwCj4+IFsgMTc0Mi4yOTA1
NzVdwqAgZG9fZ3JvdXBfZXhpdCsweGQwLzB4MjU4Cj4+IFsgMTc0Mi4yOTQyNTRdwqAgX19hcm02
NF9zeXNfZXhpdF9ncm91cCsweDNjLzB4NDgKPj4gWyAxNzQyLjI5ODYzMV3CoCBlbDBfc3ZjX2Nv
bW1vbi5jb25zdHByb3AuMCsweDEwYy8weDM0OAo+PiBbIDE3NDIuMzAzNTI5XcKgIGRvX2VsMF9z
dmMrMHg0OC8weGQwCj4+IFsgMTc0Mi4zMDY4NjFdwqAgZWwwX3N5bmNfaGFuZGxlcisweDExYy8w
eDFiOAo+PiBbIDE3NDIuMzEwODg4XcKgIGVsMF9zeW5jKzB4MTU4LzB4MTgwCgo+PiBbIDE3NDIu
MzQ4MjE1XSBwYWdlIGR1bXBlZCBiZWNhdXNlOiBrYXNhbjogYmFkIGFjY2VzcyBkZXRlY3RlZAoK
PiBJIHRoaW5rIHRoaXMgaXMgc2xpZ2h0bHkgbW9yZSBjb25jZXJuaW5nLiBUaGUgaXNzdWUgaXMg
dGhhdCB3ZSBoYXZlCj4gc3RhcnRlZCBmcmVlaW5nIHBhcnRzIG9mIHRoZSBpbnRlcnJ1cHQgc3Rh
dGUgYWxyZWFkeSAod2UgZnJlZSB0aGUKPiBTUElzIGVhcmx5IGluIGt2bV92Z2ljX2Rpc3RfZGVz
dHJveSgpKS4KCihJIHRvb2sgdGhpcyB0byBiZSBzb21lIHdpbGQgcG9pbnRlciBhY2Nlc3MuIFBy
ZXZpb3VzbHkgZm9yIHVzZS1hZnRlci1mcmVlIEkndmUgc2VlbiBpdApwcmludCB3aGVyZSBpdCB3
YXMgYWxsb2NhdGVkIGFuZCB3aGVyZSBpdCB3YXMgZnJlZWQpLgoKCj4gSWYgYSBTUEkgd2FzIHBl
bmRpbmcgb3IgYWN0aXZlIGF0IHRoaXMgc3RhZ2UgKGkuZS4gcHJlc2VudCBpbiB0aGUKPiBhcF9s
aXN0KSwgd2UgYXJlIGdvaW5nIHRvIGl0ZXJhdGUgb3ZlciBtZW1vcnkgdGhhdCBoYXMgYmVlbiBm
cmVlZAo+IGFscmVhZHkuIFRoaXMgaXMgYmFkLCBhbmQgdGhpcyBjYW4gaGFwcGVuIG9uIEdJQ3Yz
IGFzIHdlbGwuCgoKPiBJIHRoaW5rIHRoaXMgc2hvdWxkIHNvbHZlIGl0LCBidXQgSSBuZWVkIHRv
IHRlc3QgaXQgb24gYSBHSUN2MiBzeXN0ZW06Cj4gCj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2Fy
bS92Z2ljL3ZnaWMtaW5pdC5jIGIvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pbml0LmMKPiBpbmRl
eCA1M2VjOWI5ZDliYzQzLi4zMGRiZWM5ZmUwYjRhIDEwMDY0NAo+IC0tLSBhL3ZpcnQva3ZtL2Fy
bS92Z2ljL3ZnaWMtaW5pdC5jCj4gKysrIGIvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pbml0LmMK
PiBAQCAtMzY1LDEwICszNjUsMTAgQEAgc3RhdGljIHZvaWQgX19rdm1fdmdpY19kZXN0cm95KHN0
cnVjdCBrdm0gKmt2bSkKPiAKPiDCoMKgwqDCoCB2Z2ljX2RlYnVnX2Rlc3Ryb3koa3ZtKTsKPiAK
PiAtwqDCoMKgIGt2bV92Z2ljX2Rpc3RfZGVzdHJveShrdm0pOwo+IC0KPiDCoMKgwqDCoCBrdm1f
Zm9yX2VhY2hfdmNwdShpLCB2Y3B1LCBrdm0pCj4gwqDCoMKgwqDCoMKgwqDCoCBrdm1fdmdpY192
Y3B1X2Rlc3Ryb3kodmNwdSk7Cj4gKwo+ICvCoMKgwqAga3ZtX3ZnaWNfZGlzdF9kZXN0cm95KGt2
bSk7Cj4gwqB9Cj4gPiDCoHZvaWQga3ZtX3ZnaWNfZGVzdHJveShzdHJ1Y3Qga3ZtICprdm0pCgpU
aGlzIHdvcmtzIGZvciBtZSBvbiBKdW5vLgoKClRoYW5rcywKCkphbWVzCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
