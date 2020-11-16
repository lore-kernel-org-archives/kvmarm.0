Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8078FC4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 14:10:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCA1822314
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 14:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxzRGCoW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCA1822314
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD244B7F5;
	Mon, 16 Nov 2020 09:10:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0GCjGXCy1+3D; Mon, 16 Nov 2020 09:10:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8A6C4B7C3;
	Mon, 16 Nov 2020 09:10:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0CC74B7BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 09:10:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d1gmom4Uv3gN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 09:10:38 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A58D24B7BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 09:10:38 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3C559222B9;
 Mon, 16 Nov 2020 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605535837;
 bh=ce9j1AGGlbt/dA39/NSUVN8ivIA3K66bI5W3yfnRygo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=MxzRGCoWZdy+IUxEK/B3YqzKL9YwdvEloQ4NV94H/28zFEl8StOb8eqKkaY1CBO6v
 NdkWbaJXg1tYuz+cQAj3nPFl9IBzbX/6xl8Gai6j6b4MWiRfjjMSy44MBvlx8A/U0y
 0OoThWvSEmzVrfOplnI5zr1uz2lyPMoEqxVIaQ/w=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kefDH-00B1sD-2K; Mon, 16 Nov 2020 14:10:35 +0000
MIME-Version: 1.0
Date: Mon, 16 Nov 2020 14:10:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Forbid invalid userspace
 Redistributor accesses
In-Reply-To: <584b7ff1-ecf2-b0ec-cea3-ccc29902f43a@huawei.com>
References: <20201113142801.1659-1-yuzenghui@huawei.com>
 <20201113142801.1659-2-yuzenghui@huawei.com>
 <724c43702b52aac0d3c9beb9604d1bfb@kernel.org>
 <584b7ff1-ecf2-b0ec-cea3-ccc29902f43a@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <cc45285fe491aff5c28a24f94c124508@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, wanghaibin.wang@huawei.com, zhukeqian1@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

