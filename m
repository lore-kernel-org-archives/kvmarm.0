Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B6FC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:59:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D1E061221
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:59:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D1E061221
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABE9E4B516;
	Wed, 12 May 2021 12:59:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 46UWidYv3Sic; Wed, 12 May 2021 12:59:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64B084B530;
	Wed, 12 May 2021 12:59:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA7E4B516
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:59:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t1CnWBcm8xio for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 12:59:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 039784B4A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:59:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5845D31B;
 Wed, 12 May 2021 09:59:36 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C46D3F719;
 Wed, 12 May 2021 09:59:34 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
 <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
Date: Wed, 12 May 2021 18:00:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
Content-Language: en-US
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 Pavel Machek <pavel@denx.de>, open list <linux-kernel@vger.kernel.org>,
 lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-stable <stable@vger.kernel.org>, patches@kernelci.org,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Guenter Roeck <linux@roeck-us.net>
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

SGkgTmFyZXNoLAoKVGhhbmsgeW91IGZvciB0aGUgcmVwb3J0IQoKT24gNS8xMi8yMSA1OjQ3IFBN
LCBOYXJlc2ggS2FtYm9qdSB3cm90ZToKPiBPbiBXZWQsIDEyIE1heSAyMDIxIGF0IDIwOjIyLCBH
cmVnIEtyb2FoLUhhcnRtYW4KPiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdyb3RlOgo+
PiBUaGlzIGlzIHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDUu
NC4xMTkgcmVsZWFzZS4KPj4gVGhlcmUgYXJlIDI0NCBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBh
bGwgd2lsbCBiZSBwb3N0ZWQgYXMgYSByZXNwb25zZQo+PiB0byB0aGlzIG9uZS4gIElmIGFueW9u
ZSBoYXMgYW55IGlzc3VlcyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQo+PiBsZXQg
bWUga25vdy4KPj4KPj4gUmVzcG9uc2VzIHNob3VsZCBiZSBtYWRlIGJ5IEZyaSwgMTQgTWF5IDIw
MjEgMTQ6NDc6MDkgKzAwMDAuCj4+IEFueXRoaW5nIHJlY2VpdmVkIGFmdGVyIHRoYXQgdGltZSBt
aWdodCBiZSB0b28gbGF0ZS4KPj4KPj4gVGhlIHdob2xlIHBhdGNoIHNlcmllcyBjYW4gYmUgZm91
bmQgaW4gb25lIHBhdGNoIGF0Ogo+PiAgICAgICAgIGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvcHVi
L2xpbnV4L2tlcm5lbC92NS54L3N0YWJsZS1yZXZpZXcvcGF0Y2gtNS40LjExOS1yYzEuZ3oKPj4g
b3IgaW4gdGhlIGdpdCB0cmVlIGFuZCBicmFuY2ggYXQ6Cj4+ICAgICAgICAgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9saW51eC1zdGFibGUtcmMu
Z2l0IGxpbnV4LTUuNC55Cj4+IGFuZCB0aGUgZGlmZnN0YXQgY2FuIGJlIGZvdW5kIGJlbG93Lgo+
Pgo+PiB0aGFua3MsCj4+Cj4+IGdyZWcgay1oCj4gQnVpbGQgcmVncmVzc2lvbiBkZXRlY3RlZC4K
Pgo+PiBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4YW5kcnUuZWxpc2VpQGFybS5jb20+Cj4+ICAgICBL
Vk06IGFybTY0OiBJbml0aWFsaXplIFZDUFUgbWRjcl9lbDIgYmVmb3JlIGxvYWRpbmcgaXQKPiBz
dGFibGUgcmMgNS40IGFybSBheG01NXh4X2RlZmNvbmZpZyBidWlsZHMgZmFpbGVkIGR1ZSB0byB0
aGVzZQo+IHdhcm5pbmdzIC8gZXJyb3JzLgo+ICAgLSBhcm0gKGF4bTU1eHhfZGVmY29uZmlnKSB3
aXRoIGdjYy04LDkgYW5kIDEwIGZhaWxlZAo+Cj4gYXJjaC9hcm0va3ZtLy4uLy4uLy4uL3ZpcnQv
a3ZtL2FybS9hcm0uYzogSW4gZnVuY3Rpb24gJ2t2bV92Y3B1X2ZpcnN0X3J1bl9pbml0JzoKPiBh
cmNoL2FybS9rdm0vLi4vLi4vLi4vdmlydC9rdm0vYXJtL2FybS5jOjU4MjoyOiBlcnJvcjogaW1w
bGljaXQKPiBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbiAna3ZtX2FybV92Y3B1X2luaXRfZGVidWcn
OyBkaWQgeW91IG1lYW4KPiAna3ZtX2FybV9pbml0X2RlYnVnJz8gWy1XZXJyb3I9aW1wbGljaXQt
ZnVuY3Rpb24tZGVjbGFyYXRpb25dCj4gICBrdm1fYXJtX3ZjcHVfaW5pdF9kZWJ1Zyh2Y3B1KTsK
PiAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Cj4gICBrdm1fYXJtX2luaXRfZGVidWcKPiBjYzE6
IHNvbWUgd2FybmluZ3MgYmVpbmcgdHJlYXRlZCBhcyBlcnJvcnMKClRoaXMgaXMgbXkgZmF1bHQs
IGluIExpbnV4IHY1LjQgS1ZNIGZvciBhcm0gaXMgc3RpbGwgYXJvdW5kLCBhbmQgdGhlcmUncyBu
bwpwcm90b3R5cGUgZm9yIHRoZSBmdW5jdGlvbiB3aGVuIGNvbXBpbGluZyBmb3IgYXJtLiBJIHN1
c3BlY3QgdGhhdCdzIGFsc28gdGhlIGNhc2UKZm9yIHY0LjE5LgoKSSBtYWRlIHRoaXMgY2hhbmdl
IHRvIGdldCBpdCB0byBidWlsZDoKCiQgZ2l0IGRpZmYKZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2lu
Y2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL2FybS9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCmlu
ZGV4IGRkMDNkNWUwMWE5NC4uMzI1NjRiMDE3YmEwIDEwMDY0NAotLS0gYS9hcmNoL2FybS9pbmNs
dWRlL2FzbS9rdm1faG9zdC5oCisrKyBiL2FyY2gvYXJtL2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgK
QEAgLTMzNSw2ICszMzUsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2FyY2hfc2NoZWRfaW4o
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LAppbnQgY3B1KSB7fQrCoHN0YXRpYyBpbmxpbmUgdm9pZCBr
dm1fYXJjaF92Y3B1X2Jsb2NrX2ZpbmlzaChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHt9CsKgCsKg
c3RhdGljIGlubGluZSB2b2lkIGt2bV9hcm1faW5pdF9kZWJ1Zyh2b2lkKSB7fQorc3RhdGljIGlu
bGluZSB2b2lkIGt2bV9hcm1fdmNwdV9pbml0X2RlYnVnKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkg
e30KwqBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2FybV9zZXR1cF9kZWJ1ZyhzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpIHt9CsKgc3RhdGljIGlubGluZSB2b2lkIGt2bV9hcm1fY2xlYXJfZGVidWcoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KSB7fQrCoHN0YXRpYyBpbmxpbmUgdm9pZCBrdm1fYXJtX3Jlc2V0
X2RlYnVnX3B0cihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHt9Cgp3aGljaCBtYXRjaGVzIHRoZSBz
dHViIGZvciBrdm1fYXJtX2luaXRfZGVidWcoKS4gSSBjYW4gc3BpbiBhIHBhdGNoIG91dCBvZiBp
dCBhbmQKc2VuZCBpdCBmb3IgNS40IGFuZCA0LjE5LiBNYXJjLCB3aGF0IGRvIHlvdSB0aGluaz8K
ClRoYW5rcywKCkFsZXgKCj4KPgo+IHN0ZXBzIHRvIHJlcHJvZHVjZToKPiAtLS0tLS0tLS0tLS0t
LS0tLS0tLQo+ICMhL2Jpbi9zaAo+Cj4gIyBUdXhNYWtlIGlzIGEgY29tbWFuZCBsaW5lIHRvb2wg
YW5kIFB5dGhvbiBsaWJyYXJ5IHRoYXQgcHJvdmlkZXMKPiAjIHBvcnRhYmxlIGFuZCByZXBlYXRh
YmxlIExpbnV4IGtlcm5lbCBidWlsZHMgYWNyb3NzIGEgdmFyaWV0eSBvZgo+ICMgYXJjaGl0ZWN0
dXJlcywgdG9vbGNoYWlucywga2VybmVsIGNvbmZpZ3VyYXRpb25zLCBhbmQgbWFrZSB0YXJnZXRz
Lgo+ICMKPiAjIFR1eE1ha2Ugc3VwcG9ydHMgdGhlIGNvbmNlcHQgb2YgcnVudGltZXMuCj4gIyBT
ZWUgaHR0cHM6Ly9kb2NzLnR1eG1ha2Uub3JnL3J1bnRpbWVzLywgZm9yIHRoYXQgdG8gd29yayBp
dCByZXF1aXJlcwo+ICMgdGhhdCB5b3UgaW5zdGFsbCBwb2RtYW4gb3IgZG9ja2VyIG9uIHlvdXIg
c3lzdGVtLgo+ICMKPiAjIFRvIGluc3RhbGwgdHV4bWFrZSBvbiB5b3VyIHN5c3RlbSBnbG9iYWxs
eToKPiAjIHN1ZG8gcGlwMyBpbnN0YWxsIC1VIHR1eG1ha2UKPiAjCj4gIyBTZWUgaHR0cHM6Ly9k
b2NzLnR1eG1ha2Uub3JnLyBmb3IgY29tcGxldGUgZG9jdW1lbnRhdGlvbi4KPgo+Cj4gdHV4bWFr
ZSAtLXJ1bnRpbWUgcG9kbWFuIC0tdGFyZ2V0LWFyY2ggYXJtIC0tdG9vbGNoYWluIGdjYy04IC0t
a2NvbmZpZwo+IGF4bTU1eHhfZGVmY29uZmlnCj4KPiByZWY6Cj4gaHR0cHM6Ly9idWlsZHMudHV4
YnVpbGQuY29tLzFzUlQwSE95SG5aOE41a3RKbWFFY01JUVpMMC8KPgo+Cj4gLS0KPiBMaW5hcm8g
TEtGVAo+IGh0dHBzOi8vbGtmdC5saW5hcm8ub3JnCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
