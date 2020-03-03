Return-Path: <SRS0=b+IX=4U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6F8C3F2D8
	for <kvmarm@archiver.kernel.org>; Tue,  3 Mar 2020 13:14:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CBD0820842
	for <kvmarm@archiver.kernel.org>; Tue,  3 Mar 2020 13:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E/D9AxX5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBD0820842
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CB044AF05;
	Tue,  3 Mar 2020 08:14:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ww-vY+zwWdWs; Tue,  3 Mar 2020 08:14:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1751A4AF0F;
	Tue,  3 Mar 2020 08:14:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07CE84AF02
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2020 08:14:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TrKceFrAuxcP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Mar 2020 08:14:18 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1CF74AEBE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2020 08:14:18 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583241258;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=K6MYW0Cw8y8JjG5SoRIVtn0utAaLa/9boq4bliE04oQ=;
 b=E/D9AxX5y6fo7WvBvhjKkXA/LWgv/w0wwgPBif8WCHPY8UD5RIQAkRzRrbyEnTLYZcEZJd
 n35m9Y7j7aIyTPCesZqaNG44Kn/9wRfU1IqXHo/CM5mQ/NjGgPMV+lD7xyPG1o/y3FReRx
 /vumSyD8XnuCWwfdidZGmVsMTuWH9D4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-hrEKN05ONsaAjIh7E5NlUA-1; Tue, 03 Mar 2020 08:14:14 -0500
X-MC-Unique: hrEKN05ONsaAjIh7E5NlUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B28A13E4;
 Tue,  3 Mar 2020 13:14:11 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 00884277A4;
 Tue,  3 Mar 2020 13:14:02 +0000 (UTC)
Subject: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
To: zhangfei <zhangfei.gao@linaro.org>, Tomasz Nowicki
 <tnowicki@marvell.com>, "eric.auger.pro@gmail.com"
 <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
 "will.deacon@arm.com" <will.deacon@arm.com>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>
References: <20190711135625.20684-1-eric.auger@redhat.com>
 <a35234a6-e386-fc8e-fcc4-5db4601b00d2@marvell.com>
 <3741c034-08f1-9dbb-ab06-434f3a8bd782@redhat.com>
 <e0133df5-073b-13e1-8399-ff48bfaef5e5@linaro.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <f01c0690-4561-287f-a5c6-5eefc5be52b7@redhat.com>
Date: Tue, 3 Mar 2020 14:14:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <e0133df5-073b-13e1-8399-ff48bfaef5e5@linaro.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "vincent.stehle@arm.com" <vincent.stehle@arm.com>,
 "ashok.raj@intel.com" <ashok.raj@intel.com>,
 "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
 "tina.zhang@intel.com" <tina.zhang@intel.com>,
 wangzhou1 <wangzhou1@hisilicon.com>,
 Kenneth Lee <kenneth-lee-2012@foxmail.com>
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

