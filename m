From: zichao <zhichao.huang@linaro.org>
Subject: Re: [PATCH v2 04/11] KVM: arm: common infrastructure for handling
 AArch32 CP14/CP15
Date: Mon, 15 Jun 2015 00:17:23 +0800
Message-ID: <557DA913.5030205@linaro.org>
References: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org>
 <1433046432-1824-5-git-send-email-zhichao.huang@linaro.org>
 <87y4jt6tyw.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A870A54F72
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 Jun 2015 12:07:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Bnia7tO-qIY for <kvmarm@lists.cs.columbia.edu>;
 Sun, 14 Jun 2015 12:07:00 -0400 (EDT)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
 [209.85.220.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3B0C54F53
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 Jun 2015 12:07:00 -0400 (EDT)
Received: by padev16 with SMTP id ev16so50312962pad.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 Jun 2015 09:17:30 -0700 (PDT)
In-Reply-To: <87y4jt6tyw.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, huangzhichao@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAyMDE1LzYvOSAxODo0NSwgQWxleCBCZW5uw6llIHdyb3RlOgo+IAo+IFpoaWNoYW8gSHVh
bmcgPHpoaWNoYW8uaHVhbmdAbGluYXJvLm9yZz4gd3JpdGVzOgo+IAo+PiBBcyB3ZSdyZSBhYm91
dCB0byB0cmFwIGEgYnVuY2ggb2YgQ1AxNCByZWdpc3RlcnMsIGxldCdzIHJld29yawo+PiB0aGUg
Q1AxNSBoYW5kbGluZyBzbyBpdCBjYW4gYmUgZ2VuZXJhbGl6ZWQgYW5kIHdvcmsgd2l0aCBtdWx0
aXBsZQo+PiB0YWJsZXMuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFpoaWNoYW8gSHVhbmcgPHpoaWNo
YW8uaHVhbmdAbGluYXJvLm9yZz4KPj4gLS0tCj4+ICBhcmNoL2FybS9rdm0vY29wcm9jLmMgICAg
ICAgICAgfCAxNzYgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0KPj4g
IGFyY2gvYXJtL2t2bS9pbnRlcnJ1cHRzX2hlYWQuUyB8ICAgMiArLQo+PiAgMiBmaWxlcyBjaGFu
Z2VkLCAxMTIgaW5zZXJ0aW9ucygrKSwgNjYgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQg
YS9hcmNoL2FybS9rdm0vY29wcm9jLmMgYi9hcmNoL2FybS9rdm0vY29wcm9jLmMKPj4gaW5kZXgg
OWQyODNkOS4uZDIzMzk1YiAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm0va3ZtL2NvcHJvYy5jCj4+
ICsrKyBiL2FyY2gvYXJtL2t2bS9jb3Byb2MuYwo+PiBAQCAtMzc1LDYgKzM3NSw5IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgY29wcm9jX3JlZyBjcDE1X3JlZ3NbXSA9IHsKPj4gIAl7IENSbigxNSks
IENSbSggMCksIE9wMSggNCksIE9wMiggMCksIGlzMzIsIGFjY2Vzc19jYmFyfSwKPj4gIH07Cj4+
ICAKPj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgY29wcm9jX3JlZyBjcDE0X3JlZ3NbXSA9IHsKPj4g
K307Cj4+ICsKPj4gIC8qIFRhcmdldCBzcGVjaWZpYyBlbXVsYXRpb24gdGFibGVzICovCj4+ICBz
dGF0aWMgc3RydWN0IGt2bV9jb3Byb2NfdGFyZ2V0X3RhYmxlICp0YXJnZXRfdGFibGVzW0tWTV9B
Uk1fTlVNX1RBUkdFVFNdOwo+PiAgCj4+IEBAIC00MjQsNDcgKzQyNyw3NSBAQCBzdGF0aWMgY29u
c3Qgc3RydWN0IGNvcHJvY19yZWcgKmZpbmRfcmVnKGNvbnN0IHN0cnVjdCBjb3Byb2NfcGFyYW1z
ICpwYXJhbXMsCj4+ICAJcmV0dXJuIE5VTEw7Cj4+ICB9Cj4+ICAKPj4gLXN0YXRpYyBpbnQgZW11
bGF0ZV9jcDE1KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gLQkJCWNvbnN0IHN0cnVjdCBjb3By
b2NfcGFyYW1zICpwYXJhbXMpCj4+ICsvKgo+PiArICogZW11bGF0ZV9jcCAtLSAgdHJpZXMgdG8g
bWF0Y2ggYSBjcDE0L2NwMTUgYWNjZXNzIGluIGEgaGFuZGxpbmcgdGFibGUsCj4+ICsgKiAgICAg
ICAgICAgICAgICBhbmQgY2FsbCB0aGUgY29ycmVzcG9uZGluZyB0cmFwIGhhbmRsZXIuCj4+ICsg
Kgo+PiArICogQHBhcmFtczogcG9pbnRlciB0byB0aGUgZGVzY3JpcHRvciBvZiB0aGUgYWNjZXNz
Cj4+ICsgKiBAdGFibGU6IGFycmF5IG9mIHRyYXAgZGVzY3JpcHRvcnMKPj4gKyAqIEBudW06IHNp
emUgb2YgdGhlIHRyYXAgZGVzY3JpcHRvciBhcnJheQo+PiArICoKPj4gKyAqIFJldHVybiAwIGlm
IHRoZSBhY2Nlc3MgaGFzIGJlZW4gaGFuZGxlZCwgYW5kIC0xIGlmIG5vdC4KPj4gKyAqLwo+PiAr
c3RhdGljIGludCBlbXVsYXRlX2NwKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gKwkJCWNvbnN0
IHN0cnVjdCBjb3Byb2NfcGFyYW1zICpwYXJhbXMsCj4+ICsJCQljb25zdCBzdHJ1Y3QgY29wcm9j
X3JlZyAqdGFibGUsCj4+ICsJCQlzaXplX3QgbnVtKQo+PiAgewo+PiAtCXNpemVfdCBudW07Cj4+
IC0JY29uc3Qgc3RydWN0IGNvcHJvY19yZWcgKnRhYmxlLCAqcjsKPj4gLQo+PiAtCXRyYWNlX2t2
bV9lbXVsYXRlX2NwMTVfaW1wKHBhcmFtcy0+T3AxLCBwYXJhbXMtPlJ0MSwgcGFyYW1zLT5DUm4s
Cj4+IC0JCQkJICAgcGFyYW1zLT5DUm0sIHBhcmFtcy0+T3AyLAo+PiBwYXJhbXMtPmlzX3dyaXRl
KTsKPiAKPiBXaGVyZSBoYXMgdGhpcyB0cmFjZSBnb25lPyBXZSBzdGlsbCB3YW50IHRvIGJlIGFi
bGUgdG8gdmlldyByZWdpc3Rlcgo+IHRyYXBzIHdoZW4gZGVidWdnaW5nLgo+IAoKT0ssIEkgd2ls
bCBhZGQgaXQgaW4gdjMgcGF0Y2hlcy4KCj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
