From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v11 07/19] arm64: fpsimd: Avoid FPSIMD context leakage for
 the init task
Date: Fri, 25 May 2018 11:01:11 +0100
Message-ID: <87sh6grr4o.fsf@linaro.org>
References: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
 <1527181008-13549-8-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14ACA4A0D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 05:51:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W3mSPfWUdNLV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 05:50:49 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29CD149F7F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 05:50:29 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id m129-v6so12991169wmb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 03:01:13 -0700 (PDT)
In-reply-to: <1527181008-13549-8-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFRoZSBpbml0IHRh
c2sgaXMgc3RhcnRlZCB3aXRoIHRocmVhZF9mbGFncyBlcXVhbCB0byAwLCB3aGljaCBtZWFucwo+
IHRoYXQgVElGX0ZPUkVJR05fRlBTVEFURSBpcyBpbml0aWFsbHkgY2xlYXIuCj4KPiBJdCBpcyB0
aGVvcmV0aWNhbGx5IHBvc3NpYmxlIChpZiB1bmxpa2VseSkgdGhhdCB0aGUgaW5pdCB0YXNrIGNv
dWxkCj4gcmVhY2ggdXNlcnNwYWNlIHdpdGhvdXQgZXZlciBiZWluZyBzY2hlZHVsZWQgb3V0LiAg
SWYgdGhpcyBvY2N1cnMsCj4gZGF0YSBsZWZ0IGluIHRoZSBGUFNJTUQgcmVnaXN0ZXJzIGJ5IHRo
ZSBrZXJuZWwgY291bGQgYmUgZXhwb3NlZC4KPgo+IFRoaXMgcGF0Y2ggZml4ZXMgdGhpcyBhbm9t
YWx5IGJ5IGVuc3VyaW5nIHRoYXQgdGhlIGluaXQgdGFzaydzCj4gaW5pdGlhbCBUSUZfRk9SRUlH
Tl9GUFNUQVRFIGlzIHNldC4KPgo+IFNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1h
cnRpbkBhcm0uY29tPgo+IEZpeGVzOiAwMDVmNzhjZDg4NDkgKCJhcm02NDogZGVmZXIgcmVsb2Fk
aW5nIGEgdGFzaydzIEZQU0lNRCBzdGF0ZSB0byB1c2VybGFuZCByZXN1bWUiKQo+IFJldmlld2Vk
LWJ5OiBDYXRhbGluIE1hcmluYXMgPGNhdGFsaW4ubWFyaW5hc0Bhcm0uY29tPgo+IFJldmlld2Vk
LWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CgpTdGlsbCBnb29kIDst
KQoKPiBDYzogV2lsbCBEZWFjb24gPHdpbGwuZGVhY29uQGFybS5jb20+Cj4gQ2M6IEFyZCBCaWVz
aGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPgo+Cj4gLS0tCj4KPiBDaGFuZ2VzIHNp
bmNlIHYxMDoKPgo+ICAqIE5ldyBwYXRjaC4KPiAtLS0KPiAgYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS90aHJlYWRfaW5mby5oIHwgMTMgKysrKysrKy0tLS0tLQo+ICAxIGZpbGUgY2hhbmdlZCwgNyBp
bnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQo+Cj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
aW5jbHVkZS9hc20vdGhyZWFkX2luZm8uaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vdGhyZWFk
X2luZm8uaAo+IGluZGV4IDc0MGFhMDNjLi5hZjI3MWY5IDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20vdGhyZWFkX2luZm8uaAo+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20vdGhyZWFkX2luZm8uaAo+IEBAIC00NSwxMiArNDUsNiBAQCBzdHJ1Y3QgdGhyZWFkX2luZm8g
ewo+ICAJaW50CQkJcHJlZW1wdF9jb3VudDsJLyogMCA9PiBwcmVlbXB0YWJsZSwgPDAgPT4gYnVn
ICovCj4gIH07Cj4KPiAtI2RlZmluZSBJTklUX1RIUkVBRF9JTkZPKHRzaykJCQkJCQlcCj4gLXsJ
CQkJCQkJCQlcCj4gLQkucHJlZW1wdF9jb3VudAk9IElOSVRfUFJFRU1QVF9DT1VOVCwJCQkJXAo+
IC0JLmFkZHJfbGltaXQJPSBLRVJORUxfRFMsCQkJCQlcCj4gLX0KPiAtCj4gICNkZWZpbmUgdGhy
ZWFkX3NhdmVkX3BjKHRzaykJXAo+ICAJKCh1bnNpZ25lZCBsb25nKSh0c2stPnRocmVhZC5jcHVf
Y29udGV4dC5wYykpCj4gICNkZWZpbmUgdGhyZWFkX3NhdmVkX3NwKHRzaykJXAo+IEBAIC0xMTcs
NSArMTExLDEyIEBAIHZvaWQgYXJjaF9yZWxlYXNlX3Rhc2tfc3RydWN0KHN0cnVjdCB0YXNrX3N0
cnVjdCAqdHNrKTsKPiAgCQkJCSBfVElGX1NZU0NBTExfVFJBQ0VQT0lOVCB8IF9USUZfU0VDQ09N
UCB8IFwKPiAgCQkJCSBfVElGX05PSFopCj4KPiArI2RlZmluZSBJTklUX1RIUkVBRF9JTkZPKHRz
aykJCQkJCQlcCj4gK3sJCQkJCQkJCQlcCj4gKwkuZmxhZ3MJCT0gX1RJRl9GT1JFSUdOX0ZQU1RB
VEUsCQkJCVwKPiArCS5wcmVlbXB0X2NvdW50CT0gSU5JVF9QUkVFTVBUX0NPVU5ULAkJCQlcCj4g
KwkuYWRkcl9saW1pdAk9IEtFUk5FTF9EUywJCQkJCVwKPiArfQo+ICsKPiAgI2VuZGlmIC8qIF9f
S0VSTkVMX18gKi8KPiAgI2VuZGlmIC8qIF9fQVNNX1RIUkVBRF9JTkZPX0ggKi8KCgotLQpBbGV4
IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
