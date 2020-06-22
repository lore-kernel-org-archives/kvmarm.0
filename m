Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A7EC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 09:15:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A2C9020656
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 09:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2C9020656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFDC94B0D7;
	Mon, 22 Jun 2020 05:15:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q7U+adFkjMPd; Mon, 22 Jun 2020 05:15:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCD154B0CA;
	Mon, 22 Jun 2020 05:15:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 975A54B0C9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 05:15:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 89CB5mmUF1Nb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 05:15:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 346E04B0C8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 05:15:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A5D51FB;
 Mon, 22 Jun 2020 02:15:13 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.15.132])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C7A63F6CF;
 Mon, 22 Jun 2020 02:15:11 -0700 (PDT)
Date: Mon, 22 Jun 2020 10:15:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Message-ID: <20200622091508.GB88608@C02TD0UTHF1T.local>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200622080643.171651-6-maz@kernel.org>
Cc: kvm@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

T24gTW9uLCBKdW4gMjIsIDIwMjAgYXQgMDk6MDY6NDNBTSArMDEwMCwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+IFdlIGN1cnJlbnRseSBkZWNpZGUgdG8gZXhlY3V0ZSB0aGUgUHRyQXV0aCBzYXZlL3Jl
c3RvcmUgY29kZSBiYXNlZAo+IG9uIGEgc2V0IG9mIGJyYW5jaGVzIHRoYXQgZXZhbHVhdGUgYXMg
KEFSTTY0X0hBU19BRERSRVNTX0FVVEhfQVJDSCB8fAo+IEFSTTY0X0hBU19BRERSRVNTX0FVVEhf
SU1QX0RFRikuIFRoaXMgY2FuIGJlIGVhc2lseSByZXBsYWNlZCBieQo+IGEgbXVjaCBzaW1wbGVy
IHRlc3QgYXMgdGhlIEFSTTY0X0hBU19BRERSRVNTX0FVVEggY2FwYWJpbGl0eSBpcwo+IGV4YWN0
bHkgdGhpcyBleHByZXNzaW9uLgo+IAo+IFN1Z2dlc3RlZC1ieTogTWFyayBSdXRsYW5kIDxtYXJr
LnJ1dGxhbmRAYXJtLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJu
ZWwub3JnPgoKTG9va3MgZ29vZCB0byBtZS4gT25lIG1pbm9yIHN1Z2dlc3Rpb24gYmVsb3csIGJ1
dCBlaXRoZXIgd2F5OgoKQWNrZWQtYnk6IE1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5j
b20+Cgo+IC0tLQo+ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9wdHJhdXRoLmggfCAyNiAr
KysrKysrKystLS0tLS0tLS0tLS0tLS0tLQo+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25z
KCspLCAxNyBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1fcHRyYXV0aC5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fcHRyYXV0aC5o
Cj4gaW5kZXggZjE4MzAxNzNmYTllLi43YTcyNTA4YTg0MWIgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9rdm1fcHRyYXV0aC5oCj4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1fcHRyYXV0aC5oCj4gQEAgLTYxLDQ0ICs2MSwzNiBAQAo+ICAKPiAgLyoKPiAgICog
Qm90aCBwdHJhdXRoX3N3aXRjaF90b19ndWVzdCBhbmQgcHRyYXV0aF9zd2l0Y2hfdG9faG9zdCBt
YWNyb3Mgd2lsbAo+IC0gKiBjaGVjayBmb3IgdGhlIHByZXNlbmNlIG9mIG9uZSBvZiB0aGUgY3B1
ZmVhdHVyZSBmbGFnCj4gLSAqIEFSTTY0X0hBU19BRERSRVNTX0FVVEhfQVJDSCBvciBBUk02NF9I
QVNfQUREUkVTU19BVVRIX0lNUF9ERUYgYW5kCj4gKyAqIGNoZWNrIGZvciB0aGUgcHJlc2VuY2Ug
QVJNNjRfSEFTX0FERFJFU1NfQVVUSCwgd2hpY2ggaXMgZGVmaW5lZCBhcwo+ICsgKiAoQVJNNjRf
SEFTX0FERFJFU1NfQVVUSF9BUkNIIHx8IEFSTTY0X0hBU19BRERSRVNTX0FVVEhfSU1QX0RFRikg
YW5kCj4gICAqIHRoZW4gcHJvY2VlZCBhaGVhZCB3aXRoIHRoZSBzYXZlL3Jlc3RvcmUgb2YgUG9p
bnRlciBBdXRoZW50aWNhdGlvbgo+IC0gKiBrZXkgcmVnaXN0ZXJzLgo+ICsgKiBrZXkgcmVnaXN0
ZXJzIGlmIGVuYWJsZWQgZm9yIHRoZSBndWVzdC4KPiAgICovCj4gIC5tYWNybyBwdHJhdXRoX3N3
aXRjaF90b19ndWVzdCBnX2N0eHQsIHJlZzEsIHJlZzIsIHJlZzMKPiAtYWx0ZXJuYXRpdmVfaWYg
QVJNNjRfSEFTX0FERFJFU1NfQVVUSF9BUkNICj4gK2FsdGVybmF0aXZlX2lmX25vdCBBUk02NF9I
QVNfQUREUkVTU19BVVRICj4gIAliCTEwMDBmCj4gIGFsdGVybmF0aXZlX2Vsc2Vfbm9wX2VuZGlm
Cj4gLWFsdGVybmF0aXZlX2lmX25vdCBBUk02NF9IQVNfQUREUkVTU19BVVRIX0lNUF9ERUYKPiAt
CWIJMTAwMWYKPiAtYWx0ZXJuYXRpdmVfZWxzZV9ub3BfZW5kaWYKPiAtMTAwMDoKPiAgCW1ycwlc
cmVnMSwgaGNyX2VsMgo+ICAJYW5kCVxyZWcxLCBccmVnMSwgIyhIQ1JfQVBJIHwgSENSX0FQSykK
PiAtCWNieglccmVnMSwgMTAwMWYKPiArCWNieglccmVnMSwgMTAwMGYKPiAgCWFkZAlccmVnMSwg
XGdfY3R4dCwgI0NQVV9BUElBS0VZTE9fRUwxCj4gIAlwdHJhdXRoX3Jlc3RvcmVfc3RhdGUJXHJl
ZzEsIFxyZWcyLCBccmVnMwo+IC0xMDAxOgo+ICsxMDAwOgo+ICAuZW5kbQoKU2luY2UgdGhlc2Ug
YXJlIGluIG1hY3Jvcywgd2UgY291bGQgdXNlIFxAIHRvIGdlbmVyYXRlIGEgbWFjcm8tc3BlY2lm
aWMKbGF2ZWwgcmF0aGVyIHRoYW4gYSBtYWdpYyBudW1iZXIsIHdoaWNoIHdvdWxkIGJlIGxlc3Mg
bGlrZWx5IHRvIGNvbmZsaWN0CndpdGggdGhlIHN1cnJvdW5kaW5nIGVudmlyb25tZW50IGFuZCB3
b3VsZCBiZSBtb3JlIGRlc2NyaXB0aXZlLiBXZSBkbwp0aGF0IGluIGEgZmV3IHBsYWNlcyBhbHJl
YWR5LCBhbmQgaGVyZSBpdCBjb3VsZCBsb29rIHNvbWV0aGluZyBsaWtlOgoKfCBhbHRlcm5hdGl2
ZV9pZl9ub3QgQVJNNjRfSEFTX0FERFJFU1NfQVVUSAp8IAliCS5MX19za2lwX3BhdXRoX3N3aXRj
aFxACnwgYWx0ZXJuYXRpdmVfZWxzZV9ub3BfZW5kaWYKfCAJCnwgCS4uLgp8IAp8IC5MX19za2lw
X3BhdXRoX3N3aXRjaFxAOgoKUGVyIHRoZSBnYXMgZG9jdW1lbnRhdGlvbgoKfCBcQAp8CnwgICAg
YXMgbWFpbnRhaW5zIGEgY291bnRlciBvZiBob3cgbWFueSBtYWNyb3MgaXQgaGFzIGV4ZWN1dGVk
IGluIHRoaXMKfCAgICBwc2V1ZG8tdmFyaWFibGU7IHlvdSBjYW4gY29weSB0aGF0IG51bWJlciB0
byB5b3VyIG91dHB1dCB3aXRoIOKAmFxA4oCZLAp8ICAgIGJ1dCBvbmx5IHdpdGhpbiBhIG1hY3Jv
IGRlZmluaXRpb24uCgpObyB3b3JyaWVzIGlmIHlvdSBkb24ndCB3YW50IHRvIGNoYW5nZSB0aGF0
IG5vdzsgdGhlIEFja2VkLWJ5IHN0YW5kcwplaXRoZXIgd2F5LgoKTWFyay4KCj4gIAo+ICAubWFj
cm8gcHRyYXV0aF9zd2l0Y2hfdG9faG9zdCBnX2N0eHQsIGhfY3R4dCwgcmVnMSwgcmVnMiwgcmVn
Mwo+IC1hbHRlcm5hdGl2ZV9pZiBBUk02NF9IQVNfQUREUkVTU19BVVRIX0FSQ0gKPiArYWx0ZXJu
YXRpdmVfaWZfbm90IEFSTTY0X0hBU19BRERSRVNTX0FVVEgKPiAgCWIJMjAwMGYKPiAgYWx0ZXJu
YXRpdmVfZWxzZV9ub3BfZW5kaWYKPiAtYWx0ZXJuYXRpdmVfaWZfbm90IEFSTTY0X0hBU19BRERS
RVNTX0FVVEhfSU1QX0RFRgo+IC0JYgkyMDAxZgo+IC1hbHRlcm5hdGl2ZV9lbHNlX25vcF9lbmRp
Zgo+IC0yMDAwOgo+ICAJbXJzCVxyZWcxLCBoY3JfZWwyCj4gIAlhbmQJXHJlZzEsIFxyZWcxLCAj
KEhDUl9BUEkgfCBIQ1JfQVBLKQo+IC0JY2J6CVxyZWcxLCAyMDAxZgo+ICsJY2J6CVxyZWcxLCAy
MDAwZgo+ICAJYWRkCVxyZWcxLCBcZ19jdHh0LCAjQ1BVX0FQSUFLRVlMT19FTDEKPiAgCXB0cmF1
dGhfc2F2ZV9zdGF0ZQlccmVnMSwgXHJlZzIsIFxyZWczCj4gIAlhZGQJXHJlZzEsIFxoX2N0eHQs
ICNDUFVfQVBJQUtFWUxPX0VMMQo+ICAJcHRyYXV0aF9yZXN0b3JlX3N0YXRlCVxyZWcxLCBccmVn
MiwgXHJlZzMKPiAgCWlzYgo+IC0yMDAxOgo+ICsyMDAwOgo+ICAuZW5kbQo+ICAKPiAgI2Vsc2Ug
LyogIUNPTkZJR19BUk02NF9QVFJfQVVUSCAqLwo+IC0tIAo+IDIuMjcuMAo+IApfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