SGkgWmhhbmdmZWksCgpPbiAzLzMvMjAgMTo1NyBQTSwgemhhbmdmZWkgd3JvdGU6Cj4gSGksIEVy
aWMKPiAKPiBPbiAyMDE5LzExLzIwIOS4i+WNiDY6MTgsIEF1Z2VyIEVyaWMgd3JvdGU6Cj4+Cj4+
Pj4gVGhpcyBzZXJpZXMgYnJpbmdzIHRoZSBWRklPIHBhcnQgb2YgSFcgbmVzdGVkIHBhZ2luZyBz
dXBwb3J0Cj4+Pj4gaW4gdGhlIFNNTVV2My4KPj4+Pgo+Pj4+IFRoZSBzZXJpZXMgZGVwZW5kcyBv
bjoKPj4+PiBbUEFUQ0ggdjkgMDAvMTRdIFNNTVV2MyBOZXN0ZWQgU3RhZ2UgU2V0dXAgKElPTU1V
IHBhcnQpCj4+Pj4gKGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2tlcm5lbC9tc2czMTg3
NzE0Lmh0bWwpCj4+Pj4KPj4+PiAzIG5ldyBJT0NUTHMgYXJlIGludHJvZHVjZWQgdGhhdCBhbGxv
dyB0aGUgdXNlcnNwYWNlIHRvCj4+Pj4gMSkgcGFzcyB0aGUgZ3Vlc3Qgc3RhZ2UgMSBjb25maWd1
cmF0aW9uCj4+Pj4gMikgcGFzcyBzdGFnZSAxIE1TSSBiaW5kaW5ncwo+Pj4+IDMpIGludmFsaWRh
dGUgc3RhZ2UgMSByZWxhdGVkIGNhY2hlcwo+Pj4+Cj4+Pj4gVGhleSBtYXAgb250byB0aGUgcmVs
YXRlZCBuZXcgSU9NTVUgQVBJIGZ1bmN0aW9ucy4KPj4+Pgo+Pj4+IFdlIGludHJvZHVjZSB0aGUg
Y2FwYWJpbGl0eSB0byByZWdpc3RlciBzcGVjaWZpYyBpbnRlcnJ1cHQKPj4+PiBpbmRleGVzIChz
ZWUgWzFdKS4gQSBuZXcgRE1BX0ZBVUxUIGludGVycnVwdCBpbmRleCBhbGxvd3MgdG8gcmVnaXN0
ZXIKPj4+PiBhbiBldmVudGZkIHRvIGJlIHNpZ25hbGVkIHdoZW5ldmVyIGEgc3RhZ2UgMSByZWxh
dGVkIGZhdWx0Cj4+Pj4gaXMgZGV0ZWN0ZWQgYXQgcGh5c2ljYWwgbGV2ZWwuIEFsc28gYSBzcGVj
aWZpYyByZWdpb24gYWxsb3dzCj4+Pj4gdG8gZXhwb3NlIHRoZSBmYXVsdCByZWNvcmRzIHRvIHRo
ZSB1c2VyIHNwYWNlLgo+Pj4+Cj4+Pj4gQmVzdCBSZWdhcmRzCj4+Pj4KPj4+PiBFcmljCj4+Pj4K
Pj4+PiBUaGlzIHNlcmllcyBjYW4gYmUgZm91bmQgYXQ6Cj4+Pj4gaHR0cHM6Ly9naXRodWIuY29t
L2VhdWdlci9saW51eC90cmVlL3Y1LjMuMC1yYzAtMnN0YWdlLXY5Cj4+PiBJIHRoaW5rIHlvdSBo
YXZlIGFscmVhZHkgdGVzdGVkIG9uIFRodW5kZXJYMiwgYnV0IGFzIGEgZm9ybWFsaXR5LCBmb3IK
Pj4+IHRoZSB3aG9sZSBzZXJpZXM6Cj4+Pgo+Pj4gVGVzdGVkLWJ5OiBUb21hc3ogTm93aWNraSA8
dG5vd2lja2lAbWFydmVsbC5jb20+Cj4+PiBxZW11OiBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2Vy
L3FlbXUvdHJlZS92NC4xLjAtcmMwLTJzdGFnZS1yZmN2NQo+Pj4ga2VybmVsOiBodHRwczovL2dp
dGh1Yi5jb20vZWF1Z2VyL2xpbnV4L3RyZWUvdjUuMy4wLXJjMC0yc3RhZ2UtdjkgKwo+Pj4gU2hh
bWVlcidzIGZpeCBwYXRjaAo+Pj4KPj4+IEluIG15IHRlc3QgSSBhc3NpZ25lZCBJbnRlbCA4MjU3
NEwgTklDIGFuZCBwZXJmb3JtIGlwZXJmIHRlc3RzLgo+PiBUaGFuayB5b3UgZm9yIHlvdXIgdGVz
dGluZyBlZmZvcnRzLgo+Pj4gT3RoZXIgZm9sa3MgZnJvbSBNYXJ2ZWxsIGNsYWltZWQgdGhpcyB0
byBiZSBpbXBvcnRhbnQgZmVhdHVyZSBzbyBJIGFza2VkCj4+PiB0aGVtIHRvIHJldmlldyBhbmQg
c3BlYWsgdXAgb24gbWFpbGluZyBsaXN0Lgo+PiBUaGF0J3MgbmljZSB0byByZWFkIHRoYXQhwqAg
U28gaXQgaXMgdGltZSBmb3IgbWUgdG8gcmViYXNlIGJvdGggdGhlIGlvbW11Cj4+IGFuZCB2Zmlv
IHBhcnRzLiBJIHdpbGwgc3VibWl0IHNvbWV0aGluZyBxdWlja2x5LiBUaGVuIEkgd291bGQgZW5j
b3VyYWdlCj4+IHRoZSByZXZpZXcgZWZmb3J0cyB0byBmb2N1cyBmaXJzdCBvbiB0aGUgaW9tbXUg
cGFydC4KPj4KPj4KPiB2U1ZBIGZlYXR1cmUgaXMgYWxzbyB2ZXJ5IGltcG9ydGFudCB0byB1cywg
aXQgd2lsbCBiZSBncmVhdCBpZiB2U1ZBIGNhbgo+IGJlIHN1cHBvcnRlZCBpbiBndWVzdCB3b3Js
ZC4KPiAKPiBXZSBqdXN0IHN1Ym1pdHRlZCB1YWNjZSBmb3IgYWNjZWxlcmF0b3IsIHdoaWNoIHdp
bGwgYmUgc3VwcG9ydGluZyBTVkEgb24KPiBob3N0LCB0aGFua3MgdG8gSmVhbidzIGVmZm9ydC4K
PiAKPiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMC8yLzExLzU0Cj4gCj4gCj4gSG93ZXZlciwg
c3VwcG9ydGluZyB2U1ZBIGluIGd1ZXN0IGlzIGFsc28gYSBrZXkgY29tcG9uZW50IGZvciBhY2Nl
bGVyYXRvci4KPiAKPiBMb29raW5nIGZvcndhcmQgdGhpcyBnb2luZyB0byBiZSBoYXBwZW4uCj4g
Cj4gCj4gQW55IHJlc3BpbiwgSSB3aWxsIGJlIHZlcnkgaGFwcHkgdG8gdGVzdC4KCk9LLiBCYXNl
ZCBvbiB5b3VyIGludGVyZXN0IGFuZCBNYXJ2ZWxsJ3MgaW50ZXJlc3QgdG9vLCBJIHdpbGwgcmVz
cGluCmJvdGggaW9tbXUgJiB2ZmlvIHNlcmllcy4KClRoYW5rcwoKRXJpYwo+IAo+IAo+IFRoYW5r
cwo+IAo+IAo+IAo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
