Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47357C54FCB
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 15:13:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCA3F2087E
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 15:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xMxdJ4t6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCA3F2087E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 533734B12E;
	Thu, 23 Apr 2020 11:13:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xi-dkEkIEFnn; Thu, 23 Apr 2020 11:13:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE84C4B141;
	Thu, 23 Apr 2020 11:13:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 435A94B12E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 11:13:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d2BVsmxKLQW6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 11:13:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4F374B12C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 11:13:45 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C1BCF206EC;
 Thu, 23 Apr 2020 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587654824;
 bh=DX2ahC5YezPSncDsnW2JuqQxbYmHihTnGnwtYjNnElA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=xMxdJ4t6VRR0LUv9peSzA6nTn+JcxTOEsqUNBLIVGu1o9a2JbOvUHnOweeZ1guQvM
 VG3koraHHJqtQjhbeUKqZS/dhJ0KItx8CvDagUi676kYQyC+o3ZOeTkz0UmY/81wva
 L3SZPPaBrQt5njB/FVDGVAhgmv7qUGnyB045VvH8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRdXr-005nyB-14; Thu, 23 Apr 2020 16:13:43 +0100
MIME-Version: 1.0
Date: Thu, 23 Apr 2020 16:13:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 5/6] KVM: arm64: vgic-v3: Retire all pending LPIs on
 vcpu destroy
In-Reply-To: <b76bf753-caaa-a6ce-9cdc-0fcf05821a56@arm.com>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-6-maz@kernel.org>
 <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
 <c4b89164d79b733bcc38801c9483417d@kernel.org>
 <b76bf753-caaa-a6ce-9cdc-0fcf05821a56@arm.com>
Message-ID: <339204221453ecbf3ef8946f8313ad2c@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, eric.auger@redhat.com, Andre.Przywara@arm.com,
 julien@xen.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
 Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgSmFtZXMsCgpPbiAyMDIwLTA0LTIzIDE1OjM0LCBKYW1lcyBNb3JzZSB3cm90ZToKPiBIaSBn
