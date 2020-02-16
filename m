Return-Path: <SRS0=vR/6=4E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2270C2BA83
	for <kvmarm@archiver.kernel.org>; Sun, 16 Feb 2020 10:46:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6EA4720857
	for <kvmarm@archiver.kernel.org>; Sun, 16 Feb 2020 10:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="RMQrDTHX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EA4720857
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 006ED4A4CD;
	Sun, 16 Feb 2020 05:46:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@c-s.fr
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GsFuohMNaUoW; Sun, 16 Feb 2020 05:46:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD584A4FC;
	Sun, 16 Feb 2020 05:46:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74EAD4A418
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Feb 2020 05:46:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nHds1cQaAwiM for <kvmarm@lists.cs.columbia.edu>;
 Sun, 16 Feb 2020 05:46:13 -0500 (EST)
Received: from pegase1.c-s.fr (pegase1.c-s.fr [93.17.236.30])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 554B94A3BF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Feb 2020 05:46:13 -0500 (EST)
Received: from localhost (mailhub1-int [192.168.12.234])
 by localhost (Postfix) with ESMTP id 48L3gh69Lpz9tyMB;
 Sun, 16 Feb 2020 11:46:08 +0100 (CET)
Authentication-Results: localhost; dkim=pass
 reason="1024-bit key; insecure key"
 header.d=c-s.fr header.i=@c-s.fr header.b=RMQrDTHX; dkim-adsp=pass;
 dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
 by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
 with ESMTP id 0F5rpVhkSbpS; Sun, 16 Feb 2020 11:46:08 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
 by pegase1.c-s.fr (Postfix) with ESMTP id 48L3gh3dBjz9tyM9;
 Sun, 16 Feb 2020 11:46:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
 t=1581849968; bh=puEVphfmlLbrWTO3mdDB17WkluHf49q+nkCLHU1WEPk=;
 h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
 b=RMQrDTHXiSIvSNdSJIUAuTLTwTBfKbldAHrwtZjJ0BW+ZG7c0EUq537f7BNPK+LIN
 e+qzSqPhQUdW5m9f0ovUN5sc2R9fpgjJRx6JMSfOyIGDK3OikFgbqf4WNmfnjBWb14
 Yj8xq1+79SXISvpVp+Jg6Y8NZ4c+QrYGyIAwuT0U=
Received: from localhost (localhost [127.0.0.1])
 by messagerie.si.c-s.fr (Postfix) with ESMTP id 63ADD8B784;
 Sun, 16 Feb 2020 11:46:10 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
 by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
 with ESMTP id GYiIMEW0V5j7; Sun, 16 Feb 2020 11:46:10 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
 by messagerie.si.c-s.fr (Postfix) with ESMTP id 992958B755;
 Sun, 16 Feb 2020 11:45:59 +0100 (CET)
Subject: Re: [PATCH v2 00/13] mm: remove __ARCH_HAS_5LEVEL_HACK
To: Russell King - ARM Linux admin <linux@armlinux.org.uk>,
 Mike Rapoport <rppt@kernel.org>
References: <20200216081843.28670-1-rppt@kernel.org>
 <20200216082230.GV25745@shell.armlinux.org.uk>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <d6691709-30ce-4d28-0b7b-34f1fa3b4e6f@c-s.fr>
Date: Sun, 16 Feb 2020 11:45:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200216082230.GV25745@shell.armlinux.org.uk>
Content-Language: fr
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org,
 Geert Uytterhoeven <geert+renesas@glider.be>, linux-sh@vger.kernel.org,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
 Paul Mackerras <paulus@samba.org>, linux-hexagon@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Jonas Bonn <jonas@southpole.se>, linux-arch@vger.kernel.org,
 Brian Cain <bcain@codeaurora.org>, Marc Zyngier <maz@kernel.org>,
 Ley Foon Tan <ley.foon.tan@intel.com>, Mike Rapoport <rppt@linux.ibm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 uclinux-h8-devel@lists.sourceforge.jp, Fenghua Yu <fenghua.yu@intel.com>,
 Arnd Bergmann <arnd@arndb.de>, kvm-ppc@vger.kernel.org,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 openrisc@lists.librecores.org, Stafford Horne <shorne@gmail.com>,
 Guan Xuetao <gxt@pku.edu.cn>, linux-arm-kernel@lists.infradead.org,
 Tony Luck <tony.luck@intel.com>, Yoshinori Sato <ysato@users.sourceforge.jp>,
 linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 nios2-dev@lists.rocketboards.org, Andrew Morton <akpm@linux-foundation.org>,
 linuxppc-dev@lists.ozlabs.org
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

