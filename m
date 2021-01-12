Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B887C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 12:21:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E867F206F0
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 12:21:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E867F206F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35D9F4B1B2;
	Tue, 12 Jan 2021 07:21:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 14OHXznRzcJU; Tue, 12 Jan 2021 07:21:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00EE74B23A;
	Tue, 12 Jan 2021 07:21:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A204B1B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 07:21:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DeMZgHnSufgv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 07:20:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2851C4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 07:20:59 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A082E1042;
 Tue, 12 Jan 2021 04:20:58 -0800 (PST)
Received: from [10.57.39.145] (unknown [10.57.39.145])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 180C23F66E;
 Tue, 12 Jan 2021 04:20:54 -0800 (PST)
Subject: Re: [PATCH v3 09/21] arm64: cpufeature: Add global feature override
 facility
To: Marc Zyngier <maz@kernel.org>
References: <20210111132811.2455113-1-maz@kernel.org>
 <20210111132811.2455113-10-maz@kernel.org> <20210111184154.GC17941@gaia>
 <129db8bd3913a90c96d4cfe4f55e27a0@kernel.org>
 <a122aa5c-4af9-e236-db82-db0ed885e0a5@arm.com>
 <d98aed718a26d0455d5549d53f97db06@kernel.org>
 <a477277b3941dc6650571f8fe29fe4f6@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <7720a317-2591-3b60-41ce-772bf168bee7@arm.com>
Date: Tue, 12 Jan 2021 12:20:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a477277b3941dc6650571f8fe29fe4f6@kernel.org>
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