dXlzLAo+IAo+IE9uIDIzLzA0LzIwMjAgMTM6MDMsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24g
MjAyMC0wNC0yMyAxMjozNSwgSmFtZXMgTW9yc2Ugd3JvdGU6CgpbLi4uXQoKPj4+IFsgMTc0Mi4z
NDgyMTVdIHBhZ2UgZHVtcGVkIGJlY2F1c2U6IGthc2FuOiBiYWQgYWNjZXNzIGRldGVjdGVkCj4g
Cj4+IEkgdGhpbmsgdGhpcyBpcyBzbGlnaHRseSBtb3JlIGNvbmNlcm5pbmcuIFRoZSBpc3N1ZSBp
cyB0aGF0IHdlIGhhdmUKPj4gc3RhcnRlZCBmcmVlaW5nIHBhcnRzIG9mIHRoZSBpbnRlcnJ1cHQg
c3RhdGUgYWxyZWFkeSAod2UgZnJlZSB0aGUKPj4gU1BJcyBlYXJseSBpbiBrdm1fdmdpY19kaXN0
X2Rlc3Ryb3koKSkuCj4gCj4gKEkgdG9vayB0aGlzIHRvIGJlIHNvbWUgd2lsZCBwb2ludGVyIGFj
Y2Vzcy4gUHJldmlvdXNseSBmb3IKPiB1c2UtYWZ0ZXItZnJlZSBJJ3ZlIHNlZW4gaXQKPiBwcmlu
dCB3aGVyZSBpdCB3YXMgYWxsb2NhdGVkIGFuZCB3aGVyZSBpdCB3YXMgZnJlZWQpLgoKVGhpcyBp
cyBpbmRlZWQgd2hhdCBJIG1hbmFnZWQgdG8gdHJpZ2dlciBieSBmb3JjaW5nIGEgcGVuZGluZwpT
UEkgKHRoZSBrdm10b29sIFVBUlQgaW50ZXJydXB0KSBpbiB0aGUgZ3Vlc3QgYW5kIGZvcmNlZnVs
bHkKdGVybWluYXRpbmcgaXQ6CgpbIDM4MDcuMDg0MjM3XSAKPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgMzgwNy4wODY1
MTZdIEJVRzogS0FTQU46IHVzZS1hZnRlci1mcmVlIGluIAp2Z2ljX2ZsdXNoX3BlbmRpbmdfbHBp
cysweDU0LzB4MTk4ClsgMzgwNy4wODgwMjddIFJlYWQgb2Ygc2l6ZSA4IGF0IGFkZHIgZmZmZjAw
MDg1NTE0YTMyOCBieSB0YXNrIAppb2V2ZW50ZmQtd29ya2UvMjMxClsgMzgwNy4wODk3NzFdClsg
MzgwNy4wOTA5MTFdIENQVTogNCBQSUQ6IDIzMSBDb21tOiBpb2V2ZW50ZmQtd29ya2UgTm90IHRh
aW50ZWQgCjUuNy4wLXJjMi0wMDA4Ni1nMjEwMGMwNjZlOWE3OCAjMjAwClsgMzgwNy4wOTI4NjRd
IEhhcmR3YXJlIG5hbWU6IEZWUCBCYXNlIFJldkMgKERUKQpbIDM4MDcuMDk0MDAzXSBDYWxsIHRy
YWNlOgpbIDM4MDcuMDk1MTgwXSAgZHVtcF9iYWNrdHJhY2UrMHgwLzB4MjY4ClsgMzgwNy4wOTY0
NDVdICBzaG93X3N0YWNrKzB4MWMvMHgyOApbIDM4MDcuMDk3OTYxXSAgZHVtcF9zdGFjaysweGU4
LzB4MTQ0ClsgMzgwNy4wOTkzNzRdICBwcmludF9hZGRyZXNzX2Rlc2NyaXB0aW9uLmlzcmEuMTEr
MHg2Yy8weDM1NApbIDM4MDcuMTAxMDAyXSAgX19rYXNhbl9yZXBvcnQrMHgxMTAvMHgxYzgKWyAz
ODA3LjEwMjMzMl0gIGthc2FuX3JlcG9ydCsweDQ4LzB4NjAKWyAzODA3LjEwMzc2OV0gIF9fYXNh
bl9sb2FkOCsweDljLzB4YzAKWyAzODA3LjEwNTExM10gIHZnaWNfZmx1c2hfcGVuZGluZ19scGlz
KzB4NTQvMHgxOTgKWyAzODA3LjEwNzE4N10gIF9fa3ZtX3ZnaWNfZGVzdHJveSsweDEyMC8weDI3
OApbIDM4MDcuMTA4ODE0XSAga3ZtX3ZnaWNfZGVzdHJveSsweDMwLzB4NDgKWyAzODA3LjExMDQ0
M10gIGt2bV9hcmNoX2Rlc3Ryb3lfdm0rMHgyMC8weGE4ClsgMzgwNy4xMTE4NjhdICBrdm1fcHV0
X2t2bSsweDIzNC8weDQ2MApbIDM4MDcuMTEzNjk3XSAga3ZtX3ZtX3JlbGVhc2UrMHgzNC8weDQ4
ClsgMzgwNy4xMTUxNjJdICBfX2ZwdXQrMHgxMDQvMHgyZjgKWyAzODA3LjExNjQ2NF0gIF9fX19m
cHV0KzB4MTQvMHgyMApbIDM4MDcuMTE3OTI5XSAgdGFza193b3JrX3J1bisweGJjLzB4MTg4Clsg
MzgwNy4xMTk0MTldICBkb19leGl0KzB4NTE0LzB4ZmY4ClsgMzgwNy4xMjA4NTldICBkb19ncm91
cF9leGl0KzB4NzgvMHgxMDgKWyAzODA3LjEyMjMyM10gIGdldF9zaWduYWwrMHgxNjQvMHhjYzAK
WyAzODA3LjEyMzk1MV0gIGRvX25vdGlmeV9yZXN1bWUrMHgyNDQvMHg1ZTAKWyAzODA3LjEyNTQx
Nl0gIHdvcmtfcGVuZGluZysweDgvMHgxMApbIDM4MDcuMTI2MzkyXQpbIDM4MDcuMTI2OTY5XSBB
bGxvY2F0ZWQgYnkgdGFzayAyMjk6ClsgMzgwNy4xMjg4MzRdICBzYXZlX3N0YWNrKzB4MjQvMHg1
MApbIDM4MDcuMTMwNDYyXSAgX19rYXNhbl9rbWFsbG9jLmlzcmEuMTArMHhjNC8weGUwClsgMzgw
Ny4xMzIxMzRdICBrYXNhbl9rbWFsbG9jKzB4Yy8weDE4ClsgMzgwNy4xMzM1NTRdICBfX2ttYWxs
b2MrMHgxNzQvMHgyNzAKWyAzODA3LjEzNTE4Ml0gIHZnaWNfaW5pdC5wYXJ0LjIrMHhlMC8weDRm
MApbIDM4MDcuMTM2ODA5XSAgdmdpY19pbml0KzB4NDgvMHg1OApbIDM4MDcuMTM4MDk1XSAgdmdp
Y19zZXRfY29tbW9uX2F0dHIuaXNyYS40KzB4MmZjLzB4Mzg4ClsgMzgwNy4xNDAwODFdICB2Z2lj
X3YzX3NldF9hdHRyKzB4OGMvMHgzNTAKWyAzODA3LjE0MTY5Ml0gIGt2bV9kZXZpY2VfaW9jdGxf
YXR0cisweDEyNC8weDE5MApbIDM4MDcuMTQzMjYwXSAga3ZtX2RldmljZV9pb2N0bCsweGU4LzB4
MTcwClsgMzgwNy4xNDQ5NDddICBrc3lzX2lvY3RsKzB4YjgvMHhmOApbIDM4MDcuMTQ2NTc1XSAg
X19hcm02NF9zeXNfaW9jdGwrMHg0OC8weDYwClsgMzgwNy4xNDgzNjVdICBlbDBfc3ZjX2NvbW1v
bi5jb25zdHByb3AuMSsweGM4LzB4MWM4ClsgMzgwNy4xNTAwMTVdICBkb19lbDBfc3ZjKzB4OTQv
MHhhMApbIDM4MDcuMTUxNjA1XSAgZWwwX3N5bmNfaGFuZGxlcisweDEyMC8weDE5MApbIDM4MDcu
MTUyOTIyXSAgZWwwX3N5bmMrMHgxNDAvMHgxODAKWyAzODA3LjE1Mzg5OV0KWyAzODA3LjE1NDc4
NF0gRnJlZWQgYnkgdGFzayAyMzE6ClsgMzgwNy4xNTYxNzhdICBzYXZlX3N0YWNrKzB4MjQvMHg1
MApbIDM4MDcuMTU3ODA1XSAgX19rYXNhbl9zbGFiX2ZyZWUrMHgxMGMvMHgxODgKWyAzODA3LjE1
OTQzM10gIGthc2FuX3NsYWJfZnJlZSsweDEwLzB4MTgKWyAzODA3LjE2MDg5N10gIGtmcmVlKzB4
ODgvMHgzNTAKWyAzODA3LjE2MjU3MF0gIF9fa3ZtX3ZnaWNfZGVzdHJveSsweDVjLzB4Mjc4Clsg
MzgwNy4xNjQxNTNdICBrdm1fdmdpY19kZXN0cm95KzB4MzAvMHg0OApbIDM4MDcuMTY1NzgwXSAg
a3ZtX2FyY2hfZGVzdHJveV92bSsweDIwLzB4YTgKWyAzODA3LjE2NzQwOF0gIGt2bV9wdXRfa3Zt
KzB4MjM0LzB4NDYwClsgMzgwNy4xNjg2OTFdICBrdm1fdm1fcmVsZWFzZSsweDM0LzB4NDgKWyAz
ODA3LjE3MDI4MV0gIF9fZnB1dCsweDEwNC8weDJmOApbIDM4MDcuMTcxODcwXSAgX19fX2ZwdXQr
MHgxNC8weDIwClsgMzgwNy4xNzMyNjhdICB0YXNrX3dvcmtfcnVuKzB4YmMvMHgxODgKWyAzODA3
LjE3NDczM10gIGRvX2V4aXQrMHg1MTQvMHhmZjgKWyAzODA3LjE3NjI0Ml0gIGRvX2dyb3VwX2V4
aXQrMHg3OC8weDEwOApbIDM4MDcuMTc3NDM0XSAgZ2V0X3NpZ25hbCsweDE2NC8weGNjMApbIDM4
MDcuMTc5Mjg5XSAgZG9fbm90aWZ5X3Jlc3VtZSsweDI0NC8weDVlMApbIDM4MDcuMTgwNzU1XSAg
d29ya19wZW5kaW5nKzB4OC8weDEwClsgMzgwNy4xODE3MzFdClsgMzgwNy4xODI3MDddIFRoZSBi
dWdneSBhZGRyZXNzIGJlbG9uZ3MgdG8gdGhlIG9iamVjdCBhdCAKZmZmZjAwMDg1NTE0YTAwMApb
IDM4MDcuMTgyNzA3XSAgd2hpY2ggYmVsb25ncyB0byB0aGUgY2FjaGUga21hbGxvYy00ayBvZiBz
aXplIDQwOTYKWyAzODA3LjE4NTM4MV0gVGhlIGJ1Z2d5IGFkZHJlc3MgaXMgbG9jYXRlZCA4MDgg
Ynl0ZXMgaW5zaWRlIG9mClsgMzgwNy4xODUzODFdICA0MDk2LWJ5dGUgcmVnaW9uIFtmZmZmMDAw
ODU1MTRhMDAwLCBmZmZmMDAwODU1MTRiMDAwKQpbIDM4MDcuMTg3NTkxXSBUaGUgYnVnZ3kgYWRk
cmVzcyBiZWxvbmdzIHRvIHRoZSBwYWdlOgpbIDM4MDcuMTg5MzgxXSBwYWdlOmZmZmZmZTAwMjEz
NDUyMDAgcmVmY291bnQ6MSBtYXBjb3VudDowIAptYXBwaW5nOjAwMDAwMDAwMDkwYjEwNjggaW5k
ZXg6MHgwIGhlYWQ6ZmZmZmZlMDAyMTM0NTIwMCBvcmRlcjozIApjb21wb3VuZF9tYXBjb3VudDow
IGNvbXBvdW5kX3BpbmNvdW50OjAKWyAzODA3LjE5MjE0OF0gZmxhZ3M6IDB4MmZmZmYwMDAwMDAx
MDIwMChzbGFifGhlYWQpClsgMzgwNy4xOTQxMjNdIHJhdzogMmZmZmYwMDAwMDAxMDIwMCBkZWFk
MDAwMDAwMDAwMTAwIGRlYWQwMDAwMDAwMDAxMjIgCmZmZmYwMDA4NWEwMGYyMDAKWyAzODA3LjE5
NjM3OV0gcmF3OiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwODAwNDAwMDQgMDAwMDAwMDFmZmZm
ZmZmZiAKMDAwMDAwMDAwMDAwMDAwMApbIDM4MDcuMTk4MDk3XSBwYWdlIGR1bXBlZCBiZWNhdXNl
OiBrYXNhbjogYmFkIGFjY2VzcyBkZXRlY3RlZApbIDM4MDcuMTk5Mjg5XQpbIDM4MDcuMjAwMTIz
XSBNZW1vcnkgc3RhdGUgYXJvdW5kIHRoZSBidWdneSBhZGRyZXNzOgpbIDM4MDcuMjAxNzUwXSAg
ZmZmZjAwMDg1NTE0YTIwMDogZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIg
CmZiIGZiIGZiClsgMzgwNy4yMDM3MDRdICBmZmZmMDAwODU1MTRhMjgwOiBmYiBmYiBmYiBmYiBm
YiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiAKZmIgZmIgZmIKWyAzODA3LjIwNTY1N10gPmZmZmYw
MDA4NTUxNGEzMDA6IGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIApmYiBm
YiBmYgpbIDM4MDcuMjA3Mjg1XSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXgpb
IDM4MDcuMjA4ODI2XSAgZmZmZjAwMDg1NTE0YTM4MDogZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIg
ZmIgZmIgZmIgZmIgZmIgCmZiIGZiIGZiClsgMzgwNy4yMTA4MTJdICBmZmZmMDAwODU1MTRhNDAw
OiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiAKZmIgZmIgZmIKWyAzODA3
LjIxMjQwMl0gCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQoKPj4gSWYgYSBTUEkgd2FzIHBlbmRpbmcgb3IgYWN0aXZlIGF0
IHRoaXMgc3RhZ2UgKGkuZS4gcHJlc2VudCBpbiB0aGUKPj4gYXBfbGlzdCksIHdlIGFyZSBnb2lu
ZyB0byBpdGVyYXRlIG92ZXIgbWVtb3J5IHRoYXQgaGFzIGJlZW4gZnJlZWQKPj4gYWxyZWFkeS4g
VGhpcyBpcyBiYWQsIGFuZCB0aGlzIGNhbiBoYXBwZW4gb24gR0lDdjMgYXMgd2VsbC4KPiAKPiAK
Pj4gSSB0aGluayB0aGlzIHNob3VsZCBzb2x2ZSBpdCwgYnV0IEkgbmVlZCB0byB0ZXN0IGl0IG9u
IGEgR0lDdjIgc3lzdGVtOgo+PiAKPj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS92Z2ljL3Zn
aWMtaW5pdC5jIAo+PiBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaW5pdC5jCj4+IGluZGV4IDUz
ZWM5YjlkOWJjNDMuLjMwZGJlYzlmZTBiNGEgMTAwNjQ0Cj4+IC0tLSBhL3ZpcnQva3ZtL2FybS92
Z2ljL3ZnaWMtaW5pdC5jCj4+ICsrKyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaW5pdC5jCj4+
IEBAIC0zNjUsMTAgKzM2NSwxMCBAQCBzdGF0aWMgdm9pZCBfX2t2bV92Z2ljX2Rlc3Ryb3koc3Ry
dWN0IGt2bSAqa3ZtKQo+PiAKPj4gwqDCoMKgwqAgdmdpY19kZWJ1Z19kZXN0cm95KGt2bSk7Cj4+
IAo+PiAtwqDCoMKgIGt2bV92Z2ljX2Rpc3RfZGVzdHJveShrdm0pOwo+PiAtCj4+IMKgwqDCoMKg
IGt2bV9mb3JfZWFjaF92Y3B1KGksIHZjcHUsIGt2bSkKPj4gwqDCoMKgwqDCoMKgwqDCoCBrdm1f
dmdpY192Y3B1X2Rlc3Ryb3kodmNwdSk7Cj4+ICsKPj4gK8KgwqDCoCBrdm1fdmdpY19kaXN0X2Rl
c3Ryb3koa3ZtKTsKPj4gwqB9Cj4+ID4gwqB2b2lkIGt2bV92Z2ljX2Rlc3Ryb3koc3RydWN0IGt2
bSAqa3ZtKQo+IAo+IFRoaXMgd29ya3MgZm9yIG1lIG9uIEp1bm8uCgpJJ3ZlIHZlcmlmaWVkIHRo
YXQgdGhlIGFib3ZlIHNwbGF0IGRpc2FwcGVhcnMgb24gdGhlIEZWUCB0b28uCkknbGwgc3F1YXNo
IHRoZSBmaXggaW4sIGFkZCB5b3VyIFJCICh3aGljaCBJIGFzc3VtZSBzdGFuZHMpCmFuZCBzZW5k
IHRoZSB3aG9sZSB0aGluZyBhcyBhIGxvY2tkb3duIHByZXNlbnQgdG8gUGFvbG8hCgpUaGFua3Ms
CgogICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55
Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
