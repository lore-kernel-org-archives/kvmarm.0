Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEB7C433E4
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 13:14:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22A20206D8
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 13:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsEw8Oui"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22A20206D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA9D24BA3C;
	Tue, 28 Jul 2020 09:14:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nAn8GTFxRiYK; Tue, 28 Jul 2020 09:13:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD944BA75;
	Tue, 28 Jul 2020 09:13:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2DB4BA3C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 09:13:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fX8XyTr8vtrk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 09:13:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D55224B9DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 09:13:57 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B5B95206D4;
 Tue, 28 Jul 2020 13:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595942036;
 bh=+uFhf2g9FNicnPqh1uSvAdwl71+frJOQtcY4UF0hIUs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=IsEw8Oui0Zre8d8keY1EFRlqWEfMehhUzMcSQ1MFq6CZ1Tf4wk2Kxhdpmk1QoUEHS
 mEtPp5Ck7NoKyNfNMtfXQu3z1i+5nucGGdLfzum25kmu+gtMFfjT0OJC5NaufyH331
 Gxb6j38at+xhywhsMCY71go95sCOajjYIAL7eaco=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k0PQZ-00Ff63-1K; Tue, 28 Jul 2020 14:13:55 +0100
MIME-Version: 1.0
Date: Tue, 28 Jul 2020 14:13:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/5] KVM: arm64: pvtime: steal-time is only supported when
 configured
In-Reply-To: <20200728125553.3k65bfdxs6u5pb4i@kamzik.brq.redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-2-drjones@redhat.com>
 <e2f23a105af0d7cf2daa6f3f8b596177@kernel.org>
 <20200728125553.3k65bfdxs6u5pb4i@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <ef8a19e07a2735d0d684ef54f8600d66@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 steven.price@arm.com
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

