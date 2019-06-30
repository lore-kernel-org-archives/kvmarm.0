Return-Path: <SRS0=ia35=U5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A571EC5B57E
	for <kvmarm@archiver.kernel.org>; Sun, 30 Jun 2019 10:19:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21A1B20659
	for <kvmarm@archiver.kernel.org>; Sun, 30 Jun 2019 10:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=web.de header.i=@web.de header.b="EkWw07tL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21A1B20659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75A104A511;
	Sun, 30 Jun 2019 06:19:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@web.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cL4H0aXoKhBV; Sun, 30 Jun 2019 06:19:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2BF4A49F;
	Sun, 30 Jun 2019 06:19:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F317A4A4EA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jun 2019 06:19:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TNHUE+hXkJ4H for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Jun 2019 06:19:03 -0400 (EDT)
Received: from mout.web.de (mout.web.de [212.227.15.3])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B1554A47E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jun 2019 06:19:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=dbaedf251592; t=1561889940;
 bh=bLhlpcS3Du6/J70yEMs1c6ggw5kDdNhYdM136+k71T0=;
 h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
 b=EkWw07tLAGMWKqKCDSX+ZxU6TJyESeJfwIJfmz+QuLc+hWLRD9GVOegvn01L1NH1x
 EWq6FeDdjWRDy00Z1qlV/OfJaBnQMlWwQU5UAKPan6IdxSfR3KTVmblhiiDT8HwZq+
 jW/mliXV3hd3rXPiVUBh3mcNwm4x0SzW4F9mD8a0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.54.22]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MI6JC-1hgy9y0ZEU-003xRY; Sun, 30
 Jun 2019 12:19:00 +0200
Subject: Re: KVM works on RPi4
From: Jan Kiszka <jan.kiszka@web.de>
To: Marc Zyngier <marc.zyngier@arm.com>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why> <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
Message-ID: <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
Date: Sun, 30 Jun 2019 12:18:59 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
Content-Language: en-US
X-Provags-ID: V03:K1:04w92vQEYTT8pNExe/B59Ak2jCirTtbX1hTIl64kTfUc7ZuF4Vr
 SxiGs7y7wzi28iWqyJcckIkR6VcRkFIoPDrTpCK7RY9wXeU6vmxxBBIfKywQfagu4FLiW18
 cOoZj3h1lxVC0VuZPF+TmUbF5jH4lcBGv4z98vqcS9mHdUIOq75l+2RD7rD/MBEt/LETara
 c3DXmhO/9RbiSq5KLMlRg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/GDKbidp1Og=:Ja3BHrbn2HKwBierKeWW8y
 4iEhhs80n2S9VGeo69lEeF+uUr3T+VX6e0vjsFZIgUIZn3NlfPE+L+FDDkgpkMpZdRHToSRaS
 KTWnyp+pRtFe/TiWfPVpsrp8+r5ZqilaiAkQuMkjyGwrZpKMJuv9UkiUBsJpjTCgrMxVDWxHO
 7jTc0bo9YymEJzdJBY4SLnTXwgpcdnFzEwmw48ZSv1SEn45/iCXVFACl4XOGlc0J7sgKxj1Tc
 Z1VnEImlO9FLjWIx8Xpj2hCv7ZZyyyHtFuCtOw2nFUORnPsAc/w/q/5W98fEfFs/0oRrLR7Ss
 XyUSKB0+T/HSFnmVJpCiu7fya4oq3gjsSAgDZbhuzCHmDmPpxdz8+PJX1cOBL48UznJR+se1r
 rwknjiMa9kyq0v9WUhjUqcElAjqcf3lpg8dmx7Vz+psmC5Ki6o2kgygzTvIjjmSGjIukMD0zk
 txKPqpvQh3cqj5iX72PnJAbfTHAaWrBdxsgpjad/pY2BQd6GvZYHSxb6/DxnmuW0Amo5ZhVUZ
 xat3Ne9ohcDZ2nkHzOG1BJh2ihrFzIeLKiYCNHY2dFCGKCy0DD/jsItfO1gT/fOEUkYQE7izJ
 MK1D2hg1S44RS33em5dSLAafmviyBab0nXCxwVO9NkmHcvsU3Wqaz7nmG5AYESaXwIYHjqKWa
 eVBisu4Wm7zkj2oqdJ88O5y7Ze09KGlIzM4aaG7U6divYz3u2nYKRHUf2zoMXwofy4ROEiwpO
 ziABfimhOheWmC6b1L49nzMbSnOA4UKH2YfdLi2TIkFo57equUUjJ9/9INpltPhPj74qUZgnx
 c3tSU8C6hm48RLdrdKsmfbxt2TqEcw9BBwWVSBd1r48ai8ZSMfqqBjgYDdtDQ+az1j5OVagnu
 P0kOKdqOyo+FjP9mfvkk6QsTdWA08VnOzDtsq7KW2/Oq7LGbfAX3BQZ05FZzqUsBhb8gQ8n2P
 TM0E6A0OclPesK3taqhcnS2WMmIVwVjRvUbHK5qujZRACIGOYByfdzBy5v+wAYzEOhOBNlXXP
 9GfBNzKl4Y62zEYcowdhvsFYkMpJKTw16j7paYuHy07UJdOOZBGDGaBD/QvdON0mnCtDF9KRt
 Pa6VsOqt9o0HNfoioIXRzN7RI6phMQDm2MB
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

