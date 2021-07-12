Return-Path: <SRS0=bTo6=ME=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF5EC07E99
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 16:02:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8BFC61209
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 16:02:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8BFC61209
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3712A409DD;
	Mon, 12 Jul 2021 12:02:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MvADQZakXO5u; Mon, 12 Jul 2021 12:02:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC1AE40799;
	Mon, 12 Jul 2021 12:02:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4BE4066E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 12:02:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j1XLOH7cNEG5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Jul 2021 12:02:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70FBD40617
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 12:02:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A6E11FB;
 Mon, 12 Jul 2021 09:02:49 -0700 (PDT)
Received: from [10.57.36.240] (unknown [10.57.36.240])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C4933F774;
 Mon, 12 Jul 2021 09:02:47 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Disabling disabled PMU counters wastes a
 lot of time
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Alexandre Chartre <alexandre.chartre@oracle.com>, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20210712151700.654819-1-alexandre.chartre@oracle.com>
 <d4646297-da3a-c629-d0b2-b830cce6a656@arm.com>
 <90b0b99b-505c-c46c-6c2c-a45192135f5a@arm.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <74ccea1f-50b6-cf10-0b7f-3aced1d6f42e@arm.com>
Date: Mon, 12 Jul 2021 17:02:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <90b0b99b-505c-c46c-6c2c-a45192135f5a@arm.com>
Content-Language: en-GB
Cc: konrad.wilk@oracle.com
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

