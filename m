Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91769C433E9
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 17:04:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7D0F23A22
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 17:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7D0F23A22
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 133404B43D;
	Fri,  8 Jan 2021 12:04:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wz2vMwqjtNDm; Fri,  8 Jan 2021 12:03:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4E8F4B445;
	Fri,  8 Jan 2021 12:03:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C9384B439
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 12:03:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QSlH0kUBkiqQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 12:03:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DD004B42C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 12:03:56 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B35E11FB;
 Fri,  8 Jan 2021 09:03:56 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 034A43F70D;
 Fri,  8 Jan 2021 09:03:53 -0800 (PST)
Subject: Re: [PATCH] KVM: arm64: Compute TPIDR_EL2 ignoring MTE tag
To: Marc Zyngier <maz@kernel.org>
References: <20210108161254.53674-1-steven.price@arm.com>
 <e49459f08d0afb30a120dfb3d6b80741@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <d26549a7-8de8-876e-0385-ebb831da4a53@arm.com>
Date: Fri, 8 Jan 2021 17:03:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e49459f08d0afb30a120dfb3d6b80741@kernel.org>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Andrey Konovalov <andreyknvl@google.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMDgvMDEvMjAyMSAxNjo1MSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFN0ZXZlbiwKPiAK
PiBPbiAyMDIxLTAxLTA4IDE2OjEyLCBTdGV2ZW4gUHJpY2Ugd3JvdGU6Cj4+IEtBU0FOIGluIEhX
X1RBR1MgbW9kZSB3aWxsIHN0b3JlIE1URSB0YWdzIGluIHRoZSB0b3AgYnl0ZSBvZiB0aGUKPj4g
cG9pbnRlci4gV2hlbiBjb21wdXRpbmcgdGhlIG9mZnNldCBmb3IgVFBJRFJfRUwyIHdlIGRvbid0
IHdhbnQgYW55dGhpbmcKPj4gaW4gdGhlIHRvcCBieXRlLCBzbyByZW1vdmUgdGhlIHRhZyB0byBl
bnN1cmUgdGhlIGNvbXB1dGF0aW9uIGlzIGNvcnJlY3QKPj4gbm8gbWF0dGVyIHdoYXQgdGhlIHRh
Zy4KPj4KPj4gRml4ZXM6IDk0YWI1YjYxZWUxNiAoImthc2FuLCBhcm02NDogZW5hYmxlIENPTkZJ
R19LQVNBTl9IV19UQUdTIikKPj4gU2lnbmVkLW9mZi1ieTogU3RldmVuIFByaWNlIDxzdGV2ZW4u
cHJpY2VAYXJtLmNvbT4KPj4gLS0tCj4+IFdpdGhvdXQgdGhpcyBmaXggSSBjYW4ndCBib290IGEg
Y29uZmlnIHdpdGggS0FTQU5fSFdfVEFHUyBhbmQgS1ZNIG9uIGFuCj4+IE1URSBlbmFibGVkIGhv
c3QuIEknbSB1bnN1cmUgaWYgdGhpcyBzaG91bGQgcmVhbGx5IGJlIGluCj4+IHRoaXNfY3B1X3B0
cl9udmhlX3N5bSgpLgo+IAo+IHRoaXNfY3B1X3B0cl9udmhlX3N5bSgpIHNob3VsZCByZXR1cm4g
c29tZXRoaW5nIHRoYXQgaXMgdmFsaWQgZm9yCj4gdGhlIEVMMSBrZXJuZWwsIHNvIEkgZ3Vlc3Mg
dW50YWdnaW5nIGluIHRoZSBoZWxwZXIgbWF5IG5vdCBiZQo+IHRoYXQgdXNlZnVsLgoKTWFrZXMg
c2Vuc2UgYW5kIHdhcyBteSBzdXNwaWNpb24uCgo+IEhvd2V2ZXIsIEknbSBtb3JlIGNvbmNlcm5l
ZCBieSBhbnl0aGluZyBhdCByZXF1aXJlcyB1cyB0byBmb2xsb3cKPiBwb2ludGVycyBzZXQgdXAg
YnkgRUwxIGF0IEVMMi4gSXQgbG9va3MgdG8gbWUgdGhhdCB0aGUgb25seSByZWFzb24KPiB0aGUg
d2hvbGUgdGhpbmcgd29ya3MgaXMgYmVjYXVzZSBrZXJuX2h5cF92YSgpICphY2NpZGVudGFsbHkq
IGRyb3BzCj4gdGFncyBiZWZvcmUgYXBwbHlpbmcgdGhlIEVMMS9FTDIgb2Zmc2V0Li4uCgpJbiB0
aGUgY2FzZSBJJ20gZml4aW5nIHRoaXMgaXMgaW50ZW5kZWQgdG8gYmUgYW4gb2Zmc2V0IGNhbGN1
bGF0aW9uIC0gCml0J3MganVzdCBtZXNzZWQgdXAgYnkgdGhlIHByZXNlbmNlIG9mIGFuIE1URSB0
YWcgaW4gb25lIG9mIHRoZSBwb2ludGVycy4KCkkgYWdyZWUgSSB3YXMgc29tZXdoYXQgc3VycHJp
c2VkIHdoZW4gZXZlcnl0aGluZyAnanVzdCB3b3JrZWQnIHdpdGggdGhpcyAKb25lIGNoYW5nZSAt
IGFuZCBJIHRoaW5rIHlvdSdyZSByaWdodCBpdCdzIGJlY2F1c2Uga2Vybl9oeXBfdmEoKSAnanVz
dCAKaGFwcGVucycgdG8gbG9zZSB0aGUgdGFncy4gT2YgY291cnNlIHRoZXJlIG1heSBiZSBvdGhl
ciBidWdzIGx1cmtpbmcgLSAKcnVubmluZyBNVEUrS0FTQU4gb24gdGhlIG1vZGVsIGlzIHNsb3cg
c28gSSBkaWRuJ3QgZG8gbXVjaCBiZXlvbmQgYm9vdCBpdC4KCk9uZSBvZiB0aGUgJ2Z1bicgdGhp
bmdzIGFib3V0IE1URSBpcyB0aGF0IHlvdSBjYW4gbm8gbG9uZ2VyIGRvIHBvaW50ZXIgCnN1YnRy
YWN0aW9uIHRvIGNhbGN1bGF0ZSB0aGUgb2Zmc2V0IHVubGVzcyB0aGUgcG9pbnRlcnMgYXJlIGFj
dHVhbGx5IApmcm9tIHRoZSBzYW1lIGFsbG9jYXRpb24gKGFuZCB0aGVyZWZvcmUgaGF2ZSB0aGUg
c2FtZSB0YWcpLiBJJ20gc3VyZSB0aGUgCkMgbGFuZ3VhZ2UgZXhwZXJ0cyB3b3VsZCBwb2ludCBv
dXQgdGhhdCdzICJhbHdheXMgYmVlbiB0aGUgY2FzZSIgYnV0IGl0IAp3aWxsIHByb2JhYmx5IGJy
ZWFrIHRoaW5ncyBlbHNld2hlcmUgdG9vLgoKU3RldmUKCj4gT3IgYW0gSSBnZXR0aW5nIGl0IHdy
b25nPwo+IAo+IFRoYW5rcywKPiAKPiAgwqDCoMKgwqDCoMKgwqAgTS4KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
