Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B627C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 09:13:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0BBB229C7
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 09:13:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0BBB229C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0924B4B23A;
	Tue,  5 Jan 2021 04:13:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DUsn+2z2lVmQ; Tue,  5 Jan 2021 04:13:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 131A74B2D3;
	Tue,  5 Jan 2021 04:13:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A758F4B23A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 04:13:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RXaUxbNXjxis for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 04:13:43 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 640B34B1BF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 04:13:43 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3756C225AC;
 Tue,  5 Jan 2021 09:13:42 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kwiPL-005OSj-R8; Tue, 05 Jan 2021 09:13:39 +0000
MIME-Version: 1.0
Date: Tue, 05 Jan 2021 09:13:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v2 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
In-Reply-To: <20210104081613.100-3-lushenming@huawei.com>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-3-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, eric.auger@redhat.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
 lorenzo.pieralisi@arm.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, Will Deacon <will@kernel.org>,
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

T24gMjAyMS0wMS0wNCAwODoxNiwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gQWZ0ZXIgcGF1c2luZyBh
bGwgdkNQVXMgYW5kIGRldmljZXMgY2FwYWJsZSBvZiBpbnRlcnJ1cHRpbmcsIGluIG9yZGVyCj4g
dG8gc2F2ZSB0aGUgaW5mb3JtYXRpb24gb2YgYWxsIGludGVycnVwdHMsIGJlc2lkZXMgZmx1c2hp
bmcgdGhlIHBlbmRpbmcKPiBzdGF0ZXMgaW4ga3Zt4oCZcyB2Z2ljLCB3ZSBhbHNvIHRyeSB0byBm
bHVzaCB0aGUgc3RhdGVzIG9mIFZMUElzIGluIHRoZQo+IHZpcnR1YWwgcGVuZGluZyB0YWJsZXMg
aW50byBndWVzdCBSQU0sIGJ1dCB3ZSBuZWVkIHRvIGhhdmUgR0lDdjQuMSBhbmQKPiBzYWZlbHkg
dW5tYXAgdGhlIHZQRXMgZmlyc3QuCj4gCj4gU2lnbmVkLW9mZi1ieTogU2hlbm1pbmcgTHUgPGx1
c2hlbm1pbmdAaHVhd2VpLmNvbT4KPiAtLS0KPiAgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYz
LmMgfCA1OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLQo+ICAxIGZpbGUgY2hh
bmdlZCwgNTIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMgCj4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtdjMuYwo+IGluZGV4IDljZGYzOWE5NGE2My4uYTU4Yzk0MTI3Y2IwIDEwMDY0NAo+IC0tLSBh
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXYzLmMKPiBAQCAtMSw2ICsxLDggQEAKPiAgLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZp
ZXI6IEdQTC0yLjAtb25seQo+IAo+ICAjaW5jbHVkZSA8bGludXgvaXJxY2hpcC9hcm0tZ2ljLXYz
Lmg+Cj4gKyNpbmNsdWRlIDxsaW51eC9pcnEuaD4KPiArI2luY2x1ZGUgPGxpbnV4L2lycWRvbWFp
bi5oPgo+ICAjaW5jbHVkZSA8bGludXgva3ZtLmg+Cj4gICNpbmNsdWRlIDxsaW51eC9rdm1faG9z
dC5oPgo+ICAjaW5jbHVkZSA8a3ZtL2FybV92Z2ljLmg+Cj4gQEAgLTM1Niw2ICszNTgsMzggQEAg
aW50IHZnaWNfdjNfbHBpX3N5bmNfcGVuZGluZ19zdGF0dXMoc3RydWN0IGt2bQo+ICprdm0sIHN0
cnVjdCB2Z2ljX2lycSAqaXJxKQo+ICAJcmV0dXJuIDA7Cj4gIH0KPiAKPiArLyoKPiArICogVGhl
IGRlYWN0aXZhdGlvbiBvZiB0aGUgZG9vcmJlbGwgaW50ZXJydXB0IHdpbGwgdHJpZ2dlciB0aGUK
PiArICogdW5tYXBwaW5nIG9mIHRoZSBhc3NvY2lhdGVkIHZQRS4KPiArICovCj4gK3N0YXRpYyB2
b2lkIHVubWFwX2FsbF92cGVzKHN0cnVjdCB2Z2ljX2Rpc3QgKmRpc3QpCj4gK3sKPiArCXN0cnVj
dCBpcnFfZGVzYyAqZGVzYzsKPiArCWludCBpOwo+ICsKPiArCWlmICgha3ZtX3ZnaWNfZ2xvYmFs
X3N0YXRlLmhhc19naWN2NF8xKQo+ICsJCXJldHVybjsKPiArCj4gKwlmb3IgKGkgPSAwOyBpIDwg
ZGlzdC0+aXRzX3ZtLm5yX3ZwZXM7IGkrKykgewo+ICsJCWRlc2MgPSBpcnFfdG9fZGVzYyhkaXN0
LT5pdHNfdm0udnBlc1tpXS0+aXJxKTsKPiArCQlpcnFfZG9tYWluX2RlYWN0aXZhdGVfaXJxKGly
cV9kZXNjX2dldF9pcnFfZGF0YShkZXNjKSk7Cj4gKwl9Cj4gK30KPiArCj4gK3N0YXRpYyB2b2lk
IG1hcF9hbGxfdnBlcyhzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0KQo+ICt7Cj4gKwlzdHJ1Y3QgaXJx
X2Rlc2MgKmRlc2M7Cj4gKwlpbnQgaTsKPiArCj4gKwlpZiAoIWt2bV92Z2ljX2dsb2JhbF9zdGF0
ZS5oYXNfZ2ljdjRfMSkKPiArCQlyZXR1cm47Cj4gKwo+ICsJZm9yIChpID0gMDsgaSA8IGRpc3Qt
Pml0c192bS5ucl92cGVzOyBpKyspIHsKPiArCQlkZXNjID0gaXJxX3RvX2Rlc2MoZGlzdC0+aXRz
X3ZtLnZwZXNbaV0tPmlycSk7Cj4gKwkJaXJxX2RvbWFpbl9hY3RpdmF0ZV9pcnEoaXJxX2Rlc2Nf
Z2V0X2lycV9kYXRhKGRlc2MpLCBmYWxzZSk7Cj4gKwl9Cj4gK30KPiArCj4gIC8qKgo+ICAgKiB2
Z2ljX3YzX3NhdmVfcGVuZGluZ190YWJsZXMgLSBTYXZlIHRoZSBwZW5kaW5nIHRhYmxlcyBpbnRv
IGd1ZXN0IAo+IFJBTQo+ICAgKiBrdm0gbG9jayBhbmQgYWxsIHZjcHUgbG9jayBtdXN0IGJlIGhl
bGQKPiBAQCAtMzY1LDE0ICszOTksMTggQEAgaW50IHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxl
cyhzdHJ1Y3Qga3ZtICprdm0pCj4gIAlzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0ID0gJmt2bS0+YXJj
aC52Z2ljOwo+ICAJc3RydWN0IHZnaWNfaXJxICppcnE7Cj4gIAlncGFfdCBsYXN0X3B0ciA9IH4o
Z3BhX3QpMDsKPiAtCWludCByZXQ7Cj4gKwlpbnQgcmV0ID0gMDsKPiAgCXU4IHZhbDsKPiAKPiAr
CS8qIEFzIGEgcHJlcGFyYXRpb24gZm9yIGdldHRpbmcgYW55IFZMUEkgc3RhdGVzLiAqLwo+ICsJ
dW5tYXBfYWxsX3ZwZXMoZGlzdCk7CgpXaGF0IGlmIHRoZSBWUEVzIGFyZSBub3QgbWFwcGVkIHll
dD8gSXMgaXQgcG9zc2libGUgdG8gc25hcHNob3QgYSBWTQp0aGF0IGhhcyBub3QgcnVuIGF0IGFs
bD8KCj4gKwo+ICAJbGlzdF9mb3JfZWFjaF9lbnRyeShpcnEsICZkaXN0LT5scGlfbGlzdF9oZWFk
LCBscGlfbGlzdCkgewo+ICAJCWludCBieXRlX29mZnNldCwgYml0X25yOwo+ICAJCXN0cnVjdCBr
dm1fdmNwdSAqdmNwdTsKPiAgCQlncGFfdCBwZW5kYmFzZSwgcHRyOwo+ICAJCWJvb2wgc3RvcmVk
Owo+ICsJCWJvb2wgaXNfcGVuZGluZyA9IGlycS0+cGVuZGluZ19sYXRjaDsKPiAKPiAgCQl2Y3B1
ID0gaXJxLT50YXJnZXRfdmNwdTsKPiAgCQlpZiAoIXZjcHUpCj4gQEAgLTM4NywyNCArNDI1LDMy
IEBAIGludCB2Z2ljX3YzX3NhdmVfcGVuZGluZ190YWJsZXMoc3RydWN0IGt2bSAqa3ZtKQo+ICAJ
CWlmIChwdHIgIT0gbGFzdF9wdHIpIHsKPiAgCQkJcmV0ID0ga3ZtX3JlYWRfZ3Vlc3RfbG9jayhr
dm0sIHB0ciwgJnZhbCwgMSk7Cj4gIAkJCWlmIChyZXQpCj4gLQkJCQlyZXR1cm4gcmV0Owo+ICsJ
CQkJZ290byBvdXQ7Cj4gIAkJCWxhc3RfcHRyID0gcHRyOwo+ICAJCX0KPiAKPiAgCQlzdG9yZWQg
PSB2YWwgJiAoMVUgPDwgYml0X25yKTsKPiAtCQlpZiAoc3RvcmVkID09IGlycS0+cGVuZGluZ19s
YXRjaCkKPiArCj4gKwkJaWYgKGlycS0+aHcpCj4gKwkJCXZnaWNfdjRfZ2V0X3ZscGlfc3RhdGUo
aXJxLCAmaXNfcGVuZGluZyk7CgpZb3UgZG9uJ3QgY2hlY2sgdGhlIHJldHVybiB2YWx1ZSBoZXJl
LCBzbyBJIHdvbmRlciB3aHkgdGhlIGNoZWNrcwppbiB2Z2ljX3Y0X2dldF92bHBpX3N0YXRlKCku
CgpBbm90aGVyIHRoaW5nIHRoYXQgd29ycmllcyBtZSBpcyB0aGF0IHZnaWNfdjRfZ2V0X3ZscGlf
c3RhdGUoKSBkb2Vzbid0CmhhdmUgYW55IGNhY2hlIGludmFsaWRhdGlvbiwgYW5kIGNhbiBlbmQt
dXAgaGl0dGluZyBpbiB0aGUgQ1BVIGNhY2hlCih0aGVyZSBpcyBubyBndWFyYW50ZWUgb2YgY29o
ZXJlbmN5IGJldHdlZW4gdGhlIEdJQyBhbmQgdGhlIENQVSwgb25seQp0aGF0IHRoZSBHSUMgd2ls
bCBoYXZlIGZsdXNoZWQgaXRzIGNhY2hlcykuCgpJJ2QgZXhwZWN0IHRoaXMgdG8gaGFwcGVuIGF0
IHVubWFwIHRpbWUsIHRob3VnaCwgaW4gb3JkZXIgdG8gYXZvaWQKcmVwZWF0ZWQgc2luZ2xlIGJ5
dGUgaW52YWxpZGF0aW9ucy4KCj4gKwo+ICsJCWlmIChzdG9yZWQgPT0gaXNfcGVuZGluZykKPiAg
CQkJY29udGludWU7Cj4gCj4gLQkJaWYgKGlycS0+cGVuZGluZ19sYXRjaCkKPiArCQlpZiAoaXNf
cGVuZGluZykKPiAgCQkJdmFsIHw9IDEgPDwgYml0X25yOwo+ICAJCWVsc2UKPiAgCQkJdmFsICY9
IH4oMSA8PCBiaXRfbnIpOwo+IAo+ICAJCXJldCA9IGt2bV93cml0ZV9ndWVzdF9sb2NrKGt2bSwg
cHRyLCAmdmFsLCAxKTsKPiAgCQlpZiAocmV0KQo+IC0JCQlyZXR1cm4gcmV0Owo+ICsJCQlnb3Rv
IG91dDsKPiAgCX0KPiAtCXJldHVybiAwOwo+ICsKPiArb3V0Ogo+ICsJbWFwX2FsbF92cGVzKGRp
c3QpOwo+ICsKPiArCXJldHVybiByZXQ7Cj4gIH0KPiAKPiAgLyoqCgpUaGFua3MsCgogICAgICAg
ICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcg
bGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1i
aWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
