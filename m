Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76DBC2D0EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 08:58:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7378721556
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 08:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAw/DPQ2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7378721556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A4E84B1A3;
	Thu, 16 Apr 2020 04:58:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6KX+u1TelBds; Thu, 16 Apr 2020 04:58:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 202F14B1D1;
	Thu, 16 Apr 2020 04:58:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF0DA4B15D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 04:58:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W9PWLKDg+XZ8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 04:58:48 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACA424B15B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 04:58:48 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 84BF220784;
 Thu, 16 Apr 2020 08:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587027527;
 bh=dVAp91Tj6hWWtUY7tL+aLgKkZ276mvf5MWRT7goV5sk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=NAw/DPQ2vN2rzJzmUreAA38rnfxIXX3BUID+0uehW0Z9v4f/Ntd1a7JWQHTF+uDMv
 4tUi3XdV3gd/0EuPpoon9MJXibqbgTfuDttD3xyfrTBNZAOlFyJ4cRJ6Z+sHqArQUT
 PeqbbpCCaPZTxxeljv/xMr+adoczGliqtOh0MmEk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jP0M9-003lwb-Tr; Thu, 16 Apr 2020 09:58:46 +0100
MIME-Version: 1.0
Date: Thu, 16 Apr 2020 09:58:45 +0100
From: Marc Zyngier <maz@kernel.org>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH v2] KVM: Optimize kvm_arch_vcpu_ioctl_run function
In-Reply-To: <8b92fb5b-5138-0695-fb90-6c36b8dfad00@linux.alibaba.com>
References: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
 <878sivx67g.fsf@vitty.brq.redhat.com>
 <1000159f971a6fa3b5bd9e5871ce4d82@kernel.org>
 <8b92fb5b-5138-0695-fb90-6c36b8dfad00@linux.alibaba.com>
Message-ID: <b700f9bde1218b217ca4e571b1d29c1e@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: tianjia.zhang@linux.alibaba.com, vkuznets@redhat.com,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
 benh@kernel.crashing.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, cohuck@redhat.com, heiko.carstens@de.ibm.com,
 gor@linux.ibm.com, sean.j.christopherson@intel.com, wanpengli@tencent.com,
 jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, mpe@ellerman.id.au, joro@8bytes.org, x86@kernel.org,
 borntraeger@de.ibm.com, mingo@redhat.com, thuth@redhat.com, gor@linux.ibm.com,
 kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 tsbogend@alpha.franken.de, cohuck@redhat.com, linux-mips@vger.kernel.org,
 sean.j.christopherson@intel.com, pbonzini@redhat.com,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

T24gMjAyMC0wNC0xNiAwOTo0NSwgVGlhbmppYSBaaGFuZyB3cm90ZToKPiBPbiAyMDIwLzQvMTYg
MTY6MjgsIE1hcmMgWnluZ2llciB3cm90ZToKClsuLi5dCgo+PiBPdmVyYWxsLCB0aGVyZSBpcyBh
IGxhcmdlIHNldCBvZiBjbGVhbnVwcyB0byBiZSBkb25lIHdoZW4gYm90aCB0aGUgCj4+IHZjcHUg
YW5kIHRoZSBydW4KPj4gc3RydWN0dXJlcyBhcmUgcGFzc2VkIGFzIHBhcmFtZXRlcnMgYXQgdGhl
IHNhbWUgdGltZS4gSnVzdCBncmVwcGluZyAKPj4gdGhlIHRyZWUgZm9yCj4+IGt2bV9ydW4gaXMg
cHJldHR5IGluc3RydWN0aXZlLgo+PiAKPj4gIMKgwqDCoMKgwqDCoMKgIE0uCj4gCj4gU29ycnks
IGl0J3MgbXkgbWlzdGFrZSwgSSBvbmx5IGNvbXBpbGVkIHRoZSB4ODYgcGxhdGZvcm0sIEkgd2ls
bAo+IHN1Ym1pdCBwYXRjaCBhZ2Fpbi4KCk5vdCBhIG1pc3Rha2UuIEFsbCBJJ20gc2F5aW5nIGlz
IHRoYXQgdGhlcmUgaXMgYW4gb3Bwb3J0dW5pdHkgZm9yIGEgCmxhcmdlcgpzZXJpZXMgdGhhdCBj
bGVhbnMgdXAgdGhlIGNvZGUgYmFzZSwgcmF0aGVyIHRoYW4ganVzdCBkb2luZyBhIGNvdXBsZSBv
Zgpsb2NhbGl6ZWQgY2hhbmdlcy4KClRoYW5rcywKCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5v
dCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
