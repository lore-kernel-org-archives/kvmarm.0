Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDE6C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 11:59:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B408422226
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 11:59:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B408422226
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6734B2CF;
	Tue, 12 Jan 2021 06:59:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Aqba5x6TnZK6; Tue, 12 Jan 2021 06:59:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A674B242;
	Tue, 12 Jan 2021 06:59:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A0044B233
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 06:59:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mShotfKYRYCV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 06:59:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57E024B22B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 06:59:35 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB8FF1042;
 Tue, 12 Jan 2021 03:59:34 -0800 (PST)
Received: from [10.57.39.145] (unknown [10.57.39.145])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 815CA3F66E;
 Tue, 12 Jan 2021 03:59:31 -0800 (PST)
Subject: Re: [PATCH v3 09/21] arm64: cpufeature: Add global feature override
 facility
To: Marc Zyngier <maz@kernel.org>
References: <20210111132811.2455113-1-maz@kernel.org>
 <20210111132811.2455113-10-maz@kernel.org> <20210111184154.GC17941@gaia>
 <129db8bd3913a90c96d4cfe4f55e27a0@kernel.org>
 <a122aa5c-4af9-e236-db82-db0ed885e0a5@arm.com>
 <d98aed718a26d0455d5549d53f97db06@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <168970f2-89d8-4e57-ab8d-59fa52bd830a@arm.com>
