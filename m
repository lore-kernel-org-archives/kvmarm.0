Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F08C3815B
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 13:43:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B5582075E
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 13:43:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wvTuJ2Kv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B5582075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95E184B1C9;
	Tue, 14 Apr 2020 09:43:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v82DF4iPetyT; Tue, 14 Apr 2020 09:43:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6374B16B;
	Tue, 14 Apr 2020 09:43:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F02044B16B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 09:43:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 44E-gDygC3Sp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 09:43:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CA0A4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 09:43:17 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 61A3320644;
 Tue, 14 Apr 2020 13:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586871796;
 bh=3koUbGe2LBHalbakeLDQom7EXe+LBTn/mZU+H8wy818=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=wvTuJ2KvMEs7RpYKRjMqdZ7Noxqbzu3FUz84V073BNWMVq4DecOZ7bcI5eY7Vk3os
 UeYuUradQiVbk4CiVsGslmtxQBXxWNaJ74F/n0jD7EObUMUgymqHhHdC2jwmmnxKuS
 Bd8vCxQYxboemoA0+5ye6cxU6zTkDdzw7K0EVOAA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jOLqM-003Abw-Jl; Tue, 14 Apr 2020 14:43:14 +0100
Date: Tue, 14 Apr 2020 14:43:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: =?UTF-8?Q?Andr=C3=A9?= Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm: vgic: Synchronize the whole guest on
 GIC{D,R}_I{S,C}ACTIVER read
Message-ID: <20200414144313.1f9645cd@why>
In-Reply-To: <fddef0b7-3db7-89aa-5aac-4f08380ed00d@arm.com>
References: <20200414103517.2824071-1-maz@kernel.org>
 <20200414103517.2824071-2-maz@kernel.org>
 <fddef0b7-3db7-89aa-5aac-4f08380ed00d@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, yuzenghui@huawei.com,
 eric.auger@redhat.com, julien@xen.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gVHVlLCAxNCBBcHIgMjAyMCAxMjoxNjoyNyArMDEwMApBbmRyw6kgUHJ6eXdhcmEgPGFuZHJl