CgpMZSAxNi8wMi8yMDIwIMOgIDA5OjIyLCBSdXNzZWxsIEtpbmcgLSBBUk0gTGludXggYWRtaW4g
YSDDqWNyaXTCoDoKPiBPbiBTdW4sIEZlYiAxNiwgMjAyMCBhdCAxMDoxODozMEFNICswMjAwLCBN
aWtlIFJhcG9wb3J0IHdyb3RlOgo+PiBGcm9tOiBNaWtlIFJhcG9wb3J0IDxycHB0QGxpbnV4Lmli
bS5jb20+Cj4+Cj4+IEhpLAo+Pgo+PiBUaGVzZSBwYXRjaGVzIGNvbnZlcnQgc2V2ZXJhbCBhcmNo
aXRlY3R1cmVzIHRvIHVzZSBwYWdlIHRhYmxlIGZvbGRpbmcgYW5kCj4+IHJlbW92ZSBfX0FSQ0hf
SEFTXzVMRVZFTF9IQUNLIGFsb25nIHdpdGggaW5jbHVkZS9hc20tZ2VuZXJpYy81bGV2ZWwtZml4
dXAuaC4KPj4KPj4gVGhlIGNoYW5nZXMgYXJlIG1vc3RseSBhYm91dCBtZWNoYW5pY2FsIHJlcGxh
Y2VtZW50IG9mIHBnZCBhY2Nlc3NvcnMgd2l0aCBwNGQKPj4gb25lcyBhbmQgdGhlIGFkZGl0aW9u
IG9mIGhpZ2hlciBsZXZlbHMgdG8gcGFnZSB0YWJsZSB0cmF2ZXJzYWxzLgo+Pgo+PiBBbGwgdGhl
IHBhdGNoZXMgd2VyZSBzZW50IHNlcGFyYXRlbHkgdG8gdGhlIHJlc3BlY3RpdmUgYXJjaCBsaXN0
cyBhbmQKPj4gbWFpbnRhaW5lcnMgaGVuY2UgdGhlICJ2MiIgcHJlZml4Lgo+IAo+IFlvdSBmYWls
IHRvIGV4cGxhaW4gd2h5IHRoaXMgY2hhbmdlIHdoaWNoIGFkZHMgNDg4IGFkZGl0aW9uYWwgbGlu
ZXMgb2YKPiBjb2RlIGlzIGRlc2lyYWJsZS4KPiAKClRoZSBwdXJwb3NlIG9mIHRoZSBzZXJpZXMs
IGllIGRyb3BpbmcgYSBIQUNLLCBpcyB3b3J0aCBpdC4KCkhvd2V2ZXIgbG9va2luZyBhdCB0aGUg
cG93ZXJwYyBwYXRjaCBJIGhhdmUgdGhlIGZlZWxpbmcgdGhhdCB0aGlzIHNlcmllcyAKZ29lcyBi
ZWhpbmQgaXRzIHB1cnBvc2UuCgpUaGUgbnVtYmVyIGFkZGl0aW9uYWwgbGluZXMgY291bGQgYmUg
ZGVlcGx5IHJlZHVjZWQgSSB0aGluayBpZiB3ZSBsaW1pdCAKdGhlIHBhdGNoZXMgdG8gdGhlIHN0
cmljdCBtaW5pbXVtLCBpZSBqdXN0IGRvIHRoaW5ncyBsaWtlIGJlbG93IGluc3RlYWQgCm9mIGFk
ZGluZyBsb3RzIG9mIGhhbmRsaW5nIG9mIHVzZWxlc3MgbGV2ZWxzLgoKSW5zdGVhZCBvZiBkb2lu
ZyB0aGluZ3MgbGlrZToKCi0JcHVkID0gTlVMTDsKKwlwNGQgPSBOVUxMOwogIAlpZiAocGdkX3By
ZXNlbnQoKnBnZCkpCi0JCXB1ZCA9IHB1ZF9vZmZzZXQocGdkLCBncGEpOworCQlwNGQgPSBwNGRf
b2Zmc2V0KHBnZCwgZ3BhKTsKKwllbHNlCisJCW5ld19wNGQgPSBwNGRfYWxsb2Nfb25lKGt2bS0+
bW0sIGdwYSk7CisKKwlwdWQgPSBOVUxMOworCWlmIChwNGRfcHJlc2VudCgqcDRkKSkKKwkJcHVk
ID0gcHVkX29mZnNldChwNGQsIGdwYSk7CiAgCWVsc2UKICAJCW5ld19wdWQgPSBwdWRfYWxsb2Nf
b25lKGt2bS0+bW0sIGdwYSk7CgpJdCBjb3VsZCBiZSBsaW1pdGVkIHRvOgoKICAJaWYgKHBnZF9w
cmVzZW50KCpwZ2QpKQotCQlwdWQgPSBwdWRfb2Zmc2V0KHBnZCwgZ3BhKTsKKwkJcHVkID0gcHVk
X29mZnNldChwNGRfb2Zmc2V0KHBnZCwgZ3BhKSwgZ3BhKTsKICAJZWxzZQogIAkJbmV3X3B1ZCA9
IHB1ZF9hbGxvY19vbmUoa3ZtLT5tbSwgZ3BhKTsKCgpDaHJpc3RvcGhlCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
