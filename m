Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50741C43219
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 06:31:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 089FE4B90B;
	Wed, 19 Oct 2022 02:31:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id te0Lzg0T7R3F; Wed, 19 Oct 2022 02:31:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 194294B920;
	Wed, 19 Oct 2022 02:31:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F6794B7FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 11:56:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SU0e1c9SAJiz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Oct 2022 11:56:47 -0400 (EDT)
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AFEC4B77A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 11:56:47 -0400 (EDT)
Received: from MUA by vps-vb.mhejs.net with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <mail@maciej.szmigiero.name>)
 id 1okoxF-0006rH-E8; Tue, 18 Oct 2022 17:56:33 +0200
Message-ID: <a1a8664c-4d06-89e7-8cfa-b730969bb841@maciej.szmigiero.name>
Date: Tue, 18 Oct 2022 17:56:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US, pl-PL
To: Gavin Shan <gshan@redhat.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-5-gshan@redhat.com>
 <3eecebca-a526-d10a-02d3-496ce919d577@maciej.szmigiero.name>
 <bd5df92c-6870-8053-0b35-a2ad993970bd@redhat.com>
 <da2b7db0-509a-c9e0-c36b-6487a265a779@redhat.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 4/6] KVM: selftests: memslot_perf_test: Support variable
 guest page size
In-Reply-To: <da2b7db0-509a-c9e0-c36b-6487a265a779@redhat.com>
X-Mailman-Approved-At: Wed, 19 Oct 2022 02:31:08 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

