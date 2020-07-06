Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1B0C433DF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 12:35:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A44620715
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 12:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A44620715
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A864B2E6;
	Mon,  6 Jul 2020 08:35:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xQbi3HvkfSyJ; Mon,  6 Jul 2020 08:35:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD64E4B2F7;
	Mon,  6 Jul 2020 08:35:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CD9F4B30A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 08:35:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SyEh67LxyXDv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 08:35:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 273D44B2E6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 08:35:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1F401FB;
 Mon,  6 Jul 2020 05:35:06 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BE003F68F;
 Mon,  6 Jul 2020 05:35:04 -0700 (PDT)
Subject: Re: [PATCH v2 06/17] KVM: arm64: Introduce accessor for ctxt->sys_reg
To: Marc Zyngier <maz@kernel.org>
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-7-maz@kernel.org>
 <a9c3a43e-7850-e74d-5383-905885721ab4@arm.com>
 <2595cd556bcb8bd996f60ef527b512ef@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <35289626-8ad8-7802-1910-7677359932f4@arm.com>
Date: Mon, 6 Jul 2020 13:35:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2595cd556bcb8bd996f60ef527b512ef@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCk9uIDcvNi8yMCAxOjE1IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkgQWxl
eCwKPgo+IE9uIDIwMjAtMDYtMjYgMTY6MzksIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+IEhp
LAo+Pgo+PiBPbiA2LzE1LzIwIDI6MjcgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IEluIG9y
ZGVyIHRvIGFsbG93IHRoZSBkaXNpbnRlZ3JhdGlvbiBvZiB0aGUgcGVyLXZjcHUgc3lzcmVnIGFy
cmF5LAo+Pj4gbGV0J3MgaW50cm9kdWNlIGEgbmV3IGhlbHBlciAoY3R4dF9zeXNfcmVnKCkpIHRo
YXQgcmV0dXJucyB0aGUKPj4+IGluLW1lbW9yeSBjb3B5IG9mIGEgc3lzdGVtIHJlZ2lzdGVyLCBw
aWNrZWQgZnJvbSBhIGdpdmVuIGNvbnRleHQuCj4+Pgo+Pj4gX192Y3B1X3N5c19yZWcoKSBpcyBy
ZXdyaXR0ZW4gdG8gdXNlIHRoaXMgaGVscGVyLgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IE1hcmMg
WnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4+PiAtLS0KPj4+IMKgYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oIHwgMTUgKysrKysrKysrKy0tLS0tCj4+PiDCoDEgZmlsZSBjaGFuZ2Vk
LCAxMCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPj4+IGIvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oCj4+PiBpbmRleCBlN2ZkMDMyNzFlNTIuLjUzMTQzOTk5NDRlNyAxMDA2
NDQKPj4+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+Pj4gKysrIGIv
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCj4+PiBAQCAtNDA1LDEyICs0MDUsMTcg
QEAgc3RydWN0IGt2bV92Y3B1X2FyY2ggewo+Pj4gwqAjZGVmaW5lIHZjcHVfZ3BfcmVncyh2KcKg
wqDCoMKgwqDCoMKgICgmKHYpLT5hcmNoLmN0eHQuZ3BfcmVncykKPj4+Cj4+PiDCoC8qCj4+PiAt
ICogT25seSB1c2UgX192Y3B1X3N5c19yZWcgaWYgeW91IGtub3cgeW91IHdhbnQgdGhlIG1lbW9y
eSBiYWNrZWQgdmVyc2lvbiBvZiBhCj4+PiAtICogcmVnaXN0ZXIsIGFuZCBub3QgdGhlIG9uZSBt
b3N0IHJlY2VudGx5IGFjY2Vzc2VkIGJ5IGEgcnVubmluZyBWQ1BVLsKgIEZvcgo+Pj4gLSAqIGV4
YW1wbGUsIGZvciB1c2Vyc3BhY2UgYWNjZXNzIG9yIGZvciBzeXN0ZW0gcmVnaXN0ZXJzIHRoYXQg
YXJlIG5ldmVyIGNvbnRleHQKPj4+IC0gKiBzd2l0Y2hlZCwgYnV0IG9ubHkgZW11bGF0ZWQuCj4+
PiArICogT25seSB1c2UgX192Y3B1X3N5c19yZWcvY3R4dF9zeXNfcmVnIGlmIHlvdSBrbm93IHlv
dSB3YW50IHRoZQo+Pj4gKyAqIG1lbW9yeSBiYWNrZWQgdmVyc2lvbiBvZiBhIHJlZ2lzdGVyLCBh
bmQgbm90IHRoZSBvbmUgbW9zdCByZWNlbnRseQo+Pj4gKyAqIGFjY2Vzc2VkIGJ5IGEgcnVubmlu
ZyBWQ1BVLsKgIEZvciBleGFtcGxlLCBmb3IgdXNlcnNwYWNlIGFjY2VzcyBvcgo+Pj4gKyAqIGZv
ciBzeXN0ZW0gcmVnaXN0ZXJzIHRoYXQgYXJlIG5ldmVyIGNvbnRleHQgc3dpdGNoZWQsIGJ1dCBv
bmx5Cj4+PiArICogZW11bGF0ZWQuCj4+PiDCoCAqLwo+Pj4gLSNkZWZpbmUgX192Y3B1X3N5c19y
ZWcodixyKcKgwqDCoCAoKHYpLT5hcmNoLmN0eHQuc3lzX3JlZ3NbKHIpXSkKPj4+ICsjZGVmaW5l
IF9fY3R4dF9zeXNfcmVnKGMscinCoMKgwqAgKCYoYyktPnN5c19yZWdzWyhyKV0pCj4+PiArCj4+
PiArI2RlZmluZSBjdHh0X3N5c19yZWcoYyxyKcKgwqDCoCAoKl9fY3R4dF9zeXNfcmVnKGMscikp
Cj4+PiArCj4+PiArI2RlZmluZSBfX3ZjcHVfc3lzX3JlZyh2LHIpwqDCoMKgIChjdHh0X3N5c19y
ZWcoJih2KS0+YXJjaC5jdHh0LCAocikpKQo+Pgo+PiBUaGlzIGlzIGNvbmZ1c2luZyAtIF9fdmNw
dV9zeXNfcmVnKCkgcmV0dXJucyB0aGUgdmFsdWUsIGJ1dCBfX2N0eHRfc3lzX3JlZygpCj4+IHJl
dHVybiBhIHBvaW50ZXIgdG8gdGhlIHZhbHVlLiBCZWNhdXNlIG9mIHRoYXQsIEkgbWFkZSB0aGUg
bWlzdGFrZSBvZiB0aGlua2luZwo+PiB0aGF0IF9fdmNwdV9zeXNfcmVnKCkgcmV0dXJucyBhIHBv
aW50ZXIgd2hlbiByZXZpZXdpbmcgdGhlIG5leHQgcGF0Y2ggaW4gdGhlCj4+IHNlcmllcywgYW5k
IEkgZ290IHJlYWxseSB3b3JyaWVkIHRoYXQgc3R1ZmYgd2FzIHNlcmlvdXNseSBicm9rZW4gKGl0
IHdhcyBub3QpLgo+Cj4gVGhpcyBpcyBpbnRlbnRpb25hbCAodGhlIGJlaGF2aW91ciwgbm90IHRo
ZSBjb25mdXNpbmcgYXNwZWN0Li4uIDstKSwgYXMKPiBfX2N0eF9zeXNfcmVnKCkgZ2V0cyBmdXJ0
aGVyIHJld3JpdHRlbiBhcyBzdWNoOgo+Cj4gLSNkZWZpbmUgX19jdHh0X3N5c19yZWcoYyxyKcKg
wqDCoCAoJihjKS0+c3lzX3JlZ3NbKHIpXSkKPiArc3RhdGljIGlubGluZSB1NjQgKl9fY3R4dF9z
eXNfcmVnKGNvbnN0IHN0cnVjdCBrdm1fY3B1X2NvbnRleHQgKmN0eHQsIGludCByKQo+ICt7Cj4g
K8KgwqDCoCBpZiAodW5saWtlbHkociA+PSBfX1ZOQ1JfU1RBUlRfXyAmJiBjdHh0LT52bmNyX2Fy
cmF5KSkKPiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuICZjdHh0LT52bmNyX2FycmF5W3IgLSBfX1ZO
Q1JfU1RBUlRfX107Cj4gKwo+ICvCoMKgwqAgcmV0dXJuICh1NjQgKikmY3R4dC0+c3lzX3JlZ3Nb
cl07Cj4gK30KPgo+IHRvIGRlYWwgd2l0aCB0aGUgVk5DUiBwYWdlIChkZXBlbmRpbmcgb24gd2hl
dGhlciB5b3UgdXNlIG5lc3Rpbmcgb3Igbm90LAo+IHRoZSBzeXNyZWcgaXMgYmFja2VkIGJ5IHRo
ZSBWTkNSIHBhZ2Ugb3IgdGhlIHVzdWFsIHN5c3JlZyBhcnJheSkuCj4KPiBUbyBiZSBjbGVhciwg
dGhlcmUgc2hvdWxkbid0IGJlIG11Y2ggdXNlIG9mIF9fY3R4dF9zeXNfcmVnICh0aGVyZSBpcyBv
bmx5Cj4gMyBpbiB0aGUgY3VycmVudCBjb2RlKSwgYWxsIGZvciBnb29kIHJlYXNvbnMgKGNvcmVf
cmVnX2FkZHIgZGVmaW5pdGVseQo+IHdhbnRzIHRoZSBhZGRyZXNzIG9mIGEgcmVnaXN0ZXIpLgo+
Cj4+IEknbSBub3Qgc3VyZSB3aGF0IHRoZSByZWFzb25hYmxlIHNvbHV0aW9uIGlzLCBvciBldmVu
IGlmIHRoZXJlIGlzIG9uZS4KPj4KPj4gU29tZSB0aG91Z2h0czogd2UgY291bGQgaGF2ZSBqdXN0
IG9uZSBtYWNybywgY3R4dF9zeXNfcmVnKCkgYW5kIGRlcmVmZXJlbmNlIHRoYXQKPj4gd2hlbiB3
ZSB3YW50IHRoZSB2YWx1ZTsgd2UgY291bGQga2VlcCBib3RoIGFuZCBzd2FwIHRoZSBtYWNybyBk
ZWZpbml0aW9uczsgb3Igd2UKPj4gY291bGQgZW5jb2RlIHRoZSBmYWN0IHRoYXQgYSBtYWNybyBy
ZXR1cm5zIGEgcG9pbnRlciBpbiB0aGUgbWFjcm8gbmFtZSAoc28gd2UKPj4gd291bGQgZW5kIHVw
IHdpdGggX19jdHh0X3N5c19yZWcoKSAtPiBfX2N0eHRfc3lzX3JlZ3AoKSBhbmQgY3R4dF9zeXNf
cmVnIC0+Cj4+IF9fY3R4dF9zeXNfcmVnKCkpLgo+Pgo+PiBXaGF0IGRvIHlvdSB0aGluaz8KPgo+
IEknbSBub3Qgb3Bwb3NlZCB0byBhbnkgb2YgdGhpcywgcHJvdmlkZWQgdGhhdCBpdCBkb2Vzbid0
IGNyZWF0ZQo+IHVubmVjZXNzYXJ5IGNodXJuIGFuZCBhZGRpdGlvbmFsIGNvbmZ1c2lvbi4gSSds
bCBrZWVwIGl0IGFzIHN1Y2gKPiBpbiB0aGUgbWVhbnRpbWUsIGJ1dCBJJ20gZGVmaW5pdGVseSB3
aWxsaW5nIHRvIHRha2UgYSBwYXRjaCBnb2luZwo+IG92ZXIgdGhpcyBpZiB5b3UgdGhpbmsgdGhp
cyBpcyBuZWNlc3NhcnkuCgpUaGF0IHNvdW5kcyB2ZXJ5IHJlYXNvbmFibGUuIEknbGwgcHV0IGl0
IG9uIG15IFRPRE8gbGlzdCBhbmQgSSdsbCBnaXZlIGl0IGFub3RoZXIKbG9vayBhZnRlciB0aGUg
c2VyaWVzIGlzIG1lcmdlZC4KClRoYW5rcywKQWxleApfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