T24gMzAuMDYuMTkgMTE6MzQsIEphbiBLaXN6a2Egd3JvdGU6Cj4gT24gMzAuMDYuMTkgMDA6NDIs
IE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gU2F0LCAyOSBKdW4gMjAxOSAxOTowOTozNyArMDIw
MAo+PiBKYW4gS2lzemthIDxqYW4ua2lzemthQHdlYi5kZT4gd3JvdGU6Cj4+PiBIb3dldmVyLCBh
cyB0aGUgUmFzcGJlcnJ5IGtlcm5lbCBpcyBub3QgeWV0IHJlYWR5IGZvciA2NC1iaXQgKGFuZAo+
Pj4gdXBzdHJlYW0gaXMgbm90IGluIHNpZ2h0KSwgSSBoYWQgdG8gdXNlIGxlZ2FjeSAzMi1iaXQg
bW9kZS4gQW5kIHRoZXJlIHdlCj4+PiBzdHVtYmxlIG92ZXIgdGhlIGNvcmUgZGV0ZWN0aW9uLiBU
aGlzIGxpdHRsZSBwYXRjaCBtYWRlIGl0IHdvcmssIHRob3VnaDoKPj4+Cj4+PiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm0va3ZtL2d1ZXN0LmMgYi9hcmNoL2FybS9rdm0vZ3Vlc3QuYwo+Pj4gaW5kZXgg
MmI4ZGU4ODViMmJmLi4wMTYwNmFhZDczY2MgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2FybS9rdm0v
Z3Vlc3QuYwo+Pj4gKysrIGIvYXJjaC9hcm0va3ZtL2d1ZXN0LmMKPj4+IEBAIC0yOTAsNiArMjkw
LDcgQEAgaW50IF9fYXR0cmlidXRlX2NvbnN0X18ga3ZtX3RhcmdldF9jcHUodm9pZCkKPj4+IMKg
wqDCoMKgwqAgY2FzZSBBUk1fQ1BVX1BBUlRfQ09SVEVYX0E3Ogo+Pj4gwqDCoMKgwqDCoMKgwqDC
oMKgIHJldHVybiBLVk1fQVJNX1RBUkdFVF9DT1JURVhfQTc7Cj4+PiDCoMKgwqDCoMKgIGNhc2Ug
QVJNX0NQVV9QQVJUX0NPUlRFWF9BMTU6Cj4+PiArwqDCoMKgIGNhc2UgQVJNX0NQVV9QQVJUX0NP
UlRFWF9BNzI6Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIEtWTV9BUk1fVEFSR0VUX0NP
UlRFWF9BMTU7Cj4+PiDCoMKgwqDCoMKgIGRlZmF1bHQ6Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIC1FSU5WQUw7Cj4+Pgo+Pj4gVGhhdCByYWlzZXMgdGhlIHF1ZXN0aW9uIGlmIHRoaXMg
aXMgaGFjayBvciBhIHZhbGlkIGNoYW5nZSBhbmQgaWYgdGhlcmUKPj4+IGlzIGdlbmVyYWwgaW50
ZXJlc3QgaW4gbWFwcGluZyA2NC1iaXQgY29yZXMgb24gMzItYml0IGlmIHRoZXkgaGFwcGVuIHRv
Cj4+PiBydW4gaW4gMzItYml0IG1vZGUuCj4+Cj4+IFRoZSByZWFsIHRoaW5nIHRvIGRvIGhlcmUg
d291bGQgYmUgdG8gbW92ZSB0byBhIGdlbmVyaWMgdGFyZ2V0LCBtdWNoCj4+IGxpa2Ugd2UgZGlk
IG9uIHRoZSA2NGJpdCBzaWRlLiBDb3VsZCB5b3UgaW52ZXN0aWdhdGUgdGhhdCBpbnN0ZWFkPyBJ
dAo+PiB3b3VsZCBhbHNvIGFsbG93IEtWTSB0byBiZSB1c2VkIG9uIG90aGVyIDMyYml0IGNvcmVz
IHN1Y2ggYXMKPj4gQTEyL0ExNy9BMzIuCj4KPiBZb3UgbWVhbiBzb21ldGhpbmcgbGlrZSBLVk1f
QVJNX1RBUkdFVF9HRU5FUklDX1Y4PyBOZWVkIHRvIHN0dWR5IHRoYXQuLi4KPgoKSG1tLCBsb29r
aW5nIGF0IHdoYXQgS1ZNX0FSTV9UQVJHRVRfQ09SVEVYX0E3IGFuZCAuLi5fQTE1IGRpZmZlcmVu
dGlhdGVzLCBJCmZvdW5kIG5vdGhpbmcgc28gZmFyOgoKa3ZtX3Jlc2V0X3ZjcHU6CiAgICAgICAg
IHN3aXRjaCAodmNwdS0+YXJjaC50YXJnZXQpIHsKICAgICAgICAgY2FzZSBLVk1fQVJNX1RBUkdF
VF9DT1JURVhfQTc6CiAgICAgICAgIGNhc2UgS1ZNX0FSTV9UQVJHRVRfQ09SVEVYX0ExNToKICAg
ICAgICAgICAgICAgICByZXNldF9yZWdzID0gJmNvcnRleGFfcmVnc19yZXNldDsKICAgICAgICAg
ICAgICAgICB2Y3B1LT5hcmNoLm1pZHIgPSByZWFkX2NwdWlkX2lkKCk7CiAgICAgICAgICAgICAg
ICAgYnJlYWs7CgpBbmQgYXJjaC9hcm0va3ZtL2NvcHJvY19hMTUuYyBsb29rcyBsaWtlIGEgY29w
eSBvZiBjb3Byb2NfYTcuYywganVzdCB3aXRoIHNvbWUKc3ltYm9scyByZW5hbWVkLgoKV2hhdCdz
IHRoZSBwdXJwb3NlIG9mIGFsbCB0aGF0PyBQbGFubmVkIGZvciBzb21ldGhpbmcgYmlnZ2VyIGJ1
dCBuZXZlcgppbXBsZW1lbnRlZD8gRnJvbSB0aGF0IHBlcnNwZWN0aXZlLCB0aGVyZSBzZWVtcyB0
byBiZSBubyBuZWVkIHRvIGFyY2gudGFyZ2V0IGFuZAprdm1fY29wcm9jX3RhcmdldF90YWJsZSBh
dCBhbGwuCgpKYW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
