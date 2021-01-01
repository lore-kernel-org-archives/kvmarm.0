Return-Path: <SRS0=pGwQ=GE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CDAC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jan 2021 03:09:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66C61221E3
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jan 2021 03:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66C61221E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD41A4B2F2;
	Thu, 31 Dec 2020 22:09:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8UilnT9uLDLF; Thu, 31 Dec 2020 22:09:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 860F44B316;
	Thu, 31 Dec 2020 22:09:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A62604B235
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Dec 2020 22:09:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mGchWMNB202A for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Dec 2020 22:09:06 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60C4D4B31A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Dec 2020 22:09:06 -0500 (EST)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D6VMc07wHz15h91;
 Fri,  1 Jan 2021 11:08:12 +0800 (CST)
Received: from [10.174.184.196] (10.174.184.196) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 1 Jan 2021 11:08:55 +0800
Subject: Re: [PATCH RFC] KVM: arm64: vgic: Decouple the check of the
 EnableLPIs bit from the ITS LPI translation
To: Marc Zyngier <maz@kernel.org>
References: <20201231062813.714-1-lushenming@huawei.com>
 <683134bdea8a22d3bb784117dcfe17a1@kernel.org>
 <cf530279-4c68-c7de-f87e-1236ce0241cf@huawei.com>
 <85dd45f580eaa7a0b8ec91ac0b7ca066@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <032ab609-0602-a3d6-5877-489e583ba0a8@huawei.com>