T24gMjAyMS0wNy0xMiAxNjo1MSwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPiBIaSBSb2JpbiwK
PiAKPiBPbiA3LzEyLzIxIDQ6NDQgUE0sIFJvYmluIE11cnBoeSB3cm90ZToKPj4gT24gMjAyMS0w
Ny0xMiAxNjoxNywgQWxleGFuZHJlIENoYXJ0cmUgd3JvdGU6Cj4+PiBJbiBhIEtWTSBndWVzdCBv
biBhcm02NCwgcGVyZm9ybWFuY2UgY291bnRlcnMgaW50ZXJydXB0cyBoYXZlIGFuCj4+PiB1bm5l
Y2Vzc2FyeSBvdmVyaGVhZCB3aGljaCBzbG93cyBkb3duIGV4ZWN1dGlvbiB3aGVuIHVzaW5nIHRo
ZSAicGVyZgo+Pj4gcmVjb3JkIiBjb21tYW5kIGFuZCBsaW1pdHMgdGhlICJwZXJmIHJlY29yZCIg
c2FtcGxpbmcgcGVyaW9kLgo+Pj4KPj4+IFRoZSBwcm9ibGVtIGlzIHRoYXQgd2hlbiBhIGd1ZXN0
IFZNIGRpc2FibGVzIGNvdW50ZXJzIGJ5IGNsZWFyaW5nIHRoZQo+Pj4gUE1DUl9FTDAuRSBiaXQg
KGJpdCAwKSwgS1ZNIHdpbGwgZGlzYWJsZSBhbGwgY291bnRlcnMgZGVmaW5lZCBpbgo+Pj4gUE1D
Ul9FTDAgZXZlbiBpZiB0aGV5IGFyZSBub3QgZW5hYmxlZCBpbiBQTUNOVEVOU0VUX0VMMC4KPj4+
Cj4+PiBLVk0gZGlzYWJsZXMgYSBjb3VudGVyIGJ5IGNhbGxpbmcgaW50byB0aGUgcGVyZiBmcmFt
ZXdvcmssIGluIHBhcnRpY3VsYXIKPj4+IGJ5IGNhbGxpbmcgcGVyZl9ldmVudF9jcmVhdGVfa2Vy
bmVsX2NvdW50ZXIoKSB3aGljaCBpcyBhIHRpbWUgY29uc3VtaW5nCj4+PiBvcGVyYXRpb24uIFNv
LCBmb3IgZXhhbXBsZSwgd2l0aCBhIE5lb3ZlcnNlIE4xIENQVSBjb3JlIHdoaWNoIGhhcyA2IGV2
ZW50Cj4+PiBjb3VudGVycyBhbmQgb25lIGN5Y2xlIGNvdW50ZXIsIEtWTSB3aWxsIGFsd2F5cyBk
aXNhYmxlIGFsbCA3IGNvdW50ZXJzCj4+PiBldmVuIGlmIG9ubHkgb25lIGlzIGVuYWJsZWQuCj4+
Pgo+Pj4gVGhpcyB0eXBpY2FsbHkgaGFwcGVucyB3aGVuIHVzaW5nIHRoZSAicGVyZiByZWNvcmQi
IGNvbW1hbmQgaW4gYSBndWVzdAo+Pj4gVk06IHBlcmYgd2lsbCBkaXNhYmxlIGFsbCBldmVudCBj
b3VudGVycyB3aXRoIFBNQ05URU5UU0VUX0VMMCBhbmQgb25seQo+Pj4gdXNlcyB0aGUgY3ljbGUg
Y291bnRlci4gQW5kIHdoZW4gdXNpbmcgdGhlICJwZXJmIHJlY29yZCIgLUYgb3B0aW9uIHdpdGgK
Pj4+IGEgaGlnaCBwcm9maWxpbmcgZnJlcXVlbmN5LCB0aGUgb3ZlcmhlYWQgb2YgS1ZNIGRpc2Fi
bGluZyBhbGwgY291bnRlcnMKPj4+IGluc3RlYWQgb2Ygb25lIG9uIGV2ZXJ5IGNvdW50ZXIgaW50
ZXJydXB0IGJlY29tZXMgdmVyeSBub3RpY2VhYmxlLgo+Pj4KPj4+IFRoZSBwcm9ibGVtIGlzIGZp
eGVkIGJ5IGhhdmluZyBLVk0gZGlzYWJsZSBvbmx5IGNvdW50ZXJzIHdoaWNoIGFyZQo+Pj4gZW5h
YmxlZCBpbiBQTUNOVEVOU0VUX0VMMC4gSWYgYSBjb3VudGVyIGlzIG5vdCBlbmFibGVkIGluIFBN
Q05URU5TRVRfRUwwCj4+PiB0aGVuIEtWTSB3aWxsIG5vdCBlbmFibGUgaXQgd2hlbiBzZXR0aW5n
IFBNQ1JfRUwwLkUgYW5kIGl0IHdpbGwgcmVtYWluCj4+PiBkaXNhYmxlZCBhcyBsb25nIGFzIGl0
IGlzIG5vdCBlbmFibGVkIGluIFBNQ05URU5TRVRfRUwwLiBTbyB0aGVyZSBpcwo+Pj4gZWZmZWN0
aXZlbHkgbm8gbmVlZCB0byBkaXNhYmxlIGEgY291bnRlciB3aGVuIGNsZWFyaW5nIFBNQ1JfRUww
LkUgaWYgaXQKPj4+IGlzIG5vdCBlbmFibGVkIFBNQ05URU5TRVRfRUwwLgo+Pj4KPj4+IFNpZ25l
ZC1vZmYtYnk6IEFsZXhhbmRyZSBDaGFydHJlIDxhbGV4YW5kcmUuY2hhcnRyZUBvcmFjbGUuY29t
Pgo+Pj4gLS0tCj4+PiBUaGUgcGF0Y2ggaXMgYmFzZWQgb24KPj4+IGh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21hei9hcm0tcGxhdGZvcm1zLmdpdC9sb2cv
P2g9a3ZtLWFybTY0L3BtdS9yZXNldC12YWx1ZXMKPj4+Cj4+PiAgwqAgYXJjaC9hcm02NC9rdm0v
cG11LWVtdWwuYyB8IDggKysrKystLS0KPj4+ICDCoCAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2
bS9wbXUtZW11bC5jIGIvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+Pj4gaW5kZXggZmFlNGU5
NWI1ODZjLi4xZjMxN2MzZGFjNjEgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9wbXUt
ZW11bC5jCj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jCj4+PiBAQCAtNTYzLDIx
ICs1NjMsMjMgQEAgdm9pZCBrdm1fcG11X3NvZnR3YXJlX2luY3JlbWVudChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsCj4+PiB1NjQgdmFsKQo+Pj4gIMKgwqAgKi8KPj4+ICDCoCB2b2lkIGt2bV9wbXVf
aGFuZGxlX3BtY3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgdmFsKQo+Pj4gIMKgIHsKPj4+
IC3CoMKgwqAgdW5zaWduZWQgbG9uZyBtYXNrID0ga3ZtX3BtdV92YWxpZF9jb3VudGVyX21hc2so
dmNwdSk7Cj4+PiArwqDCoMKgIHVuc2lnbmVkIGxvbmcgbWFzazsKPj4+ICDCoMKgwqDCoMKgIGlu
dCBpOwo+Pj4gIMKgIMKgwqDCoMKgwqAgaWYgKHZhbCAmIEFSTVY4X1BNVV9QTUNSX0UpIHsKPj4+
ICDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3BtdV9lbmFibGVfY291bnRlcl9tYXNrKHZjcHUsCj4+
PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX192Y3B1X3N5c19yZWcodmNwdSwg
UE1DTlRFTlNFVF9FTDApKTsKPj4+ICDCoMKgwqDCoMKgIH0gZWxzZSB7Cj4+PiAtwqDCoMKgwqDC
oMKgwqAga3ZtX3BtdV9kaXNhYmxlX2NvdW50ZXJfbWFzayh2Y3B1LCBtYXNrKTsKPj4+ICvCoMKg
wqDCoMKgwqDCoCBrdm1fcG11X2Rpc2FibGVfY291bnRlcl9tYXNrKHZjcHUsCj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTUNOVEVOU0VUX0VM
MCkpOwo+Pj4gIMKgwqDCoMKgwqAgfQo+Pj4gIMKgIMKgwqDCoMKgwqAgaWYgKHZhbCAmIEFSTVY4
X1BNVV9QTUNSX0MpCj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9wbXVfc2V0X2NvdW50ZXJf
dmFsdWUodmNwdSwgQVJNVjhfUE1VX0NZQ0xFX0lEWCwgMCk7Cj4+PiAgwqAgwqDCoMKgwqDCoCBp
ZiAodmFsICYgQVJNVjhfUE1VX1BNQ1JfUCkgewo+Pj4gLcKgwqDCoMKgwqDCoMKgIG1hc2sgJj0g
fkJJVChBUk1WOF9QTVVfQ1lDTEVfSURYKTsKPj4+ICvCoMKgwqDCoMKgwqDCoCBtYXNrID0ga3Zt
X3BtdV92YWxpZF9jb3VudGVyX21hc2sodmNwdSkKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICYgQklUKEFSTVY4X1BNVV9DWUNMRV9JRFgpOwo+Pgo+PiBUaGlzIGxvb2tzIHN1c3BpY2lvdXNs
eSBvcHBvc2l0ZSBvZiB3aGF0IGl0IHJlcGxhY2VzOwo+IAo+IEl0IGFsd2F5cyBzZXRzIHRoZSBi
aXQsIHdoaWNoIGdvZXMgYWdhaW5zdCB0aGUgYXJjaGl0ZWN0dXJlIGFuZCB0aGUgY29kZSBpdCB3
YXMKPiByZXBsYWNpbmcsIHllcy4KPiAKPj4gaG93ZXZlciBkaWQgd2UgZXZlbiBuZWVkIHRvIGRv
IGEgYml0d2lzZSBvcGVyYXRpb24gaGVyZSBpbiB0aGUgZmlyc3QgcGxhY2U/Cj4+IENvdWxkbid0
IHdlIHNraXAgdGhlIGN5Y2xlIGNvdW50ZXIgYnkganVzdCBsaW1pdGluZyB0aGUgZm9yX2VhY2hf
c2V0X2JpdAo+PiBpdGVyYXRpb24gYmVsb3cgdG8gMzEgYml0cz8KPiAKPiBUbyBxdW90ZSBteXNl
bGYgWzFdOgo+IAo+ICJFbnRlcnRhaW5lZCB0aGUgaWRlYSBvZiByZXN0cmljdGluZyB0aGUgbnVt
YmVyIG9mIGJpdHMgaW4gZm9yX2VhY2hfc2V0X2JpdCgpIHRvCj4gMzEgc2luY2UgTGludXggKGFu
ZCB0aGUgYXJjaGl0ZWN0dXJlLCB0byBzb21lIGRlZ3JlZSkgdHJlYXRzIHRoZSBjeWNsZSBjb3Vu
dAo+IHJlZ2lzdGVyIGFzIHRoZSAzMm5kIGV2ZW50IGNvdW50ZXIuCgpGV0lXIEkgd291bGRuJ3Qg
c2F5IHRoZXJlJ3MgYW55IGRlZ3JlZSB0byBpdCAtIHdlJ3JlIGl0ZXJhdGluZyBvdmVyIHRoZSAK
Yml0cyBpbiBhIHJlZ2lzdGVyIHdoZXJlIHRoZSBjeWNsZSBjb3VudGVyIGVuYWJsZSBpcyB1bmVx
dWl2b2NhbGx5IHRoZSAKMzJuZCBiaXQuCgo+IFNldHRsZWQgb24gdGhpcyBhcHByb2FjaCBiZWNh
dXNlIEkgdGhpbmsgaXQncwo+IGNsZWFyZXIuIgo+IAo+IFRvIGV4cGFuZCBvbiB0aGF0LCBpbmNv
cnJlY3RseSByZXNldHRpbmcgdGhlIGN5Y2xlIGNvdW50ZXIgd2FzIGludHJvZHVjZWQgYnkgYQo+
IHJlZmFjdG9yaW5nLCBzbyBJIHByZWZlcnJlZCBtYWtpbmcgaXQgdmVyeSBjbGVhciB0aGF0IFBN
Q1JfRUwwLlAgaXMgbm90IHN1cHBvc2VkCj4gdG8gY2xlYXIgdGhlIGN5Y2xlIGNvdW50ZXIuCgpG
YWlyIGVub3VnaCwgYnV0IGlmIHRoaXMgaGFzIHR1cm5lZCBvdXQgdG8gYmUgYSBjb250ZW50aW91
cyBob3QgcGF0aCAKdGhlbiBtYXNraW5nIHRoZSBiaXQgdG8gemVybyBhbmQgdGhlbiBkZWxpYmVy
YXRlbHkgaXRlcmF0aW5nIHRvIHNlZSBpZiAKaXQncyBzZXQgKGZpbmRfbmV4dF9iaXQoKSBpc24n
dCBleGFjdGx5IGZyZWUpIGFkZHMgdXAgdG8gbW9yZSBvdmVyaGVhZCAKdGhhbiBhIGNvbW1lbnQg
OykKClJvYmluLgoKPiAKPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtYXJtLzIwMjEw
NjE4MTA1MTM5LjgzNzk1LTEtYWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tLwo+IAo+IFRoYW5rcywK
PiAKPiBBbGV4Cj4gCj4+Cj4+IFJvYmluLgo+Pgo+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoCBmb3Jf
ZWFjaF9zZXRfYml0KGksICZtYXNrLCAzMikKPj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBrdm1fcG11X3NldF9jb3VudGVyX3ZhbHVlKHZjcHUsIGksIDApOwo+Pj4gIMKgwqDCoMKgwqAg
fQo+Pj4KPj4+IGJhc2UtY29tbWl0OiA4M2Y4NzBhNjYzNTkyNzk3YzU3Njg0NmRiMzYxMWUwYTE2
NjRlZGEyCj4+PgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
