Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82158C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 15:00:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02CD449EF7;
	Mon, 14 Mar 2022 11:00:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MSEbUXigv3m8; Mon, 14 Mar 2022 11:00:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4D549ED5;
	Mon, 14 Mar 2022 11:00:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB36C49ED5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 11:00:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3n4i5Zo8tvz9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 11:00:48 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A72B49EC1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 11:00:48 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id BA367B80E28;
 Mon, 14 Mar 2022 15:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2011C340EC;
 Mon, 14 Mar 2022 15:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1647270045;
 bh=TYhiBrC14m4Ad4E1iYepcEh5UqxKOLKQ/jszH2k2vNU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=IfI5NEUHZ9MnYcv/aEYl2ohIRe3rJ8o1opGh29GdmnNyJerbeHFejBuaM/s0mk1fK
 6N5fHBqHv/hwJIiX/DCOrO803EJ2Gv/8KEb1g0MTvrgMyIRvwteMPOZJ19Vf9ApVAH
 JMRbeKTDaC4CvfpbQzAOymFdX8v0fFphRYbZoR9k=
Date: Mon, 14 Mar 2022 16:00:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH 4.19 00/30] 4.19.235-rc1 review
Message-ID: <Yi9Ymvmu09seXAD5@kroah.com>
References: <20220314112731.785042288@linuxfoundation.org>
 <0ac87017-362d-33e2-eace-3407e0891a94@nvidia.com>
 <Yi9LlP+x2swdsrbE@kroah.com>
 <CA+G9fYuwyUPMBRuBL10Z0r1MRt0sZ-MqvC6ySHBtpqdSp8UcDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+G9fYuwyUPMBRuBL10Z0r1MRt0sZ-MqvC6ySHBtpqdSp8UcDQ@mail.gmail.com>
Cc: kvmarm@lists.cs.columbia.edu, f.fainelli@gmail.com,
 Catalin Marinas <catalin.marinas@arm.com>, pavel@denx.de, shuah@kernel.org,
 slade@sladewatkins.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Jon Hunter <jonathanh@nvidia.com>, lkft-triage@lists.linaro.org,
 patches@kernelci.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, akpm@linux-foundation.org,
 torvalds@linux-foundation.org, sudipm.mukherjee@gmail.com, linux@roeck-us.net
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

T24gTW9uLCBNYXIgMTQsIDIwMjIgYXQgMDg6MDI6MjFQTSArMDUzMCwgTmFyZXNoIEthbWJvanUg
d3JvdGU6Cj4gPiA+ID4gb3IgaW4gdGhlIGdpdCB0cmVlIGFuZCBicmFuY2ggYXQ6Cj4gPiA+ID4g
ICAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUv
bGludXgtc3RhYmxlLXJjLmdpdCBsaW51eC00LjE5LnkKPiA+ID4gPiBhbmQgdGhlIGRpZmZzdGF0
IGNhbiBiZSBmb3VuZCBiZWxvdy4KPiA+ID4gPgo+ID4gPiA+IHRoYW5rcywKPiA+ID4gPgo+ID4g
PiA+IGdyZWcgay1oCj4gPiA+ID4KPiA+ID4gPiAtLS0tLS0tLS0tLS0tCj4gPiA+ID4gUHNldWRv
LVNob3J0bG9nIG9mIGNvbW1pdHM6Cj4gPiA+Cj4gPiA+IC4uLgo+ID4gPgo+ID4gPiA+IEphbWVz
IE1vcnNlIDxqYW1lcy5tb3JzZUBhcm0uY29tPgo+ID4gPiA+ICAgICAgS1ZNOiBhcm02NDogUmVz
ZXQgUE1DX0VMMCB0byBhdm9pZCBhIHBhbmljKCkgb24gc3lzdGVtcyB3aXRoIG5vIFBNVQo+ID4g
Pgo+ID4gPgo+ID4gPiBUaGUgYWJvdmUgaXMgY2F1c2luZyB0aGUgZm9sbG93aW5nIGJ1aWxkIGVy
cm9yIGZvciBBUk02NCAuLi4KPiA+ID4KPiA+ID4gYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYzog
SW4gZnVuY3Rpb24g4oCYcmVzZXRfcG1jcuKAmToKPiA+ID4gYXJjaC9hcm02NC9rdm0vc3lzX3Jl
Z3MuYzo2MjQ6MzogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIOKAmHZj
cHVfc3lzX3JlZ+KAmSBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0KPiA+
ID4gICAgdmNwdV9zeXNfcmVnKHZjcHUsIFBNQ1JfRUwwKSA9IDA7Cj4gPiA+ICAgIF5+fn5+fn5+
fn5+fgo+ID4gPiBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jOjYyNDozMjogZXJyb3I6IGx2YWx1
ZSByZXF1aXJlZCBhcyBsZWZ0IG9wZXJhbmQgb2YgYXNzaWdubWVudAo+ID4gPiAgICB2Y3B1X3N5
c19yZWcodmNwdSwgUE1DUl9FTDApID0gMDsKPiA+ID4KPiA+Cj4gPiBJcyB0aGlzIGFsc28gYnJv
a2VuIGluIExpbnVzJ3MgdHJlZT8KPiAKPiBub3BlLgo+IEl0IGlzIGFsc28gb25seSBvbiA0LjE5
LgoKVGhhbmtzLiAgSSd2ZSBwdXNoZWQgb3V0IC1yYzIgcmVsZWFzZXMgd2l0aCB0aGlzIGNvbW1p
dCBkcm9wcGVkLgoKZ3JlZyBrLWgKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
