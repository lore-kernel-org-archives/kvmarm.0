Return-Path: <SRS0=WvL8=E7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F387C56202
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 18:13:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B49F12075A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 18:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B49F12075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE4724B93D;
	Wed, 25 Nov 2020 13:13:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XExHND5VGKJS; Wed, 25 Nov 2020 13:13:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA524B93E;
	Wed, 25 Nov 2020 13:13:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F2C34B936
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 13:13:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EBD-7-lKVUZK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Nov 2020 13:13:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFAFC4B935
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 13:13:11 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3860C31B;
 Wed, 25 Nov 2020 10:13:11 -0800 (PST)
Received: from [172.16.1.114] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD4F33F23F;
 Wed, 25 Nov 2020 10:13:08 -0800 (PST)
Subject: Re: [PATCH v4 2/2] arm64: kvm: Introduce MTE VCPU feature
To: Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20201026155727.36685-1-steven.price@arm.com>
 <20201026155727.36685-3-steven.price@arm.com> <X7P1VLZhBh045tsr@trantor>
 <f34b3d16-8bc7-af9d-c0e0-fb114d2465aa@arm.com>
From: James Morse <james.morse@arm.com>
Message-ID: <4212c864-805a-cef4-7138-0f8995cadf5e@arm.com>
Date: Wed, 25 Nov 2020 18:13:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f34b3d16-8bc7-af9d-c0e0-fb114d2465aa@arm.com>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgU3RldmVuLCBDYXRhbGluLAoKT24gMTgvMTEvMjAyMCAxNjowMSwgU3RldmVuIFByaWNlIHdy
b3RlOgo+IE9uIDE3LzExLzIwMjAgMTY6MDcsIENhdGFsaW4gTWFyaW5hcyB3cm90ZToKPj4gT24g
TW9uLCBPY3QgMjYsIDIwMjAgYXQgMDM6NTc6MjdQTSArMDAwMCwgU3RldmVuIFByaWNlIHdyb3Rl
Ogo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL21tdS5jIGIvYXJjaC9hcm02NC9rdm0v
bW11LmMKPj4+IGluZGV4IDE5YWFjYzdkNjRkZS4uMzhmZTI1MzEwY2ExIDEwMDY0NAo+Pj4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vbW11LmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4+
PiBAQCAtODYyLDYgKzg2MiwyNiBAQCBzdGF0aWMgaW50IHVzZXJfbWVtX2Fib3J0KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgcGh5c19hZGRyX3QKPj4+IGZhdWx0X2lwYSwKPj4+IMKgwqDCoMKgwqAg
aWYgKHZtYV9wYWdlc2l6ZSA9PSBQQUdFX1NJWkUgJiYgIWZvcmNlX3B0ZSkKPj4+IMKgwqDCoMKg
wqDCoMKgwqDCoCB2bWFfcGFnZXNpemUgPSB0cmFuc3BhcmVudF9odWdlcGFnZV9hZGp1c3QobWVt
c2xvdCwgaHZhLAo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAmcGZuLCAmZmF1bHRfaXBhKTsKPj4+ICsKPj4+ICvCoMKg
wqAgLyoKPj4+ICvCoMKgwqDCoCAqIFRoZSBvdGhlcndpc2UgcmVkdW5kYW50IHRlc3QgZm9yIHN5
c3RlbV9zdXBwb3J0c19tdGUoKSBhbGxvd3MgdGhlCj4+PiArwqDCoMKgwqAgKiBjb2RlIHRvIGJl
IGNvbXBpbGVkIG91dCB3aGVuIENPTkZJR19BUk02NF9NVEUgaXMgbm90IHByZXNlbnQuCj4+PiAr
wqDCoMKgwqAgKi8KPj4+ICvCoMKgwqAgaWYgKHN5c3RlbV9zdXBwb3J0c19tdGUoKSAmJiBrdm0t
PmFyY2gubXRlX2VuYWJsZWQgJiYgcGZuX3ZhbGlkKHBmbikpIHsKPj4+ICvCoMKgwqDCoMKgwqDC
oCAvKgo+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBWTSB3aWxsIGJlIGFibGUgdG8gc2VlIHRoZSBw
YWdlJ3MgdGFncywgc28gd2UgbXVzdCBlbnN1cmUKPj4+ICvCoMKgwqDCoMKgwqDCoMKgICogdGhl
eSBoYXZlIGJlZW4gaW5pdGlhbGlzZWQuCj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqLwo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIHN0cnVjdCBwYWdlICpwYWdlID0gcGZuX3RvX3BhZ2UocGZuKTsKPj4+ICvC
oMKgwqDCoMKgwqDCoCBsb25nIGksIG5yX3BhZ2VzID0gY29tcG91bmRfbnIocGFnZSk7Cj4+PiAr
Cj4+PiArwqDCoMKgwqDCoMKgwqAgLyogaWYgUEdfbXRlX3RhZ2dlZCBpcyBzZXQsIHRhZ3MgaGF2
ZSBhbHJlYWR5IGJlZW4gaW5pdGlhbGlzZWQgKi8KPj4+ICvCoMKgwqDCoMKgwqDCoCBmb3IgKGkg
PSAwOyBpIDwgbnJfcGFnZXM7IGkrKywgcGFnZSsrKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpZiAoIXRlc3RfYW5kX3NldF9iaXQoUEdfbXRlX3RhZ2dlZCwgJnBhZ2UtPmZsYWdzKSkK
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbXRlX2NsZWFyX3BhZ2VfdGFncyhw
YWdlX2FkZHJlc3MocGFnZSkpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4+ICvCoMKgwqAgfQo+
Pgo+PiBJZiB0aGlzIHBhZ2Ugd2FzIHN3YXBwZWQgb3V0IGFuZCBtYXBwZWQgYmFjayBpbiwgd2hl
cmUgZG9lcyB0aGUKPj4gcmVzdG9yaW5nIGZyb20gc3dhcCBoYXBwZW4/Cj4gCj4gUmVzdG9yaW5n
IGZyb20gc3dhcCBoYXBwZW5zIGFib3ZlIHRoaXMgaW4gdGhlIGNhbGwgdG8gZ2ZuX3RvX3Bmbl9w
cm90KCkKPiAKPj4gSSBtYXkgaGF2ZSBhc2tlZCBpbiB0aGUgcGFzdCwgaXMgdXNlcl9tZW1fYWJv
cnQoKSB0aGUgb25seSBwYXRoIGZvcgo+PiBtYXBwaW5nIE5vcm1hbCBwYWdlcyBpbnRvIHN0YWdl
IDI/Cj4+Cj4gCj4gVGhhdCBpcyBteSB1bmRlcnN0YW5kaW5nIChhbmQgeWVzIHlvdSBhc2tlZCBi
ZWZvcmUpIGFuZCBubyBvbmUgaGFzIGNvcnJlY3RlZCBtZSEgOykKCkEgcmVjZW50IGRpc2NvdmVy
eTogQ29weSBvbiB3cml0ZSB3aWxsIGNhdXNlIGt2bV9zZXRfc3B0ZV9oYW5kbGVyKCkgdG8gZml4
dXAgdGhlIG1hcHBpbmcKKGluc3RlYWQgb2YganVzdCBpbnZhbGlkYXRpbmcgaXQpIG9uIHRoZSBh
c3N1bXB0aW9uIHRoZSBndWVzdCBpcyBnb2luZyB0byByZWFkIHdoYXRldmVyCndhcyB3cml0dGVu
LgoKSXRzIHBvc3NpYmxlIHVzZXJfbWVtX2Fib3J0KCkgd2lsbCBnbyBhbmQgc3RvbXAgb24gdGhh
dCBtYXBwaW5nIGEgc2Vjb25kIHRpbWUsIGJ1dCBpZiB0aGUKVk1NIHRyaWdnZXJzIHRoaXMgYXQg
c3RhZ2UxLCB5b3Ugd29uJ3QgaGF2ZSBhIHZjcHUgZm9yIHRoZSB1cGRhdGUuCgoKVGhhbmtzLAoK
SmFtZXMKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