LnByenl3YXJhQGFybS5jb20+IHdyb3RlOgoKPiBPbiAxNC8wNC8yMDIwIDExOjM1LCBNYXJjIFp5
bmdpZXIgd3JvdGU6Cj4gPiBXaGVuIGEgZ3Vlc3QgdHJpZXMgdG8gcmVhZCB0aGUgYWN0aXZlIHN0
YXRlIG9mIGl0cyBpbnRlcnJ1cHRzLAo+ID4gd2UgY3VycmVudGx5IGp1c3QgcmV0dXJuIHdoYXRl
dmVyIHN0YXRlIHdlIGhhdmUgaW4gbWVtb3J5LiBUaGlzCj4gPiBtZWFucyB0aGF0IGlmIHN1Y2gg
YW4gaW50ZXJydXB0IGxpdmVzIGluIGEgTGlzdCBSZWdpc3RlciBvbiBhbm90aGVyCj4gPiBDUFUs
IHdlIGZhaWwgdG8gb2JzZXJ0dmUgdGhlIGxhdGVzdCBhY3RpdmUgc3RhdGUgZm9yIHRoaXMgaW50
ZXJydXB0LiAgCj4gCj4gICAgICAgICAgICAgICAgICAgXl5eXl5eXl4KPiAKPiA+IEluIG9yZGVy
IHRvIHJlbWVkeSB0aGlzLCBzdG9wIGFsbCB0aGUgb3RoZXIgdmNwdXMgc28gdGhhdCB0aGV5IGV4
aXQKPiA+IGFuZCB3ZSBjYW4gb2JzZXJ2ZSB0aGUgbW9zdCByZWNlbnQgdmFsdWUgZm9yIHRoZSBz
dGF0ZS4gIAo+IAo+IE1heWJlIHdvcnRoIG1lbnRpb25pbmcgdGhhdCB0aGlzIGNvcGllcyB0aGUg
YXBwcm9hY2ggd2UgYWxyZWFkeSBkZWFsCj4gd2l0aCB3cml0ZSBhY2Nlc3NlcyAoc3BsaXQgdXNl
cmxhbmQgYW5kIGd1ZXNzIGFjY2Vzc29ycykuIFRoaXMgaXMgaW4gdGhlCj4gY292ZXIgbGV0dGVy
LCBidXQgdW50aWwgSSBmb3VuZCBpdCB0aGVyZSBpdCB0b29rIG1lIGEgd2hpbGUgdG8gZ3Jhc3AK
PiB3aGF0IHRoaXMgcGF0Y2ggcmVhbGx5IGRvZXMuCgpGYWlyIGVub3VnaC4KCj4gCj4gPiAKPiA+
IFJlcG9ydGVkLWJ5OiBKdWxpZW4gR3JhbGwgPGp1bGllbkB4ZW4ub3JnPgo+ID4gU2lnbmVkLW9m
Zi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPiA+IC0tLQo+ID4gIHZpcnQva3Zt
L2FybS92Z2ljL3ZnaWMtbW1pby12Mi5jIHwgICA0ICstCj4gPiAgdmlydC9rdm0vYXJtL3ZnaWMv
dmdpYy1tbWlvLXYzLmMgfCAgIDQgKy0KPiA+ICB2aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8u
YyAgICB8IDEwMCArKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tCj4gPiAgdmlydC9rdm0v
YXJtL3ZnaWMvdmdpYy1tbWlvLmggICAgfCAgIDMgKwo+ID4gIDQgZmlsZXMgY2hhbmdlZCwgNzEg
aW5zZXJ0aW9ucygrKSwgNDAgZGVsZXRpb25zKC0pCj4gPiAKPiA+IGRpZmYgLS1naXQgYS92aXJ0
L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8tdjIuYyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1p
by12Mi5jCj4gPiBpbmRleCA1OTQ1ZjA2MmQ3NDkuLmQ2Mzg4MWY2MGUxYSAxMDA2NDQKPiA+IC0t
LSBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby12Mi5jCj4gPiArKysgYi92aXJ0L2t2bS9h
cm0vdmdpYy92Z2ljLW1taW8tdjIuYwo+ID4gQEAgLTQyMiwxMSArNDIyLDExIEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgdmdpY19yZWdpc3Rlcl9yZWdpb24gdmdpY192Ml9kaXN0X3JlZ2lzdGVyc1td
ID0gewo+ID4gIAkJVkdJQ19BQ0NFU1NfMzJiaXQpLAo+ID4gIAlSRUdJU1RFUl9ERVNDX1dJVEhf
QklUU19QRVJfSVJRKEdJQ19ESVNUX0FDVElWRV9TRVQsCj4gPiAgCQl2Z2ljX21taW9fcmVhZF9h
Y3RpdmUsIHZnaWNfbW1pb193cml0ZV9zYWN0aXZlLAo+ID4gLQkJTlVMTCwgdmdpY19tbWlvX3Vh
Y2Nlc3Nfd3JpdGVfc2FjdGl2ZSwgMSwKPiA+ICsJCXZnaWNfdWFjY2Vzc19yZWFkX2FjdGl2ZSwg
dmdpY19tbWlvX3VhY2Nlc3Nfd3JpdGVfc2FjdGl2ZSwgMSwKPiA+ICAJCVZHSUNfQUNDRVNTXzMy
Yml0KSwKPiA+ICAJUkVHSVNURVJfREVTQ19XSVRIX0JJVFNfUEVSX0lSUShHSUNfRElTVF9BQ1RJ
VkVfQ0xFQVIsCj4gPiAgCQl2Z2ljX21taW9fcmVhZF9hY3RpdmUsIHZnaWNfbW1pb193cml0ZV9j
YWN0aXZlLAo+ID4gLQkJTlVMTCwgdmdpY19tbWlvX3VhY2Nlc3Nfd3JpdGVfY2FjdGl2ZSwgMSwK
PiA+ICsJCXZnaWNfdWFjY2Vzc19yZWFkX2FjdGl2ZSwgdmdpY19tbWlvX3VhY2Nlc3Nfd3JpdGVf
Y2FjdGl2ZSwgMSwKPiA+ICAJCVZHSUNfQUNDRVNTXzMyYml0KSwKPiA+ICAJUkVHSVNURVJfREVT
Q19XSVRIX0JJVFNfUEVSX0lSUShHSUNfRElTVF9QUkksCj4gPiAgCQl2Z2ljX21taW9fcmVhZF9w
cmlvcml0eSwgdmdpY19tbWlvX3dyaXRlX3ByaW9yaXR5LCBOVUxMLCBOVUxMLAo+ID4gZGlmZiAt
LWdpdCBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby12My5jIGIvdmlydC9rdm0vYXJtL3Zn
aWMvdmdpYy1tbWlvLXYzLmMKPiA+IGluZGV4IGU3MmRjYzQ1NDI0Ny4uNzdjOGJhMWEyNTM1IDEw
MDY0NAo+ID4gLS0tIGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLXYzLmMKPiA+ICsrKyBi
L3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby12My5jCj4gPiBAQCAtNTUzLDExICs1NTMsMTEg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCB2Z2ljX3JlZ2lzdGVyX3JlZ2lvbiB2Z2ljX3YzX2Rpc3Rf
cmVnaXN0ZXJzW10gPSB7Cj4gPiAgCQlWR0lDX0FDQ0VTU18zMmJpdCksCj4gPiAgCVJFR0lTVEVS
X0RFU0NfV0lUSF9CSVRTX1BFUl9JUlFfU0hBUkVEKEdJQ0RfSVNBQ1RJVkVSLAo+ID4gIAkJdmdp
Y19tbWlvX3JlYWRfYWN0aXZlLCB2Z2ljX21taW9fd3JpdGVfc2FjdGl2ZSwKPiA+IC0JCU5VTEws
IHZnaWNfbW1pb191YWNjZXNzX3dyaXRlX3NhY3RpdmUsIDEsCj4gPiArCQl2Z2ljX3VhY2Nlc3Nf
cmVhZF9hY3RpdmUsIHZnaWNfbW1pb191YWNjZXNzX3dyaXRlX3NhY3RpdmUsIDEsCj4gPiAgCQlW
R0lDX0FDQ0VTU18zMmJpdCksCj4gPiAgCVJFR0lTVEVSX0RFU0NfV0lUSF9CSVRTX1BFUl9JUlFf
U0hBUkVEKEdJQ0RfSUNBQ1RJVkVSLAo+ID4gIAkJdmdpY19tbWlvX3JlYWRfYWN0aXZlLCB2Z2lj
X21taW9fd3JpdGVfY2FjdGl2ZSwKPiA+IC0JCU5VTEwsIHZnaWNfbW1pb191YWNjZXNzX3dyaXRl
X2NhY3RpdmUsCj4gPiArCQl2Z2ljX3VhY2Nlc3NfcmVhZF9hY3RpdmUsIHZnaWNfbW1pb191YWNj
ZXNzX3dyaXRlX2NhY3RpdmUsCj4gPiAgCQkxLCBWR0lDX0FDQ0VTU18zMmJpdCksCj4gPiAgCVJF
R0lTVEVSX0RFU0NfV0lUSF9CSVRTX1BFUl9JUlFfU0hBUkVEKEdJQ0RfSVBSSU9SSVRZUiwKPiA+
ICAJCXZnaWNfbW1pb19yZWFkX3ByaW9yaXR5LCB2Z2ljX21taW9fd3JpdGVfcHJpb3JpdHksIE5V
TEwsIE5VTEwsCj4gPiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLmMg
Yi92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8uYwo+ID4gaW5kZXggMjE5OTMwMjU5N2ZhLi40
MDEyY2Q2OGFjOTMgMTAwNjQ0Cj4gPiAtLS0gYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8u
Ywo+ID4gKysrIGIvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLmMKPiA+IEBAIC0zNDgsOCAr
MzQ4LDM5IEBAIHZvaWQgdmdpY19tbWlvX3dyaXRlX2NwZW5kaW5nKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwKPiA+ICAJfQo+ID4gIH0KPiA+ICAKPiA+IC11bnNpZ25lZCBsb25nIHZnaWNfbW1pb19y
ZWFkX2FjdGl2ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gPiAtCQkJCSAgICBncGFfdCBhZGRy
LCB1bnNpZ25lZCBpbnQgbGVuKQo+ID4gKwo+ID4gKy8qCj4gPiArICogSWYgd2UgYXJlIGZpZGRs
aW5nIHdpdGggYW4gSVJRJ3MgYWN0aXZlIHN0YXRlLCB3ZSBoYXZlIHRvIG1ha2Ugc3VyZSB0aGUg
SVJRCj4gPiArICogaXMgbm90IHF1ZXVlZCBvbiBzb21lIHJ1bm5pbmcgVkNQVSdzIExScywgYmVj
YXVzZSB0aGVuIHRoZSBjaGFuZ2UgdG8gdGhlCj4gPiArICogYWN0aXZlIHN0YXRlIGNhbiBiZSBv
dmVyd3JpdHRlbiB3aGVuIHRoZSBWQ1BVJ3Mgc3RhdGUgaXMgc3luY2VkIGNvbWluZyBiYWNrCj4g
PiArICogZnJvbSB0aGUgZ3Vlc3QuCj4gPiArICoKPiA+ICsgKiBGb3Igc2hhcmVkIGludGVycnVw
dHMgYXMgd2VsbCBhcyBHSUN2MyBwcml2YXRlIGludGVycnVwdHMsIHdlIGhhdmUgdG8KPiA+ICsg
KiBzdG9wIGFsbCB0aGUgVkNQVXMgYmVjYXVzZSBpbnRlcnJ1cHRzIGNhbiBiZSBtaWdyYXRlZCB3
aGlsZSB3ZSBkb24ndCBob2xkCj4gPiArICogdGhlIElSUSBsb2NrcyBhbmQgd2UgZG9uJ3Qgd2Fu
dCB0byBiZSBjaGFzaW5nIG1vdmluZyB0YXJnZXRzLgo+ID4gKyAqCj4gPiArICogRm9yIEdJQ3Yy
IHByaXZhdGUgaW50ZXJydXB0cyB3ZSBkb24ndCBoYXZlIHRvIGRvIGFueXRoaW5nIGJlY2F1c2UK
PiA+ICsgKiB1c2Vyc3BhY2UgYWNjZXNzZXMgdG8gdGhlIFZHSUMgc3RhdGUgYWxyZWFkeSByZXF1
aXJlIGFsbCBWQ1BVcyB0byBiZQo+ID4gKyAqIHN0b3BwZWQsIGFuZCBvbmx5IHRoZSBWQ1BVIGl0
c2VsZiBjYW4gbW9kaWZ5IGl0cyBwcml2YXRlIGludGVycnVwdHMKPiA+ICsgKiBhY3RpdmUgc3Rh
dGUsIHdoaWNoIGd1YXJhbnRlZXMgdGhhdCB0aGUgVkNQVSBpcyBub3QgcnVubmluZy4KPiA+ICsg
Ki8KPiA+ICtzdGF0aWMgdm9pZCB2Z2ljX2FjY2Vzc19hY3RpdmVfcHJlcGFyZShzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIHUzMiBpbnRpZCkKPiA+ICt7Cj4gPiArCWlmICh2Y3B1LT5rdm0tPmFyY2gu
dmdpYy52Z2ljX21vZGVsID09IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMyB8fAo+ID4gKwkgICAg
aW50aWQgPiBWR0lDX05SX1BSSVZBVEVfSVJRUykgIAo+IAo+IEkgdW5kZXJzdGFuZCB0aGF0IHRo
aXMgaXMganVzdCBtb3ZlZCBmcm9tIGV4aXN0aW5nIGNvZGUgYmVsb3csIGJ1dAo+IHNob3VsZG4n
dCB0aGF0IGVpdGhlciByZWFkICJpbnRpZCA+PSBWR0lDX05SX1BSSVZBVEVfSVJRUyIgb3IKPiAi
aW50aWQgPiBWR0lDX01BWF9QUklWQVRFIj8KCk5pY2UgY2F0Y2guIFRoaXMgd2FzIGludHJvZHVj
ZWQgaW4gYWJkNzIyOTYyNmI5MyAoIktWTTogYXJtL2FybTY0OgpTaW1wbGlmeSBhY3RpdmVfY2hh
bmdlX3ByZXBhcmUgYW5kIHBsdWcgcmFjZSIpLCB3aGlsZSB3ZSBoYWQgdGhlCm9wcG9zaXRlIGNv
bmRpdGlvbiBiZWZvcmUgdGhhdC4KClRoaXMgbWVhbnMgdGhhdCBvbiBHSUN2MiwgR0lDRF9JW0NT
XUFDVElWRVIgd3JpdGVzIGFyZSB1bnJlbGlhYmxlIGZvcgppbnRpZHMgMzItNjMgKHdlIG1heSBm
YWlsIHRvIGNsZWFyIGFuIGFjdGl2ZSBiaXQgaWYgaXQgaXMgc2V0IGluCmFub3RoZXIgdmNwdSdz
IExScywgZm9yIGV4YW1wbGUpLgoKSSdsbCBhZGQgYW4gZXh0cmEgcGF0Y2ggZm9yIHRoaXMuCgpU
aGFua3MsCgoJTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4u
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
