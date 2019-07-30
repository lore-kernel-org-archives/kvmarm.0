Return-Path: <SRS0=XAfE=V3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A684C0650F
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jul 2019 09:31:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A7F5F20665
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jul 2019 09:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7F5F20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE2A64A4FB;
	Tue, 30 Jul 2019 05:31:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6uzIMFrjKDW9; Tue, 30 Jul 2019 05:31:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9001E4A4FD;
	Tue, 30 Jul 2019 05:31:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D13A4A4EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jul 2019 05:31:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mK+rMcdyPWe5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jul 2019 05:31:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C57D4A4E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jul 2019 05:31:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 057E9344;
 Tue, 30 Jul 2019 02:31:06 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48C403F575;
 Tue, 30 Jul 2019 02:31:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when
 waiting for interrupt
To: Andrew Jones <drjones@redhat.com>
References: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
 <20190729112309.wooytkz7g6qtvvc2@kamzik.brq.redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ab4d8b69-9fc2-94a0-f5a3-01fb87c3ac44@arm.com>
Date: Tue, 30 Jul 2019 10:30:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190729112309.wooytkz7g6qtvvc2@kamzik.brq.redhat.com>
Content-Language: en-US
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

T24gNy8yOS8xOSAxMjoyMyBQTSwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+IE9uIE1vbiwgSnVsIDI5
LCAyMDE5IGF0IDEwOjI4OjUyQU0gKzAxMDAsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+IENv
bW1pdCAyMDRlODVhYTkzNTIgKCJhcm02NDogdGltZXI6IGEgZmV3IHRlc3QgaW1wcm92ZW1lbnRz
IikgYWRkZWQgYSBjYWxsCj4+IHRvIHJlcG9ydF9pbmZvIGFmdGVyIGVuYWJsaW5nIHRoZSB0aW1l
ciBhbmQgYmVmb3JlIHRoZSB3ZmkgaW5zdHJ1Y3Rpb24uIFRoZQo+PiB1YXJ0IHRoYXQgcHJpbnRm
IHVzZXMgaXMgZW11bGF0ZWQgYnkgdXNlcnNwYWNlIGFuZCBpcyBzbG93LCB3aGljaCBtYWtlcyBp
dAo+PiBtb3JlIGxpa2VseSB0aGF0IHRoZSB0aW1lciBpbnRlcnJ1cHQgd2lsbCBmaXJlIGJlZm9y
ZSBleGVjdXRpbmcgdGhlIHdmaQo+PiBpbnN0cnVjdGlvbiwgd2hpY2ggbGVhZHMgdG8gYSBkZWFk
bG9jay4KPj4KPj4gQW4gaW50ZXJydXB0IGNhbiB3YWtlIHVwIGEgQ1BVIG91dCBvZiB3ZmksIHJl
Z2FyZGxlc3Mgb2YgdGhlCj4+IFBTVEFURS57QSwgSSwgRn0gYml0cy4gRml4IHRoZSBkZWFkbG9j
ayBieSBtYXNraW5nIGludGVycnVwdHMgb24gdGhlIENQVQo+PiBiZWZvcmUgZW5hYmxpbmcgdGhl
IHRpbWVyIGFuZCB1bm1hc2tpbmcgdGhlbSBhZnRlciB0aGUgd2ZpIHJldHVybnMgc28gdGhlCj4+
IENQVSBjYW4gZXhlY3V0ZSB0aGUgdGltZXIgaW50ZXJydXB0IGhhbmRsZXIuCj4+Cj4+IFN1Z2dl
c3RlZC1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KPj4gU2lnbmVkLW9m
Zi1ieTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPgo+PiAtLS0K
Pj4gIGFybS90aW1lci5jIHwgMiArKwo+PiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KQo+Pgo+PiBkaWZmIC0tZ2l0IGEvYXJtL3RpbWVyLmMgYi9hcm0vdGltZXIuYwo+PiBpbmRleCA2
ZjJhZDFkNzZhYjIuLmYyZjYwMTkyYmE2MiAxMDA2NDQKPj4gLS0tIGEvYXJtL3RpbWVyLmMKPj4g
KysrIGIvYXJtL3RpbWVyLmMKPj4gQEAgLTI0Miw5ICsyNDIsMTEgQEAgc3RhdGljIHZvaWQgdGVz
dF90aW1lcihzdHJ1Y3QgdGltZXJfaW5mbyAqaW5mbykKPj4gIAkvKiBUZXN0IFRWQUwgYW5kIElS
USB0cmlnZ2VyICovCj4+ICAJaW5mby0+aXJxX3JlY2VpdmVkID0gZmFsc2U7Cj4+ICAJaW5mby0+
d3JpdGVfdHZhbChyZWFkX3N5c3JlZyhjbnRmcnFfZWwwKSAvIDEwMCk7CS8qIDEwIG1zICovCj4+
ICsJbG9jYWxfaXJxX2Rpc2FibGUoKTsKPj4gIAlpbmZvLT53cml0ZV9jdGwoQVJDSF9USU1FUl9D
VExfRU5BQkxFKTsKPj4gIAlyZXBvcnRfaW5mbygid2FpdGluZyBmb3IgaW50ZXJydXB0Li4uIik7
Cj4+ICAJd2ZpKCk7Cj4+ICsJbG9jYWxfaXJxX2VuYWJsZSgpOwo+PiAgCWxlZnQgPSBpbmZvLT5y
ZWFkX3R2YWwoKTsKPj4gIAlyZXBvcnQoImludGVycnVwdCByZWNlaXZlZCBhZnRlciBUVkFML1dG
SSIsIGluZm8tPmlycV9yZWNlaXZlZCk7Cj4+ICAJcmVwb3J0KCJ0aW1lciBoYXMgZXhwaXJlZCAo
JWQpIiwgbGVmdCA8IDAsIGxlZnQpOwo+PiAtLSAKPj4gMi43LjQKPj4KPiBSZXZpZXdlZC1ieTog
QW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+Cj4KPiBUaGFua3MgQWxleGFuZHJ1LiBJ
dCBub3cgbWFrZXMgbW9yZSBzZW5zZSB0byBtZSB0aGF0IHdmaSB3YWtlcyB1cCBvbgo+IGFuIGlu
dGVycnVwdCwgZXZlbiB3aGVuIGludGVycnVwdHMgYXJlIG1hc2tlZCwgYXMgaXQncyBjbGVhcmx5
IHRvCj4gYXZvaWQgdGhlc2UgdHlwZXMgb2YgcmFjZXMuIEkgc2VlIHdlIGhhdmUgdGhlIHNhbWUg
dHlwZSBvZiByYWNlIGluCj4gYXJtL2dpYy5jLiBJJ2xsIHRyeSB0byBnZXQgYXJvdW5kIHRvIGZp
eGluZyB0aGF0IGF0IHNvbWUgcG9pbnQsIHVubGVzcwo+IHNvbWVib2R5IGJlYXRzIG1lIHRvIGl0
IDopCgpTb21ldGhpbmcgbGlrZSB0aGlzPyBUZXN0ZWQgd2l0aCBnaWN2My1pcGkuCgpkaWZmIC0t
Z2l0IGEvYXJtL2dpYy5jIGIvYXJtL2dpYy5jCmluZGV4IGVkNTY0MmU3NGY3MC4uZjBiZDU3Mzk4
NDJhIDEwMDY0NAotLS0gYS9hcm0vZ2ljLmMKKysrIGIvYXJtL2dpYy5jCkBAIC0yMjAsMTIgKzIy
MCwxMiBAQCBzdGF0aWMgdm9pZCBpcGlfZW5hYmxlKHZvaWQpCsKgI2Vsc2UKwqDCoMKgwqDCoMKg
wqAgaW5zdGFsbF9pcnFfaGFuZGxlcihFTDFIX0lSUSwgaXBpX2hhbmRsZXIpOwrCoCNlbmRpZgot
wqDCoMKgwqDCoMKgIGxvY2FsX2lycV9lbmFibGUoKTsKwqB9CsKgCsKgc3RhdGljIHZvaWQgaXBp
X3NlbmQodm9pZCkKwqB7CsKgwqDCoMKgwqDCoMKgIGlwaV9lbmFibGUoKTsKK8KgwqDCoMKgwqDC
oCBsb2NhbF9pcnFfZW5hYmxlKCk7CsKgwqDCoMKgwqDCoMKgIHdhaXRfb25fcmVhZHkoKTsKwqDC
oMKgwqDCoMKgwqAgaXBpX3Rlc3Rfc2VsZigpOwrCoMKgwqDCoMKgwqDCoCBpcGlfdGVzdF9zbXAo
KTsKQEAgLTIzNiw5ICsyMzYsMTMgQEAgc3RhdGljIHZvaWQgaXBpX3NlbmQodm9pZCkKwqBzdGF0
aWMgdm9pZCBpcGlfcmVjdih2b2lkKQrCoHsKwqDCoMKgwqDCoMKgwqAgaXBpX2VuYWJsZSgpOwor
wqDCoMKgwqDCoMKgIGxvY2FsX2lycV9kaXNhYmxlKCk7CsKgwqDCoMKgwqDCoMKgIGNwdW1hc2tf
c2V0X2NwdShzbXBfcHJvY2Vzc29yX2lkKCksICZyZWFkeSk7Ci3CoMKgwqDCoMKgwqAgd2hpbGUg
KDEpCivCoMKgwqDCoMKgwqAgd2hpbGUgKDEpIHsKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgbG9jYWxfaXJxX2Rpc2FibGUoKTsKwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHdm
aSgpOworwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBsb2NhbF9pcnFfZW5hYmxlKCk7CivC
oMKgwqDCoMKgwqAgfQrCoH0KwqAKwqBzdGF0aWMgdm9pZCBpcGlfdGVzdCh2b2lkICpkYXRhIF9f
dW51c2VkKQo+Cj4gZHJldwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
