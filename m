Return-Path: <SRS0=XAfE=V3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1675C0650F
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jul 2019 10:49:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35FC02087F
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jul 2019 10:49:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35FC02087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748EF4A54C;
	Tue, 30 Jul 2019 06:49:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FEDhfu5tl4qQ; Tue, 30 Jul 2019 06:49:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03F734A51E;
	Tue, 30 Jul 2019 06:49:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 046CF4A4F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jul 2019 06:49:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kktcWa-NqGXI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jul 2019 06:49:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B3C74A4F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jul 2019 06:49:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B05CF344;
 Tue, 30 Jul 2019 03:49:11 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 011073F575;
 Tue, 30 Jul 2019 03:49:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when
 waiting for interrupt
To: Andrew Jones <drjones@redhat.com>
References: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
 <20190729112309.wooytkz7g6qtvvc2@kamzik.brq.redhat.com>
 <ab4d8b69-9fc2-94a0-f5a3-01fb87c3ac44@arm.com>
 <20190730101215.i3geqxzwjqwyp3bz@kamzik.brq.redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e827084e-7c8c-0970-dcb0-8227d5660bff@arm.com>
Date: Tue, 30 Jul 2019 11:49:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190730101215.i3geqxzwjqwyp3bz@kamzik.brq.redhat.com>
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