T24gMTguMTAuMjAyMiAwMjo1MSwgR2F2aW4gU2hhbiB3cm90ZToKPiBPbiAxMC8xOC8yMiA4OjQ2
IEFNLCBHYXZpbiBTaGFuIHdyb3RlOgo+PiBPbiAxMC8xOC8yMiA1OjMxIEFNLCBNYWNpZWogUy4g
U3ptaWdpZXJvIHdyb3RlOgo+Pj4gT24gMTQuMTAuMjAyMiAwOToxOSwgR2F2aW4gU2hhbiB3cm90
ZToKPj4+PiBUaGUgdGVzdCBjYXNlIGlzIG9idmlvdXNseSBicm9rZW4gb24gYWFyY2g2NCBiZWNh
dXNlIG5vbi00S0IgZ3Vlc3QKPj4+PiBwYWdlIHNpemUgaXMgc3VwcG9ydGVkLiBUaGUgZ3Vlc3Qg
cGFnZSBzaXplIG9uIGFhcmNoNjQgY291bGQgYmUgNEtCLAo+Pj4+IDE2S0Igb3IgNjRLQi4KPj4+
Pgo+Pj4+IFRoaXMgc3VwcG9ydHMgdmFyaWFibGUgZ3Vlc3QgcGFnZSBzaXplLCBtb3N0bHkgZm9y
IGFhcmNoNjQuCj4+Pj4KPj4+PiDCoMKgIC0gVGhlIGhvc3QgZGV0ZXJtaW5lcyB0aGUgZ3Vlc3Qg
cGFnZSBzaXplIHdoZW4gdmlydHVhbCBtYWNoaW5lIGlzCj4+Pj4gwqDCoMKgwqAgY3JlYXRlZC4g
VGhlIHZhbHVlIGlzIGFsc28gcGFzc2VkIHRvIGd1ZXN0IHRocm91Z2ggdGhlIHN5bmNocm9uaXph
dGlvbgo+Pj4+IMKgwqDCoMKgIGFyZWEuCj4+Pj4KPj4+PiDCoMKgIC0gVGhlIG51bWJlciBvZiBn
dWVzdCBwYWdlcyBhcmUgdW5rbm93biB1bnRpbCB0aGUgdmlydHVhbCBtYWNoaW5lCj4+Pj4gwqDC
oMKgwqAgaXMgdG8gYmUgY3JlYXRlZC4gU28gYWxsIHRoZSByZWxhdGVkIG1hY3JvcyBhcmUgZHJv
cHBlZC4gSW5zdGVhZCwKPj4+PiDCoMKgwqDCoCB0aGVpciB2YWx1ZXMgYXJlIGR5bmFtaWNhbGx5
IGNhbGN1bGF0ZWQgYmFzZWQgb24gdGhlIGd1ZXN0IHBhZ2UKPj4+PiDCoMKgwqDCoCBzaXplLgo+
Pj4+Cj4+Pj4gwqDCoCAtIFRoZSBzdGF0aWMgY2hlY2tzIG9uIG1lbW9yeSBzaXplcyBhbmQgcGFn
ZXMgYmVjb21lcyBkZXBlbmRlbnQKPj4+PiDCoMKgwqDCoCBvbiBndWVzdCBwYWdlIHNpemUsIHdo
aWNoIGlzIHVua25vd24gdW50aWwgdGhlIHZpcnR1YWwgbWFjaGluZQo+Pj4+IMKgwqDCoMKgIGlz
IGFib3V0IHRvIGJlIGNyZWF0ZWQuIFNvIGFsbCB0aGUgc3RhdGljIGNoZWNrcyBhcmUgY29udmVy
dGVkCj4+Pj4gwqDCoMKgwqAgdG8gZHluYW1pYyBjaGVja3MsIGRvbmUgaW4gY2hlY2tfbWVtb3J5
X3NpemVzKCkuCj4+Pj4KPj4+PiDCoMKgIC0gQXMgdGhlIGFkZHJlc3MgcGFzc2VkIHRvIG1hZHZp
c2UoKSBzaG91bGQgYmUgYWxpZ25lZCB0byBob3N0IHBhZ2UsCj4+Pj4gwqDCoMKgwqAgdGhlIHNp
emUgb2YgcGFnZSBjaHVuayBpcyBhdXRvbWF0aWNhbGx5IHNlbGVjdGVkLCBvdGhlciB0aGFuIG9u
ZQo+Pj4+IMKgwqDCoMKgIHBhZ2UuCj4+Pj4KPj4+PiDCoMKgIC0gQWxsIG90aGVyIGNoYW5nZXMg
aW5jbHVkZWQgaW4gdGhpcyBwYXRjaCBhcmUgYWxtb3N0IG1lY2hhbmljYWwKPj4+PiDCoMKgwqDC
oCByZXBsYWNpbmcgJzQwOTYnIHdpdGggJ2d1ZXN0X3BhZ2Vfc2l6ZScuCj4+Pj4KPj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBHYXZpbiBTaGFuIDxnc2hhbkByZWRoYXQuY29tPgo+Pj4+IC0tLQo+Pj4+IMKg
IC4uLi90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbWVtc2xvdF9wZXJmX3Rlc3QuYyB8IDE5MSArKysr
KysrKysrKy0tLS0tLS0KPj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMTE1IGluc2VydGlvbnMoKyks
IDc2IGRlbGV0aW9ucygtKQo+Pj4+Cj4+Pj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2t2bS9tZW1zbG90X3BlcmZfdGVzdC5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
a3ZtL21lbXNsb3RfcGVyZl90ZXN0LmMKPj4+PiBpbmRleCBkNWFhOTE0OGY5NmYuLmQ1ODdiZDk1
MmZmOSAxMDA2NDQKPj4+PiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbWVtc2xv
dF9wZXJmX3Rlc3QuYwo+Pj4+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9tZW1z
bG90X3BlcmZfdGVzdC5jCiguLi4pCj4+Pj4gQEAgLTc3LDggKzYxLDcgQEAgc3RhdGljX2Fzc2Vy
dChNRU1fVEVTVF9VTk1BUF9TSVpFX1BBR0VTICUKPj4+PiDCoMKgICogZm9yIHRoZSB0b3RhbCBz
aXplIG9mIDI1IHBhZ2VzLgo+Pj4+IMKgwqAgKiBIZW5jZSwgdGhlIG1heGltdW0gc2l6ZSBoZXJl
IGlzIDUwIHBhZ2VzLgo+Pj4+IMKgwqAgKi8KPj4+PiAtI2RlZmluZSBNRU1fVEVTVF9NT1ZFX1NJ
WkVfUEFHRVPCoMKgwqAgKDUwKQo+Pj4+IC0jZGVmaW5lIE1FTV9URVNUX01PVkVfU0laRcKgwqDC
oMKgwqDCoMKgIChNRU1fVEVTVF9NT1ZFX1NJWkVfUEFHRVMgKiA0MDk2KQo+Pj4+ICsjZGVmaW5l
IE1FTV9URVNUX01PVkVfU0laRcKgwqDCoMKgwqDCoMKgIDB4MzIwMDAKPj4+Cj4+PiBUaGUgYWJv
dmUgbnVtYmVyIHNlZW1zIGxlc3MgcmVhZGFibGUgdGhhbiBhbiBleHBsaWNpdCB2YWx1ZSBvZiA1
MCBwYWdlcy4KPj4+Cj4+PiBJbiBhZGRpdGlvbiB0byB0aGF0LCBpdCdzIDUwIHBhZ2VzIG9ubHkg
d2l0aCA0ayBwYWdlIHNpemUsIHNvIGF0IGxlYXN0Cj4+PiB0aGUgY29tbWVudCBhYm92ZSBuZWVk
cyB0byBiZSB1cGRhdGVkIHRvIHJlZmxlY3QgdGhpcyBmYWN0Lgo+Pj4KPj4KPj4gWWVhaCwgSSB3
aWxsIGNoYW5nZSB0aGUgY29tbWVudHMgbGlrZSBiZWxvdyBpbiBuZXh0IHJldmlzaW9uLgo+Pgo+
PiDCoMKgLyoKPj4gwqDCoCAqIFdoZW4gcnVubmluZyB0aGlzIHRlc3Qgd2l0aCAzMmsgbWVtc2xv
dHMsIGFjdHVhbGx5IDMyNzYzIGV4Y2x1ZGluZwo+PiDCoMKgICogdGhlIHJlc2VydmVkIG1lbW9y
eSBzbG90IDAsIHRoZSBtZW1vcnkgZm9yIGVhY2ggc2xvdCBpcyAweDQwMDAgYnl0ZXMuCj4+IMKg
wqAgKiBUaGUgbGFzdCBzbG90IGNvbnRhaW5zIDB4MTkwMDAgYnl0ZXMgbWVtb3J5LiBIZW5jZSwg
dGhlIG1heGltdW0gc2l6ZQo+PiDCoMKgICogaGVyZSBpcyAweDMyMDAwIGJ5dGVzLgo+PiDCoMKg
ICovCj4+Cj4gCj4gSSB3aWxsIHJlcGxhY2UgdGhvc2UgbnVtYmVycyB3aXRoIHJlYWRhYmxlIG9u
ZXMgbGlrZSBiZWxvdyA6KQo+IAo+IC8qCj4gIMKgKiBXaGVuIHJ1bm5pbmcgdGhpcyB0ZXN0IHdp
dGggMzJrIG1lbXNsb3RzLCBhY3R1YWxseSAzMjc2MyBleGNsdWRpbmcKPiAgwqAqIHRoZSByZXNl
cnZlZCBtZW1vcnkgc2xvdCAwLCB0aGUgbWVtb3J5IGZvciBlYWNoIHNsb3QgaXMgMTZLQi4gVGhl
Cj4gIMKgKiBsYXN0IHNsb3QgY29udGFpbnMgMTAwS0IgbWVtb3J5IHdpdGggdGhlIHJlbWFpbmlu
ZyA4NEtCLiBIZW5jZSwKPiAgwqAqIHRoZSBtYXhpbXVtIHNpemUgaXMgZG91YmxlIG9mIHRoYXQg
KDIwMEtCKQo+ICDCoCovCgpTdGlsbCwgdGhlc2UgbnVtYmVycyBhcmUgZm9yIHg4Niwgd2hpY2gg
aGFzIEtWTV9JTlRFUk5BTF9NRU1fU0xPVFMKZGVmaW5lZCBhcyAzLgoKQXMgZmFyIGFzIEkgY2Fu
IHNlZSBhYXJjaDY0IGhhcyBLVk1fSU5URVJOQUxfTUVNX1NMT1RTIGVxdWFsIHRvIDAsIHNvCnRo
aXMgYXJjaCBoYXMgMzI3NjYgc2xvdCBhdmFpbGFibGUgZm9yIHRoZSB0ZXN0IG1lbW9yeS4KClF1
aWNrIGNhbGN1bGF0aW9ucyBzaG93IHRoYXQgdGhpcyB3aWxsIHJlc3VsdCBpbiAxMTIgS2lCIG9m
IG1lbW9yeSBpbgp0aGUgbGFzdCBzbG90IGZvciA0IEtpQiBwYWdlIHNpemUgKHdoaWxlIGZvciA2
NCBLaUIgcGFnZSBzaXplIHRoZQptYXhpbXVtIHNsb3QgY291bnQgZm9yIHRoaXMgdGVzdCBpcyA4
MTkyIGFueXdheSAtIG5vdCBjb3VudGluZyBzbG90IDApLgoKPiBUaGFua3MsCj4gR2F2aW4KPiAK
ClRoYW5rcywKTWFjaWVqCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
