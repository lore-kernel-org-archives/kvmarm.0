Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A17C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 07:08:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C11B49F04;
	Tue, 29 Mar 2022 03:08:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ekv6CJjm79+H; Tue, 29 Mar 2022 03:08:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BD354B0B6;
	Tue, 29 Mar 2022 03:08:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E51749F14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 02:14:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0PE2DGKHnBTk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2022 02:14:24 -0400 (EDT)
Received: from ha.nfschina.com (mail.nfschina.com [124.16.136.209])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2A2343C72
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 02:14:24 -0400 (EDT)
Received: from localhost (unknown [127.0.0.1])
 by ha.nfschina.com (Postfix) with ESMTP id 6261E1E80D78;
 Tue, 29 Mar 2022 14:13:47 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
 by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BrCJMHfyAm77; Tue, 29 Mar 2022 14:13:44 +0800 (CST)
Received: from [18.165.124.108] (unknown [101.228.248.165])
 (Authenticated sender: yuzhe@nfschina.com)
 by ha.nfschina.com (Postfix) with ESMTPA id EB7331E80D75;
 Tue, 29 Mar 2022 14:13:43 +0800 (CST)
Message-ID: <0f4cf955-ca2b-626f-867e-5a0ecfe68ca1@nfschina.com>
Date: Tue, 29 Mar 2022 14:14:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: arm64: vgic-debug: remove unnecessary type castings
To: Marc Zyngier <maz@kernel.org>
References: <20220328103836.2829-1-yuzhe@nfschina.com>
 <87h77ifbbd.wl-maz@kernel.org>
From: yuzhe <yuzhe@nfschina.com>
In-Reply-To: <87h77ifbbd.wl-maz@kernel.org>
X-Mailman-Approved-At: Tue, 29 Mar 2022 03:08:01 -0400
Cc: will@kernel.org, catalin.marinas@arm.com, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, liqiong@nfschina.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