T24gMS8xMi8yMSAxMTo1MSBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjEtMDEtMTIg
MTE6NTAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gSGkgU3V6dWtpLAo+Pgo+PiBPbiAyMDIxLTAx
LTEyIDA5OjE3LCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+Pj4gSGkgTWFyYywKPj4+Cj4+PiBP
biAxLzExLzIxIDc6NDggUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4KPj4gWy4uLl0KPj4KPj4+
PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rZXJuZWwvY3B1ZmVhdHVyZS5jIGIvYXJjaC9hcm02
NC9rZXJuZWwvY3B1ZmVhdHVyZS5jCj4+Pj4gaW5kZXggODk0YWY2MGI5NjY5Li4wMGQ5OWU1OTNi
NjUgMTAwNjQ0Cj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9rZXJuZWwvY3B1ZmVhdHVyZS5jCj4+Pj4g
KysrIGIvYXJjaC9hcm02NC9rZXJuZWwvY3B1ZmVhdHVyZS5jCj4+Pj4gQEAgLTc3NCw2ICs3NzQs
NyBAQCBzdGF0aWMgdm9pZCBfX2luaXQgaW5pdF9jcHVfZnRyX3JlZyh1MzIgc3lzX3JlZywgdTY0
IG5ldykKPj4+PiDCoMKgwqDCoMKgIHU2NCBzdHJpY3RfbWFzayA9IH4weDBVTEw7Cj4+Pj4gwqDC
oMKgwqDCoCB1NjQgdXNlcl9tYXNrID0gMDsKPj4+PiDCoMKgwqDCoMKgIHU2NCB2YWxpZF9tYXNr
ID0gMDsKPj4+PiArwqDCoMKgIHU2NCBvdmVycmlkZV92YWwgPSAwLCBvdmVycmlkZV9tYXNrID0g
MDsKPj4+Pgo+Pj4+IMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IGFybTY0X2Z0cl9iaXRzICpmdHJw
Owo+Pj4+IMKgwqDCoMKgwqAgc3RydWN0IGFybTY0X2Z0cl9yZWcgKnJlZyA9IGdldF9hcm02NF9m
dHJfcmVnKHN5c19yZWcpOwo+Pj4+IEBAIC03ODEsOSArNzgyLDM1IEBAIHN0YXRpYyB2b2lkIF9f
aW5pdCBpbml0X2NwdV9mdHJfcmVnKHUzMiBzeXNfcmVnLCB1NjQgbmV3KQo+Pj4+IMKgwqDCoMKg
wqAgaWYgKCFyZWcpCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsKPj4+Pgo+Pj4+ICvC
oMKgwqAgaWYgKHJlZy0+b3ZlcnJpZGVfbWFzayAmJiByZWctPm92ZXJyaWRlX3ZhbCkgewo+Pj4+
ICvCoMKgwqDCoMKgwqDCoCBvdmVycmlkZV9tYXNrID0gKnJlZy0+b3ZlcnJpZGVfbWFzazsKPj4+
PiArwqDCoMKgwqDCoMKgwqAgb3ZlcnJpZGVfdmFsID0gKnJlZy0+b3ZlcnJpZGVfdmFsOwo+Pj4+
ICvCoMKgwqAgfQo+Pj4+ICsKPj4+PiDCoMKgwqDCoMKgIGZvciAoZnRycCA9IHJlZy0+ZnRyX2Jp
dHM7IGZ0cnAtPndpZHRoOyBmdHJwKyspIHsKPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgdTY0IGZ0
cl9tYXNrID0gYXJtNjRfZnRyX21hc2soZnRycCk7Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHM2
NCBmdHJfbmV3ID0gYXJtNjRfZnRyX3ZhbHVlKGZ0cnAsIG5ldyk7Cj4+Pj4gK8KgwqDCoMKgwqDC
oMKgIHM2NCBmdHJfb3ZyID0gYXJtNjRfZnRyX3ZhbHVlKGZ0cnAsIG92ZXJyaWRlX3ZhbCk7Cj4+
Pj4gKwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoKGZ0cl9tYXNrICYgb3ZlcnJpZGVfbWFzaykg
PT0gZnRyX21hc2spIHsKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoZnRyX292ciA8
IGZ0cl9uZXcpIHsKPj4+Cj4+PiBIZXJlIHdlIGFzc3VtZSB0aGF0IGFsbCB0aGUgZmVhdHVyZXMg
YXJlIEZUUl9MT1dFUl9TQUZFLiBXZSBjb3VsZAo+Pj4gcHJvYmFibHkgdXNlIGFybTY0X2Z0cl9z
YWZlX3ZhbHVlKGZ0cnAsIGZ0cl9uZXcsIGZ0cl9vdnIpIGhlcmUgPwo+Pj4gVGhhdCB3b3VsZCBj
b3ZlciB1cyBmb3IgYm90aCBISUdIRVJfU0FGRSBhbmQgTE9XRVJfU0FGRSBmZWF0dXJlcy4KPj4+
IEhvd2V2ZXIgdGhhdCBtYXkgYmUgcmVzdHJpY3RpdmUgZm9yIEZUUl9FWEFDVCwgYXMgd2UgdGhl
IHNhZmUKPj4+IHZhbHVlIHdvdWxkIGJlIHNldCB0byAiZnRyLT5zYWZlX3ZhbCIuIEkgZ3Vlc3Mg
dGhhdCBtYXkgYmUgYmV0dGVyCj4+PiB0aGFuIGZvcmNpbmcgdG8gdXNlIGFuIHVuc2FmZSB2YWx1
ZSBmb3IgdGhlIGJvb3QgQ1BVLCB3aGljaCBjb3VsZAo+Pj4gYW55d2F5IGNvbmZsaWN0IHdpdGgg
dGhlIG90aGVyIENQVXMgYW5kIGV2ZW50dWFsbHkgdHJpZ2dlciB0aGUKPj4+IGZ0ciBhbHVlIHRv
IGJlIHNhZmVfdmFsLgo+Pgo+PiBJIGxpa2UgdGhlIGlkZWEgb2YgdXNpbmcgdGhlIGhlbHBlciwg
YXMgaXQgY2xlYW51cHMgdXAgdGhlIGNvZGUgYSBiaXQuCj4+IEhvd2V2ZXIsIG5vdCBiZWluZyB0
byBzZXQgYSBmZWF0dXJlIHRvIGEgY2VydGFpbiB2YWx1ZSBjb3VsZCBiZSByZXN0cmljdGl2ZSwK
Pj4gYXMgaW4gZ2VuZXJhbCwgaXQgbWVhbnMgdGhhdCB3ZSBjYW4gb25seSBkaXNhYmxlIGEgZmVh
dHVyZSBhbmQgbm90IGFkanVzdAo+PiBpdHMgbGV2ZWwgb2Ygc3VwcG9ydC4KPj4KPj4gVGFrZSBQ
TVVWRVIgZm9yIGV4YW1wbGU6IHdpdGggdGhlIGhlbHBlciwgSSBjYW4ndCBvdmVycmlkZSBpdCBm
cm9tIHY4LjQgdG8KPj4gdjguMS4gSSBjYW4gb25seSBnbyB0byB2OC4wLgo+IAo+IEFjdHVhbGx5
LCB3ZSBjYW4gb25seSAqZGlzYWJsZSogdGhlIFBNVSBhbHRvZ2V0aGVyLiBTYW1lIHF1ZXN0aW9u
IHRob3VnaC4uLgoKSXQgZGVwZW5kcyBvbiB0d28gdGhpbmdzIDoKCjEpIFdoYXQgaXMgdGhlIHNh
ZmUgdmFsdWUgZm9yIGFuIEVYQUNUIHR5cGVkIGZlYXR1cmUgPwpVc3VhbGx5LCB0aGF0IG1lYW5z
IGVpdGhlciBkaXNhYmxlZCwgb3IgdGhlIGxvd2VzdCBwb3NzaWJsZSB2YWx1ZS4KCjIpIEhvdyBp
cyB0aGlzIHZhbHVlIGNvbnN1bWVkID8KICAgYSkgaS5lLCBEbyB3ZSB1c2UgdGhlIHBlci1DUFUg
dmFsdWUKCVRoZW4gbm9uZSBvZiB0aGVzZSBjaGFuZ2VzIGhhdmUgYW55IGVmZmVjdAogICBiKSBT
eXN0ZW0gd2lkZSB2YWx1ZSA/CiAgICAgICBUaGVuIHdlIGdldCB0aGUgc2FmZSB2YWx1ZSBhcyAi
aW5mbHVlbmNlZCIgYnkgdGhlIGluZnJhc3RydWN0dXJlLgoKVGhlIHNhZmUgdmFsdWUgd2UgdXNl
IGZvciBFWEFDVCBmZWF0dXJlcyBpcyBleGNsdXNpdmVseSBmb3IgbWFraW5nIHN1cmUKdGhhdCB0
aGUgc3lzdGVtIHVzZXMgdGhlIHNhZmUgYXNzdW1wdGlvbiBhbmQgdGh1cyBzaG91bGQgYmUgdGhl
IGJlc3QKb3B0aW9uLgoKVG8gYW5zd2VyIHlvdXIgcXVlc3Rpb24sIGZvciBQTVUsIGl0IGlzIDAs
IGltcGxpZXMsIHY4LjAuIE9yIHdlIGNvdWxkCnVwZGF0ZSB0aGUgc2FmZSB2YWx1ZSB0byAtMSAo
MHhmKSBhcyB0aGUgc2FmZSB2YWx1ZSwgd2hpY2ggaXMgYSBiaXQgbW9yZSBzYWZlciwKa2luZCBv
ZiBpbXBseWluZyB0aGF0IHRoZSBQTVUgaXMgbm90IGEgc3RhbmRhcmQgb25lLgoKCkNoZWVycwpT
dXp1a2kKCgoKPiAKPiAgwqDCoMKgwqDCoMKgwqAgTS4KPiAKPj4KPj4gSXMgaXQgc29tZXRoaW5n
IHdlIGNhcmUgYWJvdXQ/Cj4+Cj4+IFRoYW5rcywKPj4KPj4gwqDCoMKgwqDCoMKgwqAgTS4KPiAK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
