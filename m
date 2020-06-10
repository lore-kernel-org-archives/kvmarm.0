Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A835FC433E1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 14:12:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19C8B2067B
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 14:12:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19C8B2067B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 342BB4B24B;
	Wed, 10 Jun 2020 10:12:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ncdLe9Z4o-7q; Wed, 10 Jun 2020 10:12:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AACD4B21A;
	Wed, 10 Jun 2020 10:12:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F43A4B207
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 10:12:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jpMdXcnrnEQc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 10:12:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DF354B1D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 10:12:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0C4F1F1;
 Wed, 10 Jun 2020 07:12:21 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50B713F6CF;
 Wed, 10 Jun 2020 07:12:20 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
To: Marc Zyngier <maz@kernel.org>, Robin Murphy <robin.murphy@arm.com>
References: <20200609084921.1448445-1-maz@kernel.org>
 <20200609084921.1448445-2-maz@kernel.org>
 <7c173265-3f8e-51df-d700-7e3658a0e4d8@arm.com>
 <7451e64c22d8432f998458e0343aee7f@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <5ab013a2-7213-4bf6-b616-ff39bda72ffb@arm.com>
Date: Wed, 10 Jun 2020 15:12:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <7451e64c22d8432f998458e0343aee7f@kernel.org>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, stable@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyYywgUm9iaW4sCgpPbiAwOS8wNi8yMDIwIDEyOjQ4LCBNYXJjIFp5bmdpZXIgd3JvdGU6
Cj4gT24gMjAyMC0wNi0wOSAxMjo0MSwgUm9iaW4gTXVycGh5IHdyb3RlOgo+PiBPbiAyMDIwLTA2
LTA5IDA5OjQ5LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiBBQXJjaDMyIENQMXggcmVnaXN0ZXJz
IGFyZSBvdmVybGF5ZWQgb24gdGhlaXIgQUFyY2g2NCBjb3VudGVycGFydHMKPj4+IGluIHRoZSB2
Y3B1IHN0cnVjdC4gVGhpcyBsZWFkcyB0byBhbiBpbnRlcmVzdGluZyBwcm9ibGVtIGFzIHRoZXkK
Pj4+IGFyZSBzdG9yZWQgaW4gdGhlaXIgQ1BVLWxvY2FsIGZvcm1hdCwgYW5kIHRodXMgYSBDUDF4
IHJlZ2lzdGVyCj4+PiBkb2Vzbid0ICJoaXQiIHRoZSBsb3dlciAzMmJpdCBwb3J0aW9uIG9mIHRo
ZSBBQXJjaDY0IHJlZ2lzdGVyIG9uCj4+PiBhIEJFIGhvc3QuCj4+Pgo+Pj4gVG8gd29ya2Fyb3Vu
ZCB0aGlzIHVuZm9ydHVuYXRlIHNpdHVhdGlvbiwgaW50cm9kdWNlIGEgYmlhcyB0cmljawo+Pj4g
aW4gdGhlIHZjcHVfY3AxeCgpIGFjY2Vzc29ycyB3aGljaCBwaWNrcyB0aGUgY29ycmVjdCBoYWxm
IG9mIHRoZQo+Pj4gNjRiaXQgcmVnaXN0ZXIuCgo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
aW5jbHVkZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3Qu
aAo+Pj4gaW5kZXggNTkwMjllOTBiNTU3Li5lODBjMGUwNmYyMzUgMTAwNjQ0Cj4+PiAtLS0gYS9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPj4+ICsrKyBiL2FyY2gvYXJtNjQvaW5j
bHVkZS9hc20va3ZtX2hvc3QuaAo+Pj4gQEAgLTQwNCw4ICs0MDQsMTQgQEAgdm9pZCB2Y3B1X3dy
aXRlX3N5c19yZWcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgdmFsLCBpbnQgcmVnKTsKPj4+
IMKgwqAgKiBDUDE0IGFuZCBDUDE1IGxpdmUgaW4gdGhlIHNhbWUgYXJyYXksIGFzIHRoZXkgYXJl
IGJhY2tlZCBieSB0aGUKPj4+IMKgwqAgKiBzYW1lIHN5c3RlbSByZWdpc3RlcnMuCj4+PiDCoMKg
ICovCj4+PiAtI2RlZmluZSB2Y3B1X2NwMTQodixyKcKgwqDCoMKgwqDCoMKgICgodiktPmFyY2gu
Y3R4dC5jb3Byb1socildKQo+Pj4gLSNkZWZpbmUgdmNwdV9jcDE1KHYscinCoMKgwqDCoMKgwqDC
oCAoKHYpLT5hcmNoLmN0eHQuY29wcm9bKHIpXSkKPj4+ICsjaWZkZWYgQ1BVX0JJR19FTkRJQU4K
Pj4KPj4gQWhlbS4uLiBJIHRoaW5rIHlvdSdyZSBtaXNzaW5nIGEgIkNPTkZJR18iIHRoZXJlIDsp
Cj4gCj4gRHVoISBBcyBJIHNhaWQsIEkgZGlkbid0IHRlc3QgdGhlIHRoaW5nIGF0IGFsbCEgOy0p
Cj4gCj4+IEJvbnVzIHRyaWNrZXJ5IC0gZm9yIGEgMCBvciAxIHZhbHVlIHlvdSBjYW4gc2ltcGx5
IHVzZSBJU19FTkFCTEVEKCkuCj4gCj4gQmVhdXRpZnVsISBEZWZpbml0ZWx5IGEgbXVzdCEgOkQK
CldpdGggUm9iaW4ncyBzdWdnZXN0aW9uIG9mOgotLS0tLS0tLS0tLS0tLS0lPC0tLS0tLS0tLS0t
LS0tLQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCmluZGV4IDJhOTM1NDU3NzEyYi4uNTRlOWM3
ZWIzNTk2IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKKysr
IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCkBAIC00MDUsMTEgKzQwNSw3IEBA
IHZvaWQgdmNwdV93cml0ZV9zeXNfcmVnKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IHZhbCwg
aW50IHJlZyk7CiAgKiBDUDE0IGFuZCBDUDE1IGxpdmUgaW4gdGhlIHNhbWUgYXJyYXksIGFzIHRo
ZXkgYXJlIGJhY2tlZCBieSB0aGUKICAqIHNhbWUgc3lzdGVtIHJlZ2lzdGVycy4KICAqLwotI2lm
ZGVmIENQVV9CSUdfRU5ESUFOCi0jZGVmaW5lIENQeF9PRkZTRVQgICAgIDEKLSNlbHNlCi0jZGVm
aW5lIENQeF9PRkZTRVQgICAgIDAKLSNlbmRpZgorI2RlZmluZSBDUHhfT0ZGU0VUICAgICBJU19F
TkFCTEVEKENPTkZJR19DUFVfQklHX0VORElBTikKCiAjZGVmaW5lIHZjcHVfY3AxNCh2LHIpICAg
ICAgICAgKCh2KS0+YXJjaC5jdHh0LmNvcHJvWyhyKSBeIENQeF9PRkZTRVRdKQogI2RlZmluZSB2
Y3B1X2NwMTUodixyKSAgICAgICAgICgodiktPmFyY2guY3R4dC5jb3Byb1socikgXiBDUHhfT0ZG
U0VUXSkKLS0tLS0tLS0tLS0tLS0tJTwtLS0tLS0tLS0tLS0tLS0KClRlc3RlZC1ieTogSmFtZXMg
TW9yc2UgPGphbWVzLm1vcnNlQGFybS5jb20+CkFja2VkLWJ5OiBKYW1lcyBNb3JzZSA8amFtZXMu
bW9yc2VAYXJtLmNvbT4KCgpUaGFua3MsCgpKYW1lcwoKLS0tLS0KQmVmb3JlIHRoaXMgcGF0Y2gs
IGFuIGFhcmNoMzIgZ3Vlc3Qgb2YgYSBCRSBob3N0IHJlYWRpbmcgc3lzcmVncyBLVk0gaXMgdHJh
cC1hbmQtdW5kZWZmaW5nCmdldHM6CnwgQmFkIG1vZGUgaW4gcHJlZmV0Y2ggYWJvcnQgaGFuZGxl
ciBkZXRlY3RlZAp8IEludGVybmFsIGVycm9yOiBPb3BzIC0gYmFkIG1vZGU6IDAgWyMxXSBTTVAg
VEhVTUIyCnwgTW9kdWxlcyBsaW5rZWQgaW46CnwgQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVy
LzAgTm90IHRhaW50ZWQgNS43LjArICMyNjAKfCBIYXJkd2FyZSBuYW1lOiBHZW5lcmljIERUIGJh
c2VkIHN5c3RlbQp8IFBDIGlzIGF0IDB4NAp8IExSIGlzIGF0IHNtcF9jcHVzX2RvbmUrMHg4NS8w
eDk4CnwgcGMgOiBbPDAwMDAwMDA0Pl0gICAgbHIgOiBbPDgwODAzNWNiPl0gICAgcHNyOiA2MDAw
MDA5Ygp8IHNwIDogOWY0YTFmMDggIGlwIDogMDAwMDAwMDMgIGZwIDogMDAwMDAwMDAKfCByMTA6
IDAwMDAwMDAwICByOSA6IDAwMDAwMDAwICByOCA6IDAwMDAwMDAwCnwgcjcgOiA4MDkwNGVhOCAg
cjYgOiA4MDkwNGY2YyAgcjUgOiAwMDAwMDAwMiAgcjQgOiAwMDBmNDI0MAp8IHIzIDogYmM2MDVj
MTIgIHIyIDogYmM2MDVjMTIgIHIxIDogMWYzOGMwMDAgIHIwIDogMDAwMGMzNDgKfCBGbGFnczog
blpDdiAgSVJRcyBvZmYgIEZJUXMgb24gIE1vZGUgVU5EXzMyICBJU0EgQVJNICBTZWdtZW50IG5v
bmUKfCBDb250cm9sOiA1MGM1MzgzZCAgVGFibGU6IDgwMDA0MDZhICBEQUM6IGJjNjA1YzEyCnwg
UHJvY2VzcyBzd2FwcGVyLzAgKHBpZDogMSwgc3RhY2sgbGltaXQgPSAweChwdHJ2YWwpKQpbLi4u
XQp8IFs8ODA4MDM1Y2I+XSAoc21wX2NwdXNfZG9uZSkgZnJvbSBbPDAwMDAwMDAyPl0gKDB4MikK
fCBDb2RlOiBiYWQgUEMgdmFsdWUKfCAtLS1bIGVuZCB0cmFjZSBiMzcyNzViZjQ4OWNhMjI1IF0t
LS0KCgppbnN0ZWFkIG9mIHRoZSB1bmRlZiBpdCBzbyByaWNobHkgZGVzZXJ2ZWQ6CnwgSW50ZXJu
YWwgZXJyb3I6IE9vcHMgLSB1bmRlZmluZWQgaW5zdHJ1Y3Rpb246IDAgWyMxXSBTTVAgVEhVTUIy
CnwgTW9kdWxlcyBsaW5rZWQgaW46CnwgQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90
IHRhaW50ZWQgNS43LjArICMyNjAKfCBIYXJkd2FyZSBuYW1lOiBHZW5lcmljIERUIGJhc2VkIHN5
c3RlbQp8IFBDIGlzIGF0IHNtcF9jcHVzX2RvbmUrMHg4OC8weDk4CnwgTFIgaXMgYXQgc21wX2Nw
dXNfZG9uZSsweDg1LzB4OTgKfCBwYyA6IFs8ODA4MDM1Y2U+XSAgICBsciA6IFs8ODA4MDM1Y2I+
XSAgICBwc3I6IDYwMDAwMDczCnwgc3AgOiA5ZjQ5NWY1MCAgaXAgOiAwMDAwMDAwMSAgZnAgOiAw
MDAwMDAwMAp8IHIxMDogMDAwMDAwMDAgIHI5IDogMDAwMDAwMDAgIHI4IDogMDAwMDAwMDAKfCBy
NyA6IDgwOTA0ZWE4ICByNiA6IDgwOTA0ZjZjICByNSA6IDAwMDAwMDAxICByNCA6IDAwMDdhMTIw
CnwgcjMgOiA3ZjM4MjhkMiAgcjIgOiA3ZjM4MjhkMiAgcjEgOiAxZjM5ZjAwMCAgcjAgOiAwMDAw
YzM0OAp8IEZsYWdzOiBuWkN2ICBJUlFzIG9uICBGSVFzIG9mZiAgTW9kZSBTVkNfMzIgIElTQSBU
aHVtYiAgU2VnbWVudCBub25lCnwgQ29udHJvbDogNTBjNTM4M2QgIFRhYmxlOiA4MDAwNDA2YSAg
REFDOiAwMDAwMDA1MQp8IFByb2Nlc3Mgc3dhcHBlci8wIChwaWQ6IDEsIHN0YWNrIGxpbWl0ID0g
MHgocHRydmFsKSkKWy4uLl0KfCBbPDgwODAzNWNlPl0gKHNtcF9jcHVzX2RvbmUpIGZyb20gWzw4
MDgwMGY3Mz5dIChrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGRmLzB4MjA0KQp8IFs8ODA4MDBmNzM+
XSAoa2VybmVsX2luaXRfZnJlZWFibGUpIGZyb20gWzw4MDVhYTJhNz5dIChrZXJuZWxfaW5pdCsw
eDcvMHhjOCkKfCBbPDgwNWFhMmE3Pl0gKGtlcm5lbF9pbml0KSBmcm9tIFs8ODAxMDAxNTk+XSAo
cmV0X2Zyb21fZm9yaysweDExLzB4MzgpCnwgQ29kZTogZjdmZiBmOGI5IGYyNGMgMzA0OCAoZWUx
MSkgMWYzMAp8IC0tLVsgZW5kIHRyYWNlIDRjNzhkY2Q4NDYwZTYwNDEgXS0tLQoKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
