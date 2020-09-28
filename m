Return-Path: <SRS0=JNaZ=DF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53983C2D0A8
	for <kvmarm@archiver.kernel.org>; Mon, 28 Sep 2020 15:25:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6BB542100A
	for <kvmarm@archiver.kernel.org>; Mon, 28 Sep 2020 15:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BB542100A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6A574B305;
	Mon, 28 Sep 2020 11:25:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3BIEqTjxzwqd; Mon, 28 Sep 2020 11:25:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6758A4B1C0;
	Mon, 28 Sep 2020 11:25:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B6354B1B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Sep 2020 11:25:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g-dPPIiWTgl3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Sep 2020 11:25:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ECE24B1AB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Sep 2020 11:25:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98DE431B;
 Mon, 28 Sep 2020 08:25:42 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 793F63F70D;
 Mon, 28 Sep 2020 08:25:41 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Hide unsupported MPAM from the guest
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>
References: <20200925160102.118858-1-james.morse@arm.com>
 <20200926094809.f5boi5c3bnptsa7x@kamzik.brq.redhat.com>
 <d334762f56f97c4735168558dd1a5e11@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <5757de88-7c4d-e026-b82f-dbf7ad1730e3@arm.com>
Date: Mon, 28 Sep 2020 16:25:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <d334762f56f97c4735168558dd1a5e11@kernel.org>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Anshuman Khandual <anshuman.khandual@arm.com>
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

