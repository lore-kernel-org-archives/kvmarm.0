Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD07DC433B4
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 19:47:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 387A8613C1
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 19:47:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 387A8613C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A34734B390;
	Thu, 29 Apr 2021 15:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nlt7qWw9yGCj; Thu, 29 Apr 2021 15:47:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 793FE4B321;
	Thu, 29 Apr 2021 15:47:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76CED4B2BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 15:47:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fRKvVuapqXla for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 15:47:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 887A64B2AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 15:47:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619725629;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+M4to1dcOs700isxx4oGCjHBz32mVchtGZDofF69pWA=;
 b=OVpFVCfri1gk3LLJ2mNIW7M5jv/n5AM+DXBF5DO3457+spy4TNXT4vdC3tG0eExinkCamx
 9knIKR64U7TKa24djGNkD+GW8r/+i1aJRsy0ueea6/+P7oSDTfemMW5TJ5cjkwSO+9b//e
 oO2weDWiAmWWSNGP/Yubs1HbFJIA0VY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-KamNEiW9NsGsTkhGWHaQ0w-1; Thu, 29 Apr 2021 15:47:02 -0400
X-MC-Unique: KamNEiW9NsGsTkhGWHaQ0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E7048189C6;
 Thu, 29 Apr 2021 19:47:00 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C2AFF69513;
 Thu, 29 Apr 2021 19:46:59 +0000 (UTC)
Date: Thu, 29 Apr 2021 13:46:59 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Shanker R Donthineni <sdonthineni@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210429134659.321a5c3c@redhat.com>
In-Reply-To: <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Vikram Sethi <vsethi@nvidia.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Jason Sequeira <jsequeira@nvidia.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

