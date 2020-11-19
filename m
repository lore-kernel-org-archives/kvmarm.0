Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355B5C2D0E4
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 12:46:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71D11246B8
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 12:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71D11246B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B86384B488;
	Thu, 19 Nov 2020 07:46:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YVx4TwkjY66I; Thu, 19 Nov 2020 07:46:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84EF64B47F;
	Thu, 19 Nov 2020 07:46:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E38164B406
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 07:46:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PMkME5GlqPBU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 07:46:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B39C04B3E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 07:46:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6039A1396;
 Thu, 19 Nov 2020 04:46:28 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EFEED3F718;
 Thu, 19 Nov 2020 04:46:25 -0800 (PST)
Subject: Re: [PATCH v4 1/2] arm64: kvm: Save/restore MTE registers
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20201026155727.36685-1-steven.price@arm.com>
 <20201026155727.36685-2-steven.price@arm.com>
 <b8f2fe15e0cab5c24094915b8c000930@kernel.org>
 <98eaa539-0ae8-ce4c-8886-3040542ede80@arm.com> <X7VTsaO/7+Izqm8/@trantor>
From: Steven Price <steven.price@arm.com>
Message-ID: <f5e9fe3a-2147-4326-5e78-5eaf88c72789@arm.com>
Date: Thu, 19 Nov 2020 12:45:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X7VTsaO/7+Izqm8/@trantor>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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