Date: Fri, 1 Jan 2021 11:08:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <85dd45f580eaa7a0b8ec91ac0b7ca066@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.196]
X-CFilter-Loop: Reflected
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gMjAyMC8xMi8zMSAyMDoyMiwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjAtMTItMzEg
MTE6NTgsIFNoZW5taW5nIEx1IHdyb3RlOgo+PiBPbiAyMDIwLzEyLzMxIDE2OjU3LCBNYXJjIFp5
bmdpZXIgd3JvdGU6Cj4+PiBIaSBTaGVtbWluZywKPj4+Cj4+PiBPbiAyMDIwLTEyLTMxIDA2OjI4
LCBTaGVubWluZyBMdSB3cm90ZToKPj4+PiBXaGVuIHRoZSBFbmFibGVMUElzIGJpdCBpcyBzZXQg
dG8gMCwgYW55IElUUyBMUEkgcmVxdWVzdHMgaW4gdGhlCj4+Pj4gUmVkaXN0cmlidXRvciB3b3Vs
ZCBiZSBpZ25vcmVkLiBBbmQgdGhpcyBjaGVjayBpcyBpbmRlcGVuZGVudCBmcm9tCj4+Pj4gdGhl
IElUUyBMUEkgdHJhbnNsYXRpb24uIFNvIGl0IG1pZ2h0IGJlIGJldHRlciB0byBtb3ZlIHRoZSBj
aGVjawo+Pj4+IG9mIHRoZSBFbmFibGVMUElzIGJpdCBvdXQgb2YgdGhlIExQSSByZXNvbHZpbmcs
IGFuZCBhbHNvIGFkZCBpdAo+Pj4+IHRvIHRoZSBwYXRoIHRoYXQgdXNlcyB0aGUgdHJhbnNsYXRp
b24gY2FjaGUuCj4+Pgo+Pj4gQnV0IGJ5IGRvaW5nIHRoYXQsIHlvdSBhcmUgbW92aW5nIHRoZSBv
dmVyaGVhZCBvZiBjaGVja2luZyBmb3IKPj4+IEVuYWJsZUxQSXMgZnJvbSB0aGUgc2xvdyBwYXRo
ICh0cmFuc2xhdGlvbiB3YWxrKSB0byB0aGUgZmFzdAo+Pj4gcGF0aCAoY2FjaGUgaGl0KSwgd2hp
Y2ggc2VlbXMgY291bnRlci1wcm9kdWN0aXZlLgo+Pgo+PiBPaCwgSSBkaWRuJ3Qgbm90aWNlIHRo
ZSBvdmVyaGVhZCBvZiB0aGUgY2hlY2tpbmcsIEkgdGhvdWdodCBpdCB3b3VsZAo+PiBiZSBuZWds
aWdpYmxlLi4uCj4gCj4gSXQgcHJvYmFibHkgZG9lc24ndCBzaG93IG9uIGEgbW9kZXJuIGJveCwg
YnV0IHNvbWUgb2YgdGhlIHNsb3dlcgo+IHN5c3RlbXMgbWlnaHQgc2VlIGl0LiBPdmVyYWxsLCB0
aGlzIGlzIGEgZGVzaWduIGRlY2lzaW9uIHRvIGtlZXAKPiB0aGUgdHJhbnNsYXRpb24gY2FjaGUg
YXMgc2ltcGxlIGFuZCBzdHJhaWdodGZvcndhcmQgYXMgcG9zc2libGU6Cj4gaWYgYW55dGhpbmcg
YWZmZWN0cyB0aGUgb3V0cHV0IG9mIHRoZSBjYWNoZSwgd2UgaW52YWxpZGF0ZSBpdCwKPiBhbmQg
dGhhdCdzIGl0LgoKT2ssIGdldCBpdC4KCj4gCj4+Cj4+Pgo+Pj4+IEJlc2lkZXMgaXQgc2VlbXMg
dGhhdAo+Pj4+IGJ5IHRoaXMgdGhlIGludmFsaWRhdGluZyBvZiB0aGUgdHJhbnNsYXRpb24gY2Fj
aGUgY2F1c2VkIGJ5IHRoZSBMUEkKPj4+PiBkaXNhYmxpbmcgaXMgdW5uZWNlc3NhcnkuCj4+Pj4K
Pj4+PiBOb3Qgc3VyZSBpZiBJIGhhdmUgbWlzc2VkIHNvbWV0aGluZy4uLiBUaGFua3MuCj4+Pgo+
Pj4gSSBhbSBjZXJ0YWlubHkgbWlzc2luZyB0aGUgcHVycG9zZSBvZiB0aGlzIHBhdGNoLgo+Pj4K
Pj4+IFRoZSBlZmZlY3Qgb2YgRW5hYmxlTFBJcyBiZWluZyB6ZXJvIGlzIHRvIGRyb3AgdGhlIHJl
c3VsdCBvZiBhbnkKPj4+IHRyYW5zbGF0aW9uIChhIG5ldyBwZW5kaW5nIGJpdCkgb24gdGhlIGZs
b29yLiBHaXZlbiB0aGF0LCBpdCBpcwo+Pj4gaW1tYXRlcmlhbCB3aGV0aGVyIHRoaXMgY2F1c2Vz
IGEgbmV3IHRyYW5zbGF0aW9uIG9yIGhpdHMgaW4gdGhlCj4+PiBjYWNoZSwgYXMgdGhlIHJlc3Vs
dCBpcyBzdGlsbCB0byBub3QgcGVuZCBhIG5ldyBpbnRlcnJ1cHQuCj4+Pgo+Pj4gSSBnZXQgdGhl
IGZlZWxpbmcgdGhhdCB5b3UgYXJlIHRyeWluZyB0byBvcHRpbWlzZSBmb3IgdGhlIHVudXN1YWwK
Pj4+IGNhc2Ugd2hlcmUgRW5hYmxlTFBJcyBpcyAwICphbmQqIHlvdSBoYXZlIGEgc2NyZWFtaW5n
IGRldmljZQo+Pj4gaW5qZWN0aW5nIHRvbnMgb2YgaW50ZXJydXB0LiBJZiB0aGF0IGlzIHRoZSBj
YXNlLCBJIGRvbid0IHRoaW5rCj4+PiB0aGlzIGlzIHdvcnRoIGl0Lgo+Pgo+PiBJbiBmYWN0LCBJ
IGp1c3QgZm91bmQgKGltYWdpbmluZykgdGhhdCBpZiB0aGUgRW5hYmxlTFBJcyBiaXQgaXMgMCwK
Pj4gdGhlIGt2bV92Z2ljX3Y0X3NldF9mb3J3YXJkaW5nKCkgd291bGQgZmFpbCB3aGVuIHBlcmZv
cm1pbmcgdGhlIExQSQo+PiB0cmFuc2xhdGlvbiwgYnV0IGluZGVlZCB3ZSBkb24ndCB0cnkgdG8g
cGVuZCBhbnkgaW50ZXJydXB0cyB0aGVyZS4uLgo+Pgo+PiBCeSB0aGUgd2F5LCBpdCBzZWVtcyB0
aGF0IHRoZSBMUEkgZGlzYWJsaW5nIHdvdWxkIG5vdCBhZmZlY3QgdGhlCj4+IGluamVjdGlvbiBv
ZiBWTFBJcy4uLgo+IAo+IFllcywgZ29vZCBwb2ludC4gV2UgY291bGQgdW5tYXAgdGhlIFZQRSBm
cm9tIGFsbCBJVFMsIHdoaWNoIHdvdWxkIHJlc3VsdAo+IGluIGFsbCB0cmFuc2xhdGlvbnMgdG8g
YmUgZGlzY2FyZGVkLCBidXQgdGhpcyBoYXMgdGhlIHJlYWxseSBiYWQgc2lkZQo+IGVmZmVjdCBv
ZiAqYWxzbyogcHJldmVudGluZyB0aGUgZGVsaXZlcnkgb2YgdlNHSXMsIHdoaWNoIGlzbid0IHdo
YXQKPiB5b3UnZCBleHBlY3QuCj4gCj4gT3ZlcmFsbCwgSSBkb24ndCB0aGluayB0aGVyZSBpcyBh
IGdvb2Qgd2F5IHRvIHN1cHBvcnQgdGhpcywgYW5kIG1heWJlCj4gd2Ugc2hvdWxkIGp1c3QgcHJl
dmVudCBFbmFibGVMUElzIHRvIGJlIHR1cm5lZCBvZmYgd2hlbiB1c2luZyBkaXJlY3QKPiBpbmpl
Y3Rpb24uIEFmdGVyIGFsbCwgdGhlIGFyY2hpdGVjdHVyZSBkb2VzIGFsbG93IHRoYXQgZm9yIEdJ
Q3YzCj4gaW1wbGVtZW50YXRpb25zLCB3aGljaCBpcyB3aGF0IHdlIGVtdWxhdGUuCgpBZ3JlZWQs
IGlmIHRoZXJlIGlzIG5vIGdvb2Qgd2F5LCB3ZSBjb3VsZCBqdXN0IG1ha2UgdGhlIEVuYWJsZUxQ
SXMgY2xlYXJpbmcKdW5zdXBwb3J0ZWQuLi4KClRoYW5rcyhIYXBweSAyMDIxKSwKU2hlbm1pbmcK
Cj4gCj4gVGhhbmtzLAo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
