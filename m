Return-Path: <SRS0=WQBf=WM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF56EC3A59C
	for <kvmarm@archiver.kernel.org>; Fri, 16 Aug 2019 16:32:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 65E6920665
	for <kvmarm@archiver.kernel.org>; Fri, 16 Aug 2019 16:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65E6920665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C34B84A546;
	Fri, 16 Aug 2019 12:32:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lvco2W2oLVMc; Fri, 16 Aug 2019 12:32:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 753044A537;
	Fri, 16 Aug 2019 12:32:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC7B4A537
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Aug 2019 12:32:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1pPO0dcPWDlz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Aug 2019 12:32:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C26304A51D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Aug 2019 12:32:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B725328;
 Fri, 16 Aug 2019 09:32:41 -0700 (PDT)
Received: from [10.1.196.50] (e108454-lin.cambridge.arm.com [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6AE0D3F694;
 Fri, 16 Aug 2019 09:32:39 -0700 (PDT)
Subject: Re: KVM Arm64 and Linux-RT issues
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <b9867c43-7fe3-5d64-9939-b1a7ab7f1061@arm.com>
 <cd310858-2c0f-6af1-bf82-ee1e01a2cfb8@arm.com>
 <alpine.DEB.2.21.1907270053360.1791@nanos.tec.linutronix.de>
 <86zhkzn319.wl-maz@kernel.org> <960b5ed1-6d0f-3cee-da37-6061b4946c1a@arm.com>
 <20190813125835.5v26s4iuv44lw2xg@linutronix.de>
 <adc0b2e2-3a2e-5685-8eb5-2ce927d2139e@arm.com> <865zn1nidx.wl-maz@kernel.org>
 <1f76c277-665a-e962-8cbe-b3c4ecad41b0@arm.com>
 <20190816152317.pbhctfiyurjrepju@linutronix.de>
From: Julien Grall <julien.grall@arm.com>
Message-ID: <e9a77a95-ce0e-27a4-acb0-e997eb656e14@arm.com>
Date: Fri, 16 Aug 2019 17:32:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816152317.pbhctfiyurjrepju@linutronix.de>
Content-Language: en-US
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, anna-maria@linutronix.de,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

SGkgU2ViYXN0aWFuLAoKT24gMTYvMDgvMjAxOSAxNjoyMywgU2ViYXN0aWFuIEFuZHJ6ZWogU2ll
d2lvciB3cm90ZToKPiBPbiAyMDE5LTA4LTE2IDE2OjE4OjIwIFsrMDEwMF0sIEp1bGllbiBHcmFs
bCB3cm90ZToKPj4gU2FkbHksIEkgbWFuYWdlZCB0byBoaXQgdGhlIHNhbWUgQlVHX09OKCkgdG9k
YXkgd2l0aCB0aGlzIHBhdGNoCj4+IGFwcGxpZWQgb24gdG9wIHY1LjItcnQxLXJlYmFzZS4gOi8g
QWx0aG91Z2gsIGl0IGlzIG1vcmUgZGlmZmljdWx0Cj4+IHRvIGhpdCB0aGFuIHByZXZpb3VzbHku
Cj4+Cj4+IFsgIDE1Ny40NDk1NDVdIDAwMDogQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQg
ZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQga2VybmVsL2xvY2tpbmcvcnRtdXRleC5jOjk2OAo+PiBb
ICAxNTcuNDQ5NTY5XSAwMDA6IGluX2F0b21pYygpOiAxLCBpcnFzX2Rpc2FibGVkKCk6IDAsIHBp
ZDogOTkwLCBuYW1lOiBrdm0tdmNwdS0xCj4+IFsgIDE1Ny40NDk1NzldIDAwMDogMiBsb2NrcyBo
ZWxkIGJ5IGt2bS12Y3B1LTEvOTkwOgo+PiBbICAxNTcuNDQ5NTkyXSAwMDA6ICAjMDogMDAwMDAw
MDBjMmZjODIxNyAoJnZjcHUtPm11dGV4KXsrLisufSwgYXQ6IGt2bV92Y3B1X2lvY3RsKzB4NzAv
MHhhZTAKPj4gWyAgMTU3LjQ0OTYzOF0gMDAwOiAgIzE6IDAwMDAwMDAwOTY4NjM4MDEgKCZjcHVf
YmFzZS0+c29mdGlycV9leHBpcnlfbG9jayl7Ky4rLn0sIGF0OiBocnRpbWVyX2dyYWJfZXhwaXJ5
X2xvY2srMHgyNC8weDQwCj4+IFsgIDE1Ny40NDk2NzddIDAwMDogUHJlZW1wdGlvbiBkaXNhYmxl
ZCBhdDoKPj4gWyAgMTU3LjQ0OTY3OV0gMDAwOiBbPGZmZmYwMDAwMTExYTQ1Mzg+XSBzY2hlZHVs
ZSsweDMwLzB4ZDgKPj4gWyAgMTU3LjQ0OTcwMl0gMDAwOiBDUFU6IDAgUElEOiA5OTAgQ29tbTog
a3ZtLXZjcHUtMSBUYWludGVkOiBHICAgICAgICBXIDUuMi4wLXJ0MS0wMDAwMS1nZDM2ODEzOWU4
OTJmICMxMDQKPj4gWyAgMTU3LjQ0OTcxMl0gMDAwOiBIYXJkd2FyZSBuYW1lOiBBUk0gTFREIEFS
TSBKdW5vIERldmVsb3BtZW50IFBsYXRmb3JtL0FSTSBKdW5vIERldmVsb3BtZW50IFBsYXRmb3Jt
LCBCSU9TIEVESyBJSSBKYW4gMjMgMjAxNwo+PiBbICAxNTcuNDQ5NzE4XSAwMDA6IENhbGwgdHJh
Y2U6Cj4+IFsgIDE1Ny40NDk3MjJdIDAwMDogIGR1bXBfYmFja3RyYWNlKzB4MC8weDEzMAo+PiBb
ICAxNTcuNDQ5NzMwXSAwMDA6ICBzaG93X3N0YWNrKzB4MTQvMHgyMAo+PiBbICAxNTcuNDQ5NzM4
XSAwMDA6ICBkdW1wX3N0YWNrKzB4YmMvMHgxMDQKPj4gWyAgMTU3LjQ0OTc0N10gMDAwOiAgX19f
bWlnaHRfc2xlZXArMHgxOTgvMHgyMzgKPj4gWyAgMTU3LjQ0OTc1Nl0gMDAwOiAgcnRfc3Bpbl9s
b2NrKzB4NWMvMHg3MAo+PiBbICAxNTcuNDQ5NzY1XSAwMDA6ICBocnRpbWVyX2dyYWJfZXhwaXJ5
X2xvY2srMHgyNC8weDQwCj4+IFsgIDE1Ny40NDk3NzNdIDAwMDogIGhydGltZXJfY2FuY2VsKzB4
MWMvMHgzOAo+PiBbICAxNTcuNDQ5NzgwXSAwMDA6ICBrdm1fdGltZXJfdmNwdV9sb2FkKzB4Nzgv
MHgzZTAKPiAKPiDigKYKPj4gSSB3aWxsIGRvIHNvbWUgZGVidWcgYW5kIHNlZSB3aGF0IEkgY2Fu
IGZpbmQuCj4gCj4gd2hpY2ggdGltZXIgaXMgdGhpcz8gSXMgdGhlcmUgYW5vdGhlciBvbmU/CgpJ
dCBsb29rcyBsaWtlIHRoZSB0aW1lciBpcyB0aGUgYmFja2dyb3VuZCB0aW1lciAoYmdfdGltZXIp
LgpBbHRob3VnaCwgdGhlIEJVRygpIHNlZW1zIHRvIGhhcHBlbiB3aXRoIHRoZSBvdGhlciBvbmVz
CmJ1dCBsZXNzIG9mdGVuLiBBbGwgb2YgdGhlbSBoYXZlIGFscmVhZHkgYmVlbiBjb252ZXJ0ZWQu
CgpJbnRlcmVzdGluZ2x5LCBocnRpbWVyX2dyYWJfZXhwaXJ5X2xvY2sgbWF5IGJlIGNhbGxlZCBi
eQp0aW1lciBldmVuIGlmIGlzX3NvZnQgKEkgYXNzdW1lIHRoaXMgbWVhbnMgc29mdGlycSB3aWxs
Cm5vdCBiZSB1c2VkKSBpcyAwLgoKZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL2hydGltZXIuYyBi
L2tlcm5lbC90aW1lL2hydGltZXIuYwppbmRleCA3ZDdkYjg4MDIxMzEuLmZlMDVlNTUzZGVhMiAx
MDA2NDQKLS0tIGEva2VybmVsL3RpbWUvaHJ0aW1lci5jCisrKyBiL2tlcm5lbC90aW1lL2hydGlt
ZXIuYwpAQCAtOTM0LDYgKzkzNCw5IEBAIHZvaWQgaHJ0aW1lcl9ncmFiX2V4cGlyeV9sb2NrKGNv
bnN0IHN0cnVjdCBocnRpbWVyICp0aW1lcikKIHsKICAgICAgICBzdHJ1Y3QgaHJ0aW1lcl9jbG9j
a19iYXNlICpiYXNlID0gdGltZXItPmJhc2U7CiAKKyAgICAgICBXQVJOKCFwcmVlbXB0aWJsZSgp
LCAiaXNfc29mdCAldSBiYXNlICVwIGJhc2UtPmNwdV9iYXNlICVwXG4iLAorICAgICAgICAgICAg
dGltZXItPmlzX3NvZnQsIGJhc2UsIGJhc2UgPyBiYXNlLT5jcHVfYmFzZSA6IE5VTEwpOworCiAg
ICAgICAgaWYgKGJhc2UgJiYgYmFzZS0+Y3B1X2Jhc2UpIHsKICAgICAgICAgICAgICAgIHNwaW5f
bG9jaygmYmFzZS0+Y3B1X2Jhc2UtPnNvZnRpcnFfZXhwaXJ5X2xvY2spOwogICAgICAgICAgICAg
ICAgc3Bpbl91bmxvY2soJmJhc2UtPmNwdV9iYXNlLT5zb2Z0aXJxX2V4cGlyeV9sb2NrKTsKClsg
IDU3Ni4yOTE4ODZdIDAwNDogaXNfc29mdCAwIGJhc2UgZmZmZjgwMDk3ZWVkNDRjMCBiYXNlLT5j
cHVfYmFzZSBmZmZmODAwOTdlZWQ0MzgwCgpCZWNhdXNlIHRoZSBocnRpbWVyIGlzIHN0YXJ0ZWQg
d2hlbiBzY2hlZHVsaW5nIG91dCB0aGUKdkNQVSBhbmQgY2FuY2VsZWQgd2hlbiB0aGUgc2NoZWR1
bGluZyBpbiwgdGhlcmUgaXMgbm8KZ3VhcmFudGVlIHRoZSBocnRpbWVyIHdpbGwgYmUgcnVubmlu
ZyBvbiB0aGUgc2FtZSBwQ1BVLgpTbyBJIHRoaW5rIHRoZSBmb2xsb3dpbmcgY2FuIGhhcHBlbjoK
CkNQVTAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICBDUFUxCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8CiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICBocnRpbWVyX2ludGVycnVwdCgp
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIHJhd19z
cGluX2xvY2tfaXJxc2F2ZSgmY3B1X3NhdmUtPmxvY2spCiBocnRpbWVyX2NhbmNlbCgpICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgX19ydW5faHJ0aW1lcl9ydW5fcXVldWVzKCkK
ICAgaHJ0aW1lcl90cnlfdG9fY2FuY2VsKCkgICAgICAgICAgICAgICAgICAgIHwgICAgICBfX3J1
bl9ocnRpbWVyKCkKICAgICBsb2NrX2hydGltZXJfYmFzZSgpICAgICAgICAgICAgICAgICAgICAg
IHwgICAgICAgIGJhc2UtPnJ1bm5pbmcgPSB0aW1lcjsKICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgIHJhd19zcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZjcHVfc2F2ZS0+bG9jaykKICAgICAgIHJhd19zcGluX2xvY2tfaXJxc2F2ZShjcHVfYmFzZS0+
bG9jaykgIHwgICAgICAgIGZuKHRpbWVyKTsKICAgICBocnRpbWVyX2NhbGxiYWNrX3J1bm5pbmco
KSAgICAgICAgICAgICAgIHwKICAgICAgICAKaHJ0aW1lcl9jYWxsYmFja19ydW5uaW5nKCkgd2ls
bCBiZSByZXR1cm5pbmcgdHJ1ZSBhcyB0aGUgY2FsbGJhY2sgaXMKcnVubmluZyBzb21ld2hlcmUg
ZWxzZS4gVGhpcyBtZWFucyBocnRpbWVyX3RyeV90b19jYW5jZWwoKQp3b3VsZCByZXR1cm4gLTEu
IFRoZXJlZm9yZSBocnRpbWVyX2dyYWJfZXhwaXJ5X2xvY2soKSB3b3VsZApiZSBjYWxsZWQuCgpE
aWQgSSBtaXNzIGFueXRoaW5nPwoKQ2hlZXJzLAoKLS0gCkp1bGllbiBHcmFsbApfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
