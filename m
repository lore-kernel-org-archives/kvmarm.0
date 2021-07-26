Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45081C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:57:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF9DB60F55
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF9DB60F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40E334A1A5;
	Mon, 26 Jul 2021 09:57:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L0LhCAMyJepR; Mon, 26 Jul 2021 09:57:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AF3E49DE7;
	Mon, 26 Jul 2021 09:57:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A07E849DE7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:57:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S4UvIPBDZBTy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 09:57:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B23849D50
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:57:17 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8E0CD6023F;
 Mon, 26 Jul 2021 13:57:16 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m816Y-0013Q0-N0; Mon, 26 Jul 2021 14:57:14 +0100
MIME-Version: 1.0
Date: Mon, 26 Jul 2021 14:57:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 5/6] kvm: allocate vcpu pointer array separately
In-Reply-To: <2aed0475-3df0-5ac6-f393-042b5e798ebc@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-6-jgross@suse.com>
 <001b7eab-ed7b-da27-a623-057781cf1211@redhat.com>
 <2aed0475-3df0-5ac6-f393-042b5e798ebc@suse.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <1643c773ce53d643f45feb53dbbfd819@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jgross@suse.com, pbonzini@redhat.com,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
 jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, hpa@zytor.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Joerg Roedel <joro@8bytes.org>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

