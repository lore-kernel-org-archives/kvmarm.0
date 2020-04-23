Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B998C54FCB
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 14:34:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0CC2B2098B
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 14:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CC2B2098B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51B594B130;
	Thu, 23 Apr 2020 10:34:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Se59O4hLgcR7; Thu, 23 Apr 2020 10:34:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 331F14B137;
	Thu, 23 Apr 2020 10:34:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E2274B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 10:34:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Wv4PbTv5tYd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 10:34:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFBD94B130
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 10:34:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46F8B31B;
 Thu, 23 Apr 2020 07:34:08 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C3633F6CF;
 Thu, 23 Apr 2020 07:34:05 -0700 (PDT)
Subject: Re: [PATCH v3 5/6] KVM: arm64: vgic-v3: Retire all pending LPIs on
 vcpu destroy
To: Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-6-maz@kernel.org>
 <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
 <f8c8b60d-f701-28c5-3102-e2ae8804e341@huawei.com>
From: James Morse <james.morse@arm.com>
Message-ID: <86d04a96-4048-878e-b104-7b4631902558@arm.com>
Date: Thu, 23 Apr 2020 15:34:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <f8c8b60d-f701-28c5-3102-e2ae8804e341@huawei.com>
Content-Language: en-GB
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
 Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
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

SGkgWmVuZ2h1aSwKCk9uIDIzLzA0LzIwMjAgMTI6NTcsIFplbmdodWkgWXUgd3JvdGU6Cj4gT24g
MjAyMC80LzIzIDE5OjM1LCBKYW1lcyBNb3JzZSB3cm90ZToKPj4gT24gMjIvMDQvMjAyMCAxNzox
OCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gRnJvbTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1
YXdlaS5jb20+Cj4+Pgo+Pj4gSXQncyBsaWtlbHkgdGhhdCB0aGUgdmNwdSBmYWlscyB0byBoYW5k
bGUgYWxsIHZpcnR1YWwgaW50ZXJydXB0cyBpZgo+Pj4gdXNlcnNwYWNlIGRlY2lkZXMgdG8gZGVz
dHJveSBpdCwgbGVhdmluZyB0aGUgcGVuZGluZyBvbmVzIHN0YXkgaW4gdGhlCj4+PiBhcF9saXN0
LiBJZiB0aGUgdW4taGFuZGxlZCBvbmUgaXMgYSBMUEksIGl0cyB2Z2ljX2lycSBzdHJ1Y3R1cmUg
d2lsbAo+Pj4gYmUgZXZlbnR1YWxseSBsZWFrZWQgYmVjYXVzZSBvZiBhbiBleHRyYSByZWZjb3Vu
dCBpbmNyZW1lbnQgaW4KPj4+IHZnaWNfcXVldWVfaXJxX3VubG9jaygpLgo+Pgo+Pj4gZGlmZiAt
LWdpdCBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaW5pdC5jIGIvdmlydC9rdm0vYXJtL3ZnaWMv
dmdpYy1pbml0LmMKPj4+IGluZGV4IGE5NjNiOWQ3NjZiNzMuLjUzZWM5YjlkOWJjNDMgMTAwNjQ0
Cj4+PiAtLS0gYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLWluaXQuYwo+Pj4gKysrIGIvdmlydC9r
dm0vYXJtL3ZnaWMvdmdpYy1pbml0LmMKPj4+IEBAIC0zNDgsNiArMzQ4LDEyIEBAIHZvaWQga3Zt
X3ZnaWNfdmNwdV9kZXN0cm95KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+IMKgIHsKPj4+IMKg
wqDCoMKgwqAgc3RydWN0IHZnaWNfY3B1ICp2Z2ljX2NwdSA9ICZ2Y3B1LT5hcmNoLnZnaWNfY3B1
Owo+Pj4gwqAgK8KgwqDCoCAvKgo+Pj4gK8KgwqDCoMKgICogUmV0aXJlIGFsbCBwZW5kaW5nIExQ
SXMgb24gdGhpcyB2Y3B1IGFueXdheSBhcyB3ZSdyZQo+Pj4gK8KgwqDCoMKgICogZ29pbmcgdG8g
ZGVzdHJveSBpdC4KPj4+ICvCoMKgwqDCoCAqLwo+Pgo+PiBMb29raW5nIGF0IHRoZSBvdGhlciBj
YWxsZXIsIGRvIHdlIG5lZWQgc29tZXRoaW5nIGxpa2U6Cj4+IHzCoMKgwqAgaWYgKHZnaWNfY3B1
LT5scGlzX2VuYWJsZWQpCj4+Cj4+ID8KPiAKPiBJZiBMUElzIGFyZSBkaXNhYmxlZCBhdCByZWRp
c3RyaWJ1dG9yIGxldmVsLCB5ZXMgdGhlcmUgc2hvdWxkIGJlIG5vCj4gcGVuZGluZyBMUElzIGlu
IHRoZSBhcF9saXN0LiBCdXQgSSdtIG5vdCBzdXJlIGhvdyBjYW4gdGhlIGZvbGxvd2luZwo+IHVz
ZS1hZnRlci1mcmVlIEJVRyBiZSB0cmlnZ2VyZWQuCj4gCj4+Cj4+PiArwqDCoMKgIHZnaWNfZmx1
c2hfcGVuZGluZ19scGlzKHZjcHUpOwo+Pj4gKwo+Pgo+PiBPdGhlcndpc2UsIEkgZ2V0IHRoaXMg
b24gYSBnaWMtdjIgbWFjaGluZSE6Cj4gCj4gSSBkb24ndCBoYXZlIGEgZ2ljLXYyIG9uZSBhbmQg
dGh1cyBjYW4ndCByZXByb2R1Y2UgaXQgOi0oCj4gCj4+IFsgMTc0Mi4xODcxMzldIEJVRzogS0FT
QU46IHVzZS1hZnRlci1mcmVlIGluIHZnaWNfZmx1c2hfcGVuZGluZ19scGlzKzB4MjUwLzB4MmMw
Cj4+IFsgMTc0Mi4xOTQzMDJdIFJlYWQgb2Ygc2l6ZSA4IGF0IGFkZHIgZmZmZjAwMDhlMWJmMWYy
OCBieSB0YXNrIHFlbXUtc3lzdGVtLWFhci81NDIKPj4gWyAxNzQyLjIwMzE0MF0gQ1BVOiAyIFBJ
RDogNTQyIENvbW06IHFlbXUtc3lzdGVtLWFhciBOb3QgdGFpbnRlZAo+PiA1LjcuMC1yYzItMDAw
MDYtZzRmYjBmN2JiMGUyNyAjMgo+PiBbIDE3NDIuMjExNzgwXSBIYXJkd2FyZSBuYW1lOiBBUk0g
TFREIEFSTSBKdW5vIERldmVsb3BtZW50IFBsYXRmb3JtL0FSTSBKdW5vIERldmVsb3BtZW50Cj4+
IFBsYXRmb3JtLCBCSU9TIEVESyBJSSBKdWwgMzAgMjAxOAo+PiBbIDE3NDIuMjIyNTk2XSBDYWxs
IHRyYWNlOgo+PiBbIDE3NDIuMjI1MDU5XcKgIGR1bXBfYmFja3RyYWNlKzB4MC8weDMyOAo+PiBb
IDE3NDIuMjI4NzM4XcKgIHNob3dfc3RhY2srMHgxOC8weDI4Cj4+IFsgMTc0Mi4yMzIwNzFdwqAg
ZHVtcF9zdGFjaysweDEzNC8weDFiMAo+PiBbIDE3NDIuMjM1NTc4XcKgIHByaW50X2FkZHJlc3Nf
ZGVzY3JpcHRpb24uaXNyYS4wKzB4NmMvMHgzNTAKPj4gWyAxNzQyLjI0MDkxMF3CoCBfX2thc2Fu
X3JlcG9ydCsweDEwYy8weDE4MAo+PiBbIDE3NDIuMjQ0NzYzXcKgIGthc2FuX3JlcG9ydCsweDRj
LzB4NjgKPj4gWyAxNzQyLjI0ODI2OF3CoCBfX2FzYW5fcmVwb3J0X2xvYWQ4X25vYWJvcnQrMHgz
MC8weDQ4Cj4+IFsgMTc0Mi4yNTMwODFdwqAgdmdpY19mbHVzaF9wZW5kaW5nX2xwaXMrMHgyNTAv
MHgyYzAKPiAKPiBDb3VsZCB5b3UgcGxlYXNlIHNob3cgdGhlIHJlc3VsdCBvZgo+IAo+IC4vc2Ny
aXB0cy9mYWRkcjJsaW5lIHZtbGludXggdmdpY19mbHVzaF9wZW5kaW5nX2xwaXMrMHgyNTAvMHgy
YzAKPiAKPiBvbiB5b3VyIHNldHVwPwoKdmdpY19mbHVzaF9wZW5kaW5nX2xwaXMrMHgyNTAvMHgy
YzA6CnZnaWNfZmx1c2hfcGVuZGluZ19scGlzIGF0IGFyY2gvYXJtNjQva3ZtLy4uLy4uLy4uL3Zp
cnQva3ZtL2FybS92Z2ljL3ZnaWMuYzoxNTkKCldoaWNoIGlzOgp8CWxpc3RfZm9yX2VhY2hfZW50
cnlfc2FmZShpcnEsIHRtcCwgJnZnaWNfY3B1LT5hcF9saXN0X2hlYWQsIGFwX2xpc3QpIHsKCgpJ
IHRoaW5rIHRoaXMgY29uZmlybXMgTWFyYydzIHZpZXcgb2YgdGhlIEtBU0FOIHNwbGF0LgoKCj4+
IFdpdGggdGhhdDoKPj4gUmV2aWV3ZWQtYnk6IEphbWVzIE1vcnNlIDxqYW1lcy5tb3JzZUBhcm0u
Y29tPgo+IAo+IFRoYW5rcyBhIGxvdCEKCkhlaCwgaXQgbG9va3MgbGlrZSBJIGhhZCB0aGUgd3Jv
bmcgZW5kIG9mIHRoZSBzdGljayB3aXRoIHRoaXMuLi4gSSB3cm9uZ2x5IGFzc3VtZWQgY2FsbGlu
Zwp0aGlzIG9uIGdpY3YyIHdvdWxkIGdvIHVzaW5nIHN0cnVjdHVyZXMgdGhhdCBoZWxkIHNvbWV0
aGluZyBlbHNlLgoKClRoYW5rcywKCkphbWVzCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
