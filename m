Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3ADEC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 28 Feb 2022 21:02:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C3A49E17;
	Mon, 28 Feb 2022 16:02:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WGahSUnSIZzH; Mon, 28 Feb 2022 16:02:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01BBA4101F;
	Mon, 28 Feb 2022 16:02:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CA6E411D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Feb 2022 16:02:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gC5Hu2ZR8iJj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Feb 2022 16:02:51 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB6FC40BDF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Feb 2022 16:02:51 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A73E460F8F;
 Mon, 28 Feb 2022 21:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13226C340F1;
 Mon, 28 Feb 2022 21:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1646082170;
 bh=+zlq/azdEB2IZFXwfoDXE+34FTi9I+0yDoZ4dH2KaeM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=YDg6JCRYOWeQB8L2pYvuzm/cFb3K10jXaYyOXaWI742LnQrKGIK7EYCqA0vaWyEei
 2lPR71kfN9m4cO9y2EhvgIOiYvTI3u7h1l62qpMTqG45flalCYPF4NKQMQCEXla/jN
 ulQ3UghtG8gUNgisRZD/OHZ92balORDEm3UMW5bQbuIEIx2Pu+44gBGQsSIfDzdBo9
 lev+PyZtC7Wb2vZd9l2gyoSI9NQiM1T5bVJDCkC4AXL4/TTZsYyqTLUHH96/7iL+o2
 HmsAJP3NS/XJs4PamNJLABFi6+DJ3taEEDKvsygzzEblN94gHBtHyP88/2mDl5Lc25
 xQ7UDbawC0Egg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nOnAN-00BEbx-Me; Mon, 28 Feb 2022 21:02:47 +0000
MIME-Version: 1.0
Date: Mon, 28 Feb 2022 21:02:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: Eugene Huang <eugeneh@nvidia.com>
Subject: Re: Timer delays in VM
In-Reply-To: <BYAPR12MB31927AEB9D0A4068ED12826DD9019@BYAPR12MB3192.namprd12.prod.outlook.com>
References: <BYAPR12MB31927AEB9D0A4068ED12826DD9019@BYAPR12MB3192.namprd12.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <667c9f084b2d38725369de60daef6d58@misterjones.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eugeneh@nvidia.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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

