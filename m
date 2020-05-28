Return-Path: <SRS0=/xnR=7K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9F0C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 11:59:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 49028215A4
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 11:59:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49028215A4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9DE44B23C;
	Thu, 28 May 2020 07:59:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jkZaEH9-uuYJ; Thu, 28 May 2020 07:59:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 710434B1B8;
	Thu, 28 May 2020 07:59:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A91A24B1BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 07:59:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mNsMBgqey3lq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2020 07:59:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69C4F4B1B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 07:59:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4602D6E;
 Thu, 28 May 2020 04:59:35 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D37283F6C4;
 Thu, 28 May 2020 04:59:34 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
To: Marc Zyngier <maz@kernel.org>
References: <20200526161834.29165-1-james.morse@arm.com>
 <20200526161834.29165-2-james.morse@arm.com>
 <4be0c0b654f7d7c1efe9f52efb856bd8@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <09dca8e9-c548-43fd-a95b-747a77f19e02@arm.com>
Date: Thu, 28 May 2020 12:59:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4be0c0b654f7d7c1efe9f52efb856bd8@kernel.org>
Content-Language: en-GB
Cc: stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

SGkgTWFyYywKCk9uIDI4LzA1LzIwMjAgMDk6NTcsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAy
MDIwLTA1LTI2IDE3OjE4LCBKYW1lcyBNb3JzZSB3cm90ZToKPj4gYWNjZXNzX2Nzc2VscigpIHVz
ZXMgdGhlIDMyYml0IHItPnJlZyB2YWx1ZSB0byBhY2Nlc3MgdGhlIDY0Yml0IGFycmF5LAo+PiBz
byByZWFkcyBhbmQgd3JpdGUgdGhlIHdyb25nIHZhbHVlLiBzeXNfcmVnc1s0XSwgaXMgQUNUTFJf
RUwxLCB3aGljaAo+PiBpcyBzdWJzZXF1ZW50bHkgc2F2ZS9yZXN0b3JlZCB3aGVuIHdlIGVudGVy
IHRoZSBndWVzdC4KCj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIGIv
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+PiBpbmRleCA1MWRiOTM0NzAyYjYuLjJlZGE1Mzlm
MzI4MSAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+PiArKysgYi9h
cmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCj4+IEBAIC0yMDYwLDcgKzIwNjAsNyBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyBjcDE1X3JlZ3NbXSA9IHsKPj4KPj4gwqDCoMKgwqAg
eyBPcDEoMSksIENSbiggMCksIENSbSggMCksIE9wMigwKSwgYWNjZXNzX2Njc2lkciB9LAo+PiDC
oMKgwqDCoCB7IE9wMSgxKSwgQ1JuKCAwKSwgQ1JtKCAwKSwgT3AyKDEpLCBhY2Nlc3NfY2xpZHIg
fSwKPj4gLcKgwqDCoCB7IE9wMSgyKSwgQ1JuKCAwKSwgQ1JtKCAwKSwgT3AyKDApLCBhY2Nlc3Nf
Y3NzZWxyLCBOVUxMLCBjMF9DU1NFTFIgfSwKPj4gK8KgwqDCoCB7IE9wMSgyKSwgQ1JuKCAwKSwg
Q1JtKCAwKSwgT3AyKDApLCBhY2Nlc3NfY3NzZWxyX2VsMSwgTlVMTCwgQ1NTRUxSX0VMMSB9LAo+
PiDCoH07Cgo+IFRoaXMgaXMgYSBkZXBhcnR1cmUgZnJvbSB0aGUgd2F5IHdlIGRlYWwgd2l0aCAz
MmJpdCBDUDE1IHJlZ2lzdGVycy4KPiBXZSBkZWFsIHdpdGggdGhpcyBleGFjdCBpc3N1ZSBpbiBh
IHZlcnkgZGlmZmVyZW50IHdheSBmb3Igb3RoZXIKPiBDUDE1IHJlZ3MsIGJ5IGFkanVzdGluZyB0
aGUgaW5kZXggaW4gdGhlIHN5c19yZWdzIGFycmF5IChzZWUgdGhlCj4gd2F5IHdlIGhhbmRsZSB0
aGUgVk0gcmVncykuCj4gCj4gSG93IGFib3V0IHNvbWV0aGluZyBsaWtlIHRoaXMgKHVudGVzdGVk
KToKCltsaWtlIGFjY2Vzc192bV9yZWcoKSBkb2VzXQoKU3VyZSwgSSdsbCBnaXZlIHRoYXQgYSB0
ZXN0IGFuZCByZS1wb3N0IGl0LgoKCj4gSWRlYWxseSwgSSdkIGxpa2UgdGhlIGNvcmUgc3lzX3Jl
ZyBjb2RlIHRvIGRlYWwgd2l0aCB0aGlzIHNvcnQKPiBvZiBmdW5uaWVzLCBidXQgSSdtIHRyeWlu
ZyB0byBrZWVwIHRoZSBjaGFuZ2UgbWluaW1hbC4uLgoKUm9sbCB0aGlzICcvMicgYW5kIHVwcGVy
L2xvd2VyIGJpdHMgc3R1ZmYgaW50byBhIHZjcHVfd3JpdGVfY3AxNV9yZWcoKSB0aGF0IGNhbGxz
CnZjcHVfd3JpdGVfc3lzX3JlZygpPyAoL21lIGh1bnRzIG91dCB0aGUgdG9kbyBsaXN0KQoKClRo
YW5rcywKCkphbWVzCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
