Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E15C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 09:25:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 49364225AB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 09:25:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49364225AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B54F4B23A;
	Tue,  5 Jan 2021 04:25:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XTENIz++quHm; Tue,  5 Jan 2021 04:25:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4054B2D3;
	Tue,  5 Jan 2021 04:25:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44AEC4B23A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 04:25:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hVmbcvh+cYeT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 04:25:15 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E6F94B214
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 04:25:15 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E3B9620756;
 Tue,  5 Jan 2021 09:25:13 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kwiaV-005Oa8-O2; Tue, 05 Jan 2021 09:25:11 +0000
MIME-Version: 1.0
Date: Tue, 05 Jan 2021 09:25:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v2 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
In-Reply-To: <20210104081613.100-4-lushenming@huawei.com>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-4-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <76a7b9cca485dc8157d3be53189eac69@kernel.org>
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

T24gMjAyMS0wMS0wNCAwODoxNiwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gRnJvbTogWmVuZ2h1aSBZ
dSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4gCj4gV2hlbiBzZXR0aW5nIHRoZSBmb3J3YXJkaW5n
IHBhdGggb2YgYSBWTFBJIChzd2l0Y2ggdG8gdGhlIEhXIG1vZGUpLAo+IHdlIGNvdWxkIGFsc28g
dHJhbnNmZXIgdGhlIHBlbmRpbmcgc3RhdGUgZnJvbSBpcnEtPnBlbmRpbmdfbGF0Y2ggdG8KPiBW
UFQgKGVzcGVjaWFsbHkgaW4gbWlncmF0aW9uLCB0aGUgcGVuZGluZyBzdGF0ZXMgb2YgVkxQSXMg
YXJlIHJlc3RvcmVkCj4gaW50byBrdm3igJlzIHZnaWMgZmlyc3QpLiBBbmQgd2UgY3VycmVudGx5
IHNlbmQgIklOVCtWU1lOQyIgdG8gdHJpZ2dlcgo+IGEgVkxQSSB0byBwZW5kaW5nLgo+IAo+IFNp
Z25lZC1vZmYtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+IFNpZ25lZC1v
ZmYtYnk6IFNoZW5taW5nIEx1IDxsdXNoZW5taW5nQGh1YXdlaS5jb20+Cj4gLS0tCj4gIGFyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jIHwgMTIgKysrKysrKysrKysrCj4gIDEgZmlsZSBjaGFu
Z2VkLCAxMiBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy12NC5jIAo+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKPiBpbmRleCBm
MjExYTdjMzI3MDQuLjc5NDVkNmQwOWNkZCAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtdjQuYwo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4gQEAg
LTQ1NCw2ICs0NTQsMTggQEAgaW50IGt2bV92Z2ljX3Y0X3NldF9mb3J3YXJkaW5nKHN0cnVjdCBr
dm0gKmt2bSwgCj4gaW50IHZpcnEsCj4gIAlpcnEtPmhvc3RfaXJxCT0gdmlycTsKPiAgCWF0b21p
Y19pbmMoJm1hcC52cGUtPnZscGlfY291bnQpOwo+IAo+ICsJLyogVHJhbnNmZXIgcGVuZGluZyBz
dGF0ZSAqLwo+ICsJcmV0ID0gaXJxX3NldF9pcnFjaGlwX3N0YXRlKGlycS0+aG9zdF9pcnEsCj4g
KwkJCQkgICAgSVJRQ0hJUF9TVEFURV9QRU5ESU5HLAo+ICsJCQkJICAgIGlycS0+cGVuZGluZ19s
YXRjaCk7Cj4gKwlXQVJOX1JBVEVMSU1JVChyZXQsICJJUlEgJWQiLCBpcnEtPmhvc3RfaXJxKTsK
CldoeSBkbyB0aGlzIGlmIHBlbmRpbmdfbGF0Y2ggaXMgMCwgd2hpY2ggaXMgbGlrZWx5IHRvIGJl
CnRoZSBvdmVyd2hlbG1pbmcgY2FzZT8KCj4gKwo+ICsJLyoKPiArCSAqIExldCBpdCBiZSBwcnVu
ZWQgZnJvbSBhcF9saXN0IGxhdGVyIGFuZCBkb24ndCBib3RoZXIKPiArCSAqIHRoZSBMaXN0IFJl
Z2lzdGVyLgo+ICsJICovCj4gKwlpcnEtPnBlbmRpbmdfbGF0Y2ggPSBmYWxzZTsKCldoYXQgZ3Vh
cmFudGVlcyB0aGUgcHJ1bmluZz8gUHJ1bmluZyBvbmx5IGhhcHBlbnMgb24gdmNwdSBleGl0LAp3
aGljaCBtZWFucyB3ZSBtYXkgaGF2ZSB0aGUgc2FtZSBpbnRlcnJ1cHQgdmlhIGJvdGggdGhlIExS
IGFuZAp0aGUgc3RyZWFtIGludGVyZmFjZSwgd2hpY2ggSSBkb24ndCBiZWxpZXZlIGlzIGxlZ2Fs
IChpdCBpcwpsaWtlIGhhdmluZyB0d28gTFJzIGhvbGRpbmcgdGhlIHNhbWUgaW50ZXJydXB0KS4K
Cj4gKwo+ICBvdXQ6Cj4gIAltdXRleF91bmxvY2soJml0cy0+aXRzX2xvY2spOwo+ICAJcmV0dXJu
IHJldDsKClRoYW5rcywKCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0
IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