SGkgTWFyYywgRHJldywKCk9uIDI4LzA5LzIwMjAgMTI6NTIsIE1hcmMgWnluZ2llciB3cm90ZToK
PiBPbiAyMDIwLTA5LTI2IDEwOjQ4LCBBbmRyZXcgSm9uZXMgd3JvdGU6Cj4+IE9uIEZyaSwgU2Vw
IDI1LCAyMDIwIGF0IDA1OjAxOjAyUE0gKzAxMDAsIEphbWVzIE1vcnNlIHdyb3RlOgo+Pj4gQ29t
bWl0IDAxMWU1ZjViZjUyOSAoImFybTY0L2NwdWZlYXR1cmU6IEFkZCByZW1haW5pbmcgZmVhdHVy
ZSBiaXRzIGluCj4+PiBJRF9BQTY0UEZSMCByZWdpc3RlciIpIHByb2FjdGl2ZWx5IGFkZGVkIHB1
Ymxpc2hlZCBmZWF0dXJlcyB0byB0aGUKPj4+IGNwdWZlYXR1cmUgaWQgcmVnaXN0ZXJzLgo+Pj4K
Pj4+IElmIHRoZSBwbGF0Zm9ybSBzdXBwb3J0cyB0aGVzZSBmZWF0dXJlcywgdGhleSBhcmUgdmlz
aWJsZSBpbiB0aGUKPj4+IHNhbml0aXNlZCBJRCByZWdpc3RlcnMgdGhhdCBhcmUgZXhwb3NlZCB0
byBLVk0gZ3Vlc3RzLiBUaGlzIGlzIGEKPj4+IHByb2JsZW0gYXMgS1ZNIGRvZXNuJ3Qgc3VwcG9y
dCBNUEFNLgo+Pj4KPj4+IFRoZSBoYXJkd2FyZSByZXNldCBiZWhhdmlvdXIgb2YgTVBBTSBpcyB0
byBiZSBkaXNhYmxlZCBhdCBFTDMuIEl0Cj4+PiBpcyB1bmxpa2VseSBhbnlvbmUgd291bGQgc2hp
cCBhIHBsYXRmb3JtIHdpdGhvdXQgZmlybXdhcmUgc3VwcG9ydCwKPj4+IHRoZSBuZWNlc3Nhcnkg
aW5pdGlhbGlzYXRpb24gaGFzIGJlZW4gdXBzdHJlYW0gaW4gdGhlIFRGLUEgcHJvamVjdAo+Pj4g
Zm9yIG92ZXIgYSB5ZWFyLgo+Pj4KPj4+IEZpcm13YXJlIGNvbmZpZ3VyZXMgdGhlIEVMMiByZWdp
c3RlcnMgdG8gdHJhcCBFTDEgYW5kIEVMMCBhY2Nlc3MKPj4+IHRvIEVMMi4gQXMgS1ZNIGRvZXNu
J3Qgc3VwcG9ydCBNUEFNLCBpdCBkb2Vzbid0IGNoYW5nZSB0aGVzZQo+Pj4gcmVnaXN0ZXJzLiBC
b290aW5nIGFuIE1QQU0gY2FwYWJsZSBrZXJuZWwgYXMgYSBndWVzdCBvZiBtYWlubGluZQo+Pj4g
Y2F1c2VzIEtWTSB0byB0YWtlIGFuIHVua25vd24gdHJhcCBmcm9tIGFuIEVMMSBndWVzdCwgYW5k
IGluamVjdAo+Pj4gYW4gdW5kZWYgaW4gcmVzcG9uc2U6Cgo+Pj4gVGhpcyBpcyBhIHRhZCB1bmZh
aXIgb24gdGhlIGd1ZXN0IGFzIEtWTSBzYWlkIGl0IHN1cHBvcnRlZCB0aGUKPj4+IGZlYXR1cmUu
IE1hc2sgb3V0IHRoZSBNUEFNIGZlYXR1cmUuCgoKPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L2t2bS9zeXNfcmVncy5jIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gaW5kZXggMDc3
MjkzYjUxMTVmLi5mNzM2NzkxZjM3Y2EgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9z
eXNfcmVncy5jCj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCj4+PiBAQCAtMTEz
MSw2ICsxMTMxLDcgQEAgc3RhdGljIHU2NCByZWFkX2lkX3JlZyhjb25zdCBzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsCj4+PiDCoMKgwqDCoMKgwqDCoMKgIGlmICghdmNwdV9oYXNfc3ZlKHZjcHUpKQo+
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZhbCAmPSB+KDB4ZlVMIDw8IElEX0FBNjRQRlIw
X1NWRV9TSElGVCk7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgIHZhbCAmPSB+KDB4ZlVMIDw8IElEX0FB
NjRQRlIwX0FNVV9TSElGVCk7Cj4+PiArwqDCoMKgwqDCoMKgwqAgdmFsICY9IH4oMHhmVUwgPDwg
SURfQUE2NFBGUjBfTVBBTV9TSElGVCk7Cj4+PiDCoMKgwqDCoCB9IGVsc2UgaWYgKGlkID09IFNZ
U19JRF9BQTY0SVNBUjFfRUwxICYmICF2Y3B1X2hhc19wdHJhdXRoKHZjcHUpKSB7Cj4+PiDCoMKg
wqDCoMKgwqDCoMKgIHZhbCAmPSB+KCgweGZVTCA8PCBJRF9BQTY0SVNBUjFfQVBBX1NISUZUKSB8
Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoMHhmVUwgPDwgSURfQUE2NElTQVIxX0FQ
SV9TSElGVCkgfAoKCj4+IGJ1dCwgZ29pbmcgZm9yd2FyZCwgSSB0aGluayB3ZSBuZWVkIGEgbW9y
ZSByb2J1c3Qgc29sdXRpb24gdG8gQ1BVIGZlYXR1cmUKPj4gYWRkaXRpb25zIGluIG9yZGVyIHRv
IGF2b2lkIHRoZXNlIHR5cGVzIG9mIGlzc3Vlcy4gT3VyIGN1cnJlbnQgYXBwcm9hY2ggaXMKPj4g
dG8gcGF0Y2ggS1ZNIHRvIGhpZGUgZmVhdHVyZXMgZnJvbSB0aGUgZ3Vlc3QgYXMgd2UgaW50cm9k
dWNlIHN1cHBvcnQgdG8KPj4gdGhlIFtndWVzdF0ga2VybmVsLiBJT1csIHdlIGhhdmUgdG8gcmVt
ZW1iZXIgdG8gbWFpbnRhaW4gYSBndWVzdCBDUFUKPj4gZmVhdHVyZSByZWplY3QtbGlzdC4gQW5k
LCBzaW5jZSB0aGF0J3MgZXJyb3ItcHJvbmUsIHdlIHNob3VsZCBkbyByZWd1bGFyCj4+IGF1ZGl0
cyBvZiB0aGUgcmVqZWN0LWxpc3QgdG8gZW5zdXJlIGl0J3MgY29tcGxldGUuIEl0IHdvdWxkIGJl
IGJldHRlciB0bwo+PiBoYXZlIGFuIGFjY2VwdC1saXN0IChhbGwgZmVhdHVyZXMgbWFza2VkIGJ5
IGRlZmF1bHQpIGFuZCB0aGVuIG9ubHkgZXhwb3NlCj4+IGZlYXR1cmVzIGFzIHdlIGFkZCB0aGUg
S1ZNIHN1cHBvcnQuCgo+IEkgaGF2ZSBzdGFydGVkIGRvaW5nIHRoYXQgZm9yIHRoZSBOViBzZXJp
ZXMgWzFdLCBhcyBvdXIgdmlydHVhbCBDUFUgaXMgbXVjaAo+IG1vcmUgbGltaXRlZCB0aGFuIHRo
ZSBIVyBpdCBydW5zIG9uLiBJdCBzaG91bGRuJ3QgYmUgaGFyZCB0byB0dXJuIHRoaXMgaW50bwo+
IHNvbWV0aGluZyBtb3JlIGdlbmVyaWMuCgpJIHRoaW5rIGhhdmluZyB0d28gbGlzdHMgaXMgYSBw
cm9ibGVtIGFzIHRoZXkgaGF2ZSB0byBiZSBrZXB0IGluIHN5bmMuIGNwdWZlYXR1cmUgaGFzCidG
VFJfSElEREVOJyB3aGljaCBtZWFucyAiaGlkZGVuIGZyb20gdGhlIEVMMCBlbXVsYXRpb24gb2Yg
bXJzIi4gSSB0aGluayB0aGlzIHNob3VsZCBiZQpzcGxpdCBpbnRvIEZUUl9OT19HVUVTVCBhbmQg
RlRSX05PX1VTRVIgc28gdGhhdCB0aGUgcGVyc29uIGFkZGluZyB0aGUgZW50cnkgaGFzIHRvIGFu
c3dlcgp0aGUgcXVlc3Rpb24gYXMgdG8gd2hldGhlciB0aGlzIGZlYXR1cmUgaXMgdmlzaWJsZSB0
byB0aGUgZ3Vlc3QuCgoKPiBIb3dldmVyLCBpdCBkb2Vzbid0IHNheSBhbnl0aGluZyBhYm91dCB0
aGUgdHJhcHMgdGhhdCBjYW4gb2NjdXIgYXMgdGhlCj4gYXJjaGl0ZWN0dXJlIGdyb3dzIG5ldyBl
eHRlbnNpb25zLiBUaGUgY3VycmVudCBwb3NpdGlvbiBpcyB0byBhbHdheXMKPiBpbmplY3QgYW4g
VU5ERUYgKGV4YWN0bHkgd2hhdCBKYW1lcyBpcyBkb2luZyBoZXJlKSwgYnV0IGl0IGlzbid0IG9i
dmlvdXMKPiB0byBtZSB0aGF0IGl0IGlzIGFsd2F5cyB0aGUgcmlnaHQgdGhpbmcgdG8gZG8uIFdl
IHNob3VsZCBwcm9iYWJseSBkcm9wIHRoZQo+IGRtZXNnIHNjcmVhbWluZyBhbmQgY29udmVydCBp
dCB0byBhIHRyYWNlLi4uCgpJIGRvbid0IHRoaW5rIHRoZXNlICJ1bmtub3duIHRyYXBzIiBzaG91
bGQgYmUgc2lsZW50LCB3ZSBuZWVkIHNvbWUga2luZCBvZiB3YXJuaW5nIHRoYXQKc29tZXRoaW5n
IGJhZCBpcyBoYXBwZW5pbmcuIEN1cnJlbnRseSB3ZSB3YWl0IHVudGlsIHdlIHRha2UgdGhlIHRy
YXAgYmVmb3JlIHdhcm5pbmcgdGhhdAp3ZSBkb24ndCByZWFsbHkgdW5kZXJzdGFuZCB0aGUgcGxh
dGZvcm0sIHdoaWNoIGlzIG9ubHkgaGFsZiB0aGUgc3RvcnkuCgpBc3N1bWluZyBhbGwgbmV3IGZl
YXR1cmVzIGhhdmUgYSBuZXcgaWQtcmVnaXN0ZXIgZW50cnksIG9yIGFyZSBiYWNrd2FyZCBjb21w
YXRpYmxlOiBIb3cgZG8KeW91IGZlZWwgYWJvdXQgYSBib290LXRpbWUgd2FybmluZyB0aGF0IHRo
ZSBJRCByZWdpc3RlcnMgZGVzY3JpYmUgZmVhdHVyZXMgdGhpcyB2ZXJzaW9uIG9mCnRoZSBrZXJu
ZWwgZG9lc24ndCB1bmRlcnN0YW5kPyBUaGlzIHdvdWxkIGFsc28gY2F0Y2ggdGhlIGlzc3VlIHRo
ZSBvdGhlciB3YXkgcm91bmQ6IGFuCnVua25vd24gZmVhdHVyZSBoYXMgZ3Vlc3QtYWNjZXNzaWJs
ZSBzdGF0ZSB0aGF0IGRpZG4ndCB0cmFwIGFsc28gZ2VuZXJhdGVzIGEgd2FybmluZy4KVG9kYXkg
dGhhdCBpcyBzaWxlbnQuCkkgdGhpbmsgY3B1ZmVhdHVyZSBjYW4gZG8gdGhpcywgYmVjYXVzZSBp
dHMgZXF1YWxseSBhcHBsaWNhYmxlIHRvIHRoZSBob3N0LgoKKEknbSBub3Qgdm9sdW50ZWVyaW5n
KQoKCj4+IE1heWJlIHdlIHNob3VsZCBpbnRyb2R1Y2UgS1ZNIG1hc2tzCj4+IGZvciBlYWNoIElE
IHJlZ2lzdGVyPyBBbHNvLCByZWdhcmRpbmcgdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24sIGRv
IHlvdQo+PiBrbm93IGlmIGEgcmVjZW50IGF1ZGl0IGhhcyBiZWVuIGNvbmR1Y3RlZCB0byBlbnN1
cmUgKG5vdyB3aXRoIE1QQU0pIHRoYXQKPj4gdGhlIGN1cnJlbnQgZmVhdHVyZSBoaWRpbmcgaXMg
Y29tcGxldGU/CgpJIGNoZWNrZWQgdGhlIHBhdGNoIGluIHRoZSBmaXhlcyB0YWcsIHdoaWNoIGlz
IG90aGVyd2lzZSBmaW5lLiBCdXQgdGhlcmUgd2VyZSBhIGZldyBvZgp0aGVzZSwgd2hlbiB0aGV5
IHdlcmUgb24gdGhlIGxpc3QgSSBnb3QgYm9nZ2VkIGRvd24gaW4gcmVhZGluZyB1cCBvbiBzb21l
IG9mIHRoZSBmZWF0dXJlcy4KCgpUaGFua3MsCgpKYW1lcwoKCj4gSSBkb3VidCBpdCBpcy4gVGhl
IG51bWJlciBvZiBhZGRpdGlvbnMgdXAgdG8gQVJNdjguNiBpcyBodWdlLCBhbmQgc29tZW9uZQo+
IHdvdWxkIG5lZWQgdG8gY2FyZWZ1bGx5IGNvbWIgaXQgYW5kIHRlc3QgaXQgb24gRlZQIHdpdGgg
YWxsIHRoZSBwb3NzaWJsZQo+IGFyY2hpdGVjdHVyYWwga25vYnMgdHVybmVkIGluIHZhcmlvdXMg
d2F5cy4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