T24gMjAyMC0xMS0xNiAxMzowOSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBNYXJjLAo+IAo+IE9u
IDIwMjAvMTEvMTYgMTowNCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBIaSBaZW5naHVpLAo+PiAK
Pj4gT24gMjAyMC0xMS0xMyAxNDoyOCwgWmVuZ2h1aSBZdSB3cm90ZToKPj4+IEl0J3MgZXhwZWN0
ZWQgdGhhdCB1c2VycyB3aWxsIGFjY2VzcyByZWdpc3RlcnMgaW4gdGhlIHJlZGlzdHJpYnV0b3Ig
Cj4+PiAqaWYqCj4+PiB0aGUgUkQgaGFzIGJlZW4gaW5pdGlhbGl6ZWQgcHJvcGVybHkuIFVuZm9y
dHVuYXRlbHkgdXNlcnNwYWNlIGNhbiBiZSAKPj4+IGJvZ3VzCj4+PiBlbm91Z2ggdG8gYWNjZXNz
IHJlZ2lzdGVycyBiZWZvcmUgc2V0dGluZyB0aGUgUkQgYmFzZSBhZGRyZXNzLCBhbmQgCj4+PiBL
Vk0KPj4+IGltcGxpY2l0bHkgYWxsb3dzIGl0ICh3ZSBoYW5kbGUgdGhlIGFjY2VzcyBhbnl3YXks
IHJlZ2FyZGxlc3Mgb2YgCj4+PiB3aGV0aGVyCj4+PiB0aGUgYmFzZSBhZGRyZXNzIGlzIHNldCku
Cj4+PiAKPj4+IEJhZCB0aGluZyBoYXBwZW5zIHdoZW4gd2UncmUgaGFuZGxpbmcgdGhlIHVzZXIg
cmVhZCBvZiBHSUNSX1RZUEVSLiBXZSAKPj4+IGVuZAo+Pj4gdXAgd2l0aCBhbiBvb3BzIHdoZW4g
ZGVmZXJlbmNpbmcgdGhlIHVuc2V0IHJkcmVnLi4uCj4+PiAKPj4+IMKgwqDCoMKgZ3BhX3QgbGFz
dF9yZGlzdF90eXBlciA9IHJkcmVnLT5iYXNlICsgR0lDUl9UWVBFUiArCj4+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIChyZHJlZy0+ZnJlZV9pbmRleCAtIDEpICogS1ZNX1ZHSUNfVjNfUkVESVNU
X1NJWkU7Cj4+PiAKPj4+IEZpeCB0aGlzIGlzc3VlIGJ5IGluZm9ybWluZyB1c2Vyc3BhY2Ugd2hh
dCBoYWQgZ29uZSB3cm9uZyAoLUVOWElPKS4KPj4gCj4+IEknbSB3b3JyaWVkIGFib3V0IHRoZSAi
aW1wbGljaXQiIGFzcGVjdCBvZiB0aGUgYWNjZXNzIHRoYXQgdGhpcyBwYXRjaAo+PiBub3cgZm9y
Ymlkcy4KPj4gCj4+IFRoZSBwcm9ibGVtIGlzIHRoYXQgdGhlIGV4aXN0aW5nIGRvY3VtZW50YXRp
b24gZG9lc24ndCBjb3ZlciB0aGlzIAo+PiBjYXNlLCA+IGFuZCAtRU5YSU8ncyAiR2V0dGluZyBv
ciBzZXR0aW5nIHRoaXMgcmVnaXN0ZXIgaXMgbm90IHlldCAKPj4gc3VwcG9ydGVkIgo+PiBpcyB3
YXkgdG9vIHZhZ3VlLgo+IAo+IEluZGVlZC4gSG93IGFib3V0IGNoYW5naW5nIHRvCj4gCj4gICAg
IC1FTlhJTyAgR2V0dGluZyBvciBzZXR0aW5nIHRoaXMgcmVnaXN0ZXIgaXMgbm90IHlldCBzdXBw
b3J0ZWQKPiAgICAgICAgICAgICBvciBWR0lDIG5vdCBwcm9wZXJseSBjb25maWd1cmVkIChlLmcu
LCBbUmVdRGlzdHJpYnV0b3IgYmFzZQo+ICAgICAgICAgICAgIGFkZHJlc3MgaXMgdW5rbm93bikK
Ckxvb2tzIE9LIHRvIG1lLgoKPiAKPj4gVGhlcmUgaXMgYSBwcmVjZWRlbnQgd2l0aCB0aGUgSVRT
LCBidXQgdGhhdCdzIHVuZG9jdW1lbnRlZAo+PiBhcyB3ZWxsLiBBbHNvLCBob3cgYWJvdXQgdjI/
IElmIHRoYXQncyB0aGUgd2FzeSB3ZSBhcmUgZ29pbmcgdG8gZml4IAo+PiB0aGlzLAo+PiB3ZSBh
bHNvIG5uZWQgdG8gYmVlZiB1cCB0aGUgZG9jdW1lbnRhdGlvbi4KPiAKPiBTdXJlLCBJIHBsYW4g
dG8gZG8gc28gYW5kIGhvcGUgaXQgd29uJ3QgYnJlYWsgdGhlIGV4aXN0aW5nIHVzZXJzcGFjZS4K
CldlbGwsIGF0IHRoaXMgc3RhZ2Ugd2UgY2FuIG9ubHkgaG9wZS4KCj4gCj4+IE9mIGNvdXJzZSwg
dGhlIG90aGVyIGhvcnJpYmxlIHdheSB0byBhZGRyZXNzIHRoZSBpc3N1ZSBpcyB0byByZXR1cm4g
YSAKPj4gdmFsdWUKPj4gdGhhdCBkb2Vzbid0IGhhdmUgdGhlIExhc3QgYml0IHNldCwgc2luY2Ug
d2UgY2FuJ3Qgc3ludGhldGlzZSBpdC4gSXQgCj4+IGRvZXNuJ3QKPj4gY2hhbmdlIHRoZSB1c2Vy
c3BhY2UgQVBJLCBhbmQgSSBjYW4gZXZlbiBmaW5kIHNvbWUgKGFkbWl0dGVkbHnCoCAKPj4gdHdp
c3RlZCkKPj4gbG9naWMgdG8gaXQgKHNpbmNlIHRoZXJlIGlzIG5vIGJhc2UgYWRkcmVzcywgdGhl
cmUgaXMgbm8gbGFzdCBSRC4uLikuCj4gCj4gSSdtIGZpbmUgd2l0aCBpdC4gQnV0IEknbSBhZnJh
aWQgdGhhdCB0aGVyZSBtaWdodCBiZSBvdGhlciBpc3N1ZXMgZHVlIAo+IHRvCj4gdGhlICJ1bmV4
cGVjdGVkIiBhY2Nlc3NlcyBzaW5jZSBJIGhhdmVuJ3QgdGVzdGVkIHdpdGggYWxsIHJlZ2lzdGVy
cyAKPiBmcm9tCj4gdXNlcnNwYWNlLgoKSSBoYXZlIGhhZCBhIGxvb2sgYXQgdGhlIHdlZWtlbmQs
IGFuZCBjb3VsZG4ndCBzZWUgYW55IG90aGVyIG90aGVyIEdJQ1IKcmVnaXN0ZXIgdGhhdCB3b3Vs
ZCBzdWZmZXIgZnJvbSByZHJlZyBiZWluZyBOVUxMLiBJIGhhdmVuJ3QgbG9va2VkIGF0CkdJQ0Qs
IGJ1dCBJIGRvbid0IGFudGljaXBhdGUgYW55dGhpbmcgYmFkIG9uIHRoYXQgZnJvbnQuCgo+IE15
IHRha2UgaXMgdGhhdCBvbmx5IGlmIHRoZSAiW1JlXURpc3RyaWJ1dG9yIGJhc2UgYWRkcmVzcyIg
aXMgc3BlY2lmaWVkCj4gaW4gdGhlIHN5c3RlbSBtZW1vcnkgbWFwLCB3aWxsIHRoZSB1c2VyLXBy
b3ZpZGVkIGt2bV9kZXZpY2VfYXR0ci5vZmZzZXQKPiBtYWtlIHNlbnNlLiBBbmQgd2UgY2FuIHRo
ZW4gaGFuZGxlIHRoZSBhY2Nlc3MgdG8gdGhlIHJlZ2lzdGVyIHdoaWNoIGlzCj4gZGVmaW5lZCBi
eSAiYmFzZSBhZGRyZXNzICsgb2Zmc2V0Ii4KCkknZCB0ZW5kIHRvIGFncmVlLCBidXQgaXQgaXMg
anVzdCB0aGF0IHRoaXMgaXMgYSBsYXJnZSBjaGFuZ2UgYXQgLXJjNC4KSSdkIHJhdGhlciBoYXZl
IGEgcXVpY2sgZml4IGZvciA1LjEwLCBhbmQgYSBtb3JlIGludmFzaXZlIGNoYW5nZSBmb3IgCjUu
MTEsCnNwYW5uaW5nIGFsbCB0aGUgcG9zc2libGUgdmdpYyBkZXZpY2VzLgoKICAgICAgICAgTS4K
LS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