T24gMTgvMTEvMjAyMCAxNzowMiwgQ2F0YWxpbiBNYXJpbmFzIHdyb3RlOgo+IE9uIFdlZCwgTm92
IDE4LCAyMDIwIGF0IDA0OjAxOjE4UE0gKzAwMDAsIFN0ZXZlbiBQcmljZSB3cm90ZToKPj4gT24g
MTcvMTEvMjAyMCAxOToyMCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gT24gMjAyMC0xMC0yNiAx
NTo1NywgU3RldmVuIFByaWNlIHdyb3RlOgo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL3N5c3JlZy5oCj4+Pj4gYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5o
Cj4+Pj4gaW5kZXggZDUyYzFiM2NlNTg5Li43NzI3ZGYwYmMwOWQgMTAwNjQ0Cj4+Pj4gLS0tIGEv
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaAo+Pj4+ICsrKyBiL2FyY2gvYXJtNjQvaW5j
bHVkZS9hc20vc3lzcmVnLmgKPj4+PiBAQCAtNTY1LDcgKzU2NSw4IEBACj4+Pj4gw6/Cv8K9I2Rl
ZmluZSBTQ1RMUl9FTHhfTcOvwr/CvcOvwr/CvcOvwr/CvSAoQklUKDApKQo+Pj4+Cj4+Pj4gw6/C
v8K9I2RlZmluZSBTQ1RMUl9FTHhfRkxBR1PDr8K/wr3Dr8K/wr3Dr8K/wr0gKFNDVExSX0VMeF9N
w6/Cv8K9IHwgU0NUTFJfRUx4X0EgfCBTQ1RMUl9FTHhfQyB8IFwKPj4+PiAtw6/Cv8K9w6/Cv8K9
w6/Cv8K9w6/Cv8K9w6/Cv8K9w6/Cv8K9w6/Cv8K9w6/Cv8K9w6/Cv8K9w6/Cv8K9w6/Cv8K9w6/C
v8K9IFNDVExSX0VMeF9TQSB8IFNDVExSX0VMeF9JIHwgU0NUTFJfRUx4X0lFU0IpCj4+Pj4gK8Ov
wr/CvcOvwr/CvcOvwr/CvcOvwr/CvcOvwr/CvcOvwr/CvcOvwr/CvcOvwr/CvcOvwr/CvcOvwr/C
vcOvwr/CvcOvwr/CvSBTQ1RMUl9FTHhfU0EgfCBTQ1RMUl9FTHhfSSB8IFNDVExSX0VMeF9JRVNC
IHwgXAo+Pj4+ICvDr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/
wr3Dr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr0gU0NUTFJfRUx4X0lURlNCKQo+Pj4+Cj4+Pj4gw6/C
v8K9LyogU0NUTFJfRUwyIHNwZWNpZmljIGZsYWdzLiAqLwo+Pj4+IMOvwr/CvSNkZWZpbmUgU0NU
TFJfRUwyX1JFUzHDr8K/wr3Dr8K/wr3Dr8K/wr0gKChCSVQoNCkpw6/Cv8K9IHwgKEJJVCg1KSnD
r8K/wr0gfCAoQklUKDExKSkgfAo+Pj4+IChCSVQoMTYpKSB8IFwKPj4+PiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N5c3JlZy1zci5oCj4+Pj4gYi9hcmNoL2Fy
bTY0L2t2bS9oeXAvaW5jbHVkZS9oeXAvc3lzcmVnLXNyLmgKPj4+PiBpbmRleCA3YTk4NjAzMDE0
NWYuLmExMjRmZmE0OWJhMyAxMDA2NDQKPj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9oeXAvaW5j
bHVkZS9oeXAvc3lzcmVnLXNyLmgKPj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS9oeXAvaW5jbHVk
ZS9oeXAvc3lzcmVnLXNyLmgKPj4+PiBAQCAtMTgsNiArMTgsMTEgQEAKPj4+PiDDr8K/wr1zdGF0
aWMgaW5saW5lIHZvaWQgX19zeXNyZWdfc2F2ZV9jb21tb25fc3RhdGUoc3RydWN0Cj4+Pj4ga3Zt
X2NwdV9jb250ZXh0ICpjdHh0KQo+Pj4+IMOvwr/CvXsKPj4+PiDDr8K/wr3Dr8K/wr3Dr8K/wr3D
r8K/wr0gY3R4dF9zeXNfcmVnKGN0eHQsIE1EU0NSX0VMMSnDr8K/wr3Dr8K/wr3Dr8K/wr0gPSBy
ZWFkX3N5c3JlZyhtZHNjcl9lbDEpOwo+Pj4+ICvDr8K/wr3Dr8K/wr3Dr8K/wr0gaWYgKHN5c3Rl
bV9zdXBwb3J0c19tdGUoKSkgewo+Pj4+ICvDr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr3D
r8K/wr3Dr8K/wr0gY3R4dF9zeXNfcmVnKGN0eHQsIFJHU1JfRUwxKcOvwr/CvcOvwr/CvcOvwr/C
vSA9IHJlYWRfc3lzcmVnX3MoU1lTX1JHU1JfRUwxKTsKPj4+PiArw6/Cv8K9w6/Cv8K9w6/Cv8K9
w6/Cv8K9w6/Cv8K9w6/Cv8K9w6/Cv8K9IGN0eHRfc3lzX3JlZyhjdHh0LCBHQ1JfRUwxKcOvwr/C
vcOvwr/CvcOvwr/CvSA9IHJlYWRfc3lzcmVnX3MoU1lTX0dDUl9FTDEpOwo+Pj4+ICvDr8K/wr3D
r8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr3Dr8K/wr0gY3R4dF9zeXNfcmVnKGN0eHQsIFRG
U1JFMF9FTDEpw6/Cv8K9w6/Cv8K9w6/Cv8K9ID0KPj4+PiByZWFkX3N5c3JlZ19zKFNZU19URlNS
RTBfRUwxKTsKPj4+Cj4+PiBBcyBmYXIgYXMgSSBjYW4gdGVsbCwgSENSX0VMMi5BVEEgaXMgc3Rp
bGwgY2xlYXIgd2hlbiBydW5uaW5nIGEgZ3Vlc3QuCj4+PiBTbyB3aHksIGRvIHdlIHNhdmUvcmVz
dG9yZSB0aGlzIHN0YXRlIHlldD8KPj4+Cj4+PiBBbHNvLCBJIHdvbmRlciB3aGV0aGVyIHdlIHNo
b3VsZCBrZWVwIHRoZXNlIGluIHRoZSBDIGNvZGUuIElmIG9uZSBkYXkKPj4+IHdlIGVuYWJsZSBN
VEUgaW4gdGhlIGtlcm5lbCwgd2Ugd2lsbCBoYXZlIHRvIG1vdmUgdGhlbSB0byB0aGUgYXNzZW1i
bHkKPj4+IHBhcnQsIG11Y2ggbGlrZSB3ZSBkbyBmb3IgUEF1dGguIEFuZCBJIGZlYXIgdGhhdCAi
b25lIGRheSIgaXMgcHJldHR5Cj4+PiBzb29uOgo+Pj4KPj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xpbnV4LWFybS1rZXJuZWwvY292ZXIuMTYwNTA0NjE5Mi5naXQuYW5kcmV5a252bEBnb29n
bGUuY29tLwo+Pgo+PiBHb29kIHBvaW50LiBBbHRob3VnaCBmb3IgTVRFIHdlIGRvIGhhdmUgdGhl
IG9wdGlvbiBvZiBzZXR0aW5nIFRDTyBpbiBQU1RBVEUKPj4gc28gdGhpcyBjb3VsZCByZW1haW4g
aW4gQyBpZiB3ZSdyZSBub3QgYm90aGVyZWQgYWJvdXQgdGhlICdnYXAnIGluIEtBU0FOCj4+IGNv
dmVyYWdlLiBJIGhhdmVuJ3QgeWV0IGdvdCBteSBoZWFkIGFyb3VuZCBob3cgKG9yIGluZGVlZCBp
ZikgdGhhdCBzZXJpZXMKPj4gaGFuZGxlcyBndWVzdHMuCj4gCj4gSSB0aGluayB3ZSBzaG91bGQg
YmUgZmluZSB3aXRoIHRoZSBjdXJyZW50bHkgcHJvcG9zZWQgaW4ta2VybmVsIE1URQo+IHN1cHBv
cnQuIEhvd2V2ZXIsIHNldHRpbmcgR0NSX0VMMSBjYW4gZ2V0IGluIHRoZSB3YXkgaWYgc3RhY2sg
dGFnZ2luZyBpcwo+IGV2ZXIgZW5hYmxlZCAoaXQgYnJlYWtzIHNpbmdsZSBpbWFnZSkuIFRoZSBj
b21waWxlciB1c2VzIEdDUl9FTDEgdG8KPiBnZW5lcmF0ZSBkaWZmZXJlbnQgY29sb3VycyBmb3Ig
dmFyaWFibGVzIG9uIHRoZSBzdGFjayBhbmQgY2hhbmdpbmcgaXQgaW4KPiB0aGUgbWlkZGxlIG9m
IGEgZnVuY3Rpb24gbWF5IGNhdXNlIGNvbmZ1c2lvbi4gWW91J2QgaGF2ZSB0byBzZXQKPiBQU1RB
VEUuVENPIGZvciB0aGUgd2hvbGUgZnVuY3Rpb24sIGVpdGhlciBmcm9tIHRoZSBjYWxsZXIgb3Is
IGlmIHRoZQo+IGNvbXBpbGVyIGdldHMgc21hcnRlciwgc29tZSBmdW5jdGlvbiBhdHRyaWJ1dGUu
Cj4gCgpJZiB0aGUgY29tcGlsZXIgbWlnaHQgc3RhcnQgcGxheWluZyB3aXRoIFRDTyB0aGVuIHRo
aXMgY291bGQgYWxzbyBiZSBhbiAKaXNzdWUgZm9yIFZNTXMgd2hpY2ggd2lsbCAoYXQgbGVhc3Qg
d2l0aCB0aGUgY3VycmVudCBkZXNpZ24pIG5lZWQgdG8gdXNlIApUQ08gdG8gc2FmZWx5IGFjY2Vz
cyBndWVzdCBtZW1vcnkuIEVzcGVjaWFsbHkgaWYgd2UgZW5mb3JjZSBQUk9UX01URSAKbWFwcGlu
Z3MgZm9yIHRoZSBWTU0uCgpTdGV2ZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
