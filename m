Return-Path: <SRS0=0SjI=5Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1A1C2BA1A
	for <kvmarm@archiver.kernel.org>; Wed,  8 Apr 2020 14:19:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A49A620780
	for <kvmarm@archiver.kernel.org>; Wed,  8 Apr 2020 14:19:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lnbn2Omz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A49A620780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 243DD4B17B;
	Wed,  8 Apr 2020 10:19:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uGkDkuwwBT1J; Wed,  8 Apr 2020 10:19:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D92684B190;
	Wed,  8 Apr 2020 10:19:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61BE94B159
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2020 10:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uttpUoLkNdrI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Apr 2020 10:19:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23ED34B149
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2020 10:19:41 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 125E62074F;
 Wed,  8 Apr 2020 14:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586355580;
 bh=maNVyBfu8ItLwyKOhrh/TRhv8mzBKc1ELxLvZuhL170=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Lnbn2Omzi2MippQjx2Qz4HU42rFftYa7piXsNUj1JsbLia6A/8wuGN5Ds4VKxBzEW
 R0aDA+UZM1bFZFjVVqLQvTQZX2nLSMMxH1f8iBC8dyLWlmtyqERTFmstDyqEuEvXFm
 UsC1paAuXHuF8IYKVkFiYjdU15cYQkpLW7/1rW8w=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jMBYI-001fX7-9A; Wed, 08 Apr 2020 15:19:38 +0100
MIME-Version: 1.0
Date: Wed, 08 Apr 2020 15:19:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm64: arch_timer shouldn't assume the vcpu is loaded
In-Reply-To: <281d91cb-6818-4393-55ce-6207c04d744b@arm.com>
References: <20200406150355.4859-1-james.morse@arm.com>
 <20200408110726.4d81bc3b@why> <281d91cb-6818-4393-55ce-6207c04d744b@arm.com>
