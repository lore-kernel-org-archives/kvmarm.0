Return-Path: <SRS0=V360=D6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A6BC388F9
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 01:26:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D490B21D6C
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 01:26:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D490B21D6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E496D4B729;
	Thu, 22 Oct 2020 21:26:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q3JNG9T31xN3; Thu, 22 Oct 2020 21:26:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD4E84B781;
	Thu, 22 Oct 2020 21:26:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4B2D4B780
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2020 21:26:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 96sNRyWQKb4P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2020 21:26:10 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A7FC4B729
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2020 21:26:10 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 5B58A88F25C5B57FB2C7;
 Fri, 23 Oct 2020 09:26:06 +0800 (CST)
Received: from [10.67.76.251] (10.67.76.251) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0;
 Fri, 23 Oct 2020 09:26:00 +0800
Subject: Re: [RFC] KVM: arm64: Don't force broadcast tlbi when guest is running
To: Marc Zyngier <maz@kernel.org>
References: <1603331829-33879-1-git-send-email-zhangshaokun@hisilicon.com>
 <be1d84d42df6203ad993e8d20d9bd6da@kernel.org>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <0a7032a7-ff23-b537-fdbd-8189380d4f41@hisilicon.com>
Date: Fri, 23 Oct 2020 09:26:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <be1d84d42df6203ad993e8d20d9bd6da@kernel.org>
X-Originating-IP: [10.67.76.251]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGkgTWFyY++8jAoK5ZyoIDIwMjAvMTAvMjIgMjA6MDMsIE1hcmMgWnluZ2llciDlhpnpgZM6Cj4g
T24gMjAyMC0xMC0yMiAwMjo1NywgU2hhb2t1biBaaGFuZyB3cm90ZToKPj4gRnJvbTogTmlhbnlh
byBUYW5nIDx0YW5nbmlhbnlhb0BodWF3ZWkuY29tPgo+Pgo+PiBOb3cgSENSX0VMMi5GQiBpcyBz
ZXQgdG8gZm9yY2UgYnJvYWRjYXN0IHRsYmkgdG8gYWxsIG9ubGluZSBwY3B1cywKPj4gZXZlbiB0
aG9zZSB2Y3B1IGRvIG5vdCByZXNpZGVudCBvbi4gSXQgd291bGQgZ2V0IHdvcnNlIGFzIHN5c3Rl
bQo+PiBnZXRzIGxhcmdlciBhbmQgbW9yZSBwY3B1cyBnZXQgb25saW5lLgo+PiBMZXQncyBkaXNh
YmxlIGZvcmNlLWJyb2FkY2FzdC4gV2UgZmx1c2ggdGxiaSB3aGVuIG1vdmUgdmNwdSB0byBhCj4+
IG5ldyBwY3B1LCBpbiBjYXNlIG9sZCBwYWdlIG1hcHBpbmcgc3RpbGwgZXhpc3RzIG9uIG5ldyBw
Y3B1Lgo+Pgo+PiBDYzogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPj4gU2lnbmVkLW9m
Zi1ieTogTmlhbnlhbyBUYW5nIDx0YW5nbmlhbnlhb0BodWF3ZWkuY29tPgo+PiBTaWduZWQtb2Zm
LWJ5OiBTaGFva3VuIFpoYW5nIDx6aGFuZ3NoYW9rdW5AaGlzaWxpY29uLmNvbT4KPj4gLS0tCj4+
IMKgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fYXJtLmggfCAyICstCj4+IMKgYXJjaC9hcm02
NC9rdm0vYXJtLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCA0ICsrKy0KPj4gwqAyIGZpbGVz
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FybS5oIGIvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1fYXJtLmgKPj4gaW5kZXggNjRjZTI5Mzc4NDY3Li5mODVlYTljNjQ5Y2IgMTAwNjQ0
Cj4+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FybS5oCj4+ICsrKyBiL2FyY2gv
YXJtNjQvaW5jbHVkZS9hc20va3ZtX2FybS5oCj4+IEBAIC03NSw3ICs3NSw3IEBACj4+IMKgICog
UFRXOsKgwqDCoMKgwqDCoMKgIFRha2UgYSBzdGFnZTIgZmF1bHQgaWYgYSBzdGFnZTEgd2FsayBz
dGVwcyBpbiBkZXZpY2UgbWVtb3J5Cj4+IMKgICovCj4+IMKgI2RlZmluZSBIQ1JfR1VFU1RfRkxB
R1MgKEhDUl9UU0MgfCBIQ1JfVFNXIHwgSENSX1RXRSB8IEhDUl9UV0kgfCBIQ1JfVk0gfCBcCj4+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSENSX0JTVV9JUyB8IEhDUl9GQiB8IEhDUl9UQUMg
fCBcCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSENSX0JTVV9JUyB8IEhDUl9UQUMgfCBc
Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEhDUl9BTU8gfCBIQ1JfU1dJTyB8IEhDUl9U
SURDUCB8IEhDUl9SVyB8IEhDUl9UTE9SIHwgXAo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBIQ1JfRk1PIHwgSENSX0lNTyB8IEhDUl9QVFcgKQo+PiDCoCNkZWZpbmUgSENSX1ZJUlRfRVhD
UF9NQVNLIChIQ1JfVlNFIHwgSENSX1ZJIHwgSENSX1ZGKQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9rdm0vYXJtLmMgYi9hcmNoL2FybTY0L2t2bS9hcm0uYwo+PiBpbmRleCBhY2Y5YTk5M2Rm
YjYuLjg0NWJlOTExZjg4NSAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vYXJtLmMKPj4g
KysrIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMKPj4gQEAgLTMzNCw4ICszMzQsMTAgQEAgdm9pZCBr
dm1fYXJjaF92Y3B1X2xvYWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgY3B1KQo+PiDCoMKg
wqDCoCAvKgo+PiDCoMKgwqDCoMKgICogV2UgbWlnaHQgZ2V0IHByZWVtcHRlZCBiZWZvcmUgdGhl
IHZDUFUgYWN0dWFsbHkgcnVucywgYnV0Cj4+IMKgwqDCoMKgwqAgKiBvdmVyLWludmFsaWRhdGlv
biBkb2Vzbid0IGFmZmVjdCBjb3JyZWN0bmVzcy4KPj4gK8KgwqDCoMKgICogRGlydHkgdGxiIG1p
Z2h0IHN0aWxsIGV4aXN0IHdoZW4gdmNwdSByYW4gb24gb3RoZXIgcGNwdQo+PiArwqDCoMKgwqAg
KiBhbmQgbW9kaWZpZWQgcGFnZSBtYXBwaW5nLgo+PiDCoMKgwqDCoMKgICovCj4+IC3CoMKgwqAg
aWYgKCpsYXN0X3JhbiAhPSB2Y3B1LT52Y3B1X2lkKSB7Cj4+ICvCoMKgwqAgaWYgKCpsYXN0X3Jh
biAhPSB2Y3B1LT52Y3B1X2lkIHx8IHZjcHUtPmNwdSAhPSBjcHUpIHsKPj4gwqDCoMKgwqDCoMKg
wqDCoCBrdm1fY2FsbF9oeXAoX19rdm1fdGxiX2ZsdXNoX2xvY2FsX3ZtaWQsIG1tdSk7Cj4+IMKg
wqDCoMKgwqDCoMKgwqAgKmxhc3RfcmFuID0gdmNwdS0+dmNwdV9pZDsKPj4gwqDCoMKgwqAgfQo+
IAo+IFRoaXMgYnJlYWtzIHVuaXByb2Nlc3NvciBzZW1hbnRpY3MgZm9yIEktY2FjaGUgaW52YWxp
ZGF0aW9uLiBXaGF0IGNvdWxkCgpPb3BzLCBJdCBzaGFsbCBjb25zaWRlciB0aGlzLgoKPiBwb3Nz
aWJseSBnbyB3cm9uZz8gWW91IGFsc28gZmFpbCB0byBwcm92aWRlIGFueSBkYXRhIHRoYXQgd291
bGQgYmFjayB1cAo+IHlvdXIgY2xhaW0sIGFzIHVzdWFsLgoKVGVzdCBVbml4YmVuY2ggc3Bhd24g
aW4gZWFjaCA0VThHIHZtIG9uIEt1bnBlbmcgOTIwOgooMSkgMjQgNFU4RyBWTXMsIGVhY2ggdmNw
dSBpcyB0YXNrc2V0IHRvIG9uZSBwY3B1IHRvIG1ha2Ugc3VyZQplYWNoIHZtIHNlcGVyYXRlZC4K
KDIpIDEgNFU4RyBWTQpSZXN1bHQ6CigxKSA4MDAgKiAyNAooMikgMzIwMApCeSByZXN0cmljdGlu
ZyBEVk0gYnJvYWRjYXN0aW5nIGFjcm9zcyBOVU1BLCByZXN1bHQgKDEpIGNhbgpiZSBpbXByb3Zl
ZCB0byAyMzAwICogMjQuIEluIHNwYXduIHRlc3RjYXNlLCB0bGJpaXMgdXNlZAppbiBjcmVhdGlu
ZyBwcm9jZXNzLgpGdXJ0aGVyLCB3ZSBjb25zaWRlciByZXN0cmljdGluZyB0bGJpIGJyb2FkY2Fz
dCByYW5nZSBhbmQgbWFrZQp0bGJpIG1vcmUgYWNjdXJhdGUuCk9uZSBzY2hlbWUgaXMgcmVwbGFj
aW5nIHRsYmlpcyB3aXRoIGlwaSArIHRsYmkgKyBIQ1JfRUwyLkZCPTAuCkNvbnNpZGVyIEktY2Fj
aGUgaW52YWxpZGF0aW9uLCBLVk0gYWxzbyBuZWVkcyB0byBpbnZhbGlkIGljYWNoZQp3aGVuIG1v
dmluZyB2Y3B1IHRvIGEgbmV3IHBjcHUuCkRvIHdlIG1pc3MgYW55IGNhc2VzIHRoYXQgbmVlZCBI
Q1JfRUwyLkZCID09IDE/CkV2ZW50dWFsbHkgd2UgZXhwZWN0IEhDUl9FTDIuRkIgPT0gMCBpZiBp
dCBpcyBwb3NzaWJsZS4KClRoYW5rcywKU2hhb2t1bgoKPiAKPiDCoMKgwqDCoMKgwqDCoCBNLgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