T24gMjAyMS0wNy0yNiAxNDo0NiwgSnVlcmdlbiBHcm9zcyB3cm90ZToKPiBPbiAyNi4wNy4yMSAx
NTo0MCwgUGFvbG8gQm9uemluaSB3cm90ZToKPj4gT24gMDEvMDcvMjEgMTc6NDEsIEp1ZXJnZW4g
R3Jvc3Mgd3JvdGU6Cj4+PiDCoCB7Cj4+PiAtwqDCoMKgIGlmICghaGFzX3ZoZSgpKQo+Pj4gK8Kg
wqDCoCBpZiAoIWhhc192aGUoKSkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIGtmcmVlKGt2bS0+dmNw
dXMpOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGtmcmVlKGt2bSk7Cj4+PiAtwqDCoMKgIGVsc2UK
Pj4+ICvCoMKgwqAgfSBlbHNlIHsKPj4+ICvCoMKgwqDCoMKgwqDCoCB2ZnJlZShrdm0tPnZjcHVz
KTsKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCB2ZnJlZShrdm0pOwo+Pj4gK8KgwqDCoCB9Cj4+PiDC
oCB9Cj4+PiDCoCBpbnQga3ZtX2FyY2hfdmNwdV9wcmVjcmVhdGUoc3RydWN0IGt2bSAqa3ZtLCB1
bnNpZ25lZCBpbnQgaWQpCj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3Zt
X2hvc3QuaCAKPj4+IGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+Pj4gaW5kZXgg
NzkxMzhjOTFmODNkLi4zOWNiYzRiNmJmZmIgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9rdm1faG9zdC5oCj4+PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9z
dC5oCj4+PiBAQCAtMTQ0MCwxMCArMTQ0MCw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCAKPj4+IGt2
bV9vcHNfc3RhdGljX2NhbGxfdXBkYXRlKHZvaWQpCj4+PiDCoCB9Cj4+PiDCoCAjZGVmaW5lIF9f
S1ZNX0hBVkVfQVJDSF9WTV9BTExPQwo+Pj4gLXN0YXRpYyBpbmxpbmUgc3RydWN0IGt2bSAqa3Zt
X2FyY2hfYWxsb2Nfdm0odm9pZCkKPj4+IC17Cj4+PiAtwqDCoMKgIHJldHVybiBfX3ZtYWxsb2Mo
a3ZtX3g4Nl9vcHMudm1fc2l6ZSwgR0ZQX0tFUk5FTF9BQ0NPVU5UIHwgCj4+PiBfX0dGUF9aRVJP
KTsKPj4+IC19Cj4+PiArc3RydWN0IGt2bSAqa3ZtX2FyY2hfYWxsb2Nfdm0odm9pZCk7Cj4+PiDC
oCB2b2lkIGt2bV9hcmNoX2ZyZWVfdm0oc3RydWN0IGt2bSAqa3ZtKTsKPj4+IMKgICNkZWZpbmUg
X19LVk1fSEFWRV9BUkNIX0ZMVVNIX1JFTU9URV9UTEIKPj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMKPj4+IGluZGV4IDNhZjM5OGVmMWZjOS4u
YTliMGJiMjIyMWVhIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jCj4+PiArKysg
Yi9hcmNoL3g4Ni9rdm0veDg2LmMKPj4+IEBAIC0xMDc0MSw5ICsxMDc0MSwyOCBAQCB2b2lkIGt2
bV9hcmNoX3NjaGVkX2luKHN0cnVjdCBrdm1fdmNwdSAKPj4+ICp2Y3B1LCBpbnQgY3B1KQo+Pj4g
wqDCoMKgwqDCoCBzdGF0aWNfY2FsbChrdm1feDg2X3NjaGVkX2luKSh2Y3B1LCBjcHUpOwo+Pj4g
wqAgfQo+Pj4gK3N0cnVjdCBrdm0gKmt2bV9hcmNoX2FsbG9jX3ZtKHZvaWQpCj4+PiArewo+Pj4g
K8KgwqDCoCBzdHJ1Y3Qga3ZtICprdm07Cj4+PiArCj4+PiArwqDCoMKgIGt2bSA9IF9fdm1hbGxv
Yyhrdm1feDg2X29wcy52bV9zaXplLCBHRlBfS0VSTkVMX0FDQ09VTlQgfCAKPj4+IF9fR0ZQX1pF
Uk8pOwo+Pj4gK8KgwqDCoCBpZiAoIWt2bSkKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gTlVM
TDsKPj4+ICsKPj4+ICvCoMKgwqAga3ZtLT52Y3B1cyA9IF9fdm1hbGxvYyhLVk1fTUFYX1ZDUFVT
ICogc2l6ZW9mKHZvaWQgKiksCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIEdGUF9LRVJORUxfQUNDT1VOVCB8IF9fR0ZQX1pFUk8pOwo+Pj4gK8KgwqDCoCBpZiAoIWt2
bS0+dmNwdXMpIHsKPj4+ICvCoMKgwqDCoMKgwqDCoCB2ZnJlZShrdm0pOwo+Pj4gK8KgwqDCoMKg
wqDCoMKgIGt2bSA9IE5VTEw7Cj4+PiArwqDCoMKgIH0KPj4+ICsKPj4gCj4+IExldCdzIGtlZXAg
dGhpcyBjbGVhbmVyOgo+PiAKPj4gMSkgdXNlIGt2ZnJlZSBpbiB0aGUgY29tbW9uIHZlcnNpb24g
b2Yga3ZtX2FyY2hfZnJlZV92bQo+PiAKPj4gMikgc3BsaXQgX19LVk1fSEFWRV9BUkNIX1ZNX0FM
TE9DIGFuZCBfX0tWTV9IQVZFX0FSQ0hfVk1fRlJFRSAoQVJNIAo+PiBkb2VzIG5vdCBuZWVkIGl0
IG9uY2Uga3ZmcmVlIGlzIHVzZWQpCj4+IAo+PiAzKSBkZWZpbmUgYSBfX2t2bV9hcmNoX2ZyZWVf
dm0gdmVyc2lvbiB0aGF0IGlzIGRlZmluZWQgZXZlbiBpZiAKPj4gIV9fS1ZNX0hBVkVfQVJDSF9W
TV9GUkVFLCBhbmQgd2hpY2ggY2FuIGJlIHVzZWQgb24geDg2Lgo+IAo+IE9rYXksIHdpbGwgZG8g
c28uCgpJJ2QgYXBwcmVjaWF0ZSBpZiB5b3UgY291bGQgQ2MgbWUgb24gdGhlIHdob2xlIHNlcmll
cywgYW5kCm5vdCBqdXN0IHRoZSBzaW5nbGUgYXJtNjQgcGF0Y2guCgpUaGFua3MsCgogICAgICAg
ICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcg
bGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1i
aWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
