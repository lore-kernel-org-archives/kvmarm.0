Return-Path: <SRS0=rD/S=E2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769FEC5519F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D745204EF
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D745204EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D19234B4F8;
	Fri, 20 Nov 2020 04:51:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BbTp-80IsWoq; Fri, 20 Nov 2020 04:51:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82BC74B3F3;
	Fri, 20 Nov 2020 04:51:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DF554B249
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 04:50:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pOlXznVt3ndY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Nov 2020 04:50:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F23604A4CD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 04:50:57 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FF871042;
 Fri, 20 Nov 2020 01:50:57 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BD123F70D;
 Fri, 20 Nov 2020 01:50:54 -0800 (PST)
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
Date: Fri, 20 Nov 2020 09:50:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
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

T24gMTkvMTEvMjAyMCAxOToxMSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjAtMTEtMTkg
MTg6NDIsIEFuZHJldyBKb25lcyB3cm90ZToKPj4gT24gVGh1LCBOb3YgMTksIDIwMjAgYXQgMDM6
NDU6NDBQTSArMDAwMCwgUGV0ZXIgTWF5ZGVsbCB3cm90ZToKPj4+IE9uIFRodSwgMTkgTm92IDIw
MjAgYXQgMTU6MzksIFN0ZXZlbiBQcmljZSA8c3RldmVuLnByaWNlQGFybS5jb20+IHdyb3RlOgo+
Pj4gPiBUaGlzIHNlcmllcyBhZGRzIHN1cHBvcnQgZm9yIEFybSdzIE1lbW9yeSBUYWdnaW5nIEV4
dGVuc2lvbiAoTVRFKSB0bwo+Pj4gPiBLVk0sIGFsbG93aW5nIEtWTSBndWVzdHMgdG8gbWFrZSB1
c2Ugb2YgaXQuIFRoaXMgYnVpbGRzIG9uIHRoZSAKPj4+IGV4aXN0aW5nCj4+PiA+IHVzZXIgc3Bh
Y2Ugc3VwcG9ydCBhbHJlYWR5IGluIHY1LjEwLXJjMSwgc2VlIFsxXSBmb3IgYW4gb3ZlcnZpZXcu
Cj4+Pgo+Pj4gPiBUaGUgY2hhbmdlIHRvIHJlcXVpcmUgdGhlIFZNTSB0byBtYXAgYWxsIGd1ZXN0
IG1lbW9yeSBQUk9UX01URSBpcwo+Pj4gPiBzaWduaWZpY2FudCBhcyBpdCBtZWFucyB0aGF0IHRo
ZSBWTU0gaGFzIHRvIGRlYWwgd2l0aCB0aGUgTVRFIHRhZ3MgCj4+PiBldmVuCj4+PiA+IGlmIGl0
IGRvZXNuJ3QgY2FyZSBhYm91dCB0aGVtIChlLmcuIGZvciB2aXJ0dWFsIGRldmljZXMgb3IgaWYg
dGhlIFZNTQo+Pj4gPiBkb2Vzbid0IHN1cHBvcnQgbWlncmF0aW9uKS4gQWxzbyB1bmZvcnR1bmF0
ZWx5IGJlY2F1c2UgdGhlIFZNTSBjYW4KPj4+ID4gY2hhbmdlIHRoZSBtZW1vcnkgbGF5b3V0IGF0
IGFueSB0aW1lIHRoZSBjaGVjayBmb3IgUFJPVF9NVEUvVk1fTVRFIGhhcwo+Pj4gPiB0byBiZSBk
b25lIHZlcnkgbGF0ZSAoYXQgdGhlIHBvaW50IG9mIGZhdWx0aW5nIHBhZ2VzIGludG8gc3RhZ2Ug
MikuCj4+Pgo+Pj4gSSdtIGEgYml0IGR1YmlvdXMgYWJvdXQgcmVxdXJpbmcgdGhlIFZNTSB0byBt
YXAgdGhlIGd1ZXN0IG1lbW9yeQo+Pj4gUFJPVF9NVEUgdW5sZXNzIHNvbWVib2R5J3MgZG9uZSBh
dCBsZWFzdCBhIHNrZXRjaCBvZiB0aGUgZGVzaWduCj4+PiBmb3IgaG93IHRoaXMgd291bGQgd29y
ayBvbiB0aGUgUUVNVSBzaWRlLiBDdXJyZW50bHkgUUVNVSBqdXN0Cj4+PiBhc3N1bWVzIHRoZSBn
dWVzdCBtZW1vcnkgaXMgZ3Vlc3QgbWVtb3J5IGFuZCBpdCBjYW4gYWNjZXNzIGl0Cj4+PiB3aXRo
b3V0IHNwZWNpYWwgcHJlY2F1dGlvbnMuLi4KPj4+Cj4+Cj4+IFRoZXJlIGFyZSB0d28gc3RhdGVt
ZW50cyBiZWluZyBtYWRlIGhlcmU6Cj4+Cj4+IDEpIFJlcXVpcmluZyB0aGUgdXNlIG9mIFBST1Rf
TVRFIHdoZW4gbWFwcGluZyBndWVzdCBtZW1vcnkgbWF5IG5vdCBmaXQKPj4gwqDCoCBRRU1VIHdl
bGwuCj4+Cj4+IDIpIE5ldyBLVk0gZmVhdHVyZXMgc2hvdWxkIGJlIGFjY29tcGFuaWVkIHdpdGgg
c3VwcG9ydGluZyBRRU1VIGNvZGUgaW4KPj4gwqDCoCBvcmRlciB0byBwcm92ZSB0aGF0IHRoZSBB
UElzIG1ha2Ugc2Vuc2UuCj4+Cj4+IEkgc3Ryb25nbHkgYWdyZWUgd2l0aCAoMikuIFdoaWxlIGt2
bXRvb2wgc3VwcG9ydHMgc29tZSBxdWljayB0ZXN0aW5nLCBpdAo+PiBkb2Vzbid0IHN1cHBvcnQg
bWlncmF0aW9uLiBXZSBtdXN0IHRlc3QgYWxsIG5ldyBmZWF0dXJlcyB3aXRoIGEgbWlncmF0aW9u
Cj4+IHN1cHBvcnRpbmcgVk1NLgo+Pgo+PiBJJ20gbm90IHN1cmUgYWJvdXQgKDEpLiBJIGRvbid0
IGZlZWwgbGlrZSBpdCBzaG91bGQgYmUgYSBtYWpvciBwcm9ibGVtLAo+PiBidXQgKDIpLgoKKDEp
IHNlZW1zIHRvIGJlIGNvbnRlbnRpb3VzIHdoaWNoZXZlciB3YXkgd2UgZ28uIEVpdGhlciBQUk9U
X01URSBpc24ndCAKcmVxdWlyZWQgaW4gd2hpY2ggY2FzZSBpdCdzIGVhc3kgdG8gYWNjaWRlbnRh
bGx5IHNjcmV3IHVwIG1pZ3JhdGlvbiwgb3IgCml0IGlzIHJlcXVpcmVkIGluIHdoaWNoIGNhc2Ug
aXQncyBkaWZmaWN1bHQgdG8gaGFuZGxlIG5vcm1hbCBndWVzdCAKbWVtb3J5IGZyb20gdGhlIFZN
TS4gSSBnZXQgdGhlIGltcHJlc3Npb24gdGhhdCBwcm9iYWJseSBJIHNob3VsZCBnbyBiYWNrIAp0
byB0aGUgcHJldmlvdXMgYXBwcm9hY2ggLSBzb3JyeSBmb3IgdGhlIGRpc3RyYWN0aW9uIHdpdGgg
dGhpcyBjaGFuZ2UuCgooMikgaXNuJ3Qgc29tZXRoaW5nIEknbSB0cnlpbmcgdG8gc2tpcCwgYnV0
IEknbSBsaW1pdGVkIGluIHdoYXQgSSBjYW4gZG8gCm15c2VsZiBzbyB3b3VsZCBhcHByZWNpYXRl
IGhlbHAgaGVyZS4gSGFpYm8gaXMgbG9va2luZyBpbnRvIHRoaXMuCgo+Pgo+PiBJJ2QgYmUgaGFw
cHkgdG8gaGVscCB3aXRoIHRoZSBRRU1VIHByb3RvdHlwZSwgYnV0IHByZWZlcmFibHkgd2hlbiB0
aGVyZSdzCj4+IGhhcmR3YXJlIGF2YWlsYWJsZS4gSGFzIGFsbCB0aGUgY3VycmVudCBNVEUgdGVz
dGluZyBqdXN0IGJlZW4gZG9uZSBvbgo+PiBzaW11bGF0b3JzPyBBbmQsIGlmIHNvLCBhcmUgdGhl
cmUgcmVncmVzc2lvbiB0ZXN0cyByZWd1bGFybHkgcnVubmluZyBvbgo+PiB0aGUgc2ltdWxhdG9y
cyB0b28/IEFuZCBjYW4gdGhleSB0ZXN0IG1pZ3JhdGlvbj8gSWYgaGFyZHdhcmUgZG9lc24ndAo+
PiBzaG93IHVwIHF1aWNrbHkgYW5kIHNpbXVsYXRvcnMgYXJlbid0IHVzZWQgZm9yIHJlZ3Jlc3Np
b24gdGVzdHMsIHRoZW4KPj4gYWxsIHRoaXMgY29kZSB3aWxsIHN0YXJ0IHJvdHRpbmcgZnJvbSBk
YXkgb25lLgoKQXMgTWFyYyBzYXlzLCBoYXJkd2FyZSBpc24ndCBhdmFpbGFibGUuIFRlc3Rpbmcg
aXMgZWl0aGVyIHZpYSB0aGUgQXJtIApGVlAgbW9kZWwgKHRoYXQgSSd2ZSBiZWVuIHVzaW5nIGZv
ciBtb3N0IG9mIG15IHRlc3RpbmcpIG9yIFFFTVUgZnVsbCAKc3lzdGVtIGVtdWxhdGlvbi4KCj4g
Cj4gV2hpbGUgSSBhZ3JlZSB3aXRoIHRoZSBzZW50aW1lbnQsIHRoZSByZWFsaXR5IGlzIHByZXR0
eSBibGVhay4KPiAKPiBJJ20gcHJldHR5IHN1cmUgbm9ib2R5IHdpbGwgZXZlciBydW4gYSBtaWdy
YXRpb24gb24gZW11bGF0aW9uLiBJIGFsc28gZG91YnQKPiB0aGVyZSBpcyBtdWNoIG92ZXJsYXAg
YmV0d2VlbiBNVEUgdXNlcnMgYW5kIG1pZ3JhdGlvbiB1c2VycywgdW5mb3J0dW5hdGVseS4KPiAK
PiBObyBIVyBpcyBhdmFpbGFibGUgdG9kYXksIGFuZCB3aGVuIGl0IGJlY29tZXMgYXZhaWxhYmxl
LCBpdCB3aWxsIGJlIGluCj4gdGhlIGZvcm0gb2YgYSBjbG9zZWQgc3lzdGVtIG9uIHdoaWNoIFFF
TVUgZG9lc24ndCBydW4sIGVpdGhlciBiZWNhdXNlCj4gd2UgYXJlIGxvY2tlZCBvdXQgb2YgRUwy
IChhcyB1c3VhbCksIG9yIGJlY2F1c2UgbWlncmF0aW9uIGlzIG5vdCBwYXJ0IG9mCj4gdGhlIHVz
ZSBjYXNlIChsaWtlIEtWTSBvbiBBbmRyb2lkLCBmb3IgZXhhbXBsZSkuCj4gCj4gU28gd2UgY2Fu
IHdhaXQgYW5vdGhlciB0d28gKGZpdmU/KSB5ZWFycyB1bnRpbCBnZW5lcmFsIHB1cnBvc2UgSFcg
YmVjb21lcwo+IGF2YWlsYWJsZSwgb3Igd2Ugc3RhcnQgbWVyZ2luZyB3aGF0IHdlIGNhbiB0ZXN0
IHRvZGF5LiBJJ20gaW5jbGluZWQgdG8KPiBkbyB0aGUgbGF0dGVyLgo+IAo+IEFuZCBJIHRoaW5r
IGl0IGlzIGFic29sdXRlbHkgZmluZSBmb3IgUUVNVSB0byBzYXkgIm5vIE1URSBzdXBwb3J0IHdp
dGggS1ZNIgo+ICh3ZSBjYW4gcmVtb3ZlIGFsbCB1c2Vyc3BhY2UgdmlzaWJpbGl0eSwgZXhjZXB0
IGZvciB0aGUgY2FwYWJpbGl0eSkuCgpXaGF0IEknbSB0cnlpbmcgdG8gYWNoaWV2ZSBpcyBhIHNp
dHVhdGlvbiB3aGVyZSBLVk0rTVRFIHdpdGhvdXQgCm1pZ3JhdGlvbiB3b3JrcyBhbmQgd2UgbGVh
dmUgb3Vyc2VsdmVzIGEgY2xlYXIgcGF0aCB3aGVyZSBtaWdyYXRpb24gY2FuIApiZSBhZGRlZC4g
V2l0aCBoaW5kc2lnaHQgSSB0aGluayB0aGlzIHZlcnNpb24gb2YgdGhlIHNlcmllcyB3YXMgYSB3
cm9uZyAKdHVybiAtIGlmIHdlIHJldHVybiB0byBub3QgcmVxdWlyaW5nIFBST1RfTVRFIHRoZW4g
d2UgaGF2ZSB0aGUgZm9sbG93aW5nIAp0d28gcG90ZW50aWFsIG9wdGlvbnMgdG8gZXhwbG9yZSBm
b3IgbWlncmF0aW9uIGluIHRoZSBmdXR1cmU6CgogICogVGhlIFZNTSBjYW4gY2hvb3NlIHRvIGVu
YWJsZSBQUk9UX01URSBpZiBpdCBuZWVkcyB0bywgYW5kIGlmIGRlc2lyZWQgCndlIGNhbiBhZGQg
YSBmbGFnIHRvIGVuZm9yY2UgdGhpcyBpbiB0aGUga2VybmVsLgoKICAqIElmIG5lZWRlZCBhIG5l
dyBrZXJuZWwgaW50ZXJmYWNlIGNhbiBiZSBwcm92aWRlZCB0byBmZXRjaC9zZXQgdGFncyAKZnJv
bSBndWVzdCBtZW1vcnkgd2hpY2ggaXNuJ3QgbWFwcGVkIFBST1RfTVRFLgoKRG9lcyB0aGlzIHNv
dW5kIHJlYXNvbmFibGU/CgpJJ2xsIGNsZWFuIHVwIHRoZSBzZXRfcHRlX2F0KCkgY2hhbmdlIGFu
ZCBwb3N0IGEgdjYgbGF0ZXIgdG9kYXkuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
