From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Add braces to multi-line if statement in
 virtual PMU code
Date: Fri, 1 Apr 2016 13:30:40 +0200
Message-ID: <20160401113040.GD20224@cbox>
References: <1459509142-13524-1-git-send-email-will.deacon@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5873040F77
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 07:29:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MKxpX1zbxEem for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2016 07:29:31 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D78C40C9D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 07:29:31 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id p65so21985895wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2016 04:30:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459509142-13524-1-git-send-email-will.deacon@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gRnJpLCBBcHIgMDEsIDIwMTYgYXQgMTI6MTI6MjJQTSArMDEwMCwgV2lsbCBEZWFjb24gd3Jv
dGU6Cj4gVGhlIGtlcm5lbCBpcyB3cml0dGVuIGluIEMsIG5vdCBweXRob24sIHNvIHdlIG5lZWQg
YnJhY2VzIGFyb3VuZAo+IG11bHRpLWxpbmUgaWYgc3RhdGVtZW50cy4gR0NDIDYgYWN0dWFsbHkg
d2FybnMgYWJvdXQgdGhpcywgdGhhbmtzIHRvIHRoZQo+IGZhbnRhc3RpYyBuZXcgIi1XbWlzbGVh
ZGluZy1pbmRlbnRhdGlvbiIgZmxhZzoKCldlIHNob3VsZCByZXdyaXRlIHRoZSBrZXJuZWwgaW4g
cHl0aG9uIQoKPiAKPiAgfCB2aXJ0L2t2bS9hcm0vcG11LmM6IEluIGZ1bmN0aW9uIOKAmGt2bV9w
bXVfb3ZlcmZsb3dfc3RhdHVz4oCZOgo+ICB8IHZpcnQva3ZtL2FybS9wbXUuYzoxOTg6Mzogd2Fy
bmluZzogc3RhdGVtZW50IGlzIGluZGVudGVkIGFzIGlmIGl0IHdlcmUgZ3VhcmRlZCBieS4uLiBb
LVdtaXNsZWFkaW5nLWluZGVudGF0aW9uXQo+ICB8ICAgIHJlZyAmPSB2Y3B1X3N5c19yZWcodmNw
dSwgUE1DTlRFTlNFVF9FTDApOwo+ICB8ICAgIF5+fgo+ICB8IGFyY2gvYXJtNjQva3ZtLy4uLy4u
Ly4uL3ZpcnQva3ZtL2FybS9wbXUuYzoxOTY6Mjogbm90ZTogLi4udGhpcyDigJhpZuKAmSBjbGF1
c2UsIGJ1dCBpdCBpcyBub3QKPiAgfCAgIGlmICgodmNwdV9zeXNfcmVnKHZjcHUsIFBNQ1JfRUww
KSAmIEFSTVY4X1BNVV9QTUNSX0UpKQo+ICB8ICAgXn4KPiAKPiBBcyBpdCB0dXJucyBvdXQsIHRo
aXMgcGFydGljdWxhciBjYXNlIGlzIGhhcm1sZXNzICh3ZSBqdXN0IGRvIHNvbWUgJj0KPiBvcGVy
YXRpb25zIHdpdGggMCksIGJ1dCB3b3J0aCBmaXhpbmcgbm9uZXRoZWxlc3MuCj4gCj4gU2lnbmVk
LW9mZi1ieTogV2lsbCBEZWFjb24gPHdpbGwuZGVhY29uQGFybS5jb20+CgpUaGFua3MgZm9yIHRo
ZSBwYXRjaC4KCi1DaHJpc3RvZmZlcgoKPiAtLS0KPiAgdmlydC9rdm0vYXJtL3BtdS5jIHwgMyAr
Ky0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+IAo+
IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vcG11LmMgYi92aXJ0L2t2bS9hcm0vcG11LmMKPiBp
bmRleCBiNTc1NGM2YzU1MDguLjU3NWM3YWEzMGQ3ZSAxMDA2NDQKPiAtLS0gYS92aXJ0L2t2bS9h
cm0vcG11LmMKPiArKysgYi92aXJ0L2t2bS9hcm0vcG11LmMKPiBAQCAtMTkzLDExICsxOTMsMTIg
QEAgc3RhdGljIHU2NCBrdm1fcG11X292ZXJmbG93X3N0YXR1cyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpCj4gIHsKPiAgCXU2NCByZWcgPSAwOwo+ICAKPiAtCWlmICgodmNwdV9zeXNfcmVnKHZjcHUs
IFBNQ1JfRUwwKSAmIEFSTVY4X1BNVV9QTUNSX0UpKQo+ICsJaWYgKCh2Y3B1X3N5c19yZWcodmNw
dSwgUE1DUl9FTDApICYgQVJNVjhfUE1VX1BNQ1JfRSkpIHsKPiAgCQlyZWcgPSB2Y3B1X3N5c19y
ZWcodmNwdSwgUE1PVlNTRVRfRUwwKTsKPiAgCQlyZWcgJj0gdmNwdV9zeXNfcmVnKHZjcHUsIFBN
Q05URU5TRVRfRUwwKTsKPiAgCQlyZWcgJj0gdmNwdV9zeXNfcmVnKHZjcHUsIFBNSU5URU5TRVRf
RUwxKTsKPiAgCQlyZWcgJj0ga3ZtX3BtdV92YWxpZF9jb3VudGVyX21hc2sodmNwdSk7Cj4gKwl9
Cj4gIAo+ICAJcmV0dXJuIHJlZzsKPiAgfQo+IC0tIAo+IDIuMS40Cj4gCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