W1BsZWFzZSBkb24ndCBzZW5kIEhUTUwgZW1haWwgYW5kIHN0aWNrIHRvIHBsYWluIHRleHRdCgpP
biAyMDIyLTAyLTI4IDE4OjAyLCBFdWdlbmUgSHVhbmcgd3JvdGU6Cj4gSGksCj4gCj4gSSBhbSBy
dW5uaW5nIHFlbXUgb24gYW4gYXJtNjQgQ2VudE9TIGhvc3QuIEluc2lkZSBhIHVidW50dSBWTSwg
YQoKSSBhc3N1bWUgdGhhdCBieSB0aGlzIHlvdSBtZWFuIFFFTVUgYXMgdGhlIFZNTSBmb3IgYSBL
Vk0gZ3Vlc3QsIHJpZ2h0PwoKPiBwcm9jZXNzIHJ1bnMgYSB0aW1lciBjcmVhdGVkIHVzaW5nIHRp
bWVyX3Q6Cj4gCj4gZXYuc2lnZXZfbm90aWZ5X2Z1bmN0aW9uID0gbV9jYWxsYmFjazsKPiAKPiDi
gKYKPiAKPiB0aW1lcl9jcmVhdGUoQ0xPQ0tfTU9OT1RPTklDLCAmZXYsICZtX3RpbWVyX3QpOwo+
IAo+IFRoaXMgdGltZXIgc29tZXRpbWVzIGhhcyBzaWduaWZpY2FudCBkZWxheXMuIEZvciBleGFt
cGxlLCB0aGUgNTAgbXMKPiB0aW1lciBjYW4gaGF2ZSBhIGNhbGxiYWNrIGRlbGF5IG9mIDEwMG1z
Lgo+IAo+IEkgZGlkIGEgaG9zdCBrZXJuZWwgdHJhY2UgYW5kIHNlZSBhIGxvdCBvZiBXRngga3Zt
X2V4aXRzLCBhbmQgIHRoZQo+IGZvbGxvd2luZyBldmVudHMgYmV0d2VlbiBrdm1fZXhpdCBhbmQg
a3ZtX2VudHJ5Ogo+IAo+IGt2bV9leGl0Cj4gCj4ga3ZtX3dmeF9hcm02NAo+IAo+IGt2bV9nZXRf
dGltZXJfbWFwCj4gCj4gc2NoZWRfc3dpdGNoCj4gCj4ga3ZtX3RpbWVyX3NhdmVfc3RhdGUKPiAK
PiBrdm1fdGltZXJfdXBkYXRlX2lycQo+IAo+IHZnaWNfdXBkYXRlX2lycV9wZW5kaW5nCj4gCj4g
a3ZtX3RpbWVyX3Jlc3RvcmVfc3RhdGUKPiAKPiBrdm1fdmNwdV93YWtldXAKPiAKPiBrdm1fYXJt
X3NldHVwX2RlYnVnCj4gCj4ga3ZtX2FybV9zZXRfZHJlZzMyCj4gCj4ga3ZtX2VudHJ5CgpBbGwg
b2YgdGhpcyBpcyBwZXJmZWN0bHkgbm9ybWFsIChndWVzdCBoaXRzIFdGSSBmcm9tIGl0cyBpZGxl
Cmxvb3AsIG5vIGludGVycnVwdCBpcyBwZW5kaW5nLCB0cmFwIHRvIEVMMiwgc2NoZWR1bGUgb3V0
LApzY2hlZHVsZSBiYWNrIGluLCByZWVudGVyIHRoZSBndWVzdCkuCgo+IAo+IEkgaGF2ZSB0aGUg
Zm9sbG93aW5nIHF1ZXN0aW9uczoKPiAKPiAgCSogV2h5IHRoZXJlIGFyZSBhIGxvdCBXRnggZXhp
dHM/IElzIHRoZSB0aW1lciBkZXBlbmRlbnQgb24gaXQ/CgpUaGF0J3MgbW9zdCBwcm9iYWJseSBi
ZWNhdXNlIHlvdXIgdmNwdSBnb2VzIGlkbGUgYW5kIGV4ZWN1dGUgV0ZJIHRvCldhaXQgRm9yIGFu
IEludGVycnVwdC4gQXMgbm8gaW50ZXJydXB0IGlzIHBlbmRpbmcsIHRoZSB2Y3B1IGV4aXRzCnNv
IHRoYXQgdGhlIGhvc3QgY2FuIGRvIHNvbWV0aGluZyB1c2VmdWwgdW50aWwgaXQgZ2V0cyBhbiBp
bnRlcnJ1cHQKdGhhdCBpcyB0YXJnZXRlZCBhdCB0aGUgdmNwdS4gT24gYW4gaWRsZSBWTSwgdGhp
cyBwcm9iYWJseSBoYXBwZW5zCjEwMHMgb2YgdGltZXMgYSBzZWNvbmQuCgo+IAkqIERvZXMgdGhp
cyB0aW1lciByZWx5IG9uIGt2bSB0aW1lciBpcnEgaW5qZWN0aW9uPwoKWWVzLiBBIHRpbWVyIGlu
dGVycnVwdCBpcyBhbHdheXMgaW5qZWN0ZWQgaW4gU1cuIEJ1dCB0aGUgdGltZXIKaW50ZXJydXB0
IGNhbiBlaXRoZXIgY29tZSBmcm9tIHRoZSBIVyB0aW1lciBpdHNlbGYgKHRoZSBWTQp3YXMgcnVu
bmluZyB3aGlsZSB0aGUgdGltZXIgZXhwaXJlZCksIG9yIGZyb20gYSBTVyB0aW1lciB0aGF0CktW
TSBhcyBzZXR1cCBpZiB0aGUgZ3Vlc3Qgd2FzIGJsb2NrZWQgb24gV0ZJLgoKPiAJKiBXaGF0IGNh
biBiZSBhbnkgcG9zc2libGUgY2F1c2VzIGZvciB0aGUgdGltZXIgZGVsYXk/IEFyZSB0aGVyZSBz
b21lCj4gbG9ja2luZyBtZWNoYW5pc21zIHdoaWNoIGNhbiBjYXVzZSB0aGUgZGVsYXk/CgpUaGlz
IGNvbXBsZXRlbHkgZGVwZW5kIG9uIGhvdyBsb2FkZWQgeW91ciBob3N0IGlzLCB0aGUgcmVzcGVj
dGl2ZQpwcmlvcml0aWVzIG9mIHRoZSB2YXJpb3VzIHByb2Nlc3NlcywgYW5kIGEgbWlsbGlvbiBv
ZiBvdGhlciB0aGluZ3MuClRoaXMgaXMgbm8gZGlmZmVyZW50IGZyb20gdGhlIHNhbWUgdXNlcnNw
YWNlIHJ1bm5pbmcgb24gdGhlIGhvc3QuCkl0IGFsc28gZGVwZW5kcyBvbiB0aGUgKmd1ZXN0KiBr
ZXJuZWwsIGJ5IHRoZSB3YXkuCgpUaGVyZSBhcmUgb2YgY291cnNlIGxvY2tzIGFsbCBvdmVyIHRo
ZSBwbGFjZSwgYnV0IHRoYXQncyB0aGUgdmVyeQpuYXR1cmUgb2YgdGhlIGJlYXN0LgoKPiAJKiBX
aGF0IHBhcmFtZXRlcnMgY2FuIHR1bmUgdGhpcyB0aW1lcj8KCk5vbmUuIFlvdSBtYXkgd2FudCB0
byBjaGVjayB3aGV0aGVyIHRoZSBkZWxheSBpcyBvYnNlcnZlZCB3aGVuIHRoZQpWTSBoYXMgaGl0
IFdGSSBvciBub3QuCgpZb3UgYWxzbyBkb24ndCBtZW50aW9uIHdoYXQgaG9zdCBrZXJuZWwgdmVy
c2lvbiB5b3UgYXJlIHJ1bm5pbmcuCkluIGdlbmVyYWwsIHBsZWFzZSB0cnkgYW5kIHJlcHJvZHVj
ZSB0aGUgaXNzdWUgdXNpbmcgdGhlIGxhdGVzdAprZXJuZWwgdmVyc2lvbiAoNS4xNiBhdCB0aGUg
bW9tZW50KS4gUGxlYXNlIGFsc28gaW5kaWNhdGUgd2hhdApIVyB5b3UgYXJlIHVzaW5nLgoKVGhh
bmtzLAoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1
bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
