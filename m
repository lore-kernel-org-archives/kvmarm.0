From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/6] lib/pci: fix BAR format strings
Date: Thu, 12 Jan 2017 13:35:58 +0100
Message-ID: <faf255f3-2a97-4b94-9866-161060f646a1@redhat.com>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-3-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 362DB403F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 07:34:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PDQ2eJ0-AVnK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 07:34:14 -0500 (EST)
Received: from mail-wj0-f195.google.com (mail-wj0-f195.google.com
 [209.85.210.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B2154027C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 07:34:13 -0500 (EST)
Received: by mail-wj0-f195.google.com with SMTP id ey1so1722840wjd.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 04:35:59 -0800 (PST)
In-Reply-To: <20170111162841.15569-3-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, drjones@redhat.com
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAxMS8wMS8yMDE3IDE3OjI4LCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4gVXNpbmcgJXggYXMg
YSBmb3JtYXQgc3RyaW5nIGlzIG5vdCBwb3J0YWJsZSBhY3Jvc3MgMzIvNjQgYml0IGJ1aWxkcy4K
PiBVc2UgZXhwbGljaXQgUFJJeDMyIGZvcm1hdCBzdHJpbmdzIGxpa2UgdGhlIDY0IGJpdCB2ZXJz
aW9uIGFib3ZlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVA
bGluYXJvLm9yZz4KPiAtLS0KPiAgbGliL3BjaS5jIHwgNCArKy0tCj4gIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2xpYi9w
Y2kuYyBiL2xpYi9wY2kuYwo+IGluZGV4IDY0MTYxOTEuLjU5N2Q4ZjIgMTAwNjQ0Cj4gLS0tIGEv
bGliL3BjaS5jCj4gKysrIGIvbGliL3BjaS5jCj4gQEAgLTY3LDcgKzY3LDcgQEAgYm9vbCBwY2lf
c2V0dXBfbXNpKHN0cnVjdCBwY2lfZGV2ICpkZXYsIHVpbnQ2NF90IG1zaV9hZGRyLCB1aW50MzJf
dCBtc2lfZGF0YSkKPiAgCQlwY2lfY29uZmlnX3dyaXRlbChhZGRyLCBvZmZzZXQgKyBQQ0lfTVNJ
X0RBVEFfMzIsIG1zaV9kYXRhKTsKPiAgCQlwcmludGYoIk1TSTogZGV2IDB4JXggaW5pdCAzMmJp
dCBhZGRyZXNzOiAiLCBhZGRyKTsKPiAgCX0KPiAtCXByaW50ZigiYWRkcj0weCVseCwgZGF0YT0w
eCV4XG4iLCBtc2lfYWRkciwgbXNpX2RhdGEpOwo+ICsJcHJpbnRmKCJhZGRyPTB4JSIgUFJJeDY0
ICIsIGRhdGE9MHglIiBQUkl4MzIgIlxuIiwgbXNpX2FkZHIsIG1zaV9kYXRhKTsKCkFwcGx5aW5n
IG9ubHkgdGhlICVseCAtPiAlIlBSSXg2NCIgY2hhbmdlIGZvciBub3cgKHRob3VnaCBpdCdzIGFs
c28gaW4KQW5kcmV3J3MgMzItYml0IGNvbXBpbGF0aW9uIGZpeGVzIHBhdGNoKS4KClBhb2xvCj4g
IAo+ICAJbXNpX2NvbnRyb2wgfD0gUENJX01TSV9GTEFHU19FTkFCTEU7Cj4gIAlwY2lfY29uZmln
X3dyaXRldyhhZGRyLCBvZmZzZXQgKyBQQ0lfTVNJX0ZMQUdTLCBtc2lfY29udHJvbCk7Cj4gQEAg
LTIzNyw3ICsyMzcsNyBAQCB2b2lkIHBjaV9iYXJfcHJpbnQoc3RydWN0IHBjaV9kZXYgKmRldiwg
aW50IGJhcl9udW0pCj4gIAkJcHJpbnRmKCJCQVIjJWQsJWQgWyUiIFBSSXg2NCAiLSUiIFBSSXg2
NCAiICIsCj4gIAkJICAgICAgIGJhcl9udW0sIGJhcl9udW0gKyAxLCBzdGFydCwgZW5kKTsKPiAg
CX0gZWxzZSB7Cj4gLQkJcHJpbnRmKCJCQVIjJWQgWyUwMngtJTAyeCAiLAo+ICsJCXByaW50Zigi
QkFSIyVkIFslIiBQUkl4MzIgIi0lIiBQUkl4MzIgIiAiLAo+ICAJCSAgICAgICBiYXJfbnVtLCAo
dWludDMyX3Qpc3RhcnQsICh1aW50MzJfdCllbmQpOwo+ICAJfQo+ICAKPiAKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
