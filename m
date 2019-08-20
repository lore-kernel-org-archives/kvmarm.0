Return-Path: <SRS0=avC1=WQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739EDC3A589
	for <kvmarm@archiver.kernel.org>; Tue, 20 Aug 2019 14:18:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EB026214DA
	for <kvmarm@archiver.kernel.org>; Tue, 20 Aug 2019 14:18:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB026214DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 407D54A57D;
	Tue, 20 Aug 2019 10:18:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YDj+a02YWJgh; Tue, 20 Aug 2019 10:18:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9C904A5B6;
	Tue, 20 Aug 2019 10:18:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6CB4A5AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Aug 2019 10:18:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z34Bo8fqFJ9t for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Aug 2019 10:18:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33F374A55F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Aug 2019 10:18:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8488E28;
 Tue, 20 Aug 2019 07:18:45 -0700 (PDT)
Received: from [10.1.196.50] (e108454-lin.cambridge.arm.com [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 493033F246;
 Tue, 20 Aug 2019 07:18:44 -0700 (PDT)
Subject: Re: KVM Arm64 and Linux-RT issues
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <cd310858-2c0f-6af1-bf82-ee1e01a2cfb8@arm.com>
 <alpine.DEB.2.21.1907270053360.1791@nanos.tec.linutronix.de>
 <86zhkzn319.wl-maz@kernel.org> <960b5ed1-6d0f-3cee-da37-6061b4946c1a@arm.com>
 <20190813125835.5v26s4iuv44lw2xg@linutronix.de>
 <adc0b2e2-3a2e-5685-8eb5-2ce927d2139e@arm.com> <865zn1nidx.wl-maz@kernel.org>
 <1f76c277-665a-e962-8cbe-b3c4ecad41b0@arm.com>
 <20190816152317.pbhctfiyurjrepju@linutronix.de>
 <e9a77a95-ce0e-27a4-acb0-e997eb656e14@arm.com>
 <20190819073321.b3q2bxnslwwmdssn@linutronix.de>
From: Julien Grall <julien.grall@arm.com>
Message-ID: <35fd274a-08ae-8bfd-3484-83676af00328@arm.com>
Date: Tue, 20 Aug 2019 15:18:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819073321.b3q2bxnslwwmdssn@linutronix.de>
Content-Language: en-US
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, anna-maria@linutronix.de,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

SGkgU2ViYXN0aWFuLAoKT24gMTkvMDgvMjAxOSAwODozMywgU2ViYXN0aWFuIEFuZHJ6ZWogU2ll
d2lvciB3cm90ZToKPiBPbiAyMDE5LTA4LTE2IDE3OjMyOjM4IFsrMDEwMF0sIEp1bGllbiBHcmFs
bCB3cm90ZToKPj4gSGkgU2ViYXN0aWFuLAo+IEhpIEp1bGllbiwKPiAKPj4gaHJ0aW1lcl9jYWxs
YmFja19ydW5uaW5nKCkgd2lsbCBiZSByZXR1cm5pbmcgdHJ1ZSBhcyB0aGUgY2FsbGJhY2sgaXMK
Pj4gcnVubmluZyBzb21ld2hlcmUgZWxzZS4gVGhpcyBtZWFucyBocnRpbWVyX3RyeV90b19jYW5j
ZWwoKQo+PiB3b3VsZCByZXR1cm4gLTEuIFRoZXJlZm9yZSBocnRpbWVyX2dyYWJfZXhwaXJ5X2xv
Y2soKSB3b3VsZAo+PiBiZSBjYWxsZWQuCj4+Cj4+IERpZCBJIG1pc3MgYW55dGhpbmc/Cj4gCj4g
bm9wZSwgeW91IGFyZSByaWdodC4gSSBhc3N1bWVkIHRoYXQgd2UgaGFkIGNvZGUgdG8gZGVhbCB3
aXRoIHRoaXMgYnV0Cj4gZGlkbid0IGZpbmQgaXTigKYKPiAKPiBkaWZmIC0tZ2l0IGEva2VybmVs
L3RpbWUvaHJ0aW1lci5jIGIva2VybmVsL3RpbWUvaHJ0aW1lci5jCj4gaW5kZXggN2Q3ZGI4ODAy
MTMxMS4uNDBkODNjNzA5NTAzZSAxMDA2NDQKPiAtLS0gYS9rZXJuZWwvdGltZS9ocnRpbWVyLmMK
PiArKysgYi9rZXJuZWwvdGltZS9ocnRpbWVyLmMKPiBAQCAtOTM0LDcgKzkzNCw3IEBAIHZvaWQg
aHJ0aW1lcl9ncmFiX2V4cGlyeV9sb2NrKGNvbnN0IHN0cnVjdCBocnRpbWVyICp0aW1lcikKPiAg
IHsKPiAgIAlzdHJ1Y3QgaHJ0aW1lcl9jbG9ja19iYXNlICpiYXNlID0gdGltZXItPmJhc2U7Cj4g
ICAKPiAtCWlmIChiYXNlICYmIGJhc2UtPmNwdV9iYXNlKSB7Cj4gKwlpZiAoYmFzZSAmJiBiYXNl
LT5jcHVfYmFzZSAmJiBiYXNlLT5pbmRleCA8IE1BU0tfU0hJRlQpIHsKCkxvd2VyIGluZGV4ZXMg
YXJlIHVzZWQgZm9yIGhhcmQgaW50ZXJydXB0LiBTbyB0aGlzIHdvdWxkIG5lZWQgdG8gYmUgYmFz
ZS0+aW5kZXggCiA+PSBNQVNLX1NISUZULgoKQnV0IEkgd2FzIHdvbmRlcmluZyB3aGV0aGVyIGNo
ZWNraW5nIHRpbWVyLT5pc19zb2Z0IHdvdWxkIG1ha2UgdGhlIGNvZGUgbW9yZSAKcmVhZGFibGU/
CgpXaGlsZSBpbnZlc3RpZ2F0aW9uIGhvdyB0aGlzIGlzIG1lYW50IHRvIHdvcmssIEkgbm90aWNl
ZCBhIGZldyBvdGhlcnMgdGhpbmdzLgoKdGltZXItPmJhc2UgY291bGQgcG90ZW50aWFsbHkgY2hh
bmdlIHVuZGVyIG91ciBmZWV0IGF0IGFueSBwb2ludCBvZiB0aW1lICh3ZSAKZG9uJ3QgaG9sZCBh
bnkgbG9jaykuIFNvIGl0IHdvdWxkIGJlIHZhbGlkIHRvIGhhdmUgYmFzZSA9PSBtaWdyYXRpb25f
YmFzZS4KCm1pZ3JhdGlvbl9jcHVfYmFzZSBkb2VzIG5vdCBoYXZlIHNvZnRpcnFfZXhwaXJ5X2xv
Y2sgaW5pdGlhbGl6ZWQuIFNvIHdlIHdvdWxkIAplbmQgdXAgdG8gdXNlIGFuIHVuaW5pdGlhbGl6
ZWQgbG9jay4gTm90ZSB0aGF0IG1pZ3JhdGlvbl9iYXNlLT5pbmRleCBpcyBhbHdheXMgCjAsIHNv
IHRoZSBjaGVjayBiYXNlLT5pbmRleCA+IE1BU0tfU0hJRlQgd291bGQgaGlkZSBpdC4KCkFsdGVy
bmF0aXZlbHksIHdlIGNvdWxkIGluaXRpYWxpemUgdGhlIHNwaW4gbG9jayBmb3IgbWlncmF0aW9u
X2NwdV9iYXNlIGF2b2lkaW5nIAp0byByZWx5IG9uIHNpZGUgZWZmZWN0IG9mIHRoZSBjaGVjay4K
CkFub3RoZXIgcG90ZW50aWFsIGlzc3VlIGlzIHRoZSBjb21waWxlciBpcyBmcmVlIHRvIHJlbG9h
ZCB0aW1lci0+YmFzZSBhdCBhbnkgCnRpbWUuIFNvIEkgdGhpbmsgd2Ugd2FudCBhbiBBQ0NFU1Nf
T05DRSguLi4pLgoKTGFzdGx5IHRpbWVyLT5iYXNlIGNhbm5vdCBiZSBOVUxMLiBGcm9tIHRoZSBj
b21tZW50IG9uIHRvcCBvZiAKbWlncmF0aW9uX2NwdV9iYXNlLCB0aW1lci0+YmFzZS0+Y3B1X2Jh
c2Ugd2lsbCBhcyB3ZWxsIG5vdCBiZSBOVUxMLgoKU28gSSB0aGluayB0aGUgZnVuY3Rpb24gY2Fu
IGJlIHJld29ya2VkIGFzOgoKdm9pZCBocnRpbWVyX2dyYWJfZXhwaXJ0eV9sb2NrKGNvbnN0IHN0
cnVjdCBocnRpbWVyICp0aW1lcikKewogICAgICAgICBzdHJ1Y3QgaHJ0aW1lcl9jbG9ja19iYXNl
ICpiYXNlID0gQUNDRVNTX09OQ0UodGltZXItPmJhc2UpOwoKICAgICAgICAgaWYgKCF0aW1lci0+
aXNfc29mdCAmJiBiYXNlICE9IG1pZ3JhdGlvbl9iYXNlICkgewogICAgICAgICAgIHNwaW5fbG9j
aygpOwogICAgICAgICAgIHNwaW5fdW5sb2NrKCk7CiAgICAgICAgIH0KfQoKCj4gICAJCXNwaW5f
bG9jaygmYmFzZS0+Y3B1X2Jhc2UtPnNvZnRpcnFfZXhwaXJ5X2xvY2spOwo+ICAgCQlzcGluX3Vu
bG9jaygmYmFzZS0+Y3B1X2Jhc2UtPnNvZnRpcnFfZXhwaXJ5X2xvY2spOwo+ICAgCX0KPiAKPiBU
aGlzIHNob3VsZCBkZWFsIHdpdGggaXQuCj4gCj4+IENoZWVycywKPiAKPiBTZWJhc3RpYW4KPiAK
Ci0tIApKdWxpZW4gR3JhbGwKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