T24gNy8zMC8xOSAxMToxMiBBTSwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+IE9uIFR1ZSwgSnVsIDMw
LCAyMDE5IGF0IDEwOjMwOjUwQU0gKzAxMDAsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+IE9u
IDcvMjkvMTkgMTI6MjMgUE0sIEFuZHJldyBKb25lcyB3cm90ZToKPj4+IE9uIE1vbiwgSnVsIDI5
LCAyMDE5IGF0IDEwOjI4OjUyQU0gKzAxMDAsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+Pj4g
Q29tbWl0IDIwNGU4NWFhOTM1MiAoImFybTY0OiB0aW1lcjogYSBmZXcgdGVzdCBpbXByb3ZlbWVu
dHMiKSBhZGRlZCBhIGNhbGwKPj4+PiB0byByZXBvcnRfaW5mbyBhZnRlciBlbmFibGluZyB0aGUg
dGltZXIgYW5kIGJlZm9yZSB0aGUgd2ZpIGluc3RydWN0aW9uLiBUaGUKPj4+PiB1YXJ0IHRoYXQg
cHJpbnRmIHVzZXMgaXMgZW11bGF0ZWQgYnkgdXNlcnNwYWNlIGFuZCBpcyBzbG93LCB3aGljaCBt
YWtlcyBpdAo+Pj4+IG1vcmUgbGlrZWx5IHRoYXQgdGhlIHRpbWVyIGludGVycnVwdCB3aWxsIGZp
cmUgYmVmb3JlIGV4ZWN1dGluZyB0aGUgd2ZpCj4+Pj4gaW5zdHJ1Y3Rpb24sIHdoaWNoIGxlYWRz
IHRvIGEgZGVhZGxvY2suCj4+Pj4KPj4+PiBBbiBpbnRlcnJ1cHQgY2FuIHdha2UgdXAgYSBDUFUg
b3V0IG9mIHdmaSwgcmVnYXJkbGVzcyBvZiB0aGUKPj4+PiBQU1RBVEUue0EsIEksIEZ9IGJpdHMu
IEZpeCB0aGUgZGVhZGxvY2sgYnkgbWFza2luZyBpbnRlcnJ1cHRzIG9uIHRoZSBDUFUKPj4+PiBi
ZWZvcmUgZW5hYmxpbmcgdGhlIHRpbWVyIGFuZCB1bm1hc2tpbmcgdGhlbSBhZnRlciB0aGUgd2Zp
IHJldHVybnMgc28gdGhlCj4+Pj4gQ1BVIGNhbiBleGVjdXRlIHRoZSB0aW1lciBpbnRlcnJ1cHQg
aGFuZGxlci4KPj4+Pgo+Pj4+IFN1Z2dlc3RlZC1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdp
ZXJAYXJtLmNvbT4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4YW5k
cnUuZWxpc2VpQGFybS5jb20+Cj4+Pj4gLS0tCj4+Pj4gIGFybS90aW1lci5jIHwgMiArKwo+Pj4+
ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCj4+Pj4KPj4+PiBkaWZmIC0tZ2l0IGEv
YXJtL3RpbWVyLmMgYi9hcm0vdGltZXIuYwo+Pj4+IGluZGV4IDZmMmFkMWQ3NmFiMi4uZjJmNjAx
OTJiYTYyIDEwMDY0NAo+Pj4+IC0tLSBhL2FybS90aW1lci5jCj4+Pj4gKysrIGIvYXJtL3RpbWVy
LmMKPj4+PiBAQCAtMjQyLDkgKzI0MiwxMSBAQCBzdGF0aWMgdm9pZCB0ZXN0X3RpbWVyKHN0cnVj
dCB0aW1lcl9pbmZvICppbmZvKQo+Pj4+ICAJLyogVGVzdCBUVkFMIGFuZCBJUlEgdHJpZ2dlciAq
Lwo+Pj4+ICAJaW5mby0+aXJxX3JlY2VpdmVkID0gZmFsc2U7Cj4+Pj4gIAlpbmZvLT53cml0ZV90
dmFsKHJlYWRfc3lzcmVnKGNudGZycV9lbDApIC8gMTAwKTsJLyogMTAgbXMgKi8KPj4+PiArCWxv
Y2FsX2lycV9kaXNhYmxlKCk7Cj4+Pj4gIAlpbmZvLT53cml0ZV9jdGwoQVJDSF9USU1FUl9DVExf
RU5BQkxFKTsKPj4+PiAgCXJlcG9ydF9pbmZvKCJ3YWl0aW5nIGZvciBpbnRlcnJ1cHQuLi4iKTsK
Pj4+PiAgCXdmaSgpOwo+Pj4+ICsJbG9jYWxfaXJxX2VuYWJsZSgpOwo+Pj4+ICAJbGVmdCA9IGlu
Zm8tPnJlYWRfdHZhbCgpOwo+Pj4+ICAJcmVwb3J0KCJpbnRlcnJ1cHQgcmVjZWl2ZWQgYWZ0ZXIg
VFZBTC9XRkkiLCBpbmZvLT5pcnFfcmVjZWl2ZWQpOwo+Pj4+ICAJcmVwb3J0KCJ0aW1lciBoYXMg
ZXhwaXJlZCAoJWQpIiwgbGVmdCA8IDAsIGxlZnQpOwo+Pj4+IC0tIAo+Pj4+IDIuNy40Cj4+Pj4K
Pj4+IFJldmlld2VkLWJ5OiBBbmRyZXcgSm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4KPj4+Cj4+
PiBUaGFua3MgQWxleGFuZHJ1LiBJdCBub3cgbWFrZXMgbW9yZSBzZW5zZSB0byBtZSB0aGF0IHdm
aSB3YWtlcyB1cCBvbgo+Pj4gYW4gaW50ZXJydXB0LCBldmVuIHdoZW4gaW50ZXJydXB0cyBhcmUg
bWFza2VkLCBhcyBpdCdzIGNsZWFybHkgdG8KPj4+IGF2b2lkIHRoZXNlIHR5cGVzIG9mIHJhY2Vz
LiBJIHNlZSB3ZSBoYXZlIHRoZSBzYW1lIHR5cGUgb2YgcmFjZSBpbgo+Pj4gYXJtL2dpYy5jLiBJ
J2xsIHRyeSB0byBnZXQgYXJvdW5kIHRvIGZpeGluZyB0aGF0IGF0IHNvbWUgcG9pbnQsIHVubGVz
cwo+Pj4gc29tZWJvZHkgYmVhdHMgbWUgdG8gaXQgOikKPj4gU29tZXRoaW5nIGxpa2UgdGhpcz8g
VGVzdGVkIHdpdGggZ2ljdjMtaXBpLgo+Pgo+PiBkaWZmIC0tZ2l0IGEvYXJtL2dpYy5jIGIvYXJt
L2dpYy5jCj4+IGluZGV4IGVkNTY0MmU3NGY3MC4uZjBiZDU3Mzk4NDJhIDEwMDY0NAo+PiAtLS0g
YS9hcm0vZ2ljLmMKPj4gKysrIGIvYXJtL2dpYy5jCj4+IEBAIC0yMjAsMTIgKzIyMCwxMiBAQCBz
dGF0aWMgdm9pZCBpcGlfZW5hYmxlKHZvaWQpCj4+IMKgI2Vsc2UKPj4gwqDCoMKgwqDCoMKgwqAg
aW5zdGFsbF9pcnFfaGFuZGxlcihFTDFIX0lSUSwgaXBpX2hhbmRsZXIpOwo+PiDCoCNlbmRpZgo+
PiAtwqDCoMKgwqDCoMKgIGxvY2FsX2lycV9lbmFibGUoKTsKPj4gwqB9Cj4+IMKgCj4+IMKgc3Rh
dGljIHZvaWQgaXBpX3NlbmQodm9pZCkKPj4gwqB7Cj4+IMKgwqDCoMKgwqDCoMKgIGlwaV9lbmFi
bGUoKTsKPj4gK8KgwqDCoMKgwqDCoCBsb2NhbF9pcnFfZW5hYmxlKCk7Cj4+IMKgwqDCoMKgwqDC
oMKgIHdhaXRfb25fcmVhZHkoKTsKPj4gwqDCoMKgwqDCoMKgwqAgaXBpX3Rlc3Rfc2VsZigpOwo+
PiDCoMKgwqDCoMKgwqDCoCBpcGlfdGVzdF9zbXAoKTsKPj4gQEAgLTIzNiw5ICsyMzYsMTMgQEAg
c3RhdGljIHZvaWQgaXBpX3NlbmQodm9pZCkKPj4gwqBzdGF0aWMgdm9pZCBpcGlfcmVjdih2b2lk
KQo+PiDCoHsKPj4gwqDCoMKgwqDCoMKgwqAgaXBpX2VuYWJsZSgpOwo+PiArwqDCoMKgwqDCoMKg
IGxvY2FsX2lycV9kaXNhYmxlKCk7Cj4+IMKgwqDCoMKgwqDCoMKgIGNwdW1hc2tfc2V0X2NwdShz
bXBfcHJvY2Vzc29yX2lkKCksICZyZWFkeSk7Cj4+IC3CoMKgwqDCoMKgwqAgd2hpbGUgKDEpCj4+
ICvCoMKgwqDCoMKgwqAgd2hpbGUgKDEpIHsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgbG9jYWxfaXJxX2Rpc2FibGUoKTsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHdmaSgpOwo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBsb2NhbF9pcnFfZW5hYmxl
KCk7Cj4+ICvCoMKgwqDCoMKgwqAgfQo+PiDCoH0KPj4gwqAKPj4gwqBzdGF0aWMgdm9pZCBpcGlf
dGVzdCh2b2lkICpkYXRhIF9fdW51c2VkKQo+IEknbSBub3Qgc3VyZSB3ZSBuZWVkIHRvIHdvcnJ5
IGFib3V0IGVuYWJsaW5nL2Rpc2FibGluZyBpbnRlcnJ1cHRzIGFyb3VuZAo+IHRoZSB3ZmksIHNp
bmNlIHdlJ3JlIGp1c3QgZG9pbmcgYSB0aWdodCBsb29wIG9uIGl0LiBJIHRoaW5rIHNvbWV0aGlu
ZyBsaWtlCj4gdGhpcyAodW50ZXN0ZWQpLCB3aGljaCBpcyBxdWl0ZSBzaW1pbGFyIHRvIHlvdXIg
YXBwcm9hY2gsIHNob3VsZCB3b3JrCj4KPiBkaWZmIC0tZ2l0IGEvYXJtL2dpYy5jIGIvYXJtL2dp
Yy5jCj4gaW5kZXggZWQ1NjQyZTc0ZjcwLi5jZGJiNDEzNGIwYWYgMTAwNjQ0Cj4gLS0tIGEvYXJt
L2dpYy5jCj4gKysrIGIvYXJtL2dpYy5jCj4gQEAgLTIxNCwxOCArMjE0LDE5IEBAIHN0YXRpYyB2
b2lkIGlwaV90ZXN0X3NtcCh2b2lkKQo+ICAKPiAgc3RhdGljIHZvaWQgaXBpX2VuYWJsZSh2b2lk
KQo+ICB7Cj4gKyAgICAgICBsb2NhbF9pcnFfZGlzYWJsZSgpOwo+ICAgICAgICAgZ2ljX2VuYWJs
ZV9kZWZhdWx0cygpOwo+ICAjaWZkZWYgX19hcm1fXwo+ICAgICAgICAgaW5zdGFsbF9leGNlcHRp
b25faGFuZGxlcihFWENQVE5fSVJRLCBpcGlfaGFuZGxlcik7Cj4gICNlbHNlCj4gICAgICAgICBp
bnN0YWxsX2lycV9oYW5kbGVyKEVMMUhfSVJRLCBpcGlfaGFuZGxlcik7Cj4gICNlbmRpZgo+IC0g
ICAgICAgbG9jYWxfaXJxX2VuYWJsZSgpOwo+ICB9Cj4gIAo+ICBzdGF0aWMgdm9pZCBpcGlfc2Vu
ZCh2b2lkKQo+ICB7Cj4gICAgICAgICBpcGlfZW5hYmxlKCk7Cj4gKyAgICAgICBsb2NhbF9pcnFf
ZW5hYmxlKCk7Cj4gICAgICAgICB3YWl0X29uX3JlYWR5KCk7Cj4gICAgICAgICBpcGlfdGVzdF9z
ZWxmKCk7Cj4gICAgICAgICBpcGlfdGVzdF9zbXAoKTsKPiBAQCAtMjM3LDYgKzIzOCw3IEBAIHN0
YXRpYyB2b2lkIGlwaV9yZWN2KHZvaWQpCj4gIHsKPiAgICAgICAgIGlwaV9lbmFibGUoKTsKPiAg
ICAgICAgIGNwdW1hc2tfc2V0X2NwdShzbXBfcHJvY2Vzc29yX2lkKCksICZyZWFkeSk7Cj4gKyAg
ICAgICBsb2NhbF9pcnFfZW5hYmxlKCk7Cj4gICAgICAgICB3aGlsZSAoMSkKPiAgICAgICAgICAg
ICAgICAgd2ZpKCk7Cj4gIH0KPgo+IFdoYXQgZG8geW91IHRoaW5rPwoKSSd2ZSBiZWVuIHRoaW5r
aW5nIGFib3V0IGl0IGFuZCBJIHRoaW5rIHRoYXQgdGhlIGdpYyB0ZXN0IGlzIGZpbmUgYXMgaXQg
aXMuIFRoZQpzZWNvbmRhcmllcyBhcmUgYWxyZWFkeSBzeW5jaHJvbml6ZWQgd2l0aCB0aGUgYm9v
dCBjcHUgdmlhIHRoZSByZWFkeSBtYXNrLCB3ZQpkb24ndCBjYXJlIGlmIHRoZSBzZWNvbmRhcmll
cyByZWNlaXZlIHRoZSBJUElzIGJlZm9yZSBvciBhZnRlciB0aGUgd2ZpCmluc3RydWN0aW9uLCBh
bmQgdGhleSB3aWxsIGVuZCB1cCBibG9ja2VkIGluIHdmaSBhdCB0aGUgZW5kIG9mIHRoZSB0ZXN0
IGVpdGhlcgp3YXkgKGJlY2F1c2Ugb2YgdGhlIHdoaWxlKDEpIGxvb3ApLiBBbSBJIG1pc3Npbmcg
c29tZXRoaW5nPwoKVGhhbmtzLApBbGV4Cj4KPiBUaGFua3MsCj4gZHJldwpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