Message-ID: <92de4dc6e0c065eec528bb21c2d870cf@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGkgQW5kcmUsCgpPbiAyMDIwLTA0LTA4IDEzOjEzLCBBbmRyw6kgUHJ6eXdhcmEgd3JvdGU6Cj4g
T24gMDgvMDQvMjAyMCAxMTowNywgTWFyYyBaeW5naWVyIHdyb3RlOgo+IAo+IEhpIE1hcmMsCj4g
Cj4+IEhpIEphbWVzLAo+PiAKPj4gVGhhbmtzIGZvciBsb29raW5nIGludG8gdGhpcy4KPj4gCj4+
IE9uIE1vbiwgIDYgQXByIDIwMjAgMTY6MDM6NTUgKzAxMDAKPj4gSmFtZXMgTW9yc2UgPGphbWVz
Lm1vcnNlQGFybS5jb20+IHdyb3RlOgo+PiAKPj4+IGt2bV9hcmNoX3RpbWVyX2dldF9pbnB1dF9s
ZXZlbCgpIG5lZWRzIHRvIGdldCB0aGUgYXJjaF90aW1lcl9jb250ZXh0IAo+Pj4gZm9yCj4+PiBh
IHBhcnRpY3VsYXIgdmNwdSwgYW5kIHVzZXMga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKSB0byBmaW5k
IGl0Lgo+Pj4gCj4+PiBrdm1fYXJjaF90aW1lcl9nZXRfaW5wdXRfbGV2ZWwoKSBtYXkgYmUgY2Fs
bGVkIHRvIGhhbmRsZSBhIHVzZXItc3BhY2UKPj4+IHdyaXRlIHRvIHRoZSByZWRpc3RyaWJ1dG9y
LCB3aGVyZSB0aGUgdmNwdSBpcyBub3QgbG9hZGVkLiBUaGlzIGNhdXNlcwo+Pj4ga3ZtX2dldF9y
dW5uaW5nX3ZjcHUoKSB0byByZXR1cm4gTlVMTDoKPj4+IHwgVW5hYmxlIHRvIGhhbmRsZSBrZXJu
ZWwgcGFnaW5nIHJlcXVlc3QgYXQgdmlydHVhbCBhZGRyZXNzIAo+Pj4gMDAwMDAwMDAwMDAwMWVj
MAo+Pj4gfCBNZW0gYWJvcnQgaW5mbzoKPj4+IHwgICBFU1IgPSAweDk2MDAwMDA0Cj4+PiB8ICAg
RUMgPSAweDI1OiBEQUJUIChjdXJyZW50IEVMKSwgSUwgPSAzMiBiaXRzCj4+PiB8ICAgU0VUID0g
MCwgRm5WID0gMAo+Pj4gfCAgIEVBID0gMCwgUzFQVFcgPSAwCj4+PiB8IERhdGEgYWJvcnQgaW5m
bzoKPj4+IHwgICBJU1YgPSAwLCBJU1MgPSAweDAwMDAwMDA0Cj4+PiB8ICAgQ00gPSAwLCBXblIg
PSAwCj4+PiB8IHVzZXIgcGd0YWJsZTogNGsgcGFnZXMsIDQ4LWJpdCBWQXMsIHBnZHA9MDAwMDAw
MDAzY2JmOTAwMAo+Pj4gfCBbMDAwMDAwMDAwMDAwMWVjMF0gcGdkPTAwMDAwMDAwMDAwMDAwMDAK
Pj4+IHwgSW50ZXJuYWwgZXJyb3I6IE9vcHM6IDk2MDAwMDA0IFsjMV0gUFJFRU1QVCBTTVAKPj4+
IHwgTW9kdWxlcyBsaW5rZWQgaW46IHI4MTY5IHJlYWx0ZWsgZWZpdmFyZnMgaXBfdGFibGVzIHhf
dGFibGVzCj4+PiB8IENQVTogMSBQSUQ6IDI2MTUgQ29tbTogcWVtdS1zeXN0ZW0tYWFyIE5vdCB0
YWludGVkIDUuNi4wLXJjNyAjMzAKPj4+IHwgSGFyZHdhcmUgbmFtZTogTWFydmVsbCBtdmVidV9h
cm1hZGEtMzd4eC9tdmVidV9hcm1hZGEtMzd4eCwgQklPUyAKPj4+IDIwMTguMDMtZGV2ZWwtMTgu
MTIuMy1nYzlhYTkyYy1hcm1iaWFuIDAyLzIwLzIwMTkKPj4+IHwgcHN0YXRlOiAwMDAwMDA4NSAo
bnpjdiBkYUlmIC1QQU4gLVVBTykKPj4+IHwgcGMgOiBrdm1fYXJjaF90aW1lcl9nZXRfaW5wdXRf
bGV2ZWwrMHgxYy8weDY4Cj4+PiB8IGxyIDoga3ZtX2FyY2hfdGltZXJfZ2V0X2lucHV0X2xldmVs
KzB4MWMvMHg2OAo+Pj4gCj4+PiB8IENhbGwgdHJhY2U6Cj4+PiB8ICBrdm1fYXJjaF90aW1lcl9n
ZXRfaW5wdXRfbGV2ZWwrMHgxYy8weDY4Cj4+PiB8ICB2Z2ljX2dldF9waHlzX2xpbmVfbGV2ZWwr
MHgzYy8weDkwCj4+PiB8ICB2Z2ljX21taW9fd3JpdGVfc2VuYWJsZSsweGU0LzB4MTMwCj4+PiB8
ICB2Z2ljX3VhY2Nlc3MrMHhlMC8weDEwMAo+Pj4gfCAgdmdpY192M19yZWRpc3RfdWFjY2Vzcysw
eDVjLzB4ODAKPj4+IHwgIHZnaWNfdjNfYXR0cl9yZWdzX2FjY2VzcysweGYwLzB4MjAwCj4+PiB8
ICBudmdpY192M19zZXRfYXR0cisweDIzNC8weDI1MAo+Pj4gfCAga3ZtX2RldmljZV9pb2N0bF9h
dHRyKzB4YTQvMHhmOAo+Pj4gfCAga3ZtX2RldmljZV9pb2N0bCsweDdjLzB4YzAKPj4+IHwgIGtz
eXNfaW9jdGwrMHgxZmMvMHhjMTgKPj4+IHwgIF9fYXJtNjRfc3lzX2lvY3RsKzB4MjQvMHgzMAo+
Pj4gfCAgZG9fZWwwX3N2YysweDdjLzB4MTQ4Cj4+PiB8ICBlbDBfc3luY19oYW5kbGVyKzB4MTM4
LzB4MjU4Cj4+PiB8ICBlbDBfc3luYysweDE0MC8weDE4MAo+Pj4gfCBDb2RlOiA5MTAwMDNmZCBm
OTAwMGJmMyAyYTAwMDNmMyA5N2ZmNjUwYyAoYjk1ZWMwMDEpCj4+PiB8IC0tLVsgZW5kIHRyYWNl
IDgxMjg3NjEyZDkzZjFlNzAgXS0tLQo+Pj4gfCBub3RlOiBxZW11LXN5c3RlbS1hYXJbMjYxNV0g
ZXhpdGVkIHdpdGggcHJlZW1wdF9jb3VudCAxCj4+PiAKPj4+IExvYWRpbmcgdGhlIHZjcHUgZG9l
c24ndCBtYWtlIGEgbG90IG9mIHNlbnNlIGZvciBoYW5kbGluZyBhIGRldmljZSAKPj4+IGlvY3Rs
KCksCj4+PiBzbyBpbnN0ZWFkIHBhc3MgdGhlIHZjcHUgdGhyb3VnaCB0byBrdm1fYXJjaF90aW1l
cl9nZXRfaW5wdXRfbGV2ZWwoKS4gCj4+PiBJdHMKPj4+IG5vdCBjbGVhciB0aGF0IGFuIGludGlk
IG1ha2VzIG11Y2ggc2Vuc2Ugd2l0aG91dCB0aGUgcGFpcmVkIHZjcHUuCj4+IAo+PiBJIGRvbid0
IGZ1bGx5IGFncmVlIHdpdGggdGhlIGFuYWx5c2lzLCBSZW1lbWJlciB3ZSBhcmUgbG9va2luZyBh
dCB0aGUKPj4gc3RhdGUgb2YgdGhlIHBoeXNpY2FsIGludGVycnVwdCBhc3NvY2lhdGVkIHdpdGgg
YSB2aXJ0dWFsIGludGVycnVwdCwgCj4+IHNvCj4+IHRoZSB2Y3B1IGRvZXNuJ3QgcXVpdGUgbWFr
ZSBzZW5zZSBoZXJlIGlmIGl0IGlzbid0IGxvYWRlZC4KPiAKPiBCdXQgd2Fzbid0IGl0IHRoYXQg
dGhpcyBmdW5jdGlvbiBpcyBtZWFudCB0byBzcGVjaWZpY2FsbHkgZGVhbCB3aXRoIAo+IHRoaXMK
PiAqd2l0aG91dCogZ29pbmcgdG8gdGhlIGhhcmR3YXJlICh3aGljaCBpcyBjb3N0bHksIGhlbmNl
IHRoaXMKPiBvcHRpbWlzYXRpb24pPyBCZWNhdXNlIGZvciB0aGUgdGltZXIgd2UgKmNhbiogd29y
ayBvdXQgdGhlIGxvZ2ljYWwgSVJRCj4gbGluZSBzdGF0ZSBieSBleGFtaW5pbmcgb3VyIHNhdmVk
IHN0YXRlPyBBbmQgdGhpcyBpcyB3aGF0IHdlIGRvIGluCj4ga3ZtX3RpbWVyX3Nob3VsZF9maXJl
KCksIHdoZW4gdGltZXJfY3R4LT5sb2FkZWQgaXMgZmFsc2UuCgpZZXMsIGJ1dCB0aGF0J3MganVz
dCBhIHNwZWNpYWxpemF0aW9uIG9mIGEgbW9yZSBnZW5lcmljIGludGVyZmFjZSwgd2hpY2ggCmlz
CiJpbnNwZWN0IHRoZSBzdGF0ZSBvZiB0aGlzICpwaHlzaWNhbCogaW50aWQiLiBUaGUgZmFjdCB0
aGF0IHdlIGFyZSBhYmxlIAp0byBkbwppdCBpbiBhIHNwZWNpYWwgd2F5IGZvciB0aGUgdGltZXIg
ZG9lc24ndCBjaGFuZ2UgdGhlIG5hdHVyZSBvZiB0aGUgCmludGVyZmFjZS4KCj4gV2hpY2ggZm9y
IG1lIHRoaXMgc291bmRzIGxpa2UgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvIGluIHRoaXMgc2l0dWF0
aW9uOgo+IHRoZSBWQ1BVIChhbmQgdGhlIHRpbWVyKSBpcyBub3QgbG9hZGVkLCBzbyB3ZSBjaGVj
ayBvdXIgc2F2ZWQgc3RhdGUgYW5kCj4gY29uc3RydWN0IHRoZSBsb2dpY2FsIGxpbmUgbGV2ZWwu
IFdlIGp1c3QgbmVlZCBhIHZhbGlkIFZDUFUgc3RydWN0IHRvCj4gYWNoaWV2ZSB0aGlzLCBhbmQg
aG9wZSBmb3IgdGhlIHZpcnR1YWwgdGltZXIgdG8gYmUgYWxyZWFkeSBpbml0aWFsaXNlZC4KPiAK
PiBEbyBJIG1pc3Mgc29tZXRoaW5nIGhlcmU/CgpZZXMuIFlvdSBhcmUgbWlzc2luZyB0aGF0IHRo
ZSAqaW50ZXJmYWNlKiBpcyBnZW5lcmljLCBhbmQgeW91IGNhbiAKcmVwbGFjZQppdCB3aXRoIGFu
eXRoaW5nIHlvdSB3YW50LiBDYXNlIGluIHBvaW50LCB3aGF0IHdlIGRvIHdoZW4gCmdldF9pbnB1
dF9sZXZlbAppcyBOVUxMLgoKPiBBbHNvIHRvIG1lIGl0IHNvdW5kIGxpa2UgdGhlIGludGVyZmFj
ZSBmb3IgdGhpcyBmdW5jdGlvbiBpcyBzbGlnaHRseQo+IGxhY2tpbmcsIGJlY2F1c2UganVzdCBh
biBpbnRpZCBpcyBub3QgZW5vdWdoIHRvIHVuaXF1ZWx5IGlkZW50aWZ5IGFuCj4gSVJRLiBJdCB3
YXMganVzdCBmaW5lIHNvIGZhciBiZWNhdXNlIG9mIHRoaXMgc3BlY2lhbCB1c2UgY2FzZS4KClRo
aXMgaXMgYSAqcGh5c2ljYWwqIGludGlkLiBJdCBjYW4gb25seSBtZWFuIG9uZSBzaW5nbGUgdGhp
bmcsIGFuZCBpdApvbmx5IG1ha2VzIHNlbnNlIGluIHRoZSBjb250ZXh0IG9mIGEgdmNwdSBpZiB0
aGUgZGV2aWNlIGdldHMgCmNvbnRleHQtc3dpdGNoZWQuCgpJIGNhbiByZW1vdmUgdGhlIGFib3Zl
IGZhc3QgcGF0aCBlbnRpcmVseSwgYW5kIGV2ZXJ5dGhpbmcgd2lsbCBzdGlsbCAKd29yawp0aGUg
c2FtZSB3YXksIHdpdGhvdXQgaGF2aW5nIHRvIHBhc3MgYW55IHZjcHUsIGJlY2F1c2UgdGhlICpj
b250ZXh0KiBpcwp3aGF0IG1hdHRlcnMuCgpUaGFua3MsCgogICAgICAgICBNLgotLSAKSmF6eiBp
cyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
