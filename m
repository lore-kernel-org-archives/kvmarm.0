Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F86CA9EB7
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 07:55:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9C8020663
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 07:55:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9C8020663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13BDD4AC17;
	Mon, 21 Oct 2019 03:55:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EqX0NhwsnEYI; Mon, 21 Oct 2019 03:55:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 036B44AC09;
	Mon, 21 Oct 2019 03:55:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58C6C4A9FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 03:55:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cWoPlywHoivI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 03:55:55 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D01E4A9F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 03:55:55 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iMSXe-0007gc-Fy; Mon, 21 Oct 2019 09:55:50 +0200
To: =?UTF-8?Q?J=C3=BCrgen_Gro=C3=9F?= <jgross@suse.com>
Subject: Re: [PATCH v6 10/10] arm64: Retrieve stolen time as paravirtualized
 guest
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 21 Oct 2019 08:55:50 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <237a3457-bcb3-c9b7-11ef-241b7ccc370e@suse.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-11-steven.price@arm.com>
 <86a79wzdhk.wl-maz@kernel.org>
 <237a3457-bcb3-c9b7-11ef-241b7ccc370e@suse.com>
Message-ID: <e8fa44e1e6bcb58ea07b5064ed40e088@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: jgross@suse.com, steven.price@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com,
 linux@armlinux.org.uk, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, mark.rutland@arm.com, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Steven Price <steven.price@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

T24gMjAxOS0xMC0yMSAwNjowMSwgSsO8cmdlbiBHcm/DnyB3cm90ZToKPiBPbiAxOS4xMC4xOSAy
MjoyOCwgTWFyYyBaeW5naWVyIHdyb3RlOgoKPj4gSG93IGFib3V0IHNvbWV0aGluZyBsaWtlIHB2
X3RpbWVfaW5pdCgpIGluc3RlYWQ/IEluIHRoZSBndWVzdCwgdGhpcyAKPj4gaXMKPj4gbm8gd2F5
IEtWTSBzcGVjaWZpYywgYW5kIEkgc3RpbGwgaG9wZSBmb3IgdGhpcyB0byB3b3JrIG9uIHRoaW5n
cyAKPj4gbGlrZQo+PiBYZW4vSHlwZXJWL1ZNd2FyZSAoeWVhaCwgSSdtIGZvb2xpc2hseSBvcHRp
bWlzdGljKS4gQWxsIHRoZSAKPj4gcmVmZXJlbmNlcwo+PiB0byBLVk0gc2hvdWxkIGdvLCBhbmQg
YmUgcmVwbGFjZWQgYnkgc29tZXRoaW5nIG1vcmUgZ2VuZXJpYyAoYWZ0ZXIKPj4gYWxsLCB5b3Un
cmUgb25seSBpbXBsZW1lbnRpbmcgdGhlIHNwZWMsIHNvIGZlZWwgZnJlZSB0byBjYWxsIGl0Cj4+
IGRlbjAwNTdfKiBpZiB5b3UgcmVhbGx5IHdhbnQpLgo+Cj4gWGVuIGd1ZXN0cyBhbHJlYWR5IGhh
dmUgdGhlIG5lZWRlZCBmdW5jdGlvbmFsaXR5LiBPbiBBUk0gdGhpcyBqdXN0IAo+IG5lZWRzCj4g
dG8gYmUgaG9va2VkIHVwLgoKWWVzLCBYZW4gb2ZmZXJzIGl0cyBvd24gUFYgaW50ZXJmYWNlIGZv
ciB0aGF0LiBCdXQgdGhpcyBjb2RlIGlzIGFib3V0CmltcGxlbWVudGluZyBzdXBwb3J0IGZvciBh
IGNyb3NzIGh5cGVydmlzb3IgZnVuY3Rpb25uYWxpdHkgKHdoaWNoIApBRkFJQ1QKaXMgbm90IGlt
cGxlbWVudGVkIGJ5IFhlbikuCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQg
anVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
