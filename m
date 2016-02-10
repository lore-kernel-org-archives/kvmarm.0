From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 1/8] arm64: KVM: Switch the sys_reg search to be a binary
 search
Date: Wed, 10 Feb 2016 13:49:14 +0000
Message-ID: <87ziv8vfol.fsf@linaro.org>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A582E49B21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 08:43:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GmcoMPyjiG8M for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Feb 2016 08:43:26 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 869BC49B07
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 08:43:26 -0500 (EST)
Received: by mail-wm0-f53.google.com with SMTP id 128so27551352wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 05:49:18 -0800 (PST)
In-reply-to: <1454931622-14902-2-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Ck1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+IHdyaXRlczoKCj4gT3VyIDY0Yml0
IHN5c19yZWcgdGFibGUgaXMgYWJvdXQgOTAgZW50cmllcyBsb25nIChzbyBmYXIsIGFuZCB0aGUK
PiBQTVUgc3VwcG9ydCBpcyBsaWtlbHkgdG8gaW5jcmVhc2UgdGhpcykuIFRoaXMgbWVhbnMgdGhh
dCBvbiBhdmVyYWdlLAo+IGl0IHRha2VzIDQ1IGNvbXBhcmFpc29ucyB0byBmaW5kIHRoZSByaWdo
dCBlbnRyeSAoYW5kIGFjdHVhbGx5IHRoZQo+IGZ1bGwgOTAgaWYgd2UgaGF2ZSB0byBzZWFyY2gg
dGhlIGludmFyaWFudCB0YWJsZSkuCj4KPiBOb3QgdGhlIG1vc3QgZWZmaWNpZW50IHRoaW5nLiBT
cGVjaWFsbHkgd2hlbiB5b3UgdGhpbmsgdGhhdCB0aGlzCj4gdGFibGUgaXMgYWxyZWFkeSBzb3J0
ZWQuIFN3aXRjaGluZyB0byBhIGJpbmFyeSBzZWFyY2ggZWZmZWN0aXZlbHkKPiByZWR1Y2VzIHRo
ZSBzZWFyY2ggdG8gYWJvdXQgNyBjb21wYXJhaXNvbnMuIFNsaWdodGx5IGJldHRlciEKCklzIHRo
ZXJlIGFuIGFyZ3VtZW50IGZvciBtYWtpbmcgdGhpcyBhIGhhc2ggdGFibGUgaW5zdGVhZCBvciBp
cyB0aGlzIG5vdApwb3NzaWJsZSBhcyB5b3Ugd291bGQgaGF2ZSB0byB1c2UgZHluYW1pY2FsbHkg
YWxsb2NhdGVkIGluc3RlYWQ/CgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