5ZyoIDIwMjIvMy8yOCAyMTozNiwgTWFyYyBaeW5naWVyIOWGmemBkzoKCj4gT24gTW9uLCAyOCBN
YXIgMjAyMiAxMTozODozNiArMDEwMCwKPiB5dXpoZSA8eXV6aGVAbmZzY2hpbmEuY29tPiB3cm90
ZToKPj4gcmVtb3ZlIHVubmVjZXNzYXJ5IGNhc3RpbmdzLCBmcm9tICJ2b2lkICoiIHRvICJzdHJ1
Y3Qga3ZtICoiCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IHl1emhlIDx5dXpoZUBuZnNjaGluYS5jb20+
Cj4+IC0tLQo+PiAgIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1kZWJ1Zy5jIHwgOCArKysrLS0t
LQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4+
Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtZGVidWcuYyBiL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy1kZWJ1Zy5jCj4+IGluZGV4IGYzOGM0MGE3NjI1MS4uOTI3ZTVj
MWY2NTBkIDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtZGVidWcuYwo+
PiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtZGVidWcuYwo+PiBAQCAtODIsNyArODIs
NyBAQCBzdGF0aWMgYm9vbCBlbmRfb2ZfdmdpYyhzdHJ1Y3QgdmdpY19zdGF0ZV9pdGVyICppdGVy
KQo+PiAgIAo+PiAgIHN0YXRpYyB2b2lkICp2Z2ljX2RlYnVnX3N0YXJ0KHN0cnVjdCBzZXFfZmls
ZSAqcywgbG9mZl90ICpwb3MpCj4+ICAgewo+PiAtCXN0cnVjdCBrdm0gKmt2bSA9IChzdHJ1Y3Qg
a3ZtICopcy0+cHJpdmF0ZTsKPj4gKwlzdHJ1Y3Qga3ZtICprdm0gPSBzLT5wcml2YXRlOwo+PiAg
IAlzdHJ1Y3QgdmdpY19zdGF0ZV9pdGVyICppdGVyOwo+PiAgIAo+PiAgIAltdXRleF9sb2NrKCZr
dm0tPmxvY2spOwo+PiBAQCAtMTEwLDcgKzExMCw3IEBAIHN0YXRpYyB2b2lkICp2Z2ljX2RlYnVn
X3N0YXJ0KHN0cnVjdCBzZXFfZmlsZSAqcywgbG9mZl90ICpwb3MpCj4+ICAgCj4+ICAgc3RhdGlj
IHZvaWQgKnZnaWNfZGVidWdfbmV4dChzdHJ1Y3Qgc2VxX2ZpbGUgKnMsIHZvaWQgKnYsIGxvZmZf
dCAqcG9zKQo+PiAgIHsKPj4gLQlzdHJ1Y3Qga3ZtICprdm0gPSAoc3RydWN0IGt2bSAqKXMtPnBy
aXZhdGU7Cj4+ICsJc3RydWN0IGt2bSAqa3ZtID0gcy0+cHJpdmF0ZTsKPj4gICAJc3RydWN0IHZn
aWNfc3RhdGVfaXRlciAqaXRlciA9IGt2bS0+YXJjaC52Z2ljLml0ZXI7Cj4+ICAgCj4+ICAgCSsr
KnBvczsKPj4gQEAgLTEyMiw3ICsxMjIsNyBAQCBzdGF0aWMgdm9pZCAqdmdpY19kZWJ1Z19uZXh0
KHN0cnVjdCBzZXFfZmlsZSAqcywgdm9pZCAqdiwgbG9mZl90ICpwb3MpCj4+ICAgCj4+ICAgc3Rh
dGljIHZvaWQgdmdpY19kZWJ1Z19zdG9wKHN0cnVjdCBzZXFfZmlsZSAqcywgdm9pZCAqdikKPj4g
ICB7Cj4+IC0Jc3RydWN0IGt2bSAqa3ZtID0gKHN0cnVjdCBrdm0gKilzLT5wcml2YXRlOwo+PiAr
CXN0cnVjdCBrdm0gKmt2bSA9IHMtPnByaXZhdGU7Cj4+ICAgCXN0cnVjdCB2Z2ljX3N0YXRlX2l0
ZXIgKml0ZXI7Cj4+ICAgCj4+ICAgCS8qCj4+IEBAIC0yMjksNyArMjI5LDcgQEAgc3RhdGljIHZv
aWQgcHJpbnRfaXJxX3N0YXRlKHN0cnVjdCBzZXFfZmlsZSAqcywgc3RydWN0IHZnaWNfaXJxICpp
cnEsCj4+ICAgCj4+ICAgc3RhdGljIGludCB2Z2ljX2RlYnVnX3Nob3coc3RydWN0IHNlcV9maWxl
ICpzLCB2b2lkICp2KQo+PiAgIHsKPj4gLQlzdHJ1Y3Qga3ZtICprdm0gPSAoc3RydWN0IGt2bSAq
KXMtPnByaXZhdGU7Cj4+ICsJc3RydWN0IGt2bSAqa3ZtID0gcy0+cHJpdmF0ZTsKPj4gICAJc3Ry
dWN0IHZnaWNfc3RhdGVfaXRlciAqaXRlciA9IChzdHJ1Y3QgdmdpY19zdGF0ZV9pdGVyICopdjsK
PiBIb3cgYWJvdXQgeW91IGZ1bGx5IGdldCByaWQgb2YgdGhlIHVubmVjZXNzYXJ5IGNhc3RzIHRo
ZW4/Cj4KPiAJTS4KCkkgZG9uJ3Qga25vdyB3aGF0IHlvdSBleGFjdGx5IG1lYW4uIEkgZm9sbG93
IHRoZSBrZXJuZWwtamFuaXRvcnMvVE9ETyBMaXN0IHRvIGdldCByaWQgb2YgdGhlIHVubmVjZXNz
YXJ5IGNhc3RzLgpBbmQgSSBjaGVja2VkIGFsbCB0aGUgY29kZSBpbiB0aGUgYXJjaCBkaXJlY3Rv
cnkgYW5kIGZvdW5kIHRoZXNlIGlzc3Vlcy4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