Date: Tue, 12 Jan 2021 11:59:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <d98aed718a26d0455d5549d53f97db06@kernel.org>
Content-Language: en-GB
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMS8xMi8yMSAxMTo1MCBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFN1enVraSwKPiAK
PiBPbiAyMDIxLTAxLTEyIDA5OjE3LCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+PiBIaSBNYXJj
LAo+Pgo+PiBPbiAxLzExLzIxIDc6NDggUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiAKPiBbLi4u
XQo+IAo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva2VybmVsL2NwdWZlYXR1cmUuYyBiL2Fy
Y2gvYXJtNjQva2VybmVsL2NwdWZlYXR1cmUuYwo+Pj4gaW5kZXggODk0YWY2MGI5NjY5Li4wMGQ5
OWU1OTNiNjUgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0dXJlLmMK
Pj4+ICsrKyBiL2FyY2gvYXJtNjQva2VybmVsL2NwdWZlYXR1cmUuYwo+Pj4gQEAgLTc3NCw2ICs3
NzQsNyBAQCBzdGF0aWMgdm9pZCBfX2luaXQgaW5pdF9jcHVfZnRyX3JlZyh1MzIgc3lzX3JlZywg
dTY0IG5ldykKPj4+IMKgwqDCoMKgwqAgdTY0IHN0cmljdF9tYXNrID0gfjB4MFVMTDsKPj4+IMKg
wqDCoMKgwqAgdTY0IHVzZXJfbWFzayA9IDA7Cj4+PiDCoMKgwqDCoMKgIHU2NCB2YWxpZF9tYXNr
ID0gMDsKPj4+ICvCoMKgwqAgdTY0IG92ZXJyaWRlX3ZhbCA9IDAsIG92ZXJyaWRlX21hc2sgPSAw
Owo+Pj4KPj4+IMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IGFybTY0X2Z0cl9iaXRzICpmdHJwOwo+
Pj4gwqDCoMKgwqDCoCBzdHJ1Y3QgYXJtNjRfZnRyX3JlZyAqcmVnID0gZ2V0X2FybTY0X2Z0cl9y
ZWcoc3lzX3JlZyk7Cj4+PiBAQCAtNzgxLDkgKzc4MiwzNSBAQCBzdGF0aWMgdm9pZCBfX2luaXQg
aW5pdF9jcHVfZnRyX3JlZyh1MzIgc3lzX3JlZywgdTY0IG5ldykKPj4+IMKgwqDCoMKgwqAgaWYg
KCFyZWcpCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+Pj4KPj4+ICvCoMKgwqAgaWYg
KHJlZy0+b3ZlcnJpZGVfbWFzayAmJiByZWctPm92ZXJyaWRlX3ZhbCkgewo+Pj4gK8KgwqDCoMKg
wqDCoMKgIG92ZXJyaWRlX21hc2sgPSAqcmVnLT5vdmVycmlkZV9tYXNrOwo+Pj4gK8KgwqDCoMKg
wqDCoMKgIG92ZXJyaWRlX3ZhbCA9ICpyZWctPm92ZXJyaWRlX3ZhbDsKPj4+ICvCoMKgwqAgfQo+
Pj4gKwo+Pj4gwqDCoMKgwqDCoCBmb3IgKGZ0cnAgPSByZWctPmZ0cl9iaXRzOyBmdHJwLT53aWR0
aDsgZnRycCsrKSB7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgdTY0IGZ0cl9tYXNrID0gYXJtNjRf
ZnRyX21hc2soZnRycCk7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgczY0IGZ0cl9uZXcgPSBhcm02
NF9mdHJfdmFsdWUoZnRycCwgbmV3KTsKPj4+ICvCoMKgwqDCoMKgwqDCoCBzNjQgZnRyX292ciA9
IGFybTY0X2Z0cl92YWx1ZShmdHJwLCBvdmVycmlkZV92YWwpOwo+Pj4gKwo+Pj4gK8KgwqDCoMKg
wqDCoMKgIGlmICgoZnRyX21hc2sgJiBvdmVycmlkZV9tYXNrKSA9PSBmdHJfbWFzaykgewo+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGZ0cl9vdnIgPCBmdHJfbmV3KSB7Cj4+Cj4+IEhl
cmUgd2UgYXNzdW1lIHRoYXQgYWxsIHRoZSBmZWF0dXJlcyBhcmUgRlRSX0xPV0VSX1NBRkUuIFdl
IGNvdWxkCj4+IHByb2JhYmx5IHVzZSBhcm02NF9mdHJfc2FmZV92YWx1ZShmdHJwLCBmdHJfbmV3
LCBmdHJfb3ZyKSBoZXJlID8KPj4gVGhhdCB3b3VsZCBjb3ZlciB1cyBmb3IgYm90aCBISUdIRVJf
U0FGRSBhbmQgTE9XRVJfU0FGRSBmZWF0dXJlcy4KPj4gSG93ZXZlciB0aGF0IG1heSBiZSByZXN0
cmljdGl2ZSBmb3IgRlRSX0VYQUNULCBhcyB3ZSB0aGUgc2FmZQo+PiB2YWx1ZSB3b3VsZCBiZSBz
ZXQgdG8gImZ0ci0+c2FmZV92YWwiLiBJIGd1ZXNzIHRoYXQgbWF5IGJlIGJldHRlcgo+PiB0aGFu
IGZvcmNpbmcgdG8gdXNlIGFuIHVuc2FmZSB2YWx1ZSBmb3IgdGhlIGJvb3QgQ1BVLCB3aGljaCBj
b3VsZAo+PiBhbnl3YXkgY29uZmxpY3Qgd2l0aCB0aGUgb3RoZXIgQ1BVcyBhbmQgZXZlbnR1YWxs
eSB0cmlnZ2VyIHRoZQo+PiBmdHIgYWx1ZSB0byBiZSBzYWZlX3ZhbC4KPiAKPiBJIGxpa2UgdGhl
IGlkZWEgb2YgdXNpbmcgdGhlIGhlbHBlciwgYXMgaXQgY2xlYW51cHMgdXAgdGhlIGNvZGUgYSBi
aXQuCj4gSG93ZXZlciwgbm90IGJlaW5nIHRvIHNldCBhIGZlYXR1cmUgdG8gYSBjZXJ0YWluIHZh
bHVlIGNvdWxkIGJlIHJlc3RyaWN0aXZlLAo+IGFzIGluIGdlbmVyYWwsIGl0IG1lYW5zIHRoYXQg
d2UgY2FuIG9ubHkgZGlzYWJsZSBhIGZlYXR1cmUgYW5kIG5vdCBhZGp1c3QKPiBpdHMgbGV2ZWwg
b2Ygc3VwcG9ydC4KPiAKPiBUYWtlIFBNVVZFUiBmb3IgZXhhbXBsZTogd2l0aCB0aGUgaGVscGVy
LCBJIGNhbid0IG92ZXJyaWRlIGl0IGZyb20gdjguNCB0bwo+IHY4LjEuIEkgY2FuIG9ubHkgZ28g
dG8gdjguMC4KCk15IHBvaW50IGlzLCB3ZSBzZXQgdGhpcyBvbmx5IGZvciB0aGUgImluaXQiIG9m
IGNwdSBmZWF0dXJlcy4gU28sIGV2ZW4gaWYgd2UKaW5pdCB0byBhIGN1c3RvbSAsIG5vbi0oZGVm
YXVsdC1zYWZlKSB2YWx1ZSwgdGhlIHNlY29uZGFyeSBDUFVzIGNvdWxkIHNjcmVhbSwKYW5kIHRo
ZSBzeXN0ZW0gd2lkZSBzYWZlIHZhbHVlIGNvdWxkIGZhbGwgYmFjayB0byB0aGUgInNhZmUiIHZh
bHVlIGZvciBFWEFDVCBmZWF0dXJlcywKbm8gbWF0dGVyIHdoYXQgeW91IGRpZCB0byBpbml0IGl0
LgoKQWxzbywgaXQgd2lsbCBiZSBkYW5nZXJvdXMgZm9yIHRoaW5ncyBsaWtlIFBBQywgYXMgdGhl
IGxvd2VyIGxldmVsIHZhbHVlIG1heQpub3QgYmUgY29tcGF0aWJsZSB3aXRoIHRoZSAiYWN0dWFs
IiBjcHUgZmVhdHVyZSBzdXBwb3J0ZWQuCgpTbyBzaW1wbHkgc2V0dGluZyB0byBhIGxvd2VyIHZh
bHVlIGZvciBFWEFDVCBmZWF0dXJlcyBpcyBnZW5lcmFsbHkgbm90IHNhZmUsCnRob3VnaCBJIHVu
ZGVyc3RhbmQgc29tZSBhcmUgZXhjZXB0aW9ucy4KClN1enVraQoKCgo+IAo+IElzIGl0IHNvbWV0
aGluZyB3ZSBjYXJlIGFib3V0Pwo+IAo+IFRoYW5rcywKPiAKPiAgwqDCoMKgwqDCoMKgwqAgTS4K
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