T24gMjAyMC0wNy0yOCAxMzo1NSwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+IE9uIE1vbiwgSnVsIDI3
LCAyMDIwIGF0IDA2OjI1OjUwUE0gKzAxMDAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gSGkgQW5k
cmV3LAo+PiAKPj4gT24gMjAyMC0wNy0xMSAxMTowNCwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+PiA+
IERvbid0IGNvbmZ1c2UgdGhlIGd1ZXN0IGJ5IHNheWluZyBzdGVhbC10aW1lIGlzIHN1cHBvcnRl
ZCB3aGVuCj4+ID4gaXQgaGFzbid0IGJlZW4gY29uZmlndXJlZCBieSB1c2Vyc3BhY2UgYW5kIHdv
bid0IHdvcmsuCj4+ID4KPj4gPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgSm9uZXMgPGRyam9uZXNA
cmVkaGF0LmNvbT4KPj4gPiAtLS0KPj4gPiAgYXJjaC9hcm02NC9rdm0vcHZ0aW1lLmMgfCA1ICsr
KystCj4+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkK
Pj4gPgo+PiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9wdnRpbWUuYyBiL2FyY2gvYXJt
NjQva3ZtL3B2dGltZS5jCj4+ID4gaW5kZXggZjdiNTJjZTE1NTdlLi4yYjIyMjE0OTA5YmUgMTAw
NjQ0Cj4+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vcHZ0aW1lLmMKPj4gPiArKysgYi9hcmNoL2Fy
bTY0L2t2bS9wdnRpbWUuYwo+PiA+IEBAIC00Miw5ICs0MiwxMiBAQCBsb25nIGt2bV9oeXBlcmNh
bGxfcHZfZmVhdHVyZXMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+PiA+Cj4+ID4gIAlzd2l0Y2gg
KGZlYXR1cmUpIHsKPj4gPiAgCWNhc2UgQVJNX1NNQ0NDX0hWX1BWX1RJTUVfRkVBVFVSRVM6Cj4+
ID4gLQljYXNlIEFSTV9TTUNDQ19IVl9QVl9USU1FX1NUOgo+PiA+ICAJCXZhbCA9IFNNQ0NDX1JF
VF9TVUNDRVNTOwo+PiA+ICAJCWJyZWFrOwo+PiA+ICsJY2FzZSBBUk1fU01DQ0NfSFZfUFZfVElN
RV9TVDoKPj4gPiArCQlpZiAodmNwdS0+YXJjaC5zdGVhbC5iYXNlICE9IEdQQV9JTlZBTElEKQo+
PiA+ICsJCQl2YWwgPSBTTUNDQ19SRVRfU1VDQ0VTUzsKPj4gPiArCQlicmVhazsKPj4gPiAgCX0K
Pj4gPgo+PiA+ICAJcmV0dXJuIHZhbDsKPj4gCj4+IEknbSBub3Qgc28gc3VyZSBhYm91dCB0aGlz
LiBJIGhhdmUgYWx3YXlzIGNvbnNpZGVyZWQgdGhlCj4+IGRpc2NvdmVyeSBpbnRlcmZhY2UgdG8g
YmUgImRvIHlvdSBrbm93IGFib3V0IHRoaXMgU01DQ0MKPj4gZnVuY3Rpb24iLiBBbmQgaWYgeW91
IGxvb2sgYXQgdGhlIHNwZWMsIGl0IHNheXMgKDQuMiwKPj4gUFZfVElNRV9GRUFUVVJFUyk6Cj4+
IAo+PiA8cXVvdGU+Cj4+IElmIFBWX2NhbGxfaWQgaWRlbnRpZmllcyBQVl9USU1FX0ZFQVRVUkVT
LCB0aGlzIGNhbGwgcmV0dXJuczoKPj4g4oCiIE5PVF9TVVBQT1JURUQgKC0xKSB0byBpbmRpY2F0
ZSB0aGF0IGFsbAo+PiBwYXJhdmlydHVhbGl6ZWQgdGltZSBmdW5jdGlvbnMgaW4gdGhpcyBzcGVj
aWZpY2F0aW9uIGFyZSBub3QKPj4gc3VwcG9ydGVkLgo+PiDigKIgU1VDQ0VTUyAoMCkgdG8gaW5k
aWNhdGUgdGhhdCBhbGwgdGhlIHBhcmF2aXJ0dWFsaXplZCB0aW1lCj4+IGZ1bmN0aW9ucyBpbiB0
aGlzIHNwZWNpZmljYXRpb24gYXJlIHN1cHBvcnRlZC4KPj4gPC9xdW90ZT4KPj4gCj4+IFNvIHRo
ZSB3YXkgSSB1bmRlcnN0YW5kIGl0LCB5b3UgY2Fubm90IHJldHVybiAic3VwcG9ydGVkIgo+PiBm
b3IgUFZfVElNRV9GRUFUVVJFUywgYW5kIHlldCByZXR1cm4gTk9UX1NVUFBPUlRFRCBmb3IKPj4g
UFZfVElNRV9TVC4gSXQgYXBwbGllcyB0byAqYWxsKiBmZWF0dXJlcy4KPj4gCj4+IFllcywgdGhp
cyBpcyB2ZXJ5IGJpemFycmUuIEJ1dCBJIGRvbid0IHRoaW5rIHdlIGNhbiBkZXZpYXRlCj4+IGZy
b20gaXQuCj4gCj4gQWgsIEkgc2VlIHlvdXIgcG9pbnQuIEJ1dCBJIHdvbmRlciBpZiB3ZSBzaG91
bGQgZHJvcCB0aGlzIHBhdGNoCj4gb3IgaWYgd2Ugc2hvdWxkIGNoYW5nZSB0aGUgcmV0dXJuIG9m
IEFSTV9TTUNDQ19IVl9QVl9USU1FX0ZFQVRVUkVTCj4gdG8gYmUgZGVwZW5kYW50IG9uIGFsbCB0
aGUgcHYgY2FsbHM/Cj4gCj4gRGlzY292ZXJ5IHdvdWxkIGxvb2sgbGlrZSB0aGlzCj4gCj4gSUYg
KFNNQ0NDX0FSQ0hfRkVBVFVSRVMsIFBWX1RJTUVfRkVBVFVSRVMpID09IDA7IFRIRU4KPiAgIElG
IChQVl9USU1FX0ZFQVRVUkVTLCBQVl9USU1FX0ZFQVRVUkVTKSA9PSAwOyBUSEVOCj4gICAgIFBW
X1RJTUVfU1QgaXMgc3VwcG9ydGVkLCBhcyB3ZWxsIGFzIGFsbCBvdGhlciBQViBjYWxscwo+ICAg
RUxJRiAoUFZfVElNRV9GRUFUVVJFUywgUFZfVElNRV9TVCkgPT0gMDsgVEhFTgo+ICAgICBQVl9U
SU1FX1NUIGlzIHN1cHBvcnRlZAo+ICAgRUxJRiAoUFZfVElNRV9GRUFUVVJFUywgPGFub3RoZXIt
cHYtY2FsbD4pID09IDA7IFRIRU4KPiAgICAgPGFub3RoZXItcHYtY2FsbD4gaXMgc3VwcG9ydGVk
Cj4gICAuLi4KPiAgIEVORElGCj4gRUxTRQo+ICAgTm8gUFYgY2FsbHMgYXJlIHN1cHBvcnRlZAo+
IEVORElGCj4gCj4gSSBiZWxpZXZlIHRoZSBhYm92ZSBpbXBsZW1lbnRzIGEgcmVhc29uYWJsZSBp
bnRlcnByZXRhdGlvbiBvZiB0aGUKPiBzcGVjaWZpY2F0aW9uLCBidXQgdGhlIGFsbCBmZWF0dXJl
IChQVl9USU1FX0ZFQVRVUkVTLCBQVl9USU1FX0ZFQVRVUkVTKQo+IHRoaW5nIGlzIGluZGVlZCBi
aXphcnJlIG5vIG1hdHRlciBob3cgeW91IGxvb2sgYXQgaXQuCgpJdCBpdCBpbmRlZWQgdHJ1ZSB0
byB0aGUgc3BlYy4gVGhhbmtmdWxseSB3ZSBvbmx5IHN1cHBvcnQgUFZfVElNRQphcyBhIGZlYXR1
cmUgZm9yIG5vdywgc28gd2UgYXJlIChzb3J0IG9mKSBpbW11bmUgdG8gdGhlIGJyYWluZGVhZAph
c3BlY3Qgb2YgdGhlIGRpc2NvdmVyeSBwcm90b2NvbC4KCkkgdGhpbmsgcmV0dXJuaW5nIGEgZmFp
bHVyZSB3aGVuIFBWX1RJTUUgaXNuJ3Qgc2V0dXAgaXMgYSB2YWxpZCB0aGluZwp0byBkbywgYXMg
bG9uZyBhcyBpdCBhcHBsaWVzIHRvIGFsbCBmdW5jdGlvbnMgKGkuZS4gc29tZXRoaW5nIGxpa2UK
dGhlIGJlbG93IHBhdGNoKS4KClRoYW5rcywKCiAgICAgICAgIE0uCgpkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vcHZ0aW1lLmMgYi9hcmNoL2FybTY0L2t2bS9wdnRpbWUuYwppbmRleCBmN2I1
MmNlMTU1N2UuLmMzZWY0ZWJkNjg0NiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vcHZ0aW1l
LmMKKysrIGIvYXJjaC9hcm02NC9rdm0vcHZ0aW1lLmMKQEAgLTQzLDcgKzQzLDggQEAgbG9uZyBr
dm1faHlwZXJjYWxsX3B2X2ZlYXR1cmVzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKICAJc3dpdGNo
IChmZWF0dXJlKSB7CiAgCWNhc2UgQVJNX1NNQ0NDX0hWX1BWX1RJTUVfRkVBVFVSRVM6CiAgCWNh
c2UgQVJNX1NNQ0NDX0hWX1BWX1RJTUVfU1Q6Ci0JCXZhbCA9IFNNQ0NDX1JFVF9TVUNDRVNTOwor
CQlpZiAodmNwdS0+YXJjaC5zdGVhbC5iYXNlICE9IEdQQV9JTlZBTElEKQorCQkJdmFsID0gU01D
Q0NfUkVUX1NVQ0NFU1M7CiAgCQlicmVhazsKICAJfQoKCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJ
dCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