T24gVGh1LCAyOSBBcHIgMjAyMSAxNDoxNDo1MCAtMDUwMApTaGFua2VyIFIgRG9udGhpbmVuaSA8
c2RvbnRoaW5lbmlAbnZpZGlhLmNvbT4gd3JvdGU6Cgo+IFRoYW5rcyBBbGV4IGZvciBxdWljayBy
ZXBseS4KPiAKPiBPbiA0LzI5LzIxIDE6MjggUE0sIEFsZXggV2lsbGlhbXNvbiB3cm90ZToKPiA+
IElmIHRoaXMgd2VyZSBhIHZhbGlkIHRoaW5nIHRvIGRvLCBpdCBzaG91bGQgYmUgZG9uZSBmb3Ig
YWxsCj4gPiBhcmNoaXRlY3R1cmVzLCBub3QganVzdCBBUk02NC4gIEhvd2V2ZXIsIGEgcHJlZmV0
Y2hhYmxlIHJhbmdlIG9ubHkKPiA+IG5lY2Vzc2FyaWx5IGFsbG93cyBtZXJnZWQgd3JpdGVzLCB3
aGljaCBzZWVtcyBsaWtlIGEgc3Vic2V0IG9mIHRoZQo+ID4gc2VtYW50aWNzIGltcGxpZWQgYnkg
YSBXQyBhdHRyaWJ1dGUsIHRoZXJlZm9yZSB0aGlzIGRvZXNuJ3Qgc2VlbQo+ID4gdW5pdmVyc2Fs
bHkgdmFsaWQuCj4gPgo+ID4gSSdtIGFsc28gYSBiaXQgY29uZnVzZWQgYnkgeW91ciBwcm9ibGVt
IHN0YXRlbWVudCB0aGF0IGluZGljYXRlcyB0aGF0Cj4gPiB3aXRob3V0IFdDIHlvdSdyZSBzZWVp
bmcgdW5hbGlnbmVkIGFjY2Vzc2VzLCBkb2VzIHRoaXMgc3VnZ2VzdCB0aGF0Cj4gPiB5b3VyIGRy
aXZlciBpcyBhY3R1YWxseSByZWx5aW5nIG9uIFdDIHNlbWFudGljcyB0byBwZXJmb3JtIG1lcmdp
bmcgdG8KPiA+IGFjaGlldmUgYWxpZ25tZW50PyAgVGhhdCBzZWVtcyByYXRoZXIgbGlrZSBhIGRy
aXZlciBidWcsIEknZCBleHBlY3QgVUMKPiA+IHZzIFdDIGlzIGxhcmdlbHkgYSBkaWZmZXJlbmNl
IGluIHBlcmZvcm1hbmNlLCBub3QgYSBtZWFucyB0byBlbmZvcmNlCj4gPiBwcm9wZXIgZHJpdmVy
IGFjY2VzcyBwYXR0ZXJucy4gIFBlciB0aGUgUENJIHNwZWMsIHRoZSBicmlkZ2UgaXRzZWxmIGNh
bgo+ID4gbWVyZ2Ugd3JpdGVzIHRvIHByZWZldGNoYWJsZSBhcmVhcywgcHJlc3VtYWJseSByZWdh
cmRsZXNzIG9mIHRoaXMKPiA+IHByb2Nlc3NvciBhdHRyaWJ1dGUsIHBlcmhhcHMgdGhhdCdzIHRo
ZSBmZWF0dXJlIHlvdXIgZHJpdmVyIGlzIHJlbHlpbmcKPiA+IG9uIHRoYXQgbWlnaHQgYmUgbWlz
c2luZyBoZXJlLiAgVGhhbmtzLCAgCj4gVGhlIGRyaXZlciB1c2VzIFdDIHNlbWFudGljcywgSXQn
cyBtYXBwaW5nIFBDSSBwcmVmZXRjaGFibGUgQkFSUwo+IHVzaW5nIGlvcmVtYXBfd2MoKS7CoCBX
ZSBkb24ndCBzZWUgYW55IGlzc3VlIGZvciB4ODYgYXJjaGl0ZWN0dXJlLAo+IGRyaXZlciB3b3Jr
cyBmaW5lIGluIHRoZSBob3N0IGFuZCBndWVzdCBrZXJuZWwuIFRoZSBzYW1lIGRyaXZlciB3b3Jr
cwo+IG9uIEFSTTY0IGtlcm5lbCBidXQgY3Jhc2hlcyBpbnNpZGUgVk0uIEdQVSBkcml2ZXIgdXNl
cyB0aGUKPiBhcmNoaXRlY3R1cmUgYWdub3N0aWMgZnVuY3Rpb24gaW9yZW1hcF93YygpIGxpa2Ug
b3RoZXIgZHJpdmVycy4gVGhpcwo+IGxpbWl0YXRpb24gYXBwbGllcyB0byBhbGwgdGhlIGRyaXZl
cnMgaWYgdGhleSB1c2UgV0MgbWVtb3J5IGFuZAo+IGZvbGxvdyBBUk02NCBOT1JNQUwtTkMgYWNj
ZXNzIHJ1bGVzLgoKeDg2IEtWTSB3b3JrcyBmb3Igb3RoZXIgcmVhc29ucywgS1ZNIHdpbGwgdHJ1
c3QgdGhlIHZDUFUgYXR0cmlidXRlcyBmb3IKdGhlIG1lbW9yeSByYW5nZSByYXRoZXIgdGhhbiBy
ZWx5aW5nIG9ubHkgb24gdGhlIGhvc3QgbWFwcGluZy4KCj4gT24gQVJNNjQsIGlvcmVtYXBfd2Mo
KSBpcyBtYXBwZWQgdG8gbm9uLWNhY2hlYWJsZSBtZW1vcnktdHlwZSwgbm8KPiBzaWRlIGVmZmVj
dHMgb24gcmVhZHMgYW5kIHVuYWxpZ25lZCBhY2Nlc3NlcyBhcmUgYWxsb3dlZCBhcyBwZXIKPiBB
Uk0tQVJNIGFyY2hpdGVjdHVyZS4gVGhlIGRyaXZlciBiZWhhdmlvciBpcyBkaWZmZXJlbnQgaW4g
aG9zdCB2cwo+IGd1ZXN0IG9uIEFSTTY0LsKgCgpQZXIgdGhlIFBDSSBzcGVjLCBwcmVmZXRjaGFi
bGUgbWVtb3J5IG9ubHkgbmVjZXNzYXJpbHkgYWxsb3dzIHRoZSBicmlkZ2UKdG8gbWVyZ2Ugd3Jp
dGVzLiAgSSBiZWxpZXZlIHRoaXMgaXMgb25seSBhIHN1YnNldCBvZiB3aGF0IFdDIG1hcHBpbmdz
CmFsbG93LCB0aGVyZWZvcmUgSSBleHBlY3QgdGhpcyBpcyBpbmNvbXBhdGlibGUgd2l0aCBkcml2
ZXJzIHRoYXQgZG8gbm90CnVzZSBXQyBtYXBwaW5ncy4KIAo+IEFSTSBDUFUgZ2VuZXJhdGluZyBh
bGlnbm1lbnQgZmF1bHRzIGJlZm9yZSB0cmFuc2FjdGlvbiByZWFjaGVzIHRoZQo+IFBDSS1SQy9z
d2l0Y2gvZW5kLXBvaW50LWRldmljZS4KCklmIGFuIGFsaWdubWVudCBmYXVsdCBpcyBmaXhlZCBi
eSBjb25maWd1cmluZyBhIFdDIG1hcHBpbmcsIGRvZXNuJ3QKdGhhdCBzdWdnZXN0IHRoYXQgdGhl
IGRyaXZlciBwZXJmb3JtZWQgYW4gdW5hbGlnbmVkIGFjY2VzcyBpdHNlbGYgYW5kCmlzIHJlbHlp
bmcgb24gd3JpdGUgY29tYmluaW5nIGJ5IHRoZSBwcm9jZXNzb3IgdG8gY29ycmVjdCB0aGF0IGVy
cm9yPwpUaGF0J3Mgd3JvbmcuICBGaXggdGhlIGRyaXZlciBvciBwbGVhc2Ugb2ZmZXIgYW5vdGhl
ciBleHBsYW5hdGlvbiBvZgpob3cgdGhlIFdDIG1hcHBpbmcgcmVzb2x2ZXMgdGhpcy4gIEkgc3Vz
cGVjdCB5b3UgY291bGQgZW5hYmxlIHRyYWNpbmcKaW4gUUVNVSwgZGlzYWJsZSBNTUlPIG1tYXBz
IG9uIHRoZSB2ZmlvLXBjaSBkZXZpY2UgYW5kIGZpbmQgdGhlIGludmFsaWQKYWNjZXNzLgoKPiBX
ZSd2ZSB0d28gY29uY2VybnMgaGVyZToKPiDCoMKgIC0gUGVyZm9ybWFuY2UgaW1wYWN0cyBmb3Ig
cGFzcy10aHJvdWdoIGRldmljZXMuCj4gwqDCoCAtIFRoZSBkZWZpbml0aW9uIG9mIGlvcmVtYXBf
d2MoKSBmdW5jdGlvbiBkb2Vzbid0IG1hdGNoIHRoZSBob3N0Cj4ga2VybmVsIG9uIEFSTTY0CgpQ
ZXJmb3JtYW5jZSBJIGNhbiB1bmRlcnN0YW5kLCBidXQgSSB0aGluayB5b3UncmUgYWxzbyB1c2lu
ZyBpdCB0byBtYXNrCmEgZHJpdmVyIGJ1ZyB3aGljaCBzaG91bGQgYmUgcmVzb2x2ZWQgZmlyc3Qu
ICBUaGFua3MsCgpBbGV4CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
