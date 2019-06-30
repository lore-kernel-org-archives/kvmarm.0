Return-Path: <SRS0=ia35=U5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65A3C5B57E
	for <kvmarm@archiver.kernel.org>; Sun, 30 Jun 2019 10:50:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 419F020663
	for <kvmarm@archiver.kernel.org>; Sun, 30 Jun 2019 10:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=web.de header.i=@web.de header.b="nR9mggtS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 419F020663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66C344A4DF;
	Sun, 30 Jun 2019 06:50:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@web.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gq6bghosQxva; Sun, 30 Jun 2019 06:50:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29A074A508;
	Sun, 30 Jun 2019 06:50:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA324A4DF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jun 2019 06:50:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X6q8XD9OQyvZ for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Jun 2019 06:50:04 -0400 (EDT)
Received: from mout.web.de (mout.web.de [212.227.15.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 561F54A47E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jun 2019 06:50:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=dbaedf251592; t=1561891801;
 bh=wFUVo4i7n+V3Z5o09v/i2Qwehi6NSg2qJtEb/OiNCgc=;
 h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
 b=nR9mggtSOXhESNthWFcWTDWau1Ap7SzcL9NOc6l0rMUvK7rhmiOs8RKtzJQ3JAJve
 np/CBdU6ZtMl/z/UH03CTlFp8YG8CNVMqVB1u3/XjmNwZgbCcA89zpCHUoHBLM91qa
 TA69I3NhirWNaRLgsBN9+9Y0zo3oPn94RzZ9VZj8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.54.22]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MHdwC-1hgS0a3mQO-003KpV; Sun, 30
 Jun 2019 12:50:01 +0200
Subject: Re: KVM works on RPi4
From: Jan Kiszka <jan.kiszka@web.de>
To: Marc Zyngier <marc.zyngier@arm.com>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why> <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
 <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
Message-ID: <cbbeb948-23e5-97d9-2410-ef804ae2b80d@web.de>
Date: Sun, 30 Jun 2019 12:49:59 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
Content-Language: en-US
X-Provags-ID: V03:K1:axysJ3BelgeJrbLFQ8BBG8UY7QGR1050x54XqjETZMZD02IviWJ
 MC9UyM0mJDLQJN1a+SphIUtRpFvnN7RKKxJ0h56JWv/hyzz1zPJtRMcjW8/ygQLwBoXT9r9
 egKzDx9C4b11Y4b8t7L2JLhzQcO/KyMjkiVM0QEFgHznWT799eD3Ji0U31yRkV/32/b4Ua8
 WZv7gBQ1PSa/X5s3y0j6w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Kxg4aAPUBfY=:/s9EBv0nEhlobcqldkBP7p
 qFM+SFzLEy7zJaFdcufGsRFZ9cHxOaeg7Ox9RfAsvqN4dyiJr3iHUU61ToFU4AaXpcuf7MD2l
 DnN+FDDjroDqDvTHApM5pf3brdUnDm69WQEqVWxgHt+14PVoel7R5nA7wTC3CDx8jyXThJV2g
 I+81HP9g7/kmRRLvKf2cNjyhk2jidlWv0JLig46w5A/4VKZ8jS49w/uEKQuDv7G5l6WZl9CxS
 YtvPla9GVVd93jtPQuTwu2t1MuyeNPZH2mNermX3zJsWdRa7Bo5pI4E6coF9ye/JEXFdslb13
 qbojWD9VhHkyZ6TcZhW2qNw5vcRgtKeJOLg5+bVR76euR9JlwsfdnyFZgmIC8qX8JtZLbP6hx
 HcncaZGXM+dh2XzXkw2fFnZfW3iprXEEaIpO3JNN3smvwyfnKdU6o1wV7IfHnqaP5lNkN5Mr+
 j0POBMN8IgSly7kGjTh9zx4Xtal0aqrhXpt2fCGWtlGKf0xmjrvUp1BE1x1kxCqw2dwSr/VTh
 /xE0OHlrR2GF1wzFuBCc8IllH6rwhQ1S5L0hlU/vcCYPn1dYTITTkUXynwr0kzDhiRfWQqQ8t
 0hVQQczQNwfH55zXHEfZ86VkxcvW5zeSGejSJov+4XqhlIr7d9oKv8BQOl5KKmWHina8wRIQU
 auh1xxaF7A0eODPd662VT6h41rXDUtK070L3Wm4/c6gY490HZhnh0fwFCXvaGsoWMtrzZvcMk
 rkj7X4+JzVgoP7BnWtWV9SN6K0Uk2ydUTp/GC+27gKYo8XXoxCw7rMXz0cHG1lokPENbfkEVN
 AWUrpfzQ5BpZE/uFtSNJDG/GfBy+fbK+0TLSacVa5cQd7gAIJqC9xrn4R0LcfI9HVjPqIgmPy
 3YO//+OsrCIvwW8kROLoRi9tLZqRHWD12TOhdphTXQZrMFCdmSapfmaFDgibLT5hHmmhYBM/q
 L1JuGZRSXUGEtu3XwwEL9j3lpZdyCguKjKFVs8pyBRO5b7Ee+4/rtpjNjxJe3u5u12wkqYm4Y
 9ARTUdR32tT5Wc1maPv58Y5YbBbSfh7rEhqoXzswggh+JtS0ezIjZS+fqVyEBpwCNvhAgQxae
 lxX3y/RxlleFJ2Qn+QzTFEILuflTNQXoFO5
Cc: kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
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

T24gMzAuMDYuMTkgMTI6MTgsIEphbiBLaXN6a2Egd3JvdGU6Cj4gT24gMzAuMDYuMTkgMTE6MzQs
IEphbiBLaXN6a2Egd3JvdGU6Cj4+IE9uIDMwLjA2LjE5IDAwOjQyLCBNYXJjIFp5bmdpZXIgd3Jv
dGU6Cj4+PiBPbiBTYXQsIDI5IEp1biAyMDE5IDE5OjA5OjM3ICswMjAwCj4+PiBKYW4gS2lzemth
IDxqYW4ua2lzemthQHdlYi5kZT4gd3JvdGU6Cj4+Pj4gSG93ZXZlciwgYXMgdGhlIFJhc3BiZXJy
eSBrZXJuZWwgaXMgbm90IHlldCByZWFkeSBmb3IgNjQtYml0IChhbmQKPj4+PiB1cHN0cmVhbSBp
cyBub3QgaW4gc2lnaHQpLCBJIGhhZCB0byB1c2UgbGVnYWN5IDMyLWJpdCBtb2RlLiBBbmQgdGhl
cmUgd2UKPj4+PiBzdHVtYmxlIG92ZXIgdGhlIGNvcmUgZGV0ZWN0aW9uLiBUaGlzIGxpdHRsZSBw
YXRjaCBtYWRlIGl0IHdvcmssIHRob3VnaDoKPj4+Pgo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bS9rdm0vZ3Vlc3QuYyBiL2FyY2gvYXJtL2t2bS9ndWVzdC5jCj4+Pj4gaW5kZXggMmI4ZGU4ODVi
MmJmLi4wMTYwNmFhZDczY2MgMTAwNjQ0Cj4+Pj4gLS0tIGEvYXJjaC9hcm0va3ZtL2d1ZXN0LmMK
Pj4+PiArKysgYi9hcmNoL2FybS9rdm0vZ3Vlc3QuYwo+Pj4+IEBAIC0yOTAsNiArMjkwLDcgQEAg
aW50IF9fYXR0cmlidXRlX2NvbnN0X18ga3ZtX3RhcmdldF9jcHUodm9pZCkKPj4+PiDCoMKgwqDC
oMKgIGNhc2UgQVJNX0NQVV9QQVJUX0NPUlRFWF9BNzoKPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIEtWTV9BUk1fVEFSR0VUX0NPUlRFWF9BNzsKPj4+PiDCoMKgwqDCoMKgIGNhc2UgQVJN
X0NQVV9QQVJUX0NPUlRFWF9BMTU6Cj4+Pj4gK8KgwqDCoCBjYXNlIEFSTV9DUFVfUEFSVF9DT1JU
RVhfQTcyOgo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gS1ZNX0FSTV9UQVJHRVRfQ09S
VEVYX0ExNTsKPj4+PiDCoMKgwqDCoMKgIGRlZmF1bHQ6Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKg
IHJldHVybiAtRUlOVkFMOwo+Pj4+Cj4+Pj4gVGhhdCByYWlzZXMgdGhlIHF1ZXN0aW9uIGlmIHRo
aXMgaXMgaGFjayBvciBhIHZhbGlkIGNoYW5nZSBhbmQgaWYgdGhlcmUKPj4+PiBpcyBnZW5lcmFs
IGludGVyZXN0IGluIG1hcHBpbmcgNjQtYml0IGNvcmVzIG9uIDMyLWJpdCBpZiB0aGV5IGhhcHBl
biB0bwo+Pj4+IHJ1biBpbiAzMi1iaXQgbW9kZS4KPj4+Cj4+PiBUaGUgcmVhbCB0aGluZyB0byBk
byBoZXJlIHdvdWxkIGJlIHRvIG1vdmUgdG8gYSBnZW5lcmljIHRhcmdldCwgbXVjaAo+Pj4gbGlr
ZSB3ZSBkaWQgb24gdGhlIDY0Yml0IHNpZGUuIENvdWxkIHlvdSBpbnZlc3RpZ2F0ZSB0aGF0IGlu
c3RlYWQ/IEl0Cj4+PiB3b3VsZCBhbHNvIGFsbG93IEtWTSB0byBiZSB1c2VkIG9uIG90aGVyIDMy
Yml0IGNvcmVzIHN1Y2ggYXMKPj4+IEExMi9BMTcvQTMyLgo+Pgo+PiBZb3UgbWVhbiBzb21ldGhp
bmcgbGlrZSBLVk1fQVJNX1RBUkdFVF9HRU5FUklDX1Y4PyBOZWVkIHRvIHN0dWR5IHRoYXQuLi4K
Pj4KPgo+IEhtbSwgbG9va2luZyBhdCB3aGF0IEtWTV9BUk1fVEFSR0VUX0NPUlRFWF9BNyBhbmQg
Li4uX0ExNSBkaWZmZXJlbnRpYXRlcywgSQo+IGZvdW5kIG5vdGhpbmcgc28gZmFyOgo+Cj4ga3Zt
X3Jlc2V0X3ZjcHU6Cj4gIMKgwqDCoMKgwqDCoMKgIHN3aXRjaCAodmNwdS0+YXJjaC50YXJnZXQp
IHsKPiAgwqDCoMKgwqDCoMKgwqAgY2FzZSBLVk1fQVJNX1RBUkdFVF9DT1JURVhfQTc6Cj4gIMKg
wqDCoMKgwqDCoMKgIGNhc2UgS1ZNX0FSTV9UQVJHRVRfQ09SVEVYX0ExNToKPiAgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlc2V0X3JlZ3MgPSAmY29ydGV4YV9yZWdzX3Jlc2V0Owo+
ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmNwdS0+YXJjaC5taWRyID0gcmVhZF9j
cHVpZF9pZCgpOwo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4KPiBB
bmQgYXJjaC9hcm0va3ZtL2NvcHJvY19hMTUuYyBsb29rcyBsaWtlIGEgY29weSBvZiBjb3Byb2Nf
YTcuYywganVzdCB3aXRoIHNvbWUKPiBzeW1ib2xzIHJlbmFtZWQuCgpPSywgZm91bmQgaXQ6IFRo
ZSByZXNldCB2YWx1ZXMgb2YgU0NUTFIgZGlmZmVyLCBpbiBvbmUgYml0LiBBMTUgc3RhcnRzIHdp
dGgKYnJhbmNoIHByZWRpY3Rpb24gKDExKSBvZmYsIEE3IHdpdGggdGhhdCBmZWF0dXJlIGVuYWJs
ZWQuIFF1aXRlIHNvbWUgYm9pbGVycGxhdGUKY29kZSBmb3IgbWFuYWdpbmcgYSBzaW5nbGUgYml0
LgoKRm9yIGEgZ2VuZXJpYyB0YXJnZXQsIGNhbiB3ZSBzaW1wbHkgYXNzdW1lIEExNSByZXNldCBi
ZWhhdmlvdXI/CgpKYW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
